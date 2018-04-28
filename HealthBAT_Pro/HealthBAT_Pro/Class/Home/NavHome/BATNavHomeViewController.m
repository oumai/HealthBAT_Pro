//
//  BATNavHomeViewController.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/9/12.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATNavHomeViewController.h"
#import "UIViewController+BATIsFromRoundGuide.h"

#import "BATHomeViewController.h"
#import "BATHealthFollowController.h"
#import "BATHealthDocumentsViewController.h"
#import "BATConsultationIndexViewController.h"
#import "BATMeViewController.h"

#import "BATHealth360EvaluationViewController.h"

@interface BATNavHomeViewController ()

@property (nonatomic,assign) CGPoint beginPoint;

@property (nonatomic,assign) CGPoint currentPoint;

@property (nonatomic,assign) BATNavHomeAnimateDirection direction;

@property (nonatomic,assign) BOOL isNeedPushEvaluationVC;
@property (nonatomic,assign) BOOL isCurrentVC;

@end

@implementation BATNavHomeViewController

- (void)dealloc {
    
    DDLogDebug(@"%s",__func__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    [self.navHomeView downImageAnimate];
    
//    UITabBarController *tabBarController = (UITabBarController *)[UIApplication sharedApplication].windows[0].rootViewController;
    
    BATAppDelegate *appDelegate = (BATAppDelegate *)[UIApplication sharedApplication].delegate;
    
    for (UIViewController *vc in appDelegate.rootTabBarController.viewControllers) {
        UINavigationController *navVC = (UINavigationController *)vc;
        
//        UIViewController *vc = navVC.viewControllers[0];
//        vc.isFromRoundGuide = NO;
        
        if (navVC.viewControllers.count > 0) {
            
            if ([navVC.viewControllers[0] isKindOfClass:[BATConsultationIndexViewController class]]) {
                BATConsultationIndexViewController *consultationIndexVC = (BATConsultationIndexViewController *)navVC.viewControllers[0];
                consultationIndexVC.isFromRoundGuide = NO;
            } else if ([navVC.viewControllers[0] isKindOfClass:[BATHealthDocumentsViewController class]]) {
                BATHealthDocumentsViewController *healthDocumentsVC = (BATHealthDocumentsViewController *)navVC.viewControllers[0];
                healthDocumentsVC.isFromRoundGuide = NO;
            } else if ([navVC.viewControllers[0] isKindOfClass:[BATHomeViewController class]]) {
                BATHomeViewController *homeVC = (BATHomeViewController *)navVC.viewControllers[0];
                homeVC.isFromRoundGuide = NO;
            } else if ([navVC.viewControllers[0] isKindOfClass:[BATMeViewController class]]) {
                BATMeViewController *meVC = (BATMeViewController *)navVC.viewControllers[0];
                meVC.isFromRoundGuide = NO;
            } else if ([navVC.viewControllers[0] isKindOfClass:[BATHealthFollowController class]]) {
                BATHealthFollowController *healthFollowVC = (BATHealthFollowController *)navVC.viewControllers[0];
                healthFollowVC.isFromRoundGuide = NO;
            }
        }
    }
    
    self.isCurrentVC = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.isCurrentVC = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self pageLayout];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushHealth360EvaluationVC:) name:@"HEALTH_MANAGER_PUSH_360EVALUATION_VC" object:nil];
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


#pragma mark - UITouch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{    
    _beginPoint = [[touches anyObject] locationInView:self.view];
    
    CGPoint point = [self.healthEvaluationVC.view.layer convertPoint:_beginPoint fromLayer:self.view.layer];
    
    if ([self.healthEvaluationVC.view.layer containsPoint:point]) {
        DDLogDebug(@"在下面的界面");
    }
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint currentPoint = [[touches anyObject] locationInView:self.view];
    
    CGPoint point = [self.healthEvaluationVC.view.layer convertPoint:currentPoint fromLayer:self.view.layer];

    if ([self.healthEvaluationVC.view.layer containsPoint:point]) {
        DDLogDebug(@"在下面的界面");
        
        
        if (currentPoint.y > _beginPoint.y) {
            [self animateDirection:BATNavHomeAnimateDirection_Down];
            
        }
        
    }

    
}

#pragma mark - Action
- (void)animateDirection:(BATNavHomeAnimateDirection)direction
{
    [UIView animateWithDuration:1.0f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
//        self.navHomeView.gohomeView.hidden = YES;
//        self.navHomeView.jkdaBtn.hidden = YES;
        
        if (direction == BATNavHomeAnimateDirection_Up) {
            //向上
            
            self.navHomeView.downImageView.hidden = YES;
            
            self.roundVC.view.transform = CGAffineTransformMakeTranslation(0, -SCREEN_HEIGHT);
            self.healthEvaluationVC.view.transform = CGAffineTransformMakeTranslation(0, -SCREEN_HEIGHT);
            
        } else if (direction == BATNavHomeAnimateDirection_Down) {
            //向下
            self.navHomeView.downImageView.hidden = NO;
            
            self.roundVC.view.transform = CGAffineTransformIdentity;
            self.healthEvaluationVC.view.transform = CGAffineTransformIdentity;
        }
        

        
    } completion:^(BOOL finished) {
        
//        self.navHomeView.gohomeView.hidden = NO;
//        self.navHomeView.jkdaBtn.hidden = NO;
    }];
    
    CABasicAnimation *alpha = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alpha.duration = 1.0f;
    alpha.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [alpha setFromValue:[NSNumber numberWithInt:1]];
    [alpha setToValue:[NSNumber numberWithInt:0]];
    
    [self.navHomeView.gohomeView.layer addAnimation:alpha forKey:nil];
    [self.navHomeView.jkdaBtn.layer addAnimation:alpha forKey:nil];
    
}

#pragma mark - pageLayout
- (void)pageLayout
{
    [self.view addSubview:self.navHomeView];
    
    WEAK_SELF(self);
    [self.navHomeView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self.view);
    }];
    
    [self addChildViewController:self.roundVC];
    [self.navHomeView addSubview:self.roundVC.view];
    [self.navHomeView sendSubviewToBack:self.roundVC.view];
    
    [self.roundVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self.navHomeView);
    }];
    
    [self addChildViewController:self.healthEvaluationVC];
    [self.navHomeView addSubview:self.healthEvaluationVC.view];
    [self.navHomeView sendSubviewToBack:self.healthEvaluationVC.view];
    
    [self.healthEvaluationVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(self.navHomeView.mas_bottom);
        make.left.right.equalTo(self.navHomeView);
        make.height.mas_offset(SCREEN_HEIGHT);
    }];
}

#pragma mark - get & set
- (BATNavHomeView *)navHomeView
{
    if (_navHomeView == nil) {
//        _navHomeView = [[BATNavHomeView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _navHomeView = [[BATNavHomeView alloc] init];

        WEAK_SELF(self);
        _navHomeView.downBlock = ^{
            STRONG_SELF(self);
            [self animateDirection:BATNavHomeAnimateDirection_Up];
        };
        
        _navHomeView.goHomeBlock = ^{
            STRONG_SELF(self);
            [self dismissViewControllerAnimated:NO completion:nil];

//            UITabBarController *tabBarController = (UITabBarController *)[UIApplication sharedApplication].windows[0].rootViewController;
            
            BATAppDelegate *appDelegate = (BATAppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate.rootTabBarController setSelectedIndex:0];
            
            UINavigationController *navVC = appDelegate.rootTabBarController.selectedViewController;
            navVC.viewControllers[0].isFromRoundGuide = YES;
            
            BATHomeViewController *homeVC = (BATHomeViewController *)navVC.viewControllers[0];
            [homeVC isShowGuide];
        };
        
        _navHomeView.goJkdaBlock = ^{
            STRONG_SELF(self);
            
            if (!LOGIN_STATION) {
                PRESENT_LOGIN_VC;
                return;
            } else {
                [self dismissViewControllerAnimated:NO completion:nil];
//                UITabBarController *tabBarController = (UITabBarController *)[UIApplication sharedApplication].windows[0].rootViewController;
//                [tabBarController setSelectedIndex:2];

                BATAppDelegate *appDelegate = (BATAppDelegate *)[UIApplication sharedApplication].delegate;
                [appDelegate.rootTabBarController setSelectedIndex:2];
                
                UINavigationController *navVC = appDelegate.rootTabBarController.selectedViewController;
                navVC.viewControllers[0].isFromRoundGuide = YES;
                
                //            BATHealthDocumentsViewController *healthDocumentsVC = (BATHealthDocumentsViewController *)navVC.viewControllers[0];
                //            healthDocumentsVC.isFromRoundGuide = YES;
            }
            
            
        };
    }
    return _navHomeView;
}

- (BATRoundGuideViewController *)roundVC
{
    if (_roundVC == nil) {
        _roundVC = [[BATRoundGuideViewController alloc] init];
//        _roundVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    return _roundVC;
}

- (BATHealthEvaluationViewController *)healthEvaluationVC
{
    if (_healthEvaluationVC == nil) {
        _healthEvaluationVC = [[BATHealthEvaluationViewController alloc] init];
//        _healthEvaluationVC.view.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    return _healthEvaluationVC;
}

- (void)pushHealth360EvaluationVC:(NSNotification *)noti {
    
    if (self.isCurrentVC == NO) {

        return;
    }
    
    BATHealth360EvaluationViewController *evaluationVC = [[BATHealth360EvaluationViewController alloc] init];
    evaluationVC.urlSuffix = @"&redirect=/H5/src/index.html?src=2#/healthEvaluateReport/////2";
    [self.navigationController pushViewController:evaluationVC animated:YES];
}

@end
