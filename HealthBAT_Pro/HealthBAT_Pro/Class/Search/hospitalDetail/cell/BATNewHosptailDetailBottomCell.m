//
//  BATNewHosptailDetailBottomCell.m
//  HealthBAT_Pro
//
//  Created by four on 2017/5/18.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATNewHosptailDetailBottomCell.h"

@implementation BATNewHosptailDetailBottomCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        WEAK_SELF(self);
        [self.contentView addSubview:self.doctorIcon];
        [self.doctorIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@12.5);
            make.bottom.equalTo(@-12.5);
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.height.width.mas_equalTo(50);
        }];
        
        [self.contentView addSubview:self.docrotTitleLabel];
        [self.docrotTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.bottom.equalTo(self.contentView.mas_centerY).offset(-5);
            make.left.equalTo(self.doctorIcon.mas_right).offset(10);
            make.right.equalTo(self.contentView.mas_centerX).offset(-10);
        }];
        
        [self.contentView addSubview:self.docrotDescLabel];
        [self.docrotDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.contentView.mas_centerY).offset(5);
            make.left.equalTo(self.doctorIcon.mas_right).offset(10);
            make.right.equalTo(self.contentView.mas_centerX).offset(-10);
        }];
        
        [self.contentView addSubview:self.hospitalIcon];
        [self.hospitalIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@12.5);
            make.bottom.equalTo(@-12.5);
            make.height.width.mas_equalTo(50);
            make.left.equalTo(self.contentView.mas_centerX).offset(10);
        }];
        
        [self.contentView addSubview:self.hospitalTitleLabel];
        [self.hospitalTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.bottom.equalTo(self.contentView.mas_centerY).offset(-5);
            make.left.equalTo(self.hospitalIcon.mas_right).offset(10);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
        }];
        
        [self.contentView addSubview:self.hospitalDescLabel];
        [self.hospitalDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.contentView.mas_centerY).offset(5);
            make.left.equalTo(self.hospitalIcon.mas_right).offset(10);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
        }];
        
        
        [self.contentView addSubview:self.deptDoctorView];
        [self.deptDoctorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.bottom.equalTo(@0);
            make.left.equalTo(self.contentView.mas_left);
            make.width.mas_equalTo(SCREEN_WIDTH/2.0);
        }];
        
        [self.contentView addSubview:self.hospitalDetailView];
        [self.hospitalDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.bottom.equalTo(@0);
            make.left.equalTo(self.contentView.mas_centerX);
            make.width.mas_equalTo(SCREEN_WIDTH/2.0);
        }];
        
    }
    return self;
}

- (UIImageView *)doctorIcon{
    if (!_doctorIcon) {
        _doctorIcon = [[UIImageView alloc]init];
        _doctorIcon.image = [UIImage imageNamed:@"ic-ksys"];
        _doctorIcon.clipsToBounds = YES;
        _doctorIcon.layer.cornerRadius = 25;
    }
    return _doctorIcon;
}


-(UILabel *)docrotTitleLabel{
    if (!_docrotTitleLabel) {
        _docrotTitleLabel = [[UILabel alloc]init];
        _docrotTitleLabel.textAlignment = NSTextAlignmentLeft;
        _docrotTitleLabel.textColor = UIColorFromHEX(0x333333, 1);
        _docrotTitleLabel.font = [UIFont systemFontOfSize:15];
        _docrotTitleLabel.text = @"科室医生";
        [_docrotTitleLabel sizeToFit];
    }
    return _docrotTitleLabel;
}

-(UILabel *)docrotDescLabel{
    if (!_docrotDescLabel) {
        _docrotDescLabel = [[UILabel alloc]init];
        _docrotDescLabel.textAlignment = NSTextAlignmentLeft;
        _docrotDescLabel.textColor = UIColorFromHEX(0x666666, 1);
        _docrotDescLabel.font = [UIFont systemFontOfSize:15];
        _docrotDescLabel.text = @"按科室一键挂号";
        _docrotDescLabel.numberOfLines = 0;
        [_docrotDescLabel sizeToFit];
    }
    return _docrotDescLabel;
}

- (UIImageView *)hospitalIcon{
    if (!_hospitalIcon) {
        _hospitalIcon = [[UIImageView alloc]init];
        _hospitalIcon.image = [UIImage imageNamed:@"ic-yygk"];
        _hospitalIcon.clipsToBounds = YES;
        _hospitalIcon.layer.cornerRadius = 25;
    }
    return _hospitalIcon;
}


-(UILabel *)hospitalTitleLabel{
    if (!_hospitalTitleLabel) {
        _hospitalTitleLabel = [[UILabel alloc]init];
        _hospitalTitleLabel.textAlignment = NSTextAlignmentLeft;
        _hospitalTitleLabel.textColor = UIColorFromHEX(0x333333, 1);
        _hospitalTitleLabel.font = [UIFont systemFontOfSize:15];
        _hospitalTitleLabel.text = @"医院概况";
        [_hospitalTitleLabel sizeToFit];
    }
    return _hospitalTitleLabel;
}

-(UILabel *)hospitalDescLabel{
    if (!_hospitalDescLabel) {
        _hospitalDescLabel = [[UILabel alloc]init];
        _hospitalDescLabel.textAlignment = NSTextAlignmentLeft;
        _hospitalDescLabel.textColor = UIColorFromHEX(0x666666, 1);
        _hospitalDescLabel.font = [UIFont systemFontOfSize:15];
        _hospitalDescLabel.text = @"查看医院简介";
        _hospitalDescLabel.numberOfLines = 0;
        [_hospitalDescLabel sizeToFit];
    }
    return _hospitalDescLabel;
}

- (UIView *)deptDoctorView{
    
    if (!_deptDoctorView) {
        _deptDoctorView = [[UIView alloc]init];
        _deptDoctorView.userInteractionEnabled = YES;
        [_deptDoctorView bk_whenTapped:^{
            if (self.clickDeptDoctorBlock) {
                self.clickDeptDoctorBlock();
            }
        }];
    }
    return _deptDoctorView;
}

- (UIView *)hospitalDetailView{
    
    if (!_hospitalDetailView) {
        _hospitalDetailView = [[UIView alloc]init];
        _hospitalDetailView.userInteractionEnabled = YES;
        [_hospitalDetailView bk_whenTapped:^{
            if (self.clickHospitalDetailBlock) {
                self.clickHospitalDetailBlock();
            }
        }];
    }
    return _hospitalDetailView;
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
