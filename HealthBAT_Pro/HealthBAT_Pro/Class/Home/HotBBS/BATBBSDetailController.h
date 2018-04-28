//
//  BATBBSDetailController.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/2/21.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATMomentsModel.h"
@interface BATBBSDetailController : UIViewController

@property (nonatomic,strong) BATMomentData *monentsModel;

@property (nonatomic,strong) NSString *PostId;

@property (nonatomic,assign) BOOL isScro;

@property (nonatomic,strong) void(^isRefreshBlock)(BOOL isRefresh);

@end
