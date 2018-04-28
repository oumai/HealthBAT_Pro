//
//  BATAlbumDetailRecommendVidoeModel.h
//  HealthBAT_Pro
//
//  Created by four on 2017/6/15.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BATAlbumDetailRecommendVidoeData;

@interface BATAlbumDetailRecommendVidoeModel : NSObject

@property (nonatomic, copy)     NSString *ResultMessage;
@property (nonatomic, assign)   NSInteger RecordsCount;
@property (nonatomic, assign)   NSInteger PageIndex;
@property (nonatomic, assign)   NSInteger PageSize;
@property (nonatomic, assign)   NSInteger ResultCode;

@property (nonatomic,strong)    NSMutableArray <BATAlbumDetailRecommendVidoeData *> *Data;
@end


@interface BATAlbumDetailRecommendVidoeData : NSObject

@property (nonatomic, copy)      NSString * ThemplateID;
@property (nonatomic, assign)   NSInteger ID;
@property (nonatomic, copy)    NSString *Topic;
@property (nonatomic, copy)     NSString *Description;
@property (nonatomic, copy)     NSString *AttachmentUrl;
@property (nonatomic, copy)     NSString *Poster;
@property (nonatomic, copy)     NSString *CoursePlayTime;

@end
