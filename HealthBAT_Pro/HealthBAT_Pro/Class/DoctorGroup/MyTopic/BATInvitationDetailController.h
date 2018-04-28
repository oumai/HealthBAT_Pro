//
//  BATInvitationDetailController.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/3/20.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATInvitationDetailController : UIViewController

@property (nonatomic,strong) NSString *ID;

@property (nonatomic,strong) void (^priseBlock)(BOOL isPrise);

@property (nonatomic,strong) void (^updateReadNumBlock)(void);

@end
