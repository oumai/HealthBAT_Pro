//
//  BATPersonDetailModel.h
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/5/16.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BATPersonDetailModel : NSObject
//ResultMessage = 操作成功,
//ResultCode = 0,
//Data = {
//    IsShow = 0,
//    TopicNum = 3,
//    FollowNum = 4,
//    Sex = 1,
//    PostNum = 0,
//    IsUserFollow = 0,
//    AccountID = 3395,
//    UserName = 我了个去,
//    PhotoPath = http://upload.jkbat.com/20160922/2wweg3hk.rvn.png,
//    FansNum = 1
//}
/** <#属性说明#> */
@property (nonatomic, assign) NSInteger  FollowNum;
/** <#属性说明#> */
@property (nonatomic, assign) BOOL  isShow;

/** <#属性说明#> */
@property (nonatomic, assign) NSInteger  IsUserFollow;

/** <#属性说明#> */
@property (nonatomic, assign) NSInteger PostNum;

/** <#属性说明#> */
@property (nonatomic, strong) NSString  *AccountID;

/** <#属性说明#> */
@property (nonatomic, strong) NSString  *UserName;

/** <#属性说明#> */
@property (nonatomic, copy) NSString  *PhotoPath;

/** <#属性说明#> */
@property (nonatomic, assign) NSInteger  FansNum;

/** <#属性说明#> */
@property (nonatomic, assign) NSInteger  TopicNum;

/** <#属性说明#> */
@property (nonatomic, assign) BOOL  Sex;



@end

