//
//  BATRelateWordModel.h
//  HealthBAT_Pro
//
//  Created by KM on 16/8/262016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface BATRelateWordModel : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, copy) NSString *resultCode;

@property (nonatomic, strong) NSArray<NSString *> *resultData;

@end
