//
//  BATProgramListAddedModel.h
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/6/9.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BATProgramListModel : NSObject

//"ID":1,
//"Theme":"15天养好肾",
//"TemplateImage":"http://upload.jkbat.com/Files/20170616/l4nsxfkn.z0m.JPG",
//"Remark":"15天养好肾",
//"IsFlag":false,
//"JoinCount":11,
//"ProgrammeLst":Array[3],
//"ClockInCount":1,
//"ExpectClockInCount":15,
//"ComplateTime":"07月01日",
//"IsSecondDayOpenclock":false

/** <#属性描述#> */
@property (nonatomic, copy) NSString *TemplateID;

/** <#属性说明#> */
@property (nonatomic, assign) BOOL  IsSecondDayOpenclock;
/** <#属性描述#> */
@property (nonatomic, assign) NSInteger ExpectClockInCount;
/** <#属性描述#> */
@property (nonatomic, assign) NSInteger ClockInCount;
/** <#属性说明#> */
@property (nonatomic, assign) NSInteger ID;
/** <#属性描述#> */
@property (nonatomic, copy) NSString *Remark;
/** <#属性描述#> */
@property (nonatomic, copy) NSString *Theme;
/** <#属性描述#> */
@property (nonatomic, assign) BOOL IsFlag;
/** <#属性描述#> */
@property (nonatomic, copy) NSString *ComplateTime;
/** <#属性描述#> */
@property (nonatomic, copy) NSString *TemplateImage;
/** <#属性描述#> */
@property (nonatomic, copy) NSString *JoinCount;

@property (nonatomic,copy) NSString *CreatedTime;

@end
