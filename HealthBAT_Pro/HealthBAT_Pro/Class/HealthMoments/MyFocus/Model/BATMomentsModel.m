//
//  MomentsModel.m
//  HealthBAT_Pro
//
//  Created by Skyrim on 16/7/17.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATMomentsModel.h"

@implementation BATMomentsModel


+ (NSDictionary *)objectClassInArray{
    return @{@"Data" : [BATMomentData class]};
}
@end


@implementation BATMomentData

+ (NSDictionary *)objectClassInArray{
    return @{@"Comments" : [BATComments class], @"MarkHelpfuls" : [BATMarkhelpfuls class], @"imgList" : [BATImglist class]};
}

- (double)collectionImageViewHeight
{
    if (!_collectionImageViewHeight) {
        
        if (_imgList.count == 1) {
            
            _collectionImageViewHeight = 120;
            
        } else {
            double contentWidth = SCREEN_WIDTH - 60.0f - 20.0f;
            
            double imageItemHeight = (contentWidth - 2 * 5) / 3;
            
            NSInteger row = 0;
            
            if (_imgList.count % 3 == 0) {
                row = _imgList.count / 3;
            } else {
                row = _imgList.count / 3 + 1;
            }
            _collectionImageViewHeight = row * imageItemHeight + ((row - 1) * 5);
        }
        
    }
    return _collectionImageViewHeight;
}

- (double)commentTableViewHeight
{
//    if (!_commentTableViewHeight) {
    
        double commentTableViewHeight = 0;
        
        if (_Comments.count > 0) {
            
            for (BATComments *commet in _Comments) {
                commentTableViewHeight = commentTableViewHeight + commet.commentHeight;
            }
            
            _commentTableViewHeight = commentTableViewHeight;
        }
        
//    }
    return _commentTableViewHeight;
}

@end


@implementation BATComments

- (double)commentHeight
{
    if (_commentHeight == 0) {
        
        double contentWidth = SCREEN_WIDTH - 60.0f - 20.0f;
        float tempHeight = [Tools calculateHeightWithText:[NSString stringWithFormat:@"%@：%@",self.UserName,self.CommentContent] width:contentWidth - 16 font:[UIFont systemFontOfSize:12] lineHeight:15.0f];
        
        _commentHeight = (tempHeight >= 30 ? ceilf(tempHeight) + 4 : 30);
        
    }
    return _commentHeight;
}

@end


@implementation BATMarkhelpfuls

@end


@implementation BATImglist

@end


