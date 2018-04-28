//
//  BATHealthTestRecordDetailViewController.m
//  HealthBAT_Pro
//
//  Created by KM on 16/10/142016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATHealthTestRecordDetailViewController.h"
#import "BATHealthAssessmentDetailTableViewCell.h"

static  NSString * const DETAIL_CELL = @"DetailCell";

@interface BATHealthTestRecordDetailViewController ()//<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIWebView *webView;

@end

@implementation BATHealthTestRecordDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = self.recordData.Theme;

    [self layoutPages];

    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/App/TemplateTest/%ld?resultId=%ld",APP_WEB_DOMAIN_URL,(long)self.recordData.EvaluationTempId,(long)self.recordData.ID]]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - layout
- (void)layoutPages {

    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - getter

- (UIWebView *)webView {

    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
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
