//
//  BATTumorOrderListViewController.m
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/9/14.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATTumorOrderListViewController.h"
#import "BATHomeTopPicLinkViewController.h"
#import "BATTumorOrderListCell.h"
#import "BATPerson.h"
#import "BATTableViewPlaceHolder.h"
#import "BATEmptyDataView.h"

#import "BATTumorOrderListModel.h"

static NSString *const orderListCellID = @"BATTumorOrderListCell";

@interface BATTumorOrderListViewController ()<UITableViewDelegate, UITableViewDataSource, BATTableViewPlaceHolderDelegate>
/** UITableView */
@property (nonatomic, strong) UITableView *tableView;
/** 数据源 */
@property (nonatomic, strong) NSMutableArray *dataSource;
/** <#属性描述#> */
@property (nonatomic, assign)NSUInteger  currentPage;
/** <#属性描述#> */
@property (nonatomic, assign)NSUInteger  pageSize;
@property(nonatomic, strong) BATPerson *loginUserModel;
/** 无数据占位 view */
@property (nonatomic, strong) BATEmptyDataView *emptyDataView;

@end

@implementation BATTumorOrderListViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.tableView.mj_header beginRefreshing];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.loginUserModel = PERSON_INFO;
    self.view.backgroundColor = UIColorFromHEX(0xf5f5f5, 1);
    [self.view addSubview:self.tableView];
    [self setupRefresh];
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_equalTo(0);
    }];
}
#pragma mark - 空数据占位 view
#pragma mark - BATTableViewPlaceHolderDelegate
- (UIView *)makePlaceHolderView{
    
    if (!_emptyDataView) {
        _emptyDataView = [[BATEmptyDataView alloc]initWithFrame:self.tableView.bounds];
        WeakSelf
        _emptyDataView.reloadRequestBlock = ^{
            [weakSelf loadDataRequest];
        };
        
    }
    return _emptyDataView;
}

/**
 集成刷新控件
 */
- (void)setupRefresh{
    
    self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshRequest)];
    
    self.tableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshRequest)];
    
    _pageSize = 10;
    
    [self.tableView.mj_header beginRefreshing];
    
}

/**
 头部刷新调用
 */
- (void)headerRefreshRequest{
    _currentPage = 0;
    [self.tableView.mj_footer endRefreshing];
    
    [self loadDataRequest];
}

/**
 尾部刷新调用
 */
- (void)footerRefreshRequest{
    _currentPage ++ ;
    [self.tableView.mj_header endRefreshing];
    
    [self loadDataRequest];
}

- (void)loadDataRequest{
    
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    
    dictM[@"phone"] = self.loginUserModel.Data.PhoneNumber;
    dictM[@"pageSize"] = @(_pageSize);
    dictM[@"state"] = [NSString stringWithFormat:@"%d",_OrderType];
    dictM[@"pageIndex"] = @(_currentPage);
    WeakSelf
    
    [HTTPTool requestWithURLString:@"/api/Tumour/GetOrderLst" parameters:dictM type:kGET success:^(id responseObject) {
        
        DDLogDebug(@"---------%@",responseObject);
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];

        
        if (_currentPage == 0) {
            [weakSelf.dataSource removeAllObjects];
        }
        
        NSArray *moreData =  [BATTumorOrderListModel mj_objectArrayWithKeyValuesArray:responseObject[@"Data"]];
        
        [weakSelf.dataSource addObjectsFromArray:moreData];
        
        if (moreData.count < _pageSize) {
            [weakSelf.tableView.mj_footer setHidden:YES];
        }else{
            [weakSelf.tableView.mj_footer setHidden:NO];
        }
        
        [weakSelf.tableView bat_reloadData];
        
        
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView bat_reloadData];
        
    }];
    
    
}
#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BATTumorOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:orderListCellID];
   
    cell.orderListModel = self.dataSource[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    BATTumorOrderListModel *orderModel = self.dataSource[indexPath.row];
     BATHomeTopPicLinkViewController *webVc = [[BATHomeTopPicLinkViewController alloc]init];
    webVc.url = [NSURL URLWithString:orderModel.LinkUrl];
    [self.navigationController pushViewController:webVc animated:YES];
    

}


#pragma mark - Lazy load
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 45) style:UITableViewStylePlain];
        _tableView.backgroundColor = UIColorFromHEX(0xf5f5f5, 1);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 100;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.tableFooterView = [[UIView alloc]init];
        
        [_tableView registerNib:[UINib nibWithNibName:@"BATTumorOrderListCell" bundle:nil] forCellReuseIdentifier:orderListCellID];
        
        
    }
    return _tableView;
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (void)dealloc{
    
    DDLogDebug(@"%s",__func__);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
