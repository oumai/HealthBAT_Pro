//
//  BATMyFansListViewController.m
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/5/14.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATMyFansListViewController.h"
#import "BATMyFansListModel.h"
#import "BATMyFansListCell.h"
#import "UIViewController+Message.h"
#import "BATPerson.h"
//#import "UIScrollView+EmptyDataSet.h"
#import "BATPersonDetailController.h"
#import "BATEmptyDataView.h"
#import "BATTableViewPlaceHolder.h"

@interface BATMyFansListViewController ()<UITableViewDelegate, UITableViewDataSource, BATMyFansListCellDelegate, BATTableViewPlaceHolderDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *dataSource;
@property(nonatomic, assign) NSInteger currentPage;
@property(nonatomic, assign) NSInteger pageSize;
@property(nonatomic, strong) BATPerson *loginUserModel;
/** <#属性描述#> */
@property (nonatomic, strong) BATEmptyDataView *emptyDataView;

@end

@implementation BATMyFansListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    
    self.loginUserModel = PERSON_INFO;
    
    BOOL isMyFans =  [self.accountID isEqualToString:[NSString stringWithFormat:@"%ld", (long)self.loginUserModel.Data.AccountID]];
    self.title = isMyFans ? @"我的粉丝" : @"TA的粉丝";
    
    [self setupRefresh];
    
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
    dictM[@"accountId"] = self.accountID;
    NSString *loginUserId = [NSString stringWithFormat:@"%ld",(long)self.loginUserModel.Data.AccountID];
    if ([loginUserId isEqualToString:self.accountID]) {
        dictM[@"accountId"] = @(0);
    }else{
        dictM[@"accountId"] = self.accountID;
    }
    
    [HTTPTool requestWithURLString:@"/api/dynamic/GetFans" parameters:dictM type:kGET success:^(id responseObject) {
        
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (_currentPage == 0) {
            [self.dataSource removeAllObjects];
        }
        
        //        NSLog(@"---------%@",responseObject);
        
        NSArray *moreData =  [BATMyFansListModel mj_objectArrayWithKeyValuesArray:responseObject[@"Data"]];
        
        [self.dataSource addObjectsFromArray:moreData];
        
        if (moreData.count < _pageSize) {
            [self.tableView.mj_footer setHidden:YES];
        }else{
            [self.tableView.mj_footer setHidden:NO];
        }
        
        [self.tableView bat_reloadData];
        
        
    } failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        
        [self.tableView bat_reloadData];
    }];
    
    
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BATMyFansListCell *myFansCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BATMyFansListCell class])];
    myFansCell.delegate = self;
    myFansCell.fansListModel = self.dataSource[indexPath.row];
    return myFansCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BATMyFansListModel *fansModel = self.dataSource[indexPath.row];
    
    BATPersonDetailController *personDetailVC = [[BATPersonDetailController alloc]init];
    personDetailVC.accountID = fansModel.AccountID;
    
    [self.navigationController pushViewController:personDetailVC animated:YES];
    
}

#pragma mark - 关注 / 取消按钮事件

- (void)requestFollow:(BATMyFansListModel *)fansModel focusBtn:(UIButton *)focusBtn
{
    
    NSString *cancelOperationURL = @"/api/dynamic/CancelOperation";
    NSString *executeOperationURL = @"/api/dynamic/ExecuteOperation";
    NSString *operationURL = fansModel.IsUserFollow ? cancelOperationURL : executeOperationURL;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"3" forKey:@"RelationType"];
    [dict setObject:fansModel.AccountID forKey:@"RelationID"];
    
    
    [HTTPTool requestWithURLString:operationURL parameters:dict type:kPOST success:^(id responseObject) {
        
        fansModel.IsUserFollow = !fansModel.IsUserFollow;
        focusBtn.selected = fansModel.IsUserFollow;
        
        [self.tableView bat_reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - CellDelegate

- (void)focusButtonDidClick:(UIButton *)focusBtn fansModel:(BATMyFansListModel *)fansModel{
    
    if (!LOGIN_STATION) {
        PRESENT_LOGIN_VC;
        return ;
    }
    
    if (fansModel.IsUserFollow) {
        WeakSelf
        [self showAlertSureAndCancelWithTitle:@"温馨提示" message:@"确认取消关注?" sure:^(UIAlertAction *action) {
            [weakSelf requestFollow:fansModel focusBtn:(UIButton *)focusBtn];
            
        } cancel:^(UIAlertAction *action) {
            
        }];
    }else{
        
        [self requestFollow:fansModel focusBtn:focusBtn];
    }
    
}

#pragma mark - lazy load

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT- 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 70;
        _tableView.tableFooterView = [[UIView alloc]init];
        [_tableView registerClass:[BATMyFansListCell class] forCellReuseIdentifier:NSStringFromClass([BATMyFansListCell class])];
        _tableView.bat_separatorInsetEdge = UIEdgeInsetsMake(0, 0, 0, 0);
        
    }
    return _tableView;
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
