//
//  RootTabBarController.m
//  News
//
//  Created by KM on 16/5/62016.
//  Copyright © 2016年 skyrim. All rights reserved.
//

#import "BATRootTabBarController.h"

#import "BATHomeViewController.h"
#import "BATHealthMomentsViewController.h"
//#import "BATConsultationViewController.h"
//#import "BATOnlineLearningViewController.h"
//#import "BATOnlineLearningIndexViewController.h"
//#import "BATHealthFollowViewController.h"
#import "BATHealthFollowController.h"
#import "BATHealthDocumentsViewController.h"

#import "BATMeViewController.h"
#import "BATConsultationIndexViewController.h"

#import "BATVisitConfigModel.h"

@interface BATRootTabBarController ()<UITabBarControllerDelegate>

@property (nonatomic,strong) UIViewController *lastVC;

@end

@implementation BATRootTabBarController

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(configRequest) name:@"APPLICATION_CONFIG_REQUEST" object:nil];

    self.title = @"首页";
    [self setupViewControllers];
    self.delegate = self;

    self.tabBar.tintColor = [UIColor whiteColor];
    
    [self configRequest];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupViewControllers{
    
    BATHomeViewController *homeVC = [BATHomeViewController new];
    UINavigationController * homeNav = [[UINavigationController alloc] initWithRootViewController:homeVC];
    
//    BATHealthMomentsViewController * healthMomentsVC = [BATHealthMomentsViewController new];
//    UINavigationController * healthMomentsNav = [[UINavigationController alloc] initWithRootViewController:healthMomentsVC];
    
//    BATOnlineLearningViewController *onlineLearningVC = [BATOnlineLearningViewController new];
//    UINavigationController *onlineLearningNav = [[UINavigationController alloc] initWithRootViewController:onlineLearningVC];
    
//    BATOnlineLearningIndexViewController *onlineLearningIndexVC = [BATOnlineLearningIndexViewController new];
//    UINavigationController *onlineLearningNav = [[UINavigationController alloc] initWithRootViewController:onlineLearningIndexVC];
    
//    BATHealthFollowViewController *healthFollowVC = [BATHealthFollowViewController new];
    
    //新关注界面
    BATHealthFollowController *healthFollowVC = [[BATHealthFollowController alloc]init];
    
    UINavigationController *healthFollowNav = [[UINavigationController alloc] initWithRootViewController:healthFollowVC];

    
    //    BATConsultationViewController * consulationVC = [BATConsultationViewController new];
    //    UINavigationController * consulationNav = [[UINavigationController alloc] initWithRootViewController:consulationVC];
    BATConsultationIndexViewController * consulationVC = [BATConsultationIndexViewController new];
    UINavigationController * consulationNav = [[UINavigationController alloc] initWithRootViewController:consulationVC];
    
    BATHealthDocumentsViewController * healthDocumentsVC = [BATHealthDocumentsViewController new];
    UINavigationController * healthDocumentsNav = [[UINavigationController alloc] initWithRootViewController:healthDocumentsVC];
    
    
    BATMeViewController * meVC = [BATMeViewController new];
    UINavigationController * meNav = [[UINavigationController alloc] initWithRootViewController:meVC];
    
    self.viewControllers = @[homeNav, healthFollowNav, healthDocumentsNav, consulationNav, meNav];
    
//    self.viewControllers = @[homeNav, onlineLearningNav, consulationNav, meNav];
    
//    self.viewControllers = @[homeNav, healthMomentsNav, consulationNav, meNav];
    
    [self customizeTabBarForController];
    
}

- (void)customizeTabBarForController {
    //选项卡图片
//    NSArray *tabBarItemImages = @[@"Home", @"HealthMoments", @"Consultation", @"Me"];
//    NSArray *tabBarItemImages = @[@"Home", @"OnlineLearning", @"Consultation", @"Me"];
    NSArray *tabBarItemImages = @[@"Home", @"HealthFollow", @"HealthDocuments", @"Consultation", @"Me"];
    //选项卡标题
//    NSArray *tabBarItemTitles = @[@"首页", @"健康圈", @"咨询", @"个人中心"];
//    NSArray *tabBarItemTitles = @[@"首页", @"学习", @"咨询", @"个人中心"];
    NSArray *tabBarItemTitles = @[@"首页", @"关注", @"健康360", @"咨询", @"个人中心"];
    NSInteger index = 0;
    for (UIViewController * vc in self.viewControllers) {
        
        UITabBarItem * item = vc.tabBarItem;
        
        item.selectedImage = [[UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",[tabBarItemImages objectAtIndex:index]]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];;
        item.image = [[UIImage imageNamed:[NSString stringWithFormat:@"%@_normal",[tabBarItemImages objectAtIndex:index]]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.title = [tabBarItemTitles objectAtIndex:index];
        [item setTitleTextAttributes:@{
                                       NSFontAttributeName: [UIFont systemFontOfSize:13],
                                       NSForegroundColorAttributeName:STRING_LIGHT_COLOR,
                                       }
                            forState:UIControlStateNormal];
        [item setTitleTextAttributes:@{
                                       NSFontAttributeName: [UIFont systemFontOfSize:13],
                                       NSForegroundColorAttributeName:START_COLOR,
                                       }
                            forState:UIControlStateSelected];
        index ++;
    }
}

- (void)configRequest {
    
    [HTTPTool requestWithURLString:@"/api/Common/GetVisitConfig" parameters:nil type:kGET success:^(id responseObject) {
        BATVisitConfigModel *visitConfigModel = [BATVisitConfigModel mj_objectWithKeyValues:responseObject];
        [[NSUserDefaults standardUserDefaults] setBool:visitConfigModel.CanConsult forKey:@"CanConsult"];
        [[NSUserDefaults standardUserDefaults] setBool:visitConfigModel.CanRegister forKey:@"CanRegister"];
        [[NSUserDefaults standardUserDefaults] setBool:visitConfigModel.CanVisitShop forKey:@"CanVisitShop"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    } failure:^(NSError *error) {
        
    }];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    

    
    NSInteger selectedIndex = [tabBarController.viewControllers indexOfObject:viewController];


    if (!LOGIN_STATION && selectedIndex == 2) {
        PRESENT_LOGIN_VC;
        return NO;
    }

    
//    if (selectedIndex == 1) {
//        [self saveOperateModule:selectedIndex];
//        //进入健康圈。判断登录
//        if (!LOGIN_STATION) {
//            PRESENT_LOGIN_VC;
//            return NO;
//        }
//    }
    
    if (selectedIndex == 3) {
        [self saveOperateModule:selectedIndex];
    }
    
    if (self.lastVC != viewController) {
        
        //第一次点击
        self.lastVC = viewController;
        
        return YES;
    }
    
    //第二次点击，刷新当前页面
    NSString *notiName = @"";
    UINavigationController *nav = (UINavigationController *)viewController;
    
    if ([nav.viewControllers[0] isMemberOfClass:[BATHomeViewController class]]) {
        notiName = @"Home";
    }
//    if ([nav.viewControllers[0] isKindOfClass:[BATOnlineLearningIndexViewController class]]) {
//        notiName = @"OnlineLearning";
//    }
    if ([nav.viewControllers[0] isKindOfClass:[BATHealthFollowController class]]) {
        notiName = @"HealthFollow";
    }
//    if ([nav.viewControllers[0] isKindOfClass:[BATHealthMomentsViewController class]]) {
//        notiName = @"HealthMoments";
//    }
    //    if ([nav.viewControllers[0] isKindOfClass:[BATConsultationViewController class]]) {
    //        notiName = @"Consultation";
    //    }
    if ([nav.viewControllers[0] isKindOfClass:[BATConsultationIndexViewController class]]) {
        notiName = @"Consultation";
    }
    if ([nav.viewControllers[0] isKindOfClass:[BATMeViewController class]]) {
        notiName = @"Me";
    }
    if ([nav.viewControllers[0] isKindOfClass:[BATHealthDocumentsViewController class]]) {
        notiName = @"HealthDociments";
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:notiName object:nil];
    
    return YES;
}

-(void)saveOperateModule:(NSInteger)tag {
    /*
     NSMutableDictionary *dict = [NSMutableDictionary dictionary];
     [dict setValue:[Tools getPostUUID] forKey:@"deviceNo"];
     [dict setValue:@(1) forKey:@"deviceType"];
     if (LOGIN_STATION) {
     [dict setValue:[Tools getCurrentID] forKey:@"userId"];
     }
     NSString *ipString = [Tools get4GorWIFIAddress];
     [dict setValue:ipString forKey:@"userIp"];
     if (tag==1) {
     [dict setValue:@"健康圈" forKey:@"moduleName"];
     [dict setValue:@(2) forKey:@"moduleId"];
     }else if(tag==3){
     [dict setValue:@"个人中心" forKey:@"moduleName"];
     [dict setValue:@(4) forKey:@"moduleId"];
     }
     
     
     [dict setValue:[Tools getCurrentDateStringByFormat:@"yyyy-MM-dd HH:mm:ss"] forKey:@"createdTime"];
     [dict setValue:[Tools getCurrentDateStringByFormat:@"yyyy-MM-dd HH:mm:ss"] forKey:@"leaveTime"];
     //获取ip
     [HTTPTool requestWithSearchURLString:@"/kmStatistical-sync/saveOperateModule" parameters:dict success:^(id responseObject) {
     
     } failure:^(NSError *error) {
     
     }];*/
    NSString *moduleName = nil;
    NSInteger moduleId = 0;
    if (tag == 1) {
        moduleName =@"健康圈";
        moduleId = 2;
    }else if(tag == 3){
        moduleId = 4;
        moduleName =@"个人中心";
    }
    [BATUserPortrayTools saveOperateModuleRequestWithURL:@"/kmStatistical-sync/saveOperateModule" pathName:moduleName moduleId:moduleId beginTime:[Tools getCurrentDateStringByFormat:@"yyyy-MM-dd HH:mm:ss"]];
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
