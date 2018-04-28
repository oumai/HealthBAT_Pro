//
//  BATEatDetailsModel.h
//  HealthBAT_Pro
//
//  Created by 黄帆 on 2017/12/14.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BATEatData;
@interface BATEatDetailsModel : NSObject
@property (nonatomic, copy) NSString *ResultMessage; //提示信息
@property (nonatomic, assign) NSInteger ResultCode; //返回码，0 代表无错误 -1代表有错误

@property (strong, nonatomic) NSArray <BATEatData *> *Data;
@end

@interface BATEatData : NSObject
@property (nonatomic, copy) NSString *ID; //数据主键ID
@property (nonatomic, assign) NSInteger AccountID; //用户ID
@property (nonatomic, copy) NSString *DataDate; //数据日期
@property (nonatomic, copy) NSString *FoodName; //食物名称
@property (nonatomic, assign) NSInteger Count; //食物份量
@property (nonatomic, copy) NSString *Calories; //每份食物含的卡路里数
@property (nonatomic, assign) NSInteger OrderNum; //顺序号
@property (nonatomic, copy) NSString *ImageUrl; //食物图片
@property (nonatomic, copy) NSString *CreateTime; //添加时间
@end
