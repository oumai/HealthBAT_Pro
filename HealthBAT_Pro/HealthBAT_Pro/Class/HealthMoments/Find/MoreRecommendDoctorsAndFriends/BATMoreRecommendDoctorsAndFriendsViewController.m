//
//  BATMoreRecommendDoctorsAndFriendsViewController.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/29.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATMoreRecommendDoctorsAndFriendsViewController.h"
#import "UIScrollView+EmptyDataSet.h"
//#import "BATRecommendDoctorTableViewCell.h"
#import "BATRecommendUserModel.h"
//#import "BATRecommendFriendsTableViewCell.h"
#import "BATFindSearchViewController.h"
#import "BATUserPersonCenterViewController.h"
#import "BATRecommendUserTableViewCell.h"

@interface BATMoreRecommendDoctorsAndFriendsViewController () <UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

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

@implementation BATMoreRecommendDoctorsAndFriendsViewController

- (void)dealloc
{
    DDLogWarn(@"%@",self);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _moreRecommendDoctorAndFriendsView.tableView.delegate = nil;
    _moreRecommendDoctorAndFriendsView.tableView.dataSource = nil;
    _moreRecommendDoctorAndFriendsView.tableView.emptyDataSetSource = nil;
    _moreRecommendDoctorAndFriendsView.tableView.emptyDataSetDelegate = nil;
}

- (void)loadView
{
    [super loadView];
    
    if (_moreRecommendDoctorAndFriendsView == nil) {
        _moreRecommendDoctorAndFriendsView = [[BATMoreRecommendDoctorAndFriendsView alloc] init];
        _moreRecommendDoctorAndFriendsView.tableView.delegate = self;
        _moreRecommendDoctorAndFriendsView.tableView.dataSource = self;
        [_moreRecommendDoctorAndFriendsView.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _moreRecommendDoctorAndFriendsView.tableView.emptyDataSetSource = self;
        _moreRecommendDoctorAndFriendsView.tableView.emptyDataSetDelegate = self;
        [self.view addSubview:_moreRecommendDoctorAndFriendsView];
        
        WEAK_SELF(self);
        _moreRecommendDoctorAndFriendsView.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.pageIndex = 0;
            [self.moreRecommendDoctorAndFriendsView.tableView.mj_footer resetNoMoreData];
            [self requestGetMoreRecommendDoctorAndFriends];
        }];
        
        _moreRecommendDoctorAndFriendsView.tableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.pageIndex++;
            [self requestGetMoreRecommendDoctorAndFriends];
        }];
        
        _moreRecommendDoctorAndFriendsView.tableView.mj_footer.hidden = YES;
        
        [_moreRecommendDoctorAndFriendsView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.edges.equalTo(self.view);
        }];
    }
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchRightBtnAction)];
    
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;

    
    [self.view addSubview:self.defaultView];
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.top.equalTo(self.view);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshFollowState:) name:BATRefreshFollowStateNotification object:nil];
    
    if (_recommendType == BATRecommendFriends) {
         self.title =  @"推荐老师";
    } else if (_recommendType == BATRecommendDoctors) {
         self.title =  @"推荐医生";
    } else if (_recommendType == BATRecommendHobby) {
        self.title =  @"可能感兴趣的人";
    }
    
//    [_moreRecommendDoctorAndFriendsView.tableView registerNib:[UINib nibWithNibName:@"BATRecommendDoctorTableViewCell" bundle:nil] forCellReuseIdentifier:@"BATRecommendDoctorTableViewCell"];
//    
//    [_moreRecommendDoctorAndFriendsView.tableView registerNib:[UINib nibWithNibName:@"BATRecommendFriendsTableViewCell" bundle:nil] forCellReuseIdentifier:@"BATRecommendFriendsTableViewCell"];
    
    [_moreRecommendDoctorAndFriendsView.tableView registerNib:[UINib nibWithNibName:@"BATRecommendUserTableViewCell" bundle:nil] forCellReuseIdentifier:@"BATRecommendUserTableViewCell"];
    
    _dataSource = [NSMutableArray array];
    _pageSize = 10;
    _pageIndex = 0;
    
    [_moreRecommendDoctorAndFriendsView.tableView.mj_header beginRefreshing];
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewAutomaticDimension;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 70;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BATRecommendUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATRecommendUserTableViewCell" forIndexPath:indexPath];
    
    if (_recommendType == BATRecommendFriends) {
        if (_dataSource.count > 0) {
            
            cell.indexPath = indexPath;
            
            BATRecommendUserData *recommendUserData = _dataSource[indexPath.row];
            [cell configrationCell:recommendUserData];
            
            WEAK_SELF(self);
            cell.followUser = ^(){
                STRONG_SELF(self);
                [self requestFollow:recommendUserData indexPath:indexPath];
            };
            
        }

    } else {
        if (_dataSource.count > 0) {
            cell.indexPath = indexPath;
            BATRecommendUserData *recommendUserData = _dataSource[indexPath.row];
            [cell configrationCell:recommendUserData];
            
            WEAK_SELF(self);
            cell.followUser = ^(){
                STRONG_SELF(self);
                [self requestFollow:recommendUserData indexPath:indexPath];
            };
            
        }
    }

    return cell;

    
//    if (_recommendType == BATRecommendFriends) {
//        BATRecommendFriendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATRecommendFriendsTableViewCell" forIndexPath:indexPath];
//        
//        if (_dataSource.count > 0) {
//            
//            cell.indexPath = indexPath;
//
//            BATRecommendUserData *recommendUserData = _dataSource[indexPath.row];
//            [cell configrationCell:recommendUserData];
//            
//            WEAK_SELF(self);
//            cell.followUser = ^(){
//                STRONG_SELF(self);
//                [self requestFollow:recommendUserData indexPath:indexPath];
//            };
//            
//        }
//        
//        
//        return cell;
//    }
//    
//    BATRecommendDoctorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATRecommendDoctorTableViewCell" forIndexPath:indexPath];
//    
//    if (_dataSource.count > 0) {
//        cell.indexPath = indexPath;
//        BATRecommendUserData *recommendUserData = _dataSource[indexPath.row];
//        [cell configrationCell:recommendUserData];
//        
//        WEAK_SELF(self);
//        cell.followUser = ^(){
//            STRONG_SELF(self);
//            [self requestFollow:recommendUserData indexPath:indexPath];
//        };
//        
//    }
//    
//    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BATRecommendUserData *recommendUserData = _dataSource[indexPath.row];
    BATUserPersonCenterViewController *userPersonCenterVC = [[BATUserPersonCenterViewController alloc] init];
    userPersonCenterVC.AccountID = recommendUserData.AccountID;
    userPersonCenterVC.AccountType = recommendUserData.AccountType;
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
//

#pragma mark - NET

#pragma mark - 获取更多推荐医生或者好友
- (void)requestGetMoreRecommendDoctorAndFriends
{
    [HTTPTool requestWithURLString:@"/api/Account/RecommendedUsers" parameters:@{@"pageIndex":@(_pageIndex),@"pageSize":@(_pageSize),@"accountType":@(_recommendType),@"keyword":@""} type:kGET success:^(id responseObject) {
        
        [_moreRecommendDoctorAndFriendsView.tableView.mj_header endRefreshingWithCompletionBlock:^{
            self.isCompleteRequest = YES;
            [self.moreRecommendDoctorAndFriendsView.tableView reloadData];
        }];
        [_moreRecommendDoctorAndFriendsView.tableView.mj_footer endRefreshing];
        
        if (_pageIndex == 0) {
            [_dataSource removeAllObjects];
        }
        
        BATRecommendUserModel *recommendDoctorModel = [BATRecommendUserModel mj_objectWithKeyValues:responseObject];
        
        [_dataSource addObjectsFromArray:recommendDoctorModel.Data];
        
        
        if (recommendDoctorModel.RecordsCount > 0) {
            _moreRecommendDoctorAndFriendsView.tableView.mj_footer.hidden = NO;
        } else {
            _moreRecommendDoctorAndFriendsView.tableView.mj_footer.hidden = YES;
        }
        
        if (_dataSource.count == recommendDoctorModel.RecordsCount) {
            [_moreRecommendDoctorAndFriendsView.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        [_moreRecommendDoctorAndFriendsView.tableView reloadData];
        
        if (_dataSource.count == 0) {
            [self.defaultView showDefaultView];
        }
        
    } failure:^(NSError *error) {
        [_moreRecommendDoctorAndFriendsView.tableView.mj_header endRefreshingWithCompletionBlock:^{
            self.isCompleteRequest = YES;
            [self.moreRecommendDoctorAndFriendsView.tableView reloadData];
        }];
        [_moreRecommendDoctorAndFriendsView.tableView.mj_footer endRefreshing];
        _pageIndex--;
        if (_pageIndex < 0) {
            _pageIndex = 0;
        }
        
        [self.defaultView showDefaultView];
    }];
}

#pragma mark - 关注或取消关注
- (void)requestFollow:(BATRecommendUserData *)model indexPath:(NSIndexPath *)indexPath
{
    [HTTPTool requestWithURLString:@"/api/Account/Focus" parameters:@{@"accountId":@(model.AccountID),@"isFocus":@(!model.IsFollowed)} type:kPOST success:^(id responseObject) {
        
        model.IsFollowed = !model.IsFollowed;
        
        [_dataSource replaceObjectAtIndex:indexPath.row withObject:model];
        
        [_moreRecommendDoctorAndFriendsView.tableView reloadData];
        
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
//        [_moreRecommendDoctorAndFriendsView.tableView reloadData];
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
        BATRecommendUserData *model = [_dataSource objectAtIndex:i];
        if (model.AccountID == accountId) {
            model.IsFollowed = isFollowed;
            [_dataSource replaceObjectAtIndex:i withObject:model];
            break;
        }
    }
    [_moreRecommendDoctorAndFriendsView.tableView reloadData];
}

#pragma mark - 搜索
- (void)searchRightBtnAction
{
    BATFindSearchViewController *findSearchVC = [[BATFindSearchViewController alloc] init];
    findSearchVC.recommendType = _recommendType;
    findSearchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:findSearchVC animated:YES];
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
            [self.moreRecommendDoctorAndFriendsView.tableView.mj_header beginRefreshing];
        }];
        
    }
    return _defaultView;
}
@end
