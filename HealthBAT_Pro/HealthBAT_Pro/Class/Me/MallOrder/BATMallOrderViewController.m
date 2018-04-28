//
//  BATMallOrderViewController.m
//  HealthBAT_Pro
//
//  Created by KM on 16/10/232016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATMallOrderViewController.h"
//model
#import "BATLoginModel.h"
#import "BATPerson.h"

@interface BATMallOrderViewController ()<UIWebViewDelegate>

@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) NSString *currentUrl;

@property (nonatomic,strong) NSString *backUrl;
@property (nonatomic,strong) NSString *lastUrl;
@property (nonatomic,assign) BOOL islock;

@property (nonatomic,assign) BOOL lastLoginStation;

@property (nonatomic,strong) NSString *beginTime;

@property (nonatomic,strong) BATDefaultView *defaultView;

@end

@implementation BATMallOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"物流订单";
    [self layoutPages];

    self.lastLoginStation = LOGIN_STATION;

    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[self todayOfferUrl]]]];

}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [BATUserPortrayTools saveOperateModuleRequestWithURL:@"/kmStatistical-sync/saveOperateModule" pathName:@"个人中心-物流订单" moduleId:4 beginTime:self.beginTime];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    self.navigationController.navigationBar.translucent=NO;


    if (self.lastLoginStation == NO && LOGIN_STATION) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[self todayOfferUrl]]]];
    }

    self.lastLoginStation = LOGIN_STATION;

}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

    DDLogDebug(@"%@",request.URL.absoluteString);

    self.currentUrl = request.URL.absoluteString;

    if (!self.islock) {
        self.islock = YES;
        self.backUrl = request.URL.absoluteString;
        self.lastUrl = nil;
    }

    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    //失败直接返回吧
//    [self.defaultView showDefaultView];
}

#pragma mark - private
- (BOOL)navigationShouldPopOnBackButton {

    self.islock = NO;

    if ([self.lastUrl isEqualToString:self.backUrl]) {
        return YES;
    }

    self.lastUrl = self.backUrl;

    if ([self.currentUrl containsString:@"queryWapOrderList"]) {
        //当前页面为今日特价首页。直接返回
        return YES;
    }

    [self.webView goBack];
    return NO;
}

- (NSString *)todayOfferUrl {

    NSString * strURL = @"";
    BATPerson *person = PERSON_INFO;
    BATLoginModel *login = LOGIN_INFO;

    strURL = [NSString stringWithFormat:@"%@/kmHealthMall-web/discountLogin?uId=%ld&userName=%@&deviceSource=1&targetUrl=http://m.km1818.com/member/queryWapOrderList.action",MALL_URL,(long)login.Data.ID,person.Data.PhoneNumber];

    return strURL;
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
        make.bottom.right.left.equalTo(self.view);
        make.top.equalTo(@-20);
    }];
    
}

#pragma mark - setter
- (UIWebView *)webView {

    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
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
