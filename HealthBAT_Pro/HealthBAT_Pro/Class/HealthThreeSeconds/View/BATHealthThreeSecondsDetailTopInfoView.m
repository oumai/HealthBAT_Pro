//
//  BATHealthThreeSecondsDetailTopInfoView.m
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/12/22.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHealthThreeSecondsDetailTopInfoView.h"
#import "BATHealthThreeSecondsTopChangeDateView.h"
#import "UIColor+Gradient.h"
#import "BATPerson.h"

@interface BATHealthThreeSecondsDetailTopInfoView ()

@property (nonatomic, strong) UILabel *calorieTitleLabel;
@property (nonatomic, strong) UILabel *calorieValueLabel;
@property (nonatomic, strong) UILabel *calorieValueUnitLabel;
@property (nonatomic, strong) UILabel *reportTitleLabel;
@property (nonatomic, strong) UILabel *reportValueLabel;
@property (nonatomic, strong) UIButton *editInfoButton;
@property (nonatomic, strong) NSString *currentDateStr;
@property (nonatomic, strong) NSString *todayStr;
@property (nonatomic, strong) BATPerson *loginUserModel;


@end

@implementation BATHealthThreeSecondsDetailTopInfoView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.topChangeDateVieW];
        [self addSubview:self.editInfoButton];
        [self addSubview:self.calorieValueLabel];
        [self addSubview:self.calorieValueUnitLabel];
        [self addSubview:self.calorieTitleLabel];
        [self addSubview:self.reportValueLabel];
        [self addSubview:self.reportTitleLabel];
        self.loginUserModel = PERSON_INFO;
       
    }
    return self;
}
- (void)setCalorieValue:(double)calorieValue{
    
    NSString *reportResult = [self getReportResultWithCalories:calorieValue];
    self.calorieValueLabel.text = [NSString stringWithFormat:@"%0.2f",calorieValue];
    self.reportValueLabel.text = reportResult;
    self.editInfoButton.hidden = [reportResult isEqualToString:@"暂无法评估"] ? NO : YES;
}

/**
 根据身高体重计算评估结果
 */
- (NSString *)getReportResultWithCalories:(double )calories{
    
    CGFloat height = self.loginUserModel.Data.Height;
    CGFloat weight = self.loginUserModel.Data.Weight;
    
    //标准卡路里
    CGFloat standCalorie = 0;
    
    if (height && weight) {
        //标准体重
        CGFloat standardWeight = ABS(105-height);
        //BMI=体重/ 身高²
        CGFloat BMI = weight / pow(height, 2);
        
        standCalorie =  BMI < 18.5 ? standardWeight * 35 :
        BMI < 24   ? standardWeight * 30:
        BMI < 28   ? standardWeight * 25 : standardWeight * 25;
        
        return  standCalorie * 1.1 < calories ? @"偏高" :
        standCalorie * 0.9 < calories &&  calories < standCalorie * 1.1 ?  @"适中" :
        standCalorie * 0.9 > calories ?  @"偏低" : @"";
        
        /*
         if (BMI < 18.5) {
         
         standCalorie = standardWeight * 35;
         
         
         }else if (BMI >= 18.5 && BMI <24){
         
         standCalorie = standardWeight * 30;
         
         
         }else if (BMI >= 24 && BMI < 28){
         standCalorie = standardWeight * 25;
         
         
         }else{
         standCalorie = standardWeight * 25;
         
         
         }
         
         if (standCalorie * 1.1 < self.CaloriesIntake ) {
         return @"偏高";
         }else if (standCalorie * 0.9 < self.CaloriesIntake &&  self.CaloriesIntake < standCalorie * 1.1 ){
         return @"适中";
         }else if (standCalorie * 0.9 > self.CaloriesIntake ){
         return @"偏低";
         }
         */
    }
    
    
    return @"暂无法评估";
    
}

- (void)editInfoButtonClick{
    if (self.editButtonBlock) {
        self.editButtonBlock();
    }
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.topChangeDateVieW mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.mas_equalTo(0);
        make.height.equalTo(@50);
    }];
    
    [self.calorieValueUnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(self.mas_centerX).offset(-50);
    make.top.mas_equalTo(self.topChangeDateVieW.mas_bottom).offset(12);
        
    }];
    
    [self.calorieValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(self.calorieValueUnitLabel.mas_left);
        make.top.bottom.mas_equalTo(self.calorieValueUnitLabel);
        
    }];
    
    [self.calorieTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.calorieValueLabel.mas_left);
        make.right.mas_equalTo(self.calorieValueUnitLabel.mas_right);
    make.top.mas_equalTo(self.calorieValueLabel.mas_bottom).offset(20);

    }];

    [self.reportValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX).offset(60);
        make.top.bottom.mas_equalTo(self.calorieValueLabel);
    }];
    
    [self.reportTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.bottom.mas_equalTo(self.calorieTitleLabel);
        make.left.right.mas_equalTo(self.reportValueLabel);
        
    }];
    
    
    [self.editInfoButton mas_makeConstraints:^(MASConstraintMaker *make) {
     make.left.mas_equalTo(self.reportValueLabel.mas_right).offset(10);
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(self.reportValueLabel.mas_centerY);
        make.height.equalTo(@25);
    }];
    
}
- (BATHealthThreeSecondsTopChangeDateView *)topChangeDateVieW {
    if (!_topChangeDateVieW) {
        _topChangeDateVieW = [[BATHealthThreeSecondsTopChangeDateView alloc]init];
       
    }
    return _topChangeDateVieW;
}

- (UIButton *)editInfoButton {
    if (!_editInfoButton) {
        _editInfoButton = [[UIButton alloc]init];
        _editInfoButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _editInfoButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_editInfoButton setTitle:@"完善健康资料" forState:UIControlStateNormal];
        UIColor *btnColor = [UIColor gradientFromColor:START_COLOR toColor:END_COLOR withHeight:25];
        _editInfoButton.backgroundColor = btnColor;
        _editInfoButton.layer.cornerRadius = 25*0.5;
        _editInfoButton.layer.masksToBounds = YES;
        [_editInfoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_editInfoButton addTarget:self action:@selector(editInfoButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _editInfoButton;
}
- (UILabel *)calorieTitleLabel {
    if (!_calorieTitleLabel) {
        _calorieTitleLabel = [[UILabel alloc]init];
        _calorieTitleLabel.textAlignment = NSTextAlignmentCenter;
        _calorieTitleLabel.font = [UIFont systemFontOfSize:12];
        _calorieTitleLabel.textColor = UIColorFromHEX(0x999999, 1);
        _calorieTitleLabel.text = @"已饮食";
        
        
    }
    return _calorieTitleLabel;
}
- (UILabel *)calorieValueLabel {
    if (!_calorieValueLabel) {
        _calorieValueLabel = [[UILabel alloc]init];
        _calorieValueLabel.textAlignment = NSTextAlignmentCenter;
        _calorieValueLabel.font = [UIFont boldSystemFontOfSize:18];
        
    }
    return _calorieValueLabel;
}
- (UILabel *)calorieValueUnitLabel {
    if (!_calorieValueUnitLabel) {
        
        _calorieValueUnitLabel = [[UILabel alloc]init];
        _calorieValueUnitLabel.textAlignment = NSTextAlignmentCenter;
        _calorieValueUnitLabel.font = [UIFont systemFontOfSize:12];
        _calorieValueUnitLabel.textColor = UIColorFromHEX(0x999999, 1);
        _calorieValueUnitLabel.text = @"卡路里";
        
    }
    return _calorieValueUnitLabel;
}
- (UILabel *)reportTitleLabel {
    if (!_reportTitleLabel) {
        _reportTitleLabel = [[UILabel alloc]init];
        _reportTitleLabel.textAlignment = NSTextAlignmentCenter;
        _reportTitleLabel.font = [UIFont systemFontOfSize:12];
        _reportTitleLabel.textColor = UIColorFromHEX(0x999999, 1);
        _reportTitleLabel.text = @"评估";
        
    }
    return _reportTitleLabel;
}
- (UILabel *)reportValueLabel {
    if (!_reportValueLabel) {
        _reportValueLabel = [[UILabel alloc]init];
        _reportValueLabel.textAlignment = NSTextAlignmentCenter;
        _reportValueLabel.font = [UIFont boldSystemFontOfSize:14];
        _reportValueLabel.text = @"偏低";
        
    }
    return _reportValueLabel;
}

@end
