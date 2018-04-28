//
//  BATTrainStudioCategoryModel.h
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/7/17.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BATTrainStudioCategoryModel : NSObject
//"Code":0,
//"Text":"养老护理",
//"Name":"OldAgeNursing"
/** <#属性描述#> */
@property (nonatomic, strong) NSString *Text;
/** <#属性说明#> */
@property (nonatomic, assign) NSInteger  Code;
/** <#属性描述#> */
@property (nonatomic, strong) NSString *Name;
@end
