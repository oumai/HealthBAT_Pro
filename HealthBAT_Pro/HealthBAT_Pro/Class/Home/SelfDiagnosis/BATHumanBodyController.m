//
//  BATHumanBodyController.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/1/3.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHumanBodyController.h"
#import "BATSelfDiagnosisController.h"
#import "YCXMenu.h"
#import "BATSearchViewController.h"
#import <WebKit/WebKit.h>
#import "BATDefaultView.h"
#import "BATJSObject.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "BATSearchDieaseDetailController.h"
@interface BATHumanBodyController ()<UIWebViewDelegate>
@property (nonatomic,strong) NSArray *items;
@property (nonatomic,assign) NSInteger type;
@property (nonatomic,strong) NSString *beginTime;
@property (nonatomic,strong) UIWebView *web;
@property (nonatomic,strong) BATDefaultView *defaultView;
@property (nonatomic,strong) JSContext *jsContext;
@end

@implementation BATHumanBodyController

- (BATDefaultView *)defaultView{
    if (!_defaultView) {
        _defaultView = [[BATDefaultView alloc]initWithFrame:self.view.bounds];
        _defaultView.hidden = YES;
        [self.view addSubview:_defaultView];
        WEAK_SELF(self);
        [_defaultView setReloadRequestBlock:^{
            STRONG_SELF(self);
            DDLogInfo(@"=====重新开始加载！=====");
            self.defaultView.hidden = YES;
            
            NSURL *urll = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APP_WEB_DOMAIN_URL,@"app/body"]];
            NSURLRequest * req = [NSURLRequest requestWithURL:urll];
            [self.web loadRequest:req];
        }];
        
    }
    return _defaultView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self pageLayout];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    
    
    [BATUserPortrayTools saveOperateModuleRequestWithURL:@"/kmStatistical-sync/saveOperateModule" pathName:@"首页-自我诊断" moduleId:5 beginTime:self.beginTime];
}


#pragma mark - SETTER - GETTER
-(void)pageLayout {
     self.title = @"症状自诊";
     self.beginTime = [Tools getCurrentDateStringByFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,25,6)];
    [rightBtn setImage:[UIImage imageNamed:@"icon-zwzd-gd"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(moreSearchAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBar;
    
//     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon-zwzd-gd"] style:UIBarButtonItemStylePlain target:self action:@selector(moreSearchAction)];
    

    _web = [[UIWebView alloc]initWithFrame:self.view.bounds];
    _web.delegate = self;
    _web.scalesPageToFit = YES;
    _web.scrollView.scrollEnabled = NO;
    
    //加载本地html文件
    NSString *resPath = [[NSBundle mainBundle] resourcePath];
    NSString *filePath = [resPath stringByAppendingPathComponent:@"index.html"];
    [_web loadRequest:[[NSURLRequest alloc] initWithURL:[[NSURL alloc] initFileURLWithPath:filePath]]];
    
//    NSURL *urll = [NSURL URLWithString:@"http://www.jkbat.com/weixin/webApp/home/SelfExam?src=batapp"];
////    NSURL *urll = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",APP_WEB_DOMAIN_URL,@"app/body"]];
//    NSURLRequest * req = [NSURLRequest requestWithURL:urll];
//    [_web loadRequest:req];
    [self.view addSubview:_web];
    
}

-(void)webViewDidStartLoad:(UIWebView *)webView {
    [self showProgressWithText:@"正在加载"];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self dismissProgress];
    [self.defaultView showDefaultView];
}


-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [self dismissProgress];
    self.jsContext = [self.web valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
  
    BATJSObject *testJO=[BATJSObject new];
    self.jsContext[@"HealthBAT"]=testJO;

    [testJO setChooseSymptomBlock:^(NSString *ID) {
        NSLog(@"%@",ID);
        dispatch_async(dispatch_get_main_queue(), ^{
            
//            BATDieaseSymptomDetailController *symptomVC = [[BATDieaseSymptomDetailController alloc]init];
//            symptomVC.ID = [ID integerValue];
//            [self.navigationController pushViewController:symptomVC animated:YES];
            BATSearchDieaseDetailController *searchDieaseCtl = [[BATSearchDieaseDetailController alloc]init];
//            searchDieaseCtl.resultDesc = @"";
            searchDieaseCtl.DieaseID = [ID integerValue];
            searchDieaseCtl.EntryCNName = @"";
//            searchDieaseCtl.pathName = @"";
            searchDieaseCtl.titleName = @"症状百科";
            [self.navigationController pushViewController:searchDieaseCtl animated:YES];
            
        });
        
    }];
}



- (NSArray *)items {
    if (!_items) {
        _items = @[
                   [YCXMenuItem menuItem:@"疾病查询"
                                   image:nil
                                     tag:0
                                userInfo:@{@"type":@0}],
                   [YCXMenuItem menuItem:@"搜 索"
                                   image:nil
                                     tag:0
                                userInfo:@{@"type":@1}]
                   ];
        
        YCXMenuItem *allMenuTitle = _items[0];
        allMenuTitle.foreColor = UIColorFromHEX(0x666666, 1);
        allMenuTitle.titleFont = [UIFont systemFontOfSize:16];
        
        
        YCXMenuItem *deleteMenuTitle = _items[1];
        deleteMenuTitle.foreColor = UIColorFromHEX(0x666666, 1);
        deleteMenuTitle.titleFont = [UIFont systemFontOfSize:16];
        
    }
    return _items;
}


-(void)moreSearchAction {
   
    if ([YCXMenu isShow]){
        [YCXMenu dismissMenu];
    } else {
        [YCXMenu setHasShadow:YES];
        [YCXMenu setBackgrounColorEffect:YCXMenuBackgrounColorEffectSolid];
        [YCXMenu setSeparatorColor:BASE_LINECOLOR];
        [YCXMenu setCornerRadius:5.f];
        [YCXMenu showMenuInView:self.view fromRect:CGRectMake(SCREEN_WIDTH - 55, 0, 60, 0) menuItems:self.items selected:^(NSInteger index, YCXMenuItem *item) {
            DDLogDebug(@"%@",item.userInfo);
            
            self.type = [item.userInfo[@"type"] intValue];
            [YCXMenu dismissMenu];
            
            if (self.type) {
                
                BATSearchViewController *searchVC = [[BATSearchViewController alloc]init];
                [self.navigationController pushViewController:searchVC animated:YES
                 ];
              
            }else{
                
                 BATSelfDiagnosisController *selfDiagnosisVC = [[BATSelfDiagnosisController alloc]init];
                 [self.navigationController pushViewController:selfDiagnosisVC animated:YES];
                
               
            }
        }];
        [YCXMenu setTintColor:[UIColor whiteColor]];
    }
    
}

@end
