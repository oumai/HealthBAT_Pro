//
//  Singleton.h
//  WeiboS
//
//  Created by KM on 16/12/202016.
//  Copyright © 2016年 Skybrim. All rights reserved.
//

#ifndef Singleton_h
#define Singleton_h

#define singletonInterface(classname)              +(instancetype)shared##classname;

#if __has_feature(objc_arc)
#define singletonImplemention(class) \
static id instanse;\
+ (instancetype)allocWithZone:(struct _NSZone *)zone\
{\
static dispatch_once_t onesToken;\
dispatch_once(&onesToken, ^{\
instanse = [super allocWithZone:zone];\
});\
return instanse;\
}\
+ (instancetype)shared##class\
{\
static dispatch_once_t onestoken;\
dispatch_once(&onestoken, ^{\
instanse = [[self alloc] init];\
});\
return instanse;\
}\
- (id)copyWithZone:(NSZone *)zone\
{\
return instanse;\
};
#else
#define singletonImplemention(class)  \
static id instanse;\
+ (instancetype)allocWithZone:(struct _NSZone *)zone\
{\
static dispatch_once_t onesToken;\
dispatch_once(&onesToken, ^{\
instanse = [super allocWithZone:zone];\
});\
return instanse;\
}\
+ (instancetype)shared##class\
{\
static dispatch_once_t onestoken;\
dispatch_once(&onestoken, ^{\
instanse = [[self alloc] init];\
});\
return instanse;\
}\
a

#endif


#endif /* Singleton_h */
