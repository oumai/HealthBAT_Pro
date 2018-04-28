//
//  BATNewPayServerInfoCell.m
//  HealthBAT_Pro
//
//  Created by four on 2017/5/11.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATNewPayServerInfoCell.h"

@implementation BATNewPayServerInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
    
        [self setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0.5];
        
        [self pageLayouts];
    }
    
    return self;
}

- (void)pageLayouts{
    
    WEAK_SELF(self);
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_left).offset(10);
    }];
    
    [self.contentView addSubview:self.deseLabel];
    [self.deseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        
    }];
}



- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:UIColorFromHEX(0x333333, 1) textAlignment:NSTextAlignmentLeft];
        [_titleLabel sizeToFit];
    }
    
    return _titleLabel;
}

- (UILabel *)deseLabel{
    if (!_deseLabel) {
        _deseLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:UIColorFromHEX(0x333333, 1) textAlignment:NSTextAlignmentLeft];
        [_deseLabel sizeToFit];
    }
    
    return _deseLabel;
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
