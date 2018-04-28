//
//  BATNewPayDoctorInfoCell.h
//  HealthBAT_Pro
//
//  Created by four on 2017/5/11.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATNewPayDoctorInfoCell : UITableViewCell

@property (nonatomic,strong) UIImageView *doctorImageView;

@property (nonatomic,strong) UILabel *doctorName;

@property (nonatomic,strong) UILabel *timeLable;

@property (nonatomic,strong) UIImageView *rightIcon;

@property (nonatomic,copy) void(^chooseConsultingTime)(void);

@end
