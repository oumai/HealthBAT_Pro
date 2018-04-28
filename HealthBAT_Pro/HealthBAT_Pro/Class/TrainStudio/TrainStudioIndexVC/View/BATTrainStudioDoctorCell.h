//
//  BATTrainStudioDoctorCell.h
//  HealthBAT_Pro
//
//  Created by four on 17/4/1.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATGraditorButton.h"

@interface BATTrainStudioDoctorCell : UITableViewCell

@property (nonatomic,strong) UIImageView *headerImageView;

@property (nonatomic,strong) UILabel *nameLable;

@property (nonatomic,strong) UILabel *levelLable;

@property (nonatomic,strong) UILabel *skillLable;

@property (nonatomic,strong) BATGraditorButton *courseBtn;

@property (nonatomic,copy)   void(^courseBtnClickBlock)(void);

@end
