//
//  CommonMacro.h
//  XMPP
//
//  Created by KM on 16/3/28.
//  Copyright © 2016年 skybrim. All rights reserved.
//

#ifndef CommonMacro_h
#define CommonMacro_h
#import "CocoaLumberjack.h"

#ifdef RELEASE
static const DDLogLevel ddLogLevel = DDLogLevelOff;
#elif ENTERPRISERELEASE
static const DDLogLevel ddLogLevel = DDLogLevelOff;
#elif PRERELEASE
static const DDLogLevel ddLogLevel = DDLogLevelOff;
#else
static const DDLogLevel ddLogLevel = DDLogLevelAll;
#endif

//mainWindow
#define MAIN_WINDOW [UIApplication sharedApplication].keyWindow

//宽高
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

//状态栏高度
#define kSTATUSBAR_HEIGHT [UIApplication sharedApplication].statusBarFrame.size.height


//字体
//#define stringFont(s) [UIFont fontWithName:@"Hiragino Kaku Gothic ProN W3" size:s]
#define stringFont(s) [UIFont systemFontOfSize:s]

//颜色
// RGB颜色转换（16进制->10进制）
#define UIColorFromHEX(rgbValue,A) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:A]
#define UIColorFromRGB(R,G,B,A) [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:A]

// 弱引用
#define WeakSelf __weak typeof(self) weakSelf = self;

#define RGB(a,b,c)      [UIColor colorWithRed:a/255.0 green:b/255.0 blue:c/255.0 alpha:1.0]
#define batRandomColor RGB(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))

#define LineColor RGB(200,199,204)
#define ErrorText @"网络消化不良\n请检查您的网络哦"
#define AppFontHelvetica   @"Helvetica-Light"

#define IS_IOS10 ([[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue] >= 10)
#define IS_IOS9 ([[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue] >= 9)
#define IS_IOS8 ([[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue] >= 8)
#define IS_IOS7 ([[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue] >= 7)
#define IS_IOS6 ([[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue] == 6)
#define RGBA(r, g, b, a)    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

//#define APPSTORE_URL @"https://itunes.apple.com/cn/app/kang-mei-zhi-hui-yao-fang/id1169968028?l=zh&mt=8"

//判断IOS版本
#define iPhoneSystemVersion ([UIDevice currentDevice].systemVersion.floatValue)

//定义设备的类型

#define iPad   (([[NSUserDefaults standardUserDefaults] integerForKey:@"ImageResolutionHeight"]) == 1024?YES:NO)

#define iPhone4   (([[NSUserDefaults standardUserDefaults] integerForKey:@"ImageResolutionHeight"]) == 960?YES:NO)
#define iPhone5   (([[NSUserDefaults standardUserDefaults] integerForKey:@"ImageResolutionHeight"]) == 1136?YES:NO)
#define iPhone6   (([[NSUserDefaults standardUserDefaults] integerForKey:@"ImageResolutionHeight"]) == 1334?YES:NO)
#define iPhone6p  (([[NSUserDefaults standardUserDefaults] integerForKey:@"ImageResolutionHeight"]) == 2208?YES:NO)
#define iPhoneX   (([[NSUserDefaults standardUserDefaults] integerForKey:@"ImageResolutionHeight"]) == 2436?YES:NO)

#endif /* CommonMacro_h */
