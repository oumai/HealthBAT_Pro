//
//  BATContractlongTextCell.m
//  HealthBAT_Pro
//
//  Created by four on 17/3/17.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATContractlongTextCell.h"

@implementation BATContractlongTextCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        WEAK_SELF(self);
        [self.contentView addSubview:self.titleLable];
        [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(@10);
            make.centerX.equalTo(self.mas_left).offset(40 + 10);
            make.width.height.mas_equalTo(80);
            make.bottom.equalTo(@-10);
        }];
        
        [self.contentView addSubview:self.midLine];
        [self.midLine mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.bottom.equalTo(self.contentView);
            make.left.equalTo(self.titleLable.mas_right);
            make.width.mas_equalTo(1);
        }];
        
        [self.contentView addSubview:self.leftLine];
        [self.leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.bottom.equalTo(self.contentView);
            make.left.equalTo(self.contentView.mas_left).offset(12);
            make.width.mas_equalTo(1);
        }];
        
        
        [self.contentView addSubview:self.rightLine];
        [self.rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.bottom.equalTo(self.contentView);
            make.right.equalTo(self.contentView.mas_right).offset(-12);
            make.width.mas_equalTo(1);
        }];
        
        [self.contentView addSubview:self.descLable];
        [self.descLable mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerY.equalTo(self.midLine.mas_centerY);
            make.left.equalTo(self.titleLable.mas_right).offset(10);
            make.right.equalTo(self.contentView);
        }];
        
        
        [self setBottomBorderWithColor:UIColorFromHEX(0xcccccc, 1) width:SCREEN_WIDTH-24 height:0.25f];
        [self setTopBorderWithColor:UIColorFromHEX(0xcccccc, 1) width:SCREEN_WIDTH-24 height:0.25f];
        [self setLeftBorderWithColor:UIColorFromHEX(0xcccccc, 1) width:0.25f height:45];
        [self setRightBorderWithColor:UIColorFromHEX(0xcccccc, 1) width:0.25f height:45];
        
    }
    
    return self;
}

- (UILabel *)titleLable{
    if (!_titleLable) {
        _titleLable = [UILabel labelWithFont:[UIFont systemFontOfSize:16] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter];
        _titleLable.text = @"服务内容";
        [_titleLable sizeToFit];
    }
    
    return _titleLable;
}

- (UILabel *)descLable{
    if (!_descLable) {
        _descLable = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
        _descLable.text = @"图文咨询";
        _descLable.numberOfLines = 0;
        [_descLable sizeToFit];
    }
    
    return _descLable;
}



- (UIView *)midLine{
    if (!_midLine) {
        _midLine = [[UIView alloc] initWithFrame:CGRectZero];
        _midLine.backgroundColor = UIColorFromHEX(0xcccccc, 1);
    }
    
    return _midLine;
}


- (UIView *)leftLine{
    if (!_leftLine) {
        _leftLine = [[UIView alloc] initWithFrame:CGRectZero];
        _leftLine.backgroundColor = UIColorFromHEX(0xcccccc, 1);
    }
    
    return _leftLine;
}

- (UIView *)rightLine{
    if (!_rightLine) {
        _rightLine = [[UIView alloc] initWithFrame:CGRectZero];
        _rightLine.backgroundColor = UIColorFromHEX(0xcccccc, 1);
    }
    
    return _rightLine;
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
