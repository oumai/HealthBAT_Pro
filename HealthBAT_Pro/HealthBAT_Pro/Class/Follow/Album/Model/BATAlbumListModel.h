//
//  BATAlbumListModel.h
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/6/13.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BATAlbumListModel : NSObject
/*
 "ID":"5937b173e845712e3c4f3f3d",
 "VideoID":0,
 "Title":"小李天天说健康",
 "Poster":"http://upload.jkbat.com/Files/20170616/vjgjwn2f.k1h.JPG",
 "IsAlbum":true,
 "CreatedTime":"2017-06-07 16:01:34"
 */

/** 专辑ID */
@property (nonatomic, copy) NSString *ID;
/** 视频ID */
@property (nonatomic, copy) NSString *VideoID;
/** <#属性描述#> */
@property (nonatomic, copy) NSString *Title;
/** <#属性描述#> */
@property (nonatomic, copy) NSString *Poster;
/** <#属性描述#> */
@property (nonatomic, assign) BOOL IsAlbum;
/** <#属性描述#> */
@property (nonatomic, copy) NSString *CreatedTime;
/** <#属性描述#> */

@end
