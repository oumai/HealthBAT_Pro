//
//  BATTodayOfferViewController.m
//  HealthBAT_Pro
//
//  Created by KM on 16/9/222016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATTodayOfferViewController.h"
//model
#import "BATLoginModel.h"
#import "BATPerson.h"

#import "SFHFKeychainUtils.h"

//#import "CustomURLProtocol.h"

@interface BATTodayOfferViewController ()<UIWebViewDelegate>

@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) NSString *currentUrl;

@property (nonatomic,strong) NSString *backUrl;
@property (nonatomic,strong) NSString *lastUrl;
@property (nonatomic,assign) BOOL islock;

@property (nonatomic,assign) BOOL lastLoginStation;
@property (nonatomic,strong) NSString *beginTime;

@property (nonatomic,strong) BATDefaultView *defaultView;

@end

@implementation BATTodayOfferViewController

- (void)dealloc{
//    [NSURLProtocol unregisterClass:[CustomURLProtocol class]];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"今日特价";

    self.islock = NO;

    
    //目前断网了就提示
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDefaultViewOfNoNet) name:@"APP_NOT_NET_STATION" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDefaultView) name:@"UIWebViewRequestError_NoNET" object:nil];
//    [NSURLProtocol registerClass:[CustomURLProtocol class]];

    [self layoutPages];

    self.lastLoginStation = LOGIN_STATION;

    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[self todayOfferUrl]]]];

}

//- (void)reloadDefaultView{
//    
//    [self.defaultView showDefaultView];
//}

- (void)reloadDefaultViewOfNoNet{
        //请求结束的断网不提示
        [self.defaultView showDefaultView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
//    self.navigationController.navigationBar.translucent=NO;

    if (self.lastLoginStation == NO && LOGIN_STATION) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[self todayOfferUrl]]]];
    }

    self.lastLoginStation = LOGIN_STATION;

}

-(void)viewWillDisappear:(BOOL)animated {
   
    [super viewWillDisappear:animated];
    
   // [TalkingData trackPageEnd:@"今日特价"];
    
    [BATUserPortrayTools saveOperateModuleRequestWithURL:@"/kmStatistical-sync/saveOperateModule" pathName:@"首页-今日特价" moduleId:1 beginTime:self.beginTime];
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

    DDLogError(@"%@",request.URL);

    static BOOL isRequestWeb = YES;
    
    if (isRequestWeb) {
        NSHTTPURLResponse *response = nil;
        
        [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
        if (response.statusCode == 404) {
            // code for 404
            [self.defaultView showDefaultView];
        } else if (response.statusCode == 403) {
            [self.defaultView showDefaultView];
        }
    }

    if ([request.URL.absoluteString containsString:@"products"]) {
        //当前加载的是商品页面
        self.lastUrl = nil;

        if (!LOGIN_STATION) {
            PRESENT_LOGIN_VC;
            return NO;
        }
        self.currentUrl = request.URL.absoluteString;

        if (!self.islock) {
            self.islock = YES;
            self.backUrl = request.URL.absoluteString;
        }

        return YES;
    }
    self.currentUrl = request.URL.absoluteString;

    if (!self.islock) {
        self.islock = YES;
        self.backUrl = request.URL.absoluteString;
    }

    return YES;

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
   
    [self.defaultView showDefaultView];
}


#pragma mark - private
- (BOOL)navigationShouldPopOnBackButton {

    self.islock = NO;

    if ([self.lastUrl isEqualToString:self.backUrl]) {
        return YES;
    }

    self.lastUrl = self.backUrl;

    if ([self.currentUrl containsString:MALL_URL]) {
        //当前页面为今日特价首页。直接返回
        return YES;
    }

    if ([self.currentUrl containsString:@"products"]) {

        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[self todayOfferUrl]]]];
        return NO;
    }

    [self.webView goBack];
    return NO;
}

- (NSString *)todayOfferUrl {

    NSString * strURL = @"";
    BATPerson *person = PERSON_INFO;
    BATLoginModel *login = LOGIN_INFO;
    if (!LOGIN_STATION) {

        //未登录
        strURL = [NSString stringWithFormat:@"%@/kmHealthMall-web/saletoday_sub.jsp?deviceCode=%@",MALL_URL,[self getPostUUID]];
    }
    else {
        //已经登录
        strURL = [NSString stringWithFormat:@"%@/kmHealthMall-web/saletoday_sub.jsp?userName=%@&deviceSource=1&userId=%ld&deviceCode=%@",MALL_URL,person.Data.PhoneNumber,(long)login.Data.ID,[self getPostUUID]];
    }

    return strURL;
}


- (NSString *)getPostUUID {
    //保存UUID
    NSError *uuidError;
    NSString * uuidString = [SFHFKeychainUtils getPasswordForUsername:@"UUID" andServiceName:ServiceName error:&uuidError];
    if (!uuidString) {
        BOOL saved = [SFHFKeychainUtils storeUsername:@"UUID" andPassword:[Tools getUUID] forServiceName:ServiceName updateExisting:YES error:&uuidError];
        if (!saved) {
            DDLogDebug(@"获取UUID失败");
        }
        uuidString = [SFHFKeychainUtils getPasswordForUsername:@"UUID" andServiceName:ServiceName error:&uuidError];
    }
    return uuidString;
}


#pragma mark - layout
- (void)layoutPages {
    self.beginTime = [Tools getCurrentDateStringByFormat:@"yyyy-MM-dd HH:mm:ss"];
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:self.defaultView];
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}



#pragma mark - setter
- (UIWebView *)webView {

    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
//        _webView.scalesPageToFit = YES;
        _webView.delegate = self;
    }
    return _webView;
}

- (BATDefaultView *)defaultView{
    if (!_defaultView) {
        _defaultView = [[BATDefaultView alloc]initWithFrame:CGRectZero];
        _defaultView.hidden = YES;
        WEAK_SELF(self);
        [_defaultView setReloadRequestBlock:^{
            STRONG_SELF(self);
            DDLogInfo(@"=====重新开始加载！=====");
            self.defaultView.hidden = YES;
            
            if(!NET_STATION){
                [self.defaultView showDefaultView];
            }
            
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[self todayOfferUrl]]]];
        }];
        
    }
    return _defaultView;
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
