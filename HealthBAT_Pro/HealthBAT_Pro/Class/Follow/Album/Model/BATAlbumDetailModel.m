//
//  BATAlbumDetailModel.m
//  HealthBAT_Pro
//
//  Created by four on 2017/6/14.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATAlbumDetailModel.h"

@implementation BATAlbumDetailModel

@end

@implementation BATAlbumDetailData

+ (NSDictionary *)objectClassInArray{
    return @{@"ProjectVideoList" : [BATAlbumProjectVideoData class],@"ReplyList" : [BATAlbumCommentData class]};
}

@end

@implementation BATAlbumProjectVideoData
MJExtensionCodingImplementation
@end

@implementation BATAlbumCommentData
MJExtensionCodingImplementation
@end

