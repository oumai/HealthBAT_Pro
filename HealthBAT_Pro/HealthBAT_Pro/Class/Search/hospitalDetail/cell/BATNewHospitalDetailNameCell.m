//
//  BATNewHospitalDetailNameCell.m
//  HealthBAT_Pro
//
//  Created by four on 2017/5/18.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATNewHospitalDetailNameCell.h"

@implementation BATNewHospitalDetailNameCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        WEAK_SELF(self);
        [self.contentView addSubview:self.imageV];
        [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.top.right.equalTo(self.contentView);
            make.height.mas_equalTo(432/670.0*SCREEN_WIDTH);
        }];
        
        [self.contentView addSubview:self.blackBGView];
        [self.blackBGView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.right.equalTo(self.contentView);
            make.bottom.equalTo(self.imageV.mas_bottom);
            make.height.mas_equalTo(45);
        }];
        
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.mas_left).offset(10);
            make.centerY.equalTo(self.blackBGView.mas_centerY);
        }];
        
        
        [self.contentView addSubview:self.levelLabel];
        [self.levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.nameLabel.mas_right).offset(10);
            make.centerY.equalTo(self.blackBGView.mas_centerY);
        }];
        
        [self.contentView addSubview:self.addressBGView];
        [self.addressBGView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.right.equalTo(self.contentView);
            make.top.equalTo(self.imageV.mas_bottom);
            make.height.mas_equalTo(45);
        }];
        
        [self.contentView addSubview:self.phoneBGView];
        [self.phoneBGView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.right.equalTo(self.contentView);
            make.top.equalTo(self.addressBGView.mas_bottom);
            make.height.mas_equalTo(45);
            make.bottom.equalTo(@0);
        }];
        
        [self.contentView addSubview:self.addressIcon];
        [self.addressIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.centerY.equalTo(self.addressBGView.mas_centerY);
            make.width.mas_equalTo(14);
            make.height.mas_equalTo(19);
        }];
        
        [self.contentView addSubview:self.titleAddressLabel];
        [self.titleAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.contentView.mas_left).offset(40);
            make.centerY.equalTo(self.addressBGView.mas_centerY);
            make.width.mas_equalTo(50);
        }];
        
        [self.contentView addSubview:self.addressLabel];
        [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.titleAddressLabel.mas_right);
            make.centerY.equalTo(self.addressBGView.mas_centerY);
            make.right.equalTo(self.contentView.mas_right).offset(-25);
        }];
        
        [self.contentView addSubview:self.addressRightImageV];
        [self.addressRightImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.centerY.equalTo(self.addressBGView.mas_centerY);
            make.height.mas_equalTo(10);
            make.width.mas_equalTo(7);
        }];
        
        [self.contentView addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.right.equalTo(self.contentView);
            make.top.equalTo(self.addressBGView.mas_bottom);
            make.height.mas_equalTo(0.5);
        }];
        
        [self.contentView addSubview:self.phoneIcon];
        [self.phoneIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.centerY.equalTo(self.phoneBGView.mas_centerY);
            make.width.mas_equalTo(16);
            make.height.mas_equalTo(18);
        }];
        
        [self.contentView addSubview:self.titlePhoneLabel];
        [self.titlePhoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.contentView.mas_left).offset(40);
            make.centerY.equalTo(self.phoneBGView.mas_centerY);
            make.width.mas_equalTo(50);
        }];
        
        [self.contentView addSubview:self.phoneLabel];
        [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.titlePhoneLabel.mas_right);
            make.centerY.equalTo(self.phoneBGView.mas_centerY);
            make.right.equalTo(self.contentView.mas_right).offset(-25);
        }];
        
        [self.contentView addSubview:self.phoneRightImageV];
        [self.phoneRightImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.centerY.equalTo(self.phoneBGView.mas_centerY);
            make.height.mas_equalTo(10);
            make.width.mas_equalTo(7);
        }];
    }
    return self;
}

- (void)setCellWithModel:(HospitalDetailModel *)model{

    if(model){
        
        [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.Data.IMAGE] placeholderImage:[UIImage imageNamed:@"医生"]];
        
        self.nameLabel.text = model.Data.UNIT_NAME;
        
        switch (model.Data.HOSPITAL_LEVEL) {
            case 1:
                self.levelLabel.text = @"特等医院";
                break;
            case 2:
                self.levelLabel.text = @"三级甲等";
                break;
            case 3:
                self.levelLabel.text = @"三级乙等";
                break;
            case 4:
                self.levelLabel.text = @"三级丙等";
                break;
            case 5:
                self.levelLabel.text = @"二级甲等";
                break;
            case 6:
                self.levelLabel.text = @"二级乙等";
                break;
            case 7:
                self.levelLabel.text = @"二级丙等";
                break;
            case 8:
                self.levelLabel.text = @"一级甲等";
                break;
            case 9:
                self.levelLabel.text = @"一级乙等";
                break;
            case 10:
                self.levelLabel.text = @"一级丙等";
                break;
            case 11:
                self.levelLabel.text = @"其他";
                break;
            default:
                break;
        }
        
        self.addressLabel.text = model.Data.ADDRESS;
        self.phoneLabel.text = model.Data.PHONE;
    }
}

- (UIImageView *)imageV{
    if (!_imageV) {
        _imageV = [[UIImageView alloc]init];
    }
    return _imageV;
}


-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.textColor = UIColorFromHEX(0xffffff, 1);
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.numberOfLines = 0;
        [_nameLabel sizeToFit];
    }
    return _nameLabel;
}

-(UILabel *)levelLabel{
    if (!_levelLabel) {
        _levelLabel = [[UILabel alloc]init];
        _levelLabel.textAlignment = NSTextAlignmentLeft;
        _levelLabel.textColor = UIColorFromHEX(0xffffff, 1);
        _levelLabel.font = [UIFont systemFontOfSize:15];
        _levelLabel.numberOfLines = 0;
        [_levelLabel sizeToFit];
    }
    return _levelLabel;
}

- (UIView *)blackBGView{
    if (!_blackBGView) {
        _blackBGView = [[UIView alloc]init];
        _blackBGView.backgroundColor = UIColorFromHEX(0x000000, 0.3);
    }
    return _blackBGView;
}

- (UIView *)addressBGView{
    if (!_addressBGView) {
        _addressBGView = [[UIView alloc]init];
        _addressBGView.userInteractionEnabled = YES;
        [_addressBGView bk_whenTapped:^{
            if (self.ClickAddressBlock) {
                self.ClickAddressBlock();
            }
        }];
    }
    return _addressBGView;
}

- (UIView *)phoneBGView{
    if (!_phoneBGView) {
        _phoneBGView = [[UIView alloc]init];
        _phoneBGView.userInteractionEnabled = YES;
        [_phoneBGView bk_whenTapped:^{
            if (self.ClickPhoneBlock) {
                self.ClickPhoneBlock();
            }
        }];
    }
    return _phoneBGView;
}

- (UIImageView *)addressIcon{
    if (!_addressIcon) {
        _addressIcon = [[UIImageView alloc]init];
        _addressIcon.image = [UIImage imageNamed:@"ic-dizhi"];
    }
    return _addressIcon;
}

- (UIImageView *)phoneIcon{
    if (!_phoneIcon) {
        _phoneIcon = [[UIImageView alloc]init];
        _phoneIcon.image = [UIImage imageNamed:@"ic-dh"];
    }
    return _phoneIcon;
}

- (UILabel *)addressLabel{
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc]init];
        _addressLabel.textAlignment = NSTextAlignmentLeft;
        _addressLabel.textColor = UIColorFromHEX(0x333333, 1);
        _addressLabel.font = [UIFont systemFontOfSize:15];
        _addressLabel.numberOfLines = 0;
        [_addressLabel sizeToFit];
    }
    return _addressLabel;
}

- (UILabel *)titleAddressLabel{
    if (!_titleAddressLabel) {
        _titleAddressLabel = [[UILabel alloc]init];
        _titleAddressLabel.textAlignment = NSTextAlignmentLeft;
        _titleAddressLabel.textColor = UIColorFromHEX(0x333333, 1);
        _titleAddressLabel.font = [UIFont systemFontOfSize:15];
        _titleAddressLabel.text = @"地址：";
        [_titleAddressLabel sizeToFit];
    }
    return _titleAddressLabel;
}

- (UILabel *)titlePhoneLabel{
    if (!_titlePhoneLabel) {
        _titlePhoneLabel = [[UILabel alloc]init];
        _titlePhoneLabel.textAlignment = NSTextAlignmentLeft;
        _titlePhoneLabel.textColor = UIColorFromHEX(0x333333, 1);
        _titlePhoneLabel.font = [UIFont systemFontOfSize:15];
        _titlePhoneLabel.text = @"电话：";
        [_titlePhoneLabel sizeToFit];
    }
    return _titlePhoneLabel;
}

- (UILabel *)phoneLabel{
    if (!_phoneLabel) {
        _phoneLabel = [[UILabel alloc]init];
        _phoneLabel.textAlignment = NSTextAlignmentLeft;
        _phoneLabel.textColor = UIColorFromHEX(0x333333, 1);
        _phoneLabel.font = [UIFont systemFontOfSize:15];
        _phoneLabel.numberOfLines = 0;
        [_phoneLabel sizeToFit];
    }
    return _phoneLabel;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = BASE_LINECOLOR;
    }
    return _lineView;
}

- (UIImageView *)addressRightImageV{
    if (!_addressRightImageV) {
        _addressRightImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_arrow_right"]];
    }
    return _addressRightImageV;
}

- (UIImageView *)phoneRightImageV{
    if (!_phoneRightImageV) {
        _phoneRightImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_arrow_right"]];
    }
    return _phoneRightImageV;
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
