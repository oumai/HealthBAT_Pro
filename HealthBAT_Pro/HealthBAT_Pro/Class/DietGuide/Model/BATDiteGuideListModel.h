//
//  BATDiteGuideListModel.h
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/11/2.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BATDiteGuideListModel : NSObject
/*
 PicToCalories = 21.2,
 UserName = Namewe,
 UserPhoto = http://upload.jkbat.com/Files/20170113/jinipw4z.2nf.jpg,
 EatSuggestId = 2,
 CreatedTime = 2017-11-07 15:33:40,
 FoodPic = http://upload.jkbat.com/20160922/2wweg3hk.rvn.png,
 AccountID = 2408,
 FoodName = 全卖面包,
 FoodLable = 早安辰光,
 ID = bb40f0a246874f939887599e2c471274,
 SetStarNum = 1
 */

/** ID */
@property (nonatomic, strong) NSString *ID;
/** 发布者 ID */
@property (nonatomic, assign) NSInteger AccountID;
/** 食物名称 */
@property (nonatomic, strong) NSString *FoodName;
/** 食物名称 */
@property (nonatomic, strong) NSString *FoodLable;
/** 发布者名称 */
@property (nonatomic, strong) NSString *UserName;
/** 照片地址 */
@property (nonatomic, strong) NSString *FoodPic;
/** 点赞数 */
@property (nonatomic, assign) NSInteger SetStarNum;
/** 点赞数 */
@property (nonatomic, strong) NSString *PicToCalories;
/** 点赞数 */
@property (nonatomic, strong) NSString *EatSuggestId;

/** 用户头像 */
@property (nonatomic, strong) NSString *UserPhoto;
/** 发布时间 */
@property (nonatomic, strong) NSString *CreatedTime;
/** 是否点赞 */
@property (nonatomic, assign) BOOL IsSetStar;
@end
