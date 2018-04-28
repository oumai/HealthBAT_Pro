//
//  HealthMomentsViewController.m
//  HealthBAT_Pro
//
//  Created by KM on 16/7/62016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATHealthMomentsViewController.h"
#import "DLTabedSlideView.h"
#import "BATMyFocusViewController.h"
#import "BATMyGroupViewController.h"
#import "BATFindViewController.h"
#import "BATSendDynamicViewController.h"
//#import "BATDieaseSymptomDetailController.h"
@interface BATHealthMomentsViewController ()<DLTabedSlideViewDelegate>

@property (nonatomic,strong) DLTabedSlideView *topSlideView;

@property (nonatomic,strong) UIBarButtonItem * clearButton;
@property (nonatomic,strong) UIBarButtonItem * rightButton;

@end

@implementation BATHealthMomentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"我的圈子";
    
    [self pagesLayout];
    
    
//    self.navigationItem.rightBarButtonItem = self.rightButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - DLTabedSlideViewDelegate
- (NSInteger)numberOfTabsInDLTabedSlideView:(DLTabedSlideView *)sender{
//    return 3;
    return 2;

}
- (UIViewController *)DLTabedSlideView:(DLTabedSlideView *)sender controllerAt:(NSInteger)index{
    switch (index) {
        case 0:
        {
            BATMyFocusViewController * myFocusVC = [[BATMyFocusViewController alloc] init];
            myFocusVC.type = kAll;
            return myFocusVC;
        }
//        case 1:
//        {
//            BATMyGroupViewController * myGroupVC = [[BATMyGroupViewController alloc] init];
//
//            return myGroupVC;
//        }
        case 1:
        {
            BATFindViewController *findVC = [[BATFindViewController alloc] init];
            return findVC;
        }

        default:
            return nil;
    }
}

- (void)DLTabedSlideView:(DLTabedSlideView *)sender didSelectedAt:(NSInteger)index {
//    if (index == 1 || index == 2) {
//        self.navigationItem.rightBarButtonItem = self.clearButton;
//    }
//    else {
//        self.navigationItem.rightBarButtonItem = self.rightButton;
//    }
}

#pragma mark - action
-(void)chooseShowDynamic{
    
    UIAlertController * action = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *allAction = [UIAlertAction actionWithTitle:@"全部" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSNotificationCenter defaultCenter] postNotificationName:BATRefreshDynamicListNotification object:@{@"CategoryId":@(kAll)} userInfo:nil];
        
    }];
    UIAlertAction *dynamicAction = [UIAlertAction actionWithTitle:@"动态" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSNotificationCenter defaultCenter] postNotificationName:BATRefreshDynamicListNotification object:@{@"CategoryId":@(kMoment)} userInfo:nil];
        
    }];
    UIAlertAction *questionAction = [UIAlertAction actionWithTitle:@"问题" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSNotificationCenter defaultCenter] postNotificationName:BATRefreshDynamicListNotification object:@{@"CategoryId":@(kQusetion)} userInfo:nil];
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [action addAction:allAction];
    [action addAction:dynamicAction];
    [action addAction:questionAction];
    [action addAction:cancelAction];
    
    [self presentViewController:action animated:YES completion:nil];
    
}

#pragma mark - Layout
- (void)pagesLayout {

    [self.view addSubview:self.topSlideView];
    
    WEAK_SELF(self);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"icon-bj"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        STRONG_SELF(self);
        BATSendDynamicViewController *dynamicVC = [[BATSendDynamicViewController alloc]init];
        
        [self.navigationController pushViewController:dynamicVC animated:YES];
    }];
}

#pragma mark - setter && getter

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
        DLTabedbarItem *item1 = [DLTabedbarItem itemWithTitle:@"动态" image:nil selectedImage:nil];
//        DLTabedbarItem *item2 = [DLTabedbarItem itemWithTitle:@"群组" image:nil selectedImage:nil];
        DLTabedbarItem *item3 = [DLTabedbarItem itemWithTitle:@"发现" image:nil selectedImage:nil];
//        _topSlideView.tabbarItems = @[item1, item2, item3];
        _topSlideView.tabbarItems = @[item1, item3];
        [_topSlideView buildTabbar];
        _topSlideView.selectedIndex = 0;
    }
    return _topSlideView;
}

- (UIBarButtonItem *)clearButton {
    if (!_clearButton) {
        _clearButton = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:nil];
    }
    return _clearButton;
}

- (UIBarButtonItem *)rightButton {
    if (!_rightButton) {
        _rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-icon42"] style:UIBarButtonItemStylePlain target:self action:@selector(chooseShowDynamic)];
    }
    return _rightButton;
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
