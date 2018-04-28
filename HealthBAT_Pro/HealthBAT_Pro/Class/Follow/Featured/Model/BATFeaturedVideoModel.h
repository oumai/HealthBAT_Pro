//
//  BATFeaturedVideoModel.h
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/6/13.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BATFeaturedVideoListModel;
@interface BATFeaturedVideoModel : NSObject
//PageIndex = 0,
//PageSize = 6,
//RecordsCount = 3,
//ResultCode = 0,
//ResultMessage = 操作成功
/** <#属性说明#> */
@property (nonatomic, assign) NSInteger  PageIndex;
@property (nonatomic, assign) NSInteger  RecordsCount;
@property (nonatomic,   copy) NSString   *ResultMessage;
@property (nonatomic, assign) NSInteger  ResultCode;
@property (nonatomic, assign) NSInteger  PageSize;
/** <#属性说明#> */
@property (nonatomic, assign) NSInteger  PagesCount;
@property (nonatomic, strong) NSArray<BATFeaturedVideoListModel *> *Data;

@end
@interface BATFeaturedVideoListModel : NSObject
/*
 "ID": 92,
 "ThemplateID": "",
 "Category": 4,
 "Topic": "有young瘦身舞 - 1.用最有型的方法，快速瘦小腹",
 "IsSelect": true,
 "AttachmentUrl": "http://video.jkbat.com/85dc9ca59a404ef7bef32de43aa2d948.mp4",
 "Poster": "http://upload.jkbat.com/Files/20170606/ymjquucy.brd.jpg",
 "CoursePlayTime": "08:50",
 "ReadingNum": 2,
 "Isalbums": false,
 "AlbumCount": 0
*/

/** <#属性描述#> */
@property (nonatomic, copy) NSString *ThemplateID;
/** <#属性描述#> */
@property (nonatomic, copy) NSString *ID;
/** <#属性描述#> */
@property (nonatomic, copy) NSString *Poster;
/** <#属性描述#> */
@property (nonatomic, assign) NSInteger Category;
/** <#属性描述#> */
@property (nonatomic, assign) BOOL IsSelect;
/** <#属性描述#> */
@property (nonatomic, copy) NSString *CoursePlayTime;
/** <#属性描述#> */
@property (nonatomic, copy) NSString *Topic;
/** <#属性描述#> */
@property (nonatomic, copy) NSString *AttachmentUrl;
/** 是否是专辑 */
@property (nonatomic, assign) BOOL  Isalbums;
/** 专辑节数 */
@property (nonatomic, assign) NSInteger  AlbumCount;
/** 播放量 */
@property (nonatomic, strong) NSString *ReadingNum;
@end
