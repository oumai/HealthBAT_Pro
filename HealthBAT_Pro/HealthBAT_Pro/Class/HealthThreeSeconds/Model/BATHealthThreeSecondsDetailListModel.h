//
//  BATHealthThreeSecondsDetailListModel.h
//  HealthBAT_Pro
//
//  Created by KM_MAC on 2017/12/15.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BATHealthThreeSecondsDetailListModel : NSObject
//"ID": "201712141440302324399506",
//"AccountID": 2842,
//"DataDate": "2017-12-13 00:00:00",
//"FoodName": "叉烧饭",
//"Count": 1,
//"Calories": "516.60",
//"OrderNum": 1,
//"ImageUrl": "http://upload.jkbat.com/Files/20170425/xk01pn1h.w32.jpg",
//"CreateTime": "0001-01-01 00:00:00"

@property (nonatomic, strong)NSString *ID;
@property (nonatomic, strong)NSString *AccountID;
@property (nonatomic, strong)NSString *DataDate;
@property (nonatomic, strong)NSString *FoodName;
@property (nonatomic, strong)NSString *Count;
@property (nonatomic, strong)NSString *Calories;
@property (nonatomic, strong)NSString *OrderNum;
@property (nonatomic, strong)NSString *ImageUrl;
@property (nonatomic, strong)NSString *CreateTime;
@end
