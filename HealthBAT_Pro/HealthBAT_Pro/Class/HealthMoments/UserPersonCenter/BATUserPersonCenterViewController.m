//
//  BATUserPersonCenterViewController.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/30.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATUserPersonCenterViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "BATHealthCircleTableViewCell.h"
#import "YYText.h"
#import "BATHealthCircleInputBar.h"
#import "BATLoginModel.h"
#import "BATMomentsModel.h"
#import "BATPerson.h"
#import "BATMyFollowViewController.h"
#import "BATMyFansViewController.h"
#import "BATReportViewController.h"

@interface BATUserPersonCenterViewController () <UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,YYTextViewDelegate,BATUserPersonCenterUserInfoViewDelegate>

/**
 *  数据源
 */
@property (nonatomic,strong) NSMutableArray *dataSource;

/**
 *  页码
 */
@property (nonatomic,assign) NSInteger pageIndex;

/**
 *  每页显示条数
 */
@property (nonatomic,assign) NSInteger pageSize;

/**
 *  输入框
 */
@property (nonatomic,strong) BATHealthCircleInputBar *inputBar;

/**
 *  选中要发表评论的行
 */
@property (nonatomic,strong) NSIndexPath *selectCommentIndexPath;

/**
 *  个人信息model
 */
@property (nonatomic,strong) BATPerson *person;

/**
 *  开始时间
 */
@property (nonatomic,strong) NSString *beginTime;

@property (nonatomic,assign) BOOL isCompleteRequest;


@property (nonatomic,strong) BATDefaultView *defaultView;

@end

@implementation BATUserPersonCenterViewController

- (void)dealloc
{
    DDLogWarn(@"%@",self);
    _userPersonCenterView.tableView.delegate = nil;
    _userPersonCenterView.tableView.dataSource = nil;
    _userPersonCenterView.tableView.emptyDataSetSource = nil;
    _userPersonCenterView.tableView.emptyDataSetDelegate = nil;
    _userPersonCenterView.userInfoView.delegate = nil;
    _inputBar.textView.delegate = nil;
}

- (void)loadView
{
    [super loadView];
    
    if (_userPersonCenterView == nil) {
        _userPersonCenterView = [[BATUserPersonCenterView alloc] init];
        _userPersonCenterView.tableView.delegate = self;
        _userPersonCenterView.tableView.dataSource = self;
        _userPersonCenterView.tableView.emptyDataSetSource = self;
        _userPersonCenterView.tableView.emptyDataSetDelegate = self;
        _userPersonCenterView.userInfoView.delegate = self;
        [self.view addSubview:_userPersonCenterView];
        
        WEAK_SELF(self);
        _userPersonCenterView.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.pageIndex = 0;
            [self.userPersonCenterView.tableView.mj_footer resetNoMoreData];
            [self requestUserDynamic];
        }];
        
        _userPersonCenterView.tableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.pageIndex++;
            [self requestUserDynamic];
        }];
        
        _userPersonCenterView.tableView.mj_footer.hidden = YES;
        
        [_userPersonCenterView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.edges.equalTo(self.view);
        }];
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
    
    [_userPersonCenterView addSubview:self.defaultView];
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.top.equalTo(self.view);
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //注册键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self requestUserInfo];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [BATUserPortrayTools saveOperateModuleRequestWithURL:@"/kmStatistical-sync/saveOperateModule" pathName:@"个人中心-我的健康圈" moduleId:4 beginTime:self.beginTime];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.beginTime = [Tools getCurrentDateStringByFormat:@"yyyy-MM-dd HH:mm:ss"];
    [_userPersonCenterView.tableView registerNib:[UINib nibWithNibName:@"BATHealthCircleTableViewCell" bundle:nil] forCellReuseIdentifier:@"BATHealthCircleTableViewCell"];
    
    _dataSource = [NSMutableArray array];
    _pageSize = 10;
    _pageIndex = 0;
    
    [_userPersonCenterView.tableView.mj_header beginRefreshing];
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BATHealthCircleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATHealthCircleTableViewCell" forIndexPath:indexPath];
    if (_dataSource.count > 0) {
        BATMomentData *moment = _dataSource[indexPath.row];
        cell.indexPath = indexPath;
        [cell configrationCell:moment];
        
        WEAK_SELF(self);
        cell.avatarAction = ^(NSIndexPath *cellIndexPath) {
            DDLogWarn(@"头像点击%@",cellIndexPath);
            STRONG_SELF(self);
            //判断是否为当前显示用户个人中心的用户
            if (self.AccountID != moment.AccountID) {
                BATUserPersonCenterViewController *userPersonCenterVC = [[BATUserPersonCenterViewController alloc] init];
                userPersonCenterVC.AccountID = moment.AccountID;
                userPersonCenterVC.AccountType = moment.AccountType;
                userPersonCenterVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:userPersonCenterVC animated:YES];
            }
            
        };
        
        cell.moreAction = ^(NSIndexPath *cellIndexPath) {
            DDLogWarn(@"更多操作点击%@",cellIndexPath);
            STRONG_SELF(self);
            [self moreAction:cellIndexPath];
        };
        
        cell.commentAction = ^(NSIndexPath *cellIndexPath) {
            DDLogWarn(@"评论按钮点击%@",cellIndexPath);
            STRONG_SELF(self);
            self.selectCommentIndexPath = cellIndexPath;
            [self.inputBar.textView becomeFirstResponder];
            
        };
        
        cell.thumbsUpAction = ^(NSIndexPath *cellIndexPath) {
            DDLogWarn(@"点赞按钮点击%@",cellIndexPath);
            STRONG_SELF(self);
            [self requestCancelAndThumpUp:cellIndexPath];
        };
        
        cell.commentTapUserAction = ^(NSIndexPath *commentIndexPath,BATComments *comments) {
            DDLogWarn(@"评论列表中点击了:%@ indexPath %@",comments.UserName,commentIndexPath);
        };
        
        cell.commentReplyAction = ^(NSIndexPath *commentIndexPath,BATComments *comments) {
            DDLogWarn(@"评论列表中点击了 indexPath %@,可对这行进行回复",commentIndexPath);
        };
        
        cell.longTapCommentAction = ^(NSIndexPath *commentIndexPath,BATComments *comments) {
            DDLogWarn(@"评论列表删除 indexPath %@",commentIndexPath);
        };
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
}

#pragma mark - UITouch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - DZNEmptyDataSetSource
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

#pragma mark - BATUserPersonCenterUserInfoViewDelegate
- (void)BATUserPersonCenterUserInfoView:(BATUserPersonCenterUserInfoView *)userPersonCenterUserInfoView followButtonClicked:(UIButton *)button
{
    [self requestFollow];
}

- (void)BATUserPersonCenterUserInfoView:(BATUserPersonCenterUserInfoView *)userPersonCenterUserInfoView consulationButtonClicked:(UIButton *)button
{
    
}

- (void)BATUserPersonCenterUserInfoView:(BATUserPersonCenterUserInfoView *)userPersonCenterUserInfoView followMemberButtonClicked:(UIButton *)button
{
    BATMyFollowViewController *myFollowVC = [[BATMyFollowViewController alloc] init];
    myFollowVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:myFollowVC animated:YES];
}

- (void)BATUserPersonCenterUserInfoView:(BATUserPersonCenterUserInfoView *)userPersonCenterUserInfoView fansMemberButtonClicked:(UIButton *)button
{
    BATMyFansViewController *myFansVC = [[BATMyFansViewController alloc] init];
    myFansVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:myFansVC animated:YES];
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

#pragma mark - 获取个人信息
- (void)requestUserInfo
{
    [HTTPTool requestWithURLString:[NSString stringWithFormat:@"/api/Patient/Info/%ld",(long)_AccountID] parameters:nil type:kGET success:^(id responseObject) {
        
        _person = [BATPerson mj_objectWithKeyValues:responseObject];
        
        [_userPersonCenterView.userInfoView configrationUserInfo:_person];
        
    } failure:^(NSError *error) {
        [self.defaultView showDefaultView];
    }];
}

#pragma mark - 获取用户动态
- (void)requestUserDynamic
{
    
    [HTTPTool requestWithURLString:@"/api/DynamicLoop/GetDynamicLoopsOfMyCommentAndMe"
                        parameters:@{
                                     @"pageIndex":@(_pageIndex),
                                     @"pageSize":@"10",
                                     //                                     @"postType":@(-1),
                                     @"accountId":@(_AccountID)
                                     }
                              type:kGET
                           success:^(id responseObject) {
                               [_userPersonCenterView.tableView.mj_header endRefreshingWithCompletionBlock:^{
                                   self.isCompleteRequest = YES;
                                   [self.userPersonCenterView.tableView reloadData];
                               }];
                               [_userPersonCenterView.tableView.mj_footer endRefreshing];
                               BATMomentsModel * tmpModel = [BATMomentsModel mj_objectWithKeyValues:responseObject];
                               if (tmpModel.ResultCode == 0) {
                                   if (_pageIndex == 0) {
                                       [_dataSource removeAllObjects];
                                   }
                                   
                                   [_dataSource addObjectsFromArray:tmpModel.Data];
                                   
                                   if (tmpModel.RecordsCount > 0) {
                                       _userPersonCenterView.tableView.mj_footer.hidden = NO;
                                   } else {
                                       _userPersonCenterView.tableView.mj_footer.hidden = YES;
                                   }
                                   
                                   if (_dataSource.count == tmpModel.RecordsCount) {
                                       [_userPersonCenterView.tableView.mj_footer endRefreshingWithNoMoreData];
                                   }
                                   [_userPersonCenterView.tableView reloadData];
                               }
                               
                           }
                           failure:^(NSError *error) {
                               [_userPersonCenterView.tableView.mj_header endRefreshingWithCompletionBlock:^{
                                   self.isCompleteRequest = YES;
                                   [self.userPersonCenterView.tableView reloadData];
                               }];
                               [_userPersonCenterView.tableView.mj_footer endRefreshing];
                               _pageIndex --;
                               if (_pageIndex < 0) {
                                   _pageIndex = 0;
                               }
                           }];
    
    //    [HTTPTool requestWithURLString:@"/api/DynamicLoop/GetDynamicLoopsOfMyCommentAndMe"
    //                        parameters:@{
    //                                     @"PageIndex":@(_pageIndex),
    //                                     @"PageSize":@"10",
    //                                     @"CategoryId":@(-1),
    //                                     @"AccountId":@(_AccountID)
    //                                     }
    //                              type:kGET
    //                           success:^(id responseObject) {
    //                               [_userPersonCenterView.tableView.mj_header endRefreshingWithCompletionBlock:^{
    //                                   self.isCompleteRequest = YES;
    //                                   [self.userPersonCenterView.tableView reloadData];
    //                               }];
    //                               [_userPersonCenterView.tableView.mj_footer endRefreshing];
    //                               BATMomentsModel * tmpModel = [BATMomentsModel mj_objectWithKeyValues:responseObject];
    //                               if (tmpModel.ResultCode == 0) {
    //                                   if (_pageIndex == 0) {
    //                                       [_dataSource removeAllObjects];
    //                                   }
    //
    //                                   [_dataSource addObjectsFromArray:tmpModel.Data];
    //
    //                                   if (tmpModel.RecordsCount > 0) {
    //                                       _userPersonCenterView.tableView.mj_footer.hidden = NO;
    //                                   } else {
    //                                       _userPersonCenterView.tableView.mj_footer.hidden = YES;
    //                                   }
    //
    //                                   if (_dataSource.count == tmpModel.RecordsCount) {
    //                                       [_userPersonCenterView.tableView.mj_footer endRefreshingWithNoMoreData];
    //                                   }
    //                                   [_userPersonCenterView.tableView reloadData];
    //                               }
    //
    //                           }
    //                           failure:^(NSError *error) {
    //                               [_userPersonCenterView.tableView.mj_header endRefreshingWithCompletionBlock:^{
    //                                   self.isCompleteRequest = YES;
    //                                   [self.userPersonCenterView.tableView reloadData];
    //                               }];
    //                               [_userPersonCenterView.tableView.mj_footer endRefreshing];
    //                               _pageIndex --;
    //                               if (_pageIndex < 0) {
    //                                   _pageIndex = 0;
    //                               }
    //                           }];
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
        [_userPersonCenterView.tableView reloadData];
        
    } failure:^(NSError *error) {
        [self dismissProgress];
    }];
    
    //    //删除某一行动态 根据BizRecordID字段删除某行动态，仅自己发的
    //
    //    BATMomentData *moment = _dataSource[indexPath.row];
    //
    //    NSString *urlStr = [NSString stringWithFormat:@"/api/DynamicLoop/DeleteDynamicLoops?Id=%ld",(long)moment.BizRecordID];
    //
    //    [self showProgress];
    //
    //    [HTTPTool requestWithURLString:urlStr parameters:nil type:kPOST success:^(id responseObject) {
    //        [self dismissProgress];
    //        [_dataSource removeObjectAtIndex:indexPath.row];
    //        [_userPersonCenterView.tableView reloadData];
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
        
        [_userPersonCenterView.tableView reloadData];
        
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
    //        [_userPersonCenterView.tableView reloadData];
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
    //        [_userPersonCenterView.tableView reloadData];
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
        
        [_userPersonCenterView.tableView reloadData];
        
        
    } failure:^(NSError *error) {
        
    }];
    
    [self.view endEditing:YES];
}

#pragma mark - 关注或取消关注
- (void)requestFollow
{
    [HTTPTool requestWithURLString:@"/api/Account/Focus" parameters:@{@"accountId":@(_person.Data.AccountID),@"isFocus":@(!_person.Data.IsFollowed)} type:kPOST success:^(id responseObject) {
        
        _person.Data.IsFollowed = !_person.Data.IsFollowed;
        
        //关注操作按钮
        if (_person.Data.IsFollowed) {
            [_userPersonCenterView.userInfoView.followButton setTitle:@"已关注" forState:UIControlStateNormal];
            _userPersonCenterView.userInfoView.followButton.backgroundColor = UIColorFromHEX(0xffffff, 0.2);
        } else {
            [_userPersonCenterView.userInfoView.followButton setTitle:@"+ 关注" forState:UIControlStateNormal];
            _userPersonCenterView.userInfoView.followButton.backgroundColor = UIColorFromRGB(250, 140, 32, 1);
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:BATRefreshFollowStateNotification object:@{@"AccountID":@(_person.Data.AccountID),@"IsFollowed":@(_person.Data.IsFollowed)}];
        
//        [[NSNotificationCenter defaultCenter] postNotificationName:BATRefreshFindDataNotification object:nil];

    } failure:^(NSError *error) {
        
    }];
    
    //    NSDictionary *params = @{@"BeFollowedAccountID":@(_person.Data.AccountID), @"IsFollowing":@(!_person.Data.IsFollowed)};
    //
    //    [HTTPTool requestWithURLString:@"/api/Account/Follow" parameters:params type:kPOST success:^(id responseObject) {
    //
    //        _person.Data.IsFollowed = !_person.Data.IsFollowed;
    //
    //        //关注操作按钮
    //        if (_person.Data.IsFollowed) {
    //            [_userPersonCenterView.userInfoView.followButton setTitle:@"已关注" forState:UIControlStateNormal];
    //            _userPersonCenterView.userInfoView.followButton.backgroundColor = UIColorFromHEX(0xffffff, 0.2);
    //        } else {
    //            [_userPersonCenterView.userInfoView.followButton setTitle:@"+ 关注" forState:UIControlStateNormal];
    //            _userPersonCenterView.userInfoView.followButton.backgroundColor = UIColorFromRGB(250, 140, 32, 1);
    //        }
    //        
    //        [[NSNotificationCenter defaultCenter] postNotificationName:BATRefreshFollowStateNotification object:@{@"AccountID":@(_person.Data.AccountID),@"IsFollowed":@(_person.Data.IsFollowed)}];
    //        
    //        [[NSNotificationCenter defaultCenter] postNotificationName:BATRefreshFindDataNotification object:nil];
    //        
    //    } failure:^(NSError *error) {
    //        
    //    }];
}

- (BATDefaultView *)defaultView{
    if (!_defaultView) {
        _defaultView = [[BATDefaultView alloc]initWithFrame:CGRectZero];
        _defaultView.hidden = YES;
        WEAK_SELF(self);
        [_defaultView setReloadRequestBlock:^{
            STRONG_SELF(self);
            DDLogInfo(@"=====重新开始加载！=====");
            self.defaultView.hidden = YES;
            [self requestUserInfo];
            [self requestUserDynamic];
        }];
        
    }
    return _defaultView;
}


@end
