//
//  BATDoctorStudioOrderListViewController.m
//  HealthBAT_Pro
//
//  Created by KM on 17/4/122017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDoctorStudioOrderListViewController.h"
#import "DLTabedSlideView.h"
#import "BATDoctorStudioVideoListViewController.h"
#import "BATDoctorStudioTextImageViewController.h"

@interface BATDoctorStudioOrderListViewController ()<DLTabedSlideViewDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) DLTabedSlideView *topSlideView;

@end

@implementation BATDoctorStudioOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"医生工作室订单";
    [self pagesLayout];
    
}

#pragma mark - DLTabedSlideViewDelegate
- (NSInteger)numberOfTabsInDLTabedSlideView:(DLTabedSlideView *)sender{
    
    return 2;
}

- (UIViewController *)DLTabedSlideView:(DLTabedSlideView *)sender controllerAt:(NSInteger)index{
    switch (index) {
            case 0:
        {
            BATDoctorStudioTextImageViewController *textImageListVC = [[BATDoctorStudioTextImageViewController alloc] init];
            return textImageListVC;
        }
            break;
            case 1:
        {
            BATDoctorStudioVideoListViewController *videoListVC = [[BATDoctorStudioVideoListViewController alloc] init];
            return videoListVC;
        }
            break;
        default:
            return [UIViewController new];
            break;
    }
}

- (void)DLTabedSlideView:(DLTabedSlideView *)sender didSelectedAt:(NSInteger)index {
    
    
}

#pragma mark - 

- (void)setTopTabSelected:(NSInteger)selected {
    
    self.topSlideView.selectedIndex = selected;
}

#pragma mark - Layout
- (void)pagesLayout {
    
    [self.view addSubview:self.topSlideView];
}

- (DLTabedSlideView *)topSlideView {
    if (!_topSlideView) {
        _topSlideView = [[DLTabedSlideView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _topSlideView.delegate = self;
        _topSlideView.baseViewController = self;
        _topSlideView.tabItemNormalColor = UIColorFromHEX(0x333333, 1);
        _topSlideView.tabItemSelectedColor = BASE_COLOR;
        _topSlideView.backgroundColor = [UIColor whiteColor];
        _topSlideView.tabbarTrackColor = START_COLOR;
        _topSlideView.tabbarBottomSpacing = 0.0;
        _topSlideView.tabbarBottomWidth = 100;
        DLTabedbarItem *item1 = [DLTabedbarItem itemWithTitle:@"" image:[UIImage imageNamed:@"图文咨询b"] selectedImage:[UIImage imageNamed:@"图文咨询"]];
        DLTabedbarItem *item3 = [DLTabedbarItem itemWithTitle:@"" image:[UIImage imageNamed:@"视频语音b"] selectedImage:[UIImage imageNamed:@"视频语音"]];
        _topSlideView.tabbarItems = @[item1, item3];
        [_topSlideView buildTabbar];
        _topSlideView.selectedIndex = 0;
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
