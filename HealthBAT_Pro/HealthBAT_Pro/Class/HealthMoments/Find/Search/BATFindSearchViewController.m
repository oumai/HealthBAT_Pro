//
//  BATFindSearchViewController.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/29.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATFindSearchViewController.h"
#import "UIScrollView+EmptyDataSet.h"
//#import "BATRecommendDoctorTableViewCell.h"
#import "BATRecommendUserModel.h"
//#import "BATRecommendFriendsTableViewCell.h"
#import "BATRecommendUserTableViewCell.h"
#import "BATFindSearchBarView.h"

@interface BATFindSearchViewController () <UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,UISearchBarDelegate,UITextFieldDelegate>

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

/**
 *  头部searchBarView
 */
//@property (nonatomic,strong) BATFindSearchBarView *findSearchBarView;
@property (nonatomic,strong) UITextField *searchTF;

/**
 *  关键词
 */
@property (nonatomic,strong) NSString *keyWord;

@property (nonatomic,assign) BOOL isCompleteRequest;

@property (nonatomic,strong) BATDefaultView *defaultView;

@end

@implementation BATFindSearchViewController

- (void)dealloc
{
    DDLogWarn(@"%@",self);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _findSearchView.tableView.delegate = nil;
    _findSearchView.tableView.dataSource = nil;
    _findSearchView.tableView.emptyDataSetSource = nil;
    _findSearchView.tableView.emptyDataSetDelegate = nil;
//    _findSearchBarView.searchBar.delegate = nil;
}

- (void)loadView
{
    [super loadView];
    
    if (_findSearchView == nil) {
        _findSearchView = [[BATFindSearchView alloc] init];
        _findSearchView.tableView.delegate = self;
        _findSearchView.tableView.dataSource = self;
        _findSearchView.tableView.emptyDataSetSource = self;
        _findSearchView.tableView.emptyDataSetDelegate = self;
        [self.view addSubview:_findSearchView];
        
        WEAK_SELF(self);
        _findSearchView.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.pageIndex = 0;
            [self.findSearchView.tableView.mj_footer resetNoMoreData];
            [self requestSearchDoctorAndFriend];
        }];
        
        _findSearchView.tableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.pageIndex++;
            [self requestSearchDoctorAndFriend];
        }];
        
        _findSearchView.tableView.mj_footer.hidden = YES;
        
        [_findSearchView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.edges.equalTo(self.view);
        }];
        
        
        self.navigationItem.hidesBackButton = YES;

        self.navigationItem.titleView = self.searchTF;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"取消" style:UIBarButtonItemStylePlain handler:^(id sender) {
            STRONG_SELF(self);
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
        
        [self.view addSubview:self.defaultView];
        [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.left.top.equalTo(self.view);
        }];

//        _findSearchBarView = [[BATFindSearchBarView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
//        _findSearchBarView.searchBar.delegate = self;
//        self.navigationItem.titleView = _findSearchBarView;
//        
//        _findSearchBarView.cancelBlock = ^(){
//            STRONG_SELF(self);
//            [self.navigationController popViewControllerAnimated:YES];
//        };

    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshFollowState:) name:BATRefreshFollowStateNotification object:nil];
    
//    [_findSearchView.tableView registerNib:[UINib nibWithNibName:@"BATRecommendDoctorTableViewCell" bundle:nil] forCellReuseIdentifier:@"BATRecommendDoctorTableViewCell"];
//    
//    [_findSearchView.tableView registerNib:[UINib nibWithNibName:@"BATRecommendFriendsTableViewCell" bundle:nil] forCellReuseIdentifier:@"BATRecommendFriendsTableViewCell"];
    
    [_findSearchView.tableView registerNib:[UINib nibWithNibName:@"BATRecommendUserTableViewCell" bundle:nil] forCellReuseIdentifier:@"BATRecommendUserTableViewCell"];
    
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
//    return UITableViewAutomaticDimension;
    return 74;
}

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
        
        
        return cell;
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

//#pragma mark - UISearchBarDelegate
//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
//{
//    [searchBar resignFirstResponder];
//    _keyWord = searchBar.text;
//    [_findSearchView.tableView.mj_header beginRefreshing];
//}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    [textField resignFirstResponder];
    _keyWord = textField.text;
    [_findSearchView.tableView.mj_header beginRefreshing];
    return YES;
}

#pragma mark - NET

#pragma mark - 根据关键词搜索医生或者好友
- (void)requestSearchDoctorAndFriend
{
    [HTTPTool requestWithURLString:@"/api/Account/RecommendedUsers" parameters:@{@"pageIndex":@(_pageIndex),@"pageSize":@(_pageSize),@"accountType":@(_recommendType),@"keyword":_keyWord} type:kGET success:^(id responseObject) {
        
        [_findSearchView.tableView.mj_header endRefreshingWithCompletionBlock:^{
            self.isCompleteRequest = YES;
            [self.findSearchView.tableView reloadData];
        }];
        [_findSearchView.tableView.mj_footer endRefreshing];
        
        if (_pageIndex == 0) {
            [_dataSource removeAllObjects];
        }
        
        BATRecommendUserModel *recommendDoctorModel = [BATRecommendUserModel mj_objectWithKeyValues:responseObject];
        
        [_dataSource addObjectsFromArray:recommendDoctorModel.Data];
        
        if (recommendDoctorModel.RecordsCount > 0) {
            _findSearchView.tableView.mj_footer.hidden = NO;
        } else {
            _findSearchView.tableView.mj_footer.hidden = YES;
        }
        
        if (_dataSource.count == recommendDoctorModel.RecordsCount) {
            [_findSearchView.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        if (_dataSource.count == 0) {
            [self.defaultView showDefaultView];
        }
        
        [_findSearchView.tableView reloadData];
        
    } failure:^(NSError *error) {
        [_findSearchView.tableView.mj_header endRefreshingWithCompletionBlock:^{
            self.isCompleteRequest = YES;
            [self.findSearchView.tableView reloadData];
        }];
        [_findSearchView.tableView.mj_footer endRefreshing];
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
        
        [_findSearchView.tableView reloadData];
        
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
//        [_findSearchView.tableView reloadData];
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
    [_findSearchView.tableView reloadData];
}


- (UITextField *)searchTF {
    if (!_searchTF) {
        _searchTF = [UITextField textFieldWithfont:[UIFont systemFontOfSize:14] textColor:nil placeholder:@"请输入关键字查找" BorderStyle:UITextBorderStyleRoundedRect];
        _searchTF.backgroundColor = [UIColor whiteColor];
        [_searchTF setTintColor:UIColorFromRGB(59, 145, 248, 1)];
        UIImageView *searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"搜索图标"]];
        UIView *leftIcon = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
        [leftIcon addSubview:searchIcon];
        [searchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(leftIcon);
        }];
        _searchTF.leftView = leftIcon;
        _searchTF.leftViewMode = UITextFieldViewModeAlways;
        _searchTF.delegate = self;
        _searchTF.bounds = CGRectMake(0, 0, SCREEN_WIDTH, 30);
        _searchTF.returnKeyType = UIReturnKeySearch;
    }
    return _searchTF;
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
            
            [self requestSearchDoctorAndFriend];
        }];
        
    }
    return _defaultView;
}


@end
