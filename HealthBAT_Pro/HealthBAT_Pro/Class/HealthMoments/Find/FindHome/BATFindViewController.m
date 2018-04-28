//
//  BATFindViewController.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/26.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATFindViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "BATFindTitleCell.h"
//#import "BATFindContentCell.h"
#import "BATRecommendUserModel.h"
#import "BATRecommendGroupModel.h"
#import "BATMoreRecommendDoctorsAndFriendsViewController.h"
#import "BATMoreRecommendGroupsViewController.h"
#import "BATUserPersonCenterViewController.h"
#import "BATGroupDetailViewController.h"
#import "BATRecommendUserTableViewCell.h"
#import "BATFindNewTitleView.h"
#import "BATFindCommenCell.h"
#import "BATMyFollowViewController.h"
#import "BATMyFansViewController.h"

@interface BATFindViewController () <UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

/**
 *  推荐医生数据源
 */
@property (nonatomic,strong) NSMutableArray *doctorDataSource;

/**
 *  推荐群组数据源
 */
@property (nonatomic,strong) NSMutableArray *groupDataSource;
/**
 *  推荐感兴趣的人数据源
 */
@property (nonatomic,strong) NSMutableArray *hobbyDataSource;

/**
 *  推荐好友数据源
 */
@property (nonatomic,strong) NSMutableArray *friendsDataSource;

/**
 教师数据源
 */
@property (nonatomic,strong) NSMutableArray *teacherDataSource;

@property (nonatomic,assign) BOOL isCompleteRequest;

@property (nonatomic,strong) dispatch_group_t group;

@property (nonatomic,strong) BATDefaultView *defaultView;
@end

@implementation BATFindViewController

- (void)dealloc
{
    DDLogWarn(@"%@",self);
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _findView.tableView.emptyDataSetSource = nil;
    _findView.tableView.emptyDataSetDelegate = nil;
    _findView.tableView.delegate = nil;
    _findView.tableView.dataSource = nil;
}

- (void)loadView
{
    [super loadView];
    
    if (_findView == nil) {
        _findView = [[BATFindView alloc] init];
        _findView.tableView.emptyDataSetSource = self;
        _findView.tableView.emptyDataSetDelegate = self;
        _findView.tableView.delegate = self;
        _findView.tableView.dataSource = self;
        _findView.tableView.backgroundColor = [UIColor clearColor];
        [_findView.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.view addSubview:_findView];
        
        WEAK_SELF(self);
        _findView.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            STRONG_SELF(self);
            [self refreshData];
        }];
        
        _findView.tableView.mj_footer.hidden = YES;
        
        [_findView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.edges.equalTo(self.view);
        }];
        
        [_findView addSubview:self.defaultView];
        [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:BATRefreshFindDataNotification object:nil];

    _doctorDataSource = [NSMutableArray array];
    _groupDataSource = [NSMutableArray array];
    _friendsDataSource = [NSMutableArray array];
    _teacherDataSource = [NSMutableArray array];
    _hobbyDataSource = [NSMutableArray array];
    
    [_findView.tableView registerNib:[UINib nibWithNibName:@"BATFindTitleCell" bundle:nil] forCellReuseIdentifier:@"BATFindTitleCell"];
    
    [_findView.tableView registerNib:[UINib nibWithNibName:@"BATFindCommenCell" bundle:nil] forCellReuseIdentifier:@"BATFindCommenCell"];
    
//    [_findView.tableView registerNib:[UINib nibWithNibName:@"BATFindContentCell" bundle:nil] forCellReuseIdentifier:@"BATFindContentCell"];
    
    [_findView.tableView registerNib:[UINib nibWithNibName:@"BATRecommendUserTableViewCell" bundle:nil] forCellReuseIdentifier:@"BATRecommendUserTableViewCell"];
    
//    [_findView.tableView.mj_header beginRefreshing];
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
//    [self refreshData];
    [_findView.tableView.mj_header beginRefreshing];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 4;
//    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (section == 0) {
//        return _doctorDataSource.count > 0 ? 2 : 0;
//    } else if (section == 1) {
//        return _groupDataSource.count > 0 ? 2 : 0;
//    }
//    return _friendsDataSource.count > 0 ? 2 : 0;;
    if (section == 0) {
        return 2;
    }else if (section == 1) {
        return _doctorDataSource.count > 3 ? 3 : _doctorDataSource.count;
    }else if(section == 2) {
        return _friendsDataSource.count > 3 ? 3 : _friendsDataSource.count;
    }else {
        return _hobbyDataSource.count > 3 ? 3 : _hobbyDataSource.count;
    }


}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 50;
    }else {
    return 70;
    }
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
////    if (indexPath.row == 0) {
////        return 44;
////    } else if (indexPath.row == 1) {
////        return 160;
////    }
////    return 0;
//    
//    return UITableViewAutomaticDimension;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 64;
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }else if (section == 1 && _doctorDataSource.count == 0) {
        return nil;
    } else if (section == 2 && _friendsDataSource.count == 0) {
        return nil;
    } else if (section == 3 && _hobbyDataSource.count == 0) {
        return nil;
    }
    
    BATFindNewTitleView *titleView = [[BATFindNewTitleView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
    titleView.backgroundColor = [UIColor whiteColor];
    if (section == 0) {
        
    }else if (section == 1) {
        titleView.titleLabel.text = @"推荐医生";
    } else if (section == 2) {
        titleView.titleLabel.text = @"推荐老师";
    } else if(section == 3) {
        titleView.titleLabel.text = @"可能感兴趣的人";
    }
    
    titleView.section = section;
    
    titleView.findNewTitleClick = ^(NSInteger section) {
        if (section == 1) {
            //更多推荐医生
            
            BATMoreRecommendDoctorsAndFriendsViewController *moreRecommendDoctorsAndFriendsVC = [[BATMoreRecommendDoctorsAndFriendsViewController alloc] init];
            moreRecommendDoctorsAndFriendsVC.recommendType = BATRecommendDoctors;
            moreRecommendDoctorsAndFriendsVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:moreRecommendDoctorsAndFriendsVC animated:YES];
            
        } else if (section == 2) {
            //更多推荐好友
            
            BATMoreRecommendDoctorsAndFriendsViewController *moreRecommendDoctorsAndFriendsVC = [[BATMoreRecommendDoctorsAndFriendsViewController alloc] init];
            moreRecommendDoctorsAndFriendsVC.recommendType = BATRecommendFriends;
            moreRecommendDoctorsAndFriendsVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:moreRecommendDoctorsAndFriendsVC animated:YES];
        } else if (section == 3) {
            //可能感兴趣的人
            BATMoreRecommendDoctorsAndFriendsViewController *moreRecommendDoctorsAndFriendsVC = [[BATMoreRecommendDoctorsAndFriendsViewController alloc] init];
            moreRecommendDoctorsAndFriendsVC.recommendType = BATRecommendHobby;
            moreRecommendDoctorsAndFriendsVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:moreRecommendDoctorsAndFriendsVC animated:YES];
        }
        
    };
    
    return titleView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        footerView.backgroundColor = BASE_BACKGROUND_COLOR;
        return footerView;
    }else {
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    }else {
        return CGFLOAT_MIN;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 10;
    if (section == 0) {
        return CGFLOAT_MIN;
    }else if (section == 1) {
        return _doctorDataSource.count > 0 ? 44 : CGFLOAT_MIN;
    } else if(section == 2) {
        return _friendsDataSource.count > 0 ? 44 : CGFLOAT_MIN;
    }else {
        return _hobbyDataSource.count > 0 ? 44 : CGFLOAT_MIN;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
 
    if (indexPath.section == 0) {
        BATFindCommenCell *commenCell = [tableView dequeueReusableCellWithIdentifier:@"BATFindCommenCell"];
        if (indexPath.row == 0) {
            commenCell.titleLabels.text = @"我的关注";
            commenCell.avatorImageView.image = [UIImage imageNamed:@"icon-wdhy"];
        }else {
            commenCell.titleLabels.text = @"我的粉丝";
            commenCell.avatorImageView.image = [UIImage imageNamed:@"icon-wdfs"];
        }
        return commenCell;
    }else {
        
        BATRecommendUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATRecommendUserTableViewCell" forIndexPath:indexPath];
         if (indexPath.section == 1) {

         if (_doctorDataSource.count > 0) {
            cell.indexPath = indexPath;
            BATRecommendUserData *recommendUserData = _doctorDataSource[indexPath.row];
            [cell configrationCell:recommendUserData];
            
            WEAK_SELF(self);
            cell.followUser = ^(){
                STRONG_SELF(self);
                //            [self requestFollow:recommendUserData indexPath:indexPath];
                [self requestFollow:recommendUserData];
            };
            
        }
    } else if(indexPath.section == 2){
        
        if (_friendsDataSource.count > 0) {
            
            cell.indexPath = indexPath;
            
            BATRecommendUserData *recommendUserData = _friendsDataSource[indexPath.row];
            [cell configrationCell:recommendUserData];
            
            WEAK_SELF(self);
            cell.followUser = ^(){
                STRONG_SELF(self);
                [self requestFollow:recommendUserData];
            };
            
        }
    } else if (indexPath.section == 3){
        
        if (_hobbyDataSource.count > 0) {
            
            cell.indexPath = indexPath;
            
            BATRecommendUserData *recommendUserData = _hobbyDataSource[indexPath.row];
            [cell configrationCell:recommendUserData];
            
            WEAK_SELF(self);
            cell.followUser = ^(){
                STRONG_SELF(self);
                [self requestFollow:recommendUserData];
            };
            
        }
    
    }
    
    return cell;
    }

//    BATFindContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATFindContentCell" forIndexPath:indexPath];
//    
//    if (indexPath.section == 0 && _doctorDataSource.count > 0) {
//        [cell configrationCell:_doctorDataSource type:BATFindDoctor];
//    } else if (indexPath.section == 1 && _groupDataSource.count > 0) {
//        [cell configrationCell:_groupDataSource type:BATFindGroup];
//    } else if (indexPath.section == 2 && _friendsDataSource.count >0) {
//        [cell configrationCell:_friendsDataSource type:BATFindFriends];
//    }
//    
//    if (indexPath.section == 0 || indexPath.section == 2) {
//        WEAK_SELF(self);
//        cell.followUser = ^(BATRecommendUserData *model) {
//            STRONG_SELF(self);
//            [self requestFollow:model];
//            
//        };
//    }
//    
//    WEAK_SELF(self);
//    cell.didSelectedCell = ^(NSIndexPath *collectionCellIndexPath){
//        STRONG_SELF(self);
//        
//        if (indexPath.section == 0 || indexPath.section == 2) {
//            //医生推荐和好友推荐点击
//            BATUserPersonCenterViewController *userPersonCenterVC = [[BATUserPersonCenterViewController alloc] init];
//            
//            BATRecommendUserData *recommendUserData = indexPath.section == 0 ? self.doctorDataSource[collectionCellIndexPath.row] : self.friendsDataSource[collectionCellIndexPath.row];
//            
//            userPersonCenterVC.AccountID = recommendUserData.AccountID;
//            userPersonCenterVC.AccountType = recommendUserData.AccountType;
//            
//            userPersonCenterVC.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:userPersonCenterVC animated:YES];
//
//        } else {
//            //推荐群组点击
//            BATRecommendGroupData *recommendGroupData = _groupDataSource[collectionCellIndexPath.row];
//            BATGroupDetailViewController *groupDetailVC = [[BATGroupDetailViewController alloc] init];
//            groupDetailVC.groupID = recommendGroupData.ID;
//            groupDetailVC.groupName = recommendGroupData.GroupName;
//            groupDetailVC.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:groupDetailVC animated:YES];
//        }
//        
//
//    };
//     
//    return cell;

}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == 0) {
//        
//        if (indexPath.section == 0) {
//            //更多推荐医生
//            
//            BATMoreRecommendDoctorsAndFriendsViewController *moreRecommendDoctorsAndFriendsVC = [[BATMoreRecommendDoctorsAndFriendsViewController alloc] init];
//            moreRecommendDoctorsAndFriendsVC.recommendType = BATRecommendDoctors;
//            moreRecommendDoctorsAndFriendsVC.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:moreRecommendDoctorsAndFriendsVC animated:YES];
//            
//        } else if (indexPath.section == 1) {
//            //更多推荐群组
//            
//            BATMoreRecommendGroupsViewController *moreRecommendGroupsVC = [[BATMoreRecommendGroupsViewController alloc] init];
//            moreRecommendGroupsVC.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:moreRecommendGroupsVC animated:YES];
//            
//        } else if (indexPath.section == 2) {
//            //更多推荐好友
//            
//            BATMoreRecommendDoctorsAndFriendsViewController *moreRecommendDoctorsAndFriendsVC = [[BATMoreRecommendDoctorsAndFriendsViewController alloc] init];
//            moreRecommendDoctorsAndFriendsVC.recommendType = BATRecommendFriends;
//            moreRecommendDoctorsAndFriendsVC.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:moreRecommendDoctorsAndFriendsVC animated:YES];
//        }
//        
//        
//    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            BATMyFollowViewController *followVC = [[BATMyFollowViewController alloc]init];
            [self.navigationController pushViewController:followVC animated:YES];
        }else {
            BATMyFansViewController *fansVC = [[BATMyFansViewController alloc]init];
            [self.navigationController pushViewController:fansVC animated:YES];
        }
    }else {
    
        //医生推荐和好友推荐点击
        BATUserPersonCenterViewController *userPersonCenterVC = [[BATUserPersonCenterViewController alloc] init];
        
    if (indexPath.section == 1) {
        if (_doctorDataSource.count > 0) {
            BATRecommendUserData *recommendUserData = _doctorDataSource[indexPath.row];
            userPersonCenterVC.AccountID = recommendUserData.AccountID;
            userPersonCenterVC.AccountType = recommendUserData.AccountType;
            
        }
    } else if (indexPath.section == 2){
        if (_friendsDataSource.count > 0) {
            BATRecommendUserData *recommendUserData = _friendsDataSource[indexPath.row];
            userPersonCenterVC.AccountID = recommendUserData.AccountID;
            userPersonCenterVC.AccountType = recommendUserData.AccountType;
        }
    }else if (indexPath.section == 3){
        if (_hobbyDataSource.count > 0) {
            BATRecommendUserData *recommendUserData = _hobbyDataSource[indexPath.row];
            userPersonCenterVC.AccountID = recommendUserData.AccountID;
            userPersonCenterVC.AccountType = recommendUserData.AccountType;
        }
    }
        userPersonCenterVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:userPersonCenterVC animated:YES];
    }
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

#pragma mark - 刷新数据
- (void)refreshData
{
    
    _group = dispatch_group_create();
    
    [self requestDoctorRecommend];
//    [self requestGroupRecommend];
    [self requestFriendsRecommend];
    [self requestHobbyRecommend];
    
    dispatch_group_notify(_group, dispatch_get_main_queue(), ^{
        self.isCompleteRequest = YES;
        [self.findView.tableView reloadData];
    });
}

#pragma mark - 获取医生推荐
- (void)requestDoctorRecommend
{
    dispatch_group_enter(_group);
    [HTTPTool requestWithURLString:@"/api/Account/RecommendedUsers" parameters:@{@"pageIndex":@"0",@"pageSize":@"3",@"accountType":@"2"} type:kGET success:^(id responseObject) {
        
        [_findView.tableView.mj_header endRefreshingWithCompletionBlock:^{
//            self.isCompleteRequest = YES;
//            [self.findView.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        }];
        
        [_doctorDataSource removeAllObjects];
        
        BATRecommendUserModel *recommendDoctorModel = [BATRecommendUserModel mj_objectWithKeyValues:responseObject];
        
        [_doctorDataSource addObjectsFromArray:recommendDoctorModel.Data];
        
//        [self.findView.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        
        dispatch_group_leave(_group);
        
    } failure:^(NSError *error) {
        [_findView.tableView.mj_header endRefreshingWithCompletionBlock:^{
//            self.isCompleteRequest = YES;
//            [self.findView.tableView reloadData];
            dispatch_group_leave(_group);
        }];
        
        [self.defaultView showDefaultView];
    }];
}

#pragma mark - 获取群组推荐
- (void)requestGroupRecommend
{
    [HTTPTool requestWithURLString:@"/api/Group/RecommendedGroups" parameters:@{@"count":@"3"} type:kGET success:^(id responseObject) {
        
        [_findView.tableView.mj_header endRefreshingWithCompletionBlock:^{
            self.isCompleteRequest = YES;
            [self.findView.tableView reloadData];
        }];
        [_groupDataSource removeAllObjects];
        
        BATRecommendGroupModel *recommendGroupModel = [BATRecommendGroupModel mj_objectWithKeyValues:responseObject];
        
        [_groupDataSource addObjectsFromArray:recommendGroupModel.Data];
        
        [_findView.tableView reloadData];
        
    } failure:^(NSError *error) {
        [_findView.tableView.mj_header endRefreshingWithCompletionBlock:^{
            self.isCompleteRequest = YES;
            [self.findView.tableView reloadData];
        }];
        
        [self.defaultView showDefaultView];
    }];
}

#pragma mark - 获取好友推荐
- (void)requestFriendsRecommend
{
    dispatch_group_enter(_group);
    [HTTPTool requestWithURLString:@"/api/Account/RecommendedUsers" parameters:@{@"pageIndex":@"0",@"pageSize":@"3",@"accountType":@"1"} type:kGET success:^(id responseObject) {
        
        [_findView.tableView.mj_header endRefreshingWithCompletionBlock:^{
//            self.isCompleteRequest = YES;
//            [self.findView.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        }];
        [_friendsDataSource removeAllObjects];
        
        BATRecommendUserModel *recommendDoctorModel = [BATRecommendUserModel mj_objectWithKeyValues:responseObject];
        
        [_friendsDataSource addObjectsFromArray:recommendDoctorModel.Data];
        
//        [self.findView.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        
        dispatch_group_leave(_group);

    } failure:^(NSError *error) {

        [_findView.tableView.mj_header endRefreshingWithCompletionBlock:^{
//            self.isCompleteRequest = YES;
//            [self.findView.tableView reloadData];
            
            dispatch_group_leave(_group);
        }];

    }];
}

#pragma mark - 获取感兴趣的人
- (void)requestHobbyRecommend
{
    dispatch_group_enter(_group);
    [HTTPTool requestWithURLString:@"/api/Account/RecommendedUsers" parameters:@{@"pageIndex":@"0",@"pageSize":@"3",@"accountType":@"3"} type:kGET success:^(id responseObject) {
        
        [_findView.tableView.mj_header endRefreshingWithCompletionBlock:^{
            //            self.isCompleteRequest = YES;
            //            [self.findView.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        }];
        [_hobbyDataSource removeAllObjects];
        
        BATRecommendUserModel *recommendDoctorModel = [BATRecommendUserModel mj_objectWithKeyValues:responseObject];
        
        [_hobbyDataSource addObjectsFromArray:recommendDoctorModel.Data];
        
        //        [self.findView.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        
        dispatch_group_leave(_group);
        
    } failure:^(NSError *error) {
        
        [_findView.tableView.mj_header endRefreshingWithCompletionBlock:^{
            //            self.isCompleteRequest = YES;
            //            [self.findView.tableView reloadData];
            
            dispatch_group_leave(_group);
        }];
        
        [self.defaultView showDefaultView];
    }];
}

#pragma mark - 关注或取消关注
- (void)requestFollow:(BATRecommendUserData *)model
{
    [HTTPTool requestWithURLString:@"/api/Account/Focus" parameters:@{@"accountId":@(model.AccountID),@"isFocus":@(!model.IsFollowed)} type:kPOST success:^(id responseObject) {
        
        //根据之前关注状态提示关注是否成功
        if (model.IsFollowed) {
            [self showText:@"已取消关注"];
        } else {
            [self showText:@"关注成功"];
        }
        
//        if (model.AccountType == 1) {
//            //刷新推荐好友
//            [self requestFriendsRecommend];
//        } else {
//            //刷新推荐医生
//            [self requestDoctorRecommend];
//        }
        
        [self refreshData];
        
        
    } failure:^(NSError *error) {
        
    }];
    
//    NSDictionary *params = @{@"BeFollowedAccountID":@(model.AccountID), @"IsFollowing":@(!model.IsFollowed)};
//    
//    [HTTPTool requestWithURLString:@"/api/Account/Follow" parameters:params type:kPOST success:^(id responseObject) {
//        
//        //根据之前关注状态提示关注是否成功
//        if (model.IsFollowed) {
//            [self showText:@"已取消关注"];
//        } else {
//            [self showText:@"关注成功"];
//        }
//        
//        if (model.AccountType == 1) {
//            //刷新推荐好友
//            [self requestFriendsRecommend];
//        } else {
//            //刷新推荐医生
//            [self requestDoctorRecommend];
//        }
//        
//        
//    } failure:^(NSError *error) {
//        
//    }];
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
            
            [self requestDoctorRecommend];
            [self requestFriendsRecommend];
            [self requestHobbyRecommend];
        }];
        
    }
    return _defaultView;
}


@end
