//
//  BATTrainResultViewController.m
//  HealthBAT_Pro
//
//  Created by Skybrim on 2017/3/20.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATTrainResultViewController.h"
#import "BATTrainerInfoViewController.h"
@interface BATTrainResultViewController ()

@end

@implementation BATTrainResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"培训认证";
    [self pageLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
- (void)resetBtnAction:(UIButton *)button
{
    //重新认证
    [self.navigationController pushViewController:[BATTrainerInfoViewController new] animated:YES];
    
    //延时操作，去掉栈中的结果页面
    [self bk_performBlock:^(id obj) {
        
        NSMutableArray *vcArray = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        for (UIViewController *vc in self.navigationController.viewControllers) {
            
            if ([vc isKindOfClass:self.class]) {
                [vcArray removeObject:vc];
                self.navigationController.viewControllers = vcArray;
                break;
            }
        }
    } afterDelay:0.5];
}

#pragma mark - pageLayout
- (void)pageLayout
{
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.resultLabel];
    [self.view addSubview:self.contentLabel];
    [self.view addSubview:self.resetBtn];
    
    WEAK_SELF(self);
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(@60);
        make.size.mas_equalTo(CGSizeMake(183.5, 186.5));
    }];
    
    [self.resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(@20);
        make.right.equalTo(@-20);
        make.top.equalTo(self.imageView.mas_bottom).offset(50);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(@10);
        make.right.equalTo(@-10);
        make.top.equalTo(self.resultLabel.mas_bottom).offset(18);
    }];
    
    float resetBtnOffset = 75;
    if (iPhone4) {
        resetBtnOffset = 20;
    } else if (iPhone5) {
        resetBtnOffset = 50;
    }
    
    [self.resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(self.contentLabel.mas_bottom).offset(resetBtnOffset);
        make.centerX.equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(250, 45));
    }];
}

#pragma mark - get & set
- (UIImageView *)imageView
{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img-shz"]];
    }
    return _imageView;
}

- (UILabel *)resultLabel
{
    if (_resultLabel == nil) {
        _resultLabel = [[UILabel alloc] init];
        _resultLabel.font = [UIFont systemFontOfSize:20];
        _resultLabel.textColor = UIColorFromHEX(0x333333, 1);
        _resultLabel.numberOfLines = 0;
        _resultLabel.text = @"提交成功，请等待管理员审核！";
        _resultLabel.textAlignment = NSTextAlignmentCenter;
        [_resultLabel sizeToFit];
    }
    return _resultLabel;
}

- (UILabel *)contentLabel
{
    if (_contentLabel == nil) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.textColor = UIColorFromHEX(0x999999, 1);
        _contentLabel.numberOfLines = 0;
        _contentLabel.text = @"预计3个工作日内审核完毕，审核结果会短信通知到您的注册手机上";
        [_contentLabel sizeToFit];
    }
    return _contentLabel;
}

- (BATGraditorButton *)resetBtn
{
    if (_resetBtn == nil) {
        _resetBtn = [BATGraditorButton buttonWithType:UIButtonTypeCustom];
        [_resetBtn setTitle:@"重新认证" forState:UIControlStateNormal];
//        [_resetBtn setTitleColor:UIColorFromHEX(0xffffff, 1) forState:UIControlStateNormal];
        _resetBtn.titleColor = [UIColor whiteColor];
    //    [_resetBtn setBackgroundImage:[Tools imageFromColor:UIColorFromHEX(0x45a0f0, 1)] forState:UIControlStateNormal];
        _resetBtn.enablehollowOut = YES;
        [_resetBtn setGradientColors:@[START_COLOR,END_COLOR]];
        [_resetBtn addTarget:self action:@selector(resetBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _resetBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _resetBtn.layer.cornerRadius = 50 / 2;
        _resetBtn.layer.masksToBounds = YES;
    }
    return _resetBtn;
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
