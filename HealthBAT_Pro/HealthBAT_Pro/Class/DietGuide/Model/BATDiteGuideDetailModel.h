//
//  BATDiteGuideDetailModel.h
//  HealthBAT_Pro
//
//  Created by Carbon on 2017/11/7.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

//typedef NS_ENUM(NSInteger ,DiteGuideEnergyStatus){
//    DiteGuideEnergyStatusUnknown = -1,
//    DiteGuideEnergyStatusRecommend = 0,
//    DiteGuideEnergyStatusSuit = 1,
//    DiteGuideEnergyStatusHigh = 2
//};

@interface BATDiteGuideDetailEatSuggestModel : NSObject
@property (nonatomic ,assign) NSInteger             ID;
@property (nonatomic ,copy)   NSString              *HeatLevel;//": "推荐",
@property (nonatomic ,copy)   NSString              *Suggest;//": "绝大部分蔬菜水果、粗粮杂粮、奶制品以及低脂肪肉类都是推荐吃的食物",
@property (nonatomic ,assign) NSInteger             GenerationMealId;//": 1,                             --代餐表关联ID
@property (nonatomic ,assign) NSInteger             SportSuggestId;//": 1                                --运动建议表关联ID
@end

@interface BATDiteGuideDetailGenerationMealModel : NSObject
@property (nonatomic ,assign) NSInteger             ID;//": 14240,
@property (nonatomic ,copy)   NSString              *RelationId;//": 2,                                        --关联饮食建议表中的ID
@property (nonatomic ,copy)   NSString              *PRODUCT_NAME;//": "司邦适蛋白私密护理液",                 --产品名称
@property (nonatomic ,assign) NSInteger             SALE_UNIT_PRICE;//": 22.4,                                --销售价
@property (nonatomic ,assign) NSInteger             MARKET_PRICE;//": 32,                                     --市场价
@property (nonatomic ,copy)   NSString              *SKU_ID;//": "39330",                                      --电商商品ID
@property (nonatomic ,copy)   NSString              *SKU_IMG_PATH;//": "/upload/product/37532/39330/20150428131218406379_39330_3.jpg"   --商品图片
@end

@interface BATDiteGuideDetailSportSuggestModel : NSObject
@property (nonatomic ,assign) NSInteger             ID;//": 1,
@property (nonatomic ,copy)   NSString              *SuggestContent;//": "保持每天30分钟运动量，坚持一星期3次有氧运动"
@end

@interface BATDiteGuideDetailModel : NSObject
@property (nonatomic ,copy)   NSString              *ID;//": "24319dae651345838ae13f42241e9ee9",
@property (nonatomic ,assign) NSInteger             AccountID;//": 2446,
@property (nonatomic ,copy)   NSString              *UserName;//": "18565819799",                        --用户名
@property (nonatomic ,copy)   NSString              *UserPhoto;//": "/Uploads/assets/portrait_default.png",--头像
@property (nonatomic ,assign) NSInteger             EatSuggestId;//": 1,                                  --饮食指南关联ID
@property (nonatomic ,copy)   NSString              *CreatedTime;//": "2017-11-06 15:33:40",               --指南发布时间
@property (nonatomic ,copy)   NSString              *FoodName;//": "土豆炖牛肉",                            --食物名称
@property (nonatomic ,copy)   NSString              *FoodPic;//": "http://upload.jkbat.com/20160922/gnvu032c.u02.png",--食物图片
@property (nonatomic ,copy)   NSString              *FoodLable;//": "元气早餐",                            --食物标签
@property (nonatomic ,copy)   NSString              *PicToCalories;//": "310.9",                           --图片转卡路里
@property (nonatomic ,assign) NSInteger             SetStarNum;//                                       --点赞次数
@property (nonatomic, assign) BOOL                  IsSetStar;//
@property (nonatomic ,strong) BATDiteGuideDetailEatSuggestModel     *EatSuggest;
@property (nonatomic ,strong) BATDiteGuideDetailGenerationMealModel *GenerationMeal;
@property (nonatomic ,strong) BATDiteGuideDetailSportSuggestModel   *SportSuggest;
@end
