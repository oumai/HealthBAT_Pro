//
//  BATHealthEvalutionServce.h
//  HealthBAT_Pro
//
//  Created by 黄帆 on 2017/11/8.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^Success)(id);
typedef void(^Fail)(id);
@interface BATHealthEvalutionServce : NSObject

- (void)getHealthEvalutionInfoWithParamters:(NSDictionary *)dic success:(Success)sucess failure:(Fail)failure;

//获取饮食详情 get
- (void)getHealthEatDetailsInfoWithParamters:(NSDictionary *)dic success:(Success)sucess failure:(Fail)failure;

//更新健康数据 post
- (void)UpdateHealthInfoWithParamters:(NSDictionary *)dic success:(Success)sucess failure:(Fail)failure;

//获取健康数据 get
- (void)getHealthInfoWithParamters:(NSDictionary *)dic success:(Success)sucess failure:(Fail)failure;

//分词查询食物 get精确的查询
- (void)getSearchEatInfoWithParamters:(NSDictionary *)dic success:(Success)sucess failure:(Fail)failure;
//分词查询食物 get 模糊的查询
- (void)MoHugetSearchEatInfoWithParamters:(NSDictionary *)dic success:(Success)sucess failure:(Fail)failure;

//健康评估 get
- (void)HealthyAssessWithParamters:(NSDictionary *)dic success:(Success)sucess failure:(Fail)failure;
@end
