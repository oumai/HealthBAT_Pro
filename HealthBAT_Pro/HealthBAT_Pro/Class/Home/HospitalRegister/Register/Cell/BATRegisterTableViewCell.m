//
//  RegisterTableViewCell.m
//  HealthBAT_Pro
//
//  Created by KM on 16/7/262016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATRegisterTableViewCell.h"

@implementation BATRegisterTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.selectionStyle = UITableViewCellSelectionStyleNone;

        WEAK_SELF(self);
        [self.contentView addSubview:self.eventLabel];
        [self.eventLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.mas_left).offset(13);
            make.centerY.equalTo(self.mas_centerY);
        }];

        [self.contentView addSubview:self.infoLabel];
        [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
//            make.right.equalTo(self.mas_right).offset(-2);
            make.left.equalTo(self.eventLabel.mas_right).offset(80);
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        [self.contentView addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self)
            make.left.right.bottom.equalTo(self.contentView).offset(0);
            make.height.mas_equalTo(1);
        }];

        /*
        [self.contentView addSubview:self.inputTF];
        [self.inputTF mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.right.equalTo(self.mas_right).offset(-10);
            make.centerY.equalTo(self.mas_centerY);
            make.width.mas_equalTo(200);
        }];
        [self.inputTF setHidden:YES];
         */
    }
    return self;
}

#pragma mark - setter
/*
- (UITextField *)inputTF {
    if (!_inputTF) {
        _inputTF = [UITextField textFieldWithfont:[UIFont systemFontOfSize:14] textColor:[UIColor blackColor] placeholder:@"" BorderStyle:UITextBorderStyleRoundedRect];
    }
    return _inputTF;
}
 */

- (UILabel *)eventLabel {
    if (!_eventLabel) {
        _eventLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:UIColorFromHEX(0X333333, 1) textAlignment:NSTextAlignmentLeft];
    }
    return _eventLabel;
}

- (UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:UIColorFromHEX(0X999999, 1) textAlignment:NSTextAlignmentLeft];
        _infoLabel.numberOfLines = 0;
        _infoLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _infoLabel;
}

-(UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = BASE_LINECOLOR;
    }
    return _lineView;
}


#pragma mark - 

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
