//
//  BATConsultationDoctorCollectionViewCell.m
//  HealthBAT_Pro
//
//  Created by KM on 16/8/252016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATConsultationDoctorCollectionViewCell.h"
#import "BATConsultationDoctorInfoCollectionViewCell.h"

static  NSString * const DOCTOR_CELL = @"DoctorCell";

@implementation BATConsultationDoctorCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        WEAK_SELF(self);
        [self.contentView addSubview:self.headerView];
        [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.top.right.equalTo(self);
            make.height.mas_equalTo(40);
        }];

        [self.contentView addSubview:self.footerView];
        [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self);
            make.height.mas_equalTo(10);
        }];

        [self.contentView addSubview:self.doctorCollectionView];
        [self.doctorCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.right.equalTo(self);
            make.top.equalTo(self.headerView.mas_bottom);
            make.bottom.equalTo(self.footerView.mas_top);
        }];

        [self.headerView addSubview:self.departNameLabel];
        [self.departNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.headerView.mas_left).offset(10);
            make.top.equalTo(self.headerView.mas_top);
            make.bottom.equalTo(self.headerView.mas_bottom);
        }];

        [self.headerView addSubview:self.moreButton];
        [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.right.equalTo(self.headerView.mas_right).offset(-5);
            make.top.equalTo(self.headerView.mas_top);
            make.bottom.equalTo(self.headerView.mas_bottom);
        }];
    }
    return self;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BATConsultationDoctorInfoCollectionViewCell *doctorCell = [collectionView dequeueReusableCellWithReuseIdentifier:DOCTOR_CELL forIndexPath:indexPath];

    return doctorCell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    BATConsultationDoctorInfoCollectionViewCell *doctorCell = (BATConsultationDoctorInfoCollectionViewCell *)cell;
    
    id object = self.dataArray[indexPath.row];
    
    if ([object isKindOfClass:[ConsultationDoctors class]]) {
        
        ConsultationDoctors *doctor = object;
        
        [doctorCell.headerImageView sd_setImageWithURL:[NSURL URLWithString:doctor.User.PhotoUrl] placeholderImage:[UIImage imageNamed:@"医生"]];
        
        doctorCell.nameLabel.text = doctor.DoctorName;
        doctorCell.levelLabel.text = doctor.Title;
        doctorCell.departmentLabel.text = doctor.DepartmentName;

        doctorCell.hospitalLevelImageView.hidden = YES;

//        if (![doctor.Grade isEqualToString:@"三甲"]) {
//            
//            doctorCell.hospitalLevelImageView.hidden = YES;
//        }
//        else {
//            
//            doctorCell.hospitalLevelImageView.hidden = NO;
//        }
//
//        switch (doctor.OnlineStatus) {
//            case 0:
//            {
//                //离线
//                doctorCell.onlineStationImageView.image = [UIImage imageNamed:@"离线"];
//                doctorCell.headerImageView.alpha = 0.5;
//            }
//                break;
//            case 1:
//            {
//                //忙碌
//                doctorCell.onlineStationImageView.image = [UIImage imageNamed:@"忙碌"];
//                doctorCell.headerImageView.alpha = 1;
//                
//            }
//                break;
//            default:
//            {
//                //在线
//                doctorCell.onlineStationImageView.image = nil;
//                doctorCell.headerImageView.alpha = 1;
//            }
//                break;
//        }
        
//        [doctorCell.headerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,doctor.PhotoPath]] placeholderImage:[UIImage imageNamed:@"医生"]];
//        
//        doctorCell.nameLabel.text = doctor.UserName;
//        doctorCell.levelLabel.text = doctor.jobTileName;
//        doctorCell.departmentLabel.text = doctor.DepartmentName;
//        if (![doctor.HospitalGrade isEqualToString:@"三级甲等"]) {
//            
//            doctorCell.hospitalLevelImageView.hidden = YES;
//        }
//        else {
//            
//            doctorCell.hospitalLevelImageView.hidden = NO;
//        }
//        
//        switch (doctor.OnlineStatus) {
//            case 0:
//            {
//                //离线
//                doctorCell.onlineStationImageView.image = [UIImage imageNamed:@"离线"];
//                doctorCell.headerImageView.alpha = 0.5;
//            }
//                break;
//            case 1:
//            {
//                //忙碌
//                doctorCell.onlineStationImageView.image = [UIImage imageNamed:@"忙碌"];
//                doctorCell.headerImageView.alpha = 1;
//                
//            }
//                break;
//            default:
//            {
//                //在线
//                doctorCell.onlineStationImageView.image = nil;
//                doctorCell.headerImageView.alpha = 1;
//            }
//                break;
//        }
        
    } else {
        //义诊医生
        
        FreeClinicDoctorData *doctor = object;
        [doctorCell.headerImageView sd_setImageWithURL:[NSURL URLWithString:doctor.User.PhotoUrl] placeholderImage:[UIImage imageNamed:@"医生"]];
        
        doctorCell.nameLabel.text = doctor.DoctorName;
        doctorCell.levelLabel.text = doctor.Title;
        doctorCell.departmentLabel.text = doctor.DepartmentName;

        doctorCell.hospitalLevelImageView.hidden = YES;

//        if (![doctor.Grade isEqualToString:@"三甲"]) {
//            
//            doctorCell.hospitalLevelImageView.hidden = YES;
//        }
//        else {
//            
//            doctorCell.hospitalLevelImageView.hidden = NO;
//        }

//        switch (doctor.OnlineStatus) {
//            case 0:
//            {
//                //离线
//                doctorCell.onlineStationImageView.image = [UIImage imageNamed:@"离线"];
//                doctorCell.headerImageView.alpha = 0.5;
//            }
//                break;
//            case 1:
//            {
//                //忙碌
//                doctorCell.onlineStationImageView.image = [UIImage imageNamed:@"忙碌"];
//                doctorCell.headerImageView.alpha = 1;
//                
//            }
//                break;
//            default:
//            {
//                //在线
//                doctorCell.onlineStationImageView.image = nil;
//                doctorCell.headerImageView.alpha = 1;
//            }
//                break;
//        }
        
    }
    


}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {

    return CGFLOAT_MIN;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {

    return CGFLOAT_MIN;
}

//每个item 的视图的宽高  只有宽高，没有frame
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    CGSize size = CGSizeMake(94, 143);
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    DDLogError(@"点击－－%ld",(long)indexPath.item);
    if (self.doctorClick) {
        self.doctorClick(indexPath);
    }
}

#pragma mark - public
- (void)sendDoctorData:(NSArray *)data {

    self.dataArray = data;
//    if (self.dataArray && self.dataArray.count > 0) {
//
//        [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo(40);
//        }];
//        [self.footerView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo(10);
//        }];
//    }
//    else {
//        [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo(0);
//        }];
//        [self.footerView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo(0);
//        }];
//    }

    [self.doctorCollectionView reloadData];
}

- (void)sendFreeClinicDoctorData:(NSArray<FreeClinicDoctorData *> *)data
{
    self.dataArray = data;
    
    [self.doctorCollectionView reloadData];
}

#pragma mark - action

- (void)headerClick {
    if (self.moreBlock) {
        self.moreBlock();
    }
}

#pragma mark - getter
- (UICollectionView *)doctorCollectionView {
    if (!_doctorCollectionView) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _doctorCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flow];
        _doctorCollectionView.backgroundColor = [UIColor whiteColor];

        _doctorCollectionView.delegate = self;
        _doctorCollectionView.dataSource = self;

        [_doctorCollectionView registerClass:[BATConsultationDoctorInfoCollectionViewCell class] forCellWithReuseIdentifier:DOCTOR_CELL];
    }
    return _doctorCollectionView;
}

- (UITapGestureRecognizer *)tap {
    if (!_tap) {

        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerClick)];
    }
    return _tap;
}

- (UIView *)headerView {

    if (!_headerView) {
        _headerView = [[UIView alloc] init];
        _headerView.backgroundColor = [UIColor whiteColor];
        [_headerView setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0.5];
        [_headerView addGestureRecognizer:self.tap];
    }
    return _headerView;
}

- (UILabel *)departNameLabel {
    if (!_departNameLabel) {
        _departNameLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:UIColorFromHEX(0x333333, 1) textAlignment:NSTextAlignmentLeft];
    }
    return _departNameLabel;
}

- (UIButton *)moreButton {
    if (!_moreButton) {
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom Title:@"更多" titleColor:[UIColor grayColor] backgroundColor:[UIColor clearColor] backgroundImage:nil Font:[UIFont systemFontOfSize:12]];
        [_moreButton setImage:[UIImage imageNamed:@"icon_arrow_right"] forState:UIControlStateNormal];
        _moreButton.userInteractionEnabled = NO;

        // 间距
        CGFloat spacing = 15.0;
        CGSize imageSize = _moreButton.imageView.frame.size;
        _moreButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width * 2 - spacing, 0.0, 0.0);
        CGSize titleSize = _moreButton.titleLabel.frame.size;
        _moreButton.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, - titleSize.width * 2 - spacing);
    }
    return _moreButton;
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] init];
        _footerView.backgroundColor = BASE_BACKGROUND_COLOR;
    }
    return _footerView;
}

@end
