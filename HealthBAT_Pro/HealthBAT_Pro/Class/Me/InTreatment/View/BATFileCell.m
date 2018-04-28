//
//  BATFileCell.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2016/12/6.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATFileCell.h"
@interface BATFileCell ()
@property (nonatomic,strong) UILabel *defaultLb;
@property (nonatomic,strong) UISwitch *defaultSwitch;
@property (nonatomic,strong) UILabel *relateShipLb;
@property (nonatomic,strong) UIImageView *editImg;
@property (nonatomic,strong) UIImageView *icon;
@property (nonatomic,strong) UILabel *nameLb;
@property (nonatomic,strong) UILabel *unknowSetLb;
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UIButton *clearBtn;
@end
@implementation BATFileCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = BASE_BACKGROUND_COLOR;
        
        WEAK_SELF(self)
        
        [self.contentView addSubview:self.backView];
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self)
            make.top.equalTo(self.contentView).offset(0);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
            make.left.right.equalTo(self.contentView).offset(0);
        }];
        
        [self.backView addSubview:self.defaultSwitch];
        [self.defaultSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self)
            make.left.equalTo(self.backView).offset(14);
            make.top.equalTo(self.backView).offset(14);
        }];
        
        
        
        [self.backView addSubview:self.editImg];
        [self.editImg mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self)
            make.right.equalTo(self.backView.mas_right).offset(-14);
            make.centerY.equalTo(self.defaultSwitch.mas_centerY);
        }];
        
        [self.backView addSubview:self.relateShipLb];
        [self.relateShipLb mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self)
            make.right.equalTo(self.editImg.mas_left).offset(-10);
            make.centerY.equalTo(self.defaultSwitch.mas_centerY);
        }];
        
        
        [self.backView addSubview:self.defaultLb];
        [self.defaultLb mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self)
            make.left.equalTo(self.defaultSwitch.mas_right).offset(10);
            make.centerY.equalTo(self.defaultSwitch.mas_centerY);
        }];
        
        [self.backView addSubview:self.icon];
        [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self)
            make.centerY.centerX.equalTo(self.backView);
            make.height.width.mas_equalTo(48);
        }];
        
        [self.backView addSubview:self.nameLb];
        [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self)
            make.centerX.equalTo(self.icon.mas_centerX);
            make.top.equalTo(self.icon.mas_bottom).offset(10);
        }];
        
        [self.backView addSubview:self.unknowSetLb];
        [self.unknowSetLb mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self)
            make.left.right.equalTo(self.backView).offset(0);
            make.bottom.equalTo(self.backView.mas_bottom).offset(-10);
        }];
        
        [self.backView addSubview:self.clearBtn];
        [self.clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           STRONG_SELF(self)
            make.top.right.equalTo(self.backView).offset(0);
            make.height.width.mas_equalTo(80);
        }];
    }
    return self;
}

-(void)setModel:(ChooseTreatmentModel *)model {
    _model = model;
    
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.photoPath] placeholderImage:[UIImage imageNamed:@"医生"]];
    
    NSString *age = nil;
    NSString *height = nil;
    NSString *weight = nil;
    if ([model.ages isEqualToString:@"0"]) {
        age = @"年龄未设置";
    }else {
        age = [NSString stringWithFormat:@"%@岁",model.ages];
    }
    
    if ([model.height isEqualToString:@"0"]) {
        height = @"身高未设置";
    }else {
        height = [NSString stringWithFormat:@"%@cm",model.height];
    }
    
    if ([model.weight isEqualToString:@"0"]) {
        weight = @"体重未设置";
    }else {
        weight = [NSString stringWithFormat:@"%@kg",model.weight];
    }
    
    self.unknowSetLb.text = [NSString stringWithFormat:@"%@.%@.%@",age,height,weight];
    
    self.nameLb.text = model.name;
    
//    NSInteger relate = [model.relateship integerValue];
//    switch (relate) {
//        case 0:
//            self.relateShipLb.text = @"本人";
//            break;
//        case 1:
//            self.relateShipLb.text = @"配偶";
//            break;
//        case 2:
//            self.relateShipLb.text = @"父亲";
//            break;
//        case 3:
//            self.relateShipLb.text = @"母亲";
//            break;
//        case 4:
//            self.relateShipLb.text = @"儿子";
//            break;
//        case 5:
//            self.relateShipLb.text = @"女儿";
//            break;
//        case 6:
//            self.relateShipLb.text = @"其他";
//            break;
//    }
    self.relateShipLb.text = model.relateship;
    
    if (model.isDefault) {
        [self.defaultSwitch setOn:YES];
    }else {
        [self.defaultSwitch setOn:NO];
    }
    
}

#pragma mark - Action
-(void)changeState {
    if ([self.delegate respondsToSelector:@selector(BATFileCellSetDefault:IndexPath:)]) {
        [self.delegate BATFileCellSetDefault:self IndexPath:self.path];
    }
}

-(void)editActions {
    if ([self.delegate respondsToSelector:@selector(BATFileCellEdit:IndexPath:)]) {
        [self.delegate BATFileCellEdit:self IndexPath:self.path];
    }
}

#pragma mark - GETTER

-(UIButton *)clearBtn {
    if (!_clearBtn) {
        _clearBtn = [[UIButton alloc]init];
        [_clearBtn addTarget:self action:@selector(editActions) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clearBtn;
}

-(UILabel *)defaultLb {
    if (!_defaultLb) {
        _defaultLb = [[UILabel alloc]init];
        _defaultLb.text = @"默认成员";
        _defaultLb.font = [UIFont systemFontOfSize:13];
        _defaultLb.textColor = UIColorFromHEX(0X666666, 1);
    }
    return _defaultLb;
}

-(UISwitch *)defaultSwitch {
    if (!_defaultSwitch) {
        _defaultSwitch = [[UISwitch alloc]init];
        [_defaultSwitch addTarget:self action:@selector(changeState) forControlEvents:UIControlEventValueChanged];
        _defaultSwitch.tintColor = UIColorFromHEX(0Xe6e6e6, 1);
        _defaultSwitch.onTintColor = UIColorFromRGB(119, 215, 113, 1);
    }
    return _defaultSwitch;
}

-(UILabel *)relateShipLb {
    if (!_relateShipLb) {
        _relateShipLb = [[UILabel alloc]init];
        _relateShipLb.font = [UIFont systemFontOfSize:14];
        _relateShipLb.textColor = UIColorFromHEX(0X666666, 1);
    }
    return _relateShipLb;
}

-(UIImageView *)editImg {
    if (!_editImg) {
        _editImg = [[UIImageView alloc]init];
        _editImg.image = [UIImage imageNamed:@"icon-bx"];
        //_editImg.userInteractionEnabled = YES;
       // UITapGestureRecognizer *editTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(editActions)];
      //  [_editImg addGestureRecognizer:editTap];
    }
    return _editImg;
}

-(UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc]init];
        _icon.clipsToBounds = YES;
        _icon.layer.cornerRadius = 24;
    }
    return _icon;
}

-(UILabel *)nameLb {
    if (!_nameLb) {
        _nameLb = [[UILabel alloc]init];
        _nameLb.textColor = UIColorFromHEX(0X666666, 1);
        _nameLb.font = [UIFont systemFontOfSize:14];
    }
    return _nameLb;
}

-(UILabel *)unknowSetLb {
    if (!_unknowSetLb) {
        _unknowSetLb = [[UILabel alloc]init];
        _unknowSetLb.textAlignment = NSTextAlignmentCenter;
        _unknowSetLb.font = [UIFont systemFontOfSize:13];
        _unknowSetLb.textColor = UIColorFromHEX(0X666666, 1);
    }
    return _unknowSetLb;
}

-(UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.backgroundColor = [UIColor whiteColor];
    }
    return _backView;
}

@end
