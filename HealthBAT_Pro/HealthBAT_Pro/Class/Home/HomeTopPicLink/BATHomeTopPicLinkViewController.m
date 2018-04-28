//
//  BATHomeTopPicLinkViewController.m
//  HealthBAT_Pro
//
//  Created by KM on 16/11/102016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATHomeTopPicLinkViewController.h"
#import "UIButton+TouchAreaInsets.h"
#import "BATPerson.h"
#import "BATJSObject.h"

@interface BATHomeTopPicLinkViewController ()<UIWebViewDelegate>
@property (nonatomic,strong) UIView *loadingView;
@property (nonatomic,strong) UIImageView *animateView;
@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic, strong) JSContext *context;
@end

@implementation BATHomeTopPicLinkViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    [self layoutPages];
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];

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
#pragma mark - 设置导航栏返回按钮
- (void)setupNav{
    
    UIButton *backNav = [UIButton buttonWithType:UIButtonTypeCustom];
    
    backNav.frame = CGRectMake(0, 0, 11, 20);
    backNav.touchAreaInsets = UIEdgeInsetsMake(10, 20, 10, 20);
    [backNav setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    [backNav setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateHighlighted];
    
    [backNav addTarget:self action:@selector(leftBackButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBackButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backNav];
    
    self.navigationItem.leftBarButtonItem = leftBackButtonItem;
}

- (void)leftBackButtonClick{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }else{
        [self.view resignFirstResponder];
         [self.navigationController popViewControllerAnimated:YES];
    }

}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    [self showLoadingAnimation];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    //隐藏加载动画
    [self hiddenLoadingAnimation];
    
    if (!_isFromLearning) {
        self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }

    //肿瘤订单需要获取
    self.context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    BATJSObject *jsObject = [[BATJSObject alloc] init];
    
    self.context[@"HealthBAT"] = jsObject;
    self.context[@"HealthBAT"][@"userAuthentication"] = ^() {
        return  [self userAuthentication];
    };
    self.context[@"HealthBAT"][@"clearHistory"] = ^() {
        [self clearHistory];
    };
    
   
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    //商户APP的WebView处理alipays协议
    NSString* reqUrl = request.URL.absoluteString;
    if ([reqUrl hasPrefix:@"alipays://"] || [reqUrl hasPrefix:@"alipay://"]) {
        // NOTE: 跳转支付宝App
        BOOL bSucc = [[UIApplication sharedApplication]openURL:request.URL];
        
        // NOTE: 如果跳转失败，则跳转itune下载支付宝App
        if (!bSucc) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                           message:@"未检测到支付宝客户端，请安装后重试。"
                                                          delegate:self
                                                 cancelButtonTitle:@"立即安装"
                                                 otherButtonTitles:nil];
            [alert show];
        }
        return NO;
    }
    return YES;
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // NOTE: 跳转itune下载支付宝App
    NSString* urlStr = @"https://itunes.apple.com/cn/app/zhi-fu-bao-qian-bao-yu-e-bao/id333206289?mt=8";
    NSURL *downloadUrl = [NSURL URLWithString:urlStr];
    [[UIApplication sharedApplication]openURL:downloadUrl];
    
    
}
#pragma mark - 肿瘤 - JS调用
//判断是否登录，登录则返回用户手机号
- (NSString *)userAuthentication{
    if (!LOGIN_STATION) {
        dispatch_async(dispatch_get_main_queue(), ^{
            PRESENT_LOGIN_VC;
        });
        return @"";
    }else{
        return ((BATPerson *)PERSON_INFO).Data.PhoneNumber;
    }
    
}
/*
 清除UIWebView的缓存
 */
- (void)clearHistory{
    
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
 
}
#pragma mark - layout
- (void)layoutPages {
    [self.view addSubview:self.webView];
    
//    WEAK_SELF(self);
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    

}

#pragma mark - setter && getter
- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        _webView.delegate = self;
        _webView.scalesPageToFit = YES;
        _webView.scrollView.bounces = NO;
        _webView.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag; // 当拖动时移除键盘
        
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
