//
//  Assistant.m
//  XMPP
//
//  Created by KM on 16/3/292016.
//  Copyright © 2016年 skybrim. All rights reserved.
//

#import "Tools.h"
#import "AFNetworking.h"
#import <objc/runtime.h>

#import <sys/socket.h>
#import <sys/sockio.h>
#import <sys/ioctl.h>
#import <net/if.h>
#import <arpa/inet.h>
#import <CommonCrypto/CommonDigest.h>
#import "SFHFKeychainUtils.h"

#import "BATPerson.h"

#import "sys/utsname.h"

@implementation Tools
#pragma mark - 根据文本计算文本高度
+ (CGFloat)calculateHeightWithText:(NSString *)text width:(CGFloat)width font:(UIFont *)font {

    CGFloat height = 0.0;
    
    CGRect  rect = [text boundingRectWithSize:CGSizeMake(width, 0)
                                      options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                   attributes:@{NSFontAttributeName:font}
                                      context:nil];
    height = ceil(rect.size.height);
    return height;
}

#pragma mark - 根据文本计算文本高度
+ (CGFloat)calculateHeightWithText:(NSString *)text width:(CGFloat)width font:(UIFont *)font lineHeight:(CGFloat)lineHeight
{
    CGFloat height = 0;
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.maximumLineHeight = lineHeight;
    style.minimumLineHeight = lineHeight;
    
    CGRect  rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                      options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                   attributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName:style}
                                      context:nil];
    height = ceil(rect.size.height);
    return height;
}

+ (CGFloat)getHeightForAttributedText:(NSAttributedString *)attributedText
                            textWidth:(CGFloat)textWidth
{
    CGSize constraint = CGSizeMake(textWidth , CGFLOAT_MAX);
    CGSize title_size;
    CGFloat totalHeight;
    title_size = [attributedText boundingRectWithSize:constraint
                                              options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                              context:nil].size;

    totalHeight = ceil(title_size.height);

    return totalHeight;
}

+ (CGFloat)getWidthForAttributedText:(NSAttributedString *)attributedText
                          textHeight:(CGFloat)textHeight
{
    CGSize constraint = CGSizeMake(CGFLOAT_MAX , textHeight);
    CGSize title_size;
    CGFloat width;
    title_size = [attributedText boundingRectWithSize:constraint
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                              context:nil].size;

    width = ceil(title_size.width);
    return width;
}
#pragma mark - 获取URL中的参数
+ (NSDictionary *)getParametersWithUrlString:(NSString *)urlString {

    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];

    //获取问号的位置，问号后是参数列表
    NSRange range = [urlString rangeOfString:@"?"];
    if (range.location == NSNotFound) {
        return tempDic;
    }
    //获取参数列表
    NSString *propertys = [urlString substringFromIndex:(int)(range.location+1)];
    //进行字符串的拆分，通过&来拆分，把每个参数分开
    NSArray *subArray = [propertys componentsSeparatedByString:@"&"];
    //把subArray转换为字典
    //tempDic中存放一个URL中转换的键值对
    if (subArray.count > 0) {

        for (int j = 0 ; j < subArray.count; j++) {

            //在通过=拆分键和值
            NSArray *dicArray = [subArray[j] componentsSeparatedByString:@"="];
            //给字典加入元素
            [tempDic setObject:dicArray[1] forKey:dicArray[0]];
        }
    }
    DDLogError(@"打印URL的参数列表生成的字典：\n%@", tempDic);
    return tempDic;
}

#pragma mark - 获取本本号
//获取本地版本号
+ (NSString *)getLocalVersion {

    NSDictionary * infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString * currentVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString * showString = [NSString stringWithFormat:@"%@",currentVersion];
    return showString;
}

//根据appstore中版本号与本地版本号对比判断是否需要更新
+ (void)updateVersion {

    //网络获取当前最新版本及版本更新信息
    //T_WARNING APP在appstore上的APPID
    NSString *url = [NSString stringWithFormat:@"http://itunes.apple.com/cn/lookup?id=%@",BAT_APPSTORE_ID];
    
    [XMCenter sendRequest:^(XMRequest *request) {
        request.url = url;
        request.httpMethod = kGET;
        request.requestSerializerType = kXMRequestSerializerRAW;
    } onSuccess:^(id responseObject) {
        
        //获取信息
        NSDictionary * response = responseObject;
        NSArray * arr = [response valueForKey:@"results"];
        NSDictionary * result = arr[0];
        NSString * appStoreVersion = [result valueForKey:@"version"];
        NSString * releaseNotes = [result valueForKey:@"releaseNotes"];
        
        //获取本地版本号
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *localVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        
        BOOL isUpdate = NO;
        
        NSMutableArray *localArray = [NSMutableArray arrayWithArray:[localVersion componentsSeparatedByString:@"."]];
        NSMutableArray *versionArray = [NSMutableArray arrayWithArray:[appStoreVersion componentsSeparatedByString:@"."]];
        
        while (localArray.count < 3) {
            [localArray addObject:@"0"];
        }
        
        while (versionArray.count < 3) {
            [versionArray addObject:@"0"];
        }
        
        
        if ((versionArray.count == 3) && (localArray.count == versionArray.count)) {
            
            if ([localArray[0] intValue] <  [versionArray[0] intValue]) {
                
                isUpdate = YES;
            }
            else if ([localArray[0] intValue]  ==  [versionArray[0] intValue]) {
                
                if ([localArray[1] intValue] <  [versionArray[1] intValue]) {
                    
                    isUpdate = YES;
                }
                else if ([localArray[1] intValue] ==  [versionArray[1] intValue]) {
                    
                    if ([localArray[2] intValue] <  [versionArray[2] intValue]) {
                        
                        isUpdate = YES;
                    }
                }
            }
        }
        
        
        //判断
        if (isUpdate) {
            
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"健康BAT有新版本"
                                                                            message:releaseNotes
                                                                     preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                                    style:UIAlertActionStyleCancel
                                                                  handler:nil];
            UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"去更新"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * _Nonnull action)
                                        {
                                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@?mt=8",BAT_APPSTORE_ID]]];
                                            
                                        }];
            [alert addAction:cancelAction];
            [alert addAction:okAction];
            UIWindow * window = MAIN_WINDOW;
            
            UIView *subView1 = alert.view.subviews[0];
            UIView *subView2 = subView1.subviews[0];
            UIView *subView3 = subView2.subviews[0];
            UIView *subView4 = subView3.subviews[0];
            UIView *subView5 = subView4.subviews[0];
            NSLog(@"%@",subView5.subviews);
            //取title和message：
//            UILabel *title = subView5.subviews[0];
            UILabel *message = subView5.subviews[1];
            message.textAlignment = NSTextAlignmentLeft;
//            title.textAlignment = NSTextAlignmentLeft;
            
            [window.rootViewController presentViewController:alert animated:YES completion:nil];
        }
        
        
    } onFailure:^(NSError *error) {
        
        
        
    } onFinished:^(id responseObject, NSError *error) {
        
        
    }];
    
    

}

#pragma mark - 倒计时
+ (void)countdownWithTime:(int)time
                      End:(void(^)(void))end
                    going:(void(^)(NSString * time))going {

    __block int timeout = time; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^
    {
        if(timeout<=0) {

            //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^
            {
                //设置界面的按钮显示 根据自己需求设置
                if (end) {
                    end();
                }

            });
        }
        else {

            int seconds = timeout % (time + 1);
            NSString *strTime = [NSString stringWithFormat:@"%d秒后重发", seconds];
            dispatch_async(dispatch_get_main_queue(), ^
            {
                //设置界面的按钮显示 根据自己需求设置
                going(strTime);
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}


#pragma mark - 获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC {
    
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    id  nextResponder = nil;
    UIViewController *appRootVC=window.rootViewController;
    //    如果是present上来的appRootVC.presentedViewController 不为nil
    if (appRootVC.presentedViewController) {
        nextResponder = appRootVC.presentedViewController;
    }else{
        UIView *frontView = [[window subviews] objectAtIndex:0];
        nextResponder = [frontView nextResponder];
    }
    
    if ([nextResponder isKindOfClass:[UITabBarController class]]){
        UITabBarController * tabbar = (UITabBarController *)nextResponder;
        UINavigationController * nav = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
        result=nav.childViewControllers.lastObject;
        
    }else if ([nextResponder isKindOfClass:[UINavigationController class]]){
        UIViewController * nav = (UIViewController *)nextResponder;
        result = nav.childViewControllers.lastObject;
    }else{
        result = nextResponder;
    }
    
    return result;

//    UIViewController *result = nil;
//    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
//    if (window.windowLevel != UIWindowLevelNormal) {
//
//        NSArray *windows = [[UIApplication sharedApplication] windows];
//        for(UIWindow * tmpWin in windows) {
//
//            if (tmpWin.windowLevel == UIWindowLevelNormal) {
//
//                window = tmpWin;
//                break;
//            }
//        }
//    }
//
//    UIView *frontView = [[window subviews] objectAtIndex:0];
//    id nextResponder = [frontView nextResponder];
//
//    if ([nextResponder isKindOfClass:[UIViewController class]]) {
//
//        result = nextResponder;
//    }
//    else {
//
//        result = window.rootViewController;
//    }
//    return result;
}

+ (UIViewController *)getPresentedViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    if (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    
    return topVC;
}

#pragma mark - 手机正则
+ (BOOL)checkPhoneNumber:(NSString *)phoneNumber {

    //正则表达式验证手机
    NSString *pattern = @"^(0|86|17951)?1[3|4|5|7|8][0-9]{9}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:phoneNumber];
    return isMatch;
}

#pragma mark - 身份证验证
+(BOOL)checkIdentityCardNo:(NSString*)cardNo
{
    if (cardNo.length != 18) {
        return  NO;
    }
    NSArray* codeArray = [NSArray arrayWithObjects:@"7",@"9",@"10",@"5",@"8",@"4",@"2",@"1",@"6",@"3",@"7",@"9",@"10",@"5",@"8",@"4",@"2", nil];
    NSDictionary* checkCodeDic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"1",@"0",@"X",@"9",@"8",@"7",@"6",@"5",@"4",@"3",@"2", nil]  forKeys:[NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10", nil]];

    NSScanner* scan = [NSScanner scannerWithString:[cardNo substringToIndex:17]];

    int val;
    BOOL isNum = [scan scanInt:&val] && [scan isAtEnd];
    if (!isNum) {
        return NO;
    }
    int sumValue = 0;

    for (int i =0; i<17; i++) {
        sumValue+=[[cardNo substringWithRange:NSMakeRange(i , 1) ] intValue]* [[codeArray objectAtIndex:i] intValue];
    }

    NSString* strlast = [checkCodeDic objectForKey:[NSString stringWithFormat:@"%d",sumValue%11]];

    if ([strlast isEqualToString: [[cardNo substringWithRange:NSMakeRange(17, 1)]uppercaseString]]) {
        return YES;
    }
    return  NO;
}


#pragma mark - 替换手机中间4位
+ (NSString *)replacePhoneMiddleWithPhoneNumber:(NSString *)number {
    
    NSMutableString * phoneNumber = [NSMutableString stringWithString:number];
    NSRange range;
    range.location = 3;
    range.length = 4;
    [phoneNumber replaceCharactersInRange:range withString:@"****"];
    return phoneNumber;
}

#pragma mark 将对象转化为jsonDic
+ (NSDictionary *)convertFromObjectWith:(id)object{

    NSMutableDictionary * jsonDic = [[NSMutableDictionary alloc] init];
    NSMutableArray * props = [NSMutableArray array];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([object class], &outCount);
    for (i = 0; i<outCount; i++) {

        const char* char_f =property_getName(properties[i]);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        [props addObject:propertyName];
    }
    free(properties);

    for (NSString *key in props) {

        [jsonDic setValue:[object valueForKey:key] forKey:key];//从类里面取值然后赋给每个值，取得字典
    }
    return jsonDic;
}

#pragma mark - 检查网路状况
+ (BOOL)checkNetWorkIsOk {

    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;

    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;

    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);

    if (!didRetrieveFlags) {
        return NO;
    }

    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    BOOL nonWifi = flags & kSCNetworkReachabilityFlagsTransientConnection;
    BOOL moveNet = flags & kSCNetworkReachabilityFlagsIsWWAN;

    return ((isReachable && !needsConnection) || nonWifi || moveNet) ? YES : NO;
}

#pragma mark - 获取本机IP
+ (NSString *)getIpAddresses {

    NSString *ip = nil;

    int sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    if (sockfd < 0) return nil;

    int BUFFERSIZE = 4096;
    struct ifconf ifc;
    char buffer[BUFFERSIZE], *ptr, lastname[IFNAMSIZ], *cptr;
    struct ifreq *ifr, ifrcopy;
    ifc.ifc_len = BUFFERSIZE;
    ifc.ifc_buf = buffer;
    if (ioctl(sockfd, SIOCGIFCONF, &ifc) >= 0){
        for (ptr = buffer; ptr < buffer + ifc.ifc_len; ){
            ifr = (struct ifreq *)ptr;
            int len = sizeof(struct sockaddr);
            if (ifr->ifr_addr.sa_len > len) {
                len = ifr->ifr_addr.sa_len;
            }
            ptr += sizeof(ifr->ifr_name) + len;
            if (ifr->ifr_addr.sa_family != AF_INET) continue;
            if ((cptr = (char *)strchr(ifr->ifr_name, ':')) != NULL) *cptr = 0;
            if (strncmp(lastname, ifr->ifr_name, IFNAMSIZ) == 0) continue;
            memcpy(lastname, ifr->ifr_name, IFNAMSIZ);
            ifrcopy = *ifr;
            ioctl(sockfd, SIOCGIFFLAGS, &ifrcopy);
            if ((ifrcopy.ifr_flags & IFF_UP) == 0) continue;

            ip = [NSString stringWithFormat:@"%s", inet_ntoa(((struct sockaddr_in *)&ifr->ifr_addr)->sin_addr)];
        }
    }
    close(sockfd);
    return ip;
}

#pragma mark - 清除数据
+ (void)removeLocalDataWithFile:(NSString *)fileLocal {
    NSString *areafile = [NSHomeDirectory() stringByAppendingPathComponent:fileLocal];
    if ([[NSFileManager defaultManager] fileExistsAtPath:areafile]) {
        [[NSFileManager defaultManager] removeItemAtPath:areafile error:nil];
    }
}

#pragma mark - 去除URL中的特殊符号
+ (NSString *)URLEncodedString:(NSString *)string {
    NSString *encodedString = [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
    return encodedString;
}

#pragma mark - 去HTML标签
+ (NSString *)filterHTML:(NSString *)html {
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO) {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
//    NSString * regEx = @"<([^>]*)>";
//    html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
}


#pragma mark - md5加密
+ (NSString *)md5String:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

#pragma mark - 根据颜色值获取image
+ (UIImage *)imageFromColor:(UIColor *)color
{
    CGSize size = CGSizeMake(10, 10);
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, (CGRect){CGPointZero,size});
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

#pragma mark - 图片压缩方法
+ (UIImage *) compressImageWithImage:(UIImage *)orignalImage ScalePercent:(CGFloat)percent
{
    if (orignalImage.size.width - 640 > 0) {
        CGSize imgSize = orignalImage.size;
        
        CGFloat fScale = 640 / orignalImage.size.width;
        
        imgSize.width = 640;
        imgSize.height = fScale * orignalImage.size.height;
        
        // 压缩图片质量
        UIImage *imageReduced = [self reduceImage:orignalImage percent:percent];
        
        // 压缩图片尺寸
        UIImage *imageCompress = [self imageWithImageSimple:imageReduced scaledToSize:imgSize];
        
        return imageCompress;
    }
    else {
        return orignalImage;
    }
}

// 压缩图片质量
+ (UIImage *)reduceImage:(UIImage *)image percent:(float)percent
{
    NSData *imageData = UIImageJPEGRepresentation(image, percent);
    UIImage *newImage = [UIImage imageWithData:imageData];
    return newImage;
}

//压缩图片尺寸
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}

#pragma mark - 判断字符串是不是NSNull类
+ (BOOL)isNSNullCharacter:(NSString *)string
{
    BOOL isResult = NO;
    
    if ([string isKindOfClass:[NSNull class]]) {
        isResult = YES;
    }
    else if ([string isKindOfClass:[NSString class]]) {
        if ([string isEqualToString:@"(null)"]) {
            isResult = YES;
        }
    }
    
    return isResult;
}

#pragma mark - 格式化日期字符串
+ (NSString *)getCurrentDateStringByFormat:(NSString *)format
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];

    NSString *strTime = [formatter stringFromDate:date];
    
    return strTime;
}

#pragma mark - date转string
+ (NSString *)getDateStringWithDate:(NSDate *)date Format:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    
    NSString *strTime = [formatter stringFromDate:date];
    
    return strTime;
}

#pragma mark - 字符串转时间
+ (NSDate *)dateWithDateString:(NSString *)dateString Format:(NSString *)format {
    
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    
    [dateFormat setDateFormat:format];//设定时间格式,这里可以设置成自己需要的格式
    
    NSDate *date =[dateFormat dateFromString:dateString];
    
    return date;
}

#pragma mark - 跳转到系统设置界面
+ (void)showSettingWithTitle:(NSString *)title
                     message:(NSString *)message
                     failure:(void (^)(void))failure {
    //提示开启定
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL  URLWithString:UIApplicationOpenSettingsURLString]];
    }];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (failure) {
            failure();
        }

    }];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    UIWindow *mainWindow = MAIN_WINDOW;
    UIViewController *vc = mainWindow.rootViewController;
    [vc presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 改变image的alpha值
+ (UIImage *)imageByApplyingAlpha:(CGFloat)alpha  image:(UIImage*)image
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);

    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);

    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);

    CGContextSetAlpha(ctx, alpha);

    CGContextDrawImage(ctx, area, image.CGImage);

    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return newImage;
}

#pragma  mark -获取UUID
+ (NSString *)getUUID {
    NSString *identifierForVendor = [[UIDevice currentDevice].identifierForVendor UUIDString];
    return identifierForVendor;
}

#pragma mark -获取4G下或者WIFI下的ip地址
+ (NSString *)get4GorWIFIAddress{
    
    int sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    
    if (sockfd < 0) return nil;
    
    NSMutableArray *ips = [NSMutableArray array];
    
    int BUFFERSIZE = 4096;
    
    struct ifconf ifc;
    
    char buffer[BUFFERSIZE], *ptr, lastname[IFNAMSIZ], *cptr;
    
    struct ifreq *ifr, ifrcopy;
    
    ifc.ifc_len = BUFFERSIZE;
    
    ifc.ifc_buf = buffer;
    
    if (ioctl(sockfd, SIOCGIFCONF, &ifc) >= 0){
        
        for (ptr = buffer; ptr < buffer + ifc.ifc_len; ){
            
            ifr = (struct ifreq *)ptr;
            
            int len = sizeof(struct sockaddr);
            
            if (ifr->ifr_addr.sa_len > len) {
                
                len = ifr->ifr_addr.sa_len;
            }
            
            ptr += sizeof(ifr->ifr_name) + len;
            
            if (ifr->ifr_addr.sa_family != AF_INET) continue;
            
            if ((cptr = (char *)strchr(ifr->ifr_name, ':')) != NULL) *cptr = 0;
            
            if (strncmp(lastname, ifr->ifr_name, IFNAMSIZ) == 0) continue;
            
            memcpy(lastname, ifr->ifr_name, IFNAMSIZ);
            
            ifrcopy = *ifr;
            
            ioctl(sockfd, SIOCGIFFLAGS, &ifrcopy);
            
            if ((ifrcopy.ifr_flags & IFF_UP) == 0) continue;
            
            NSString *ip = [NSString  stringWithFormat:@"%s", inet_ntoa(((struct sockaddr_in *)&ifr->ifr_addr)->sin_addr)];
            
            [ips addObject:ip];
            
        }
    }
    
    close(sockfd);
    
    NSString *deviceIP = @"";
    
    for (int i=0; i < ips.count; i++) {
        if (ips.count > 0) {
            deviceIP = [NSString stringWithFormat:@"%@",ips.lastObject];
        }
    }
    return deviceIP;
}


+ (NSString *)dataTojsonString:(id)object {
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (!jsonData) {
        NSLog(@"Got an error: %@", error);
    }
    else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

//获取不变的UUID
+ (NSString *)getPostUUID {
    //保存UUID
    NSError *uuidError;
    NSString * uuidString = [SFHFKeychainUtils getPasswordForUsername:@"UUID" andServiceName:ServiceName error:&uuidError];
    if (!uuidString) {
        BOOL saved = [SFHFKeychainUtils storeUsername:@"UUID" andPassword:[Tools getUUID] forServiceName:ServiceName updateExisting:YES error:&uuidError];
        uuidString = [SFHFKeychainUtils getPasswordForUsername:@"UUID" andServiceName:ServiceName error:&uuidError];
        if (!saved) {
            DDLogDebug(@"存储UUID失败");
            uuidString = [Tools getUUID];
        }
    }
    return uuidString;
}

//获取当前用户id
+ (NSString *)getCurrentID {
    BATPerson *model = PERSON_INFO;
    return [NSString stringWithFormat:@"%zd",model.Data.AccountID];
}


//生成不重复随机数
+(NSString *)randomArray
{
    //随机数从这里边产生
    NSMutableArray *startArray=[[NSMutableArray alloc] initWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z", nil];
    //随机数产生结果
    NSMutableArray *resultArray=[[NSMutableArray alloc] initWithCapacity:0];
    //随机数个数
    NSInteger m=34;
    for (int i=0; i<m; i++) {
        int t=arc4random()%startArray.count;
        resultArray[i]=startArray[t];
        startArray[t]=[startArray lastObject]; //为更好的乱序，故交换下位置
        [startArray removeLastObject];
    }
    NSMutableString *mutString = [NSMutableString string];
    for (NSString *subString in resultArray) {
        [mutString appendString:subString];
    }
    return mutString;
}

+ (int)getRandomNumber:(int)from to:(int)to {

    return (int)(from + (arc4random() % (to - from + 1)));

}


+ (UIImage *)findFace:(UIImage *)sourceImage
{
    UIImage * image = sourceImage;
    CIImage * coreImage = [[CIImage alloc] initWithImage:image];
    CIContext * context = [CIContext contextWithOptions:nil];
    CIDetector * detector = [CIDetector detectorOfType:@"CIDetectorTypeFace"context:context options:[NSDictionary dictionaryWithObjectsAndKeys:@"CIDetectorAccuracyHigh", @"CIDetectorAccuracy", nil]];
    NSArray * features = [detector featuresInImage:coreImage];


    for(CIFaceFeature* faceFeature in features)
    {
        CGRect origRect = faceFeature.bounds;
        CGRect biggerRect = CGRectInset(origRect
                                        ,origRect.size.width*-0.5
                                        ,origRect.size.height*-0.5);

        CGRect flipRect = biggerRect;
        flipRect.origin.y = image.size.height - (biggerRect.origin.y + biggerRect.size.height);
        flipRect.origin.y = flipRect.origin.y - 4;

        CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], flipRect);
        UIImage* faceImage = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);

        sourceImage = faceImage;
        break;
    }

    return sourceImage;
}

/**
 * 身份证号全校验
 */
+ (BOOL)verifyIDCardNumber:(NSString *)IDCardNumber
{
    IDCardNumber = [IDCardNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([IDCardNumber length] != 18)
    {
        return NO;
    }
    NSString *mmdd = @"(((0[13578]|1[02])(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)(0[1-9]|[12][0-9]|30))|(02(0[1-9]|[1][0-9]|2[0-8])))";
    NSString *leapMmdd = @"0229";
    NSString *year = @"(19|20)[0-9]{2}";
    NSString *leapYear = @"(19|20)(0[48]|[2468][048]|[13579][26])";
    NSString *yearMmdd = [NSString stringWithFormat:@"%@%@", year, mmdd];
    NSString *leapyearMmdd = [NSString stringWithFormat:@"%@%@", leapYear, leapMmdd];
    NSString *yyyyMmdd = [NSString stringWithFormat:@"((%@)|(%@)|(%@))", yearMmdd, leapyearMmdd, @"20000229"];
    NSString *area = @"(1[1-5]|2[1-3]|3[1-7]|4[1-6]|5[0-4]|6[1-5]|82|[7-9]1)[0-9]{4}";
    NSString *regex = [NSString stringWithFormat:@"%@%@%@", area, yyyyMmdd , @"[0-9]{3}[0-9Xx]"];
    
    NSPredicate *regexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];if (![regexTest evaluateWithObject:IDCardNumber]){    return NO;}int summary = ([IDCardNumber substringWithRange:NSMakeRange(0,1)].intValue + [IDCardNumber substringWithRange:NSMakeRange(10,1)].intValue) *7+ ([IDCardNumber substringWithRange:NSMakeRange(1,1)].intValue + [IDCardNumber substringWithRange:NSMakeRange(11,1)].intValue) *9+ ([IDCardNumber substringWithRange:NSMakeRange(2,1)].intValue + [IDCardNumber substringWithRange:NSMakeRange(12,1)].intValue) *10+ ([IDCardNumber substringWithRange:NSMakeRange(3,1)].intValue + [IDCardNumber substringWithRange:NSMakeRange(13,1)].intValue) *5+ ([IDCardNumber substringWithRange:NSMakeRange(4,1)].intValue + [IDCardNumber substringWithRange:NSMakeRange(14,1)].intValue) *8+ ([IDCardNumber substringWithRange:NSMakeRange(5,1)].intValue + [IDCardNumber substringWithRange:NSMakeRange(15,1)].intValue) *4+ ([IDCardNumber substringWithRange:NSMakeRange(6,1)].intValue + [IDCardNumber substringWithRange:NSMakeRange(16,1)].intValue) *2+ [IDCardNumber substringWithRange:NSMakeRange(7,1)].intValue *1 + [IDCardNumber substringWithRange:NSMakeRange(8,1)].intValue *6+ [IDCardNumber substringWithRange:NSMakeRange(9,1)].intValue *3;NSInteger remainder = summary % 11;NSString *checkBit = @"";NSString *checkString = @"10X98765432";checkBit = [checkString substringWithRange:NSMakeRange(remainder,1)];
     return [checkBit isEqualToString:[[IDCardNumber substringWithRange:NSMakeRange(17,1)] uppercaseString]];
}

- (float)filePath {

     NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];

    return [self folderSizeAtPath:cachPath];
}


- ( float ) folderSizeAtPath:( NSString *) folderPath{
    
    NSFileManager * manager = [ NSFileManager defaultManager ];
    
    if (![manager fileExistsAtPath :folderPath]) return 0 ;
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator ];
    
    NSString * fileName;
    
    long long folderSize = 0 ;
    
    while ((fileName = [childFilesEnumerator nextObject ]) != nil ){
        
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        
        folderSize += [ self fileSizeAtPath :fileAbsolutePath];
        
    }
    
    return folderSize/( 1024.0 * 1024.0 );
    
}

- ( long long ) fileSizeAtPath:( NSString *) filePath{
    
    NSFileManager * manager = [ NSFileManager defaultManager ];
    
    if ([manager fileExistsAtPath :filePath]){
        
        return [[manager attributesOfItemAtPath :filePath error : nil ] fileSize ];
    }
    
    return 0 ;
    
}

- (void)clearFile:(void (^)(void))success
{
    /**/
     [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
         success();
     }];
//    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
//    
//    NSArray * files = [[ NSFileManager defaultManager ] subpathsAtPath :cachPath];
//    
//    NSLog ( @"cachpath = %@" , cachPath);
//    
//    for ( NSString * p in files) {
//        
//        NSError * error = nil ;
//        
//        NSString * path = [cachPath stringByAppendingPathComponent :p];
//        
//        if ([[ NSFileManager defaultManager ] fileExistsAtPath :path]) {
//            
//            [[ NSFileManager defaultManager ] removeItemAtPath :path error :&error];
//            
//           
//            
//        }
//        
//    }
    
//    [ self performSelectorOnMainThread : @selector (clearCachSuccess) withObject : nil waitUntilDone : YES ];
    
}


+ (long)compareDate1:(NSDate *)date1 withDate2:(NSDate *)date2 type:(int)type
{
    NSTimeInterval  timeInterval = [date1 timeIntervalSinceDate:date2];
    timeInterval = -timeInterval;
    long result = 0;
    switch (type) {
        case 1:
            result = (long)timeInterval;    //秒
            break;
        case 2:
            result = (long)timeInterval/60;    //分
            break;
        case 3:
            result = (long)timeInterval/60/60;    //时
            break;
        case 4:
            result = (long)timeInterval/60/60/24;    //天
            break;
        case 5:
            result = (long)timeInterval/60/60/24/30;    //月
            break;
        case 6:
            result = (long)timeInterval/60/60/24/365;    //年
            break;
        default:
            break;
    }
    return result;
}

+ (NSString*)getWeekdayStringFromDate:(NSDate*)inputDate {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    return [weekdays objectAtIndex:theComponents.weekday];
}

//获取当前时间
+ (NSString *) getLocalDateWithTimeString:(BOOL) time
{
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:zone];
    if (time) {
        [formatter setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    }
    else
    {
        [formatter setDateFormat:@"yyyy-MM-dd"];
    }
    NSString *strTime = [formatter stringFromDate:date];
    return strTime;
}

//字符转时间戳
+ (NSTimeInterval)getIntervalFromString:(NSString *)str
{
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:zone];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date = [formatter dateFromString:str];
    NSTimeInterval interval= [date timeIntervalSince1970];
    return interval;
}

+ (UIStoryboard *) getStoryboardInstance
{
    NSString *storyboardName = [self getStoryboardName];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    return storyboard;
}

+ (NSString *) getStoryboardName
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        return @"Main";
    }
    else
    {
        return @"Main";
    }
}

//时间转字符
+ (NSString *) getStringFromDate:(NSDate*)date
{
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:zone];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strTime = [formatter stringFromDate:date];
    return strTime;
}

+ (UIColor *)getRandomColor
{
    return  [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
}

- (NSString*)weekdayStringFromDate:(NSDate*)inputDate {

    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];

    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shenzhen"];

    [calendar setTimeZone: timeZone];

    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;

    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];

    return [weekdays objectAtIndex:theComponents.weekday];
    
}

+ (NSString *)platform {
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPod7,1"])   return @"iPod Touch 6G";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,7"])   return @"iPad Mini 3G";
    if ([platform isEqualToString:@"iPad4,8"])   return @"iPad Mini 3G";
    if ([platform isEqualToString:@"iPad4,9"])   return @"iPad Mini 3G";
    if ([platform isEqualToString:@"iPad5,1"])   return @"iPad Mini 4G";
    if ([platform isEqualToString:@"iPad5,2"])   return @"iPad Mini 4G";
    if ([platform isEqualToString:@"iPad5,3"])   return @"iPad Air 2";
    if ([platform isEqualToString:@"iPad5,4"])   return @"iPad Air 2";
    if ([platform isEqualToString:@"iPad6,3"])   return @"iPad Pro (9.7 inch)";
    if ([platform isEqualToString:@"iPad6,4"])   return @"iPad Pro (9.7 inch)";
    if ([platform isEqualToString:@"iPad6,7"])   return @"iPad Pro (12.9 inch)";
    if ([platform isEqualToString:@"iPad6,8"])   return @"iPad Pro (12.9 inch)";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}

+(NSString *)getZZwithString:(NSString *)string{
    NSRegularExpression *regularExpretion=[NSRegularExpression regularExpressionWithPattern:@"<[^>]*>|\n"
                                                                                    options:0
                                                                                      error:nil];
    string=[regularExpretion stringByReplacingMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, string.length) withTemplate:@""];
    return string;
}



@end



