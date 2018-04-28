//
//  BATAlbumDetailCommentModel.m
//  HealthBAT_Pro
//
//  Created by four on 2017/6/15.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATAlbumDetailCommentModel.h"

@implementation BATAlbumDetailCommentModel

+ (NSDictionary *)objectClassInArray{
    return @{@"Data" : [BATAlbumDetailCommentData class]};
}

@end

@implementation BATAlbumDetailCommentData

+ (NSDictionary *)objectClassInArray{
    return @{@"SubCourseReplyList" : [BATAlbumDetailCommentData class]};
}

- (double)commentHeight
{
    if (_commentHeight == 0) {
        
        double contentWidth = SCREEN_WIDTH - 60.0f - 15.0f;
        
        float tempHeight = 0.0f;
        
        
        NSString *string = @"";
        if (self.ReplyAccountName.length > 0) {
            string = [NSString stringWithFormat:@"%@回复%@：%@",self.AccountName,self.ReplyAccountName,self.Body];
        } else {
            string = [NSString stringWithFormat:@"%@：%@",self.AccountName,self.Body];
        }
        
        tempHeight = [Tools calculateHeightWithText:string width:contentWidth - 16 font:[UIFont systemFontOfSize:11] lineHeight:15.0f];
        
        _commentHeight = (tempHeight >= 30 ? ceilf(tempHeight) + 4 : 30);
        
    }
    return _commentHeight;
}

- (double)commentTableViewHeight
{
    if (!_commentTableViewHeight) {
    
        double commentTableViewHeight = 0;
        
        if (self.SubCourseReplyList.count > 0) {
            
            for (BATAlbumDetailCommentData *commet in self.SubCourseReplyList) {
                commentTableViewHeight = commentTableViewHeight + commet.commentHeight;
            }
            
            _commentTableViewHeight = commentTableViewHeight;
        }
    }
    return _commentTableViewHeight;
}


@end



