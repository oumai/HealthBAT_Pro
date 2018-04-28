//
//  BATTopicSearchModel.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/3/14.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATTopicSearchModel.h"

@implementation BATTopicSearchModel

+ (NSDictionary *)objectClassInArray{
    return @{@"resultData" : [TopicResultData class]};
}

@end

@implementation TopicResultData



@end

@implementation TopicSearchBody

+ (NSDictionary *)objectClassInArray{
    return @{@"content" : [TopicSearchContent class]};
}

@end

@implementation TopicSearchContent



@end
