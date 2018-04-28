//
//  BATTraditionFirstViewController.m
//  HealthBAT_Pro
//
//  Created by Skybrim on 2017/3/24.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATTraditionFirstViewController.h"
#import "TXHRrettyRuler.h"

#import "BATTraditonMedicineModel.h"

#import "BATTraditionSecondViewController.h"

@interface BATTraditionFirstViewController ()<TXHRrettyRulerDelegate>

@property (nonatomic,strong) UIButton *popBtn;
@property (nonatomic,strong) UIImageView *backgroundView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *detailLabel;
@property (nonatomic,strong) UILabel *heightDesLabel;
@property (nonatomic,strong) UILabel *heightLabel;
@property (nonatomic,strong) TXHRrettyRuler *heightRuler;
@property (nonatomic,strong) UILabel *weightDesLabel;
@property (nonatomic,strong) UILabel *weightLabel;
@property (nonatomic,strong) TXHRrettyRuler *weightRuler;
@property (nonatomic,strong) UIButton *nextBtn;

@property (nonatomic,strong) BATTraditonMedicineModel *model;

@end

@implementation BATTraditionFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.model = [[BATTraditonMedicineModel alloc] init];

    [self layoutPages];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}

//- (void)viewWillDisappear:(BOOL)animated {
//    
//    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)txhRrettyRuler:(TXHRulerScrollView *)rulerScrollView {
    
    if (rulerScrollView == self.heightRuler.rulerScrollView) {
        self.heightLabel.text = [NSString stringWithFormat:@"%.0fCM",rulerScrollView.rulerValue];
        self.model.Height = rulerScrollView.rulerValue;
    }
    else if (rulerScrollView == self.weightRuler.rulerScrollView) {
        self.weightLabel.text = [NSString stringWithFormat:@"%.0fKG",rulerScrollView.rulerValue];
        self.model.Weight = rulerScrollView.rulerValue;

    }
}

#pragma mark - layout
- (void)layoutPages {
    
    WEAK_SELF(self);
    
    [self.view addSubview:self.backgroundView];
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT));
    }];
    
    [self.view addSubview:self.popBtn];
    [self.popBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.top.equalTo(@30);
    }];
    
    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerX.equalTo(@0);
        make.top.equalTo(self.popBtn.mas_bottom).offset(15);
    }];
    
    [self.view addSubview:self.detailLabel];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerX.equalTo(@0);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
    }];
    
    [self.view addSubview:self.heightDesLabel];
    [self.heightDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerX.equalTo(@0);
        make.top.equalTo(self.detailLabel.mas_bottom).offset(20);
    }];
    
    [self.view addSubview:self.heightLabel];
    [self.heightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerX.equalTo(@0);
        make.top.equalTo(self.heightDesLabel.mas_bottom).offset(15);
    }];
    
    [self.view addSubview:self.heightRuler];
    [self.heightRuler mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(self.heightLabel.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-125, 80));
    }];
    
    [self.view addSubview:self.weightDesLabel];
    [self.weightDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerX.equalTo(@0);
        make.top.equalTo(self.heightRuler.mas_bottom).offset(20);
    }];

    [self.view addSubview:self.weightLabel];
    [self.weightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerX.equalTo(@0);
        make.top.equalTo(self.weightDesLabel.mas_bottom).offset(15);
    }];

    [self.view addSubview:self.weightRuler];
    [self.weightRuler mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerX.equalTo(@0);
        make.top.equalTo(self.weightLabel.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-125, 80));
    }];

    [self.view addSubview:self.nextBtn];
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerX.equalTo(@0);
        make.top.equalTo(self.weightRuler.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
}

#pragma mark - getter
- (UIImageView *)backgroundView {
    
    if (!_backgroundView) {
        
        _backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guoyiguan-back"]];
        
    }
    return _backgroundView;
}

- (UIButton *)popBtn {
    
    if (!_popBtn) {
        _popBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_popBtn setImage:[UIImage imageNamed:@"back-icon-w"] forState:UIControlStateNormal];
        [_popBtn bk_whenTapped:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    return _popBtn;
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithFont:[UIFont boldSystemFontOfSize:24] textColor:UIColorFromHEX(0xffffff, 1) textAlignment:NSTextAlignmentCenter];
        _titleLabel.text = @"初次见面，您好！";
    }
    return _titleLabel;
}

- (UILabel *)detailLabel {
    
    if (!_detailLabel) {
        _detailLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:UIColorFromHEX(0xffffff, 1) textAlignment:NSTextAlignmentCenter];
        _detailLabel.text = @"先让我们了解您的基本身体条件";
    }
    return _detailLabel;
}

- (UILabel *)heightDesLabel {
    
    if (!_heightDesLabel) {
        _heightDesLabel = [UILabel labelWithFont:[UIFont boldSystemFontOfSize:20] textColor:UIColorFromHEX(0xffffff, 1) textAlignment:NSTextAlignmentCenter];
        _heightDesLabel.text = @"身高";
    }
    return _heightDesLabel;
}

- (UILabel *)heightLabel {
    
    if (!_heightLabel) {
        _heightLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:13] textColor:UIColorFromHEX(0xffffff, 1) textAlignment:NSTextAlignmentCenter];
    }
    return _heightLabel;
}


- (TXHRrettyRuler *)heightRuler {
    
    if (!_heightRuler) {
        _heightRuler = [[TXHRrettyRuler alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-125, 80)];
        _heightRuler.backgroundColor = [UIColor clearColor];
        _heightRuler.rulerDeletate = self;
        [_heightRuler showRulerScrollViewWithCount:250 average:@1 currentValue:175 smallMode:YES];
    }
    return _heightRuler;
}

- (UILabel *)weightDesLabel {
    
    if (!_weightDesLabel) {
        _weightDesLabel = [UILabel labelWithFont:[UIFont boldSystemFontOfSize:20] textColor:UIColorFromHEX(0xffffff, 1) textAlignment:NSTextAlignmentCenter];
        _weightDesLabel.text = @"体重";
    }
    return _weightDesLabel;
}


- (UILabel *)weightLabel {
    
    if (!_weightLabel) {
        _weightLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:13] textColor:UIColorFromHEX(0xffffff, 1) textAlignment:NSTextAlignmentCenter];
    }
    return _weightLabel;
}

- (TXHRrettyRuler *)weightRuler {
    
    if (!_weightRuler) {
        _weightRuler = [[TXHRrettyRuler alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-125, 80)];
        _weightRuler.backgroundColor = [UIColor clearColor];
        _weightRuler.rulerDeletate = self;
        [_weightRuler showRulerScrollViewWithCount:250 average:@1 currentValue:75 smallMode:YES];
    }
    return _weightRuler;
}

- (UIButton *)nextBtn {
    
    if (!_nextBtn) {
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextBtn setTitle:@"下一页" forState:UIControlStateNormal];
        _nextBtn.layer.cornerRadius = 40.f;
        _nextBtn.layer.borderWidth = 2.0f;
        _nextBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        [_nextBtn bk_whenTapped:^{
            
            BATTraditionSecondViewController *secondVC = [[BATTraditionSecondViewController alloc] init];
            secondVC.model = self.model;
            [self.navigationController pushViewController:secondVC animated:YES];
        }];
    }
    return _nextBtn;
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
