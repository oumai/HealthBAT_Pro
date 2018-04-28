//
//  BATSearchDieaseDetailController.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/5/8.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATSearchDieaseDetailController : UIViewController

@property (nonatomic,strong) NSString *key;

@property (nonatomic,assign) NSInteger DieaseID;

@property (nonatomic,strong) NSString *EntryCNName;

@property (nonatomic,strong) NSString *pathName;

@property (nonatomic,strong) NSString *resultDesc;

@property (nonatomic,strong) NSString *titleName;

@end
