//
//  BATConsultationDoctorInfoView.h
//  HealthBAT_Pro
//
//  Created by KM on 16/9/62016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATConsultationDoctorDetailModel.h"
#import "BATHospitalRegisterDoctorModel.h"
#import "BATConsultationCollectionButton.h"

@interface BATConsultationDoctorInfoView : UIView

@property (nonatomic,strong) UIImageView *headerImageView;
@property (nonatomic,strong) UIImageView *onlineStationImageView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *hospitalLevelLabel;
@property (nonatomic,strong) UILabel *departmentLabel;
@property (nonatomic,strong) UILabel *hospitalLabel;
//@property (nonatomic,strong) UIButton *collectionButton;
@property (nonatomic,strong) BATConsultationCollectionButton *collectionButton;

@property (nonatomic,copy) void(^collectionDoctorBlock)(void);

- (instancetype)initWithFrame:(CGRect)frame docotrDetailModel:(BATConsultationDoctorDetailModel *)KMDoctorDetail or:(BATHospitalRegisterDoctorModel *)HRDoctorDetail;

- (void)loadConsultationDoctorDetail:(BATConsultationDoctorDetailModel *)KMDoctorDetail;

- (void)loadHospitalRegisterDoctor:(BATHospitalRegisterDoctorModel *)HRDoctorDetail;

@end
