//
//  BATHealthEvaluationViewController.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/9/12.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHealthEvaluationViewController.h"

@interface BATHealthEvaluationViewController ()

@end

@implementation BATHealthEvaluationViewController

- (void)dealloc {
    
    DDLogDebug(@"%s",__func__);
}

- (void)loadView
{
    [super loadView];
    
    [self pageLayout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

#pragma mark - pageLayout
- (void)pageLayout
{
    [self.view addSubview:self.healthEvaluationView];
    WEAK_SELF(self);
    [self.healthEvaluationView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - get & set
- (BATHealthEvaluationView *)healthEvaluationView
{
    if (_healthEvaluationView == nil) {
        _healthEvaluationView = [[BATHealthEvaluationView alloc] init];
    }
    return _healthEvaluationView;
}

@end
