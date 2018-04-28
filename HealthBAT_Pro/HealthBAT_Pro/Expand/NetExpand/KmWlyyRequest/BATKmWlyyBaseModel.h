//
//  BATKmWlyyBaseModel.h
//  HealthBAT_Pro
//
//  Created by mac on 2017/12/13.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface BATKmWlyyBaseModel : NSObject

@property (nonatomic, copy  ) NSString  *Msg;

@property (nonatomic, assign) NSInteger Total;

@property (nonatomic, assign) NSInteger Status;

@property (nonatomic, copy  ) NSString  *Result;

@end
