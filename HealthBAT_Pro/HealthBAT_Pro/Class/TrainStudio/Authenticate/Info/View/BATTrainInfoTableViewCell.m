//
//  BATTrainInfoTableViewCell.m
//  HealthBAT_Pro
//
//  Created by Skybrim on 2017/3/20.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATTrainInfoTableViewCell.h"

@implementation BATTrainInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        WEAK_SELF(self);
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(@0);
            make.left.equalTo(@10);
        }];
        
        [self.contentView addSubview:self.rightArrow];
        [self.rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(@0);
            make.right.equalTo(@-10);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
        
        [self.contentView addSubview:self.inputTF];
        [self.inputTF mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerY.equalTo(@0);
            make.right.equalTo(self.rightArrow.mas_left).offset(-10);
            make.left.equalTo(self.titleLabel.mas_right).offset(10);
        }];
        
        [self setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0.5];
        
    }
    return self;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if (self.eventBlock) {
        self.eventBlock(self.currentIndex);
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (self.inputBlock) {
        self.inputBlock(textField.text,self.currentIndex);
    }
}

#pragma mark - getter
- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:16] textColor:UIColorFromHEX(0x333333, 1) textAlignment:NSTextAlignmentLeft];
    }
    return _titleLabel;
}

- (UITextField *)inputTF {
    
    if (!_inputTF) {
        _inputTF = [[UITextField alloc] init];
        _inputTF.font = [UIFont systemFontOfSize:14];
        _inputTF.textColor = UIColorFromHEX(0x999999, 1);
        _inputTF.textAlignment = NSTextAlignmentRight;
        _inputTF.delegate = self;
    }
    return _inputTF;
}

- (UIImageView *)rightArrow {
    
    if (!_rightArrow) {
        _rightArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_arrow_right"]];
        [_rightArrow sizeToFit];
    }
    return _rightArrow;
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
