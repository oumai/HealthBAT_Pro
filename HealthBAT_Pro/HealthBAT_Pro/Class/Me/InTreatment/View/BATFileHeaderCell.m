//
//  BATFileHeaderCell.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2016/12/6.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATFileHeaderCell.h"
@interface BATFileHeaderCell()
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UIImageView *arrowImg;
@end
@implementation BATFileHeaderCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        WEAK_SELF(self)
        
        [self.contentView addSubview:self.titleLb];
        [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self)
            make.left.equalTo(self.contentView).offset(14);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        
        [self.contentView addSubview:self.arrowImg];
        [self.arrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self)
            make.right.equalTo(self.contentView.mas_right).offset(-14);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        
        [self.contentView addSubview:self.iconImg];
        [self.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self)
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.equalTo(self.arrowImg.mas_left).offset(-10);
            make.height.width.mas_equalTo(43);
        }];
        
        [self.contentView addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.contentView).offset(0);
            make.height.mas_equalTo(1);
        }];
    }
    return self;
}

#pragma mark -SETTER
-(UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [[UILabel alloc]init];
        _titleLb.textColor = UIColorFromHEX(0X333333, 1);
        _titleLb.font = [UIFont systemFontOfSize:14];
    }
    return _titleLb;
}

-(UIImageView *)iconImg {
    if (!_iconImg) {
        _iconImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"personalCenter_defaultAvator"]];
        _iconImg.clipsToBounds = YES;
        _iconImg.layer.cornerRadius = 21;
    }
    return _iconImg;
}

-(UIImageView *)arrowImg {
    if (!_arrowImg) {
        _arrowImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_arrow_right"]];
    }
    return _arrowImg;
}

-(UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = BASE_BACKGROUND_COLOR;
    }
    return _lineView;
}

@end
