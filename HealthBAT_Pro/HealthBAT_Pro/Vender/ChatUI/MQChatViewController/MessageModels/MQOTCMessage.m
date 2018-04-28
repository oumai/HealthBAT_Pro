//
//  MQOTCMessage.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/12/14.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "MQOTCMessage.h"

@implementation MQOTCMessage

- (instancetype)initWithContent:(NSDictionary *)content {
    if (self = [super init]) {
        
        self.RecipeImgUrl = [content objectForKey:@"RecipeImgUrl"];
        self.OPDRegisterID = [content objectForKey:@"OPDRegisterID"];
        self.RecipeFileID = [content objectForKey:@"RecipeFileID"];
        self.RecipeNo = [content objectForKey:@"RecipeNo"];
        self.RecipeName = [content objectForKey:@"RecipeName"];
        self.Amount = [content objectForKey:@"Amount"];
        self.ReplacePrice = [content objectForKey:@"ReplacePrice"];
        self.ReplaceDose = [[content objectForKey:@"ReplaceDose"] integerValue];
        self.TCMQuantity = [[content objectForKey:@"TCMQuantity"] integerValue];
    }
    return self;
}

@end
