//
//  Assistant.h
//  XMPP
//
//  Created by KM on 16/3/292016.
//  Copyright © 2016年 skybrim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Tools : NSObject

/**
 *  根据文本及其宽度与字号计算高度
 *
 *  @param text  文本
 *  @param width 宽度
 *  @param font  字号
 *
 *  @return 文本高度
 */
+ (CGFloat)calculateHeightWithText:(NSString *)text
                             width:(CGFloat)width
                              font:(UIFont *)font;


/**
 *  根据文本及其宽度与字号和行高计算高度
 *
 *  @param text       文本
 *  @param width      宽度
 *  @param font       字号
 *  @param lineHeight 行高
 *
 *  @return 文本高度
 */
+ (CGFloat)calculateHeightWithText:(NSString *)text
                             width:(CGFloat)width
                              font:(UIFont *)font
                        lineHeight:(CGFloat)lineHeight;


/**
 获取属性字符串的高度

 @param attributedText 属性字符串
 @param textWidth 宽度
 @return 高度
 */
+ (CGFloat)getHeightForAttributedText:(NSAttributedString *)attributedText
                            textWidth:(CGFloat)textWidth;

+ (CGFloat)getWidthForAttributedText:(NSAttributedString *)attributedText
                          textHeight:(CGFloat)textHeight;


/**
 *  获取url中的参数
 *
 *  @param urlString url
 *
 *  @return 参数字典
 */
+ (NSDictionary *)getParametersWithUrlString:(NSString *)urlString;

/**
 *  获取本地版本号
 *
 *  @return 本地版本号
 */
+ (NSString *)getLocalVersion;

/**
 *  根据appstore中版本号与本地版本号对比判断是否需要更新
 */
+ (void)updateVersion;

/**
 *  倒计时
 *
 *  @param time  倒计时间
 *  @param end   结束动作
 *  @param going 倒计进行中动作
 */
+ (void)countdownWithTime:(int)time
                      End:(void(^)(void))end
                    going:(void(^)(NSString * time))going;


/**
 *  获取当前vc
 *
 *  @return 当前vc
 */
+ (UIViewController *)getCurrentVC;

+ (UIViewController *)getPresentedViewController;

/**
 *  正则验证手机号码
 *
 *  @param phoneNumber 手机号码
 *
 *  @return 手机号真假
 */
+ (BOOL)checkPhoneNumber:(NSString *)phoneNumber;

/**
 *  身份证验证
 *
 *  @param cardNo 身份证号
 *
 *  @return 身份证格式正确与否
 */
+(BOOL)checkIdentityCardNo:(NSString*)cardNo;

/**
 *  替换手机号中间四位数
 *
 *  @param number 手机号
 *
 *  @return 替换后的手机号
 */
+ (NSString *)replacePhoneMiddleWithPhoneNumber:(NSString *)number;

/**
 *  将对象类型转化为jsonDic
 *
 *  @param object 对象
 *
 *  @return jsonDic
 */
+ (NSDictionary *)convertFromObjectWith:(id)object;


/**
 *  检查网路连接
 *
 *  @return 网络是否通顺
 */
+ (BOOL)checkNetWorkIsOk;

/**
 *  获取本机IP
 *
 *  @return 本机IP
 */
+ (NSString *)getIpAddresses;

/**
 *  清除直接写入本地的数据
 *
 *  @param fileLocal 文件地址
 */
+ (void)removeLocalDataWithFile:(NSString *)fileLocal;

/**
 *  去除URL中的特殊符号
 *
 *  @param string url
 *
 *  @return 去除符号后的url
 */
+ (NSString *)URLEncodedString:(NSString *)string;


/**
 去HTML标签

 @param html 原字符串

 @return 去HTML标签的字符串
 */
+ (NSString *)filterHTML:(NSString *)html;

/**
 *  md5加密
 *
 *  @param str 未加密字符串
 *
 *  @return 加密字符串
 */
+ (NSString *)md5String:(NSString *)str;

/**
 *  根据颜色值获取image
 *
 *  @param color 指定颜色
 *
 *  @return image
 */
+ (UIImage *)imageFromColor:(UIColor *)color;


/**
 *  图片压缩方法
 *
 *  @param orignalImage 原图
 *  @param percent      缩放压缩质量
 *
 *  @return image
 */
+ (UIImage *)compressImageWithImage:(UIImage *)orignalImage ScalePercent:(CGFloat)percent;

/**
 *  压缩图片质量
 *
 *  @param image   原图
 *  @param percent 压缩质量
 *
 *  @return image
 */
+ (UIImage *)reduceImage:(UIImage *)image percent:(float)percent;

/**
 *  压缩图片尺寸
 *
 *  @param image   原图
 *  @param newSize new Size
 *
 *  @return image
 */
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;

/**
 *  判断字符串是不是NSNull类
 *
 *  @param string 字符串
 *
 *  @return YES OR NO
 */
+ (BOOL)isNSNullCharacter:(NSString *)string;

/**
 *  格式化当前时间
 *
 *  @param format 格式
 *
 *  @return 格式化后的时间
 */
+ (NSString *)getCurrentDateStringByFormat:(NSString *)format;

/**
 *  格式化时间
 *
 *  @param date   时间
 *  @param format 格式
 *
 *  @return 格式化后的时间
 */
+ (NSString *)getDateStringWithDate:(NSDate *)date Format:(NSString *)format;


/**
 string转date

 @param dateString 时间字符串
 @param format 格式
 @return date
 */
+ (NSDate *)dateWithDateString:(NSString *)dateString Format:(NSString *)format;

/**
 *  跳转设置界面
 *
 *  @param title   标题
 *  @param message 内容
 *  @param failure 失败时执行
 */
+ (void)showSettingWithTitle:(NSString *)title
                     message:(NSString *)message
                     failure:(void (^)(void))failure;

/**
 *  改变image的alpha
 *
 *  @param alpha alpha
 *  @param image 原图
 *
 *  @return 改变alpha值的图片
 */
+ (UIImage *)imageByApplyingAlpha:(CGFloat)alpha  image:(UIImage*)image;


/**
 *  获取UUID
 *
 *  @return 格式化后的字符串
 */
+ (NSString *)getUUID;

/**
 *  获取ip地址
 *
 *  @return 格式化后的字符串
 */
+ (NSString *)get4GorWIFIAddress;




/**
 *  将字典转化为jsonstring
 *
 *  @param object 对象
 *
 *  @return jsonString
 */
+ (NSString *)dataTojsonString:(id)object;


/**
 将json字符串转为字典

 @param jsonString json字符串
 @return json字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

/*
 * 获取不变的UUID
 */
+ (NSString *)getPostUUID;

/*
 * 获取USEID
 */
+ (NSString *)getCurrentID;

/*
 * 生成不重复随机数
 */
+(NSString *)randomArray;


/**
 获取一个随机整数，范围在[from,to]


 @param from 起点数
 @param to 终点数
 @return 随机数
 */
+ (int)getRandomNumber:(int)from to:(int)to;

+ (UIImage *)findFace:(UIImage *)sourceImage;

+ (BOOL)verifyIDCardNumber:(NSString *)IDCardNumber;


/*
 *  计算缓存大小
 */
- ( float )filePath;

/*
 *  清除缓存
 */

- (void)clearFile:(void (^)(void))success;



/**
 计算两个时间的差值

 @param date1 时间1
 @param date2 时间2
 @param type 类型 1秒 2分 3时 4天 5月 6年
 @return 时间差值
 */
+ (long)compareDate1:(NSDate *)date1 withDate2:(NSDate *)date2 type:(int)type;

//+ (NSInteger) getWeekDayFromDateString:(NSString *)dateString;

+ (NSString*)getWeekdayStringFromDate:(NSDate*)inputDate;

//获取本地时间string
+ (NSString *) getLocalDateWithTimeString:(BOOL)time;

//字符串转换时间戳
+ (NSTimeInterval)getIntervalFromString:(NSString *)str;

// 获取Storyboard实例
+ (UIStoryboard *) getStoryboardInstance;

////获取本地时间
//+ (NSDate *) getLocalDate;
+ (NSString *) getStringFromDate:(NSDate*)date;

/**
 *  获取随机颜色
 *
 *
 *  @return color
 */
+ (UIColor *)getRandomColor;


/**
 判断星期几

 @param inputDate 时间
 @return 星期几
 */
- (NSString*)weekdayStringFromDate:(NSDate*)inputDate;


/**
 设备信息

 @return 设备型号
 */
+ (NSString *)platform;
/**
 去除标签
 
 @return 标签字符串
 */
+(NSString *)getZZwithString:(NSString *)string;
@end

