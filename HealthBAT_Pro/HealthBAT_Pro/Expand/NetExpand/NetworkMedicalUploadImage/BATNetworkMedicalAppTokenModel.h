//
//  BATNetworkMedicalAppTokenModel.h
//  HealthBAT_Pro
//
//  Created by cjl on 2016/10/26.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TokenModel;
@interface BATNetworkMedicalAppTokenModel : NSObject

@property (nonatomic, strong) TokenModel *Data;

@property (nonatomic, copy) NSString *Msg;

@property (nonatomic, assign) NSInteger Status;

@property (nonatomic, assign) NSInteger Total;

@end


@interface TokenModel : NSObject

@property (nonatomic, copy) NSString *Token;

@end
