//
//  BATAlbumDetailTestingTipsCell.m
//  HealthBAT_Pro
//
//  Created by four on 2017/6/13.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATAlbumDetailTestingTipsCell.h"

@interface BATAlbumDetailTestingTipsCell()

@property (nonatomic,strong) UIView *lineView;

@end

@implementation BATAlbumDetailTestingTipsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        WEAK_SELF(self);
        
        [self.contentView addSubview:self.titleLb];
        [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.contentView).offset(10);
            make.left.equalTo(self.contentView).offset(15);
        }];
        
        [self.contentView addSubview:self.tipsImage];
        [self.tipsImage mas_makeConstraints:^(MASConstraintMaker *make) {
            
            STRONG_SELF(self);
            make.left.equalTo(self.contentView.mas_left).offset(15);
            make.top.equalTo(self.titleLb.mas_bottom).offset(10);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-15);
            
        }];
        
        [self.contentView addSubview:self.contentLb];
        [self.contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
            
            STRONG_SELF(self);
            make.left.equalTo(self.tipsImage.mas_right).offset(10);
            make.right.lessThanOrEqualTo(self.contentView.mas_right).offset(-10);
            make.centerY.equalTo(self.tipsImage.mas_centerY);
            
        }];
        
        [self.contentView addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            STRONG_SELF(self);
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(0);
            make.height.mas_equalTo(1);
            
        }];
        
        
    }
    return self;
}

- (UILabel *)titleLb {
    
    if (!_titleLb) {
        _titleLb = [[UILabel alloc]init];
        _titleLb.font = [UIFont systemFontOfSize:16];
        _titleLb.text = @"健康测试";
        _titleLb.textColor = UIColorFromHEX(0X333333, 1);
    }
    return _titleLb;
}

- (UILabel *)contentLb {
    
    if (!_contentLb) {
        _contentLb = [[UILabel alloc]init];
        _contentLb.font = [UIFont systemFontOfSize:15];
        _contentLb.textColor = UIColorFromHEX(0X999999, 1);
        _contentLb.text = @"测一测";
    }
    return _contentLb;
}

- (UIImageView *)tipsImage {
    
    if (!_tipsImage) {
        _tipsImage = [[UIImageView alloc]init];
        _tipsImage.image = [UIImage imageNamed:@"Follow_HealthTest"];
    }
    return _tipsImage;
}

- (UIView *)lineView {
    
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = BASE_BACKGROUND_COLOR;
    }
    return _lineView;
}



@end
