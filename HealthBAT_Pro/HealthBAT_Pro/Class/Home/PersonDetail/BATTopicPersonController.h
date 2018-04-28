//
//  BATTopicPersonController.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/3/17.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATTopicPersonController : UIViewController

@property (nonatomic,strong) NSString *accountID;

@property (nonatomic,strong) void (^PersonRefreshBlock)(BOOL isChange);

@end
