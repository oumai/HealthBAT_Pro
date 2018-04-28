//
//  BATHealthAssessmentMoreViewController.m
//  HealthBAT_Pro
//
//  Created by four on 16/9/26.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATHealthAssessmentMoreViewController.h"
#import "BATHealthAssessmentViewController.h"

#import "UINavigationController+ShouldPopOnBackButton.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface BATHealthAssessmentMoreViewController ()<UIWebViewDelegate>

@property (nonatomic,strong) UIWebView *webView;

@property (nonatomic,strong) BATDefaultView *defaultView;

@end

@implementation BATHealthAssessmentMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"健康评测";

    [self layoutPages];
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    self.fd_interactivePopDisabled = YES;
}

- (BOOL)navigationShouldPopOnBackButton {

    [self.navigationController popToRootViewControllerAnimated:YES];
    return YES;
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{

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
    
    
    if ([request.URL.absoluteString containsString:@"TemplateIndex"]) {

        NSArray *tmpArray = [request.URL.absoluteString componentsSeparatedByString:@"/"];

        DDLogDebug(@"%@",tmpArray);

        BATHealthAssessmentViewController * healthAssessmentVC = [[BATHealthAssessmentViewController alloc] init];
        healthAssessmentVC.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?token=%@&mid=%@",request.URL.absoluteString,LOCAL_TOKEN,[Tools getPostUUID]]];
        healthAssessmentVC.isFromMore = YES;
        healthAssessmentVC.assessmentID = [[tmpArray lastObject] integerValue];
        [self.navigationController pushViewController:healthAssessmentVC animated:YES];

        return NO;
    }

    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *injectionJSString = @"var script = document.createElement('meta');"
    "script.name = 'viewport';"
    "script.content=\"width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    [webView stringByEvaluatingJavaScriptFromString:injectionJSString];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self.defaultView showDefaultView];
}

#pragma mark - layout
- (void)layoutPages {
    
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

#pragma mark - setter && getter
- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        _webView.delegate = self;
        _webView.scalesPageToFit = YES;
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
            [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
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
