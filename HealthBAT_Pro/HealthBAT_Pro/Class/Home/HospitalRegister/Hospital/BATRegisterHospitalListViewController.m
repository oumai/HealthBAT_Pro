//
//  HospitalViewController.m
//  HealthBAT_Pro
//
//  Created by KM on 16/7/142016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATRegisterHospitalListViewController.h"
//第三方
#import "MJRefresh.h"
#import "UIScrollView+EmptyDataSet.h"
//子视图
#import "BATAreaTableViewCell.h"
#import "BATHospitalTableViewCell.h"

#import "BATLeftAreaTableViewCell.h"

//model
#import "BATHospitalModel.h"
//跳转页面
#import "BATChooseCityViewController.h"
#import "BATRegisterDepartmentListViewController.h"
//工具类
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import "BATHospitalRegisterTool.h"

static  NSString * const LEFT_CELL = @"leftCell";
static  NSString * const RIGHT_CELL = @"rightCell";

@interface BATRegisterHospitalListViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic,copy  ) NSString        *cityName;
@property (nonatomic,assign) NSInteger       cityId;
@property (nonatomic,assign) NSInteger       areaId;

//@property (nonatomic,strong) UIBarButtonItem *textItem;
@property (nonatomic,strong) UIButton        *textButton;
@property (nonatomic,assign) BOOL            isFirstLocationFail;

@property (nonatomic,strong) UITableView     *leftTableView;
@property (nonatomic,strong) UITableView     *rightTableView;
@property (nonatomic,strong) BATAreaModel    *areaList;
@property (nonatomic,strong) NSMutableArray  *dataArray;
@property (nonatomic,assign) BOOL            isGetLocation;
@property (nonatomic,assign) int             currentPageIndex;
@property (nonatomic,strong) NSString *beginTime;
@property (nonatomic,strong) NSString *areaName;
@property (nonatomic,assign) BOOL isPopAction;

@property (nonatomic,assign) NSUInteger currentIndexPath;//当前indexPath
@property (nonatomic,assign) BOOL isSelcet;//上一个indexPath

@property (nonatomic,assign) BOOL isCompleteRequest;
@property (nonatomic,assign) BOOL isFirstChooseLocation;

@property (nonatomic,strong) BATDefaultView *defaultView;

@end

@implementation BATRegisterHospitalListViewController
- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"预约挂号";
    [self pagesLayout];
    
    _currentIndexPath = 0;
    _isSelcet = NO;
    _isFirstLocationFail = YES;
    _isFirstChooseLocation = YES;
    
    //定位成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLocationInfo:) name:@"LOCATION_INFO" object:nil];
    //定位失败，用深圳作为默认地址
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLocationFailure) name:@"LOCATION_FAILURE" object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //发送定位的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BEGIN_GET_LOCATION" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    if (self.isPopAction) {
        [BATUserPortrayTools saveOperateModuleRequestWithURL:@"/kmStatistical-sync/saveOperateModule" pathName:@"首页-预约挂号" moduleId:1 beginTime:self.beginTime];
    }
    
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
//    self.navigationController.navigationBar.translucent=NO;
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (tableView == self.leftTableView) {

        return self.areaList.Data.count;
    }
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == _leftTableView){
        return 50;
    }else{
        return 90;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.leftTableView) {

//        BATAreaTableViewCell * areaCell = [tableView dequeueReusableCellWithIdentifier:LEFT_CELL forIndexPath:indexPath];
//        BATAreaData * area = self.areaList.Data[indexPath.row];
//        areaCell.areaNameLabel.text = area.AREA_NAME;
//        return areaCell;
        
        
        BATLeftAreaTableViewCell * areaCell = [tableView dequeueReusableCellWithIdentifier:LEFT_CELL forIndexPath:indexPath];
        BATAreaData * area = self.areaList.Data[indexPath.row];
        [areaCell.nameLb setTitle:area.AREA_NAME forState:UIControlStateNormal];
        areaCell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_isSelcet == NO) {
            if (_currentIndexPath == 0 && indexPath.row == 0) {
                areaCell.lineView.hidden = NO;
                [areaCell.nameLb setGradientColors:@[START_COLOR,END_COLOR]];
                areaCell.backView.backgroundColor = [UIColor whiteColor];
            }else{
                areaCell.lineView.hidden = YES;
                [areaCell.nameLb setGradientColors:@[UIColorFromHEX(0X333333, 1),UIColorFromHEX(0X333333, 1)]];
                areaCell.backView.backgroundColor = UIColorFromHEX(0xf0f0f0, 1);
            }
        }else{
            if (_currentIndexPath == indexPath.row) {
                areaCell.lineView.hidden = NO;
                [areaCell.nameLb setGradientColors:@[START_COLOR,END_COLOR]];
                areaCell.backView.backgroundColor = [UIColor whiteColor];
            }else{
                areaCell.lineView.hidden = YES;
                [areaCell.nameLb setGradientColors:@[UIColorFromHEX(0X333333, 1),UIColorFromHEX(0X333333, 1)]];
                areaCell.backView.backgroundColor = UIColorFromHEX(0xf0f0f0, 1);
            }
        }
        return areaCell;
    }
    else {

        BATHospitalTableViewCell * hospitalCell = [tableView dequeueReusableCellWithIdentifier:RIGHT_CELL forIndexPath:indexPath];
        BATHospitalData * hospital = self.dataArray[indexPath.row];
        [hospitalCell.hospitalImageView sd_setImageWithURL:[NSURL URLWithString:hospital.IMAGE] placeholderImage:[UIImage imageNamed:@"默认图"]];
        hospitalCell.nameLabel.text = hospital.UNIT_NAME;
        hospitalCell.descriptionLabel.text = hospital.ADDRESS;
//        hospitalCell.registerTimesLabel.text = [NSString stringWithFormat:@"%ld个预约号源",(long)hospital.LEFT_NUM];
        hospitalCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return hospitalCell;
    }

}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    
    
    if (tableView == self.leftTableView) {
        //做变色效果
        _currentIndexPath = indexPath.row;
        _isSelcet = YES;
        [self.leftTableView reloadData];
        
        
        BATAreaData * area = self.areaList.Data[indexPath.row];
        self.areaId = area.AREA_ID;
        self.areaName = area.AREA_NAME;
        [self.rightTableView.mj_header beginRefreshing];
    }

    if (tableView == self.rightTableView ) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        self.isPopAction = NO;
        BATHospitalData * hospital = self.dataArray[indexPath.row];
        BATRegisterDepartmentListViewController * departmentListVC = [BATRegisterDepartmentListViewController new];
        departmentListVC.hospitalId = hospital.UNIT_ID;
        departmentListVC.hospitalName = hospital.UNIT_NAME;
        departmentListVC.pathName = [NSString stringWithFormat:@"首页-预约挂号-%@-%@",self.areaName,hospital.UNIT_NAME];
        [self.navigationController pushViewController:departmentListVC animated:YES];
    }
}

#pragma mark - DZNEmptyDataSetSource
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {

    return -50;
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {

    if (!self.isCompleteRequest) {
        return nil;
    }

    return [UIImage imageNamed:@"无数据"];
}

//返回标题文字
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f], NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

//返回详情文字
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {

    if (!self.isCompleteRequest) {
        return nil;
    }

    NSString *text = BAT_NO_DATA;
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:16.0f], NSForegroundColorAttributeName: [UIColor lightGrayColor], NSParagraphStyleAttributeName: paragraph};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}


#pragma mark - Location
//定位失败
- (void)handleLocationFailure {
    
    if (_isFirstChooseLocation == NO) {
        return;
    }
    
    [_textButton setTitle:@"深圳" forState:UIControlStateNormal];
    [self getAreaWithCityName:@"深圳"];
    
    //没网直接提示即可
    if(!NET_STATION){
        [self.defaultView showDefaultView];
        return;
    }
    
    //判断是没开启服务，还是定位失败
    if (_isFirstLocationFail == YES) {
        
        //提示开启定位
        [Tools showSettingWithTitle:@"定位服务已经关闭" message:@"请到设置->隐私->定位服务中开启健康BAT的定位服务，方便我们能准确获取您的地理位置" failure:^{
            //选择深圳为默认地址
            _isFirstChooseLocation = NO;
        }];
    }else{

        //提示定位失败，重新选择
        [Tools showSettingWithTitle:@"定位开小差了" message:@"没有获取你选择的位置信息，请重新选择地址" failure:^{
            //选择深圳为默认地址
            _isFirstChooseLocation = NO;
        }];
    }

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
    DDLogWarn(@"%@",result.address);

    NSString * string = @"";
    if ([result.addressDetail.city hasSuffix:@"市"]) {
        NSRange range = [result.addressDetail.city rangeOfString:@"市"];//匹配得到的下标
        string = [result.addressDetail.city substringWithRange:NSMakeRange(0, range.location)];//截取范围类的字符串
    }
    else {
        string = result.addressDetail.city;
    }
//    self.textItem.title = string;
    [_textButton setTitle:string forState:UIControlStateNormal];

    [self getAreaWithCityName:string];
}

- (void)getAreaWithCityName:(NSString *)cityName {

    self.cityName = cityName;
    if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"currentCity"] isEqualToString:cityName]) {
        [Tools removeLocalDataWithFile:location160Data];
        [[NSUserDefaults standardUserDefaults] setValue:cityName forKey:@"currentCity"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    WEAK_SELF(self);
    //获取所有支持的城市
    [BATHospitalRegisterTool getCityListWithSuccess:^(BATCityListModel *cityList) {
        STRONG_SELF(self);
        //筛选出当前城市的id
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF.CITY_NAME == %@",cityName];
        NSArray * tmpArray  =  [cityList.Data filteredArrayUsingPredicate:predicate];
        BATCityData * city = [tmpArray firstObject];
        self.cityId = city.CITY_ID;

        //获取当前城市的所有区
        [BATHospitalRegisterTool getArearListWithCity:city success:^(BATAreaModel *areaList) {
            self.areaList = areaList;

            [self.leftTableView reloadData];
            if (self.areaList.Data.count > 0) {
                [self tableView:self.leftTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];

            }
            
        } failure:^(NSError *error) {

        }];

    } failure:^(NSError *error) {
        
    }];
}

- (void)goToChooseCityVC {
    BATChooseCityViewController * chooseCityVC = [BATChooseCityViewController new];
    chooseCityVC.currentCity = self.cityName;
    WEAK_SELF(self);
    [chooseCityVC setCityChanged:^(NSString * cityName) {
        STRONG_SELF(self);
        if (![self.cityName isEqualToString:cityName]) {
            [Tools removeLocalDataWithFile:location160Data];
        }
        [self getAreaWithCityName:cityName];
//        self.textItem.title = cityName;
        [_textButton setTitle:cityName forState:UIControlStateNormal];
    }];
    [self.navigationController pushViewController:chooseCityVC animated:YES];
}

#pragma mark - NET
- (void)hospitalDataRequest {
    NSDictionary *parammeters = @{
                                  @"city_id":@(self.cityId),
                                     @"page":@(self.currentPageIndex),
                                @"page_size":@"10",
                                      @"uid":@"",
                                  @"area_id":@(self.areaId),
                                   @"cat_no":@"",
                                 @"unit_son":@"",
                               @"unit_class":@""
                                  };

    [HTTPTool requestWithURLString:@"/api/HospitalExternal/GetHospitalList" parameters:parammeters type:kGET success:^(id responseObject) {
       
        [self.rightTableView.mj_header endRefreshingWithCompletionBlock:^{
            self.isCompleteRequest = YES;
            [self.rightTableView reloadData];
        }];
        [self.rightTableView.mj_footer endRefreshing];



        [BATHospitalData mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{
                     @"kMAP" : @"MAP",
                     };
        }];
        BATHospitalModel * hospitalList = [BATHospitalModel mj_objectWithKeyValues:responseObject];
        if (hospitalList.RecordsCount == 0) {
            [self showText:@"获取医院列表为空，请换个区县"];
        }
        if (hospitalList.ResultCode == 0) {
            if (self.currentPageIndex == 0) {
                self.dataArray = [NSMutableArray array];
            }

            [self.dataArray addObjectsFromArray:hospitalList.Data];

            if (self.dataArray.count >= hospitalList.RecordsCount) {
                [self.rightTableView.mj_footer endRefreshingWithNoMoreData];
                if (self.dataArray.count == 0) {
                    //没有数据
                    MJRefreshAutoGifFooter * footer = (MJRefreshAutoGifFooter *)self.rightTableView.mj_footer;
                    [footer setTitle:@"" forState:MJRefreshStateNoMoreData];
                }
                else {
                    //有数据
                    MJRefreshAutoGifFooter * footer = (MJRefreshAutoGifFooter *)self.rightTableView.mj_footer;
                    [footer setTitle:@"已经全部加载完毕" forState:MJRefreshStateNoMoreData];
                }
            }

            [self.rightTableView reloadData];
        }

    } failure:^(NSError *error) {
        [self.rightTableView.mj_header endRefreshingWithCompletionBlock:^{
            self.isCompleteRequest = YES;
            [self.rightTableView reloadData];
        }];
        [self.rightTableView.mj_footer endRefreshing];
        self.currentPageIndex --;
        if (self.currentPageIndex < 0) {
            self.currentPageIndex = 0;
        }
        
        if(!NET_STATION){
            [self.defaultView showDefaultView];
        }
    }];
}

#pragma mark - layout
- (void)pagesLayout {
    self.isPopAction = YES;
    self.beginTime = [Tools getCurrentDateStringByFormat:@"yyyy-MM-dd HH:mm:ss"];
//    WEAK_SELF(self);
//    UIBarButtonItem * imageItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"iconfont-dizhi"] style:UIBarButtonItemStylePlain handler:^(id sender) {
//        STRONG_SELF(self);
//        [self goToChooseCityVC];
//    }];
//    self.navigationItem.rightBarButtonItems = @[self.textItem,imageItem];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:self.textButton];
    barItem.tintColor = [UIColor orangeColor];
    self.navigationItem.rightBarButtonItem = barItem;

    [self.view addSubview:self.leftTableView];
    [self.leftTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.view);
        make.width.mas_equalTo(100);
    }];
    [self.view addSubview:self.rightTableView];
    [self.rightTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self.view);
        make.width.mas_equalTo(SCREEN_WIDTH - 100);
    }];
    
    [self.view addSubview:self.defaultView];
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.top.equalTo(self.view);
    }];
}

#pragma mark - setter && getter
//- (UIBarButtonItem *)textItem {
//    if (!_textItem) {
//        WEAK_SELF(self);
//        _textItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"" style:UIBarButtonItemStylePlain handler:^(id sender) {
//            STRONG_SELF(self);
//            [self goToChooseCityVC];
//        }];
//    }
//    return _textItem;
//}

- (void)navBtnCLick{
    
    [self goToChooseCityVC];
    
}

- (UIButton *)textButton{
    if (!_textButton) {
        _textButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_textButton setImage:[UIImage imageNamed:@"iconfont-dizhi"] forState:UIControlStateNormal];
        [_textButton setImage:[UIImage imageNamed:@"iconfont-dizhi"] forState:UIControlStateHighlighted];
        [_textButton addTarget:self action:@selector(navBtnCLick) forControlEvents:UIControlEventTouchUpInside];
        [_textButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _textButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        //    [rightBtn sizeToFit];
        [_textButton setFrame:CGRectMake(0, 0, 100, 40)];
        
        //偏移20最佳
        _textButton.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        _textButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    }
    
    return _textButton;
}


- (UITableView *)leftTableView {
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _leftTableView.tableFooterView = [UIView new];
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _leftTableView.bounces = NO;
        _leftTableView.backgroundColor = UIColorFromRGB(240, 240, 240, 1);
        _leftTableView.estimatedRowHeight = 44;
        _leftTableView.rowHeight = UITableViewAutomaticDimension;
//        [_leftTableView registerClass:[BATAreaTableViewCell class] forCellReuseIdentifier:LEFT_CELL];
        [_leftTableView registerClass:[BATLeftAreaTableViewCell class] forCellReuseIdentifier:LEFT_CELL];
        
    }
    return _leftTableView;
}

- (UITableView *)rightTableView {
    if (!_rightTableView) {
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        _rightTableView.tableFooterView = [UIView new];
        _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _rightTableView.emptyDataSetSource = self;
        _rightTableView.emptyDataSetDelegate = self;
        _rightTableView.rowHeight = 100.f;
        _rightTableView.backgroundColor = [UIColor clearColor];
        [_rightTableView registerClass:[BATHospitalTableViewCell class] forCellReuseIdentifier:RIGHT_CELL];

        WEAK_SELF(self);
//        MJRefreshNormalHeader * header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            STRONG_SELF(self);
//            self.currentPageIndex = 0;
//            [self.rightTableView.mj_footer resetNoMoreData];
//            [self hospitalDataRequest];
//        }];
//        header.lastUpdatedTimeLabel.hidden = YES;
//        header.stateLabel.hidden = YES;
//        header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        
        _rightTableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.currentPageIndex = 0;
            [self.rightTableView.mj_footer resetNoMoreData];
            [self hospitalDataRequest];
        }];
        
;


//        MJRefreshAutoNormalFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//            STRONG_SELF(self);
//            self.currentPageIndex ++;
//            [self hospitalDataRequest];
//        }];
//        footer.refreshingTitleHidden = YES;
//        [footer setTitle:@"" forState:MJRefreshStateIdle];
//        footer.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        _rightTableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.currentPageIndex ++;
            [self hospitalDataRequest];
        }];
//        _rightTableView.mj_footer.hidden = YES;

    }
    return _rightTableView;
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
            
            [self.textButton setTitle:@"深圳" forState:UIControlStateNormal];
            [self getAreaWithCityName:@"深圳"];
        }];
        
    }
    return _defaultView;
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
