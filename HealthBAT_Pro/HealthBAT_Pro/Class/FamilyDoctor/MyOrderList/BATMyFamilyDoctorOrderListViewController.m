//
//  BATMyFamilyDoctorOrderListViewController.m
//  HealthBAT_Pro
//
//  Created by four on 17/3/16.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATMyFamilyDoctorOrderListViewController.h"

#import "DLTabedSlideView.h"
#import "BATSegmentControl.h"

#import "BATFamilyDocotrWaitEvaluationViewController.h"
#import "BATFamilyDocotrWaitPayViewController.h"
#import "BATFamilyDocotrWaitAcceptViewController.h"
#import "BATFamilyDoctorAllOrderViewController.h"
#import "BATFamilyDoctorWaitServiceViewController.h"

@interface BATMyFamilyDoctorOrderListViewController ()<DLTabedSlideViewDelegate,BATSegmentControlDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) DLTabedSlideView *topSlideView;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic, strong) BATSegmentControl *segmentControl;

@end

@implementation BATMyFamilyDoctorOrderListViewController

- (void)delloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"家庭服务订单";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadSelectItemIndex) name:@"PaySuccess_popWaitService" object:nil];
    
//    [self pagesLayout];
    [self addSubViewControl];
    [self.view addSubview:self.segmentControl];
    [self.view addSubview:self.scrollView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}
- (void)addSubViewControl{

    
    BATFamilyDoctorAllOrderViewController * VC1 = [[BATFamilyDoctorAllOrderViewController alloc] init];
    VC1.view.frame = CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);

    BATFamilyDocotrWaitAcceptViewController *VC2 = [[BATFamilyDocotrWaitAcceptViewController alloc] init];
    VC2.view.frame = CGRectMake(SCREEN_WIDTH, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);

    BATFamilyDocotrWaitPayViewController * VC3 = [[BATFamilyDocotrWaitPayViewController alloc] init];
    VC3.view.frame = CGRectMake(SCREEN_WIDTH *2, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);

    BATFamilyDoctorWaitServiceViewController * VC4 = [[BATFamilyDoctorWaitServiceViewController alloc] init];
    VC4.view.frame = CGRectMake(SCREEN_WIDTH *3, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);

    BATFamilyDocotrWaitEvaluationViewController * VC5 = [[BATFamilyDocotrWaitEvaluationViewController alloc] init];
    VC5.view.frame = CGRectMake(SCREEN_WIDTH *4, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    
        [self addChildViewController:VC1];
        [self addChildViewController:VC2];
        [self addChildViewController:VC3];
        [self addChildViewController:VC4];
        [self addChildViewController:VC5];
    
        [self.scrollView addSubview:VC1.view];
        [self.scrollView addSubview:VC2.view];
        [self.scrollView addSubview:VC3.view];
        [self.scrollView addSubview:VC4.view];
        [self.scrollView addSubview:VC5.view];
    




}
#pragma mark - setter && getter
- (UIScrollView *)scrollView{
    if(!_scrollView){
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - CGRectGetMaxY(self.segmentControl.frame))];
        _scrollView.contentSize = CGSizeMake( SCREEN_WIDTH * 5, 0);
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.backgroundColor = [UIColor grayColor];
        
    }
    return _scrollView;
}
- (BATSegmentControl *)segmentControl{
    if (!_segmentControl) {
        _segmentControl = [[BATSegmentControl alloc]initWithItems:@[@"全部",@"等待接单",@"待付款",@"待服务",@"待评价"]];
        _segmentControl.frame = CGRectMake(0, 0, SCREEN_WIDTH, 45);
        _segmentControl.backgroundColor = [UIColor whiteColor];
        _segmentControl.delegate = self;
    }
    return _segmentControl;
}
#pragma UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger page = (scrollView.contentOffset.x / scrollView.frame.size.width);
    
    self.segmentControl.selectedIndex = page;
}

#pragma BATSegmentControlDelagat
- (void)batSegmentedControl:(BATSegmentControl *)segmentedControl selectedIndex:(NSInteger)index{
    
    //    NSLog(@"%ld----",index);
    [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * index, 0) animated:YES];
}

- (void)reloadSelectItemIndex{
    self.topSlideView.selectedIndex = 2;
}


#pragma mark - DLTabedSlideViewDelegate
- (NSInteger)numberOfTabsInDLTabedSlideView:(DLTabedSlideView *)sender{
    return 5;
}
- (UIViewController *)DLTabedSlideView:(DLTabedSlideView *)sender controllerAt:(NSInteger)index{
    switch (index) {
        case 0:
        {
            BATFamilyDoctorAllOrderViewController * familydoctorVC = [[BATFamilyDoctorAllOrderViewController alloc] init];
            return familydoctorVC;
        }
        case 1:
        {
            BATFamilyDocotrWaitAcceptViewController * familydoctorVC = [[BATFamilyDocotrWaitAcceptViewController alloc] init];
            return familydoctorVC;
        }
        case 2:
        {
            BATFamilyDocotrWaitPayViewController * familydoctorVC = [[BATFamilyDocotrWaitPayViewController alloc] init];
            return familydoctorVC;
        }
        case 3:
        {
            BATFamilyDoctorWaitServiceViewController * familydoctorVC = [[BATFamilyDoctorWaitServiceViewController alloc] init];
            return familydoctorVC;
        }
        case 4:
        {
            BATFamilyDocotrWaitEvaluationViewController * familydoctorVC = [[BATFamilyDocotrWaitEvaluationViewController alloc] init];
            return familydoctorVC;
        }
            
        default:
            return nil;
    }
}


//#pragma mark - action
//-(void)chooseShowDynamic{
//    
//    UIAlertController * action = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//    UIAlertAction *allOrder = [UIAlertAction actionWithTitle:@"全部" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        
//    }];
//    UIAlertAction *waitAccpet = [UIAlertAction actionWithTitle:@"等待接单" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        
//    }];
//    UIAlertAction *waitPay = [UIAlertAction actionWithTitle:@"待付款" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        
//    }];
//    UIAlertAction *waitSerice = [UIAlertAction actionWithTitle:@"待服务" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        
//    }];
//    UIAlertAction *waitEvaulation = [UIAlertAction actionWithTitle:@"待评价" style:UIAlertActionStyleCancel handler:nil];
//    
//    [action addAction:allOrder];
//    [action addAction:waitAccpet];
//    [action addAction:waitPay];
//    [action addAction:waitSerice];
//    [action addAction:waitEvaulation];
//    
//    [self presentViewController:action animated:YES completion:nil];
//    
//}

#pragma mark - Layout
- (void)pagesLayout {
    
    self.title = @"家庭服务订单";
    self.view.backgroundColor = BASE_BACKGROUND_COLOR;
    [self.view addSubview:self.topSlideView];
}

#pragma mark - setter && getter

- (DLTabedSlideView *)topSlideView {
    if (!_topSlideView) {
        _topSlideView = [[DLTabedSlideView alloc] initWithFrame:CGRectMake(0, 1, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _topSlideView.delegate = self;
        _topSlideView.baseViewController = self;
        _topSlideView.tabItemNormalColor = [UIColor blackColor];
        _topSlideView.tabItemSelectedColor = BASE_COLOR;
        _topSlideView.backgroundColor = [UIColor whiteColor];
        _topSlideView.tabbarTrackColor = BASE_COLOR;
        _topSlideView.tabbarBottomSpacing = 0.0;
        DLTabedbarItem *item1 = [DLTabedbarItem itemWithTitle:@"全部" image:nil selectedImage:nil];
        DLTabedbarItem *item2 = [DLTabedbarItem itemWithTitle:@"等待接单" image:nil selectedImage:nil];
        DLTabedbarItem *item3 = [DLTabedbarItem itemWithTitle:@"待付款" image:nil selectedImage:nil];
        DLTabedbarItem *item4 = [DLTabedbarItem itemWithTitle:@"待服务" image:nil selectedImage:nil];
        DLTabedbarItem *item5 = [DLTabedbarItem itemWithTitle:@"待评价" image:nil selectedImage:nil];
        _topSlideView.tabbarItems = @[item1, item2, item3,item4,item5];
        [_topSlideView buildTabbar];
        _topSlideView.selectedIndex = self.selectedIndex;
    }
    return _topSlideView;
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

@end
