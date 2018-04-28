//
//  BATContractShoutTextCell.m
//  HealthBAT_Pro
//
//  Created by four on 17/3/17.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATContractShoutTextCell.h"

@implementation BATContractShoutTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        WEAK_SELF(self);
        [self.contentView addSubview:self.leftTitleLable];
        [self.leftTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(@10);
            make.centerX.equalTo(self.mas_left).offset(40 + 10);
            make.width.height.mas_equalTo(80);
            make.bottom.equalTo(@-10);
        }];
        
        [self.contentView addSubview:self.leftLine];
        [self.leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.bottom.equalTo(self.contentView);
            make.left.equalTo(self.leftTitleLable.mas_right);
            make.width.mas_equalTo(1);
        }];
        
        [self.contentView addSubview:self.leftDescLable];
        [self.leftDescLable mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerY.equalTo(self.leftTitleLable.mas_centerY);
            make.left.equalTo(self.leftTitleLable.mas_right).offset(10);
            make.right.equalTo(self.contentView.mas_centerX);
        }];
        
        [self.contentView addSubview:self.midLine];
        [self.midLine mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.bottom.equalTo(self.contentView);
            make.left.equalTo(self.contentView.mas_centerX);
            make.width.mas_equalTo(1);
        }];
        
        
        [self.contentView addSubview:self.rightTitleLable];
        [self.rightTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(@10);
            make.centerX.equalTo(self.mas_centerX).offset(40);
            make.width.height.mas_equalTo(60);
            make.bottom.equalTo(@-10);
        }];
        
        [self.contentView addSubview:self.rightLine];
        [self.rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.bottom.equalTo(self.contentView);
            make.left.equalTo(self.rightTitleLable.mas_right);
            make.width.mas_equalTo(1);
        }];
        
        [self.contentView addSubview:self.rightDescLable];
        [self.rightDescLable mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerY.equalTo(self.rightLine.mas_centerY);
            make.left.equalTo(self.rightTitleLable.mas_right).offset(10);
            make.right.equalTo(self.contentView.mas_right);
        }];
        
        [self.contentView addSubview:self.leftLeftLine];
        [self.leftLeftLine mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.bottom.equalTo(self.contentView);
            make.left.equalTo(self.contentView.mas_left).offset(12);
            make.width.mas_equalTo(1);
        }];
        
        
        [self.contentView addSubview:self.rightRightLine];
        [self.rightRightLine mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.bottom.equalTo(self.contentView);
            make.right.equalTo(self.contentView.mas_right).offset(-12);
            make.width.mas_equalTo(1);
        }];
        
        
        [self setBottomBorderWithColor:UIColorFromHEX(0xcccccc, 1) width:SCREEN_WIDTH-24 height:0.25f];
        [self setTopBorderWithColor:UIColorFromHEX(0xcccccc, 1) width:SCREEN_WIDTH-24 height:0.25f];
        [self setLeftBorderWithColor:UIColorFromHEX(0xcccccc, 1) width:0.25f height:45];
        [self setRightBorderWithColor:UIColorFromHEX(0xcccccc, 1) width:0.25f height:45];
    }
    
    return self;
}

- (UILabel *)leftTitleLable{
    if (!_leftTitleLable) {
        _leftTitleLable = [UILabel labelWithFont:[UIFont systemFontOfSize:16] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter];
        [_leftTitleLable sizeToFit];
    }
    
    return _leftTitleLable;
}


- (UILabel *)leftDescLable{
    if (!_leftDescLable) {
        _leftDescLable = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
        [_leftDescLable sizeToFit];
    }
    
    return _leftDescLable;
}

- (UILabel *)rightDescLable{
    if (!_rightDescLable) {
        _rightDescLable = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
        [_rightDescLable sizeToFit];
    }
    
    return _rightDescLable;
}

- (UILabel *)rightTitleLable{
    if (!_rightTitleLable) {
        _rightTitleLable = [UILabel labelWithFont:[UIFont systemFontOfSize:16] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter];
        [_rightTitleLable sizeToFit];
    }
    
    return _rightTitleLable;
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

- (UIView *)leftLeftLine{
    if (!_leftLeftLine) {
        _leftLeftLine = [[UIView alloc] initWithFrame:CGRectZero];
        _leftLeftLine.backgroundColor = UIColorFromHEX(0xcccccc, 1);
    }
    
    return _leftLeftLine;
}

- (UIView *)rightRightLine{
    if (!_rightRightLine) {
        _rightRightLine = [[UIView alloc] initWithFrame:CGRectZero];
        _rightRightLine.backgroundColor = UIColorFromHEX(0xcccccc, 1);
    }
    
    return _rightRightLine;
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
