//
//  BATTopicReplyModel.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/3/20.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATTopicRecordModel.h"

@implementation BATTopicRecordModel

+ (NSDictionary *)objectClassInArray{
    return @{@"Data" : [TopicReplyData class]};
}

@end

@implementation TopicReplyData

+ (NSDictionary *)objectClassInArray{
    return @{@"secondReplyList" : [secondReplyData class]};
}



- (double)commentTableViewHeight
{
    if (!_commentTableViewHeight) {
        
        double commentTableViewHeight = 0;
        
        if (self.secondReplyList.count > 0) {
            
            for (secondReplyData *commet in self.secondReplyList) {
                commentTableViewHeight = commentTableViewHeight + commet.commentHeight;
            }
            
            _commentTableViewHeight = commentTableViewHeight;
        }
        
    }
    return _commentTableViewHeight;
}




@end

@implementation secondReplyData

- (double)commentHeight
{
    if (_commentHeight == 0) {
        
        double contentWidth = SCREEN_WIDTH - 60.0f - 15.0f;
        
        float tempHeight = 0.0f;
        
        
        NSString *string = @"";
        
        string = [NSString stringWithFormat:@"%@：%@",self.UserName,self.ReplyContent];
        
        
        tempHeight = [Tools calculateHeightWithText:string width:contentWidth - 16 font:[UIFont systemFontOfSize:11] lineHeight:15.0f];
        
        _commentHeight = (tempHeight >= 30 ? ceilf(tempHeight) + 4 : 30);
        
    }
    return _commentHeight;
}


@end

