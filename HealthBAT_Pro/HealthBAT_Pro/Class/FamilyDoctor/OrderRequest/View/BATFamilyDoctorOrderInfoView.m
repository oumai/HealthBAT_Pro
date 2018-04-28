//
//  BATFamilyDoctorOrderInfoView.m
//  HealthBAT_Pro
//
//  Created by four on 17/3/16.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATFamilyDoctorOrderInfoView.h"

@implementation BATFamilyDoctorOrderInfoView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:1];
        [self setTopBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:1];
        
        WEAK_SELF(self);
        [self addSubview:self.buyerLabel];
        [self.buyerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(@20);
            make.left.equalTo(self.mas_left).offset(12);
        }];
        
        [self addSubview:self.phoneLabel];
        [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerY.equalTo(self.buyerLabel.mas_centerY);
            make.right.equalTo(self.mas_right).offset(-12);
        }];
        
        [self addSubview:self.line];
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.buyerLabel.mas_bottom).offset(13);
            make.left.equalTo(self.mas_left).offset(12);
            make.right.equalTo(self.mas_right).offset(12);
            make.height.mas_equalTo(0.5f);
        }];
        
        [self addSubview:self.serviceTypeLable];
        [self.serviceTypeLable mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.line.mas_bottom).offset(13);
            make.left.equalTo(self.mas_left).offset(12);
            make.right.equalTo(self.mas_right).offset(-12);
        }];
        
        
        [self addSubview:self.serviceTimeLabel];
        [self.serviceTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.serviceTypeLable.mas_bottom).offset(12);
            make.left.equalTo(self.mas_left).offset(12);
            make.right.equalTo(self.mas_right).offset(-13);
        }];
        
        [self addSubview:self.serviceCostLabel];
        [self.serviceCostLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.serviceTimeLabel.mas_bottom).offset(12);
            make.left.equalTo(self.mas_left).offset(12);
            make.right.equalTo(self.mas_right).offset(-13);
        }];
        
    }
    return self;
}


- (void)loadFamilyDoctorOrderDetail:(BATFamilyDoctorOrderDetailModel *)orderModel{

    
    if (orderModel !=nil) {
        _buyerLabel.text = [NSString stringWithFormat:@"买方：%@",orderModel.Data.TrueName];
        _phoneLabel.text = [NSString stringWithFormat:@"电话：%@",orderModel.Data.PhoneNumber];
        _serviceTypeLable.text = [NSString stringWithFormat:@"服务内容：%@",orderModel.Data.FamilyService];
        _serviceTimeLabel.text = [NSString stringWithFormat:@"服务时间：%@",orderModel.Data.ServerTime];
        
        
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"服务费用：￥%.2f",orderModel.Data.OrderMoney]];
        [AttributedStr addAttribute:NSForegroundColorAttributeName
         
                              value:UIColorFromHEX(0x333333, 1)
         
                              range:NSMakeRange(0, 5)];
        _serviceCostLabel.attributedText = AttributedStr;
    }
}

- (UILabel *)buyerLabel{
    if (!_buyerLabel) {
        _buyerLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:16] textColor:UIColorFromHEX(0x333333, 1) textAlignment:NSTextAlignmentLeft];
        _buyerLabel.text = @"买方：小明";
        [_buyerLabel sizeToFit];
    }
    
    return _buyerLabel;
}


- (UILabel *)phoneLabel{
    if (!_phoneLabel) {
        _phoneLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:16] textColor:UIColorFromHEX(0x333333, 1) textAlignment:NSTextAlignmentRight];
        _phoneLabel.text = @"电话：00000000000";
        [_phoneLabel sizeToFit];
    }
    
    return _phoneLabel;
}



- (UIView *)line{
    if (!_line) {
        _line = [[UIView alloc]initWithFrame:CGRectZero];
        _line.backgroundColor = UIColorFromHEX(0xcccccc, 1);
    }
    
    return _line;
}



- (UILabel *)serviceTypeLable{
    if (!_serviceTypeLable) {
        _serviceTypeLable = [UILabel labelWithFont:[UIFont systemFontOfSize:16] textColor:UIColorFromHEX(0x333333, 1) textAlignment:NSTextAlignmentLeft];
        _serviceTypeLable.text = @"服务内容：图文咨询";
        [_serviceTypeLable sizeToFit];
    }
    
    return _serviceTypeLable;
}


- (UILabel *)serviceTimeLabel{
    if (!_serviceTimeLabel) {
        _serviceTimeLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:16] textColor:UIColorFromHEX(0x333333, 1) textAlignment:NSTextAlignmentLeft];
        _serviceTimeLabel.text = @"服务时间：0000-00-00~0000-00-00";
        [_serviceTimeLabel sizeToFit];
    }
    
    return _serviceTimeLabel;
}


- (UILabel *)serviceCostLabel{
    if (!_serviceCostLabel) {
        _serviceCostLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:16] textColor:UIColorFromHEX(0xff8c28, 1) textAlignment:NSTextAlignmentLeft];
        _serviceCostLabel.text = @"服务费用：￥0";

        [_serviceCostLabel sizeToFit];
    }
    
    return _serviceCostLabel;
}

@end
