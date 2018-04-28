//
//  BATHealthFollowController.m
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/6/7.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHealthFollowController.h"
#import "BATProgramAddedListViewController.h"
#import "BATFeaturedViewController.h"
#import "BATCourseSearchViewController.h"
#import "HMSegmentedControl.h"
#import "UIButton+TouchAreaInsets.h"
#import "BATCustomScrollView.h"

/** 导航栏及状态栏高度 */
//#define kNAVIGATION_STATUS_BAR_HEIGHT 64
/** TabBar */
//#define kTAB_BAR_HEIGHT 49
/** 分段控制器高度 */
#define kSEGMENTEDCONTROL_HEIGHT 45

@interface BATHealthFollowController ()<UIScrollViewDelegate>

/** 分段控制器 */
@property (nonatomic, strong) HMSegmentedControl *segmentController;

/** UIScrollView */
@property (nonatomic, strong) BATCustomScrollView *bgScrollView;

@end

@implementation BATHealthFollowController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.segmentController];
    [self.view addSubview:self.bgScrollView];
    [self addNotification];
    [self addChildVc];
    [self setupNav];
    
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    [self.segmentController mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.mas_equalTo(0);
        make.height.equalTo(@45);
    }];
    
    [self.bgScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.segmentController.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.tabBarController.tabBar.mas_top);
        
        
    }];
    
}
#pragma mark - private
/**
 添加子控制器 & 子控制器 View
 */
- (void)addChildVc{
    
    //精选
    BATFeaturedViewController *featuredVc = [[BATFeaturedViewController alloc]init];
    featuredVc.view.frame = CGRectMake(0, 0, self.bgScrollView.width, self.bgScrollView.height);
    
    //已添加方案
    BATProgramAddedListViewController *programListVc = [[BATProgramAddedListViewController alloc]init];
    programListVc.view.frame = CGRectMake(SCREEN_WIDTH, 0, self.bgScrollView.width, self.bgScrollView.height);
    
    [self addChildViewController:featuredVc];
    [self addChildViewController:programListVc];
    
    [self.bgScrollView addSubview:featuredVc.view];
    [self.bgScrollView addSubview:programListVc.view];
}

/**
 通知
 */
- (void)addNotification{
    //正常退出登录
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginOut) name:@"LOGINOUT" object:nil];
    
    //被挤掉退出登录
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOut) name:@"APPLICATION_LOGOUT" object:nil];
}

/**
 当用户退出登录，滚动到精选界面
 */
- (void)loginOut{
    
    [self.bgScrollView setContentOffset:CGPointZero animated:YES];
    self.segmentController.selectedSegmentIndex = 0;
}
/**
 点击分段view 调用
 */
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentCtr{
    
    if ( !LOGIN_STATION) {
        PRESENT_LOGIN_VC;
        self.segmentController.selectedSegmentIndex = 0;
        [self.bgScrollView setContentOffset:CGPointZero];
    }else{
        
        [self.bgScrollView setContentOffset:CGPointMake(SCREEN_WIDTH * segmentCtr.selectedSegmentIndex, 0) animated:YES];
    }
    
}

#pragma mark - Nav
/**
 设置导航栏
 */
- (void)setupNav{
    
    self.navigationItem.title = @"健康关注";
    
    WEAK_SELF(self);
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 40, 40);
    
    [btn bk_whenTapped:^{
        STRONG_SELF(self);
        if (self.isFromRoundGuide) {
            BATAppDelegate *appDelegate = (BATAppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate.window.rootViewController presentViewController:appDelegate.navHomeVC animated:NO completion:nil];
        } else {
            [self.tabBarController setSelectedIndex:0];
        }
    }];
    [btn setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -40, 0, 0)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}
/**
 返回首页
 */
- (void)leftBackButtonItemClick{
    
    if (self.isFromRoundGuide) {
        BATAppDelegate *appDelegate = (BATAppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate.window.rootViewController presentViewController:appDelegate.navHomeVC animated:NO completion:nil];
    } else {
        [self.tabBarController setSelectedIndex:0];
    }
}
/**
 搜索
 */
- (void)rightSearchBarButtonItemClick{
    
    BATCourseSearchViewController *batCourseSearchVC = [[BATCourseSearchViewController alloc] init];
    batCourseSearchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:batCourseSearchVC animated:YES];
    
}

#pragma mark - UIScrolllViewDelegate
/**
 当减速完毕的时候调用（人为拖拽scrollView，手松开后scrollView慢慢减速完毕到静止）
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //添加子控制器 view
    
    if (LOGIN_STATION) {
        //    计算页码
        CGFloat pageWidth = scrollView.frame.size.width;
        NSInteger page = scrollView.contentOffset.x / pageWidth;
        [self.segmentController setSelectedSegmentIndex:page animated:YES];
        
    }
    
    
}
/**
 拖动结束，手从屏幕上抬起的一刹那，会执行这个方法,防止用户刚好拖到边界停止
 */
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(!decelerate){ //手指离开，恰好不再减速执行
        [self scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if(!LOGIN_STATION){ //没登录
        self.segmentController.selectedSegmentIndex = 0;
        PRESENT_LOGIN_VC;
        return;
    }
    
}

#pragma mark - lazy Load

- (BATCustomScrollView *)bgScrollView{
    if (!_bgScrollView) {
        //导航栏高度
        _bgScrollView = [[BATCustomScrollView alloc]init];
        
//        if(@available(iOS 11.0, *)) {
//            _bgScrollView.frame = CGRectMake(0, CGRectGetMaxY(self.segmentController.frame), SCREEN_WIDTH, SCREEN_HEIGHT-88-83-45);
//        }else{
//
//            _bgScrollView.frame = CGRectMake(0, CGRectGetMaxY(self.segmentController.frame), SCREEN_WIDTH, SCREEN_HEIGHT-64-49-45);
//        }

        _bgScrollView.delegate = self;
        _bgScrollView.pagingEnabled = YES;
        _bgScrollView.contentSize = CGSizeMake(2 * SCREEN_WIDTH, 0);
        _bgScrollView.backgroundColor = UIColorFromHEX(0xf5f5f5, 1);
        _bgScrollView.showsVerticalScrollIndicator = NO;
        _bgScrollView.showsHorizontalScrollIndicator = NO;
        _bgScrollView.bounces = NO;
    }
    return _bgScrollView;
}

- (HMSegmentedControl *)segmentController{
    if (!_segmentController) {
        
        //设置图片(普通)
        NSArray<UIImage *> *images = @[
                                       [UIImage imageNamed:@"Follow_Featured_SegCtr_Nor"],
                                       [UIImage imageNamed:@"Follow_Program_SegCtr_Nor"]
                                       ];
        
        //选中状态下的图片
        NSArray<UIImage *> *selectedImages = @[
                                               [UIImage imageNamed:@"Follow_Featured_SegCtr_Sel"],
                                               [UIImage imageNamed:@"Follow_Program_SegCtr_Sel"]
                                               ];
        
        _segmentController = [[HMSegmentedControl alloc] initWithSectionImages:images sectionSelectedImages:selectedImages];
        
        //设置底部下划线的高度
        _segmentController.selectionIndicatorHeight = 2;
        
        //设置底部下划线的颜色
        _segmentController.selectionIndicatorColor = UIColorFromHEX(0x29ccbf, 1);
        
        _segmentController.frame = CGRectMake(0, 0, SCREEN_WIDTH, kSEGMENTEDCONTROL_HEIGHT);
        
        //设置边框
        _segmentController.layer.borderColor = UIColorFromHEX(0xe0e0e0, 1).CGColor;
        _segmentController.layer.borderWidth = 0.5;
        _segmentController.layer.masksToBounds = YES;
        
        
        //设置底下的线和文字一样大
        _segmentController.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
        //设置线的位置
        _segmentController.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        
        //添加点击事件
        [_segmentController addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
        
        
        
    }
    return _segmentController;
}
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
