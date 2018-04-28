//
//  BATListenDoctorDetailController.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/3/21.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATListenDoctorDetailController : UIViewController

@property (nonatomic,strong) NSString *ID;
@property (nonatomic,strong) NSString *titleString;

@property (nonatomic,strong) void (^listenDoctorBlock)(BOOL isAttend);

@property (nonatomic,strong) void (^listenDoctorUpdateReadNumBlock)(void);
@end
