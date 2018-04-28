//
//  BATProgramViewController.m
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/6/8.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATProgramViewController.h"
#import "BATProgramListViewController.h"
#import "HMSegmentedControl.h"
@interface BATProgramViewController ()<UIScrollViewDelegate>
/** 分段 */
@property (nonatomic, strong) HMSegmentedControl *segmentController;
/** UIScrollView */
@property (nonatomic, strong) UIScrollView *bgScrollView;
/** 方案类型 */
@property (nonatomic, assign) BATHealtFocusProgramType  ProgramType;
@end

@implementation BATProgramViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"健康方案";
    [self.view addSubview:self.segmentController];
    [self.view addSubview:self.bgScrollView];
    [self addChildVc];
    
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    [self.segmentController mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.equalTo(@45);
    }];
    
    [self.bgScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.segmentController.mas_bottom);
        make.left.right.bottom.mas_equalTo(0);
    }];
}
/**
 添加子控制器及 view
 */
- (void)addChildVc{
    
    // 方案类型枚举 1：养生 2：减肥 3：美容  4: 塑形
    BATProgramListViewController *programVc1 = [[BATProgramListViewController alloc]init];
    BATProgramListViewController *programVc2 = [[BATProgramListViewController alloc]init];
    BATProgramListViewController *programVc3 = [[BATProgramListViewController alloc]init];
    BATProgramListViewController *programVc4 = [[BATProgramListViewController alloc]init];
    
    programVc1.programType= kBATHealtFocusProgramType_KeepHealth;
    programVc2.programType= kBATHealtFocusProgramType_LoseWeight;
    programVc3.programType= kBATHealtFocusProgramType_Beauty;
    programVc4.programType= kBATHealtFocusProgramType_CurvyBody;
    
    [self addChildViewController:programVc1];
    [self addChildViewController:programVc2];
    [self addChildViewController:programVc3];
    [self addChildViewController:programVc4];
    
    
    //主动调用滚动到第一个界面
    [self scrollViewDidEndScrollingAnimation:self.bgScrollView];
    
    
}

#pragma mark - UIScrolllViewDelegate
/**
 * 当滚动动画完毕的时候调用（通过代码setContentOffset:animated:让scrollView滚动完毕后，就会调用这个方法）
 * 如果执行完setContentOffset:animated:后，scrollView的偏移量并没有发生改变的话，就不会调用scrollViewDidEndScrollingAnimation:方法
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    
    int index = scrollView.contentOffset.x / SCREEN_WIDTH;
    UIViewController *willShowChildVc = self.childViewControllers[index];
    
    if (willShowChildVc.isViewLoaded) return;
    
    willShowChildVc.view.frame = scrollView.bounds;
    [scrollView addSubview:willShowChildVc.view];
}
/**
 停止减速时调用
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
    //计算页码
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    [self.segmentController setSelectedSegmentIndex:page animated:YES];
    
}
/**
 拖动结束，手从屏幕上抬起的一刹那，会执行这个方法,防止用户刚好拖到边界停止
 */
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(!decelerate){  //手指离开，恰好不再减速执行
        [self scrollViewDidEndDecelerating:scrollView];
    }
}
#pragma mark - HMSegmentedControl

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentCtr{
    
    [self.bgScrollView setContentOffset:CGPointMake(SCREEN_WIDTH * segmentCtr.selectedSegmentIndex, 0) animated:YES];
    
}

#pragma mark - lazy Load

- (UIScrollView *)bgScrollView{
    if (!_bgScrollView) {
        _bgScrollView = [[UIScrollView alloc]initWithFrame:CGRectZero];
        /*
        if(@available(iOS 11.0, *)) {
            _bgScrollView.frame = CGRectMake(0, CGRectGetMaxY(self.segmentController.frame), SCREEN_WIDTH, SCREEN_HEIGHT - 88 - CGRectGetHeight(self.segmentController.frame));
        }else{
            
            _bgScrollView.frame = CGRectMake(0, CGRectGetMaxY(self.segmentController.frame), SCREEN_WIDTH, SCREEN_HEIGHT - 64 - CGRectGetHeight(self.segmentController.frame));
        }
         */
        _bgScrollView.delegate = self;
        _bgScrollView.pagingEnabled = YES;
        _bgScrollView.contentSize = CGSizeMake(4 * SCREEN_WIDTH, 0);
        _bgScrollView.backgroundColor = [UIColor whiteColor];
        _bgScrollView.showsVerticalScrollIndicator = NO;
        _bgScrollView.showsHorizontalScrollIndicator = NO;
        _bgScrollView.bounces = NO;
    }
    return _bgScrollView;
}
- (HMSegmentedControl *)segmentController{
    if (!_segmentController) {
        
        NSArray<UIImage *> *images = @[
                                       [UIImage imageNamed:@"Follow_KeepHealth_SegCtr_Nor"],
                                       [UIImage imageNamed:@"Follow_loseWeight_SegCtr_Nor"],
                                       [UIImage imageNamed:@"Follow_Beauty_SegCtr_Nor"],
                                       [UIImage imageNamed:@"Follow_SuXing_SegCtr_Nor"]
                                       ];
        
        //选中状态下的图片
        NSArray<UIImage *> *selectedImages = @[
                                               [UIImage imageNamed:@"Follow_KeepHealth_SegCtr_Sel"],
                                               [UIImage imageNamed:@"Follow_loseWeight_SegCtr_Sel"],
                                               [UIImage imageNamed:@"Follow_Beauty_SegCtr_Sel"],
                                               [UIImage imageNamed:@"Follow_SuXing_SegCtr_Sel"]
                                               
                                               ];
        _segmentController = [[HMSegmentedControl alloc] initWithSectionImages:images sectionSelectedImages:selectedImages];
        
        _segmentController.frame = CGRectMake(0, 0, SCREEN_WIDTH, 45);
        
        //设置边框
        _segmentController.layer.borderColor = UIColorFromHEX(0xe0e0e0, 1).CGColor;
        _segmentController.layer.borderWidth = 0.5;
        _segmentController.layer.masksToBounds = YES;
        
        //设置底部下划线的高度
        _segmentController.selectionIndicatorHeight = 2;
        
        //设置底部下划线的颜色
        _segmentController.selectionIndicatorColor = UIColorFromHEX(0x29ccbf, 1);
        
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
    
    DDLogDebug(@"%s",__func__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
