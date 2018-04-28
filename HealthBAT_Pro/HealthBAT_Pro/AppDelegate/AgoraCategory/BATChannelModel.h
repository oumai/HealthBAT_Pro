//
//  BATChannelModel.h
//  HealthBAT_Doctor
//
//  Created by cjl on 2017/5/15.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BATChannelModel : NSObject

@property (nonatomic, copy) NSString  *Data;

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, copy) NSString  *ResultMessage;

@end
