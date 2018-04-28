//
//  BATGroupDetailViewController.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/30.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATGroupDetailViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "BATGroupAccouncementModel.h"
#import "BATGroupDetailModel.h"
#import "BATMomentsModel.h"
#import "BATHealthCircleTableViewCell.h"
#import "BATHealthCircleInputBar.h"
#import "YYText.h"
#import "BATLoginModel.h"
#import "BATGroupMemberViewController.h"
#import "BATSendDynamicViewController.h"
#import "BATGroupAccouncementListViewController.h"
#import "BATReportViewController.h"
#import "BATUserPersonCenterViewController.h"

@interface BATGroupDetailViewController () <UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,YYTextViewDelegate,BATGroupAccouncementViewDelegate,BATGroupDecsViewDelegate,BATGroupDynamicOperationViewDelegate>

/**
 *  群组公告model
 */
@property (nonatomic,strong) BATGroupAccouncementModel *groupAccouncementModel;


/**
 *  群组详情model
 */
@property (nonatomic,strong) BATGroupDetailModel *groupDetailModel;

/**
 *  页码
 */
@property (nonatomic,assign) NSInteger pageIndex;

/**
 *  每页显示条数
 */
@property (nonatomic,assign) NSInteger pageSize;

/**
 *  数据源
 */
@property (nonatomic,strong) NSMutableArray *dataSource;

/**
 *  动态获取类型
 */
@property (nonatomic,assign) BATGroupDetailDynamicOpration groupDetailDynamicOpration;

/**
 *  输入框
 */
@property (nonatomic,strong) BATHealthCircleInputBar *inputBar;

/**
 *  选中要发表评论的行
 */
@property (nonatomic,strong) NSIndexPath *selectCommentIndexPath;

/**
 *  发布动态
 */
@property (nonatomic,strong) UIBarButtonItem *sendBarButtonItem;

@property (nonatomic,assign) BOOL isCompleteRequest;

@end

@implementation BATGroupDetailViewController

- (void)dealloc
{
    DDLogWarn(@"%@",self);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _groupDetailView.tableView.delegate = nil;
    _groupDetailView.tableView.dataSource = nil;
    _groupDetailView.tableView.emptyDataSetSource = nil;
    _groupDetailView.tableView.emptyDataSetDelegate = nil;
    _inputBar.textView.delegate = nil;
    _groupDetailView.headerView.groupAccouncementView.delegate = nil;
    _groupDetailView.headerView.groupDecsView.delegate = nil;
    _groupDetailView.headerView.groupDynamicOperationView.delegate = nil;
}

- (void)loadView
{
    [super loadView];
    
    if (_groupDetailView == nil) {
        _groupDetailView = [[BATGroupDetailView alloc] init];
        _groupDetailView.tableView.delegate = self;
        _groupDetailView.tableView.dataSource = self;
        _groupDetailView.tableView.emptyDataSetSource = self;
        _groupDetailView.tableView.emptyDataSetDelegate = self;
        _groupDetailView.headerView.groupAccouncementView.delegate = self;
        _groupDetailView.headerView.groupDecsView.delegate = self;
        _groupDetailView.headerView.groupDynamicOperationView.delegate = self;
        [self.view addSubview:_groupDetailView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyBoard:)];
        [_groupDetailView addGestureRecognizer:tap];
        
        WEAK_SELF(self);
        [_groupDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.edges.equalTo(self.view);
        }];
        
        _groupDetailView.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.pageIndex = 0;
            [self.groupDetailView.tableView.mj_footer resetNoMoreData];
            [self reloadData];
        }];
        
        _groupDetailView.tableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.pageIndex++;
            [self requestGroupDynamic];
        }];
        
        _groupDetailView.tableView.mj_footer.hidden = YES;
    }
    
    if (_inputBar == nil) {
        _inputBar = [[BATHealthCircleInputBar alloc] init];
        _inputBar.textView.delegate = self;
        [self.view addSubview:_inputBar];
        
        WEAK_SELF(self);
        [_inputBar mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view).offset(50);
            make.height.mas_equalTo(50);
        }];
    }
    
    if (_sendBarButtonItem == nil) {
        WEAK_SELF(self);
        _sendBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"icon_group_publish"] style:UIBarButtonItemStyleDone handler:^(id sender) {
            STRONG_SELF(self);
            BATSendDynamicViewController *sendDynamicVC = [[BATSendDynamicViewController alloc] init];
            sendDynamicVC.groupID = self.groupID;
            sendDynamicVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sendDynamicVC animated:YES];
        }];
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //注册键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //群成员页面退出群组，隐藏发布按钮
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshGroupJoinState:) name:BATRefreshGroupJoinStateNotification object:nil];
    
    //刷新公告
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshGroupAccouncement:) name:BATRefreshGroupAccouncementNotification object:nil];
}

- (void)hideKeyBoard:(id)sender{
    [self.view endEditing:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = _groupName;
    
    //发布动态成功回调
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upDataOfDynamic:) name:@"SEND_DYNAMIC_SUCCESS" object:nil];
    
    [_groupDetailView.tableView registerNib:[UINib nibWithNibName:@"BATHealthCircleTableViewCell" bundle:nil] forCellReuseIdentifier:@"BATHealthCircleTableViewCell"];
    
    _dataSource = [NSMutableArray array];
    _pageIndex = 0;
    _pageSize = 10;
    _groupDetailDynamicOpration = BATGroupDetailDynamicOprationAll;
    [_groupDetailView.tableView.mj_header beginRefreshing];
}

- (void)upDataOfDynamic:(NSNotification *)info{
    [self reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BATHealthCircleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATHealthCircleTableViewCell" forIndexPath:indexPath];
    if (_dataSource.count > 0) {
        BATMomentData *moment = _dataSource[indexPath.row];
        cell.indexPath = indexPath;
        [cell configrationCell:moment];
        
        WEAK_SELF(self);
        cell.avatarAction = ^(NSIndexPath *cellIndexPath) {
            DDLogWarn(@"头像点击%@",cellIndexPath);
            STRONG_SELF(self);
            BATUserPersonCenterViewController *userPersonCenterVC = [[BATUserPersonCenterViewController alloc] init];
            userPersonCenterVC.AccountID = moment.AccountID;
            userPersonCenterVC.AccountType = moment.AccountType;
            userPersonCenterVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:userPersonCenterVC animated:YES];
        };
        
        cell.moreAction = ^(NSIndexPath *cellIndexPath) {
            DDLogWarn(@"更多操作点击%@",cellIndexPath);
            STRONG_SELF(self);
            [self.view endEditing:YES];
            [self moreAction:cellIndexPath];
        };
        
        cell.commentAction = ^(NSIndexPath *cellIndexPath) {
            DDLogWarn(@"评论按钮点击%@",cellIndexPath);
            STRONG_SELF(self);
            [self.view endEditing:YES];
            self.selectCommentIndexPath = cellIndexPath;
            [self.inputBar.textView becomeFirstResponder];
            
        };
        
        cell.thumbsUpAction = ^(NSIndexPath *cellIndexPath) {
            DDLogWarn(@"点赞按钮点击%@",cellIndexPath);
            STRONG_SELF(self);
            [self.view endEditing:YES];
            [self requestCancelAndThumpUp:cellIndexPath];
        };
        
        cell.commentTapUserAction = ^(NSIndexPath *commentIndexPath,BATComments *comments) {
            DDLogWarn(@"评论列表中点击了:%@ indexPath %@",comments.UserName,commentIndexPath);
            [self.view endEditing:YES];
        };
        
        cell.commentReplyAction = ^(NSIndexPath *commentIndexPath,BATComments *comments) {
            DDLogWarn(@"评论列表中点击了 indexPath %@,可对这行进行回复",commentIndexPath);
            [self.view endEditing:YES];
        };
        
        cell.longTapCommentAction = ^(NSIndexPath *commentIndexPath,BATComments *comments) {
            DDLogWarn(@"评论列表删除 indexPath %@",commentIndexPath);
            [self.view endEditing:YES];
        };
    }
    return cell;
}

#pragma mark - UITableViewDelegate
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [self.view endEditing:YES];
//}
//
//#pragma mark - DZNEmptyDataSetSource
//- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
//    
//    return -50;
//}
//- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
//    
//    if (!self.isCompleteRequest) {
//        return nil;
//    }
//    
//    return [UIImage imageNamed:@"无数据"];
//}
//
////返回标题文字
//- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
//    NSString *text = @"";
//    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f], NSForegroundColorAttributeName: [UIColor darkGrayColor]};
//    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
//}
//
////返回详情文字
//- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
//    
//    if (!self.isCompleteRequest) {
//        return nil;
//    }
//    
//    NSString *text = BAT_NO_DATA;
//    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
//    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
//    paragraph.alignment = NSTextAlignmentCenter;
//    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:16.0f], NSForegroundColorAttributeName: [UIColor lightGrayColor], NSParagraphStyleAttributeName: paragraph};
//    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
//}

#pragma mark YYTextViewDelegate
- (void)textViewDidChange:(YYTextView *)textView
{
    CGSize sizeThatShouldFitTheContent = [textView sizeThatFits:textView.frame.size];
    CGFloat constant = MAX(50, MIN(sizeThatShouldFitTheContent.height + 10 + 10,100));
    //每次textView的文本改变后 修改chatBar的高度
    [self.inputBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(constant);
    }];
    textView.scrollEnabled = self.inputBar.frame.size.height >= 100;
}

- (BOOL)textViewShouldBeginEditing:(YYTextView *)textView
{
    //解决textView大小不定时 contentOffset不正确的bug
    //固定了textView后可以设置滚动YES
    CGSize sizeThatShouldFitTheContent = [textView sizeThatFits:textView.frame.size];
    //每次textView的文本改变后 修改chatBar的高度
    CGFloat chatBarHeight = MAX(50, MIN(sizeThatShouldFitTheContent.height + 10 + 10,100));
    
    textView.scrollEnabled = chatBarHeight >= 100;
    
    return YES;
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    //实现textView.delegate  实现回车发送,return键发送功能
    if ([@"\n" isEqualToString:text]) {
        
        DDLogWarn(@"发送");
        
        if (textView.text.length > 0) {
            [self requestSendComment:self.selectCommentIndexPath];
        }
        
        
        [self.inputBar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(50);
        }];
        
        [textView setAttributedText:nil];
        return NO;
    }
    return YES;
    
}

#pragma mark - BATGroupAccouncementViewDelegate
- (void)groupAccouncementViewClicked:(BATGroupAccouncementView *)groupAccouncementView
{
    DDLogWarn(@"公告点击");
    
    BATGroupAccouncementListViewController *groupAccouncementListVC = [[BATGroupAccouncementListViewController alloc] init];
    groupAccouncementListVC.groupID = _groupID;
    groupAccouncementListVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:groupAccouncementListVC animated:YES];
}

#pragma mark - BATGroupDecsViewDelegate
- (void)groupDecsView:(BATGroupDecsView *)groupDecsView joinGroupButtonClicked:(UIButton *)button
{
    [self joinGroup];
}

- (void)groupDecsView:(BATGroupDecsView *)groupDecsView groupMemberButtonClicked:(UIButton *)button
{
    BATGroupMemberViewController *groupMemberVC = [[BATGroupMemberViewController alloc] init];
    groupMemberVC.groupID = _groupID;
    groupMemberVC.isJoined = _groupDetailModel.Data.IsJoined;
    groupMemberVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:groupMemberVC animated:YES];
}

#pragma mark - BATGroupDynamicOperationViewDelegate
- (void)groupDynamicOperationView:(BATGroupDynamicOperationView *)groupDynamicOperationView dynamicOprationClicked:(BATGroupDetailDynamicOpration)type
{
    [self.view endEditing:YES];
    [self showProgress];
    _groupDetailDynamicOpration = type;
    _pageIndex = 0;
    [self requestGroupDynamic];
    
}

#pragma mark - Action

#pragma mark - 更多操作 删除，举报
- (void)moreAction:(NSIndexPath *)indexPath
{
    //对自己发的可进行删除操作
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    WEAK_SELF(self);
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        STRONG_SELF(self);
        //删除
        [self requestDeleteDynamic:indexPath];
    }];
    
    UIAlertAction *reportAction = [UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //举报
        STRONG_SELF(self);
        BATMomentData *moment = self.dataSource[indexPath.row];
        
        BATReportViewController *reportVC = [[BATReportViewController alloc] init];
        reportVC.postId = moment.PostId;
        reportVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:reportVC animated:YES];
        
        //        BATReportViewController *reportVC = [[BATReportViewController alloc] init];
        //        reportVC.bizRecordID = moment.BizRecordID;
        //        reportVC.hidesBottomBarWhenPushed = YES;
        //        [self.navigationController pushViewController:reportVC animated:YES];
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    BATMomentData *moment = _dataSource[indexPath.row];
    
    BATLoginModel *loginModel = LOGIN_INFO;
    
    if (moment.AccountID == loginModel.Data.ID) {
        [alertController addAction:deleteAction];
    }
    
    [alertController addAction:reportAction];
    [alertController addAction:cancelAction];
}

#pragma mark - 刷新群组中的加入状态
- (void)refreshGroupJoinState:(NSNotification *)notif
{
    [self requestGroupDetail];
}

#pragma mark - 刷新群组公告
- (void)refreshGroupAccouncement:(NSNotification *)notif
{
    [self requestGroupAnnouncement];
}

#pragma mark - Private
#pragma mark 键盘出现
- (void)keyboardWillShow:(NSNotification *)notif
{
    CGRect keyboardFrame = [notif.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    DDLogDebug(@"keyboardFrame %@,inputBar %@",NSStringFromCGRect(keyboardFrame),_inputBar);
    
    double duration = [notif.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    NSInteger animation = [notif.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    [UIView animateWithDuration:duration delay:0.0f options:animation animations:^{
        //        _inputBar.transform = CGAffineTransformMakeTranslation(0,  -(keyboardFrame.size.height + _inputBar.frame.size.height));
        
        WEAK_SELF(self);
        [self.inputBar mas_updateConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.bottom.equalTo(self.view).offset(-keyboardFrame.size.height);
        }];
        
        [self.view layoutIfNeeded];
        
    } completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)notif
{
    //    CGRect keyboardFrame = [notif.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    self.inputBar.textView.text = @"";
    
    double duration = [notif.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    NSInteger animation = [notif.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    [UIView animateWithDuration:duration delay:0.0f options:animation animations:^{
        //        _inputBar.transform = CGAffineTransformIdentity;
        
        WEAK_SELF(self);
        [self.inputBar mas_updateConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.bottom.equalTo(self.view).offset(50);
        }];
        
        [self.view layoutIfNeeded];
    } completion:nil];
}

#pragma mark - NET

#pragma mark - 刷新数据
- (void)reloadData
{
    [self requestGroupAnnouncement];
    [self requestGroupDetail];
    [self requestGroupDynamic];
}

#pragma mark - 获取群公告
- (void)requestGroupAnnouncement
{
    [HTTPTool requestWithURLString:@"/api/Group/GetNoticeEntity" parameters:@{@"groupId":@(_groupID)} type:kGET success:^(id responseObject) {
        _groupAccouncementModel = [BATGroupAccouncementModel mj_objectWithKeyValues:responseObject];
        
        [_groupDetailView.headerView.groupAccouncementView configrationData:_groupAccouncementModel];
        
        
    } failure:^(NSError *error) {
        [_groupDetailView.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - 获取群组详情信息
- (void)requestGroupDetail
{
    [HTTPTool requestWithURLString:@"/api/group/detail" parameters:@{@"groupId":@(_groupID)} type:kGET success:^(id responseObject) {
        _groupDetailModel = [BATGroupDetailModel mj_objectWithKeyValues:responseObject];
        
        if (_groupDetailModel.Data.IsJoined) {
            self.navigationItem.rightBarButtonItem = _sendBarButtonItem;
        } else {
            self.navigationItem.rightBarButtonItem = nil;
        }
        
        [_groupDetailView.headerView.groupDecsView configrationData:_groupDetailModel];
        
    } failure:^(NSError *error) {
        [_groupDetailView.tableView.mj_header endRefreshing];
        
    }];
}

#pragma mark - 获取群组动态（全部，动态，问题）
- (void)requestGroupDynamic
{
    [HTTPTool requestWithURLString:@"/api/DynamicLoop/GetGroupDynamicLoopList" parameters:@{@"groupId":@(_groupID),@"postType":@(_groupDetailDynamicOpration),@"pageIndex":@(_pageIndex),@"pageSize":@(_pageSize)} type:kGET success:^(id responseObject) {
        
        [self dismissProgress];
        [_groupDetailView.tableView.mj_header endRefreshingWithCompletionBlock:^{
            self.isCompleteRequest = YES;
            [self.groupDetailView.tableView reloadData];
        }];
        [_groupDetailView.tableView.mj_footer endRefreshing];
        
        
        BATMomentsModel * tmpModel = [BATMomentsModel mj_objectWithKeyValues:responseObject];
        if (tmpModel.ResultCode == 0) {
            if (_pageIndex == 0) {
                [_dataSource removeAllObjects];
            }
            
            [_dataSource addObjectsFromArray:tmpModel.Data];
            
            if (tmpModel.RecordsCount > 0) {
                _groupDetailView.tableView.mj_footer.hidden = NO;
            } else {
                _groupDetailView.tableView.mj_footer.hidden = YES;
            }
            
            if (_dataSource.count == tmpModel.RecordsCount) {
                [_groupDetailView.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [_groupDetailView.tableView reloadData];
        }
        
    } failure:^(NSError *error) {
        [self dismissProgress];
        [_groupDetailView.tableView.mj_header endRefreshingWithCompletionBlock:^{
            self.isCompleteRequest = YES;
            [self.groupDetailView.tableView reloadData];
        }];
        [_groupDetailView.tableView.mj_footer endRefreshing];
        _pageIndex --;
        if (_pageIndex < 0) {
            _pageIndex = 0;
        }
    }];
}

#pragma mark - 删除动态
- (void)requestDeleteDynamic:(NSIndexPath *)indexPath
{
    //删除某一行动态 根据BizRecordID字段删除某行动态，仅自己发的
    
    BATMomentData *moment = _dataSource[indexPath.row];
    
    [self showProgress];
    
    [HTTPTool requestWithURLString:@"/api/DynamicLoop/DeleteDynamicLoops" parameters:@{@"id":moment.PostId} type:kGET success:^(id responseObject) {
        [self dismissProgress];
        [_dataSource removeObjectAtIndex:indexPath.row];
        [_groupDetailView.tableView reloadData];
        
    } failure:^(NSError *error) {
        [self dismissProgress];
    }];
    
    //    BATMomentData *moment = _dataSource[indexPath.row];
    //
    //    NSString *urlStr = [NSString stringWithFormat:@"/api/DynamicLoop/DeleteDynamicLoops?Id=%ld",(long)moment.BizRecordID];
    //
    //    [self showProgress];
    //
    //    [HTTPTool requestWithURLString:urlStr parameters:nil type:kPOST success:^(id responseObject) {
    //        [self dismissProgress];
    //        [_dataSource removeObjectAtIndex:indexPath.row];
    //        [_groupDetailView.tableView reloadData];
    //
    //    } failure:^(NSError *error) {
    //        [self dismissProgress];
    //    }];
}

#pragma mark - 对某一行点赞或者取消点赞
- (void)requestCancelAndThumpUp:(NSIndexPath *)indexPath
{
    
    //点赞某一行动态
    
    BATMomentData *moment = _dataSource[indexPath.row];
    
    NSDictionary *params = @{@"OBJ_TYPE":@(kBATCollectionLinkTypeCare), @"OBJ_ID":moment.PostId};
    
    [HTTPTool requestWithURLString:(!moment.MarkHelpful ? @"/api/CollectLink/AddCollectLink" : @"/api/CollectLink/CanelCollectLink") parameters:params type:kPOST success:^(id responseObject) {
        
        if (!moment.MarkHelpful) {
            moment.MarkHelpful = YES;
            moment.MarkHelpfulCount++;
        } else {
            moment.MarkHelpful = NO;
            moment.MarkHelpfulCount--;
            
            if (moment.MarkHelpfulCount < 0) {
                moment.MarkHelpfulCount = 0;
            }
        }
        
        [_groupDetailView.tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
    
    //    //点赞某一行动态
    //
    //    BATMomentData *moment = _dataSource[indexPath.row];
    //
    //    NSDictionary *params = @{@"BizRecordID":@(moment.BizRecordID), @"BizRecordType":@"KM.PatientsLikeMe.Domain.T_USER_DYNAMICLOOP", @"IsHelpful":@(!moment.MarkHelpful)};
    //
    //    [HTTPTool requestWithURLString:@"/api/SetHelpful" parameters:params type:kPOST success:^(id responseObject) {
    //
    //        if (!moment.MarkHelpful) {
    //            moment.MarkHelpful = YES;
    //            moment.MarkHelpfulCount++;
    //        } else {
    //            moment.MarkHelpful = NO;
    //            moment.MarkHelpfulCount--;
    //
    //            if (moment.MarkHelpfulCount < 0) {
    //                moment.MarkHelpfulCount = 0;
    //            }
    //        }
    //
    //        [_groupDetailView.tableView reloadData];
    //
    //    } failure:^(NSError *error) {
    //
    //    }];
}

#pragma mark - 发表新的评论
- (void)requestSendComment:(NSIndexPath *)indexPath
{
    
    //    BATMomentData *moment = _dataSource[indexPath.row];
    //
    //    NSDictionary *params = @{@"MyUpdateID":@(moment.MyUpdateID), @"BizRecordID":@(moment.BizRecordID), @"BizRecordType":@"KM.PatientsLikeMe.Domain.T_USER_MYCOMMENT", @"CommentContent":self.inputBar.textView.text, @"MyCommentMentionedAccounts":@[], @"MyCommentAttachments":@[]};
    //
    //    [HTTPTool requestWithURLString:@"/api/Patient/Comment" parameters:params type:kPOST success:^(id responseObject) {
    //
    //        BATComments *comments = [BATComments mj_objectWithKeyValues:[responseObject objectForKey:@"Data"]];
    //        [moment.Comments addObject:comments];
    //
    //        [_groupDetailView.tableView reloadData];
    //
    //
    //    } failure:^(NSError *error) {
    //
    //    }];
    
    BATMomentData *moment = _dataSource[indexPath.row];
    
    NSDictionary *params = @{@"PostId":moment.PostId, @"ParentId":@"", @"Body":self.inputBar.textView.text};
    
    [HTTPTool requestWithURLString:@"/api/DynamicLoop/AddReply" parameters:params type:kPOST success:^(id responseObject) {
        
        BATComments *comments = [BATComments mj_objectWithKeyValues:[responseObject objectForKey:@"Data"]];
        [moment.Comments addObject:comments];
        
        [_groupDetailView.tableView reloadData];
        
        
    } failure:^(NSError *error) {
        
    }];
    
    [self.view endEditing:YES];
}

#pragma mark - 加入群组
- (void)joinGroup
{
    [self.view endEditing:YES];
    
    [HTTPTool requestWithURLString:@"/api/Group/Join" parameters:@{@"id":@(_groupID)} type:kGET success:^(id responseObject) {
        
        [self requestGroupDetail];
        
        [self showText:@"已加入该群组"];
        
        self.navigationItem.rightBarButtonItem = _sendBarButtonItem;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:BATRefreshGroupListNotification object:nil];
        
//        [[NSNotificationCenter defaultCenter] postNotificationName:BATRefreshFindDataNotification object:nil];
        
    } failure:^(NSError *error) {
        
    }];
    
}


@end
