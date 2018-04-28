//
//  BATTrainStudioListViewController.m
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/7/14.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATTrainStudioListViewController.h"
#import "UITableView+SeparatorInsetEdge.h"
#import "BATTableViewPlaceHolder.h"

#import "BATTrainStudioListCell.h"
#import "BATEmptyDataView.h"

#import "BATTrainStudioListModel.h"
#import "BATTrainStudioCourseDetailViewController.h"

#import "BATTrainStudioCourseTextAndImageDetailViewController.h"


static NSString *const TrainStudioListCellId = @"BATTrainStudioListCell";

@interface BATTrainStudioListViewController ()<UITableViewDelegate, UITableViewDataSource, BATTableViewPlaceHolderDelegate>

/** UITableView */
@property (nonatomic, strong) UITableView *tableView;
/** 数据源 */
@property (nonatomic, strong) NSMutableArray *dataSource;
/** 页码大小 */
@property (nonatomic, assign) NSInteger  pageSize;
/** 当前页码 */
@property (nonatomic, assign) NSInteger  currentPage;

/** 无数据占位 view */
@property (nonatomic, strong) BATEmptyDataView *emptyDataView;


@end

@implementation BATTrainStudioListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    
    [self setupRefresh];
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.right.mas_equalTo(0);
    }];
}
#pragma mark - 无数据占位 view
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
#pragma mark - setupRefresh
- (void)setupRefresh{
    
    self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshRequest)];
    
    self.tableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshRequest)];
    
    [self.tableView.mj_header beginRefreshing];
    
}

- (void)headerRefreshRequest{
    [self.tableView.mj_footer endRefreshing];
    _currentPage = 1;
    _pageSize = 10;
    
    [self loadDataRequest];
}

- (void)footerRefreshRequest{
    [self.tableView.mj_header endRefreshing];
    _currentPage ++ ;
    
    [self loadDataRequest];
}

#pragma mark - Request
#pragma mark - 加载数据

- (void)loadDataRequest{
    
    //接口默认是返回都是视频课程
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    dictM[@"category"] = @(self.SubjectType);
    dictM[@"pageIndex"] = @(_currentPage);
    dictM[@"pageSize"] = @(_pageSize);
    
    WeakSelf
    [HTTPTool requestWithMaintenanceURLString:@"/api/Course/BatGetAll" parameters:dictM type:kGET success:^(id responseObject) {
        
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        
        if (_currentPage == 1) {
            [weakSelf.dataSource removeAllObjects];
        }
        
        DDLogDebug(@"---------%@",responseObject);
        
        NSArray *moreData =  [BATTrainStudioListModel mj_objectArrayWithKeyValuesArray:responseObject[@"Data"]];
        
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
        
        //请求失败显示占位视图
        [weakSelf.tableView bat_reloadData];
    }];
    
}
#pragma mark - UITabelViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BATTrainStudioListCell *studioListCell = [tableView dequeueReusableCellWithIdentifier:TrainStudioListCellId];
    studioListCell.SubjectType = self.SubjectType;
    studioListCell.studioListModel = self.dataSource[indexPath.row];
    return studioListCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DDLogDebug(@"---------");
    
    BATTrainStudioListModel *model = self.dataSource[indexPath.row];
    
    //CourseType == 13 图文课程
    if (model.CourseType == 13) {
        BATTrainStudioCourseTextAndImageDetailViewController *detailVC = [[BATTrainStudioCourseTextAndImageDetailViewController alloc]init];
        detailVC.MainContent = model.MainContent;
        detailVC.title = model.CourseTitle;
        detailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
    }else{
        BATTrainStudioCourseDetailViewController *detailVC = [[BATTrainStudioCourseDetailViewController alloc] init];
        detailVC.ID = model.Id;
        detailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    
}
#pragma mark - lazy load

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 50 - 46  ) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedRowHeight = 0;
        _tableView.rowHeight = 105;
        //设置分割线位置
        _tableView.bat_separatorInsetEdge = UIEdgeInsetsMake(0, 10, 0, 0);
        _tableView.separatorColor = UIColorFromHEX(0xe0e0e0, 1);
        _tableView.tableFooterView = [[UIView alloc]init];
        
        [_tableView registerClass:[BATTrainStudioListCell class] forCellReuseIdentifier:TrainStudioListCellId];
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
