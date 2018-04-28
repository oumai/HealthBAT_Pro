//
//  BATMyPromoCodeCell.m
//  HealthBAT_Pro
//
//  Created by four on 2017/6/8.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATMyPromoCodeCell.h"

@interface BATMyPromoCodeCell ()
{
    NSInteger _commentFont;
}
@end

@implementation BATMyPromoCodeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        if (iPhone5) {
            _commentFont = 3;
        }else if (iPhone6){
            _commentFont = 2;
        }else{
            _commentFont = 0;
        }
        
        WEAK_SELF(self);
        [self.contentView addSubview:self.bgImageView];
        [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(@10);
            make.right.equalTo(@-10);
            make.bottom.equalTo(@0);
        }];
        
        [self.contentView addSubview:self.allFreeLabel];
        [self.allFreeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(@20);
            make.left.equalTo(self.contentView.mas_left).offset((SCREEN_WIDTH/6.0)+15);
        }];
        
        [self.contentView addSubview:self.promoCodeLabel];
        [self.promoCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.allFreeLabel.mas_bottom).offset(10);
            make.left.equalTo(self.contentView.mas_left).offset((SCREEN_WIDTH/6.0)+15);
        }];
        
        [self.contentView addSubview:self.useRangeLabel];
        [self.useRangeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.promoCodeLabel.mas_bottom).offset(10);
            make.left.equalTo(self.contentView.mas_left).offset((SCREEN_WIDTH/6.0)+15);
        }];
        
        [self.contentView addSubview:self.validTimeLabel];
        [self.validTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.useRangeLabel.mas_bottom).offset(10);
            make.left.equalTo(self.contentView.mas_left).offset((SCREEN_WIDTH/6.0)+15);
        }];
        
    }
    return self;
}


- (void)setCellWithData:(BATPrommoCodeData *)model{

    if (model) {
        
        if(model.IsTerm == 1){
            //已过期
            self.bgImageView.image = [UIImage imageNamed:@"icon-yhq-ygq"];
        }else{
            if (model.IsUser == 0) {
                //未使用
                self.bgImageView.image = [UIImage imageNamed:@"icon-yhq-qsy"];
            }else{
                //已使用
                self.bgImageView.image = [UIImage imageNamed:@"icon-yhq-ysy"];
            }
        }

        self.useRangeLabel.text = [NSString stringWithFormat:@"使用范围：%@",model.Scope];
        self.promoCodeLabel.text = [NSString stringWithFormat:@"优惠码：%@",model.Code];
        self.validTimeLabel.text = [NSString stringWithFormat:@"有效时间：%@",model.TermTime];
    }
}

- (UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-yhq-ysy"]];
        _bgImageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _bgImageView;
}

- (UILabel *)allFreeLabel{
    if (!_allFreeLabel) {
        _allFreeLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:23-_commentFont] textColor:UIColorFromHEX(0xfc834e, 1) textAlignment:NSTextAlignmentRight];
        _allFreeLabel.text = @"全额减免";
        [_allFreeLabel sizeToFit];
    }
    
    return _allFreeLabel;
}

- (UILabel *)promoCodeLabel{
    if (!_promoCodeLabel) {
        _promoCodeLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:15-_commentFont] textColor:UIColorFromHEX(0x333333, 1) textAlignment:NSTextAlignmentRight];
        _promoCodeLabel.text = @"优惠码：000000";
        [_promoCodeLabel sizeToFit];
    }
    
    return _promoCodeLabel;
}

- (UILabel *)useRangeLabel{
    if (!_useRangeLabel) {
        _useRangeLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:15-_commentFont] textColor:UIColorFromHEX(0x333333, 1) textAlignment:NSTextAlignmentRight];
        _useRangeLabel.text = @"使用范围：健康咨询中图文咨询";
        [_useRangeLabel sizeToFit];
    }
    
    return _useRangeLabel;
}


- (UILabel *)validTimeLabel{
    if (!_validTimeLabel) {
        _validTimeLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:15-_commentFont] textColor:UIColorFromHEX(0x333333, 1) textAlignment:NSTextAlignmentRight];
        _validTimeLabel.text = @"有效时间：2017.06.15-2017.07.15";
        [_validTimeLabel sizeToFit];
    }
    
    return _validTimeLabel;
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
