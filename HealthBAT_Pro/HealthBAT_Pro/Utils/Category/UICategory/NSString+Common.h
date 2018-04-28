//
//  NSString+Common.h
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/5/18.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Common)
//判断是否是手机号码或者邮箱
- (BOOL)isPhoneNo;
- (BOOL)isEmail;
- (BOOL)isQQ;
- (BOOL)isChineseUserName;
- (BOOL)isUserName;
- (BOOL)isPassword;
//是否纯数字
- (BOOL)isPureNumandCharacters;
//字符数目
- (int)charCount;
- (BOOL)isUrlAddress;
// 检查字符串是否为空
+ (id)checkNull:(id)source;

//去掉<br />
- (NSString *)stringByShowLinefeedString;
//替换\n为<br />
- (NSString *)stringByPostLinefeedString;
//根据出生日期返回详细的年龄
-(NSString *)dateToOld:(NSDate *)bornDate;
@end
