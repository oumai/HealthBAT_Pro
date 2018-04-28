//
//  BATHealthPlanViewController.m
//  HealthBAT_Pro
//
//  Created by Skybrim on 2017/3/20.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHealthPlanViewController.h"
#import "DLTabedSlideView.h"


@interface BATHealthPlanViewController ()<DLTabedSlideViewDelegate>

@property (nonatomic,strong) DLTabedSlideView *topSlideView;


@end

@implementation BATHealthPlanViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"健康计划";
    [self pagesLayout];
    
    if (self.type) {
        [self.topSlideView setSelectedIndex:self.type-1];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - DLTabedSlideViewDelegate
- (NSInteger)numberOfTabsInDLTabedSlideView:(DLTabedSlideView *)sender{
    return 3;
}
- (UIViewController *)DLTabedSlideView:(DLTabedSlideView *)sender controllerAt:(NSInteger)index{
    switch (index) {
        case 0:
        {
            BATHealthPlanDetailViewController *VC = [[BATHealthPlanDetailViewController alloc] init];
            VC.title = @"塑形";
            VC.type = BATHealthPlanMoulding;
           
            
            return VC;
        }

        case 1:
        {
            BATHealthPlanDetailViewController *VC = [[BATHealthPlanDetailViewController alloc] init];
            VC.title = @"健身";
            VC.type = BATHealthPlanBodyBuilding;

            return VC;
            
        }
        case 2:
        {
            BATHealthPlanDetailViewController *VC = [[BATHealthPlanDetailViewController alloc] init];
            VC.title = @"养生";
            VC.type = BATHealthPlanRegimen;

            return VC;
        }
            
        default:
            return nil;
    }
}

- (void)DLTabedSlideView:(DLTabedSlideView *)sender didSelectedAt:(NSInteger)index {

}


#pragma mark - pagesLayout
- (void)pagesLayout {
    
    [self.view addSubview:self.topSlideView];
}

#pragma mark - getter
- (DLTabedSlideView *)topSlideView {
    if (!_topSlideView) {
        _topSlideView = [[DLTabedSlideView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _topSlideView.delegate = self;
        _topSlideView.baseViewController = self;
        _topSlideView.tabItemNormalColor = UIColorFromHEX(0x333333, 1);
        _topSlideView.tabItemSelectedColor = BASE_COLOR;
        _topSlideView.backgroundColor = [UIColor whiteColor];
        _topSlideView.tabbarTrackColor = BASE_COLOR;
        _topSlideView.tabbarBottomSpacing = 0.0;
        _topSlideView.tabbarBottomWidth = 100;
        DLTabedbarItem *item1 = [DLTabedbarItem itemWithTitle:@"塑形" image:nil selectedImage:nil];
        DLTabedbarItem *item2 = [DLTabedbarItem itemWithTitle:@"健身" image:nil selectedImage:nil];
        DLTabedbarItem *item3 = [DLTabedbarItem itemWithTitle:@"养生" image:nil selectedImage:nil];
        _topSlideView.tabbarItems = @[item1, item2, item3];
        [_topSlideView buildTabbar];
        _topSlideView.selectedIndex = 0;
    }
    return _topSlideView;
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
