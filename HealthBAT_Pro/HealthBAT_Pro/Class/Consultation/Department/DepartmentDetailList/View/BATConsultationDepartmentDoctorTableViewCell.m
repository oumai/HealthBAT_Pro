//
//  BATConsultationDepartmentDoctorTableViewCell.m
//  HealthBAT_Pro
//
//  Created by Skyrim on 16/9/5.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATConsultationDepartmentDoctorTableViewCell.h"

@implementation BATConsultationDepartmentDoctorTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0.5];
        
        WEAK_SELF(self);
        [self addSubview:self.headerImageView];
        [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(self.mas_left).offset(10);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(60);
        }];

        [self addSubview:self.hospitalLevelImageView];
        [self.hospitalLevelImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.headerImageView.mas_left);
            make.top.equalTo(self.headerImageView.mas_top);
        }];

        [self addSubview:self.onlineStationImageView];
        [self.onlineStationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.right.equalTo(self.headerImageView.mas_right);
            make.bottom.equalTo(self.headerImageView.mas_bottom);
        }];

        [self addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.mas_top).offset(15);
            make.left.equalTo(self.headerImageView.mas_right).offset(8);
        }];

        [self addSubview:self.departmentLabel];
        [self.departmentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
            make.left.equalTo(self.headerImageView.mas_right).offset(8);
        }];

        [self addSubview:self.descriptionLabel];
        [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.departmentLabel.mas_bottom).offset(5);
            make.left.equalTo(self.headerImageView.mas_right).offset(8);
            make.right.equalTo(self.mas_right).offset(-10);
        }];


    }
    return self;
}


#pragma mark - getter
- (UIImageView *)headerImageView {
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc] init];
        _headerImageView.layer.cornerRadius = 30.f;
        _headerImageView.clipsToBounds = YES;
//        _headerImageView.layer.shouldRasterize = YES;
//        _headerImageView.opaque = YES;
        _headerImageView.backgroundColor = [UIColor whiteColor];
    }
    return _headerImageView;
}

- (UIImageView *)hospitalLevelImageView {
    if (!_hospitalLevelImageView) {
        _hospitalLevelImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"三甲"]];
    }
    return _hospitalLevelImageView;
}

- (UIImageView *)onlineStationImageView {
    if (!_onlineStationImageView) {
        _onlineStationImageView = [[UIImageView alloc] init];
    }
    return _onlineStationImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:16] textColor:UIColorFromHEX(0x333333, 1) textAlignment:NSTextAlignmentLeft];
    }
    return _nameLabel;
}

- (UILabel *)departmentLabel {
    if (!_departmentLabel) {
        _departmentLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:13] textColor:UIColorFromHEX(0x666666, 1) textAlignment:NSTextAlignmentLeft];
    }
    return _departmentLabel;
}

- (UILabel *)descriptionLabel {
    if (!_descriptionLabel) {
        _descriptionLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:13] textColor:UIColorFromHEX(0x666666, 1) textAlignment:NSTextAlignmentLeft];
    }
    return _descriptionLabel;

}
#pragma mark -
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
