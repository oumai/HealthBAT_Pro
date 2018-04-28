//
//  BATSelectLocationViewController.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/9/1.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATSelectLocationViewController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>

@interface BATSelectLocationViewController () <BMKMapViewDelegate,BMKLocationServiceDelegate,BMKPoiSearchDelegate,BMKGeoCodeSearchDelegate,BMKSuggestionSearchDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    BMKLocationService *_locService;//定位类
    BMKPointAnnotation* _annotation; //定位点
    BMKPointAnnotation* _moveAnnotation; //点击定位点
    BMKGeoCodeSearch *_addressSerach;//反编码搜索信息
}

@property (nonatomic,strong) NSMutableArray *dataSource;    //搜索地址数据

@property (nonatomic,strong) UISearchBar *searchBar;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSString *currentAddress;

@property (nonatomic,strong) BMKMapView *mapView; //地图显示

@property (nonatomic,strong) BMKReverseGeoCodeOption *reverseGeoCodeOption;

@property (nonatomic,strong) BMKSuggestionSearch *suggestionSearch;// 搜索

@property (nonatomic,assign) BOOL isFirst;

@end

@implementation BATSelectLocationViewController

- (void)dealloc
{
    DDLogWarn(@"%@",self);
    _addressSerach.delegate = nil;
    _suggestionSearch.delegate = nil;
    _searchBar.delegate = nil;
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

//- (void)viewWillDisappear:(BOOL)animated
//{
//    [_mapView viewWillDisappear];
//    _mapView.delegate = nil; // 不用时，置nil
//}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //发送定位的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BEGIN_GET_LOCATION" object:nil];
    
    self.view.backgroundColor = UIColorFromRGB(240, 240, 240, 1);
    
    self.title = @"地理位置";
    
    _dataSource = [[NSMutableArray alloc] init];
    _currentAddress = @"";
    
    _suggestionSearch = [[BMKSuggestionSearch alloc] init];
    _suggestionSearch.delegate = self;
    
    _isFirst = YES;
    
    [self pageLayout];
    
    [self openLocation];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
    sectionHeaderView.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 60, 30)];
    label.text = [NSString stringWithFormat:@"[当前]"];
    label.textColor = UIColorFromRGB(87, 170, 220, 1);
    [sectionHeaderView addSubview:label];
    
    UILabel *currentLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 0, SCREEN_WIDTH - 80 - 30, 50)];
    currentLabel.text = _currentAddress;
    currentLabel.numberOfLines = 0;
    currentLabel.textColor = UIColorFromRGB(87, 170, 220, 1);
    [sectionHeaderView addSubview:currentLabel];
    
    UIImageView *rightView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 35, 15, 20, 20)];
    rightView.image = [UIImage imageNamed:@"check"];
    [sectionHeaderView addSubview:rightView];
    
    UIButton *sureAddress = [UIButton buttonWithType:UIButtonTypeCustom];
    sureAddress.frame = sectionHeaderView.bounds;
    sureAddress.backgroundColor = [UIColor clearColor];
    [sureAddress addTarget:self action:@selector(sureAddress:) forControlEvents:UIControlEventTouchUpInside];
    [sectionHeaderView addSubview:sureAddress];
    
    [sectionHeaderView setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0];
    
    return sectionHeaderView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        [cell setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0];
    }
    if (_dataSource.count > 0) {
        cell.textLabel.text = _dataSource[indexPath.row];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont systemFontOfSize:17];
        cell.textLabel.textColor = UIColorFromRGB(87, 170, 220, 1);
        
    }
    return cell;
    
}

#pragma mark - UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DDLogWarn(@"%@",_dataSource);
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_dataSource.count > 0) {
        if(self.addressBlock) {
            self.addressBlock(_dataSource[indexPath.row]);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [_dataSource removeAllObjects];
    
    [searchBar resignFirstResponder];
    
    if ([searchBar.text isEqualToString:@""]) {
        [self showText:@"请输入关键字"];
    } else {
        BMKSuggestionSearchOption* searchOption = [[BMKSuggestionSearchOption alloc] init];
        searchOption.keyword  = searchBar.text;
        BOOL flag = [_suggestionSearch suggestionSearch:searchOption];
        
        if(flag) {
            NSLog(@"建议检索发送成功");
        } else {
            NSLog(@"建议检索发送失败");
        }
    }
}

#pragma mark - BMKMapViewDelegate
#pragma mark- 单机地图代理方法
- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate
{
    self.mapView.zoomLevel = 17;
    //点击位置反地理编码数据
    self.reverseGeoCodeOption.reverseGeoPoint = coordinate;
    [self getLocationInfo:self.reverseGeoCodeOption];
    
    //添加大头针标注
    [self addPointAnnotation:coordinate];
    
}

#pragma mark- 定义大头针
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    
    //普通annotation
    if (annotation == _moveAnnotation) {
        NSString *AnnotationViewID = @"renameMark";
        BMKPinAnnotationView *annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
        if (annotationView == nil) {
            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
            // 设置颜色
            annotationView.pinColor = BMKPinAnnotationColorPurple;
            // 从天上掉下效果
            annotationView.animatesDrop = YES;
            
            annotationView.image = [UIImage imageNamed:@"icon_map"];
            // 设置可拖拽
            annotationView.draggable = YES;
        }
        return annotationView;
    }
    
    return nil;
}

#pragma mark - BMKLocationServiceDelegate

#pragma mark - 定位代理
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //    NSLog(@"heading is %@",userLocation.heading);
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    if (_isFirst) {
        [_mapView updateLocationData:userLocation];
        
        self.reverseGeoCodeOption.reverseGeoPoint = userLocation.location.coordinate;
        
        [self getLocationInfo:self.reverseGeoCodeOption];
    }
    
}

#pragma mark - BMKSuggestionSearchDelegate

#pragma mark - 实现搜索结果回调
- (void)onGetSuggestionResult:(BMKSuggestionSearch*)searcher result:(BMKSuggestionResult*)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        [_dataSource addObjectsFromArray:result.keyList];
        [_tableView reloadData];
    } else {
        DDLogDebug(@"抱歉，未找到结果");
        [_tableView reloadData];
    }
}

#pragma mark - BMKGeoCodeSearchDelegate

#pragma mark - 定位信息代理
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == 0 && _isFirst) {
        //地图上显示当前的位置
        [self showInMap:result.location];
        
        if (result != nil) {
            if(result.addressDetail.province.length == 0 && result.addressDetail.city.length == 0 &&result.addressDetail.district.length == 0 &&result.addressDetail.streetName.length == 0 &&result.addressDetail.streetNumber.length == 0){
                _currentAddress = @"地址获取失败！";
            } else {
                _currentAddress = [NSString stringWithFormat:@"%@%@%@%@%@",result.addressDetail.province,result.addressDetail.city,result.addressDetail.district,result.addressDetail.streetName,result.addressDetail.streetNumber];
                _annotation.title = _currentAddress;
            }
        } else {
            _currentAddress = @"地址获取失败！";
        }
        
        _isFirst = NO;
        
    }
    
    //处理下重复的
    if (result.poiList.count > 0) {
        [_dataSource removeAllObjects];
        
        for (BMKPoiInfo *poiInfo in result.poiList) {
            
            NSString *address = poiInfo.name.length > 0 ? poiInfo.name : poiInfo.address;
            
            [_dataSource addObject:address];
        }
        
    } else {
        [self showText:@"请重新选择(放大会更精确哦！)"];
    }
    
    [_tableView reloadData];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

#pragma mark-添加大头针标注
- (void)addPointAnnotation:(CLLocationCoordinate2D)coordinate
{
    if (_moveAnnotation == nil) {
        _moveAnnotation = [[BMKPointAnnotation alloc]init];
    }
    _moveAnnotation.coordinate = coordinate;
    BMKCoordinateRegion region ;//表示范围的结构体
    region.center = coordinate;//中心点
    [_mapView setRegion:region animated:YES];//这是一句关键的代码可以让你的地图跟着标注点走
    [_mapView addAnnotation:_moveAnnotation];
    
}

#pragma mark 选择当前位置
- (void)sureAddress:(UIButton *)sender
{
    
    if ([_currentAddress isEqualToString:@""]) {
        return;
    } else {
        if(self.addressBlock)
        {
            self.addressBlock(_currentAddress);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark - 开启定位
- (void)openLocation
{
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    [_locService startUserLocationService];
}

#pragma mark- 反编码获取位置信息
- (void)getLocationInfo:(BMKReverseGeoCodeOption *)option
{
    _addressSerach = [[BMKGeoCodeSearch alloc]init];
    _addressSerach.delegate = self;
    [_addressSerach reverseGeoCode:option];
}

#pragma mark - 地图上显示当前位置
- (void)showInMap:(CLLocationCoordinate2D)coor
{
    if (_annotation == nil) {
        _annotation = [[BMKPointAnnotation alloc]init];
    }
    _annotation.coordinate = coor;
    _mapView.centerCoordinate = coor;
    [_mapView addAnnotation:_annotation];
    
    [self showText:@"获取位置成功！"];
}


#pragma mark - layout
- (void)pageLayout
{
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.tableView];
    
    WEAK_SELF(self);
    
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.searchBar.mas_bottom);
        make.height.mas_equalTo(300);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.mapView.mas_bottom);
    }];
}

#pragma mark - get & set

#pragma mark  - 搜索框
- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.placeholder = @"请输入地址搜索...";
        _searchBar.backgroundImage = [UIImage new];
        _searchBar.barTintColor = [UIColor blackColor];
        _searchBar.tintColor = [UIColor whiteColor];
        _searchBar.delegate = self;
    }
    return _searchBar;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (BMKMapView *)mapView
{
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] init];
        _mapView.zoomLevel = 17;
        [_mapView setMapType:BMKMapTypeStandard];
        _mapView.showsUserLocation = YES;
        _mapView.delegate = self;
    }
    return _mapView;
}

- (BMKReverseGeoCodeOption *)reverseGeoCodeOption
{
    if (!_reverseGeoCodeOption) {
        _reverseGeoCodeOption = [[BMKReverseGeoCodeOption alloc] init];
    }
    return _reverseGeoCodeOption;
}

@end
