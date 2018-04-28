//
//  BATNewHospitalViewController.m
//  HealthBAT_Pro
//
//  Created by four on 2017/5/18.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATNewHospitalInfoViewController.h"

//vc
#import "BATNewHospitalInfoDetailViewController.h"
#import "BATRegisterDepartmentListViewController.h"

//model
#import "HospitalDetailModel.h"
//cell
#import "BATNewHospitalDetailNameCell.h"
#import "BATNewHosptailDetailBottomCell.h"

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface BATNewHospitalInfoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) HospitalDetailModel *hospitalModel;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) BATDefaultView  *defaultView;

@property (nonatomic,assign) double lon;

@property (nonatomic,assign) double lat;

@end

@implementation BATNewHospitalInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self layoutPages];
    
    [self getHosptailInfoRequest];
}

-(bool)isCanOpenUrlWithString:(NSString *)urlString {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlString]]) {
        return YES;
    }else {
        return NO;
    }
}

-(void)openURLWithString:(NSString *)urlString {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

-(void)openUrl{
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"" message:@"请选择" preferredStyle:UIAlertControllerStyleActionSheet];
    
    NSString *baiduMapUrl = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=目的地&mode=driving&coord_type=gcj02",self.lat,self.lon]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if ([self isCanOpenUrlWithString:baiduMapUrl]) {
        
        UIAlertAction *baidumap = [UIAlertAction actionWithTitle:@"百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self openURLWithString:baiduMapUrl];
        }];
        
        [alter addAction:baidumap];
    }
    
    
    
    NSString *gaodeMapUrl = [[NSString stringWithFormat:@"iosamap://path?sourceApplication=applicationName&sid=BGVIS1&slat=%f&slon=%f&sname=%@&did=BGVIS2&dlat=%f&dlon=%f&dname=%@&dev=0&m=0&t=0",LATITUDE,LONGITUDE,@"我的位置",self.lat,self.lon,self.hospitalModel.Data.UNIT_NAME]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if ([self isCanOpenUrlWithString:gaodeMapUrl]) {
        
        UIAlertAction *gaodedmap = [UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self openURLWithString:gaodeMapUrl];
        }];
        
        [alter addAction:gaodedmap];
    }
    
    NSString *aaMapUrl = [NSString stringWithFormat:@"qqmap://map/routeplan?type=drive&fromcoord=%f,%f&tocoord=%f,%f&policy=1",LATITUDE,LONGITUDE,self.lat,self.lon];
    if ([self isCanOpenUrlWithString:aaMapUrl]) {
        
        UIAlertAction *qqmap = [UIAlertAction actionWithTitle:@"腾讯地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self openURLWithString:aaMapUrl];
        }];
        
        [alter addAction:qqmap];
    }
    
    UIAlertAction *acton = [UIAlertAction actionWithTitle:@"苹果地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(self.lat,self.lon);
        MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:loc addressDictionary:nil]];
        [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                       launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
                                       MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
    }];
    [alter addAction:acton];
    
    UIAlertAction *cancleacton = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alter addAction:cancleacton];
    
    
    [self presentViewController:alter animated:YES completion:nil];
}


#pragma mark - net
- (void)getHosptailInfoRequest{
    
    [HTTPTool requestWithURLString:[NSString stringWithFormat:@"/api/Hospital/GetHospitalDetail?id=%@",self.HospitailID] parameters:nil type:kGET success:^(id responseObject) {
        
        
        [HospitalDetailData mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{
                     @"MAPS" : @"MAP",
                     };
        }];
        
        self.hospitalModel = [HospitalDetailModel mj_objectWithKeyValues:responseObject];
        
        NSString *oreillyAddress = self.hospitalModel.Data.UNIT_NAME;
        CLGeocoder *myGeocoder = [[CLGeocoder alloc] init];
        [myGeocoder geocodeAddressString:oreillyAddress completionHandler:^(NSArray *placemarks, NSError *error) {
            if ([placemarks count] > 0 && error == nil) {
                NSLog(@"Found %lu placemark(s).", (unsigned long)[placemarks count]);
                CLPlacemark *firstPlacemark = [placemarks objectAtIndex:0];
                NSLog(@"Longitude = %f", firstPlacemark.location.coordinate.longitude);
                NSLog(@"Latitude = %f", firstPlacemark.location.coordinate.latitude);
                self.lon = firstPlacemark.location.coordinate.longitude;
                self.lat = firstPlacemark.location.coordinate.latitude;
            }
            else if ([placemarks count] == 0 && error == nil) {
                NSLog(@"Found no placemarks.");
            } else if (error != nil) {
                NSLog(@"An error occurred = %@", error);
            }
        }];
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        return ;
    }];

}

#pragma mark - UITableViewDatasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    if (indexPath.section == 0) {
        BATNewHospitalDetailNameCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATNewHospitalDetailNameCell"];
        
        [cell setCellWithModel:self.hospitalModel];
        
        [cell setClickPhoneBlock:^{
            
            HospitalDetailData *data = self.hospitalModel.Data;
            //打电话
            
            NSMutableString * str = [[NSMutableString alloc] initWithFormat:@"tel:%@",data.PHONE];
            UIWebView * callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [self.view addSubview:callWebview];
        }];
        
        [cell setClickAddressBlock:^{
            
            [self openUrl];
        }];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
    }else{
        
        BATNewHosptailDetailBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATNewHosptailDetailBottomCell"];
        [cell setClickDeptDoctorBlock:^{
            DDLogInfo(@"科室医生");
            
            BATRegisterDepartmentListViewController * departmentListVC = [BATRegisterDepartmentListViewController new];
            departmentListVC.hospitalId = [self.hospitalModel.Data.UNIT_ID integerValue];
            departmentListVC.hospitalName = self.hospitalModel.Data.UNIT_NAME;
            [self.navigationController pushViewController:departmentListVC animated:YES];
        }];
        
        [cell setClickHospitalDetailBlock:^{
            DDLogInfo(@"医院概况");
            
            BATNewHospitalInfoDetailViewController *vc = [[BATNewHospitalInfoDetailViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.hospitalDetailModel = self.hospitalModel;
            [self.navigationController pushViewController:vc animated:YES];
        }];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }

    return nil;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
     if (section == 0) {
         return CGFLOAT_MIN;
     }else{
        return 10;
     }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}


#pragma mark - layoutPages
- (void)layoutPages{

    self.title = self.HospitailTitle;
    
    WEAK_SELF(self);
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.top.right.bottom.equalTo(self.view);
    }];
    
    [self.view addSubview:self.defaultView];
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self.view);
    }];
}



#pragma mark -setter & getter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 100;
        _tableView.backgroundColor = BASE_BACKGROUND_COLOR;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_tableView registerClass:[BATNewHosptailDetailBottomCell class] forCellReuseIdentifier:@"BATNewHosptailDetailBottomCell"];
        [_tableView registerClass:[BATNewHospitalDetailNameCell class] forCellReuseIdentifier:@"BATNewHospitalDetailNameCell"];
        
        WEAK_SELF(self);
        _tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            STRONG_SELF(self);
            DDLogInfo(@"下拉刷新！");
            [self getHosptailInfoRequest];
        }];
        
        _tableView.mj_footer.hidden = YES;
    }
    return _tableView;
}

- (BATDefaultView *)defaultView{
    if (!_defaultView) {
        _defaultView = [[BATDefaultView alloc]initWithFrame:CGRectZero];
        _defaultView.hidden = YES;
        WEAK_SELF(self);
        [_defaultView setReloadRequestBlock:^{
            STRONG_SELF(self);
            DDLogInfo(@"=====重新开始加载！=====");
            self.defaultView.hidden = YES;
            [self getHosptailInfoRequest];
        }];
        
    }
    return _defaultView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
