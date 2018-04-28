//
//  BATMineFiledEditorController.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2016/12/9.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseTreatmentModel.h"
@interface BATMineFiledEditorController : UIViewController
@property (nonatomic,strong) ChooseTreatmentModel *model;
@property (nonatomic,strong) void (^refreshBlock)(BOOL isRefresh);
@property (nonatomic,strong) void (^refreshSexAndAge)(NSString *name,NSString *sex,NSString *age);
@end
