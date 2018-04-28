//
//  BATDiteGuideMyPhotoModel.h
//  HealthBAT_Pro
//
//  Created by Carbon on 2017/11/7.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BATDiteGuideMyPhotoDataModel : NSObject
@property (nonatomic ,copy)     NSString    *ID;//": "5a00325432a20226f885969c",
@property (nonatomic ,assign)   NSInteger   AccountID;//": 2422,
@property (nonatomic ,copy)     NSString    *FoodName;//": "野山椒牛肉",              --饮食名称
@property (nonatomic ,copy)     NSString    *FoodPic;//": "http://upload.jkbat.com/20160922/uylxcxky.flj.png", --食物图片
@property (nonatomic ,copy)     NSString    *FoodLable;//": "下午茶,私房菜",               --标签
@property (nonatomic ,assign)   NSInteger   SetStarNum;//": 0,
@property (nonatomic ,copy)     NSString    *PicToCalories;//": "58.1,65.2",
@property (nonatomic ,copy)     NSString    *UserName;//": "金大爷",                        --用户名
@property (nonatomic ,copy)     NSString    *UserPhoto;//": "/Uploads/assets/portrait_default.png",  --头像
@property (nonatomic ,assign)   NSInteger   EatSuggestId;//": 3,
@property (nonatomic ,copy)     NSString    *CreatedTime;//": "2017-11-06 17:58:44"
@end

@interface BATDiteGuideMyPhotoModel : NSObject
@property (nonatomic ,copy)     NSArray<BATDiteGuideMyPhotoDataModel *> *Data;
@property (nonatomic ,assign)   NSInteger                               RecordsCount;//": 2,
@property (nonatomic ,assign)   NSInteger                               PageIndex;//": 0,
@property (nonatomic ,assign)   NSInteger                               PageSize;//": 10,
@property (nonatomic ,assign)   NSInteger                               ResultCode;//": 0,
@property (nonatomic ,copy)     NSString                                *ResultMessage;//": "操作成功"
@end
