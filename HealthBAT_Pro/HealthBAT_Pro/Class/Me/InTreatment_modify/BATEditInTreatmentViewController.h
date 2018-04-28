//
//  BATEditInTreatmentViewController.h
//  HealthBAT_Pro
//
//  Created by MichaeOu on 2017/6/13.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseTreatmentModel.h"

@interface BATEditInTreatmentViewController : UIViewController
@property(nonatomic,strong)void (^RefreshBlock)(void);//刷新档案列表refresh
@property (nonatomic,strong) ChooseTreatmentModel *model;

@property (nonatomic, strong) NSString *nameString;
//@property (nonatomic, strong) NSString *sexString;
//@property (nonatomic, strong) NSString *ageString;
@property (nonatomic, strong) NSString *phoneNumberString;
@property (nonatomic, strong) NSString *identityCardString;//身份证
@property (nonatomic, strong) NSString *relationshipString;
@property (nonatomic, assign) NSInteger ID;
@end
