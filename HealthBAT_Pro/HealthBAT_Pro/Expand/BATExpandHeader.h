//
//  BATExpandHeader.h
//  HealthBAT_Pro
//
//  Created by Skyrim on 16/8/15.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#ifndef BATExpandHeader_h
#define BATExpandHeader_h


#import "BATMacro.h"
#import "BATHospitalRegisterTool.h"//在线预约城市定位
#import "UIViewController+BATShowToast.h"//加载框

//接口
#import "HTTPTool+BATMainRequest.h"//app主要接口，.net提供
#import "HTTPTool+BATSearchRequest.h"//搜索接口
#import "HTTPTool+BATMallRequest.h"//电商接口
#import "HTTPTool+BATUploadImage.h"//上传图片
#import "HTTPTool+BATNetworkMedicalUploadImage.h"//上传图片到网络医院
#import "HTTPTool+BATMaintenanceRequest.h"//培训工作室接口
#import "HTTPTool+BATKmWlyyRequest.h"//kmwlyy接口

//#import "HTTPTool+BATDomainAPI.h"//获取域名（AppDelegate已经导入）

#import "BATTIMManager.h"
#import "BATTIMService.h"

#import "BATRongCloudManager.h"

#import "BATJPushManager.h"
#import "Tools+BATErrorTool.h"//错误日志

#endif /* BATExpandHeader_h */
