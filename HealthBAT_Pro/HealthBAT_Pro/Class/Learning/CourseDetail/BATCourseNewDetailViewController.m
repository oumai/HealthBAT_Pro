//  BATCourseNewDetailViewController.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/2/23.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATCourseNewDetailViewController.h"
#import "BATCourseDetailAuthorCell.h"
#import "BATCourseDetailVideoCell.h"
#import "BATCourseDetailModel.h"
#import "BATCourseDetailCell.h"
#import "BATTestingTipsCell.h"
#import "BATHeaderViewCollectionViewCell.h"
#import "BATShareCommentCollectionViewCell.h"
#import "BATCourseCommentCountCell.h"
#import "BATCourseCommentModel.h"
#import "BATCourseCommentTableViewCell.h"
#import "BATSendCommentView.h"
#import "BATHealthFollowTestViewController.h"
//#import "BATUserPersonCenterViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "BATTopicPersonController.h"

#import "BATPersonDetailController.h"
@interface BATCourseNewDetailViewController () <UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate,YYTextViewDelegate>

@property (nonatomic,strong) BATCourseDetailModel *courseDetailModel;

//分享相关View
@property (nonatomic,strong) UIView *bigMaskBGView;
@property (nonatomic,strong) UIView *clearMaskView;
@property (nonatomic,strong) UICollectionView *tvCollectionView;
@property (nonatomic,strong) NSArray *shareIconArray;
@property (nonatomic,assign) BOOL isSinaShare;

//是否折叠
@property (nonatomic,assign) BOOL isFold;
//是否收藏
@property (nonatomic,assign) BOOL isCollection;

//评论相关
@property (nonatomic,assign) NSInteger pageIndex;
@property (nonatomic,assign) NSInteger pageSize;
@property (nonatomic,strong) NSMutableArray *dataSource;

//输入框
@property (nonatomic,strong) BATSendCommentView *sendCommentView;

@property (nonatomic,strong) BATDefaultView *defaultView;

/**
 记录评论parentId
 */
@property (nonatomic,assign) NSInteger parentId;

/**
 记录评论parentLevelId
 */
@property (nonatomic,assign) NSInteger parentLevelId;

@property (nonatomic,assign) NSInteger resultCount;



@end

@implementation BATCourseNewDetailViewController

- (void)dealloc
{
    DDLogDebug(@"%s",__func__);
    self.bigMaskBGView = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadView
{
    [super loadView];
    
    [self pageLayout];
    
    self.title = @"健康关注";
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_courseDetailModel) {
        [self.courseNewDetailView.tableHeaderView.playerView pause];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BATChangeReadNumNotification" object:@{@"category":@(_courseDetailModel.Data.Category),@"courseID":@(_courseID),@"ReadingNum":@(_courseDetailModel.Data.ReadingNum)}];
        
    }
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
    
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self.courseNewDetailView.tableView registerClass:[BATCourseDetailAuthorCell class] forCellReuseIdentifier:@"BATCourseDetailAuthorCell"];
    [self.courseNewDetailView.tableView registerClass:[BATCourseDetailVideoCell class] forCellReuseIdentifier:@"BATCourseDetailVideoCell"];
    [self.courseNewDetailView.tableView registerClass:[BATCourseDetailCell class] forCellReuseIdentifier:@"BATCourseDetailCell"];
    [self.courseNewDetailView.tableView registerClass:[BATCourseCommentCountCell class] forCellReuseIdentifier:@"BATCourseCommentCountCell"];
    [self.courseNewDetailView.tableView registerClass:[BATCourseCommentTableViewCell class] forCellReuseIdentifier:@"BATCourseCommentTableViewCell"];
    [self.courseNewDetailView.tableView registerClass:[BATTestingTipsCell class] forCellReuseIdentifier:@"BATTestingTipsCell"];
    
    [self requestGetCourseDetail];
    
    if (LOGIN_STATION) {
        [self isCollectionInfoRequest];
    }
    
    _pageSize = 10;
    _pageIndex = 0;
    _parentId = 0;
    
    _dataSource = [NSMutableArray array];
    
    [self courseCommentListRequest];
    
    self.isSinaShare = NO;
    self.shareIconArray = @[
                            @{@"icon":@"icon-weixin",@"name":@"微信"},
                            @{@"icon":@"icon-pyquan",@"name":@"朋友圈"},
                            @{@"icon":@"icon-qq",@"name":@"QQ"},
                            @{@"icon":@"icon-qqzone",@"name":@"QQ空间"},
                            @{@"icon":@"icon-weibo",@"name":@"微博"},];
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

// 返回值要必须为NO
- (BOOL)shouldAutorotate
{
    return NO;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2 + _dataSource.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    if (indexPath.row == 0) {
    //        return 69;
    //    } else if (indexPath.row == 1) {
    //        return 200;
    //    } else
    if (indexPath.row == 2) {
        return 44;
    }
    if (indexPath.row == 1) {
        if (_courseDetailModel) {
            if (_courseDetailModel.Data.IsTestTemplate) {
                return UITableViewAutomaticDimension;
            }else {
                return 0;
            }
        }else {
            return 0;
        }
    }
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 250;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    if (indexPath.row == 0) {
    //        BATCourseDetailAuthorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATCourseDetailAuthorCell" forIndexPath:indexPath];
    //        if (_courseDetailModel) {
    //            [cell configData:_courseDetailModel];
    //            WEAK_SELF(self);
    //            cell.followAction = ^(){z
    //                STRONG_SELF(self);
    //                [self requestFollow];
    //            };
    //        }
    //        return cell;
    //    } else if (indexPath.row == 1) {
    //        BATCourseDetailVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATCourseDetailVideoCell" forIndexPath:indexPath];
    //        if (_courseDetailModel) {
    //            [cell configData:_courseDetailModel];
    //        }
    //        return cell;
    //    } else
    if (indexPath.row == 0) {
        BATCourseDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"BATCourseDetailCell" forIndexPath:indexPath];
        
        if (_courseDetailModel) {
            cell.isFold = self.isFold;
            [cell configData:_courseDetailModel];
            cell.collectButton.selected = _isCollection;
            
            WEAK_SELF(self);
            cell.collectionAction = ^(){
                STRONG_SELF(self);
                //收藏
                
                if (!LOGIN_STATION) {
                    PRESENT_LOGIN_VC;
                    return;
                }
                
                if (self.isCollection) {
                    [self cancleCollection];
                }else{
                    [self addCollection];
                }
            };
            
            cell.shareAction = ^(){
                //分享
                STRONG_SELF(self);
                self.bigMaskBGView.hidden = NO;
            };
            
            cell.foldAction = ^(){
                //展开收起
                STRONG_SELF(self);
                self.isFold = !self.isFold;
                [self.courseNewDetailView.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            };
        }
        
        return cell;
    } else if (indexPath.row == 1) {
        BATTestingTipsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATTestingTipsCell" forIndexPath:indexPath];
        if (_courseDetailModel) {
            cell.contentLb.text = _courseDetailModel.Data.Theme;
        }
        return cell;
    }else if (indexPath.row == 2) {
        BATCourseCommentCountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATCourseCommentCountCell" forIndexPath:indexPath];
        cell.countLabel.text = [NSString stringWithFormat:@"(%ld)",(unsigned long)self.resultCount];
        return cell;
    } else {
        BATCourseCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATCourseCommentTableViewCell" forIndexPath:indexPath];
        
        if (_dataSource.count > 0) {
            cell.indexPath = indexPath;
            [cell configData:_dataSource[indexPath.row - 3]];
            
            WEAK_SELF(self);
            cell.likeAction = ^(NSIndexPath *cellIndexPath) {
                //点赞
                STRONG_SELF(self);
                if (!LOGIN_STATION) {
                    PRESENT_LOGIN_VC;
                    return;
                }
                [self requestCancelAndLike:cellIndexPath];
            };
            
            cell.commentAction = ^(NSIndexPath *cellIndexPath) {
                
                //对评论进行评论
                STRONG_SELF(self);
                if (!LOGIN_STATION) {
                    PRESENT_LOGIN_VC;
                    return;
                }
               
                BATCourseDetailData *data = self.dataSource[cellIndexPath.row - 3];
                BATCourseCommentData *commentModel = self.dataSource[indexPath.row-3];
                self.parentId = data.ID;
                self.parentLevelId = data.ID;
                self.isSinaShare = NO;
                
                self.sendCommentView.commentTextView.placeholderText = [NSString stringWithFormat:@"回复%@ ",commentModel.AccountName];
                [self.sendCommentView.commentTextView becomeFirstResponder];
                
            };
            
            cell.replyTableView.replyCommentAction = ^(NSIndexPath *commentIndexPath,BATCourseCommentData *comment,NSInteger parentLevelId) {
                //回复评论
                STRONG_SELF(self);
                
                if (!LOGIN_STATION) {
                    PRESENT_LOGIN_VC;
                    return;
                }
                
                self.parentId = comment.ID;
                self.parentLevelId = parentLevelId;
                self.isSinaShare = NO;
                self.sendCommentView.commentTextView.placeholderText = [NSString stringWithFormat:@"回复%@ ",comment.AccountName];
                [self.sendCommentView.commentTextView becomeFirstResponder];
            };
            
        }
        return cell;
    }
    return nil;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        if (_courseDetailModel.Data.IsTestTemplate) {
             [self goToTestVC];
        }
       
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0 || section == 2) {
        return 1;
    }else{
        return self.shareIconArray.count;
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 || indexPath.section == 2) {
        
        BATHeaderViewCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HeaderCell" forIndexPath:indexPath];
        if (indexPath.section == 0) {
            cell.titleLabel.text = @"分享到";
            cell.backgroundColor = [UIColor clearColor];
        }else{
            cell.titleLabel.text = @"取消";
            cell.backgroundColor = [UIColor whiteColor];
        }
        return cell;
    }else{
        BATShareCommentCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ShareCell" forIndexPath:indexPath];
        NSDictionary * dic = self.shareIconArray[indexPath.row];
        cell.nameLabel.text = dic[@"name"];
        cell.iconImageV.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",dic[@"icon"]]];
        return cell;
    }
    
}

//上下间距 每个section items上下行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.25;
}
//行间距 每个section items 左右行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.25;
}

//每个item 的视图的宽高  只有宽高，没有frame
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || indexPath.section == 2) {
        CGSize size = CGSizeMake(SCREEN_WIDTH, 50);
        return size;
    }else{
        CGSize size = CGSizeMake((SCREEN_WIDTH-20-0.75)/4.0, (SCREEN_WIDTH-20-0.75)/4.0 + 35);
        return size;
    }
    
}

//设置section的偏移量
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 0 || section == 2) {
        return UIEdgeInsetsMake(0,0,0,0);
    }else{
        return UIEdgeInsetsMake(0,10,0,10);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *shareText = [NSString stringWithFormat:@"%@|%@-健康BAT",_courseDetailModel.Data.Topic,_courseDetailModel.Data.TeacherName];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/App/VideoCourse?id=%ld&token=%@",APP_WEB_DOMAIN_URL,(long)self.courseID,LOCAL_TOKEN]];
    NSString *shareURL = [NSString stringWithFormat:@"%@&%@",url,@"share=1"];
    DDLogDebug(@"shareURL === %@",shareURL);
    
    //先构造分享参数：
    OSMessage *msg=[[OSMessage alloc]init];
    msg.title = shareText;
    msg.desc = shareText;
    msg.image = [UIImage imageNamed:@"Icon-Share"];
    msg.link = shareURL;
    msg.multimediaType = OSMultimediaTypeNews;
    

    if (indexPath.section == 0) {
        // 点击分享到
    }else{
        //点击取消和按钮上
        self.bigMaskBGView.hidden = YES;
        if (indexPath.section == 1) {
           
            if (indexPath.row == 0) {
                //微信分享
                
                [OpenShare shareToWeixinSession:msg Success:^(OSMessage *message) {
                    [self showSuccessWithText:@"分享成功"];
                    
                } Fail:^(OSMessage *message, NSError *error) {
                    [self showErrorWithText:@"分享失败"];
                    
                }];
            }else if(indexPath.row == 1){
                //朋友圈分享
                [OpenShare shareToWeixinTimeline:msg Success:^(OSMessage *message) {
                    [self showSuccessWithText:@"分享成功"];
                    
                } Fail:^(OSMessage *message, NSError *error) {
                    [self showErrorWithText:@"分享失败"];
                    
                }];
            }else if(indexPath.row == 2){
                //QQ分享
                [OpenShare shareToQQFriends:msg Success:^(OSMessage *message) {
                    [self showSuccessWithText:@"分享成功"];
                    
                } Fail:^(OSMessage *message, NSError *error) {
                    [self showErrorWithText:@"分享失败"];
                    
                }];
            }else if(indexPath.row == 3){
                //QQ空间分享
                [OpenShare shareToQQZone:msg Success:^(OSMessage *message) {
                    [self showSuccessWithText:@"分享成功"];
                    
                } Fail:^(OSMessage *message, NSError *error) {
                    [self showErrorWithText:@"分享失败"];
                    
                }];
                
            }else if(indexPath.row == 4){
                //微博分享
                [OpenShare shareToWeibo:msg Success:^(OSMessage *message) {
                    
                    [self showSuccessWithText:@"分享成功"];
                } Fail:^(OSMessage *message, NSError *error) {
                    
                    [self showErrorWithText:@"分享失败"];
                }];
            }
        }
    }
}


#pragma mark - YYTextViewDelegate
- (void)textViewDidChange:(YYTextView *)textView {
    
    if (textView.text.length > 0) {
        self.sendCommentView.sendCommentButton.enabled = YES;
        self.sendCommentView.sendCommentButton.backgroundColor = BASE_COLOR;
    }
    if (textView.text.length == 0) {
        self.sendCommentView.sendCommentButton.enabled = NO;
        self.sendCommentView.sendCommentButton.backgroundColor = [UIColor lightGrayColor];
    }
}

#pragma mark - Action


- (void)keyboardWillShow:(NSNotification *)notif {
    
    if (!self.isSinaShare) {
        CGRect keyboardFrame = [notif.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        
        double duration = [notif.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        NSInteger animation = [notif.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
        
        [UIView animateWithDuration:duration delay:0.0f options:animation animations:^{
            
            self.sendCommentView.transform = CGAffineTransformMake(1, 0, 0, 1, 0, -keyboardFrame.size.height-self.sendCommentView.bounds.size.height);
            
        } completion:nil];
    }
}

- (void)keyboardWillHide:(NSNotification *)notif {
    self.parentId = 0;
    self.parentLevelId = 0;
    if (!self.isSinaShare) {
        double duration = [notif.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        NSInteger animation = [notif.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
        
        [UIView animateWithDuration:duration delay:0.0f options:animation animations:^{
            self.sendCommentView.transform = CGAffineTransformIdentity;
            
        } completion:nil];
    }
}

- (void)goToTestVC
{
    BATHealthFollowTestViewController *healthFollowTestVC = [[BATHealthFollowTestViewController alloc] init];
    healthFollowTestVC.title = self.courseDetailModel.Data.Theme;
    healthFollowTestVC.courseID = self.courseID;
    healthFollowTestVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:healthFollowTestVC animated:YES];
}

- (void)goToBack
{
    if(self.isPushFromHome == YES){
        // 先回首页，跳到关注，在刷界面
        
        [self bk_performBlock:^(id obj) {
            
            [self.navigationController popToRootViewControllerAnimated:NO];
        } afterDelay:0.5];
        
        
        DDLogInfo(@"传入的type === %ld",(long)self.courseType);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Health_Attion_Pop_More" object:@(self.courseType)];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//隐藏分享界面
- (void)hideShareAllView
{
    self.bigMaskBGView.hidden = YES;
}

- (void)checkNetwork
{
    NetworkStatus netStatus = [HTTPTool currentNetStatus];
    switch (netStatus) {
        case NotReachable:
            DDLogDebug(@"无网络");
            break;
        case ReachableViaWiFi:
            DDLogDebug(@"wifi网络");
            
            break;
        case ReachableViaWWAN: {
            DDLogDebug(@"移动网络");
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"网络提醒" message:@"使用2G、3G\4G网络观看视频会消耗较多流量，确认开启吗？" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alert addAction:cancelAction];
            [alert addAction:confirmAction];
            
            
            [self presentViewController:alert animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
    
}


#pragma mark - Net
#pragma mark - 获取课程详细
- (void)requestGetCourseDetail
{
    [HTTPTool requestWithURLString:[NSString stringWithFormat:@"/api/trainingteacher/course/%ld",(long)self.courseID] parameters:nil type:kGET success:^(id responseObject) {
        
        _courseDetailModel = [BATCourseDetailModel mj_objectWithKeyValues:responseObject];
        
        [self.courseNewDetailView.tableHeaderView configData:_courseDetailModel];
        
        [self.courseNewDetailView.tableView reloadData];
        
    } failure:^(NSError *error) {
        [self.defaultView showDefaultView];
    }];
}

#pragma mark - 关注或取消关注
- (void)requestFollow
{
    
    if (!_courseDetailModel.Data.IsFocus) {
        [HTTPTool requestWithURLString:@"/api/Account/Focus" parameters:@{@"accountId":@(_courseDetailModel.Data.AccountID),@"isFocus":@(!_courseDetailModel.Data.IsFocus)} type:kPOST success:^(id responseObject) {
            
            _courseDetailModel.Data.IsFocus = !_courseDetailModel.Data.IsFocus;
            
            _courseNewDetailView.tableHeaderView.followButton.hidden = _courseDetailModel.Data.IsFocus;
            
            _courseNewDetailView.tableHeaderView.followButton.layer.borderColor = !_courseDetailModel.Data.IsFocus ? UIColorFromHEX(0xfc9f26, 1).CGColor : [UIColor clearColor].CGColor;
            
            
        } failure:^(NSError *error) {
            
        }];
    }
    
    
}

#pragma mark - 收藏资讯
-(void)addCollection
{
    
    [HTTPTool requestWithURLString:@"/api/CollectLink/AddCollectLink" parameters:@{@"OBJ_ID":@(self.courseID),@"OBJ_TYPE":@(kBATCollectionLinkTypeCourse)} type:kPOST success:^(id responseObject) {
        [self showSuccessWithText:@"收藏成功"];
        _isCollection = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:BATRefreshIndexPathModelNotification object:@{@"courseID":@(self.courseID),@"isCollection":@(YES),@"commentState":@(NO),@"isRead":@(NO)}];
        
        [self.courseNewDetailView.tableView reloadData];
    } failure:^(NSError *error) {
        [self showErrorWithText:@"收藏失败"];
    }];
}
#pragma mark - 取消收藏资讯
-(void)cancleCollection
{
    
    [HTTPTool requestWithURLString:@"/api/CollectLink/CanelCollectLink" parameters:@{@"OBJ_ID":@(self.courseID),@"OBJ_TYPE":@(kBATCollectionLinkTypeCourse)} type:kPOST success:^(id responseObject) {
        [self showSuccessWithText:@"取消收藏成功"];
        _isCollection = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:BATRefreshIndexPathModelNotification object:@{@"courseID":@(self.courseID),@"isCollection":@(NO),@"commentState":@(NO),@"isRead":@(NO)}];
        
        [self.courseNewDetailView.tableView reloadData];
    } failure:^(NSError *error) {
        [self showErrorWithText:@"取消收藏失败"];
    }];
}

#pragma mark - 判断是否收藏
- (void)isCollectionInfoRequest
{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@(kBATCollectionLinkTypeCourse) forKey:@"RelationType"];
    [dict setValue:@(self.courseID) forKey:@"RelationId"];
    [HTTPTool requestWithURLString:@"/api/CollectLink/IsCollectLink" parameters:dict type:kGET success:^(id responseObject) {
        NSString *isCollectionString = [NSString stringWithFormat:@"%@",responseObject[@"Data"][@"IsCollectLink"]];
        if ([isCollectionString isEqualToString:@"0"]) {
            _isCollection = NO;
            
        }else {
            _isCollection = YES;
        }
        
        [self.courseNewDetailView.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 发评论
- (void)sendCommentRequest:(NSInteger)parentId parentLevelId:(NSInteger)parentLevelId {
    
    if (!LOGIN_STATION) {
        PRESENT_LOGIN_VC;
        return;
    }
    
    if (self.sendCommentView.commentTextView.text.length > 1000) {
        [self showErrorWithText:@"最多输入1000字"];
        return;
    }
    
    if ([[self.sendCommentView.commentTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        [self showErrorWithText:@"请输入评论内容"];
        return;
    }
    
    [HTTPTool requestWithURLString:@"/api/trainingteacher/course/reply"
                        parameters:@{
                                     @"CourseID":@(self.courseID),
                                     @"Body":self.sendCommentView.commentTextView.text,
                                     @"ParentId":@(parentId),
                                     @"ParentLevelId":@(parentLevelId)
                                     }
                              type:kPOST
                           success:^(id responseObject) {
                               
                               [[NSNotificationCenter defaultCenter] postNotificationName:BATRefreshIndexPathModelNotification object:@{@"courseID":@(self.courseID),@"isCollection":@(YES),@"commentState":@(YES),@"isRead":@(NO)}];
                               
                               [self showSuccessWithText:@"评论成功"];
                               self.sendCommentView.commentTextView.text = nil;
                               [self.sendCommentView.commentTextView resignFirstResponder];
                               self.sendCommentView.commentTextView.placeholderText = nil;
                               
                               //重新获取评论
                               _pageIndex = 0;
                               [self courseCommentListRequest];
                           }
                           failure:^(NSError *error) {
                               
                               [self showErrorWithText:error.localizedDescription];
                           }];
}

#pragma mark - 获取评论
- (void)courseCommentListRequest {
    
    [HTTPTool requestWithURLString:@"/api/trainingteacher/course/replylist"
                        parameters:@{
                                     @"courseID":@(self.courseID),
                                     @"pageIndex":@(_pageIndex),
                                     @"pageSize":@(_pageSize)
                                     }
                              type:kGET
                           success:^(id responseObject) {
                               [self dismissProgress];
                               [self.courseNewDetailView.tableView.mj_footer endRefreshing];
                               NSLog(@"%@-----",responseObject);
                               BATCourseCommentModel *comment = [BATCourseCommentModel mj_objectWithKeyValues:responseObject];
                               self.resultCount = comment.RecordsCount;
                               if (_pageIndex == 0) {
                                   [_dataSource removeAllObjects];
                                   
                               }
                               [_dataSource addObjectsFromArray:comment.Data];
                               if (_dataSource.count >= comment.RecordsCount) {
                                   [self.courseNewDetailView.tableView.mj_footer endRefreshingWithNoMoreData];
                               }
                               [self.courseNewDetailView.tableView reloadData];
                           }
                           failure:^(NSError *error) {
                               [self.courseNewDetailView.tableView.mj_footer endRefreshing];
                           }];
}

#pragma mark - 对某一行点赞或者取消点赞
- (void)requestCancelAndLike:(NSIndexPath *)indexPath
{
    //点赞某一行动态
    
    BATCourseCommentData *comment = _dataSource[indexPath.row - 3];
    
    NSDictionary *params = @{@"OBJ_TYPE":@(kBATCollectionLinkTypeCourseCommentLike), @"OBJ_ID":@(comment.ID)};
    
    [HTTPTool requestWithURLString:(!comment.IsFocus ? @"/api/CollectLink/AddCollectLink" : @"/api/CollectLink/CanelCollectLink") parameters:params type:kPOST success:^(id responseObject) {
        
        if (!comment.IsFocus) {
            comment.IsFocus = YES;
            comment.StarCount++;
        } else {
            comment.IsFocus = NO;
            comment.StarCount--;
            
            if (comment.StarCount < 0) {
                comment.StarCount = 0;
            }
        }
        
        [self.courseNewDetailView.tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark - pageLayout
- (void)pageLayout
{
    self.resultCount = 0;
    [self.view addSubview:self.courseNewDetailView];
    
    WEAK_SELF(self);
    [self.courseNewDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:self.sendCommentView];
    [self.sendCommentView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(120);
        make.height.mas_equalTo(120);
    }];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.bigMaskBGView];
    [self.bigMaskBGView addSubview:self.clearMaskView];
    [self.bigMaskBGView addSubview:self.tvCollectionView];
    self.bigMaskBGView.hidden = YES;
    
    [self.view addSubview:self.defaultView];
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.bottom.right.left.top.equalTo(self.view);
    }];
}

#pragma mark - get & set
- (BATCourseNewDetailView *)courseNewDetailView
{
    if (_courseNewDetailView == nil) {
        _courseNewDetailView = [[BATCourseNewDetailView alloc] init];
        _courseNewDetailView.tableView.delegate = self;
        _courseNewDetailView.tableView.dataSource = self;
        
        WEAK_SELF(self);
        [_courseNewDetailView.tableHeaderView setAvatarTap:^{
            STRONG_SELF(self);
            
            //新个人中心控制器
            BATPersonDetailController *personDetailVC = [[BATPersonDetailController alloc]init];
            personDetailVC.accountID = [NSString stringWithFormat:@"%ld",(long)self.courseDetailModel.Data.AccountID];
            
            [self.navigationController pushViewController:personDetailVC animated:YES];
            
            /*
            BATTopicPersonController *personVC = [[BATTopicPersonController alloc]init];
            personVC.accountID = [NSString stringWithFormat:@"%ld",(long)self.courseDetailModel.Data.AccountID];
            [self.navigationController pushViewController:personVC animated:YES];
             */
        }];
        
        _courseNewDetailView.tableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.pageIndex ++;
            [self courseCommentListRequest];
        }];
        
        _courseNewDetailView.tableHeaderView.followAction = ^(){
            //关注
            STRONG_SELF(self);
            if (!LOGIN_STATION) {
                PRESENT_LOGIN_VC;
                return;
            }
            [self requestFollow];
        };
        
        _courseNewDetailView.tableHeaderView.controlView.moreButton.coursePlayerCustomButtonAction = ^(){
            STRONG_SELF(self);
            //更多
            if (self.courseNewDetailView.tableHeaderView.controlView.fullScreenBtn.selected) {
                [self.courseNewDetailView.tableHeaderView.controlView.fullScreenBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self goToBack];
                });
            } else {
                [self goToBack];
            }
            
            
        };
        
        _courseNewDetailView.tableHeaderView.controlView.testButton.testAction = ^(){
            STRONG_SELF(self);
            //去测试
            if (self.courseNewDetailView.tableHeaderView.controlView.fullScreenBtn.selected) {
                [self.courseNewDetailView.tableHeaderView.controlView.fullScreenBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self goToTestVC];
                });
            } else {
                [self goToTestVC];
            }
            
        };
        
        _courseNewDetailView.courseDetailBottomView.inputBlock = ^(){
            STRONG_SELF(self);
            
            if (!LOGIN_STATION) {
                PRESENT_LOGIN_VC;
                return;
            }
            
            self.isSinaShare = NO;
            self.sendCommentView.commentTextView.placeholderText = @"请输入...";
            [self.sendCommentView.commentTextView becomeFirstResponder];
        };
        
    }
    return _courseNewDetailView;
}

- (UIView *)bigMaskBGView
{
    if (!_bigMaskBGView) {
        _bigMaskBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _bigMaskBGView.backgroundColor = UIColorFromRGB(0, 0, 0, 0.5);
    }
    return _bigMaskBGView;
}

- (UIView *)clearMaskView
{
    if (!_clearMaskView) {
        _clearMaskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _clearMaskView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideShareAllView)];
        [self.clearMaskView addGestureRecognizer:tap];
        
    }
    return _clearMaskView;
}

- (UICollectionView *)tvCollectionView{
    if (!_tvCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _tvCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - ((SCREEN_WIDTH-20-0.75)/4.0 + 35)*2 - 100, SCREEN_WIDTH, ((SCREEN_WIDTH-20-0.75)/4.0 + 35)*2+0.25+100) collectionViewLayout:layout];
        _tvCollectionView.delegate = self;
        _tvCollectionView.dataSource = self;
        _tvCollectionView.bounces = NO;
        _tvCollectionView.backgroundColor = BASE_LINECOLOR;
        [_tvCollectionView registerClass:[BATShareCommentCollectionViewCell class] forCellWithReuseIdentifier:@"ShareCell"];
        [_tvCollectionView registerClass:[BATHeaderViewCollectionViewCell class] forCellWithReuseIdentifier:@"HeaderCell"];
    }
    return _tvCollectionView;
}

- (BATSendCommentView *)sendCommentView {
    
    if (!_sendCommentView) {
        _sendCommentView = [[BATSendCommentView alloc] init];
        _sendCommentView.commentTextView.delegate = self;
        WEAK_SELF(self);
        [_sendCommentView setSendBlock:^{
            STRONG_SELF(self);
            NSString *text = [self.sendCommentView.commentTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if (text.length == 0) {
                [self showErrorWithText:@"请输入评论"];
            }
            
            [self sendCommentRequest:self.parentId parentLevelId:self.parentLevelId];
        }];
    }
    
    return _sendCommentView;
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
            [self requestGetCourseDetail];
        }];
        
    }
    return _defaultView;
}

@end
