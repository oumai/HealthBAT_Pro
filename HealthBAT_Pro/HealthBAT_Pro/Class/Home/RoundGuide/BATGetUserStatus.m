//
//  BATGetUserStatus.m
//  HealthBAT_Pro
//
//  Created by 黄帆 on 2017/11/24.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATGetUserStatus.h"
#import "BATPerson.h"
@implementation BATGetUserStatus
- (guideStatus)userStatus {

        BATPerson *personModel = PERSON_INFO;
        if (personModel.Data) {//是登录状态
            if ([personModel.Data.Sex isEqualToString:@"1"]) {
                if (personModel.Data.Age >= 35) {
                    _userStatus = blueStatus;
                } else {
                    _userStatus = greenStatus;
                }
                
            } else {//性别是女性
                
                if (personModel.Data.Age <= 35) {
                    _userStatus = pinkStatus;
                } else {
                    _userStatus = cyanStatus;
                }
            }
        } else {//非登录状态
            
            _userStatus = greenStatus;
            
        }

    return _userStatus;
    
}
/*
 *
 typedef NS_ENUM(NSInteger, guideStatus){
 
 greenStatus = 0, //默认 男 < 35 和 未登录 默认 是_q结尾
 pinkStatus, //女2 > 35   _p结尾
 cyanStatus, //女1 < 35 _c结尾
 blueStatus //男1 > 35 _b结尾
 
 };
 */
//用目前的状态改变stirng的后缀
- (NSString *)changeStringByStatusWithString:(NSString *)nowString; {
    
    if (!nowString ) {
        return @"";
    }
    if (nowString.length <= 2) {
        return nowString;
    }
    NSMutableString *mStr = [NSMutableString string];
    
    mStr = [nowString mutableCopy];
    switch (self.userStatus) {
        case greenStatus:
            {
                [mStr replaceCharactersInRange:NSMakeRange(mStr.length - 2, 2) withString:@"_q"];
            }
            break;
        case pinkStatus:
        {
            [mStr replaceCharactersInRange:NSMakeRange(mStr.length - 2, 2) withString:@"_p"];
   
        }
            break;
        case cyanStatus:
        {
            [mStr replaceCharactersInRange:NSMakeRange(mStr.length - 2, 2) withString:@"_c"];
   
        }
            break;
        case blueStatus:
        {
            [mStr replaceCharactersInRange:NSMakeRange(mStr.length - 2, 2) withString:@"_b"];
    
        }
            break;
     
        default:
            break;
    }

    return mStr;
}
- (UIColor *)changeTitleColor {
    switch (self.userStatus) {
        case greenStatus: return UIColorFromHEX(0x3988ac, 1);
        case pinkStatus : return UIColorFromHEX(0xfa7071, 1);
        case cyanStatus : return UIColorFromHEX(0x4c97aa, 1);
        case blueStatus : return UIColorFromHEX(0xcfffff, 1);
        default: return UIColorFromHEX(0x3988ac, 1);;
    }
}
@end
