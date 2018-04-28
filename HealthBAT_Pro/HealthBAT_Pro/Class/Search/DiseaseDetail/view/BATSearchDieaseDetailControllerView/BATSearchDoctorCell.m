//
//  BATSearchDoctorCell.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/5/9.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATSearchDoctorCell.h"

@implementation BATSearchDoctorCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        
        WEAK_SELF(self);
        [self.contentView addSubview:self.doctorImageView];
        self.doctorImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(moveToDoctorInfoDetail)];
        [self.doctorImageView addGestureRecognizer:imageTap];
        [self.doctorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.mas_left).offset(10);
            make.centerY.equalTo(self.mas_centerY);
            make.height.mas_equalTo(60);
            make.width.mas_equalTo(60);
        }];
        
        [self.contentView addSubview:self.nameLabel];
        self.nameLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *nameTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(moveToDoctorInfoDetail)];
        [self.nameLabel addGestureRecognizer:nameTap];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.doctorImageView.mas_right).offset(10);
            make.top.equalTo(self.mas_top).offset(20);
            make.right.lessThanOrEqualTo(self.mas_right).offset(-10);
        }];
        
        [self.contentView addSubview:self.tipsLb];
        [self.tipsLb mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self)
            make.left.equalTo(self.nameLabel.mas_right).offset(10);
            make.centerY.equalTo(self.nameLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(28, 15));
        }];
        
        [self.contentView addSubview:self.departmentLabel];
        [self.departmentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.doctorImageView.mas_right).offset(10);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
            make.right.lessThanOrEqualTo(self.mas_right).offset(-10);
        }];
        
        [self.contentView addSubview:self.skilfulLabel];
        [self.skilfulLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.doctorImageView.mas_right).offset(10);
            make.top.equalTo(self.departmentLabel.mas_bottom).offset(10);
            make.right.lessThanOrEqualTo(self.mas_right).offset(-10);
        }];
        
        [self setBottomBorderWithColor:UIColorFromHEX(0xeeeeee, 1) width:SCREEN_WIDTH height:0.5];
    }
    return self;
}

- (void)moveToDoctorInfoDetail {
    
    if ([self.delegate respondsToSelector:@selector(moveToDoctorInfoDetailActionWith:)]) {
        [self.delegate moveToDoctorInfoDetailActionWith:self.indexPath];
    }
    
}

- (UIImageView *)doctorImageView {
    if (!_doctorImageView) {
        _doctorImageView = [UIImageView new];
        _doctorImageView.layer.cornerRadius = 30;
        //        _doctorImageView.layer.cornerRadius = (self.frame.size.height-20)/2.0f;
        _doctorImageView.clipsToBounds = YES;
    }
    return _doctorImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:UIColorFromHEX(0x333333, 1) textAlignment:NSTextAlignmentLeft];
        _nameLabel.numberOfLines = 0;
        _nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _nameLabel;
}

- (UILabel *)departmentLabel {
    if (!_departmentLabel) {
        _departmentLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:13] textColor:UIColorFromHEX(0x666666, 1) textAlignment:NSTextAlignmentLeft];
    }
    return _departmentLabel;
}

- (UILabel *)skilfulLabel {
    if (!_skilfulLabel) {
        _skilfulLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:13] textColor:UIColorFromHEX(0x666666, 1) textAlignment:NSTextAlignmentLeft];
    }
    return _skilfulLabel;
}

-(UILabel *)tipsLb {
    if (!_tipsLb) {
        _tipsLb = [[UILabel alloc]init];
        _tipsLb = [UILabel labelWithFont:[UIFont systemFontOfSize:9] textColor:UIColorFromHEX(0xffffff, 1) textAlignment:NSTextAlignmentCenter];
        _tipsLb.clipsToBounds = YES;
        _tipsLb.layer.cornerRadius = 8;
        _tipsLb.text = @"网络";
        _tipsLb.backgroundColor = UIColorFromHEX(0Xffae00, 1);
    }
    return _tipsLb;
}


@end
