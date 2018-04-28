//
//  BATTraditionThirdViewController.m
//  HealthBAT_Pro
//
//  Created by Skybrim on 2017/3/25.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATTraditionThirdViewController.h"
#import "BATPerson.h"
#import "BATTraditionFouthViewController.h"
#import "BATLoginModel.h"

@interface BATTraditionThirdViewController ()

@property (nonatomic,strong) UIImageView *backgroundView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *detailLabel;
@property (nonatomic,strong) UIActivityIndicatorView *loadingIndicator;

@end

@implementation BATTraditionThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    BATLoginModel *login = LOGIN_INFO;
    self.model.AccountID = login.Data.ID;

    [self layoutPages];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self.loadingIndicator startAnimating];
    [self bk_performBlock:^(id obj) {
        BATTraditionFouthViewController *fouthVC = [[BATTraditionFouthViewController alloc] init];
        fouthVC.model = self.model;
        [self.navigationController pushViewController:fouthVC animated:YES];
    } afterDelay:2.0f];
}


#pragma mark - layoutPages
- (void)layoutPages {
    
    WEAK_SELF(self);
    
    [self.view addSubview:self.backgroundView];
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT));
    }];

    [self.view addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.centerY.equalTo(@-100);
    }];
    
    [self.view addSubview:self.detailLabel];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerX.equalTo(@0);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(25);
    }];
    
    [self.view addSubview:self.loadingIndicator];
    [self.loadingIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(self.detailLabel.mas_bottom).offset(25);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
}


#pragma mark - getter
- (UIImageView *)backgroundView {
    
    if (!_backgroundView) {
        
        _backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guoyiguan-back"]];
    }
    return _backgroundView;
}

- (UILabel *)nameLabel {
    
    if (!_nameLabel) {
        _nameLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:UIColorFromHEX(0xffffff, 1) textAlignment:NSTextAlignmentCenter];
        BATPerson *person = PERSON_INFO;
        _nameLabel.text = person.Data.UserName;
    }
    return _nameLabel;
}

- (UILabel *)detailLabel {
    
    if (!_detailLabel) {
        _detailLabel = [UILabel labelWithFont:[UIFont boldSystemFontOfSize:20] textColor:UIColorFromHEX(0xffffff, 1) textAlignment:NSTextAlignmentCenter];
        _detailLabel.text = @"我们正在为您建立超赞的健康日报";
    }
    return _detailLabel;
}

- (UIActivityIndicatorView *)loadingIndicator {
    
    if (!_loadingIndicator) {
        _loadingIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectZero];
        _loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    }
    return _loadingIndicator;
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
