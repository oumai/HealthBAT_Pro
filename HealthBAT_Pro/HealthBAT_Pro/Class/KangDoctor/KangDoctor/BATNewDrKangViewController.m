//
//  BATNewDrKangViewController.m
//  HealthBAT_Pro
//
//  Created by mac on 2018/3/19.
//  Copyright © 2018年 KMHealthCloud. All rights reserved.
//

#import "BATNewDrKangViewController.h"

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <AVFoundation/AVFoundation.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件

#import "BATLoginModel.h"
#import "BATPerson.h"

#import "BATRegisterHospitalListViewController.h"//预约挂号
#import "BATRegisterDepartmentListViewController.h"//预约挂号科室
#import "BATKangDoctorHospitalListViewController.h"
#import "BATDrKangHistoryViewController.h"//历史记录
#import "BATHealthThreeSecondsController.h"  //健康3秒钟
#import "BATHealthyInfoViewController.h"  //健康3秒钟健康资料
#import "BATHealthThreeSecondsStatisController.h" //健康3秒钟 统计
#import "BATHealth360EvaluationViewController.h"//健康360健康评估
#import "BATFindDoctorListViewController.h"//健康咨询 医生列表界面

@interface BATNewDrKangViewController ()

//地理坐标
@property (nonatomic,assign) BOOL isFirstLocationFail;
@property (nonatomic,assign) BOOL isGetLocation;
@property (nonatomic,assign) CLLocationCoordinate2D currentLocation;
@property (nonatomic,assign) double hospitalLatitude;
@property (nonatomic,assign) double hospitalLongitude;

@end

@implementation BATNewDrKangViewController

- (void)loadView {
    
    [super loadView];
    BATLoginModel *login = LOGIN_INFO;
    
    //必要参数赋值
    self.userID = [NSString stringWithFormat:@"%ld",(long)login.Data.ID];
    self.userDeviceId = [Tools getPostUUID];
    self.lat = @"";
    self.lon = @"";
    self.requestSource = @"phone";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.isFirstLocationFail = YES;
    
    WEAK_SELF(self);
    [self setRightBarActionBlock:^(NSInteger tag) {
        STRONG_SELF(self);
        switch (tag) {
            case BATDrKangRightBarButtonHistory:
            {
                //智能问诊历史评估
                [self pushDrKangHistoryVC];
            }
                break;
                
            case BATDrKangRightBarButtonEvaluation:
            {
                //健康360 健康评估
                [self pushHealth360EvaluationVC];
            }
                break;
                
            case BATDrKangRightBarButtonHealthThreeSecond:
            {
                //健康3秒钟统计
                [self pushHealthThreeSecondsStatisVC];
            }
                break;
                
            default:
                break;
        }
    }];
    
    //开始定位
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BEGIN_GET_LOCATION" object:nil];
    //定位成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLocationInfo:) name:@"LOCATION_INFO" object:nil];
    //定位失败，用深圳作为默认地址
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLocationFailure) name:@"LOCATION_FAILURE" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogin) name:@"BAT_LOGIN_SUCCESS" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogout) name:@"APPLICATION_LOGOUT" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - override
- (void)handleFlag:(NSString *)flag allPara:(NSDictionary *)allPara {
    
    [super handleFlag:flag allPara:allPara];
    
    if ([flag isEqualToString:@"咨询医生"]) {
        
        [self goConsultation];
        return;
    }else if ([flag isEqualToString:@"健康3秒钟"]){
        
        [self pushHealthThreeSecondsVC];
        
    }
    else if ([flag isEqualToString:@"预约挂号"]) {
        
        if ([allPara.allKeys containsObject:@"id"]) {
            //跳转到指定的医院
            NSString *hospitalName = allPara[@"hospitalName"];
            hospitalName = [hospitalName stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [self goHospitalRegisterWithHospitalID:allPara[@"id"] hospitalName:hospitalName];
        }
        else {
            //预约挂号
            [self goHospitalRegister];
        }
        return;
    }
    else if ([flag isEqualToString:@"周边医院"]) {
        
        BATKangDoctorHospitalListViewController *hospitalListVC = [[BATKangDoctorHospitalListViewController alloc] init];
        hospitalListVC.lat = self.currentLocation.latitude;
        hospitalListVC.lon = self.currentLocation.longitude;
        [self.navigationController pushViewController:hospitalListVC animated:YES];
        return;
    }
}

- (void)executiveOrder:(NSString *)order {
    
    [super executiveOrder:order];
    
    if ([order isEqualToString:@"login"]) {
        //跳转登陆
        PRESENT_LOGIN_VC;
    }
    else if ([order containsString:@"healthCounseling"]) {
        //跳转健康咨询
        [self goConsultation];
    }
    else if ([order containsString:@"healthReport"]) {
        //跳转健康报告
        [self pushHealth360EvaluationVC];
    }
    else if ([order containsString:@"health360"]) {
        //跳转健康360（健康档案）
        [self pushHealth360DocumentVC];
    }
    else if ([order containsString:@"health3s"]) {
        //跳转健康3s
        [self pushHealthThreeSecondsVC];
    }
    else if ([order containsString:@"show"]) {
        //小管家跳转
        
    }
}

#pragma mark - action
//定位失败
- (void)handleLocationFailure {
    
}

//定位成功
- (void)handleLocationInfo:(NSNotification *)locationNotification {
    
    //定位成功过了，不需要去隐私重新设置
    _isFirstLocationFail = NO;
    
    //阻止多次回调
    if (self.isGetLocation) {
        
        return;
    }
    self.isGetLocation = YES;
    
    BMKReverseGeoCodeResult * result = locationNotification.userInfo[@"location"];
    DDLogWarn(@"%@",result);
    
    self.currentLocation = result.location;
    
    self.lat = [NSString stringWithFormat:@"%f",result.location.latitude];
    self.lon = [NSString stringWithFormat:@"%f",result.location.longitude];
    
}

- (void)userLogin {
    
    BATLoginModel *login = LOGIN_INFO;
    
    //必要参数赋值
    self.userID = [NSString stringWithFormat:@"%ld",(long)login.Data.ID];
    self.userDeviceId = [Tools getPostUUID];
    self.lat = @"";
    self.lon = @"";
    self.requestSource = @"phone";
}

- (void)userLogout {
    
    //必要参数赋值
    self.userID = @"";
    self.userDeviceId = [Tools getPostUUID];
    self.lat = @"";
    self.lon = @"";
    self.requestSource = @"phone";
}



#pragma mark - private
//到指定的医院预约挂号
- (void)goHospitalRegisterWithHospitalID:(NSString *)hospitalID hospitalName:(NSString *)hospitalName {
    
    if (!CANREGISTER) {
        [self showText:@"您好,预约挂号功能升级中,请稍后再试!"];
        return;
    }
    
    BATRegisterDepartmentListViewController * departmentListVC = [BATRegisterDepartmentListViewController new];
    departmentListVC.hospitalId = [hospitalID integerValue];
    departmentListVC.hospitalName = hospitalName;
    [self.navigationController pushViewController:departmentListVC animated:YES];
    
}
//预约挂号
- (void)goHospitalRegister {
    
    if (!CANREGISTER) {
        [self showText:@"您好,预约挂号功能升级中,请稍后再试!"];
        return;
    }
    
    BATRegisterHospitalListViewController * hospitalVC = [BATRegisterHospitalListViewController new];
    hospitalVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:hospitalVC animated:YES];
    
}

//在线咨询 健康咨询
- (void)goConsultation {
    
    BATFindDoctorListViewController *findDoctorListVC = [[BATFindDoctorListViewController alloc] init];
    [self.navigationController pushViewController:findDoctorListVC animated:YES];
}

//跳转到智能问诊历史记录
- (void)pushDrKangHistoryVC {
    
    BATDrKangHistoryViewController *historyVC = [[BATDrKangHistoryViewController alloc] init];
    [self.navigationController pushViewController:historyVC animated:YES];
}

//跳转到健康3秒钟界面
- (void)pushHealthThreeSecondsVC{
    
    if ( !LOGIN_STATION) {
        PRESENT_LOGIN_VC;
        return;
    }
    
    BATPerson *loginUserModel = PERSON_INFO;
    
    BOOL isEdit = (loginUserModel.Data.Weight && loginUserModel.Data.Height && loginUserModel.Data.Birthday.length);
    
    if ( !LOGIN_STATION) {
        PRESENT_LOGIN_VC;
        return;
    }
    
    
    if (!isEdit && ![[NSUserDefaults standardUserDefaults]boolForKey:@"isFirstEnterHealthThreeSecond"]) {
        
        //完善资料
        BATHealthyInfoViewController *editInfo = [[BATHealthyInfoViewController alloc]init];
        editInfo.isShowNavButton = YES;
        editInfo.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:editInfo animated:YES];
        
        
    }else{
        
        //健康3秒钟
        BATHealthThreeSecondsController *healthThreeSecondsVC = [[BATHealthThreeSecondsController alloc]init];
        healthThreeSecondsVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:healthThreeSecondsVC animated:YES];
    }
}

//跳转到健康3秒钟统计界面
- (void)pushHealthThreeSecondsStatisVC{
    
    if ( !LOGIN_STATION) {
        PRESENT_LOGIN_VC;
        return;
    }
    
    BATPerson *loginUserModel = PERSON_INFO;
    
    BOOL isEdit = (loginUserModel.Data.Weight && loginUserModel.Data.Height && loginUserModel.Data.Birthday.length);
    
    if ( !LOGIN_STATION) {
        PRESENT_LOGIN_VC;
        return;
    }
    
    
    if (!isEdit && ![[NSUserDefaults standardUserDefaults]boolForKey:@"isFirstEnterHealthThreeSecond"]) {
        
        //完善资料
        BATHealthyInfoViewController *editInfo = [[BATHealthyInfoViewController alloc]init];
        editInfo.isShowNavButton = YES;
        editInfo.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:editInfo animated:YES];
        
        
    }else{
        
        //健康3秒钟统计
        BATHealthThreeSecondsStatisController *healthThreeSecondsStatisVC = [[BATHealthThreeSecondsStatisController alloc]init];
        healthThreeSecondsStatisVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:healthThreeSecondsStatisVC animated:YES];
    }
}

//健康360的评估页面
- (void)pushHealth360EvaluationVC {
    
    if (!LOGIN_STATION) {
        PRESENT_LOGIN_VC;
        return;
    }
    BATHealth360EvaluationViewController *evaluationVC = [[BATHealth360EvaluationViewController alloc] init];
    evaluationVC.urlSuffix = @"&redirect=/H5/src/index.html?src=2#/healthEvaluateReport/////2";
    [self.navigationController pushViewController:evaluationVC animated:YES];
}

//健康360的健康档案页面
- (void)pushHealth360DocumentVC {
    
    if (!LOGIN_STATION) {
        PRESENT_LOGIN_VC;
        return;
    }
    BATHealth360EvaluationViewController *documentVC = [[BATHealth360EvaluationViewController alloc] init];
    documentVC.urlSuffix = @"&redirect=/H5/src/index.html?src=2#/healthRecordIndex/2";
    [self.navigationController pushViewController:documentVC animated:YES];
}

#pragma mark - NET
- (void)sendTextRequestWithParameters:(NSDictionary *)parameters isSound:(BOOL)isSound {
    
    [super sendTextRequestWithParameters:parameters isSound:isSound];
    
    [HTTPTool requestWithDrKangURLString:@"/drkang/test/chatWithDrKang"
                              parameters:parameters
                                 success:^(id responseObject) {
                                     
                                     if (!responseObject) {
                                         
                                         return ;
                                     }
                                     
                                     if ([responseObject isKindOfClass:[NSArray class]]) {
                                         //新形势接口解析
                                         [self handleNewResponseObject:responseObject isSound:isSound];
                                     }
                                     else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                                         //旧接口解析
                                         [self handleResponseObject:responseObject];
                                     }
                                     
                                 } failure:^(NSError *error) {
                                     
                                     
                                 }];
}

- (void)eventRequestWithURL:(NSString *)url {
    
    [super eventRequestWithURL:url];
    
    url = [NSString stringWithFormat:@"%@&userDeviceId=%@&userId=%@",url,self.userDeviceId,self.userID];
    
    [XMCenter sendRequest:^(XMRequest *request) {
        request.url = url;
        request.httpMethod = kPOST;
        request.requestSerializerType = kXMRequestSerializerRAW;
    } onSuccess:^(id responseObject) {
        if (!responseObject) {
            
            return ;
        }
        
        if ([responseObject isKindOfClass:[NSArray class]]) {
            
            [self handleNewResponseObject:responseObject isSound:NO];
        }
        else if ([responseObject isKindOfClass:[NSDictionary class]]) {
            
            [self handleResponseObject:responseObject];
        }
        
    } onFailure:^(NSError *error) {
        
    } onFinished:^(id responseObject, NSError *error) {
        
    }];
}

- (void)detailRequestWithURL:(NSString *)url {
    
    [super detailRequestWithURL:url];
    
    url = [NSString stringWithFormat:@"%@&userDeviceId=%@&userId=%@",url,self.userDeviceId,self.userID];
    
    [XMCenter sendRequest:^(XMRequest *request) {
        request.url = url;
        request.httpMethod = kPOST;
        request.requestSerializerType = kXMRequestSerializerRAW;
    } onSuccess:^(id responseObject) {
        
        if (!responseObject) {
            
            return ;
        }
        
        [self expandDeitalViewWithResponseObject:responseObject];
        
    } onFailure:^(NSError *error) {
        
    } onFinished:^(id responseObject, NSError *error) {
        
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
