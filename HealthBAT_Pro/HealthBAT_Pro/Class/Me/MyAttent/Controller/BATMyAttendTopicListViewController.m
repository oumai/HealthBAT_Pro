//
//  BATMyAttendTopicListViewController.m
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/5/13.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATMyAttendTopicListViewController.h"
#import "BATMyAttendTopicListCell.h"
#import "BATMyAttendTopicListModel.h"
#import "BATTableViewPlaceHolder.h"
//#import "UIScrollView+EmptyDataSet.h"
#import "BATTopicDetailController.h"
#import "BATPerson.h"
#import "BATEmptyDataView.h"

@interface BATMyAttendTopicListViewController ()<UITableViewDelegate, UITableViewDataSource, BATMyAttendTopicListCellDelegate,BATTableViewPlaceHolderDelegate >
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataSouce;
@property (nonatomic, assign)NSInteger currentPage;
@property (nonatomic, assign)NSInteger pageSize;
@property (nonatomic, strong)BATPerson *loginUserModel;
/** <#属性描述#> */
@property (nonatomic, strong) BATEmptyDataView *emptyDataView;
@end

@implementation BATMyAttendTopicListViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadDataRequest];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loginUserModel = PERSON_INFO;
    [self.view addSubview:self.tableView];
    [self setupRefrsh];
    
    
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

#pragma mark - setupRefrsh
- (void)setupRefrsh{
    
    self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadDataRequest)];
    
    self.tableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshRequest)];
    self.pageSize = 10;
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
#pragma mark -  Request
- (void)loadDataRequest{
    
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    dictM[@"pageIndex"] = @(_currentPage);
    dictM[@"pageSize"] = @(_pageSize);
    
    NSString *loginUserId = [NSString stringWithFormat:@"%ld",(long)self.loginUserModel.Data.AccountID];
    if (![loginUserId isEqualToString:self.accountID]) {
        dictM[@"accountId"] = self.accountID;
    }else{
        dictM[@"accountId"] = @(0);
    }
    WeakSelf
    [HTTPTool requestWithURLString:@"/api/dynamic/GetMyOrOtherTopicList" parameters:dictM type:kGET success:^(id responseObject) {
        
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        
        if (_currentPage == 0) {
            [weakSelf.dataSouce removeAllObjects];
        }
        
//        NSLog(@"%@-------",responseObject);
        NSArray *moreData =  [BATMyAttendTopicListModel mj_objectArrayWithKeyValuesArray:responseObject[@"Data"]];
        
        [weakSelf.dataSouce addObjectsFromArray:moreData];
        
        if (moreData.count < _pageSize) {
            [weakSelf.tableView.mj_footer setHidden:YES];
        }else{
            [weakSelf.tableView.mj_footer setHidden:NO];
        }
        
        [weakSelf.tableView bat_reloadData];
        
        
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView bat_reloadData];
    }];
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSouce.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BATMyAttendTopicListCell *myAttedtTopicCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BATMyAttendTopicListCell class])];
    myAttedtTopicCell.selectionStyle = UITableViewCellSelectionStyleNone;
    myAttedtTopicCell.delegate = self;
    myAttedtTopicCell.topicModel = self.dataSouce[indexPath.row];
    return myAttedtTopicCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BATTopicDetailController *myAttendTopicDetailVC = [[BATTopicDetailController alloc]init];
    BATMyAttendTopicListModel *myAttendTopicModel = self.dataSouce[indexPath.row];
    myAttendTopicDetailVC.ID = myAttendTopicModel.ID;
    [self.navigationController pushViewController:myAttendTopicDetailVC animated:YES];
    
    
    
}
#pragma mark - CelleDelegate && FocusButtonHttp

- (void)operationRequest:(BATMyAttendTopicListModel *)topicModel focusBtn :(UIButton *)focusBtn{
    
    
    
    NSString *cancelOperationUrl = @"/api/dynamic/CancelOperation";
    NSString *executeOperation = @"/api/dynamic/ExecuteOperation";
    
    NSString *operationURL = topicModel.IsTopicFollow ? cancelOperationUrl : executeOperation;
    
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    [dictM setObject:@"2" forKey:@"RelationType"];
    [dictM setObject:topicModel.ID forKey:@"RelationID"];
    
    [HTTPTool requestWithURLString:operationURL parameters:dictM type:kPOST success:^(id responseObject) {
        
//        NSLog(@"%@----",responseObject);
        
        
        topicModel.IsTopicFollow = !topicModel.IsTopicFollow;
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
    
}
- (void)focusButtonDidClick:(UIButton *)btn topicModel:(BATMyAttendTopicListModel *)topicModel{
    if (!LOGIN_STATION) {
        PRESENT_LOGIN_VC;
        return ;
    }
    if (topicModel.IsTopicFollow) {
        
        [self showAlertSureAndCancelWithTitle:@"温馨提示" message:@"是否取消关注" sure:^(UIAlertAction *action) {
            [self operationRequest:topicModel focusBtn:btn];
            
        } cancel:^(UIAlertAction *action) {
            return ;
        }];
    }else{
        
        [self operationRequest:topicModel focusBtn:btn];
    }
}


- (NSMutableArray *)dataSouce{
    if (!_dataSouce) {
        _dataSouce = [NSMutableArray array];
    }
    return _dataSouce;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 45  - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 90;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.separatorColor = UIColorFromHEX(0xe0e0e0, 1);
        [_tableView registerClass:[BATMyAttendTopicListCell class] forCellReuseIdentifier:NSStringFromClass([BATMyAttendTopicListCell class])];
        _tableView.bat_separatorInsetEdge = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return _tableView;
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
