//
//  BATInvitationModel.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/3/20.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATInvitationModel.h"

@implementation BATInvitationModel

@end

@implementation InvitationData

+ (NSDictionary *)objectClassInArray{
    return @{@"ImageList" : [InvitationDataImage class]};
}

- (double)collectionImageViewHeight
{
    if (!_collectionImageViewHeight) {
        
        if (_ImageList.count == 1) {
            
            _collectionImageViewHeight = 120;
            
        } else {
            double contentWidth = SCREEN_WIDTH - 60.0f - 20.0f;
            
            double imageItemHeight = (contentWidth - 2 * 5) / 3;
            
            NSInteger row = 0;
            
            if (_ImageList.count % 3 == 0) {
                row = _ImageList.count / 3;
            } else {
                row = _ImageList.count / 3 + 1;
            }
            _collectionImageViewHeight = row * imageItemHeight + ((row - 1) * 5);
        }
        
    }
    return _collectionImageViewHeight;
}

@end

@implementation InvitationDataImage



@end
