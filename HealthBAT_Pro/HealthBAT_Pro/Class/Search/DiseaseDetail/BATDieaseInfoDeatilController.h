//
//  BATDieaseInfoDeatilController.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2016/11/23.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATSymptomModel.h"
@interface BATDieaseInfoDeatilController : UIViewController
@property (nonatomic,strong) NSString *ID;
@property (nonatomic,assign) BATSearchType type;
@property (nonatomic,assign) BOOL isSymptom;
@end
