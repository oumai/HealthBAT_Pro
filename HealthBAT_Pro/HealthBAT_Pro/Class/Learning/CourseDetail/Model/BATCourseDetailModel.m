//
//  BATCourseDetailModel.m
//  HealthBAT_Pro
//
//  Created by cjl on 2016/12/13.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATCourseDetailModel.h"
#import "BATCourseCommentModel.h"

@implementation BATCourseDetailModel

@end

@implementation BATCourseDetailData

+ (NSDictionary *)objectClassInArray{
    return @{@"ReplyList" : [BATCourseCommentData class]};
}

@end
