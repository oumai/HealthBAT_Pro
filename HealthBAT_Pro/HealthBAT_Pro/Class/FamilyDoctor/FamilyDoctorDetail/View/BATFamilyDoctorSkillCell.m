//
//  BATFamilyDoctorSkillCell.m
//  HealthBAT_Pro
//
//  Created by four on 17/3/15.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATFamilyDoctorSkillCell.h"

@implementation BATFamilyDoctorSkillCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        WEAK_SELF(self);
//        [self.contentView addSubview:self.bgView];
//        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//            STRONG_SELF(self);
//            make.left.right.top.equalTo(self.contentView);
//            make.height.mas_equalTo(40);
//        }];
        
        [self.contentView addSubview:self.titleLable];
        [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.contentView.mas_top).offset(10);
            make.left.equalTo(self.mas_left).offset(10);
        }];
        
        [self.contentView addSubview:self.subTitleLable];
        [self.subTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.bottom.equalTo(self.titleLable.mas_bottom);
            make.left.equalTo(self.titleLable.mas_right).offset(10);
        }];
        
        [self.contentView addSubview:self.descLable];
        [self.descLable mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.titleLable.mas_bottom).offset(15);
            make.left.equalTo(self.mas_left).offset(10);
            make.right.equalTo(self.mas_right).offset(-10);
            make.bottom.equalTo(@-10);
        }];
    }
    
    return self;
}

//- (UIView *)bgView{
//    if (!_bgView) {
//        _bgView = [[UIView alloc]initWithFrame:CGRectZero];
//        _bgView.backgroundColor = [UIColor whiteColor];
//    }
//    return _bgView;
//}

- (UILabel *)titleLable{
    if (!_titleLable) {
        _titleLable = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:UIColorFromHEX(0x333333, 1) textAlignment:NSTextAlignmentLeft];
        _titleLable.numberOfLines = 0;
        [_titleLable sizeToFit];
    }
    
    return _titleLable;
}


- (UILabel *)subTitleLable{
    if (!_subTitleLable) {
        _subTitleLable = [UILabel labelWithFont:[UIFont systemFontOfSize:13] textColor:UIColorFromHEX(0x999999, 1) textAlignment:NSTextAlignmentLeft];
        _subTitleLable.numberOfLines = 0;
        _subTitleLable.hidden = YES;
        [_subTitleLable sizeToFit];
    }
    
    return _subTitleLable;
}



- (UILabel *)descLable{
    if (!_descLable) {
        _descLable = [UILabel labelWithFont:[UIFont systemFontOfSize:14] textColor:UIColorFromHEX(0x333333, 1) textAlignment:NSTextAlignmentLeft];
        _descLable.numberOfLines = 0;
        [_descLable sizeToFit];
    }
    
    return _descLable;
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
