//
//  BATNetWorkMedicalImageModel.h
//  HealthBAT_Pro
//
//  Created by cjl on 2016/10/26.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NMImageModel;
@interface BATNetWorkMedicalImageModel : NSObject

@property (nonatomic, strong) NMImageModel *Data;

@property (nonatomic, copy) NSString *Msg;

@property (nonatomic, assign) NSInteger Status;

@property (nonatomic, assign) NSInteger Total;

@end


@interface NMImageModel : NSObject

@property (nonatomic, copy) NSString *FileName;

@property (nonatomic, assign) NSInteger FileSize;

@property (nonatomic, copy) NSString *MD5;

@property (nonatomic, copy) NSString *UrlPrefix;

@end
