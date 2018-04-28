//
//  BATProgramAddedListViewController.m
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/6/7.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATProgramAddedListViewController.h"
#import "BATProgramDetailViewController.h"
#import "BATProgramViewController.h"

#import "BATProgramEmptyDataView.h"
#import "BATProgramListCell.h"
#import "BATTableViewPlaceHolder.h"

#import "BATProgramListModel.h"
#import "BATPerson.h"



static NSString *const ProgramCellId = @"BATProgramListCell";


@interface BATProgramAddedListViewController ()<UITableViewDelegate, UITableViewDataSource,BATTableViewPlaceHolderDelegate>

/** UITableView */
@property (nonatomic, strong) UITableView *tableView;
/** 数据源 */
@property (nonatomic, strong) NSMutableArray *dataSource;
/** 页码大小 */
@property (nonatomic, assign) NSInteger  pageSize;
/** 当前也 */
@property (nonatomic, assign) NSInteger  currentPage;
/** 查看更多方案 */
@property (nonatomic, strong) UIView *tableViewFooter;
/** 无数据占位 view */
@property (nonatomic, strong) BATProgramEmptyDataView *emptyDataView;
/** 用户 model */
@property (nonatomic, strong) BATPerson *userModel;

@end

@implementation BATProgramAddedListViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"健康关注";
    
    self.userModel = PERSON_INFO;
    [self.view addSubview:self.tableView];
    [self registerCell];
    [self setupRefresh];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self headerRefreshRequest];
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
}
#pragma mark - 无数据 view
#pragma mark - BATTableViewPlaceHolderDelegate

- (UIView *)makePlaceHolderView{
    if (!_emptyDataView) {
        _emptyDataView = [[BATProgramEmptyDataView alloc]initWithFrame:self.tableView.bounds];
        WeakSelf
        _emptyDataView.addButtonBlock = ^{
            [weakSelf pushProgramListVc];
        };
        
    }
    return _emptyDataView;
}

#pragma mark - setupRefresh

- (void)setupRefresh{
    
    self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshRequest)];
    
    self.tableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshRequest)];
    
    
}

- (void)headerRefreshRequest{
    _currentPage = 0;
    _pageSize = 100;
    [self.tableView.mj_footer endRefreshing];
    
    [self loadDataRequest];
}

- (void)footerRefreshRequest{
    _currentPage ++ ;
    
    [self.tableView.mj_header endRefreshing];
    
    [self loadDataRequest];
}


#pragma mark - private

- (void)registerCell{
    [self.tableView registerClass:[BATProgramListCell class] forCellReuseIdentifier:ProgramCellId];
}

- (void)pushProgramListVc{
    
    BATProgramViewController  *programListVc = [[BATProgramViewController alloc]init];
    programListVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:programListVc animated:YES];
    
    
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0 ? CGFLOAT_MIN : 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BATProgramListCell *programCell = [tableView dequeueReusableCellWithIdentifier:ProgramCellId];
    programCell.addedProgramListModel = self.dataSource[indexPath.section];
    return programCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    BATProgramListModel *model = self.dataSource[indexPath.section];
    BATProgramDetailViewController *programDetailVC = [[BATProgramDetailViewController alloc] init];
    
    programDetailVC.templateID = [model.TemplateID integerValue];
    programDetailVC.hidesBottomBarWhenPushed = YES;

    [self.navigationController pushViewController:programDetailVC animated:YES];
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
//点击删除按钮
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self deleteAddedProgramWith:indexPath];
}


#pragma mark - Request
#pragma mark - 加载数据
- (void)loadDataRequest{
    
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    dictM[@"pageIndex"] = @(_currentPage);
    dictM[@"pageSize"] = @(_pageSize);
    
    WeakSelf
    [HTTPTool requestWithURLString:@"/api/trainingteacher/GetMyProgrammes" parameters:dictM type:kGET success:^(id responseObject) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (_currentPage == 0) {
            [weakSelf.dataSource removeAllObjects];
        }
        
        DDLogDebug(@"---------%@",responseObject);
        
        NSArray *moreData =  [BATProgramListModel mj_objectArrayWithKeyValuesArray:responseObject[@"Data"]];
        
        [self.dataSource addObjectsFromArray:moreData];
        
        if (moreData.count < _pageSize) {
            [weakSelf.tableView.mj_footer setHidden:YES];
            //替换 footer
            weakSelf.tableView.tableFooterView = weakSelf.tableViewFooter;
            weakSelf.tableView.tableFooterView.hidden = !weakSelf.dataSource.count;
        }else{
            [weakSelf.tableView.mj_footer setHidden:NO];
            
        }
        
        [weakSelf.tableView bat_reloadData];
        
        
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_header endRefreshing];
        //请求失败显示占位视图
        [weakSelf.tableView bat_reloadData];
    }];
    
    
}
#pragma mark - 方案删除
- (void)deleteAddedProgramWith:(NSIndexPath *)indexPath{
    
    BATProgramListModel *programModel = self.dataSource[indexPath.section];
    
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    dictM[@"templateID"] = programModel.TemplateID;
    WeakSelf
    [HTTPTool requestWithURLString:@"/api/trainingteacher/DelProgramme" parameters:dictM type:kGET success:^(id responseObject) {
        
        if ([responseObject[@"ResultMessage"] isEqualToString:@"操作成功"]) {
            
            [weakSelf.dataSource removeObjectAtIndex:indexPath.section];
            
            [weakSelf.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
            
            if (!weakSelf.dataSource.count) {
                weakSelf.tableView.tableFooterView.hidden = YES;
                [weakSelf.tableView bat_reloadData];
                

           }
        
        }
    } failure:^(NSError *error) {
        [self showErrorWithText:@"请检查网络"];
    }];
    
    
}


#pragma mark - lazy load

- (UITableView *)tableView{
    if (!_tableView) {
       
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
//        if(@available(iOS 11.0, *)) {
//            _tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-88-83-45);
//        }else{
//
//            _tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-49-45);
//        }
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

- (UIView *)tableViewFooter{
    if (!_tableViewFooter) {
        _tableViewFooter = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 126.5)];
        _tableViewFooter.backgroundColor = [UIColor whiteColor];
        UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 116.5)];
        bgImageView.alpha = 0.8;
        bgImageView.image = [UIImage imageNamed:@"Follow_Add_Program_Btn_Bg"];
        UIButton *addMoreProgramBtn = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 163)/2,(126.5 - 45)/2, 163, 45)];
        [addMoreProgramBtn setImage:[UIImage imageNamed:@"Follow_More_Program_Btn_Bg"] forState:UIControlStateNormal];
        [addMoreProgramBtn addTarget:self action:@selector(pushProgramListVc) forControlEvents:UIControlEventTouchUpInside];
        
        [_tableViewFooter addSubview:bgImageView];
        [_tableViewFooter addSubview:addMoreProgramBtn];
    }
    return _tableViewFooter;
}
- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)dealloc{
    
    DDLogDebug(@"%s",__func__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
