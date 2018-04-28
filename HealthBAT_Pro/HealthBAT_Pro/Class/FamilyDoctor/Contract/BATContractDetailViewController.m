//
//  BATContractDetailViewController.m
//  HealthBAT_Pro
//
//  Created by four on 17/3/21.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATContractDetailViewController.h"

@interface BATContractDetailViewController ()<UIWebViewDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) UIWebView *webView;

@property (nonatomic,strong) BATDefaultView *defaultView;

@end

@implementation BATContractDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self layoutPages];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self requestContractDetail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestContractDetail{
    
    [self showText:@"正在获取合同详情..."];
    
    [HTTPTool requestWithURLString:@"/api/Doctor/GetContractByNew" parameters:@{@"orderNo":self.orderNO} type:kGET success:^(id responseObject) {
        
        [self dismissProgress];
        
        NSString  *dataStr = [responseObject objectForKey:@"Data"];
        
        [self.webView loadHTMLString:dataStr baseURL:nil];
        
        
    } failure:^(NSError *error) {
        
        [self dismissProgress];
        [self.defaultView showDefaultView];
        
    }];

}


#pragma mark - layout
- (void)layoutPages {
    
    self.title = @"合同详情";
    
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:self.defaultView];
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}


#pragma mark - setter && getter
- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        _webView.delegate = self;
        _webView.scrollView.delegate = self;
        _webView.multipleTouchEnabled=NO;
        _webView.scrollView.bouncesZoom = NO;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
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
