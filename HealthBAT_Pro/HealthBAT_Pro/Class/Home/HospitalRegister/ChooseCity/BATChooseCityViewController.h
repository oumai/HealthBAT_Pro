//
//  ChooseCityViewController.h
//  HealthBAT_Pro
//
//  Created by KM on 16/7/142016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATChooseCityViewController : UIViewController

@property (nonatomic,copy  ) NSString *currentCity;
@property (nonatomic,copy) void(^cityChanged) (NSString * cityName);

@end
