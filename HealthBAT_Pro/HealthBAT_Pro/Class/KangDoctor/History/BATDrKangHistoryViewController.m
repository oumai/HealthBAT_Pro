//
//  BATDrKangHistoryViewController.m
//  HealthBAT_Pro
//
//  Created by KM on 17/7/202017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDrKangHistoryViewController.h"
#import "BATJSObject.h"

@interface BATDrKangHistoryViewController ()<UIWebViewDelegate>

@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) JSContext *context;

@end

@implementation BATDrKangHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *url = [NSString stringWithFormat:@"%@/app/KDoctor/HistoryList?userDeviceId=%@",APP_H5_DOMAIN_URL,[Tools getPostUUID]];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    
    [self layoutPages];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    self.context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    BATJSObject *jsObject = [[BATJSObject alloc] init];
    self.context[@"HealthBAT"] = jsObject;
    
    WEAK_SELF(self);
    [jsObject setGoBackDrKangBlock:^(NSString *result) {
        STRONG_SELF(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DrKangEvaluationResultNotification" object:nil userInfo:@{@"result":result}];
        });
    }];
}

#pragma mark - layout
- (void)layoutPages {
    
    self.title = @"历史评估";
    
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 20, 40);
    WEAK_SELF(self);
    [btn bk_whenTapped:^{
        STRONG_SELF(self);
        
        if ([self.webView.request.URL.absoluteString containsString:@"Detail"]) {
            
            [self.webView goBack];
            return ;
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [btn setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = backItem;
}

#pragma mark - getter
- (UIWebView *)webView {
    
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        _webView.delegate = self;
    }
    return _webView;
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
