//
//  BATTrainStudioCommentModel.m
//  HealthBAT_Pro
//
//  Created by four on 17/4/5.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATTrainStudioCommentModel.h"

@implementation BATTrainStudioCommentModel
+ (NSDictionary *)objectClassInArray{
    return @{@"Data" : [BATTrainStudioCourseCommentData class]};
}

@end

@implementation BATTrainStudioCourseCommentData

+ (NSDictionary *)objectClassInArray{
    return @{@"SubCourseReplyList" : [BATTrainStudioCourseCommentData class]};
}

@end
