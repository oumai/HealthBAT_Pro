  //
//  BATHealthEvalutionServce.m
//  HealthBAT_Pro
//
//  Created by 黄帆 on 2017/11/8.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHealthEvalutionServce.h"
#import "BATHealthEvalutionUrls.h"
#import "BATHealthEvalutionModel.h"
#import "BATEatDetailsModel.h"
#import "BATUpdateHealthInfoModel.h"
#import "BATGetHealthInfoModel.h"
#import "BATSearchFoodModel.h"
#import "BATHealthyAssessModel.h"
@interface BATHealthEvalutionServce()
@property (strong, nonatomic) BATHealthEvalutionModel *EvalutionModel;

@property (strong, nonatomic) BATEatDetailsModel *eatDetailsModel;

@property (strong, nonatomic) BATUpdateHealthInfoModel *updatehealthInfoModel;

@property (strong, nonatomic) BATGetHealthInfoModel *getHealthInfoModel;


@property (strong, nonatomic) BATSearchFoodModel *foodlistModel;

@property (strong, nonatomic) BATHealthyAssessModel *assessModel;
@end
@implementation BATHealthEvalutionServce


- (void)getHealthEvalutionInfoWithParamters:(NSDictionary *)dic success:(Success)sucess failure:(Fail)failure;
{
    [HTTPTool requestWithURLString:BATHealthEvalutionUrl parameters:dic type:kGET success:^(id responseObject) {
        
        self.EvalutionModel = [BATHealthEvalutionModel mj_objectWithKeyValues:responseObject];
        
        sucess(self.EvalutionModel);
    
    } failure:^(NSError *error) {
        
        failure(error);
        
    }];
    
    
}

//获取饮食详情 get
- (void)getHealthEatDetailsInfoWithParamters:(NSDictionary *)dic success:(Success)sucess failure:(Fail)failure; {
    
    [HTTPTool requestWithURLString:BATHealthEatDetailsUrl parameters:dic type:kGET success:^(id responseObject) {
        
        self.eatDetailsModel = [BATEatDetailsModel mj_objectWithKeyValues:responseObject];
        
        sucess(self.eatDetailsModel);
        
    } failure:^(NSError *error) {
        
        failure(error);
        
    }];
    
    
}

//更新健康数据 post
- (void)UpdateHealthInfoWithParamters:(NSDictionary *)dic success:(Success)sucess failure:(Fail)failure; {
    
    [HTTPTool requestWithURLString:BATUpdateHealthInfoUrl parameters:dic type:kPOST success:^(id responseObject) {
        
        self.updatehealthInfoModel = [BATUpdateHealthInfoModel mj_objectWithKeyValues:responseObject];
        
        sucess(self.eatDetailsModel);
        
    } failure:^(NSError *error) {
        
        failure(error);
        
    }];
    
}

//获取健康数据 get
- (void)getHealthInfoWithParamters:(NSDictionary *)dic success:(Success)sucess failure:(Fail)failure; {
    [HTTPTool requestWithURLString:BATGetHealthInfoUrl parameters:dic type:kPOST success:^(id responseObject) {
        
        self.getHealthInfoModel = [BATGetHealthInfoModel mj_objectWithKeyValues:responseObject];
        
        sucess(self.eatDetailsModel);
        
    } failure:^(NSError *error) {
        
        failure(error);
        
    }];
    
}
//分词查询食物 get
- (void)getSearchEatInfoWithParamters:(NSDictionary *)dic success:(Success)sucess failure:(Fail)failure; {
    
    [HTTPTool requestWithURLString:BATGetGetSearchEatInfoUrl parameters:dic type:kGET success:^(id responseObject) {
        
        self.foodlistModel = [BATSearchFoodModel mj_objectWithKeyValues:responseObject];
        
        sucess(self.foodlistModel);
        
    } failure:^(NSError *error) {
        
        failure(error);
        
    }];
    
    
    
}

//分词查询食物 get 模糊的查询
- (void)MoHugetSearchEatInfoWithParamters:(NSDictionary *)dic success:(Success)sucess failure:(Fail)failure; {
    
    
    [HTTPTool requestWithURLString:BATMoHuGetSearchEatInfoUrl parameters:dic type:kGET success:^(id responseObject) {
        
        self.foodlistModel = [BATSearchFoodModel mj_objectWithKeyValues:responseObject];
        
        sucess(self.foodlistModel);
        
    } failure:^(NSError *error) {
        
        failure(error);
        
    }];
}

//健康评估 get
- (void)HealthyAssessWithParamters:(NSDictionary *)dic success:(Success)sucess failure:(Fail)failure; {
    
    [HTTPTool requestWithURLString:BATHealthyAssessUrl parameters:dic type:kGET success:^(id responseObject) {
        
        self.assessModel = [BATHealthyAssessModel mj_objectWithKeyValues:responseObject];
        
        sucess(self.assessModel);
        
    } failure:^(NSError *error) {
        
        failure(error);
        
    }];
    
    
}
@end
