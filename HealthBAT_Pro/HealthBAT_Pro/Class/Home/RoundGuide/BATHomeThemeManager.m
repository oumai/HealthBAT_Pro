//
//  BATHomeThemeManager.m
//  HealthBAT_Pro
//
//  Created by Carbon on 2017/11/28.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHomeThemeManager.h"
#import "BATPerson.h"

@interface BATHomeThemeManager ()
@property (nonatomic ,strong) BATPerson     *personInfo;
@property (nonatomic ,assign) BOOL          loginStatus;
@end

@implementation BATHomeThemeManager
+ (instancetype)shareInstance {
    static BATHomeThemeManager  *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[BATHomeThemeManager alloc] init];
    });
    return shareInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        //正常退出登录
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(batHomeThemeChangeNotification:) name:@"LOGINOUT" object:nil];
        //被挤掉退出登录
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(batHomeThemeChangeNotification:) name:@"APPLICATION_LOGOUT" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(batHomeThemeChangeNotification:) name:BATuserOnForceOfflineNotification object:nil];
        //登陆
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(batHomeThemeChangeNotification:) name:BATLoginSuccessGetUserInfoSucessNotification object:nil];
        _personInfo = PERSON_INFO;
        _loginStatus = LOGIN_STATION;
    }
    return self;
}

- (void)homeThemeInitConfig {
    NSString *defaultThemePath = [[NSBundle mainBundle] pathForResource:@"DefaultTheme" ofType:@"json"];
    NSString *maleBlueThemePath = [[NSBundle mainBundle] pathForResource:@"MaleBlueTheme" ofType:@"json"];
    NSString *femalePinkThemePath = [[NSBundle mainBundle] pathForResource:@"FemalePinkTheme" ofType:@"json"];
    NSString *femaleCyanThemePath = [[NSBundle mainBundle] pathForResource:@"FemaleCyanTheme" ofType:@"json"];
    NSString *defaultThemeJson = [NSString stringWithContentsOfFile:defaultThemePath encoding:NSUTF8StringEncoding error:nil];
    NSString *maleBlueThemeJson = [NSString stringWithContentsOfFile:maleBlueThemePath encoding:NSUTF8StringEncoding error:nil];
    NSString *femalePinkThemeJson = [NSString stringWithContentsOfFile:femalePinkThemePath encoding:NSUTF8StringEncoding error:nil];
    NSString *femaleCyanThemeJson = [NSString stringWithContentsOfFile:femaleCyanThemePath encoding:NSUTF8StringEncoding error:nil];
    
    [LEETheme addThemeConfigWithJson:defaultThemeJson Tag:BATDefaultTheme ResourcesPath:nil];
    [LEETheme addThemeConfigWithJson:maleBlueThemeJson Tag:BATMaleBlueTheme ResourcesPath:nil];
    [LEETheme addThemeConfigWithJson:femalePinkThemeJson Tag:BATFemalePinkTheme ResourcesPath:nil];
    [LEETheme addThemeConfigWithJson:femaleCyanThemeJson Tag:BATFemaleCyanTheme ResourcesPath:nil];
    [LEETheme defaultTheme:[self setupHomeTheme]];
}

- (NSString *)setupHomeTheme {
    if (self.loginStatus && self.personInfo) {
        if ([self.personInfo.Data.Sex isEqualToString:@"1"]) {//男性
            if (self.personInfo.Data.Age < 35) {
                return BATDefaultTheme;
            } else {
                return BATMaleBlueTheme;
            }
        } else {//女性
            if (self.personInfo.Data.Age < 35) {
                return BATFemalePinkTheme;
            } else {
                return BATFemaleCyanTheme;
            }
        }
    } else {
        return BATDefaultTheme;
    }
}

- (void)batHomeThemeChangeNotification:(NSNotification *)notify {
    if ([notify.name isEqualToString:@"LOGINOUT"]) {
        [LEETheme startTheme:BATDefaultTheme];
    } else if ([notify.name isEqualToString:BATuserOnForceOfflineNotification] || [notify.name isEqualToString:@"APPLICATION_LOGOUT"]) {
        [LEETheme startTheme:BATDefaultTheme];
    } else if ([notify.name isEqualToString:BATLoginSuccessGetUserInfoSucessNotification]) {
        self.personInfo = (BATPerson *)notify.object;
        self.loginStatus = LOGIN_STATION;
        [LEETheme startTheme:[self setupHomeTheme]];
    } else {};
}

- (BATHomeThemeType)getCurrentThemeType {
    if ([[LEETheme currentThemeTag] isEqualToString:BATDefaultTheme]) {
        return BATHomeThemeTypeDefault;
    } else if ([[LEETheme currentThemeTag] isEqualToString:BATMaleBlueTheme]) {
        return BATHomeThemeTypeMaleBlue;
    } else if ([[LEETheme currentThemeTag] isEqualToString:BATFemalePinkTheme]) {
        return BATHomeThemeTypeFemalePink;
    } else if ([[LEETheme currentThemeTag] isEqualToString:BATFemaleCyanTheme]) {
        return BATHomeThemeTypeFemaleCyan;
    } else {
        return BATHomeThemeTypeUnkonwn;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LOGINOUT" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"APPLICATION_LOGOUT" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BATuserOnForceOfflineNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BATLoginSuccessGetUserInfoSucessNotification object:nil];
}


@end
