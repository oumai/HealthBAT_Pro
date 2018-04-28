//
//  BATMyAttendUserListViewController.m
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/5/13.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATMyAttendUserListViewController.h"
#import "BATMyAttendUserListCell.h"
#import "BATMyAttendUserListModel.h"
#import "BATTableViewPlaceHolder.h"
#import "BATPersonDetailController.h"
#import "BATPerson.h"
#import "BATEmptyDataView.h"

@interface BATMyAttendUserListViewController ()<UITableViewDelegate, UITableViewDataSource, BATMyAttendUserListCellDelegat, BATTableViewPlaceHolderDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataSouce;
@property (nonatomic, assign)NSInteger currentPage;
@property (nonatomic, assign)NSInteger pageSize;
@property (nonatomic, strong)BATPerson *loginUserModel;
@property (nonatomic, strong)NSString *loginUserId;
@property (nonatomic, strong) BATEmptyDataView *emptyDataView;

@end

@implementation BATMyAttendUserListViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadDataRequest];
    NSLog(@"----");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    self.loginUserModel = PERSON_INFO;
    self.loginUserId  = [NSString stringWithFormat:@"%ld",(long)self.loginUserModel.Data.AccountID];
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
    
    
    self.tableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshRequest)];
    self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshRequest)];
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
- (void)loadDataRequest{
    
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    dictM[@"pageIndex"] = @(_currentPage);
    dictM[@"pageSize"] = @(_pageSize);
    NSString *loginUserId = [NSString stringWithFormat:@"%ld",(long)self.loginUserModel.Data.AccountID];
    if ([loginUserId isEqualToString:self.accountID]) {
        dictM[@"accountId"] = @(0);
    }else{
        dictM[@"accountId"] = self.accountID;
    }
    
    
    [HTTPTool requestWithURLString:@"/api/dynamic/GetMyFollowUser" parameters:dictM type:kGET success:^(id responseObject) {
        
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (_currentPage == 0) {
            [self.dataSouce removeAllObjects];
        }
        
        NSArray *moreData =  [BATMyAttendUserListModel mj_objectArrayWithKeyValuesArray:responseObject[@"Data"]];
        [self.dataSouce addObjectsFromArray:moreData];
        if (moreData.count < _pageSize) {
            [self.tableView.mj_footer setHidden:YES];
        }else{
            [self.tableView.mj_footer setHidden:NO];
        }
        
        for (BATMyAttendUserListModel *userListModel in self.dataSouce) {
            if ([[NSString stringWithFormat:@"%ld",(long)self.loginUserModel.Data.AccountID] isEqualToString:self.accountID]) {
                userListModel.isAttend = YES;
            }else{
                userListModel.isAttend = NO;
            }
        }
        
        [self.tableView bat_reloadData];
        
        
    } failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        [self.tableView bat_reloadData];
    }];
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSouce.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    BATMyAttendUserListCell *userlistCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BATMyAttendUserListCell class])];
    userlistCell.selectionStyle = UITableViewCellSelectionStyleNone;
    userlistCell.delegate = self;
    userlistCell.userID = self.accountID;
    userlistCell.userListModel = self.dataSouce[indexPath.row];
    return userlistCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BATMyAttendUserListModel *userModel = self.dataSouce[indexPath.row];
    
    BATPersonDetailController *personDetailVC = [[BATPersonDetailController alloc]init];
    personDetailVC.accountID = userModel.AccountID;
    
    [self.navigationController pushViewController:personDetailVC animated:YES];
    
}
#pragma mark - 关注或取消关注

- (void)operationRequest:(UIButton *)focusBtn userModel:(BATMyAttendUserListModel *)userModel{
    NSString *logoinUserId = [NSString stringWithFormat:@"%ld",(long)self.loginUserModel.Data.AccountID];
    
    NSString *operationURL = nil;
    NSString *cancelOperationURL = @"/api/dynamic/CancelOperation";
    NSString *executeOperationURL = @"/api/dynamic/ExecuteOperation";
    
    if ([logoinUserId isEqualToString:self.accountID]) {
        
        operationURL = userModel.isAttend ? cancelOperationURL : executeOperationURL;
    }else{
        
        operationURL = userModel.IsUserFollow ? cancelOperationURL : executeOperationURL;
    }
    
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    [dictM setObject:@"3" forKey:@"RelationType"];
    [dictM setObject:userModel.AccountID forKey:@"RelationID"];
    
    [HTTPTool requestWithURLString:operationURL parameters:dictM type:kPOST success:^(id responseObject) {
        
        
        if ([logoinUserId isEqualToString:self.accountID]) {
            userModel.isAttend = !userModel.isAttend;
        }else{
            userModel.IsUserFollow = !userModel.IsUserFollow;
        }
        
        [self.tableView bat_reloadData];
        
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark - CellDelegate

- (void)focuseButtonDidClick:(UIButton *)focusBtn userModel:(BATMyAttendUserListModel *)userModel{
    if (!LOGIN_STATION) {
        PRESENT_LOGIN_VC;
        return ;
    }
    //对自己主页的已经关注用户操作
    if (userModel.isAttend ) { //已关注
        WeakSelf
        [self showAlertSureAndCancelWithTitle:@"温馨提示" message:@"是否取消关注？" sure:^(UIAlertAction *action) {
            [weakSelf operationRequest:focusBtn userModel:userModel];
            
            
        } cancel:^(UIAlertAction *action) {
            
        }];
    }else{
        
        //在他人主页对已经自己已经关注的用户操作
        if (![self.loginUserId isEqualToString:self.accountID]) {
            if (userModel.IsUserFollow ) {
                WeakSelf
                [self showAlertSureAndCancelWithTitle:@"温馨提示" message:@"是否取消关注？" sure:^(UIAlertAction *action) {
                    [weakSelf operationRequest:focusBtn userModel:userModel];
                    
                    
                } cancel:^(UIAlertAction *action) {
                    
                }];
                
                
            }else{
                //在他人主页对自己未关注的用户加关注
                [self operationRequest:focusBtn userModel:userModel];
            }
            
        }else{
            //自己主页对未关注的用户操作
            [self operationRequest:focusBtn userModel:userModel];
        }
        
    }
    
    
    
}


#pragma mark - lazyload

- (NSMutableArray *)dataSouce{
    if (!_dataSouce) {
        _dataSouce = [NSMutableArray array];
    }
    return _dataSouce;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 45 - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 70;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.separatorColor = UIColorFromHEX(0xe0e0e0, 1);
        [_tableView registerClass:[BATMyAttendUserListCell class] forCellReuseIdentifier:NSStringFromClass([BATMyAttendUserListCell class])];
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
