//
//  BATDrugOrderTableViewCell.m
//  HealthBAT_Pro
//
//  Created by wct on 2017/12/14.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDrugOrderTableViewCell.h"
#import "UIImage+Tool.h"
@implementation BATDrugOrderTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self layout];
    }
    return self;
}

- (void)cellReloadWithModel:(BATDrugOrderListDataModel *)data{
    
    self.orderCodeLabel.text = [NSString stringWithFormat:@"订单编号：%@",data.Order.OrderNo];
    self.timeLabel.text = [data.Order.OrderTime substringToIndex:10];
    self.prescriptionNameLabel.text = data.RecipeFiles[0].RecipeName;
    self.moneyLabel.text = [NSString stringWithFormat:@"总价:￥%@",[NSString decimalNumberWithDouble:data.Order.TotalFee]];
    self.countLabel.text = [NSString stringWithFormat:@"共计%@件商品",data.RecipeFiles[0].TCMQuantity];
    

    /* "OrderState": 0,//订单状态（state：0-待支付、1-已支付、2-已完成、3-已取消）*/
    self.payBtn.hidden = YES;
    self.logisticsBtn.hidden = YES;
    self.cancelBtn.hidden = YES;
    self.otherBtn.hidden = YES;
    
    switch (data.Order.OrderState) {
        case -1:
        {
            //付款
            self.payBtn.hidden = NO;
        }
            break;
        case 0:
        {
            //付款
            self.payBtn.hidden = NO;
        }
            break;
        case 1:
        {
            //取消+产看物流（已经付款，但未发货）
            self.logisticsBtn.hidden = NO;
            
            if (data.Order.LogisticState < 0) {
                //待审核
                self.otherBtn.hidden = NO;
            }
            else {
               //已经提交审核
                self.otherBtn.hidden = YES;
            }
        }
            break;
        case 2:
        {
            //查看物流（已经发货）
            self.logisticsBtn.hidden = NO;
        }
            break;
        case 3:
        {
            //已取消（付款后，未发货之前取消）
            self.cancelBtn.hidden = NO;
        }
            break;
        default:
            break;
    }
}

- (void)layout{
    
    //分割线
    UIView *topLine = [[UIView alloc]initWithFrame:CGRectZero];
    topLine.backgroundColor = BASE_LINECOLOR;
    [self.contentView addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@10);
        make.right.equalTo(@-10);
        make.top.equalTo(@34);
        make.height.mas_equalTo(0.5);
    }];
    
    //分割线
    UIView *midLine = [[UIView alloc]initWithFrame:CGRectZero];
    midLine.backgroundColor = BASE_LINECOLOR;
    [self.contentView addSubview:midLine];
    [midLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@10);
        make.right.equalTo(@-10);
        make.top.equalTo(topLine.mas_bottom).offset(60);
        make.height.mas_equalTo(0.5);
    }];
    
    //分割线
    UIView *bottomLine = [[UIView alloc]initWithFrame:CGRectZero];
    bottomLine.backgroundColor = BASE_LINECOLOR;
    [self.contentView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@10);
        make.right.equalTo(@-10);
        make.top.equalTo(midLine.mas_bottom).offset(45);
        make.height.mas_equalTo(0.5);
    }];
    
    
    WEAK_SELF(self);
    
    [self.contentView addSubview:self.orderCodeLabel];
    [self.orderCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@10);
        make.left.equalTo(@10);
    }];
    
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@-10);
        make.top.equalTo(@10);
    }];
    
 
    [self.contentView addSubview:self.prescriptionNameLabel];
    [self.prescriptionNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(topLine.mas_bottom).offset(10);
        make.left.equalTo(@10);
        make.right.equalTo(@-10);
        make.bottom.lessThanOrEqualTo(midLine.mas_top);
    }];
    
    [self.contentView addSubview:self.moneyLabel];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(midLine.mas_bottom).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
    }];
    
    [self.contentView addSubview:self.countLabel];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerY.equalTo(self.moneyLabel.mas_centerY).offset(0);
        make.right.equalTo(self.moneyLabel.mas_left).offset(-10);
    }];
    
    [self.contentView addSubview:self.payBtn];
    [self.payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(bottomLine.mas_bottom).offset(10);
        make.height.mas_equalTo(30);
    }];
    
    [self.contentView addSubview:self.logisticsBtn];
    [self.logisticsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(bottomLine.mas_bottom).offset(10);
        make.height.mas_equalTo(30);
    }];
    
    [self.contentView addSubview:self.cancelBtn];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(bottomLine.mas_bottom).offset(10);
        make.height.mas_equalTo(30);
    }];
    
    [self.contentView addSubview:self.otherBtn];
    [self.otherBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.right.equalTo(self.logisticsBtn.mas_left).offset(-10);
        make.top.equalTo(bottomLine.mas_bottom).offset(10);
        make.centerY.equalTo(self.logisticsBtn.mas_centerY).offset(0);
        make.height.mas_equalTo(30);
    }];
}

#pragma mark - setter&getter

- (UILabel *)orderCodeLabel {
    
    if (_orderCodeLabel == nil) {
        _orderCodeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
//        _orderCodeLabel.text = @"订单标号：cf2017121411111111";
        _orderCodeLabel.textColor = UIColorFromHEX(0x666666, 1);
        _orderCodeLabel.font = [UIFont systemFontOfSize:15];
        _orderCodeLabel.textAlignment = NSTextAlignmentLeft;
        [_orderCodeLabel sizeToFit];
    }
    return _orderCodeLabel;
}

- (UILabel *)timeLabel {
    
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
//        _timeLabel.text = @"2017-09-20";
        _timeLabel.textColor = UIColorFromHEX(0x666666, 1);
        _timeLabel.font = [UIFont systemFontOfSize:15];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        [_timeLabel sizeToFit];
    }
    return _timeLabel;
}

- (UILabel *)prescriptionNameLabel {
    
    if (_prescriptionNameLabel == nil) {
        _prescriptionNameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
//        _prescriptionNameLabel.text = @"处方单名称";
        _prescriptionNameLabel.textColor = UIColorFromHEX(0x666666, 1);
        _prescriptionNameLabel.font = [UIFont systemFontOfSize:15];
        _prescriptionNameLabel.textAlignment = NSTextAlignmentLeft;
        [_prescriptionNameLabel sizeToFit];
    }
    return _prescriptionNameLabel;
}

- (UILabel *)moneyLabel {
    
    if (_moneyLabel == nil) {
        _moneyLabel = [[UILabel alloc]initWithFrame:CGRectZero];
//        _moneyLabel.text = @"共计100件物品";
        _moneyLabel.textColor = UIColorFromHEX(0x666666, 1);
        _moneyLabel.font = [UIFont systemFontOfSize:15];
        _moneyLabel.textAlignment = NSTextAlignmentRight;
        [_moneyLabel sizeToFit];
    }
    return _moneyLabel;
}

- (UILabel *)countLabel {
    
    if (_countLabel == nil) {
        _countLabel = [[UILabel alloc]initWithFrame:CGRectZero];
//        _countLabel.text = @"总价：￥100";
        _countLabel.textColor = UIColorFromHEX(0x666666, 1);
        _countLabel.font = [UIFont systemFontOfSize:15];
        _countLabel.textAlignment = NSTextAlignmentRight;
        [_countLabel sizeToFit];
    }
    return _countLabel;
}

- (BATGraditorButton *)payBtn{
    
    if (_payBtn == nil) {
        _payBtn = [BATGraditorButton buttonWithType:UIButtonTypeCustom];
        _payBtn.layer.cornerRadius = 5.0;
        _payBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _payBtn.layer.masksToBounds = YES;
        [_payBtn setGradientColors:@[START_COLOR,END_COLOR]];
//        _payBtn.enablehollowOut = NO;
        
        [_payBtn setTitle:@"  付款  " forState:UIControlStateNormal];
        [_payBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [_payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_payBtn setBackgroundImage:[UIImage createImageWithColor:UIColorFromHEX(0x2accbe, 1)] forState:UIControlStateHighlighted];
        
        WEAK_SELF(self);
        [_payBtn bk_whenTapped:^{
            
            STRONG_SELF(self);
            if (self.ClickBaseBtn) {
                self.ClickBaseBtn();
            }
        }];
    }
    return _payBtn;
}

- (UIButton *)logisticsBtn{
    
    if (_logisticsBtn == nil) {
        _logisticsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _logisticsBtn.clipsToBounds = YES;
        _logisticsBtn.layer.cornerRadius = 5.0;
        _logisticsBtn.layer.borderColor = UIColorFromHEX(0x666666, 1).CGColor;
        _logisticsBtn.layer.borderWidth = 0.5;
        [_logisticsBtn setTitleColor:UIColorFromHEX(0x666666, 1) forState:UIControlStateNormal];
        [_logisticsBtn setBackgroundImage:[UIImage createImageWithColor:UIColorFromHEX(0xf0f0f0, 1)] forState:UIControlStateHighlighted];
        _logisticsBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        
        [_logisticsBtn setTitle:@"  查看物流  " forState:UIControlStateNormal];
        
        WEAK_SELF(self);
        [_logisticsBtn bk_whenTapped:^{
            
            STRONG_SELF(self);
            if (self.ClickBaseBtn) {
                self.ClickBaseBtn();
            }
        }];
    }
    return _logisticsBtn;
}

- (UIButton *)cancelBtn{
    
    if (_cancelBtn == nil) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.clipsToBounds = YES;
        _cancelBtn.layer.cornerRadius = 5.0;
        _cancelBtn.layer.borderColor = UIColorFromHEX(0x666666, 1).CGColor;
        _cancelBtn.layer.borderWidth = 0.5;
        [_cancelBtn setTitleColor:UIColorFromHEX(0x666666, 1) forState:UIControlStateNormal];
        [_cancelBtn setBackgroundImage:[UIImage createImageWithColor:UIColorFromHEX(0xf0f0f0, 1)] forState:UIControlStateHighlighted];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        
        [_cancelBtn setTitle:@"  已取消 " forState:UIControlStateNormal];
        
        WEAK_SELF(self);
        [_otherBtn bk_whenTapped:^{
            
            STRONG_SELF(self);
            if (self.ClickBaseBtn) {
                self.ClickBaseBtn();
            }
        }];
    }
    return _cancelBtn;
}
- (UIButton *)otherBtn{
    
    if (_otherBtn == nil) {
        _otherBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _otherBtn.clipsToBounds = YES;
        _otherBtn.layer.cornerRadius = 5.0;
        _otherBtn.layer.borderColor = UIColorFromHEX(0x666666, 1).CGColor;
        _otherBtn.layer.borderWidth = 0.5;
        [_otherBtn setTitleColor:UIColorFromHEX(0x666666, 1) forState:UIControlStateNormal];
        [_otherBtn setBackgroundImage:[UIImage createImageWithColor:UIColorFromHEX(0xf0f0f0, 1)] forState:UIControlStateHighlighted];
        _otherBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_otherBtn setTitle:@"  取消  " forState:UIControlStateNormal];

        WEAK_SELF(self);
        [_otherBtn bk_whenTapped:^{
            
            STRONG_SELF(self);
            if (self.ClickOtherBtn) {
                self.ClickOtherBtn();
            }
        }];
    }
    return _otherBtn;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
