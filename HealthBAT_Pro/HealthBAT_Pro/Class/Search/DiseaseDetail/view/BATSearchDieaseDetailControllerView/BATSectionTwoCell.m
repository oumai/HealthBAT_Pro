//
//  BATSectionTwoCell.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/5/8.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATSectionTwoCell.h"

@interface BATSectionTwoCell()



@property (nonatomic,strong) BATGraditorButton *doctorBtn;

@property (nonatomic,strong) BATGraditorButton *hosptialBtn;

@property (nonatomic,strong) BATGraditorButton *drugBtn;

@property (nonatomic,strong) BATGraditorButton *doctor160Btn;

@property (nonatomic,strong) UIView *bottomView;

@property (nonatomic,strong) BATGraditorButton *moveLine;

@end

@implementation BATSectionTwoCell

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pageChange:) name:@"RELOADDIEASECOLLECTIONVIEWCELL" object:nil];
        
        WEAK_SELF(self);
        [self.contentView addSubview:self.doctorBtn];
        [self.doctorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            STRONG_SELF(self);
            make.left.top.bottom.equalTo(self.contentView);
            make.width.mas_equalTo(SCREEN_WIDTH/4);
            
        }];
        
        [self.contentView addSubview:self.hosptialBtn];
        [self.hosptialBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           
            STRONG_SELF(self);
            make.centerY.equalTo(self.doctorBtn.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/4, 45));
            make.left.equalTo(self.doctorBtn.mas_right).offset(0);
            
        }];
        
        [self.contentView addSubview:self.drugBtn];
        [self.drugBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           
            STRONG_SELF(self);
            make.centerY.equalTo(self.doctorBtn.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/4, 45));
            make.left.equalTo(self.hosptialBtn.mas_right).offset(0);
            
        }];
        
        [self.contentView addSubview:self.doctor160Btn];
        [self.doctor160Btn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            STRONG_SELF(self);
            make.centerY.equalTo(self.doctorBtn.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/4, 45));
            make.left.equalTo(self.drugBtn.mas_right).offset(0);
            
        }];
        
        [self.contentView addSubview:self.bottomView];
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            STRONG_SELF(self);
            make.left.bottom.right.equalTo(self.contentView).offset(0);
            make.height.mas_equalTo(1);
        }];
        
        for (int i=0; i<3; i++) {
            UIView *verView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/4*i +SCREEN_WIDTH/4, 7.5, 1, 30)];
            verView.backgroundColor = BASE_LINECOLOR;
            [self.contentView addSubview:verView];
        }
        
        NSInteger padding = (SCREEN_WIDTH/4 - 61)/2;
        [self.contentView addSubview:self.moveLine];
        [self.moveLine mas_makeConstraints:^(MASConstraintMaker *make) {
           
            STRONG_SELF(self);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(0);
            make.size.mas_equalTo(CGSizeMake(61, 2));
            make.left.equalTo(self.contentView.mas_left).offset(padding);
            
        }];
        
//        UILabel *lb = [[UILabel alloc]init];
//        lb.text = @"医生推荐";
//        lb.font = [UIFont systemFontOfSize:15];
//        CGSize size = [lb.text boundingRectWithSize:CGSizeMake(200, 50) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size;
//        NSLog(@">>>>>>%@",NSStringFromCGSize(size));
        
        
        
    }
    return self;
}

- (BATGraditorButton *)doctorBtn {

    if (!_doctorBtn) {
        _doctorBtn = [[BATGraditorButton alloc]init];
        _doctorBtn.enbleGraditor = YES;
        _doctorBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_doctorBtn setTitle:@"医生推荐" forState:UIControlStateNormal];
        [_doctorBtn setGradientColors:@[START_COLOR,END_COLOR]];
        _doctorBtn.tag = 0;
        [_doctorBtn addTarget:self action:@selector(changeColor:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doctorBtn;
}

- (BATGraditorButton *)hosptialBtn {
    
    if (!_hosptialBtn) {
        _hosptialBtn = [[BATGraditorButton alloc]init];
        _hosptialBtn.enbleGraditor = YES;
        _hosptialBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_hosptialBtn setTitle:@"相关医院" forState:UIControlStateNormal];
        [_hosptialBtn setGradientColors:@[UIColorFromHEX(0X333333, 1)]];
        _hosptialBtn.tag = 1;
        [_hosptialBtn addTarget:self action:@selector(changeColor:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _hosptialBtn;
}


- (BATGraditorButton *)drugBtn {
    
    if (!_drugBtn) {
        _drugBtn = [[BATGraditorButton alloc]init];
        _drugBtn.enbleGraditor = YES;
        _drugBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_drugBtn setTitle:@"药品百科" forState:UIControlStateNormal];
        [_drugBtn setGradientColors:@[UIColorFromHEX(0X333333, 1)]];
        _drugBtn.tag = 2;
        [_drugBtn addTarget:self action:@selector(changeColor:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _drugBtn;
}


- (BATGraditorButton *)doctor160Btn {
    
    if (!_doctor160Btn) {
        _doctor160Btn = [[BATGraditorButton alloc]init];
        _doctor160Btn.enbleGraditor = YES;
        _doctor160Btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_doctor160Btn setTitle:@"预约挂号" forState:UIControlStateNormal];
        [_doctor160Btn setGradientColors:@[UIColorFromHEX(0X333333, 1)]];
        _doctor160Btn.tag = 3;
        [_doctor160Btn addTarget:self action:@selector(changeColor:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doctor160Btn;
}

- (UIView *)bottomView {

    if (!_bottomView) {
        _bottomView = [[UIView alloc]init];
        _bottomView.backgroundColor = BASE_LINECOLOR;
    }
    return _bottomView;
}

- (BATGraditorButton *)moveLine {

    if (!_moveLine) {
        _moveLine = [[BATGraditorButton alloc]init];
        _moveLine.enablehollowOut = YES;
        [_moveLine setGradientColors:@[START_COLOR,END_COLOR]];
    }
    return _moveLine;
}

#pragma mark - Action
- (void)pageChange:(NSNotification *)notice {
    
    NSInteger page = [notice.object integerValue];
    
    for (id objecet in self.contentView.subviews) {
        if ([objecet isKindOfClass:[BATGraditorButton class]]) {
            BATGraditorButton *btn = objecet;
            
            [btn setGradientColors:@[UIColorFromHEX(0X333333, 1)]];
        }
    }
    
    for (id objecet in self.contentView.subviews) {
        if ([objecet isKindOfClass:[BATGraditorButton class]]) {
            BATGraditorButton *btn = objecet;
            
            if (btn.tag == page) {
                [btn setGradientColors:@[START_COLOR,END_COLOR]];
                 NSInteger padding = (SCREEN_WIDTH/4 - 61)/2;
                WEAK_SELF(self);
                [self.moveLine mas_updateConstraints:^(MASConstraintMaker *make) {
                    
                    STRONG_SELF(self);
                    make.left.equalTo(self.contentView).offset(SCREEN_WIDTH/4*btn.tag + padding);
                }];
                
                [UIView animateWithDuration:0.5 animations:^{
                    
                    [self setNeedsLayout];
                    [self layoutIfNeeded];
                    
                }];
            }
        }
    }
    
}

- (void)changeColor:(BATGraditorButton *)btn {

    
    
    for (id objecet in self.contentView.subviews) {
        if ([objecet isKindOfClass:[BATGraditorButton class]]) {
            BATGraditorButton *btn = objecet;
            
            [btn setGradientColors:@[UIColorFromHEX(0X333333, 1)]];
        }
    }
    
    [btn setGradientColors:@[START_COLOR,END_COLOR]];
    
    NSInteger padding = (SCREEN_WIDTH/4 - 61)/2;

    
    WEAK_SELF(self);
    [self.moveLine mas_updateConstraints:^(MASConstraintMaker *make) {
        
        STRONG_SELF(self);
        make.left.equalTo(self.contentView).offset(SCREEN_WIDTH/4*btn.tag + padding);
    }];
    
    [UIView animateWithDuration:0.5 animations:^{
       
        [self setNeedsLayout];
        [self layoutIfNeeded];
       
    }];
    
    if (self.sectionTwoBlockAction) {
        self.sectionTwoBlockAction(btn.tag);
    }
}




@end
