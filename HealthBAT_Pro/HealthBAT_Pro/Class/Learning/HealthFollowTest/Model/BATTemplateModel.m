//
//  BATTemplateModel.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/2/27.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATTemplateModel.h"

@implementation BATTemplateModel

@end


@implementation BATTemplateData

+ (NSDictionary *)objectClassInArray{
    return @{@"Questionlst" : [BATQuestion class]};
}

@end

@implementation BATQuestion

+ (NSDictionary *)objectClassInArray{
    return @{@"QuestionItemLst" : [BATQuestionAnswerItem class]};
}

@end

@implementation BATQuestionAnswerItem

@end
