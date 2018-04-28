//
//  BATDieaseInfoCell.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2016/11/24.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATDieaseInfoCell.h"

@interface BATDieaseInfoCell ()
@property (nonatomic,strong) UIView *lineView;
@end
@implementation BATDieaseInfoCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        WEAK_SELF(self)
        
        [self.contentView addSubview:self.icon];
        [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
           STRONG_SELF(self)
            make.left.equalTo(self.contentView.mas_left).offset(15);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        
        
        [self.contentView addSubview:self.title];
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
           STRONG_SELF(self)
            make.left.equalTo(self.icon.mas_right).offset(15);
            make.right.lessThanOrEqualTo(self.contentView.mas_right).offset(-10);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        
        [self.contentView addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
           STRONG_SELF(self)
            make.left.bottom.right.equalTo(self.contentView).offset(0);
            make.height.mas_equalTo(1);
        }];
    }
    return self;
}

-(UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc]init];
        _title.textAlignment = NSTextAlignmentLeft;
        _title.font = [UIFont systemFontOfSize:14];
        _title.textColor = UIColorFromHEX(0X666666, 1);
    }
    return _title;
}

-(UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc]init];
        _icon.image = [UIImage imageNamed:@"icon-jb"];
    }
    return _icon;
}

-(UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = BASE_BACKGROUND_COLOR;
    }
    return _lineView;
}

@end
