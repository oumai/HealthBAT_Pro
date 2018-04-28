//
//  BATHomeNewMallTableViewCell.h
//  HealthBAT_Pro
//
//  Created by KM on 17/5/92017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATHomeHealthMallCommonView.h"
#import "BATHomeTodayOfferGoodView.h"
#import "BATHomeTodayOfferMoreView.h"

@interface BATHomeNewMallTableViewCell : UITableViewCell


/**
 今日特价商品
 */
//@property (nonatomic,strong) BATHomeTodayOfferGoodView *todayOfferGoodView;
//@property (nonatomic,copy) void(^todayOfferGoodBlock)(void);

/**
 今日特价更多
 */
//@property (nonatomic,strong) BATHomeTodayOfferMoreView *todayOfferMoreView;
//@property (nonatomic,copy) void(^todayOfferMoreBlock)(void);

/**
 大药房
 */
@property (nonatomic,strong) BATHomeHealthMallCommonView *bigPharmacy;
@property (nonatomic,copy) void(^bigPharmacyBlock)(void);

/**
 健康超市
 */
@property (nonatomic,strong) BATHomeHealthMallCommonView *healthMall;
@property (nonatomic,copy) void(^healthMallBlock)(void);

/**
 医疗器械
 */
@property (nonatomic,strong) BATHomeHealthMallCommonView *medicalInstrumentsView;
@property (nonatomic,copy) void(^medicalInstrumentsBlock)(void);

/**
 营养保健
 */
@property (nonatomic,strong) BATHomeHealthMallCommonView *healthcareView;
@property (nonatomic,copy) void(^healthcareBlock)(void);

/**
 按方抓药
 */
@property (nonatomic,strong) BATHomeHealthMallCommonView *anfangzhuayaoView;
@property (nonatomic,copy) void(^anfangzhuayaoBlock)(void);

/**
 膳食汉方
 */
@property (nonatomic,strong) BATHomeHealthMallCommonView *shanshihanfangView;
@property (nonatomic,copy) void(^shanshihanfangBlock)(void);

/**
 9.9特卖
 */
@property (nonatomic,strong) BATHomeHealthMallCommonView *ninedotnineView;
@property (nonatomic,copy) void(^ninedotnineBlock)(void);

@end
