
//
//  BATFamilyDoctorViewController.m
//  HealthBAT_Pro
//
//  Created by four on 17/3/15.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATFamilyDoctorViewController.h"

#import "BATFamilyDoctorDetailViewController.h"
#import "BATSearchFamilyDoctorViewController.h"
#import "BATNearFamilyDoctorViewController.h"
#import "BATMyFamilyDoctorOrderListViewController.h"

#import "BATNearFamilyDoctorRemindView.h"
#import "BATNearFamilyDoctorListView.h"
#import "BATNearFamilyDoctorModel.h"

#import "BATAppDelegate+BATBaiduMap.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface BATFamilyDoctorViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate>

@property (nonatomic,strong) UIButton *searchBtn;

@property (nonatomic,strong) BATNearFamilyDoctorListView *nearFamilyDoctorListView;

@property (nonatomic,strong) BATNearFamilyDoctorRemindView *nearFamilyDoctorRemindView;

@property (nonatomic,strong) NSMutableArray *imageArray;

@property (nonatomic,strong) UIImageView *imagesView;

@property (nonatomic,strong) BMKMapView *mapView; //地图显示
@property (nonatomic,strong) BMKLocationService *locService; //定位类
@property (nonatomic,strong) UIView  *maskView;

@property (nonatomic,strong) BATNearFamilyDoctorModel *nearFamilyDoctorModel;
@property (nonatomic,strong) UIAlertController * alert;
@end

@implementation BATFamilyDoctorViewController

- (void)dealloc{
    DDLogInfo(@"%@",self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //定位失败，用深圳作为默认地址
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLocationFailure) name:@"LOCATION_FAILURE" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLocationSuccess) name:@"LOCATION_SUCCESS" object:nil];
    
    //返回首页
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(backHomeVc) name:@"BACKHOMEVC" object:nil];
    
    _imageArray = [[NSMutableArray alloc] init];
    for (int i=0; i<36; ++i) {
        NSString *imageName=[NSString stringWithFormat:@"FD_%i.png",i+1];
        UIImage *image=[UIImage imageNamed:imageName];
        [_imageArray addObject:image];
    }
    
    [self pagesLayout];
    
    [self openLocation];

    [_imagesView startAnimating];
    
}
- (void)backHomeVc{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)handleLocationSuccess{
    
    _maskView.hidden = NO;
    _mapView.hidden = NO;
    _nearFamilyDoctorRemindView.hidden = NO;
    _imagesView.hidden = NO;
    
    [self.alert dismissViewControllerAnimated:YES completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self requesNearFamilyDoctorList];
    });
}

- (void)handleLocationFailure{
    _maskView.hidden = YES;
    _mapView.hidden = YES;
    _nearFamilyDoctorRemindView.hidden = YES;
    _imagesView.hidden = YES;
    
    [self sheckLocation];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self;
    self.locService.delegate = self;
    
    //发送定位的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BEGIN_GET_LOCATION" object:nil];
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;

}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil;
    self.locService.delegate = nil;
  self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - 定位代理
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    NSLog(@"heading is %@",userLocation.heading);
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    
    CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
    //将中心点设置为自身位置
    _mapView.centerCoordinate = coor;
    
    [_mapView updateLocationData:userLocation];
}

#pragma mark - action

- (void)sheckLocation{
    //提示开启定
    self.alert = [UIAlertController alertControllerWithTitle:@"定位失败" message:@"请检测网络状态，并确认是否开启定位" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL  URLWithString:UIApplicationOpenSettingsURLString]];
    }];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [self.alert addAction:okAction];
    [self.alert addAction:cancelAction];
    [self presentViewController:self.alert animated:YES completion:nil];
}

#pragma mark - 开启定位
- (void)openLocation
{
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    [_locService startUserLocationService];
}

- (void)showRemindView{
    //开始搜索
    self.nearFamilyDoctorRemindView.hidden = NO;
    self.nearFamilyDoctorListView.hidden = YES;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self requesNearFamilyDoctorList];
    });
}

- (void)showNearFamilyDoctorListView{
    //结束搜索
    self.nearFamilyDoctorRemindView.hidden = YES;
    self.nearFamilyDoctorListView.hidden = NO;
}

#pragma mark - net
- (void)requesNearFamilyDoctorList{
    
    [HTTPTool requestWithURLString:@"/api/FamilyDoctor/GetFamilyDoctorList" parameters:@{@"keyword":@"",@"pageIndex":@"0",@"pageSize":@"10"} type:kGET success:^(id responseObject) {
        
        self.nearFamilyDoctorModel = [BATNearFamilyDoctorModel mj_objectWithKeyValues:responseObject];
        
        /*
        [self showNearFamilyDoctorListView];
        self.nearFamilyDoctorListView.numberLable.text = self.nearFamilyDoctorModel.Data.count>0?[NSString stringWithFormat:@"%lu",(unsigned long)self.nearFamilyDoctorModel.Data.count]:@"0";
         */
       
        //底部弹出搜索结果列表
        
        BATNearFamilyDoctorViewController *nearFamilyDoctorDetailVC = [[BATNearFamilyDoctorViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:nearFamilyDoctorDetailVC];
        [self presentViewController:nav animated:YES completion:nil];
            

        
    } failure:^(NSError *error) {
        
        [self showNearFamilyDoctorListView];
        self.nearFamilyDoctorListView.numberLable.text = @"0";
    }];
}


#pragma mark - pagesLayout

- (void)pagesLayout{
    self.title = @"家庭医生";
    
    self.view.backgroundColor = BASE_BACKGROUND_COLOR;
    
    WEAK_SELF(self);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.searchBtn];
    
    [self.view addSubview:self.mapView];
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.bottom.equalTo(self.view.mas_bottom).offset(-60);
        make.top.left.right.equalTo(self.view);
    }];
    
    [self.view addSubview:self.imagesView];
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerX.centerY.equalTo(self.mapView);
        make.height.width.mas_equalTo(SCREEN_WIDTH - 40);
    }];
    
    
    [self.view addSubview:self.maskView];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:self.nearFamilyDoctorRemindView];
    [self.nearFamilyDoctorRemindView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.bottom.equalTo(self.view.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(60);
        make.left.equalTo(self.view);
    }];
    
    [self.view addSubview:self.nearFamilyDoctorListView];
    [self.nearFamilyDoctorListView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self.view);
    }];
}


#pragma mark - setter&getter

- (UIImageView *)imagesView{
    if (!_imagesView) {
        _imagesView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _imagesView.backgroundColor = [UIColor clearColor];
        [_imagesView setAnimationImages:_imageArray];
        [_imagesView setAnimationDuration:10];
        _imagesView.animationRepeatCount = 0;
    }
    return _imagesView;
}

- (BMKMapView *)mapView
{
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] init];
        _mapView.zoomLevel = 13;
        [_mapView setMapType:BMKMapTypeStandard];
        _mapView.showsUserLocation = YES;
        _mapView.delegate = self;
        _mapView.userTrackingMode = YES;
        _mapView.zoomEnabled = NO;
    }
    return _mapView;
}

- (UIView *)maskView{
    if (!_maskView) {
        
        _maskView = [[UIView alloc]init];
        _maskView.backgroundColor = [UIColor clearColor];
    }
    return _maskView;
}

- (UIButton *)searchBtn{
    if (!_searchBtn) {
        _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom Title:nil titleColor:nil backgroundColor:nil backgroundImage:nil Font:nil];
        [_searchBtn setImage:[UIImage imageNamed:@"Search"] forState:UIControlStateNormal];
        
        WEAK_SELF(self);
        [_searchBtn bk_whenTapped:^{
            STRONG_SELF(self);
            
            BATSearchFamilyDoctorViewController *searchFamilyDoctorDetailVC = [[BATSearchFamilyDoctorViewController alloc] init];
            searchFamilyDoctorDetailVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:searchFamilyDoctorDetailVC animated:YES];
        }];
    }
    
    return _searchBtn;
}

- (BATNearFamilyDoctorListView *)nearFamilyDoctorListView{
    if (!_nearFamilyDoctorListView) {
        _nearFamilyDoctorListView = [[BATNearFamilyDoctorListView alloc] init];
        _nearFamilyDoctorListView.hidden = YES;
        WEAK_SELF(self);
        [_nearFamilyDoctorListView setReloadSearchBlock:^{
            STRONG_SELF(self);
            DDLogInfo(@"重新获取");
            [self showRemindView];
        }];
        
        [_nearFamilyDoctorListView setPushNearFamilyDoctorListBlock:^{
            STRONG_SELF(self);
            DDLogInfo(@"跳转附近医生");
            
            if (self.nearFamilyDoctorModel.Data.count <= 0) {
                return ;
            }else{
                [self showRemindView];
                BATNearFamilyDoctorViewController *nearFamilyDoctorDetailVC = [[BATNearFamilyDoctorViewController alloc] init];
                nearFamilyDoctorDetailVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:nearFamilyDoctorDetailVC animated:YES];
            }

        }];
        
    }
    return _nearFamilyDoctorListView;
}

- (BATNearFamilyDoctorRemindView *)nearFamilyDoctorRemindView{
    if (!_nearFamilyDoctorRemindView) {
        _nearFamilyDoctorRemindView = [[BATNearFamilyDoctorRemindView alloc] init];
    }
    return _nearFamilyDoctorRemindView;
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
