//
//  BATTrainerIndexViewController.m
//  HealthBAT_Pro
//
//  Created by Skybrim on 2017/3/20.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATTrainerIndexViewController.h"
#import "BATTrainerInfoViewController.h"

@interface BATTrainerIndexViewController ()

@end

@implementation BATTrainerIndexViewController

- (void)loadView
{
    [super loadView];
    
    [self pageLayout];
    
    self.title = @"培训工作室";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - pageLayout
- (void)pageLayout
{
    [self.view addSubview:self.authenticateIndexView];
    
    WEAK_SELF(self);
    [self.authenticateIndexView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - get & set
- (BATTrainerAuthenticateView *)authenticateIndexView
{
    if (_authenticateIndexView == nil) {
        _authenticateIndexView = [[BATTrainerAuthenticateView alloc] init];
        
        WEAK_SELF(self);
        _authenticateIndexView.startBlock = ^(){
            STRONG_SELF(self);
            BATTrainerInfoViewController *infoVC = [[BATTrainerInfoViewController alloc] init];
            infoVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:infoVC animated:YES];
        };
    }
    return _authenticateIndexView;
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
