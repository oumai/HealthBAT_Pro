//
//  BATMyFansViewController.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/30.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATMyFansViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "BATMyFansTableViewCell.h"
#import "BATUserPersonCenterViewController.h"
#import "BATMyFansModel.h"
#import "BATTopicPersonController.h"
#import "BATPerson.h"

#import "BATPersonDetailController.h"
@interface BATMyFansViewController () <UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

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

@implementation BATMyFansViewController

- (void)dealloc
{
    DDLogWarn(@"%@",self);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _myFansView.tableView.delegate = nil;
    _myFansView.tableView.dataSource = nil;
    _myFansView.tableView.emptyDataSetSource = nil;
    _myFansView.tableView.emptyDataSetDelegate = nil;
}

- (void)loadView
{
    [super loadView];
    
    if (_myFansView == nil) {
        _myFansView = [[BATMyFansView alloc] init];
        _myFansView.tableView.delegate = self;
        _myFansView.tableView.dataSource = self;
        _myFansView.tableView.emptyDataSetSource = self;
        _myFansView.tableView.emptyDataSetDelegate = self;
        [self.view addSubview:_myFansView];
        
        WEAK_SELF(self);
        _myFansView.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.pageIndex = 0;
            [self.myFansView.tableView.mj_footer resetNoMoreData];
            [self requestGetMoreRecommendDoctorAndFriends];
        }];
        
        _myFansView.tableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.pageIndex++;
            [self requestGetMoreRecommendDoctorAndFriends];
        }];
        
        _myFansView.tableView.mj_footer.hidden = YES;
        
        [_myFansView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.edges.equalTo(self.view);
        }];
        
        [_myFansView addSubview:self.defaultView];
        [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.left.top.equalTo(self.view);
        }];
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshFollowState:) name:BATRefreshFollowStateNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableViewData) name:@"PersonHeadImageAction" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableViewData) name:@"FANSTABLEVIEWRELOAD" object:nil];
    
    self.title =  @"我的粉丝";
    
    [_myFansView.tableView registerNib:[UINib nibWithNibName:@"BATMyFansTableViewCell" bundle:nil] forCellReuseIdentifier:@"BATMyFansTableViewCell"];
    
    _dataSource = [NSMutableArray array];
    _pageSize = 10;
    _pageIndex = 0;
    
     [_myFansView.tableView.mj_header beginRefreshing];
}

- (void)reloadTableViewData {

    _pageIndex = 0;
    [self requestGetMoreRecommendDoctorAndFriends];
    
}



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
    BATMyFansTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATMyFansTableViewCell" forIndexPath:indexPath];
    if (_dataSource.count > 0) {
        cell.indexPath = indexPath;
        BATMyFansData *myFansData = _dataSource[indexPath.row];
        [cell configrationFansCell:myFansData];
        
        WEAK_SELF(self);
        cell.followUser = ^(){
            STRONG_SELF(self);
            if (myFansData.IsUserFollow) {
                [self showAlertSureAndCancelWithTitle:@"温馨提示" message:@"是否取消" sure:^(UIAlertAction *action) {
                    
                    [self requestFollow:myFansData indexPath:indexPath];
                    
                } cancel:^(UIAlertAction *action) {
                    
                }];
            
            }else {
                
                [self requestFollow:myFansData indexPath:indexPath];
            }
        };
        
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BATMyFansData *myFansData = _dataSource[indexPath.row];
//    BATTopicPersonController *userPersonCenterVC = [[BATTopicPersonController alloc] init];
    
    //新个人主页控制器
    BATPersonDetailController *userPersonCenterVC = [[BATPersonDetailController alloc]init];
    
    userPersonCenterVC.accountID = [NSString stringWithFormat:@"%zd",myFansData.AccountID];
    [self.navigationController pushViewController:userPersonCenterVC animated:YES];
}

#pragma mark - NET

#pragma mark - 获取更多推荐医生或者好友
- (void)requestGetMoreRecommendDoctorAndFriends
{
    NSString *accountID = nil;
    if (self.accountID) {
        accountID = self.accountID;
    }else {
        accountID = @"";
    }
    [HTTPTool requestWithURLString:@"/api/dynamic/GetFans" parameters:@{@"pageIndex":@(_pageIndex),@"pageSize":@(_pageSize),@"accountId":accountID,} type:kGET success:^(id responseObject) {
        
        [_myFansView.tableView.mj_header endRefreshingWithCompletionBlock:^{
            self.isCompleteRequest = YES;
            [self.myFansView.tableView reloadData];
        }];
        [_myFansView.tableView.mj_footer endRefreshing];
        
        if (_pageIndex == 0) {
            [_dataSource removeAllObjects];
        }
        
        BATMyFansModel *myFansModel = [BATMyFansModel mj_objectWithKeyValues:responseObject];
        
        [_dataSource addObjectsFromArray:myFansModel.Data];
        
        BATPerson *person = PERSON_INFO;
        for (BATMyFansData *data in _dataSource) {
            if ([NSString stringWithFormat:@"%zd",person.Data.AccountID] == self.accountID) {
                data.IsShowBtn = YES;
            }else {
                data.IsShowBtn = NO;
            }
        }
        
        if (myFansModel.RecordsCount > 0) {
            _myFansView.tableView.mj_footer.hidden = NO;
        } else {
            _myFansView.tableView.mj_footer.hidden = YES;
        }
        
        if (_dataSource.count == myFansModel.RecordsCount) {
            [_myFansView.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        [_myFansView.tableView reloadData];
        
        if (_dataSource.count == 0) {
            [self.defaultView showDefaultView];
          //  self.defaultView.reloadButton.hidden = NO;
        }
        
    } failure:^(NSError *error) {
        [_myFansView.tableView.mj_header endRefreshing];
        [_myFansView.tableView.mj_footer endRefreshing];
        _pageIndex--;
        if (_pageIndex < 0) {
            _pageIndex = 0;
        }
        
        [self.defaultView showDefaultView];
     //   self.defaultView.reloadButton.hidden = NO;
    }];
}

#pragma mark - 关注或取消关注
- (void)requestFollow:(BATMyFansData *)model indexPath:(NSIndexPath *)indexPath
{
    
    NSString *urlString = nil;
    if (model.IsUserFollow) {
        urlString = @"/api/dynamic/CancelOperation";
       
    }else {
        urlString = @"/api/dynamic/ExecuteOperation";
        
    }

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"3" forKey:@"RelationType"];
    [dict setObject:@(model.AccountID) forKey:@"RelationID"];
   
    [HTTPTool requestWithURLString:urlString parameters:dict type:kPOST success:^(id responseObject) {
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DETAILRELOAD" object:nil];
        model.IsUserFollow = !model.IsUserFollow;
        [_myFansView.tableView reloadData];
        
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
//        [_myFansView.tableView reloadData];
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
        BATMyFansData *model = [_dataSource objectAtIndex:i];
        if (model.AccountID == accountId) {
            model.IsUserFollow = isFollowed;
            [_dataSource replaceObjectAtIndex:i withObject:model];
            break;
        }
    }
    [_myFansView.tableView reloadData];
}


- (BATDefaultView *)defaultView{
    if (!_defaultView) {
        _defaultView = [[BATDefaultView alloc]initWithFrame:CGRectZero];
        _defaultView.backgroundColor = [UIColor whiteColor];
        _defaultView.hidden = YES;
        WEAK_SELF(self);
        [_defaultView setReloadRequestBlock:^{
            STRONG_SELF(self);
            DDLogInfo(@"=====重新开始加载！=====");
           
            self.defaultView.hidden = YES;
            [self.myFansView.tableView.mj_header beginRefreshing];
            
        }];
        
    }
    return _defaultView;
}
@end
