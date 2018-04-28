//
//  MyFocusViewController.m
//  HealthBAT_Pro
//
//  Created by KM on 16/7/212016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATMyFocusBBSController.h"
#import "BATMomentsModel.h"
#import "UIScrollView+EmptyDataSet.h"
#import "MJRefresh.h"
#import "BATHealthCircleTableViewCell.h"
#import "BATLoginModel.h"
#import "BATHealthCircleInputBar.h"
#import "YYText.h"
#import "BATUserPersonCenterViewController.h"
#import "BATReportViewController.h"
#import "BATBBSDetailController.h"
#import "BATSendDynamicViewController.h"

@interface BATMyFocusBBSController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,YYTextViewDelegate>

/**
 *  当前页码
 */
@property (nonatomic,assign) int currentPage;

/**
 *  数据源
 */
@property (nonatomic,strong) NSMutableArray * dataArray;

/**
 *  列表
 */
@property (nonatomic,strong) UITableView * momentListTableView;

/**
 *  输入框
 */
@property (nonatomic,strong) BATHealthCircleInputBar *inputBar;

/**
 *  选中要发表评论的行
 */
@property (nonatomic,strong) NSIndexPath *selectCommentIndexPath;

@property (nonatomic,assign) BOOL isCompleteRequest;

@property (nonatomic,strong) BATDefaultView *defaultView;

@property (nonatomic,assign) BOOL isRefresh;

@end

@implementation BATMyFocusBBSController

- (void)dealloc {
    
   [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.momentListTableView.mj_header beginRefreshing];
    [self pagesLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BATHealthCircleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATHealthCircleTableViewCell" forIndexPath:indexPath];
    if (self.dataArray.count > 0) {
        BATMomentData *moment = self.dataArray[indexPath.row];
        cell.indexPath = indexPath;
        [cell configrationCell:moment];
        if (moment.IsHot == 0) {
            cell.isHotBBS.hidden = YES;
        }else {
            cell.isHotBBS.hidden = NO;
        }
        WEAK_SELF(self);
        cell.avatarAction = ^(NSIndexPath *cellIndexPath) {
            DDLogWarn(@"头像点击%@",cellIndexPath);
            if (!LOGIN_STATION) {
                PRESENT_LOGIN_VC;
            }
            BATUserPersonCenterViewController *userPersonCenterVC = [[BATUserPersonCenterViewController alloc] init];
            userPersonCenterVC.AccountID = moment.AccountID;
            userPersonCenterVC.AccountType = moment.AccountType;
            userPersonCenterVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:userPersonCenterVC animated:YES];
            
        };
        
        cell.moreAction = ^(NSIndexPath *cellIndexPath) {
            DDLogWarn(@"更多操作点击%@",cellIndexPath);
            STRONG_SELF(self);
            [self moreAction:cellIndexPath];
        };
        
        cell.commentAction = ^(NSIndexPath *cellIndexPath) {
            DDLogWarn(@"评论按钮点击%@",cellIndexPath);
        //    STRONG_SELF(self);
//            self.selectCommentIndexPath = cellIndexPath;
//            [self.inputBar.textView becomeFirstResponder];
            BATBBSDetailController *bbsDetailVC = [[BATBBSDetailController alloc]init];
            bbsDetailVC.isScro = YES;
            bbsDetailVC.PostId = [self.dataArray[cellIndexPath.row] PostId];
            [bbsDetailVC setIsRefreshBlock:^(BOOL isReload) {
                self.isRefresh = isReload;
                if (LOGIN_STATION) {
                    if (self.isRefresh) {
                        [self.momentListTableView.mj_header beginRefreshing];
                    }
                }
            }];
            [self.navigationController pushViewController:bbsDetailVC animated:YES];
            NSLog(@"跳转");
            
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
        
        //        cell.collectionImageClickAction = ^(NSInteger index) {
        //            DDLogWarn(@"图片点击 tag %ld",index);
        //
        //        };
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    BATBBSDetailController *detailVC = [[BATBBSDetailController alloc]init];
    detailVC.monentsModel = self.dataArray[indexPath.row];
    [detailVC setIsRefreshBlock:^(BOOL isReload) {
        self.isRefresh = isReload;
        if (LOGIN_STATION) {
            if (self.isRefresh) {
                [self.momentListTableView.mj_header beginRefreshing];
            }
        }
    }];
    [self.navigationController pushViewController:detailVC animated:YES];
}
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
//    return [UIImage imageNamed:@"组-6"];
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
        
        //        [textView setAttributedText:nil];
        return NO;
    }
    return YES;
    
}

#pragma mark - Action

#pragma mark - 通知刷新操作
- (void)refreshDynamicList:(NSNotification *)notification
{
    //主要作用说右上角按钮分类加载不类型数据
    NSDictionary *dic = [notification object];
    self.type = [dic[@"CategoryId"] integerValue];
    [self.momentListTableView.mj_header beginRefreshing];
}

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
        BATMomentData *moment = self.dataArray[indexPath.row];
        
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
    
    BATMomentData *moment = self.dataArray[indexPath.row];
    
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
    
    double duration = [notif.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    NSInteger animation = [notif.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    WEAK_SELF(self);
    [UIView animateWithDuration:duration delay:0.0f options:animation animations:^{
        STRONG_SELF(self);
        //        self.inputBar.transform = CGAffineTransformMakeTranslation(0,  -(keyboardFrame.size.height));
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
    
    WEAK_SELF(self);
    [UIView animateWithDuration:duration delay:0.0f options:animation animations:^{
        STRONG_SELF(self);
        //        self.inputBar.transform = CGAffineTransformIdentity;
        WEAK_SELF(self);
        [self.inputBar mas_updateConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.bottom.equalTo(self.view).offset(50);
        }];
        [self.view layoutIfNeeded];
    } completion:nil];
}


//刷新表格
- (void)ReflashAction {
    
    [self.momentListTableView.mj_header beginRefreshing];
}

#pragma mark - NET

#pragma mark - 获取我的健康圈信息
- (void)attentionRequest {
    
    [HTTPTool requestWithURLString:@"/api/DynamicLoop/DynamicLoopsOfMyFriendsAndMe"
                        parameters:@{
                                     @"pageIndex":@(self.currentPage),
                                     @"pageSize":@"10",
                                     @"postType":@(self.type)
                                     }
                              type:kGET
                           success:^(id responseObject) {
    
        [self.momentListTableView.mj_header endRefreshingWithCompletionBlock:^{
            self.isCompleteRequest = YES;
            [self.momentListTableView reloadData];
        }];
                               
        [self.momentListTableView.mj_footer endRefreshing];
        BATMomentsModel * tmpModel = [BATMomentsModel mj_objectWithKeyValues:responseObject];
        
        
        for (BATMomentData *dataModel in tmpModel.Data) {
            dataModel.IsHideCommon = YES;
        }
        
        if (tmpModel.ResultCode == 0) {
            if (self.currentPage == 0) {
                self.dataArray = [NSMutableArray array];
            }
            
            [self.dataArray addObjectsFromArray:tmpModel.Data];
            
            if (tmpModel.RecordsCount > 0) {
                self.momentListTableView.mj_footer.hidden = NO;
            } else {
                self.momentListTableView.mj_footer.hidden = YES;
            }
            
            if (self.dataArray.count == tmpModel.RecordsCount) {
                [self.momentListTableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.momentListTableView reloadData];
            
            if (self.dataArray.count == 0) {
                [self.defaultView showDefaultView];
            }
        }
        
    } failure:^(NSError *error) {
        
        [self.momentListTableView.mj_header endRefreshingWithCompletionBlock:^{
            self.isCompleteRequest = YES;
            [self.momentListTableView reloadData];
        }];
        [self.momentListTableView.mj_footer endRefreshing];
        self.currentPage --;
        if (self.currentPage < 0) {
            self.currentPage = 0;
        }
        
        [self.defaultView showDefaultView];
        
    }];

   
   }

#pragma mark - 删除动态
- (void)requestDeleteDynamic:(NSIndexPath *)indexPath
{
    //删除某一行动态 根据BizRecordID字段删除某行动态，仅自己发的
    
    BATMomentData *moment = self.dataArray[indexPath.row];
    
    [self showProgress];
    
    [HTTPTool requestWithURLString:@"/api/DynamicLoop/DeleteDynamicLoops" parameters:@{@"id":moment.PostId} type:kGET success:^(id responseObject) {
        [self dismissProgress];
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [self.momentListTableView reloadData];
        
    } failure:^(NSError *error) {
        [self dismissProgress];
    }];
    
    //    //删除某一行动态 根据BizRecordID字段删除某行动态，仅自己发的
    //
    //    BATMomentData *moment = self.dataArray[indexPath.row];
    //
    //    NSString *urlStr = [NSString stringWithFormat:@"/api/DynamicLoop/DeleteDynamicLoops?Id=%ld",(long)moment.BizRecordID];
    //
    //    [self showProgress];
    //
    //    [HTTPTool requestWithURLString:urlStr parameters:nil type:kPOST success:^(id responseObject) {
    //        [self dismissProgress];
    //        [self.dataArray removeObjectAtIndex:indexPath.row];
    //        [self.momentListTableView reloadData];
    //
    //    } failure:^(NSError *error) {
    //        [self dismissProgress];
    //    }];
}

#pragma mark - 对某一行点赞或者取消点赞
- (void)requestCancelAndThumpUp:(NSIndexPath *)indexPath
{
    //点赞某一行动态
    
    if (!LOGIN_STATION) {
        PRESENT_LOGIN_VC
        return;
    }
    
    BATMomentData *moment = self.dataArray[indexPath.row];
    
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
        
        [self.momentListTableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
    

}

#pragma mark - 发表新的评论
- (void)requestSendComment:(NSIndexPath *)indexPath
{

    
    if (self.inputBar.textView.text.length>80) {
        [self showText:@"评论内容不能超过80个字符"];
        return;
    }
    
    BATMomentData *moment = self.dataArray[indexPath.row];
    
    NSDictionary *params = @{@"PostId":moment.PostId, @"ParentId":@"", @"Body":self.inputBar.textView.text};
    
    [HTTPTool requestWithURLString:@"/api/DynamicLoop/AddReply" parameters:params type:kPOST success:^(id responseObject) {
        
        BATComments *comments = [BATComments mj_objectWithKeyValues:[responseObject objectForKey:@"Data"]];
        [moment.Comments addObject:comments];
        
        [self.momentListTableView reloadData];
        
        
    } failure:^(NSError *error) {
        
    }];
    
    [self.view endEditing:YES];
}

#pragma mark - layout
- (void)pagesLayout {
    //    self.view.backgroundColor = UIColorFromHEX(0xefeff4, 1);
    self.title = @"帖子";
    [self.view addSubview:self.momentListTableView];
    [self.view addSubview:self.inputBar];
    WEAK_SELF(self);
    
    [self.momentListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        //        make.top.left.right.equalTo(self.view);
        //        make.bottom.equalTo(self.view.mas_bottom);
        make.edges.equalTo(self.view);
    }];
    
    [self.inputBar mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(50);
        make.height.mas_equalTo(50);
    }];
    
    [self.view addSubview:self.defaultView];
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"icon-bj"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        STRONG_SELF(self);
        if (!LOGIN_STATION) {
            PRESENT_LOGIN_VC;
            return ;
        }
        BATSendDynamicViewController *dynamicVC = [[BATSendDynamicViewController alloc]init];
        dynamicVC.isBBS = YES;
        [self.navigationController pushViewController:dynamicVC animated:YES];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDynamicList:) name:BATRefreshDynamicListNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReflashAction) name:@"SEND_DYNAMIC_SUCCESS" object:nil];
    
    //注册键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}



#pragma mark - setter && getter
- (UITableView *)momentListTableView {
    if (!_momentListTableView) {
        //        _momentListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-30-49) style:UITableViewStylePlain];
        _momentListTableView = [[UITableView alloc] init];
        _momentListTableView.delegate = self;
        _momentListTableView.dataSource = self;
        _momentListTableView.estimatedRowHeight = 250;
        _momentListTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _momentListTableView.rowHeight = UITableViewAutomaticDimension;
        _momentListTableView.tableFooterView = [UIView new];
        _momentListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _momentListTableView.emptyDataSetSource = self;
        _momentListTableView.emptyDataSetDelegate = self;
        _momentListTableView.backgroundColor = [UIColor clearColor];
        //        _momentListTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
        [_momentListTableView registerNib:[UINib nibWithNibName:@"BATHealthCircleTableViewCell" bundle:nil] forCellReuseIdentifier:@"BATHealthCircleTableViewCell"];
        
        WEAK_SELF(self);
        _momentListTableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.currentPage = 0;
            [self.momentListTableView.mj_footer resetNoMoreData];
            [self attentionRequest];
        }];
        _momentListTableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.currentPage ++;
            [self attentionRequest];
        }];
        
        _momentListTableView.mj_footer.hidden = YES;
    }
    return _momentListTableView;
}

- (BATHealthCircleInputBar *)inputBar
{
    if (!_inputBar) {
        _inputBar = [[BATHealthCircleInputBar alloc] init];
        _inputBar.textView.delegate = self;
    }
    return _inputBar;
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
            [self attentionRequest];
        }];
        
    }
    return _defaultView;
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
