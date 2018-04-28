//
//  BATGroupMemberViewController.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/31.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATGroupMemberViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "BATGroupMemberTableViewCell.h"
#import "BATGroupMemberModel.h"
#import "BATRecommendFriendsTableViewCell.h"
#import "BATFindSearchViewController.h"
#import "BATUserPersonCenterViewController.h"

@interface BATGroupMemberViewController () <UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

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
 *  退出群组
 */
@property (nonatomic,strong) UIBarButtonItem *quitGroupBarButtomItem;

/**
 *  加入群组
 */
@property (nonatomic,strong) UIBarButtonItem *joinGroupBarButtomItem;

@property (nonatomic,assign) BOOL isCompleteRequest;

@end

@implementation BATGroupMemberViewController

- (void)dealloc
{
    DDLogWarn(@"%@",self);
    _groupMemberView.tableView.delegate = nil;
    _groupMemberView.tableView.dataSource = nil;
    _groupMemberView.tableView.emptyDataSetSource = nil;
    _groupMemberView.tableView.emptyDataSetDelegate = nil;
}

- (void)loadView
{
    [super loadView];
    
    if (_groupMemberView == nil) {
        _groupMemberView = [[BATGroupMemberView alloc] init];
        _groupMemberView.tableView.delegate = self;
        _groupMemberView.tableView.dataSource = self;
        _groupMemberView.tableView.emptyDataSetSource = self;
        _groupMemberView.tableView.emptyDataSetDelegate = self;
        [self.view addSubview:_groupMemberView];
        
        WEAK_SELF(self);
        _groupMemberView.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.pageIndex = 0;
            [self.groupMemberView.tableView.mj_footer resetNoMoreData];
            [self requestGetGroupMembers];
        }];
        
        _groupMemberView.tableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.pageIndex++;
            [self requestGetGroupMembers];
        }];
        
        _groupMemberView.tableView.mj_footer.hidden = YES;
        
        [_groupMemberView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.edges.equalTo(self.view);
        }];
    }
    
    if (_joinGroupBarButtomItem == nil) {
        WEAK_SELF(self);
        _joinGroupBarButtomItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"icon_right_join_group"] style:UIBarButtonItemStyleDone handler:^(id sender) {
            STRONG_SELF(self);
            [self joinGroup];
        }];
    }
    
    if (_quitGroupBarButtomItem == nil) {
        WEAK_SELF(self);
        _quitGroupBarButtomItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"icon_quit_group"] style:UIBarButtonItemStyleDone handler:^(id sender) {
            STRONG_SELF(self);
            [self quitGroup];
        }];
    }
    
    self.navigationItem.rightBarButtonItem = _isJoined ? _quitGroupBarButtomItem : _joinGroupBarButtomItem;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title =  @"群成员";
    
    [_groupMemberView.tableView registerNib:[UINib nibWithNibName:@"BATGroupMemberTableViewCell" bundle:nil] forCellReuseIdentifier:@"BATGroupMemberTableViewCell"];
    
    _dataSource = [NSMutableArray array];
    _pageSize = 10;
    _pageIndex = 0;
    
    [_groupMemberView.tableView.mj_header beginRefreshing];
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
    BATGroupMemberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATGroupMemberTableViewCell" forIndexPath:indexPath];
    
    if (_dataSource.count > 0) {
        
        cell.indexPath = indexPath;
        
        BATGroupMemberData *groupMemberData = _dataSource[indexPath.row];
        [cell configrationCell:groupMemberData];
        
        WEAK_SELF(self);
        cell.followUser = ^(){
            STRONG_SELF(self);
            [self requestFollow:groupMemberData indexPath:indexPath];
        };
        
    }
    
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    BATGroupMemberData *groupMemberData = _dataSource[indexPath.row];
    //    BATUserPersonCenterViewController *userPersonCenterVC = [[BATUserPersonCenterViewController alloc] init];
    //    userPersonCenterVC.AccountID = groupMemberData.AccountID;
    //    userPersonCenterVC.AccountType = groupMemberData.AccountType;
    //    userPersonCenterVC.hidesBottomBarWhenPushed = YES;
    //    [self.navigationController pushViewController:userPersonCenterVC animated:YES];
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

#pragma mark - 获取群成员
- (void)requestGetGroupMembers
{
    
    [HTTPTool requestWithURLString:@"/api/Group/GetMembers"parameters:@{@"id":@(_groupID),@"pageIndex":@(_pageIndex),@"pageSize":@(_pageSize)} type:kGET success:^(id responseObject) {
        
        [_groupMemberView.tableView.mj_header endRefreshingWithCompletionBlock:^{
            self.isCompleteRequest = YES;
            [self.groupMemberView.tableView reloadData];
        }];
        [_groupMemberView.tableView.mj_footer endRefreshing];
        
        if (_pageIndex == 0) {
            [_dataSource removeAllObjects];
        }
        
        BATGroupMemberModel *groupMemberModel = [BATGroupMemberModel mj_objectWithKeyValues:responseObject];
        
        [_dataSource addObjectsFromArray:groupMemberModel.Data];
        
        if (groupMemberModel.RecordsCount > 0) {
            _groupMemberView.tableView.mj_footer.hidden = NO;
        } else {
            _groupMemberView.tableView.mj_footer.hidden = YES;
        }
        
        if (_dataSource.count == groupMemberModel.RecordsCount) {
            [_groupMemberView.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        [_groupMemberView.tableView reloadData];
        
    } failure:^(NSError *error) {
        [_groupMemberView.tableView.mj_header endRefreshingWithCompletionBlock:^{
            self.isCompleteRequest = YES;
            [self.groupMemberView.tableView reloadData];
        }];
        [_groupMemberView.tableView.mj_footer endRefreshing];
        _pageIndex--;
        if (_pageIndex < 0) {
            _pageIndex = 0;
        }
    }];
    
    //    [HTTPTool requestWithURLString:@"/api/Group/GetMembers"parameters:@{@"id":@(_groupID),@"pageIndex":@(_pageIndex),@"pageSize":@(_pageSize)} type:kGET success:^(id responseObject) {
    //
    //        [_groupMemberView.tableView.mj_header endRefreshingWithCompletionBlock:^{
    //            self.isCompleteRequest = YES;
    //            [self.groupMemberView.tableView reloadData];
    //        }];
    //        [_groupMemberView.tableView.mj_footer endRefreshing];
    //
    //        if (_pageIndex == 0) {
    //            [_dataSource removeAllObjects];
    //        }
    //
    //        BATGroupMemberModel *groupMemberModel = [BATGroupMemberModel mj_objectWithKeyValues:responseObject];
    //
    //        [_dataSource addObjectsFromArray:groupMemberModel.Data];
    //
    //        if (groupMemberModel.RecordsCount > 0) {
    //            _groupMemberView.tableView.mj_footer.hidden = NO;
    //        } else {
    //            _groupMemberView.tableView.mj_footer.hidden = YES;
    //        }
    //
    //        if (_dataSource.count == groupMemberModel.RecordsCount) {
    //            [_groupMemberView.tableView.mj_footer endRefreshingWithNoMoreData];
    //        }
    //
    //        [_groupMemberView.tableView reloadData];
    //
    //    } failure:^(NSError *error) {
    //        [_groupMemberView.tableView.mj_header endRefreshingWithCompletionBlock:^{
    //            self.isCompleteRequest = YES;
    //            [self.groupMemberView.tableView reloadData];
    //        }];
    //        [_groupMemberView.tableView.mj_footer endRefreshing];
    //        _pageIndex--;
    //        if (_pageIndex < 0) {
    //            _pageIndex = 0;
    //        }
    //    }];
}

#pragma mark - 关注或取消关注
- (void)requestFollow:(BATGroupMemberData *)model indexPath:(NSIndexPath *)indexPath
{
    
    [HTTPTool requestWithURLString:@"/api/Account/Focus" parameters:@{@"accountId":@(model.AccountID),@"isFocus":@(!model.IsFollowed)} type:kPOST success:^(id responseObject) {
        
        model.IsFollowed = !model.IsFollowed;
        
        [_dataSource replaceObjectAtIndex:indexPath.row withObject:model];
        
        [_groupMemberView.tableView reloadData];
        
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
    //        [_groupMemberView.tableView reloadData];
    //
    //        [[NSNotificationCenter defaultCenter] postNotificationName:BATRefreshFindDataNotification object:nil];
    //
    //    } failure:^(NSError *error) {
    //
    //    }];
}


#pragma mark - 加入群组

#pragma mark - 加入群组
- (void)joinGroup
{
    
    [HTTPTool requestWithURLString:@"/api/Group/Join" parameters:@{@"id":@(_groupID)} type:kGET success:^(id responseObject) {
        
        [self showText:@"已加入该群组"];
        
        _isJoined = YES;
        
        self.navigationItem.rightBarButtonItem = _isJoined ? _quitGroupBarButtomItem : _joinGroupBarButtomItem;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:BATRefreshGroupJoinStateNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:BATRefreshGroupListNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:BATRefreshFindDataNotification object:nil];
        
        [self requestGetGroupMembers];
        
    } failure:^(NSError *error) {
        
    }];
    
    //    [HTTPTool requestWithURLString:[NSString stringWithFormat:@"/api/Group/Join?id=%ld",(long)_groupID] parameters:nil type:kPOST success:^(id responseObject) {
    //
    //        [self showText:@"已加入该群组"];
    //
    //        _isJoined = YES;
    //
    //        self.navigationItem.rightBarButtonItem = _isJoined ? _quitGroupBarButtomItem : _joinGroupBarButtomItem;
    //
    //        [[NSNotificationCenter defaultCenter] postNotificationName:BATRefreshGroupJoinStateNotification object:nil];
    //
    //        [[NSNotificationCenter defaultCenter] postNotificationName:BATRefreshGroupListNotification object:nil];
    //
    //        [[NSNotificationCenter defaultCenter] postNotificationName:BATRefreshFindDataNotification object:nil];
    //
    //        [self requestGetGroupMembers];
    //
    //    } failure:^(NSError *error) {
    //
    //    }];
    
    
}

#pragma mark - 退出群组
- (void)quitGroup
{
    
    [HTTPTool requestWithURLString:@"/api/Group/Withdraw" parameters:@{@"id":@(_groupID)} type:kGET success:^(id responseObject) {
        
        [self showText:@"退群成功"];
        
        _isJoined = NO;
        
        self.navigationItem.rightBarButtonItem = _isJoined ? _quitGroupBarButtomItem : _joinGroupBarButtomItem;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:BATRefreshGroupJoinStateNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:BATRefreshGroupListNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:BATRefreshFindDataNotification object:nil];
        
        [self requestGetGroupMembers];
        
        
    } failure:^(NSError *error) {
        
    }];
    
    
    //    [HTTPTool requestWithURLString:[NSString stringWithFormat:@"/api/Group/Withdraw?id=%ld",(long)_groupID] parameters:nil type:kPOST success:^(id responseObject) {
    //
    //        [self showText:@"退群成功"];
    //
    //        _isJoined = NO;
    //
    //        self.navigationItem.rightBarButtonItem = _isJoined ? _quitGroupBarButtomItem : _joinGroupBarButtomItem;
    //
    //        [[NSNotificationCenter defaultCenter] postNotificationName:BATRefreshGroupJoinStateNotification object:nil];
    //
    //        [[NSNotificationCenter defaultCenter] postNotificationName:BATRefreshGroupListNotification object:nil];
    //        
    //        [[NSNotificationCenter defaultCenter] postNotificationName:BATRefreshFindDataNotification object:nil];
    //        
    //        [self requestGetGroupMembers];
    //        
    //        
    //    } failure:^(NSError *error) {
    //        
    //    }];
}
@end
