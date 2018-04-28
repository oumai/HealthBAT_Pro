//
//  BATPersonDetailController.m
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/5/12.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATPersonDetailController.h"
#import "BATDymaicController.h"
#import "BATSegmentControl.h"
#import "BATPersonDetailHeadView.h"
#import "BATPersonDetailModel.h"
#import "BATPerson.h"
#import "BATPersonDetailFooterView.h"
#import "BATMainAttendController.h"
//#import "BATMyFansViewController.h"
#import "BATMyFansListViewController.h"
#import "BATCustomScrollView.h"
#import "BATFamilyDoctorChatViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "BATDiteGuideMyPhotoViewController.h"
#import "BATPersonInfoViewController.h"
#define kHeadViewHeight 156
#define kSegmentHeight 45
#define kFooterViewHeight 50

@interface BATPersonDetailController ()<UIScrollViewDelegate, BATSegmentControlDelegate, BATPersonDetailFooterViewDelegate, BATPersonDetailHeadViewDelegate>
@property (nonatomic, strong) UIView *navView;
@property (nonatomic, strong) UIView *lineView;
/** 底部滑动 UIScrollview */
@property (nonatomic, strong) BATCustomScrollView *scrollView;
/** item切换 view */
@property (nonatomic, strong) BATSegmentControl *segmentControl;
/** 个人信息顶部 view */
@property (nonatomic, strong) BATPersonDetailHeadView *headView;
/** 关注按钮及私聊view */
@property (nonatomic, strong) BATPersonDetailFooterView*footerView;
/** model */
@property (nonatomic, strong) BATPersonDetailModel *personModel;
/** model */
@property (nonatomic, strong) BATPerson *loginUserModel;
/** 当前登录用户的 ID */
@property (nonatomic, strong) NSString *loginUserID;


@end

@implementation BATPersonDetailController

//取消全屏返回手势
- (BOOL)fd_interactivePopDisabled{
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loginUserModel = PERSON_INFO;
    self.loginUserID = [NSString stringWithFormat:@"%ld",(long)self.loginUserModel.Data.AccountID];
    self.view.backgroundColor = UIColorFromHEX(0xf5f5f5, 1);
    [self setupUI];
    
}



#pragma mark - 导航栏设置
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    //是否开启导航栏透明
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    
    //去掉透明后导航栏下边的黑边(底部分割线)
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    //获取个人中心数据
    [self getPersonDataRequest];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //是否开启导航栏透明
    self.navigationController.navigationBar.translucent = NO;
    //不让其他页面的导航栏变为透明
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    self.extendedLayoutIncludesOpaqueBars = YES;
    
}

#pragma mark - 界面设置

- (void)setupUI{
    
    [self.view addSubview:self.headView];
    
    //动态控制器
    BATDymaicController *dymaicVC = [[BATDymaicController alloc] init];
    dymaicVC.AccountID = self.accountID;
    
    dymaicVC.dymaicTab.backgroundColor = UIColorFromHEX(0xf5f5f5, 1);
    
    //是否为自己查看自己的主页
    if ([self.loginUserID isEqualToString:self.accountID]) {
        
        [self.view addSubview:self.segmentControl];
        [self.view addSubview:self.scrollView];
        
        BATDiteGuideMyPhotoViewController *myPhotoVC = [[BATDiteGuideMyPhotoViewController alloc] init];
        myPhotoVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.scrollView.frame.size.height);
        [self addChildViewController:myPhotoVC];
        [self.scrollView addSubview:myPhotoVC.view];
        
        dymaicVC.view.frame = CGRectMake(SCREEN_WIDTH, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        [self.scrollView addSubview:dymaicVC.view];
        [self addChildViewController:dymaicVC];
        
    }else{
        
        //当前登录用户查看别人的主页
        [self.view addSubview:self.footerView];
        
        dymaicVC.view.frame = CGRectMake(0, CGRectGetMaxY(self.headView.frame), SCREEN_WIDTH, SCREEN_HEIGHT - self.headView.frame.size.height - self.footerView.size.height);
        [self.view addSubview:dymaicVC.view];
        [self addChildViewController:dymaicVC];
        
    }
    
}
#pragma mark - FooterViewDelegate

- (void)focusButtonDidClick:(UIButton *)focusBtn{
    
    if (!LOGIN_STATION) {
        PRESENT_LOGIN_VC;
        return ;
    }
    
    NSString *cancelOperationURL = @"/api/dynamic/CancelOperation";
    NSString *executeOperationURL = @"/api/dynamic/ExecuteOperation";
    NSString *operationURL = self.personModel.IsUserFollow ? cancelOperationURL : executeOperationURL;
    
    if (![self.loginUserID isEqualToString:self.personModel.AccountID]) {
        self.personModel.FansNum = self.personModel.IsUserFollow ? (self.personModel.FansNum -=1 ): (self.personModel.FansNum +=1 );
    }else{
        
        self.personModel.FollowNum = self.personModel.IsUserFollow ? (self.personModel.FollowNum -=1 ): (self.personModel.FollowNum +=1 );
    }
    
    self.headView.personModel = self.personModel;
    self.personModel.IsUserFollow = !self.personModel.IsUserFollow;
    self.footerView.focusButton.selected = self.personModel.IsUserFollow;
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"3" forKey:@"RelationType"];
    [dict setObject:self.personModel.AccountID forKey:@"RelationID"];
    
    [HTTPTool requestWithURLString:operationURL parameters:dict type:kPOST success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
    
}
#pragma mark - 私聊按钮
- (void)chatButtonDidClick:(UIButton *)chatBtn{
    if (!LOGIN_STATION) {
        PRESENT_LOGIN_VC;
        return ;
    }
    
    //进入聊天室界面
    BATFamilyDoctorChatViewController *chatVC = [[BATFamilyDoctorChatViewController alloc] initWithConversationType:ConversationType_PRIVATE targetId:self.personModel.AccountID];
    
    chatVC.title = self.personModel.UserName;
    chatVC.DoctorName = self.personModel.UserName;
    chatVC.DoctorPhotoPath = self.personModel.PhotoPath;
    chatVC.DoctorId = self.personModel.AccountID;
    
    
    //chatVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatVC animated:YES];
    
    
}
#pragma mark - BATPersonDetailFooterViewDelegate
#pragma mark - 粉丝数按钮点击
- (void)fansCountButtonDidClick:(UIButton *)fansBtn :(BATPersonDetailModel *)personModel{
    
    /*
     旧粉丝列表控制器
     BATMyFansViewController *fansListVC = [[BATMyFansViewController alloc]init];
     fansListVC.accountID = self.accountID;
     [self.navigationController pushViewController:fansListVC animated:YES];
     */
    
    //新粉丝列表控制器
    BATMyFansListViewController *fansListVC = [[BATMyFansListViewController alloc]init];
    fansListVC.accountID = self.accountID;
    [self.navigationController pushViewController:fansListVC animated:YES];
    
}
#pragma mark - 关注按钮数点击
- (void)focusCountButtonDidClick:(UIButton *)focusBtn{
    BATMainAttendController *attendVC = [[BATMainAttendController alloc]init];
    attendVC.accountID = self.personModel.AccountID;
    
    [self.navigationController pushViewController:attendVC animated:YES];
    
}


#pragma mark - 头像点击
- (void)focusHeaderViewDidClick{
    
    if (![self.loginUserID isEqualToString:self.accountID])  return;
    
    //个人资料
    BATPersonInfoViewController *personInfoVC = [[BATPersonInfoViewController alloc]init];
    
    //隐藏tabBar
    personInfoVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:personInfoVC animated:YES];
}

#pragma BATSegmentControlDelagat
- (void)batSegmentedControl:(BATSegmentControl *)segmentedControl selectedIndex:(NSInteger)index{
    
    [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * index, 0) animated:YES];
    
}


#pragma mark - Request

- (void)getPersonDataRequest {
    
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    
    NSString *loginUserId = [NSString stringWithFormat:@"%ld",(long)self.loginUserModel.Data.AccountID];
    if (![loginUserId isEqualToString:self.accountID]) {
        dictM[@"accountId"] = self.accountID;
    }else{
        dictM[@"accountId"] = @(0);
    }
    
    WeakSelf
    [HTTPTool requestWithURLString:@"/api/dynamic/GetAccountDetail" parameters:dictM type:kGET success:^(id responseObject) {
        
        
        weakSelf.personModel = [BATPersonDetailModel mj_objectWithKeyValues:responseObject[@"Data"]];
        weakSelf.footerView.focusButton.selected = self.personModel.IsUserFollow;
        weakSelf.headView.personModel = weakSelf.personModel;
        
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - lazy Load
- (BATPersonDetailFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[BATPersonDetailFooterView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50)];
        _footerView.backgroundColor = [UIColor whiteColor];
        _footerView.delegate = self;
        
    }
    return _footerView;
}
- (BATPersonDetailHeadView *)headView{
    if (!_headView) {
        _headView = [[[NSBundle mainBundle]loadNibNamed:@"BATPersonDetailHeadView" owner:nil options:nil]lastObject];
        _headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 156);
        _headView.delegate = self;
    }
    return _headView;
}
- (BATCustomScrollView *)scrollView{
    if(!_scrollView){
        CGFloat segmentControlH  = CGRectGetMaxY(self.segmentControl.frame);
        _scrollView = [[BATCustomScrollView alloc] initWithFrame:CGRectMake(0, segmentControlH + 10, SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetHeight(self.headView.frame) - kSegmentHeight - 10)];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.contentSize = CGSizeMake( SCREEN_WIDTH * 2, 0);
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.scrollEnabled = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        
    }
    return _scrollView;
}
- (BATSegmentControl *)segmentControl{
    if (!_segmentControl) {
        _segmentControl = [[BATSegmentControl alloc]initWithItems:@[@"吃货圈",@"动态"]];
        _segmentControl.frame = CGRectMake(0, CGRectGetHeight(self.headView.frame), SCREEN_WIDTH, kSegmentHeight);
        _segmentControl.backgroundColor = [UIColor whiteColor];
        _segmentControl.delegate = self;
    }
    return _segmentControl;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
