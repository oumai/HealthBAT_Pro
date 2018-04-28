//
//  BATConfirmPayCouponCodeTableViewCell.m
//  HealthBAT_Pro
//
//  Created by KM on 17/5/22017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATConfirmPayCouponCodeTableViewCell.h"

@implementation BATConfirmPayCouponCodeTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.confirmBtn];
        [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-10);
            make.centerY.equalTo(@0);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(30);
        }];
        
        [self.contentView addSubview:self.inputTF];
        [self.inputTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.right.equalTo(@-80);
            make.centerY.equalTo(@0);
        }];
    }
    return self;
}

- (UITextField *)inputTF {
    
    if (!_inputTF) {
        _inputTF = [[UITextField alloc] init];
        [_inputTF setBorderStyle:UITextBorderStyleRoundedRect];
        [_inputTF setTextColor:STRING_DARK_COLOR];
        [_inputTF setFont:[UIFont systemFontOfSize:14]];
        [_inputTF setPlaceholder:@"请输入优惠码"];
    }
    return _inputTF;
}

- (UIButton *)confirmBtn {
    
    if (!_confirmBtn) {
        
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom Title:@"确定" titleColor:[UIColor whiteColor] backgroundColor:BASE_COLOR backgroundImage:nil Font:[UIFont systemFontOfSize:14]];
        _confirmBtn.layer.cornerRadius = 5.0f;
        WEAK_SELF(self);
        [_confirmBtn bk_whenTapped:^{
            STRONG_SELF(self);
            if (self.confirmCouponCodeBlock) {
                self.confirmCouponCodeBlock(self.inputTF.text);
            }
        }];
    }
    return _confirmBtn;
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
