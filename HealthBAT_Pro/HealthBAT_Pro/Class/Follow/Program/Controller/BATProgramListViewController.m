//
//  BATProgramListViewController.m
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/6/8.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATProgramListViewController.h"
#import "BATProgramDetailViewController.h"
#import "BATProgramListModel.h"

#import "BATProgramListCell.h"
#import "BATEmptyDataView.h"
#import "BATTableViewPlaceHolder.h"


static NSString *const ProgramCellId = @"BATProgramListCell";

@interface BATProgramListViewController ()<UITableViewDelegate, UITableViewDataSource,BATTableViewPlaceHolderDelegate >
/** tableView */
@property (nonatomic, strong) UITableView *tableView;
/** 数据源 */
@property (nonatomic, strong) NSMutableArray *dataSource;
/** 页面大小 */
@property (nonatomic, assign) NSInteger  pageSize;
/** 当前页码 */
@property (nonatomic, assign) NSInteger  currentPage;
//无数据占位 view
@property (nonatomic,strong) BATEmptyDataView *emptyDataView;


@end

@implementation BATProgramListViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromHEX(0xf5f5f5, 1);
    [self.view addSubview:self.tableView];
    
    [self registerCell];
    [self setupRefresh];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.right.mas_equalTo(0);
    }];
}
- (void)registerCell{
    
    [self.tableView registerClass:[BATProgramListCell class] forCellReuseIdentifier:ProgramCellId];
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
#pragma mark - UITabelViewDelegate & UITabelViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BATProgramListCell *programListCell = [tableView dequeueReusableCellWithIdentifier:ProgramCellId];
    programListCell.programListModel = self.dataSource[indexPath.section];
    return programListCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    BATProgramDetailViewController *programDetailVC = [[BATProgramDetailViewController alloc] init];
    BATProgramListModel *programModel = self.dataSource[indexPath.section];
    programDetailVC.templateID = programModel.ID;
    programDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:programDetailVC animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
#pragma mark - setupRefresh

- (void)setupRefresh{
    
    self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshRequest)];
    
    self.tableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshRequest)];
    
    _pageSize = 10;
    
    [self.tableView.mj_header beginRefreshing];
    
}

- (void)headerRefreshRequest{
    _currentPage = 0;
    [self.tableView.mj_footer endRefreshing];
    
    [self loadDataRequest];
}

- (void)footerRefreshRequest{
    _currentPage ++ ;
    [self.tableView.mj_header endRefreshing];
    
    [self loadDataRequest];
}

#pragma mark - Request

- (void)loadDataRequest{
    
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    dictM[@"pageIndex"] = @(_currentPage);
    dictM[@"pageSize"] = @(_pageSize);
    dictM[@"categoryID"] = @(_programType);
    // 方案类型枚举 1：养生 2：减肥 3：美容  4: 塑性
    WeakSelf
    [HTTPTool requestWithURLString:@"/api/trainingteacher/GetMoreProgrammes" parameters:dictM type:kGET success:^(id responseObject) {
        
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        
        if (_currentPage == 0) {
            [weakSelf.dataSource removeAllObjects];
        }
        
//        NSLog(@"---------%@",responseObject);
        
        NSArray *moreData =  [BATProgramListModel mj_objectArrayWithKeyValuesArray:responseObject[@"Data"]];
        
        [weakSelf.dataSource addObjectsFromArray:moreData];
        
        if (moreData.count < _pageSize) {
            [weakSelf.tableView.mj_footer setHidden:YES];
            
        }else{
            [weakSelf.tableView.mj_footer setHidden:NO];
            
        }
        
        [self.tableView bat_reloadData];
        
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_header endRefreshing];
        
        //刷新显示空数据占位 view
        [weakSelf.tableView bat_reloadData];
        
    }];
    
    
}

#pragma mark - lazy load

- (UITableView *)tableView{
        if (!_tableView) {
            _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
            /*
            if(@available(iOS 11.0, *)) {
                _tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-88-45);
            }else{
                
                _tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-45);
            }
             */
            _tableView.backgroundColor = [UIColor whiteColor];
            _tableView.delegate = self;
            _tableView.dataSource = self;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.rowHeight = 339/2;
            _tableView.tableFooterView = [[UIView alloc]init];
            
            
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
