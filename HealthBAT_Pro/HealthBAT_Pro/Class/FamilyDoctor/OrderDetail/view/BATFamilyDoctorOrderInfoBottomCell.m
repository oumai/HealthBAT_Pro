//
//  BATFamilyDoctorOrderInfoBottomCell.m
//  HealthBAT_Pro
//
//  Created by four on 2017/4/17.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATFamilyDoctorOrderInfoBottomCell.h"

@implementation BATFamilyDoctorOrderInfoBottomCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self pageLayouts];
    }
    
    return self;
}

- (void)pageLayouts{
    
    [self.contentView addSubview:self.orderNumberLabel];
    [self.orderNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(15);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.width.mas_equalTo(@90);
    }];
    
    [self.contentView addSubview:self.orderNumberDescLabel];
    [self.orderNumberDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.orderNumberLabel.mas_right).offset(0);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.top.equalTo(self.orderNumberLabel.mas_top);
    }];
    
    [self.contentView addSubview:self.serverCostLabel];
    [self.serverCostLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orderNumberDescLabel.mas_bottom).offset(15);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.width.mas_equalTo(@70);
    }];
    
    [self.contentView addSubview:self.serverCostDescLabel];
    [self.serverCostDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.serverCostLabel.mas_top);
        make.left.equalTo(self.serverCostLabel.mas_right).offset(0);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (UILabel *)orderNumberLabel{
    if (!_orderNumberLabel) {
        _orderNumberLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:16] textColor:UIColorFromHEX(0x999999, 1) textAlignment:NSTextAlignmentLeft];
        _orderNumberLabel.text = @"订单编号：";
    }
    
    return _orderNumberLabel;
}

- (UILabel *)orderNumberDescLabel{
    if (!_orderNumberDescLabel) {
        _orderNumberDescLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:16] textColor:UIColorFromHEX(0X333333, 1) textAlignment:NSTextAlignmentLeft];
        _orderNumberDescLabel.numberOfLines = 0;
        
    }
    
    return _orderNumberDescLabel;
}

- (UILabel *)serverCostLabel{
    if (!_serverCostLabel) {
        _serverCostLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:16] textColor:UIColorFromHEX(0x999999, 1) textAlignment:NSTextAlignmentLeft];
        _serverCostLabel.text = @"服务费：";
    }
    
    return _serverCostLabel;
}

- (UILabel *)serverCostDescLabel{
    if (!_serverCostDescLabel) {
        _serverCostDescLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:16] textColor:UIColorFromHEX(0xf70c0c, 1) textAlignment:NSTextAlignmentLeft];
        _serverCostDescLabel.numberOfLines = 0;
    }
    
    return _serverCostDescLabel;
}


@end
