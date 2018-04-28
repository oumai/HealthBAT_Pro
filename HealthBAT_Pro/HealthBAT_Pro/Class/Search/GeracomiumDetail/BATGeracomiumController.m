//
//  BATGeracomiumController.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2016/10/24.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATGeracomiumController.h"

@interface BATGeracomiumController ()<UIWebViewDelegate>
@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) NSString *beginTime;
@end

@implementation BATGeracomiumController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutPages];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/app/PensionHospitalDetails?id=%@",APP_WEB_DOMAIN_URL,self.gerID];
    NSURL *url = [NSURL URLWithString:urlString];
     [self.webView loadRequest:[NSURLRequest requestWithURL:url]];

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
     [BATUserPortrayTools saveUserBrowseRequestWithURL:@"/kmStatistical-sync/saveUserBrowse" moduleName:@"beadhouse_info" moduleId:[NSString stringWithFormat:@"%@",self.gerID] beginTime:self.beginTime browsePage:self.pathName];
    
}

-(void)webViewDidStartLoad:(UIWebView *)webView {
    [self showProgressWithText:@"正在加载"];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self dismissProgress];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [self dismissProgress];
}

#pragma mark - layout
- (void)layoutPages {
    self.title = self.titleName;
    self.beginTime = [Tools getCurrentDateStringByFormat:@"yyyy-MM-dd HH:mm:ss"];
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
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

@end
