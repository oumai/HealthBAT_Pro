//
//  BATHomeConsultationCollectionViewCell.h
//  HealthBAT_Pro
//
//  Created by KM on 16/9/192016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATHomeConsultationView.h"
#import "BATHomeHospitalRegisterView.h"
#import "BATHomeNationalPhysicianPavilionView.h"

@interface BATHomeConsultationTableViewCell : UITableViewCell

@property (nonatomic,strong) BATHomeNationalPhysicianPavilionView *nationalPhysicianPavilionView;
@property (nonatomic,strong) BATHomeNationalPhysicianPavilionView *healthButlerView;

@property (nonatomic,strong) BATHomeConsultationView *consultationView;
@property (nonatomic,strong) BATHomeHospitalRegisterView *hospitalRegisterView;
@property (nonatomic,strong) BATHomeHospitalRegisterView *intelligentGuideView;

@property (nonatomic,copy) void(^nationalPhysicianPavilionBlock)(void);
@property (nonatomic,copy) void(^healthButlerBlock)(void);
@property (nonatomic,copy) void(^consultationBlock)(void);
@property (nonatomic,copy) void(^hospitalRegisterBlock)(void);
@property (nonatomic,copy) void(^intelligentGuideBlock)(void);

@end
