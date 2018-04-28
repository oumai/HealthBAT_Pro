//
//  BATAppDelegate+BATBaiduMap.m
//  HealthBAT_Pro
//
//  Created by Skyrim on 16/8/15.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATAppDelegate+BATBaiduMap.h"

@implementation BATAppDelegate (BATBaiduMap)

- (void)bat_startBaiduMap {

    NSString *appKey = @"";
//#ifdef DEBUG
//    //AppStore开发
//    appKey = @"Cva03QMDKerULuGpUouyTNLlsNHFpQGC";
//#elif TESTING
//    //AppStore测试
//    appKey = @"Cva03QMDKerULuGpUouyTNLlsNHFpQGC";
//#elif PRERELEASE
//    //企业版发布
//    appKey = @"6bp5B7BlY9HjLN2NUeqOqmTAyM0muX4t";
//#elif RELEASE
//    //AppStore发布
//    appKey = @"Cva03QMDKerULuGpUouyTNLlsNHFpQGC";
//#elif PUBLICRELEASE
//    //企业版测试
//    appKey = @"6bp5B7BlY9HjLN2NUeqOqmTAyM0muX4t";
//#endif
    
#ifdef DEBUG
    //AppStore开发
    appKey = @"PWWlOryKaPUdGvgDuYvxgMLGTTG75ij4";
#elif TESTING
    //AppStore测试
    appKey = @"PWWlOryKaPUdGvgDuYvxgMLGTTG75ij4";
#elif PUBLICRELEASE
    //企业版测试
    appKey = @"jF5pHdtM1MBTQGLeHOkffVdLalTwcbPQ";
#elif PRERELEASE
    //企业版
//    appKey = @"jF5pHdtM1MBTQGLeHOkffVdLalTwcbPQ";
    appKey = @"PWWlOryKaPUdGvgDuYvxgMLGTTG75ij4";
#elif ENTERPRISERELEASE
    //企业版发布
//    appKey = @"jF5pHdtM1MBTQGLeHOkffVdLalTwcbPQ";
#elif RELEASE
    //AppStore发布
    appKey = @"PWWlOryKaPUdGvgDuYvxgMLGTTG75ij4";
#endif
    
    //初始化百度地图
    if (!self.mapManager) {

        self.mapManager = [[BMKMapManager alloc] init];
        //健康BAT企业版
        BOOL ret = [self.mapManager start:appKey generalDelegate:nil];
        if (!ret) {
            DDLogError(@"百度地图启动失败！");
        }
    }
    

}

- (void)bat_getLocation {
    //开启定位功能
    //初始化BMKLocationService
    if (!self.locService) {
        self.locService = [[BMKLocationService alloc]init];
        //    [self.locService setDesiredAccuracy:100.0f];
        self.locService.delegate = self;
    }
    //启动LocationService
    [self.locService startUserLocationService];
}

#pragma mark - BMKLocationServiceDelegate
//定位失败
- (void)didFailToLocateUserWithError:(NSError *)error {
    //定位失败
    DDLogError(@"定位失败");
    [self.locService stopUserLocationService];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LOCATION_FAILURE" object:nil];

}

- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation {
    DDLogDebug(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    DDLogDebug(@"当前坐标 lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);

    [[NSNotificationCenter defaultCenter] postNotificationName:@"USERLOCATION_INFO" object:userLocation];

    [[NSUserDefaults standardUserDefaults] setDouble:userLocation.location.coordinate.longitude forKey:@"longitude"];
    [[NSUserDefaults standardUserDefaults] setDouble:userLocation.location.coordinate.latitude forKey:@"latitude"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //发起反向地理编码检索
    BMKGeoCodeSearch * searcher =[[BMKGeoCodeSearch alloc]init];
    searcher.delegate = self;
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude};
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [searcher reverseGeoCode:reverseGeoCodeSearchOption];
    if(flag)
    {
        DDLogDebug(@"反geo检索发送成功");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LOCATION_SUCCESS" object:nil];
    }
    else
    {
        DDLogError(@"反geo检索发送失败");
        [self.locService stopUserLocationService];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LOCATION_FAILURE" object:nil];
    }

}

//接收反向地理编码结果
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        self.result = result;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LOCATION_INFO" object:nil userInfo:@{@"location":result}];
    }
    else {
        DDLogError(@"抱歉，未找到结果");
    }
    [self.locService stopUserLocationService];
}

@end
