//
//  BATHealthThreeSecondsFoodEnterController.m
//  HealthBAT_Pro
//
//  Created by KM_MAC on 2017/12/12.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHealthThreeSecondsFoodEnterController.h"
#import "BATHealthThreeSecondsFoodEnterCell.h"
#import "BATHealthThreeSecondsFoodEnterTopInfoView.h"
#import "BATHealthThreeSecondsFoodEnterAlertView.h"
#import "UIButton+ImagePosition.h"
#import "BATHealthThreeSecondsRecommedFoodListModel.h"
#import "BATPerson.h"

#import "BATHealthThreeSecondsDetailController.h"
#import "BATEatSearchTwiceViewController.h"
#import "BATHealthThreeSecondsFoodEnterTopDataModel.h"

static NSString *const FoodEnterCellID = @"BATHealthThreeSecondsFoodEnterCell";

@interface BATHealthThreeSecondsFoodEnterController ()<UITableViewDelegate, UITableViewDataSource, BATHealthThreeSecondsFoodEnterAlertViewDelegate>
/**
 顶部搜索控件
 */
@property (nonatomic, strong) UIView *topSearchView;
/**
 顶部数据模型
 */
@property (nonatomic, strong) BATHealthThreeSecondsFoodEnterTopInfoView *topFoodInfoView;
/**
 弹框
 */
@property (nonatomic, strong) BATHealthThreeSecondsFoodEnterAlertView *foodEnterAlertView;
/**
 列表推荐数据模型
 */
@property (nonatomic, strong) BATHealthThreeSecondsRecommedFoodListModel *recommendFoodModel;
/**
 顶部搜索控件
 */
@property (nonatomic, strong) BATHealthThreeSecondsFoodEnterTopDataModel *topDataModel;
@property (nonatomic, strong) UIImage *selImage;
@property (nonatomic, strong) NSString *dateStr;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) BATPerson *loginUserModel;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger currentPage;
@end

@implementation BATHealthThreeSecondsFoodEnterController
- (void)dealloc{
    
    DDLogDebug(@"===BATHealthThreeSecondsFoodEnterController====dealloc");
    
}

- (instancetype)initWithSelImage:(UIImage *)selImage date:(NSString *)date{
    if (self = [super init]) {
        _selImage = selImage;
        _dateStr = date;
    }
    return self;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"添加食物";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.topSearchView];
    [self.view addSubview:self.topFoodInfoView];
    [self.view addSubview:self.tableView];
    self.loginUserModel = PERSON_INFO;
    [self setupRefresh];
    [self requestCalorieWithImage:self.selImage];
    
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    [self.topSearchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.equalTo(@74);
        
    }];
    

    
    [self.topFoodInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.topSearchView.mas_bottom);
            make.left.right.mas_equalTo(0);
            make.height.equalTo(@236);
        
    }];
    
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.topFoodInfoView.mas_bottom);
    }];
    
}

#pragma mark - setupRefresh
/**
 集成刷新控件
 */
- (void)setupRefresh{
    
    self.tableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshRequest)];
    
    _currentPage = 0;
    _pageSize = 10;
    
}
/**
 尾部刷新调用
 */
- (void)footerRefreshRequest{
    _currentPage ++ ;
    [self.tableView.mj_header endRefreshing];
    
    [self loadRecommendFoodListRequest];
}

#pragma mark - 点击顶部搜索调用

- (void)pushSearchViewController{
    
    BATEatSearchTwiceViewController *searchVC = [[BATEatSearchTwiceViewController alloc]init];
    searchVC.dateStr = self.dateStr;
    [self.navigationController pushViewController:searchVC animated:YES];
}


#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BATHealthThreeSecondsFoodEnterCell *cell = [tableView dequeueReusableCellWithIdentifier:FoodEnterCellID];
    cell.recommedFoodModel = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.recommendFoodModel = self.dataSource[indexPath.row];
    self.foodEnterAlertView.recommedFoodModel = self.recommendFoodModel;
    
    [self.foodEnterAlertView show];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(17, 0, SCREEN_WIDTH-17, 20)];
    textLabel.font = [UIFont boldSystemFontOfSize:16];
    textLabel.textAlignment = NSTextAlignmentLeft;
    textLabel.text = @"食物推荐";
    [view addSubview:textLabel];
    
    return view;
}
#pragma mark - BATHealthThreeSecondsFoodEnterAlertViewDelegate

- (void)foodEnterAlertView:(BATHealthThreeSecondsFoodEnterAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //跳转到饮食详情
    if (buttonIndex) {
        [self addFoodDataRequest];
        
    }
    
}

#pragma mark - 根据图片获取卡路里
- (void)requestCalorieWithImage:(UIImage *)image{
    
    [self showProgressWithText:@"正在获取卡路里~"];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.25);
    NSString *base64DataStr = [imageData base64EncodedStringWithOptions:0];
    
    WeakSelf
    [HTTPTool requestWithURLString:@"api/EatCircle/GetCalorieFromPicForHealth" parameters:@{@"imageFile":base64DataStr} type:kPOST success:^(id responseObject) {
        
        if ([[responseObject objectForKey:@"ResultMessage"] isEqualToString:@"操作成功"]) {
            DDLogDebug(@"%@===",responseObject);

            [weakSelf showSuccessWithText:@"获取成功~"];
            weakSelf.topDataModel = [BATHealthThreeSecondsFoodEnterTopDataModel mj_objectWithKeyValues:responseObject[@"Data"]];
            weakSelf.topFoodInfoView.topDataModel = weakSelf.topDataModel;
            
            //获取推荐数据
            [weakSelf loadRecommendFoodListRequest];
            
        }
        
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark - 获取推荐数据
//加载推荐数据
- (void)loadRecommendFoodListRequest{
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    dictM[@"foodName"] = self.topDataModel.name;
    dictM[@"pageSize"] = @(_pageSize);;
    dictM[@"pageIndex"] = @(_currentPage);;
    
    WeakSelf
    [HTTPTool requestWithURLString:@"api/EatCircle/GetRecommendFoodList" parameters:dictM type:kGET success:^(id responseObject) {
        
        
        [weakSelf.tableView.mj_footer endRefreshing];
        
        if (_currentPage == 0) {
            [weakSelf.dataSource removeAllObjects];
        }
        
        DDLogDebug(@"---------%@",responseObject);
        
        NSArray *moreData =  [BATHealthThreeSecondsRecommedFoodListModel mj_objectArrayWithKeyValuesArray:responseObject[@"Data"]];
        
        [weakSelf.dataSource addObjectsFromArray:moreData];
        
        if (moreData.count < _pageSize) {
            [weakSelf.tableView.mj_footer setHidden:YES];
        }else{
            [weakSelf.tableView.mj_footer setHidden:NO];
        }
        
        [weakSelf.tableView reloadData];
        
        
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_footer endRefreshing];
        //请求失败显示占位视图
        [weakSelf.tableView reloadData];
        
    }];
    
}

#pragma mark - 添加(更新)食物信息
- (void)addFoodDataRequest{
    
    [self showProgressWithText:@"正在添加"];
    
    NSMutableDictionary *dictM0 = [NSMutableDictionary dictionary];
    [dictM0 setValue :self.dateStr forKey:@"DataDate"];
    
    NSMutableDictionary *ditcM2 = [NSMutableDictionary dictionary];
    ditcM2[@"FoodName"] = self.recommendFoodModel.MenuName;// 食物名称
    ditcM2[@"Count"] = @(1); //食物份量
    ditcM2[@"Calories"] = self.recommendFoodModel.HeatQty; //卡路里数
    ditcM2[@"OrderNum"] = @(1); //顺序号
    ditcM2[@"ImageUrl"] = self.recommendFoodModel.PictureURL; //顺序号
    
    NSArray *array = @[ditcM2];
    
    [dictM0 setValue :array forKey:@"DietList"];
    
    WeakSelf
    [HTTPTool requestWithURLString:@"api/EatCircle/AddDietDetails" parameters:dictM0 type:kPOST success:^(id responseObject) {
        
        [self showSuccessWithText:@"添加成功"];
        
        DDLogDebug(@"%@======",responseObject);
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            
            //跳转到详情
            BATHealthThreeSecondsDetailController *detailVc = [[BATHealthThreeSecondsDetailController alloc]init];
            detailVc.date = weakSelf.dateStr;
            [weakSelf.navigationController pushViewController:detailVc animated:YES];
            
            
        });
        
    } failure:^(NSError *error) {
        
        [self showErrorWithText:error.localizedDescription];
       
        
    }];
    
}
#pragma mark - lazy Load
- (BATHealthThreeSecondsFoodEnterAlertView *)foodEnterAlertView{
    if (!_foodEnterAlertView) {
        _foodEnterAlertView = [[BATHealthThreeSecondsFoodEnterAlertView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _foodEnterAlertView.delegate = self;
        
    }
    return _foodEnterAlertView;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 175*0.5;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BATHealthThreeSecondsFoodEnterCell class]) bundle:nil] forCellReuseIdentifier:FoodEnterCellID];
        
    }
    return _tableView;
}
- (BATHealthThreeSecondsFoodEnterTopInfoView *)topFoodInfoView{
    if (!_topFoodInfoView) {
        _topFoodInfoView = [[NSBundle mainBundle]loadNibNamed:@"BATHealthThreeSecondsFoodEnterTopInfoView" owner:nil options:nil].lastObject;
        _topFoodInfoView.backgroundColor = [UIColor whiteColor];
        _topFoodInfoView.iconImageView.image = self.selImage;
    }
    return _topFoodInfoView;
}
- (UIView *)topSearchView{
    
    if (!_topSearchView) {
        _topSearchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 56)];
        _topSearchView.backgroundColor = [UIColor whiteColor];
        
        UIButton *searchButton = [[UIButton alloc]initWithFrame:CGRectMake(15, 15, SCREEN_WIDTH - 30, 40)];
        
        searchButton.layer.masksToBounds = YES;
        searchButton.layer.cornerRadius = 20;
        [searchButton setTitleColor:UIColorFromHEX(0x999999, 1) forState:UIControlStateNormal];
        [searchButton setTitleColor:UIColorFromHEX(0x999999, 1) forState:UIControlStateHighlighted];
        searchButton.backgroundColor = UIColorFromHEX(0xeeeeee, 1);
        searchButton.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        searchButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [searchButton setImage:[UIImage imageNamed:@"ic-search"] forState:UIControlStateNormal];
        [searchButton setTitle:@"没有符合的食物，来这里直接搜索吧~" forState:UIControlStateNormal];
        [searchButton setTitle:@"没有符合的食物，来这里直接搜索吧~" forState:UIControlStateHighlighted];
        searchButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
        
        //设置图片与文字之间的间距
        [searchButton setImagePosition:ImagePositionLeft spacing:5];
        
        [searchButton addTarget:self action:@selector(pushSearchViewController) forControlEvents:UIControlEventTouchUpInside];
        
        [_topSearchView addSubview:searchButton];
        
    }
    return _topSearchView;
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
