//
//  BATAlbumDetailViewController.m
//  HealthBAT_Pro
//
//  Created by four on 2017/6/13.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATAlbumDetailViewController.h"
//model
#import "BATAlbumDetailModel.h"
#import "BATAlbumDetailRecommendVidoeModel.h"
#import "BATAlbumDetailCommentModel.h"
//view
#import "BATSendCommentView.h"
#import "BATHeaderViewCollectionViewCell.h"
#import "BATShareCommentCollectionViewCell.h"
#import "BATAlbumDetailHeaderView.h"
//cell
#import "BATAlbumDetailInfoCell.h"//视频信息
#import "BATAlbumDetailCommentCountCell.h"//评论抬头
#import "BATAlbumDetailTestingTipsCell.h"//健康评测
#import "BATAlbumDetailCommentTableViewCell.h"//评论tableview
#import "BATAlbumDetailRecommendedVideoCell.h"//为你推荐
#import "BATAlbumDetailOtherAlbumVideoCell.h"//专辑视频
#import "BATAlbumDetailCourseSectionCell.h" //课程章节 cell
//vc
#import "BATHealthFollowTestViewController.h"
#import "BATWeChatPublicNumberViewController.h" //微信公众号
//class
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "Reachability.h"

static NSString *const kSectionCellID = @"BATAlbumDetailCourseSectionCell";


@interface BATAlbumDetailViewController () <UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate,YYTextViewDelegate,UIScrollViewDelegate>
@property (nonatomic,strong) BATAlbumDetailModel *albumDetailModel;
@property (nonatomic,strong) BATAlbumDetailRecommendVidoeModel *albumDetailRecommendVidoeModel;
@property (nonatomic,strong) BATAlbumDetailHeaderView *videoView;

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
/**
 记录评论parentId
 */
@property (nonatomic,assign) NSInteger parentId;
/**
 记录评论parentLevelId
 */
@property (nonatomic,assign) NSInteger parentLevelId;
@property (nonatomic,assign) NSInteger resultCount;

//输入框
@property (nonatomic,strong) BATSendCommentView *sendCommentView;
//默认图
@property (nonatomic,strong) BATDefaultView *defaultView;

//返回按钮
@property (nonatomic,strong) UIButton *backBtn;

@end

@implementation BATAlbumDetailViewController

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
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    //    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;

    
    if (_albumDetailModel) {
        [self.videoView.playerView pause];
    }
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    //    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    
    [self.albumDetailView.tableView registerClass:[BATAlbumDetailInfoCell class] forCellReuseIdentifier:@"BATAlbumDetailInfoCell"];
    [self.albumDetailView.tableView registerClass:[BATAlbumDetailTestingTipsCell class] forCellReuseIdentifier:@"BATAlbumDetailTestingTipsCell"];
    [self.albumDetailView.tableView registerClass:[BATAlbumDetailCommentCountCell class] forCellReuseIdentifier:@"BATAlbumDetailCommentCountCell"];
    [self.albumDetailView.tableView registerClass:[BATAlbumDetailCommentTableViewCell class] forCellReuseIdentifier:@"BATAlbumDetailCommentTableViewCell"];
    [self.albumDetailView.tableView registerClass:[BATAlbumDetailRecommendedVideoCell class] forCellReuseIdentifier:@"BATAlbumDetailRecommendedVideoCell"];
    [self.albumDetailView.tableView registerClass:[BATAlbumDetailOtherAlbumVideoCell class] forCellReuseIdentifier:@"BATAlbumDetailOtherAlbumVideoCell"];
    [self.albumDetailView.tableView registerClass:[BATAlbumDetailCourseSectionCell class] forCellReuseIdentifier:kSectionCellID];
    
    _pageSize = 10;
    _pageIndex = 0;
    _parentId = 0;
    _dataSource = [NSMutableArray array];
    self.isSinaShare = NO;
    self.shareIconArray = @[
                            @{@"icon":@"icon-weixin",@"name":@"微信"},
                            @{@"icon":@"icon-pyquan",@"name":@"朋友圈"},
                            @{@"icon":@"icon-qq",@"name":@"QQ"},
                            @{@"icon":@"icon-qqzone",@"name":@"QQ空间"},
                            @{@"icon":@"icon-weibo",@"name":@"微博"},];
    
    [self requestGetAlbumDetail];
    
    //    [self courseCommentListRequest];
    //
    //    [self requestGetRecommendVideo];
    //
    //    if (LOGIN_STATION) {
    //        [self isCollectionInfoRequest];
    //    }
    //
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 返回值要必须为NO
- (BOOL)shouldAutorotate
{
    return NO;
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 0) {
        //        if (self.albumDetailModel.Data.Theme == nil || [self.albumDetailModel.Data.Theme isEqual:[NSNull null]] || [self.albumDetailModel.Data.Theme isEqualToString:@""]) {
        //            return 1;
        //        }else{
        //            return 2;
        //        }
        return 1;
    }else if (section == 1) {
        if(self.albumDetailModel.Data.ProjectVideoList.count > 0){
            return  self.albumDetailModel.Data.ProjectVideoList.count+1;
        }else{
            return 0;
        }
    }
    else if (section == 2) {
        if(self.albumDetailRecommendVidoeModel.Data.count > 0){
            return   self.albumDetailRecommendVidoeModel.Data.count+ 1;
        }else{
            return 0;
        }
    } else if (section == 3) {
        return  self.dataSource.count + 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        return UITableViewAutomaticDimension;
        
    }
    else if (indexPath.section == 1) {
        
        if(self.albumDetailModel.Data.ProjectVideoList.count == 0){
            return 0;
        }else{
            return 44;  //课程章节
        }
        
    }
    else if (indexPath.section == 2) {
        if (self.albumDetailRecommendVidoeModel.Data.count == 0) {
            return 0;
        }else{
            if (indexPath.row == 0) {
                return 35;
            }else{
                return 125;
            }
        }
    }else if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            return 44;
        }else{
            return UITableViewAutomaticDimension;
        }
    }
    
    return UITableViewAutomaticDimension;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            BATAlbumDetailInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"BATAlbumDetailInfoCell" forIndexPath:indexPath];
            
            if (_albumDetailModel) {
                cell.isFold = self.isFold;
                [cell configData:_albumDetailModel];
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
                    CGAffineTransform t = CGAffineTransformMakeScale(1, 1);
                    t = CGAffineTransformRotate(t,  M_PI/180.0*0);
                    self.tvCollectionView.transform = t;
                    
                    self.bigMaskBGView.hidden = NO;
                };
                
                cell.foldAction = ^(){
                    //展开收起
                    STRONG_SELF(self);
                    self.isFold = !self.isFold;
                    [self.albumDetailView.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                };
            }
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            return cell;
        }
        //        else{
        //            BATAlbumDetailTestingTipsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATAlbumDetailTestingTipsCell" forIndexPath:indexPath];
        //            cell.contentLb.text = _albumDetailModel.Data.Theme;
        //
        //            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        //
        //            return cell;
        //        }
        
    } else if (indexPath.section == 1) { // 视频列表
        
        /*
         BATAlbumDetailOtherAlbumVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATAlbumDetailOtherAlbumVideoCell" forIndexPath:indexPath];
         [cell sendAlbumVideoData:_albumDetailModel];
         
         WEAK_SELF(self);
         [cell setVideoClick:^(NSIndexPath *indexPath){
         STRONG_SELF(self);
         BATAlbumProjectVideoData *data = self.albumDetailModel.Data.ProjectVideoList[indexPath.row];
         self.videoID = [NSString stringWithFormat:@"%ld",(long)data.VideoID];
         self.albumID = data.TemplateID == nil? @"":[NSString stringWithFormat:@"%@",data.TemplateID];
         [self requestGetAlbumDetail];
         //            [self requestGetRecommendVideo];
         //            [self courseCommentListRequest];
         }];
         
         [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
         
         
         */
        if (indexPath.row != 0) {
            
            BATAlbumDetailCourseSectionCell *sectionCell = [tableView dequeueReusableCellWithIdentifier:kSectionCellID];
            [sectionCell setDateWith:self.albumDetailModel indexPath:indexPath selctedVideoID:self.videoID];
            [sectionCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return sectionCell;
            
            
        }else{
            
            BATAlbumDetailCommentCountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATAlbumDetailCommentCountCell" forIndexPath:indexPath];
            cell.titleLabel.text = [NSString stringWithFormat:@"【专辑】%@(%ld)",self.albumDetailModel.Data.Theme,(unsigned long)self.albumDetailModel.Data.ProjectVideoList.count];
            cell.countLabel.hidden = YES;
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            return cell;
            
            
            
        }
        
    }else if (indexPath.section == 2) {
        
        if (indexPath.row == 0) {
            BATAlbumDetailCommentCountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATAlbumDetailCommentCountCell" forIndexPath:indexPath];
            cell.titleLabel.text = @"为您推荐";
            cell.countLabel.hidden = YES;
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            return cell;
        }else {
            
            BATAlbumDetailRecommendedVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATAlbumDetailRecommendedVideoCell" forIndexPath:indexPath];
            BATAlbumDetailRecommendVidoeData *data = self.albumDetailRecommendVidoeModel.Data[indexPath.row - 1];
            [cell setCellWithModel:data];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            return cell;
        }
        
    } else if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            BATAlbumDetailCommentCountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATAlbumDetailCommentCountCell" forIndexPath:indexPath];
            cell.titleLabel.text = @"评论";
            cell.countLabel.hidden = NO;
            cell.countLabel.text = [NSString stringWithFormat:@"(%ld)",(unsigned long)self.dataSource.count];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            return cell;
        }else {
            BATAlbumDetailCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATAlbumDetailCommentTableViewCell" forIndexPath:indexPath];
            
            if (_dataSource.count > 0) {
                cell.indexPath = indexPath;
                [cell configData:_dataSource[indexPath.row - 1]];
                
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
                    
                    BATAlbumDetailData *data = self.dataSource[cellIndexPath.row - 1];
                    BATAlbumDetailCommentData *commentModel = self.dataSource[indexPath.row - 1];
                    self.parentId = data.ID;
                    self.parentLevelId = data.ID;
                    self.isSinaShare = NO;
                    
                    self.sendCommentView.commentTextView.placeholderText = [NSString stringWithFormat:@"回复%@ ",commentModel.AccountName];
                    [self.sendCommentView.commentTextView becomeFirstResponder];
                    
                };
                
                cell.replyTableView.replyCommentAction = ^(NSIndexPath *commentIndexPath,BATAlbumDetailCommentData *comment,NSInteger parentLevelId) {
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
        
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0 ) {
        return 10;
    }
    return  CGFLOAT_MIN;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    if (indexPath.section == 0 && indexPath.row == 1 ) {
    //        BATHealthFollowTestViewController *healthFollowTestVC = [[BATHealthFollowTestViewController alloc] init];
    //        healthFollowTestVC.title = self.albumDetailModel.Data.Theme;
    //        healthFollowTestVC.courseID = self.albumDetailModel.Data.ID;
    //        healthFollowTestVC.hidesBottomBarWhenPushed = YES;
    //        [self.navigationController pushViewController:healthFollowTestVC animated:YES];
    //    }
    
    if (indexPath.section == 1 && indexPath.row !=0) {
            BATAlbumProjectVideoData *data = self.albumDetailModel.Data.ProjectVideoList[indexPath.row-1];
            self.videoID = [NSString stringWithFormat:@"%ld",(long)data.VideoID];
            self.albumID = data.TemplateID == nil? @"":[NSString stringWithFormat:@"%@",data.TemplateID];
            data.selected = YES;
            [self requestGetAlbumDetail];
        
    }
    
    if (indexPath.section == 2) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        BATAlbumDetailRecommendVidoeData *data = self.albumDetailRecommendVidoeModel.Data[indexPath.row - 1];
        
        self.videoID = [NSString stringWithFormat:@"%ld",(long)data.ID];
        self.albumID = data.ThemplateID == nil?@"":[NSString stringWithFormat:@"%@",data.ThemplateID];
        [self requestGetAlbumDetail];
        //        [self requestGetRecommendVideo];
        //        [self courseCommentListRequest];
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
    
    NSString *shareText = [NSString stringWithFormat:@"%@|%@-健康BAT",_albumDetailModel.Data.Topic,_albumDetailModel.Data.TeacherName];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/App/VideoCourse?id=%@&token=%@",APP_WEB_DOMAIN_URL,self.videoID,LOCAL_TOKEN]];
    NSString *shareURL = [NSString stringWithFormat:@"%@&%@",url,@"share=1"];
    DDLogDebug(@"shareURL === %@",shareURL);
    
    //先构造分享参数：
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

#pragma mark - 修改屏幕方向
- (void)interfaceOrientation:(UIInterfaceOrientation)orientation
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector  = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = orientation;
        // 从2开始是因为0 1 两个参数已经被selector和target占用
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}
#pragma mark - Action

/**
 *  关注公众号按钮点击
 */
- (void)followQRCodeButtonClick{
    
//    NSLog(@"---点击了关注公众号按钮-");
    
   [self interfaceOrientation:UIInterfaceOrientationPortrait];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        BATWeChatPublicNumberViewController *weChatPublicNumberVC = [[BATWeChatPublicNumberViewController alloc]init];
        [self.navigationController pushViewController:weChatPublicNumberVC animated:YES];
    });
}


- (void)keyboardWillShow:(NSNotification *)notif {
    
    if (!self.isSinaShare) {
        CGRect keyboardFrame = [notif.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        
        double duration = [notif.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        NSInteger animation = [notif.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
        
        WEAK_SELF(self);
        [UIView animateWithDuration:duration delay:0.0f options:animation animations:^{
            STRONG_SELF(self);
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
        WEAK_SELF(self);
        [UIView animateWithDuration:duration delay:0.0f options:animation animations:^{
            STRONG_SELF(self);
            self.sendCommentView.transform = CGAffineTransformIdentity;
            
        } completion:nil];
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

- (void)onDeviceOrientationChange {
    
    [self.sendCommentView.commentTextView resignFirstResponder];
}

#pragma mark - Net
#pragma mark - 获取专辑详细
- (void)requestGetAlbumDetail
{
    
    [HTTPTool requestWithURLString:@"/api/trainingteacher/getcourse" parameters:@{@"ID":self.videoID,@"AlbumID":self.albumID} type:kGET success:^(id responseObject) {
        self.backBtn.hidden = YES;
        _albumDetailModel = [BATAlbumDetailModel mj_objectWithKeyValues:responseObject];
        
        [self.videoView configData:_albumDetailModel];
        
        
        
        
        
        [self.albumDetailView.tableView reloadData];
        
        
        //详情成功之后再获取其他数据
        //获取为你推荐视频
        [self requestGetRecommendVideo];
        
        //获取收藏
        if (LOGIN_STATION) {
            [self isCollectionInfoRequest];
        }
        
        //获取评论
        [self courseCommentListRequest];
        
    } failure:^(NSError *error) {
        self.backBtn.hidden = NO;
        [self.defaultView showDefaultView];
        self.defaultView.reloadButton.hidden = YES;
    }];
}


#pragma mark - 为你推荐
- (void)requestGetRecommendVideo{
    [HTTPTool requestWithURLString:@"/api/trainingteacher/GetRecommendedVideoList" parameters:nil type:kGET success:^(id responseObject) {
        
        _albumDetailRecommendVidoeModel = [BATAlbumDetailRecommendVidoeModel mj_objectWithKeyValues:responseObject];
        
        if(_albumDetailRecommendVidoeModel.Data.count > 0){
            [self.albumDetailView.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationFade];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 收藏资讯
-(void)addCollection
{
    [HTTPTool requestWithURLString:@"/api/CollectLink/AddCollectLink" parameters:@{@"OBJ_ID":self.videoID,@"OBJ_TYPE":@(kBATCollectionLinkTypeCourse)} type:kPOST success:^(id responseObject) {
        //        [self showSuccessWithText:@"收藏成功"];
        _isCollection = YES;
        [self.albumDetailView.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        
        self.videoView.controlView.collectionBtn.selected = YES;
        
    } failure:^(NSError *error) {
        //        [self showErrorWithText:@"收藏失败"];
    }];
}
#pragma mark - 取消收藏资讯
-(void)cancleCollection
{
    [HTTPTool requestWithURLString:@"/api/CollectLink/CanelCollectLink" parameters:@{@"OBJ_ID":self.videoID,@"OBJ_TYPE":@(kBATCollectionLinkTypeCourse)} type:kPOST success:^(id responseObject) {
        //        [self showSuccessWithText:@"取消收藏成功"];
        _isCollection = NO;
        [self.albumDetailView.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        
        self.videoView.controlView.collectionBtn.selected = NO;
        
    } failure:^(NSError *error) {
        //        [self showErrorWithText:@"取消收藏失败"];
    }];
}

#pragma mark - 判断是否收藏
- (void)isCollectionInfoRequest
{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@(kBATCollectionLinkTypeCourse) forKey:@"RelationType"];
    [dict setValue:self.videoID forKey:@"RelationId"];
    [HTTPTool requestWithURLString:@"/api/CollectLink/IsCollectLink" parameters:dict type:kGET success:^(id responseObject) {
        NSString *isCollectionString = [NSString stringWithFormat:@"%@",responseObject[@"Data"][@"IsCollectLink"]];
        if ([isCollectionString isEqualToString:@"0"]) {
            _isCollection = NO;
            self.videoView.controlView.collectionBtn.selected = NO;
            
        }else {
            _isCollection = YES;
            self.videoView.controlView.collectionBtn.selected = YES;
            
        }
        
        [self.albumDetailView.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
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
                                     @"CourseID":self.videoID,
                                     @"Body":self.sendCommentView.commentTextView.text,
                                     @"ParentId":@(parentId),
                                     @"ParentLevelId":@(parentLevelId)
                                     }
                              type:kPOST
                           success:^(id responseObject) {
                               
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
                                     @"courseID":self.videoID,
                                     @"pageIndex":@(_pageIndex),
                                     @"pageSize":@(_pageSize)
                                     }
                              type:kGET
                           success:^(id responseObject) {
                               [self dismissProgress];
                               [self.albumDetailView.tableView.mj_footer endRefreshing];
                               NSLog(@"%@-----",responseObject);
                               BATAlbumDetailCommentModel *comment = [BATAlbumDetailCommentModel mj_objectWithKeyValues:responseObject];
                               self.resultCount = comment.RecordsCount;
                               if (_pageIndex == 0) {
                                   [_dataSource removeAllObjects];
                               }
                               [_dataSource addObjectsFromArray:comment.Data];
                               if (_dataSource.count >= comment.RecordsCount) {
                                   [self.albumDetailView.tableView.mj_footer endRefreshingWithNoMoreData];
                               }
                               
                               [self.albumDetailView.tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationFade];
                               
                           }
                           failure:^(NSError *error) {
                               [self.albumDetailView.tableView.mj_footer endRefreshing];
                           }];
}

#pragma mark - 对某一行点赞或者取消点赞
- (void)requestCancelAndLike:(NSIndexPath *)indexPath
{
    //点赞某一行动态
    
    BATAlbumDetailCommentData *comment = _dataSource[indexPath.row - 1];
    
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
        
        [self.albumDetailView.tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark - pageLayout
- (void)pageLayout
{
    self.resultCount = 0;
    [self.view addSubview:self.albumDetailView];
    [self.view addSubview:self.videoView];
    
    WEAK_SELF(self);
    [self.videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.right.equalTo(self.view);
        if (iPhoneX) {
            make.top.equalTo(self.mas_topLayoutGuide);
        } else {
            make.top.equalTo(self.view.mas_top).offset(0);
        }
        make.height.mas_equalTo(SCREEN_WIDTH/16*9);
    }];
    
    [self.albumDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
//        make.left.right.bottom.equalTo(self.view);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
        make.top.equalTo(self.videoView.mas_bottom).offset(0);
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
        make.top.equalTo(self.videoView.mas_bottom);
        make.bottom.right.left.equalTo(self.view);
    }];
    
    [self.view addSubview:self.backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.top.equalTo(self.view.mas_top).offset(40);
    }];
}

- (BATAlbumDetailHeaderView *)videoView{
    if (!_videoView) {
        _videoView = [[BATAlbumDetailHeaderView alloc]initWithFrame:CGRectZero];
        
        WEAK_SELF(self);
        [_videoView setCilckBackBlock:^{
            STRONG_SELF(self);
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
        [_videoView.controlView setShareBtnClick:^{
            //分享
            STRONG_SELF(self);
            
            
            
            switch ([[UIDevice currentDevice] orientation]) {
                case UIDeviceOrientationLandscapeLeft:
                {
                    CGAffineTransform t = CGAffineTransformMakeScale(1, 1);
                    t = CGAffineTransformRotate(t,  M_PI/180.0*90);
                    self.tvCollectionView.transform = t;
                }
                    break;
                case UIDeviceOrientationLandscapeRight:
                {
                    CGAffineTransform t = CGAffineTransformMakeScale(1, 1);
                    t = CGAffineTransformRotate(t,  M_PI/180.0*270);
                    self.tvCollectionView.transform = t;
                }
                    break;
                    
                default:
                {
                    CGAffineTransform t = CGAffineTransformMakeScale(1, 1);
                    t = CGAffineTransformRotate(t,  M_PI/180.0*90);
                    self.tvCollectionView.transform = t;
                }
                    break;
            }
            
            self.bigMaskBGView.hidden = NO;
            
            [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self.bigMaskBGView];
        }];
        
        [_videoView.controlView setCollectionBtnClick:^{
            //收藏
            STRONG_SELF(self);
            if (!LOGIN_STATION) {
                
                [self.videoView.controlView fullScreenBtnClick:self.videoView.controlView.fullScreenBtn];
                
                PRESENT_LOGIN_VC;
                return;
            }
            
            if (self.isCollection) {
                [self cancleCollection];
            }else{
                [self addCollection];
            }
        }];
        
        [_videoView.controlView setResignTextInputView:^{
            STRONG_SELF(self);
            [self.sendCommentView.commentTextView resignFirstResponder];
        }];
        
        //视频播放完显示的关注二维码调用
        [_videoView.controlView.followQRCodeButton.button addTarget:self action:@selector(followQRCodeButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _videoView;
}

#pragma mark - get & set
- (BATAlbumDetailView *)albumDetailView
{
    if (_albumDetailView == nil) {
        _albumDetailView = [[BATAlbumDetailView alloc] init];
        _albumDetailView.tableView.rowHeight = UITableViewAutomaticDimension;
        _albumDetailView.tableView.estimatedRowHeight = 100;
        _albumDetailView.tableView.delegate = self;
        _albumDetailView.tableView.dataSource = self;
        WEAK_SELF(self);
        
        _albumDetailView.tableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.pageIndex ++;
            [self courseCommentListRequest];
        }];
        
        _albumDetailView.albumeDetailBottomView.inputBlock = ^(){
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
    return _albumDetailView;
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
            [self requestGetAlbumDetail];
        }];
        
    }
    return _defaultView;
}


-(UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom Title:@"" titleColor:nil backgroundColor:nil backgroundImage:[UIImage imageNamed:@"back-icon-w"] Font:nil];
        _backBtn.hidden = YES;
        WEAK_SELF(self);
        [_backBtn bk_whenTapped:^{
            STRONG_SELF(self);
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    return _backBtn;
}
@end

