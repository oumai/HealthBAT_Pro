//
//  BATHomeThemeManager.h
//  HealthBAT_Pro
//
//  Created by Carbon on 2017/11/28.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LEETheme.h"
#import "BATThemeConstantHeader.h"

typedef NS_ENUM(NSInteger ,BATHomeThemeType) {
    BATHomeThemeTypeUnkonwn = -1,
    BATHomeThemeTypeDefault = 0,
    BATHomeThemeTypeMaleBlue = 1,
    BATHomeThemeTypeFemalePink = 2,
    BATHomeThemeTypeFemaleCyan = 3
};

@interface BATHomeThemeManager : NSObject
+ (instancetype)shareInstance;
- (void)homeThemeInitConfig;
- (BATHomeThemeType)getCurrentThemeType;
@end
