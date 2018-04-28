//
//  IntelligentGuideViewController.m
//  HealthBAT_Pro
//
//  Created by Skyrim on 16/7/10.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATIntelligentGuideViewController.h"

@interface BATIntelligentGuideViewController ()<UIWebViewDelegate>

@property (nonatomic,assign) BOOL      isMan;
@property (nonatomic,copy  ) NSString  *url;
@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,copy  ) NSString  *urlString;

@end

@implementation BATIntelligentGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"自我导诊";
    [self pagesLayout];
    self.isMan = YES;
    self.url = [NSString stringWithFormat:@"%@/app/TreatmentGuide?sex=man&type=1",APP_WEB_DOMAIN_URL];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];

    WEAK_SELF(self);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"男" style:UIBarButtonItemStyleDone handler:^(id sender) {
        self.isMan = !self.isMan;
        STRONG_SELF(self);
        if (self.isMan) {
            self.url = [NSString stringWithFormat:@"%@/app/TreatmentGuide?sex=man&type=1",APP_WEB_DOMAIN_URL];
            [self.navigationItem.rightBarButtonItem setTitle:@"男"];

        }else {
            self.url = [NSString stringWithFormat:@"%@/app/TreatmentGuide?sex=women&type=1",APP_WEB_DOMAIN_URL];
            [self.navigationItem.rightBarButtonItem setTitle:@"女"];
        }

        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    }];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    self.urlString = request.URL.absoluteString;
    if ([request.URL.absoluteString containsString:@"TreatmentGuide/"]) {
        NSString *string = [[request.URL.absoluteString componentsSeparatedByString:@"/"] lastObject];
        NSString * departmentName = [string componentsSeparatedByString:@"_"].lastObject;

        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"推荐科室" message:[departmentName stringByRemovingPercentEncoding] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {

            //前往指定科室的医生列表

        }];
        [alert addAction:cancelAction];
        [alert addAction:okAction];;

        [self presentViewController:alert animated:YES completion:nil];

        ///不发起请求
        return NO;
    }
    return YES;
}

- (BOOL)navigationShouldPopOnBackButton {

    if ([self.urlString containsString:@"#"]) {

        if (self.isMan == YES) {
            self.url = [NSString stringWithFormat:@"%@/app/TreatmentGuide?sex=man&type=1",APP_WEB_DOMAIN_URL];
        }
        else {
            self.url = [NSString stringWithFormat:@"%@/app/TreatmentGuide?sex=women&type=1",APP_WEB_DOMAIN_URL];
        }
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
        return NO;
    }

    [self.navigationController popViewControllerAnimated:YES];
    return YES;
}

#pragma mark - layout
- (void)pagesLayout {
    [self.view addSubview:self.webView];
}

#pragma mark - setter && getter
- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        _webView.delegate = self;
    }
    return _webView;
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
