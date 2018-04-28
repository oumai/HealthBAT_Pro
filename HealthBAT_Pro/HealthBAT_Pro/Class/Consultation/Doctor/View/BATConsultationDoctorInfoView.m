//
//  BATConsultationDoctorInfoView.m
//  HealthBAT_Pro
//
//  Created by KM on 16/9/62016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATConsultationDoctorInfoView.h"

@implementation BATConsultationDoctorInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
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
        
        [self addSubview:self.onlineStationImageView];
        [self.onlineStationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.right.equalTo(self.headerImageView.mas_right);
            make.bottom.equalTo(self.headerImageView.mas_bottom);
        }];
        
        
        [self addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.headerImageView.mas_top).offset(3);
            make.left.equalTo(self.headerImageView.mas_right).offset(8);
        }];
        
        [self addSubview:self.hospitalLevelLabel];
        [self.hospitalLevelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.nameLabel.mas_right).offset(10);
            make.centerY.equalTo(self.nameLabel.mas_centerY);
            make.width.mas_equalTo(35);
            make.height.mas_equalTo(15);
        }];
        
        [self addSubview:self.departmentLabel];
        [self.departmentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
            make.left.equalTo(self.headerImageView.mas_right).offset(8);
        }];
        
        [self addSubview:self.hospitalLabel];
        [self.hospitalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.departmentLabel.mas_bottom).offset(5);
            make.left.equalTo(self.headerImageView.mas_right).offset(10);
            make.right.equalTo(self.mas_right).offset(-10).priorityHigh();
        }];
        
        [self addSubview:self.collectionButton];
        [self.collectionButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-10);
            make.top.equalTo(self.nameLabel.mas_top);
            make.width.mas_equalTo(40);
        }];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame docotrDetailModel:(BATConsultationDoctorDetailModel *)KMDoctorDetail or:(BATHospitalRegisterDoctorModel *)HRDoctorDetail {

    self = [super initWithFrame:frame];
    if (self) {

        if (KMDoctorDetail) {
            [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:KMDoctorDetail.Data.User.PhotoUrl] placeholderImage:[UIImage imageNamed:@"医生"]];
//            switch (KMDoctorDetail.Data.OnlineStatus) {
//                case 0:
//                {
//                    //离线
//                    self.onlineStationImageView.image = [UIImage imageNamed:@"离线"];
//                    self.headerImageView.image = [Tools imageByApplyingAlpha:0.5 image:self.headerImageView.image];
//                }
//                    break;
//                case 1:
//                {
//                    //忙碌
//                    self.onlineStationImageView.image = [UIImage imageNamed:@"忙碌"];
//
//                }
//                    break;
//                default:
//                {
//                    //在线
//                    self.onlineStationImageView.image = nil;
//                }
//                    break;
//            }
            self.nameLabel.text = KMDoctorDetail.Data.DoctorName;

            self.hospitalLevelLabel.hidden = YES;

//            if (![KMDoctorDetail.Data.Grade isEqualToString:@"三甲"]) {
//                self.hospitalLevelLabel.hidden = YES;
//            } else {
//                self.hospitalLevelLabel.hidden = NO;
//            }
            if (KMDoctorDetail.Data.Title.length > 0) {
                self.departmentLabel.text = [NSString stringWithFormat:@"%@ | %@",KMDoctorDetail.Data.DepartmentName,KMDoctorDetail.Data.Title];
            }
            else {
                self.departmentLabel.text = KMDoctorDetail.Data.DepartmentName;
            }
            self.hospitalLabel.text = KMDoctorDetail.Data.HospitalName;
//            self.collectionButton.selected = KMDoctorDetail.Data.IsCollectLink;
        }
        else {

            [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:HRDoctorDetail.Data.IMAGE] placeholderImage:[UIImage imageNamed:@"医生"]];
            self.onlineStationImageView.image = nil;
            self.nameLabel.text = HRDoctorDetail.Data.DOCTOR_NAME;
            self.hospitalLabel.hidden = YES;
            if (HRDoctorDetail.Data.TITLENAME.length > 0) {
                self.departmentLabel.text = [NSString stringWithFormat:@"%@ | %@",HRDoctorDetail.Data.DEP_NAME,HRDoctorDetail.Data.TITLENAME];
            }
            else {
                self.departmentLabel.text = HRDoctorDetail.Data.DEP_NAME;
            }
            self.hospitalLabel.text = HRDoctorDetail.Data.UNIT_NAME;
//            self.collectionButton.selected = HRDoctorDetail.Data.IsCollectLink;
        }

        self.backgroundColor = BASE_COLOR;

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

        [self addSubview:self.onlineStationImageView];
                [self.onlineStationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.right.equalTo(self.headerImageView.mas_right);
            make.bottom.equalTo(self.headerImageView.mas_bottom);
        }];


        [self addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.headerImageView.mas_top).offset(3);
            make.left.equalTo(self.headerImageView.mas_right).offset(8);
        }];

        [self addSubview:self.hospitalLevelLabel];
        [self.hospitalLevelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.nameLabel.mas_right).offset(10);
            make.centerY.equalTo(self.nameLabel.mas_centerY);
            make.width.mas_equalTo(35);
            make.height.mas_equalTo(15);
        }];

        [self addSubview:self.departmentLabel];
        [self.departmentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
            make.left.equalTo(self.headerImageView.mas_right).offset(8);
        }];

        [self addSubview:self.hospitalLabel];

        [self.hospitalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.departmentLabel.mas_bottom).offset(5);
            make.left.equalTo(self.headerImageView.mas_right).offset(10);
            make.right.equalTo(self.mas_right).offset(-10);
        }];

        [self addSubview:self.collectionButton];
        [self.collectionButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-10);
            make.top.equalTo(self.nameLabel.mas_top);
            make.width.mas_equalTo(40);
        }];
    }
    return self;
}

- (void)loadConsultationDoctorDetail:(BATConsultationDoctorDetailModel *)KMDoctorDetail
{
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:KMDoctorDetail.Data.User.PhotoUrl] placeholderImage:[UIImage imageNamed:@"医生"]];
    self.nameLabel.text = KMDoctorDetail.Data.DoctorName;
    self.hospitalLevelLabel.hidden = YES;
    if (KMDoctorDetail.Data.Title.length > 0) {
        self.departmentLabel.text = [NSString stringWithFormat:@"%@ | %@",KMDoctorDetail.Data.DepartmentName,KMDoctorDetail.Data.Title];
    }
    else {
        self.departmentLabel.text = KMDoctorDetail.Data.DepartmentName;
    }
    self.hospitalLabel.text = KMDoctorDetail.Data.HospitalName;
}

- (void)loadHospitalRegisterDoctor:(BATHospitalRegisterDoctorModel *)HRDoctorDetail
{
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:HRDoctorDetail.Data.IMAGE] placeholderImage:[UIImage imageNamed:@"医生"]];
    self.onlineStationImageView.image = nil;
    self.nameLabel.text = HRDoctorDetail.Data.DOCTOR_NAME;
    //self.hospitalLabel.hidden = YES;
    if (HRDoctorDetail.Data.TITLENAME.length > 0) {
        self.departmentLabel.text = [NSString stringWithFormat:@"%@ | %@",HRDoctorDetail.Data.DEP_NAME,HRDoctorDetail.Data.TITLENAME];
    }
    else {
        self.departmentLabel.text = HRDoctorDetail.Data.DEP_NAME;
    }
    self.hospitalLabel.text = HRDoctorDetail.Data.UNIT_NAME;
}


- (void)collectionDoctor:(UIButton *)sender {

    if (self.collectionDoctorBlock) {
        self.collectionDoctorBlock();
    }
}


#pragma mark - getter
- (UIImageView *)headerImageView {
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc] init];
        _headerImageView.layer.cornerRadius = 30.f;
        _headerImageView.clipsToBounds = YES;
        _headerImageView.opaque = YES;
//        _headerImageView.backgroundColor = [UIColor whiteColor];
    }
    return _headerImageView;
}

- (UIImageView *)onlineStationImageView {
    if (!_onlineStationImageView) {
        _onlineStationImageView = [[UIImageView alloc] init];
    }
    return _onlineStationImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:16] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    }
    return _nameLabel;
}

- (UILabel *)hospitalLevelLabel {
    if (!_hospitalLevelLabel) {
        _hospitalLevelLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:13] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter];
        _hospitalLevelLabel.text = @"三甲";
        _hospitalLevelLabel.layer.cornerRadius = 5.0f;
        _hospitalLevelLabel.backgroundColor = [UIColor orangeColor];
        _hospitalLevelLabel.hidden = YES;
    }
    return _hospitalLevelLabel;
}

- (UILabel *)departmentLabel {
    if (!_departmentLabel) {
        _departmentLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:12] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    }
    return _departmentLabel;
}

- (UILabel *)hospitalLabel {
    if (!_hospitalLabel) {
        _hospitalLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:12] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
        _hospitalLabel.numberOfLines = 0;
        _hospitalLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _hospitalLabel;
}


- (BATConsultationCollectionButton *)collectionButton
{
    if (!_collectionButton) {
        _collectionButton = [[BATConsultationCollectionButton alloc] initWithFrame:CGRectZero collectionButtonClickBlock:^(UIButton *button) {
            if (self.collectionDoctorBlock) {
                self.collectionDoctorBlock();
            }
        }];
        _collectionButton.hidden = YES;
    }
    return _collectionButton;
}

//- (UIButton *)collectionButton {
//
//    if (!_collectionButton) {
//        _collectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_collectionButton setImage:[UIImage imageNamed:@"iconfont-collection"] forState:UIControlStateNormal];
//        [_collectionButton setImage:[UIImage imageNamed:@"iconfont-collection-s"] forState:UIControlStateSelected];
//        [_collectionButton addTarget:self action:@selector(collectionDoctor:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _collectionButton;
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
