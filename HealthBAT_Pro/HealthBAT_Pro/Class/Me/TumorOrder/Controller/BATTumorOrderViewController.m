//
//  BATTumorOrderViewController.m
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/9/14.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATTumorOrderViewController.h"
#import "HMSegmentedControl.h"
#import "BATTumorOrderListViewController.h"
#import "UIColor+Gradient.h"

/** 导航栏及状态栏高度 */
#define kNAVIGATION_STATUS_BAR_HEIGHT 64

/** 分段控制器高度 */
#define kSEGMENTEDCONTROL_HEIGHT 45

@interface BATTumorOrderViewController ()<UIScrollViewDelegate>
/** HMSegmentedControl */
@property (nonatomic, strong) HMSegmentedControl *segmentController;
/** UIScrollView */
@property (nonatomic, strong) UIScrollView *bgScrollView;

@end

@implementation BATTumorOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"防癌筛查订单";
    [self.view addSubview:self.segmentController];
    [self.view addSubview:self.bgScrollView];
    [self addChildVc];
    
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    [self.segmentController mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@45);
        make.left.right.top.mas_equalTo(0);
    }];
    
    [self.bgScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.segmentController.mas_bottom);
        make.left.right.bottom.mas_equalTo(0);
    }];
    
    
}
- (void)addChildVc{
    
    BATTumorOrderListViewController *allOrderVc = [[BATTumorOrderListViewController alloc]init];
    
     BATTumorOrderListViewController *alreadyPaidOrderVc = [[BATTumorOrderListViewController alloc]init];
    
    BATTumorOrderListViewController *unpaidOrderVc = [[BATTumorOrderListViewController alloc]init];
    
    BATTumorOrderListViewController *finshOrderVC = [[BATTumorOrderListViewController alloc]init];
    
    BATTumorOrderListViewController *cancelOrderVC = [[BATTumorOrderListViewController alloc]init];
    
    allOrderVc.OrderType = TumorOrderTypeAll;
    unpaidOrderVc.OrderType = TumorOrderTypeUnpaid;
    alreadyPaidOrderVc.OrderType = TumorOrderTypeAlreadyPaid;
    finshOrderVC.OrderType = TumorOrderTypeFinsh;
    cancelOrderVC.OrderType = TumorOrderTypeCancel;
    
    [self addChildViewController:allOrderVc];
    [self addChildViewController:alreadyPaidOrderVc];
    [self addChildViewController:unpaidOrderVc];
    [self addChildViewController:finshOrderVC];
    [self addChildViewController:cancelOrderVC];
    
    //主动调用滚动到第一个界面
    [self scrollViewDidEndScrollingAnimation:self.bgScrollView];
    
    
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentController{
    
    [self.bgScrollView setContentOffset:CGPointMake(SCREEN_WIDTH * segmentController.selectedSegmentIndex, 0) animated:YES];

}

#pragma mark - UIScrolllViewDelegate

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    
    int index = scrollView.contentOffset.x / SCREEN_WIDTH;
    UIViewController *willShowChildVc = self.childViewControllers[index];
    
    if (willShowChildVc.isViewLoaded) return;
    
    willShowChildVc.view.frame = scrollView.bounds;
    willShowChildVc.view.backgroundColor = batRandomColor;
    [scrollView addSubview:willShowChildVc.view];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
    //计算页码
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    [self.segmentController setSelectedSegmentIndex:page animated:YES];
    
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(!decelerate){  //手指离开，恰好不再减速执行
        [self scrollViewDidEndDecelerating:scrollView];
    }
}
#pragma mark - lazy Load

- (UIScrollView *)bgScrollView{
    if (!_bgScrollView) {
        _bgScrollView = [[UIScrollView alloc]initWithFrame:CGRectZero];
        _bgScrollView.delegate = self;
        _bgScrollView.pagingEnabled = YES;
        _bgScrollView.contentSize = CGSizeMake(5 * SCREEN_WIDTH, 0);
        _bgScrollView.backgroundColor = UIColorFromHEX(0xf5f5f5, 1);
        _bgScrollView.showsVerticalScrollIndicator = NO;
        _bgScrollView.showsHorizontalScrollIndicator = NO;
        _bgScrollView.bounces = NO;
    }
    return _bgScrollView;
}
- (HMSegmentedControl *)segmentController{
    if (!_segmentController) {
        
        /*
        //设置图片(普通)
        NSArray<UIImage *> *images = @[
                                       [UIImage imageNamed:@"TumorOrder_All_Nor"],
                                       [UIImage imageNamed:@"TumorOrder_Unpaid_Nor"],
                                        [UIImage imageNamed:@"TumorOrder_Pay_Nor"],
                                        [UIImage imageNamed:@"TumorOrder_Finesh_Nor"],
                                        [UIImage imageNamed:@"TumorOrder_Cancel_Nor"],
                                       ];
        
        
        //选中状态下的图片
        NSArray<UIImage *> *selectedImages = @[
                                               [UIImage imageNamed:@"TumorOrder_All_Sel"],
                                               [UIImage imageNamed:@"TumorOrder_Unpaid_Sel"],
                                                [UIImage imageNamed:@"TumorOrder_Pay_Sel"],
                                                [UIImage imageNamed:@"TumorOrder_Finesh_Sel"],
                                               [UIImage imageNamed:@"TumorOrder_Cancel_Sel"]
                                               ];
        
        */
        _segmentController = [[HMSegmentedControl alloc]initWithSectionTitles:@[@"全部",@"已支付",@"未支付",@"已完成",@"已取消"]];
        
        _segmentController.frame = CGRectMake(0, 0, SCREEN_WIDTH, kSEGMENTEDCONTROL_HEIGHT);
        
        
        //设置底部下划线的高度
        _segmentController.selectionIndicatorHeight = 2;
        
        //设置底部下划线的颜色
        _segmentController.selectionIndicatorColor = UIColorFromHEX(0x29ccbf, 1);
        
        //设置边框
        _segmentController.layer.borderColor = UIColorFromHEX(0xe0e0e0, 1).CGColor;
        _segmentController.layer.borderWidth = 0.5;
        _segmentController.layer.masksToBounds = YES;
        
        
        //设置底下的线和文字一样大
        _segmentController.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
        //设置线的位置
        _segmentController.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        
        //设置文字颜色及字体
        _segmentController.titleTextAttributes = @{NSForegroundColorAttributeName : UIColorFromHEX(0x333333, 1),
                                                   NSFontAttributeName : [UIFont systemFontOfSize:15]};
        _segmentController.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor gradientFromColor:UIColorFromHEX(0x29ccbf, 1) toColor:UIColorFromHEX(0x6ccc56, 1) withHeight:15],
                                                           NSFontAttributeName :[UIFont systemFontOfSize:15]};
        
        
        
        
        //添加点击事件
        [_segmentController addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
        
    }
    return _segmentController;
}



- (void)dealloc{
    
    DDLogDebug(@"%s",__func__);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
