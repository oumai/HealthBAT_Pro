//
//  BATMyFollowViewController.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/30.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATMyFollowViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "BATMyFollowTableViewCell.h"
#import "BATUserPersonCenterViewController.h"
#import "BATMyFollowUserModel.h"

@interface BATMyFollowViewController () <UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

/**
 *  数据源
 */
@property (nonatomic,strong) NSMutableArray *dataSource;

/**
 *  页码
 */
@property (nonatomic,assign) NSInteger pageIndex;

/**
 *  每页显示条数
 */
@property (nonatomic,assign) NSInteger pageSize;

@property (nonatomic,assign) BOOL isCompleteRequest;

@property (nonatomic,strong) BATDefaultView *defaultView;

@end

@implementation BATMyFollowViewController

- (void)dealloc
{
    DDLogWarn(@"%@",self);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _myFollowView.tableView.delegate = nil;
    _myFollowView.tableView.dataSource = nil;
    _myFollowView.tableView.emptyDataSetSource = nil;
    _myFollowView.tableView.emptyDataSetDelegate = nil;
}

- (void)loadView
{
    [super loadView];
    
    if (_myFollowView == nil) {
        _myFollowView = [[BATMyFollowView alloc] init];
        _myFollowView.tableView.delegate = self;
        _myFollowView.tableView.dataSource = self;
        _myFollowView.tableView.emptyDataSetSource = self;
        _myFollowView.tableView.emptyDataSetDelegate = self;
        [self.view addSubview:_myFollowView];
        
        WEAK_SELF(self);
        _myFollowView.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.pageIndex = 0;
            [self.myFollowView.tableView.mj_footer resetNoMoreData];
            [self requestGetMoreRecommendDoctorAndFriends];
        }];
        
        _myFollowView.tableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.pageIndex++;
            [self requestGetMoreRecommendDoctorAndFriends];
        }];
        
        _myFollowView.tableView.mj_footer.hidden = YES;
        
        [_myFollowView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.edges.equalTo(self.view);
        }];
        
        [_myFollowView addSubview:self.defaultView];
        [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.left.top.equalTo(self.view);
        }];

    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_myFollowView.tableView.mj_header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshFollowState:) name:BATRefreshFollowStateNotification object:nil];
    
    self.title =  @"我的关注";
    
    [_myFollowView.tableView registerNib:[UINib nibWithNibName:@"BATMyFollowTableViewCell" bundle:nil] forCellReuseIdentifier:@"BATMyFollowTableViewCell"];
    
    _dataSource = [NSMutableArray array];
    _pageSize = 10;
    _pageIndex = 0;
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

#pragma mark - UITableViewDataSource
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
    return 70.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BATMyFollowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATMyFollowTableViewCell" forIndexPath:indexPath];
    
    if (_dataSource.count > 0) {
        cell.indexPath = indexPath;
        BATMyFollowUserData *myFollowUserData = _dataSource[indexPath.row];
        [cell configrationCell:myFollowUserData];
        
        WEAK_SELF(self);
        cell.followUser = ^(){
            STRONG_SELF(self);
            [self requestFollow:myFollowUserData indexPath:indexPath];
        };
        
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BATMyFollowUserData *myFollowUserData = _dataSource[indexPath.row];
    BATUserPersonCenterViewController *userPersonCenterVC = [[BATUserPersonCenterViewController alloc] init];
    userPersonCenterVC.AccountID = myFollowUserData.AccountID;
    userPersonCenterVC.AccountType = myFollowUserData.AccountType;
    userPersonCenterVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:userPersonCenterVC animated:YES];
}

#pragma mark - DZNEmptyDataSetSource
//- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
//
//    return -50;
//}
//- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
//
//    if (!self.isCompleteRequest) {
//        return nil;
//    }
//
//    return [UIImage imageNamed:@"无数据"];
//}
//
////返回标题文字
//- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
//    NSString *text = @"";
//    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f], NSForegroundColorAttributeName: [UIColor darkGrayColor]};
//    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
//}
//
////返回详情文字
//- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
//
//    if (!self.isCompleteRequest) {
//        return nil;
//    }
//
//    NSString *text = BAT_NO_DATA;
//    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
//    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
//    paragraph.alignment = NSTextAlignmentCenter;
//    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:16.0f], NSForegroundColorAttributeName: [UIColor lightGrayColor], NSParagraphStyleAttributeName: paragraph};
//    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
//}


#pragma mark - NET

#pragma mark - 获取更多推荐医生或者好友
- (void)requestGetMoreRecommendDoctorAndFriends
{
    [HTTPTool requestWithURLString:@"/api/Account/MyFriends" parameters:@{@"pageIndex":@(_pageIndex),@"pageSize":@(_pageSize),@"accountId":@"",@"keyword":@""} type:kGET success:^(id responseObject) {
        
        [_myFollowView.tableView.mj_header endRefreshingWithCompletionBlock:^{
            self.isCompleteRequest = YES;
            [self.myFollowView.tableView reloadData];
        }];
        [_myFollowView.tableView.mj_footer endRefreshing];
        
        if (_pageIndex == 0) {
            [_dataSource removeAllObjects];
        }
        
        BATMyFollowUserModel *myFollowUserModel = [BATMyFollowUserModel mj_objectWithKeyValues:responseObject];
        
        [_dataSource addObjectsFromArray:myFollowUserModel.Data];
        
        if (myFollowUserModel.RecordsCount > 0) {
            _myFollowView.tableView.mj_footer.hidden = NO;
        } else {
            _myFollowView.tableView.mj_footer.hidden = YES;
        }
        
        if (_dataSource.count == myFollowUserModel.RecordsCount) {
            [_myFollowView.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        [_myFollowView.tableView reloadData];
        
        if(_dataSource.count == 0){
            [self.defaultView showDefaultView];
        }
        
    } failure:^(NSError *error) {
        [_myFollowView.tableView.mj_header endRefreshingWithCompletionBlock:^{
            self.isCompleteRequest = YES;
            [self.myFollowView.tableView reloadData];
        }];
        [_myFollowView.tableView.mj_footer endRefreshing];
        _pageIndex--;
        if (_pageIndex < 0) {
            _pageIndex = 0;
        }
        
        [self.defaultView showDefaultView];
    }];
}

#pragma mark - 关注或取消关注
- (void)requestFollow:(BATMyFollowUserData *)model indexPath:(NSIndexPath *)indexPath
{
    [HTTPTool requestWithURLString:@"/api/Account/Focus" parameters:@{@"accountId":@(model.AccountID),@"isFocus":@(!model.IsFollowed)} type:kPOST success:^(id responseObject) {
        
        model.IsFollowed = !model.IsFollowed;
        
        [_dataSource replaceObjectAtIndex:indexPath.row withObject:model];
        
        [_myFollowView.tableView reloadData];
        
//        [[NSNotificationCenter defaultCenter] postNotificationName:BATRefreshFindDataNotification object:nil];
        
    } failure:^(NSError *error) {
        
    }];
    
//    NSDictionary *params = @{@"BeFollowedAccountID":@(model.AccountID), @"IsFollowing":@(!model.IsFollowed)};
//    
//    [HTTPTool requestWithURLString:@"/api/Account/Follow" parameters:params type:kPOST success:^(id responseObject) {
//        
//        model.IsFollowed = !model.IsFollowed;
//        
//        [_dataSource replaceObjectAtIndex:indexPath.row withObject:model];
//        
//        [_myFollowView.tableView reloadData];
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:BATRefreshFindDataNotification object:nil];
//        
//    } failure:^(NSError *error) {
//        
//    }];
}

#pragma mark - Action

#pragma mark 刷新关注状态
- (void)refreshFollowState:(NSNotification *)notif
{
    NSDictionary *dic = [notif object];
    
    NSInteger accountId = [[dic objectForKey:@"AccountID"] integerValue];
    BOOL isFollowed = [[dic objectForKey:@"IsFollowed"] boolValue];
    
    for (int i = 0; i < _dataSource.count; i++) {
        BATMyFollowUserData *model = [_dataSource objectAtIndex:i];
        if (model.AccountID == accountId) {
            model.IsFollowed = isFollowed;
            [_dataSource replaceObjectAtIndex:i withObject:model];
            break;
        }
    }
    [_myFollowView.tableView reloadData];
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
            
            [self.myFollowView.tableView.mj_header beginRefreshing];
        }];
        
    }
    return _defaultView;
}
@end
