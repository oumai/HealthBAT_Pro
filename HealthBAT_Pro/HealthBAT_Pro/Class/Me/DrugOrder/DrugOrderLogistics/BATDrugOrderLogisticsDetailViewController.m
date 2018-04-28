//
//  BATDrugOrderLogisticsDetailViewController.m
//  HealthBAT_Pro
//
//  Created by mac on 2017/12/21.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDrugOrderLogisticsDetailViewController.h"

@interface BATDrugOrderLogisticsDetailViewController ()<UIWebViewDelegate>

@property (nonatomic,strong) UIWebView *webView;

@end

@implementation BATDrugOrderLogisticsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self layoutPages];
    
    
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/hospital_h5/?phone=%@#/searchLogistics?id=%@&state=-2&from=app",APP_H5_DOMAIN_URL,self.phoneNumber,self.LogisticNo]]]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    
}

#pragma mark - layout
- (void)layoutPages {
    
    self.title = @"物流信息";
    
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
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
