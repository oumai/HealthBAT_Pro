//
//  BATHealthDocumentsViewController.m
//  HealthBAT_Pro
//
//  Created by KM on 17/6/162017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHealthDocumentsViewController.h"
#import "BATJSObject.h"

#import "BATLoginModel.h"
#import "BATPerson.h"

#import "BATHomeMallViewController.h"
#import "BATConsultationDepartmentDetailViewController.h"
#import "BATHealthThreeSecondsController.h"  //健康3秒钟
#import "BATHealthyInfoViewController.h"  //健康3秒钟健康资料
#import "BATHealthAssessmentViewController.h"
#import "BATDieaseDetailController.h"

@interface BATHealthDocumentsViewController ()<UIWebViewDelegate>

@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,assign) BOOL isNeedLoad;

@property (nonatomic,strong) JSContext *context;

@property (nonatomic,strong) UIView *loadingView;

@property (nonatomic,strong) UIImageView *animateView;

@end

@implementation BATHealthDocumentsViewController

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self layoutSubpages];
    self.isNeedLoad = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearWebViewCache) name:@"APPLICATION_LOGOUT" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadURL) name:@"HealthDociments" object:nil];
    
    [self.animateView startAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    if (self.isNeedLoad == NO) {
        return;
    }
    [self loadURL];
    self.isNeedLoad = NO;
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    //电商页面，联合登陆
    if ([request.URL.absoluteString containsString:@"http://m.km1818.com"]) {
    
        BATHomeMallViewController *homeMallVC = [[BATHomeMallViewController alloc] init];
        homeMallVC.url = request.URL.absoluteString;
        homeMallVC.title = @"健康商城";
        homeMallVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:homeMallVC animated:YES];
        
        return NO;
    }
    
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    self.context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    BATJSObject *jsObject = [[BATJSObject alloc] init];
    self.context[@"HealthBAT"] = jsObject;
    
    WEAK_SELF(self);
    //返回首页
    [jsObject setGoToBatHomeBlock:^{
        STRONG_SELF(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (self.isFromRoundGuide) {
                BATAppDelegate *appDelegate = (BATAppDelegate *)[UIApplication sharedApplication].delegate;
                [appDelegate.window.rootViewController presentViewController:appDelegate.navHomeVC animated:NO completion:nil];
            } else {
                [self.tabBarController setSelectedIndex:0];
            }
            
        });
    }];
    
    //移除动画
    [jsObject setRemoveAnimationBlock:^{
        STRONG_SELF(self);
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.animateView stopAnimating];
            [self.loadingView removeFromSuperview];
        });
    }];
    
    
    //跳转到全科医生
    [jsObject setGoToHealthConsultationBlock:^{
        
        BATConsultationDepartmentDetailViewController *departDetailVC = [[BATConsultationDepartmentDetailViewController alloc] init];
        departDetailVC.hidesBottomBarWhenPushed = YES;
        departDetailVC.title = @"全科医疗科";
        departDetailVC.departmentName = @"全科医疗科";
        departDetailVC.isConsulted = NO;
        [self.navigationController pushViewController:departDetailVC animated:YES];
    }];
    
    //健康3秒钟
    [jsObject setGoToHealthSecendsBlock:^{
        
        DDLogDebug(@"setGoToHealthSecendsBlock");
        
        if ( !LOGIN_STATION) {
            PRESENT_LOGIN_VC;
            return;
        }
        
        BATPerson *loginUserModel = PERSON_INFO;
        
        BOOL isEdit = (loginUserModel.Data.Weight && loginUserModel.Data.Height && loginUserModel.Data.Birthday.length);
        
        if ( !LOGIN_STATION) {
            PRESENT_LOGIN_VC;
            return;
        }
        
        
        if (!isEdit && ![[NSUserDefaults standardUserDefaults]boolForKey:@"isFirstEnterHealthThreeSecond"]) {
            
            //完善资料
            BATHealthyInfoViewController *editInfo = [[BATHealthyInfoViewController alloc]init];
            editInfo.isShowNavButton = YES;
            editInfo.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:editInfo animated:YES];
            
            
        }else{
            
            //健康3秒钟
            BATHealthThreeSecondsController *healthThreeSecondsVC = [[BATHealthThreeSecondsController alloc]init];
            healthThreeSecondsVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:healthThreeSecondsVC animated:YES];
        }
    }];
    
    //中医体质测试
    [jsObject setGoToMedicineBlock:^{
        
        BATHealthAssessmentViewController * healthAssessmentVC = [[BATHealthAssessmentViewController alloc] init];
        healthAssessmentVC.hidesBottomBarWhenPushed = YES;
        healthAssessmentVC.title = @"康美人生中医体质检测";
        healthAssessmentVC.assessmentID = 18;
        healthAssessmentVC.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/App/TemplateIndex/%@?token=%@&mid=%@&from=health360",APP_WEB_DOMAIN_URL,@"18",LOCAL_TOKEN,[Tools getPostUUID]]];
        [self.navigationController pushViewController:healthAssessmentVC animated:YES];
    }];
    
    //疾病百科
    [jsObject setGoToDiseasesBlock:^(NSString *diseaseID) {
        
        DDLogDebug(@"setGoToDiseasesBlock--diseaseID");
        
        BATDieaseDetailController *searchDieaseCtl = [[BATDieaseDetailController alloc]init];
        searchDieaseCtl.DieaseID = [diseaseID integerValue];
        searchDieaseCtl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:searchDieaseCtl animated:YES];
    }];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    
}

#pragma mark - private
- (void)loadURL {
    
    BATPerson *person = PERSON_INFO;
    
    NSString *appkey = @"e38ad4f48133c76ad8e6165ccc427211";
    NSString *appSecret = @"dbf2dcc52133c76ad8e61600eeafa583";
    NSString *timestamp = [Tools getDateStringWithDate:[NSDate date] Format:@"yyyy-MM-dd HH:mm:ss"];//当前日期
    NSString *phone = person.Data.PhoneNumber;//手机号
    
    NSArray *array = @[appkey,appSecret,timestamp];
    
    array = [array sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    
    NSString *tmpSign = @"";
    for (NSString *string in array) {
        tmpSign = [tmpSign stringByAppendingString:string];
    }
    
    NSString *sign = [Tools md5String:tmpSign];
    
    NSString *url = [NSString stringWithFormat:@"%@?appkey=%@&timestamp=%@&sign=%@&phone=%@&src=2",KM_HEALTH360_URL,appkey,timestamp,sign,phone];
/*
#ifdef RELEASE
    url = [NSString stringWithFormat:@"http://djymbgl.kmhealthcloud.com:9003?appkey=%@&timestamp=%@&sign=%@&phone=%@&src=2",appkey,timestamp,sign,phone];
#elif PRERELEASE
//    url = [NSString stringWithFormat:@"http://djymbgl.kmhealthcloud.com:9003?appkey=%@&timestamp=%@&sign=%@&phone=%@&src=2",appkey,timestamp,sign,phone];
    
    url = [NSString stringWithFormat:@"http://hc003pe-mobile.chinacloudsites.cn?appkey=%@&timestamp=%@&sign=%@&phone=%@&src=2",appkey,timestamp,sign,phone];
    
#else
    url = [NSString stringWithFormat:@"http://mobile.hmtest.kmhealthcloud.cn:8165?appkey=%@&timestamp=%@&sign=%@&phone=%@&src=2",appkey,timestamp,sign,phone];

//    url = [NSString stringWithFormat:@"http://hc003pe-mobile.chinacloudsites.cn?appkey=%@&timestamp=%@&sign=%@&phone=%@&src=2",appkey,timestamp,sign,phone];

#endif
*/
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

- (void)clearWebViewCache {
    
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
    
    self.isNeedLoad = YES;
    
    //弹出登录界面，跳转到首页
    PRESENT_LOGIN_VC
    
    WEAK_SELF(self);
    [self bk_performBlock:^(id obj) {
        
        STRONG_SELF(self);
        [self.tabBarController setSelectedIndex:0];
    } afterDelay:1];
}

#pragma mark - layout
- (void)layoutSubpages {
    
    [self.view addSubview:self.webView];
    [self.view addSubview:self.loadingView];
    [self.loadingView addSubview:self.animateView];
    
    WEAK_SELF(self);
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@-20);
        make.left.right.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
    
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self.view);
    }];
    
    [self.animateView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.center.equalTo(self.loadingView);
//        make.size.mas_offset(CGSizeMake(400, 300));
    }];
}

#pragma mark - getter
- (UIWebView *)webView {
    
    if (!_webView) {
        
        _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        _webView.backgroundColor = BASE_BACKGROUND_COLOR;
        _webView.scrollView.backgroundColor = BASE_BACKGROUND_COLOR;
        _webView.delegate = self;
    }
    return _webView;
}

- (UIView *)loadingView
{
    if (_loadingView == nil) {
        _loadingView = [[UIView alloc] init];
        _loadingView.backgroundColor = [UIColor whiteColor];
    }
    return _loadingView;
}

- (UIImageView *)animateView
{
    if (_animateView == nil) {
        _animateView = [[UIImageView alloc] init];
        [_animateView setImage:[UIImage imageNamed:@"web_loading_image1"]];
        [_animateView sizeToFit];
        
        NSMutableArray *animates = [NSMutableArray array];
        
        for (int i = 1; i < 11; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"web_loading_image%ld",(long)i]];
            [animates addObject:image];
        }
        _animateView.animationDuration = 0.8;
        _animateView.animationImages = animates;
    }
    return _animateView;
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
