//
//  BATHomeMallViewController.m
//  HealthBAT_Pro
//
//  Created by Skybrim on 2017/3/20.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHomeMallViewController.h"
#import "BATPerson.h"
#import "BATLoginModel.h"
#import "SFHFKeychainUtils.h"

@interface BATHomeMallViewController ()<UIWebViewDelegate>
@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) NSURL *needRequestURL;
@property (nonatomic,strong) UIView *loadingView;
@property (nonatomic,strong) UIImageView *animateView;
@property (nonatomic,assign) BOOL isFail;
@property (nonatomic,assign) BOOL isHasCookie;

@property (nonatomic,strong) NSTimer *reloadTimer;

@end

@implementation BATHomeMallViewController
- (void)dealloc{
    
    DDLogDebug(@"=======");
    self.webView = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self layoutPages];
    
    self.isFail = YES;
    if (LOGIN_STATION) {
        BATLoginModel *login = LOGIN_INFO;
        NSString * jumpLogin = [NSString stringWithFormat:@"http://search.jkbat.com/kmHealthMall-web/jumpLogin.jsp?userId=%ld&deviceSource=1&targetUrl=%@",(long)login.Data.ID,self.url];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:jumpLogin]]];
    }
    else {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    }
    
    // 展示自定义的加载动画
    
    if (![self.url containsString:@"products"]) {
        //非详情页，显示加载动画
        [self showLoadingAnimation];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.isHasCookie = NO;
    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        
        if ([cookie.name isEqualToString:@"b2c_cookieSessionId"]) {
            
            self.isHasCookie = YES;
            break;
        }
    }
    
    if (self.needRequestURL && LOGIN_STATION) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:self.needRequestURL]];
        self.needRequestURL = nil;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private
#pragma mark - 显示加载动画
- (void)showLoadingAnimation{
    
    WEAK_SELF(self);
    [self.view addSubview:self.loadingView];
    [self.loadingView addSubview:self.animateView];
    
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self.view);
    }];
    
    [self.animateView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.center.equalTo(self.loadingView);
        
    }];
    
    [self.animateView startAnimating];
    
}
#pragma mark - 隐藏加载动画
- (void)hiddenLoadingAnimation{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.animateView stopAnimating];
        [self.loadingView removeFromSuperview];
    });
    
}

- (void)failCheck {
    
    [self bk_performBlock:^(id obj) {
        
        if (self.isFail == NO) {
            return ;
        }
        
        NSString *jsStr = @"document.documentElement.innerHTML";//获取当前网页的html
        NSString *html = [self.webView stringByEvaluatingJavaScriptFromString:jsStr];
        
        if ([html containsString:@"<!--jkbat integrate page - remove loading animation-->"]) {
            
            [self.webView loadRequest:self.webView.request];
        }
        
    } afterDelay:15];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    NSString *jsStr = @"document.documentElement.innerHTML";//获取当前网页的html
    NSString *html = [webView stringByEvaluatingJavaScriptFromString:jsStr];
    
    self.isFail = NO;
    
    if ([html containsString:@"<!--jkbat integrate page - remove loading animation-->"]) {
        //加载完成隐藏加载动画
        
        [self hiddenLoadingAnimation];
    }
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    DDLogDebug(@"%@",request.URL.absoluteString);
    
    if ([request.URL.absoluteString isEqualToString:@"http://m.km1818.com/"]) {
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        return NO;
    }
    
    if ([request.URL.absoluteString containsString:@"http://m.km1818.com/cart/listWapShopCar.action"]) {
        
        //app未登陆，进行登陆
        if (!LOGIN_STATION) {
            PRESENT_LOGIN_VC;
            self.needRequestURL = request.URL;
            return NO;
        }
        
        BOOL isAppendShopCar = NO;
        NSString *tmpURL = request.URL.absoluteString;
        
        
        NSRange range = [tmpURL rangeOfString:@"http://m.km1818.com/cart/listWapShopCar.action"];
        if (range.location > 0) {
            //此时，购物车链接作为跳转url，是参数
            isAppendShopCar = NO;
        }
        else {
            
            if (self.isHasCookie == NO && ![request.URL.absoluteString containsString:@"?"]) {
                isAppendShopCar = YES;
            }
        }
        
        if (isAppendShopCar) {
            
            BATLoginModel *login = LOGIN_INFO;
            NSString * jumpLogin = [NSString stringWithFormat:@"http://search.jkbat.com/kmHealthMall-web/jumpLogin.jsp?userId=%ld&deviceSource=1&targetUrl=%@",(long)login.Data.ID,tmpURL];
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:jumpLogin]]];
            
            return NO;
        }
    }
    
    if ([request.URL.absoluteString containsString:@"wapLogin.jsp"]) {
        //网页跳转去登陆界面，阻止跳转
        
        //app未登陆，进行登陆
        if (!LOGIN_STATION) {
            PRESENT_LOGIN_VC;
            self.needRequestURL = request.URL;
            return NO;
        }
        
        //联合登陆
        NSRange range = [request.URL.absoluteString rangeOfString:@"ReturnUrl="];
        NSString *targetUrl = [request.URL.absoluteString substringFromIndex:range.location+range.length];
        
        BATLoginModel *login = LOGIN_INFO;
        NSString * jumpLogin = [NSString stringWithFormat:@"http://search.jkbat.com/kmHealthMall-web/jumpLogin.jsp?userId=%ld&deviceSource=1&targetUrl=%@",(long)login.Data.ID,targetUrl];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:jumpLogin]]];
        
        return NO;
    }
    
    
    if ([request.URL.absoluteString containsString:@"?"] || [request.URL.absoluteString containsString:@"chatClient"] || [request.URL.absoluteString containsString:@"about:blank"] || [request.URL.absoluteString containsString:@"https://__bridge_loaded__/"]) {
        
        return YES;
    }

    NSString *url = [NSString stringWithFormat:@"%@?kmCloud",request.URL.absoluteString];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    return NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    self.isFail = YES;
    
    [self failCheck];
}

#pragma mark - layout
- (void)layoutPages {
    
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 20, 40);
    WEAK_SELF(self);
    [btn bk_whenTapped:^{
        STRONG_SELF(self);
        if ([self.webView.request.URL.absoluteString containsString:self.url] ||
            self.isFail || !self.webView.canGoBack) {
            
            [self.navigationController popViewControllerAnimated:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
        [self.webView goBack];
    }];
    [btn setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = backItem;
    self.hidesBottomBarWhenPushed = YES;
}

#pragma mark - getter
- (UIWebView *)webView {
    
    if (!_webView) {
        
        _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        _webView.delegate = self;
    }
    return _webView;
}
- (UIView *)loadingView
{
    if (_loadingView == nil) {
        _loadingView = [[UIView alloc] initWithFrame:self.view.bounds];
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

