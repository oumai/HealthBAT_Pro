//
//  BATGroupAccouncementListViewController.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/31.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATGroupAccouncementListViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "BATGroupAccouncementListTableViewCell.h"
#import "BATGroupAccouncementListModel.h"
#import "BATGroupAccouncementDetailViewController.h"
#import "BATEditGroupAccouncementViewController.h"
#import "BATPerson.h"

@interface BATGroupAccouncementListViewController () <UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,assign) NSInteger pageIndex;

@property (nonatomic,assign) NSInteger pageSize;

@property (nonatomic,assign) BOOL isCompleteRequest;

@end

@implementation BATGroupAccouncementListViewController

- (void)dealloc
{
    DDLogWarn(@"%@",self);
    _groupAccouncementListView.tableView.delegate = nil;
    _groupAccouncementListView.tableView.dataSource = nil;
}

- (void)loadView
{
    [super loadView];
    
    if (_groupAccouncementListView == nil) {
        _groupAccouncementListView = [[BATGroupAccouncementListView alloc] init];
        _groupAccouncementListView.tableView.delegate = self;
        _groupAccouncementListView.tableView.dataSource = self;
        _groupAccouncementListView.tableView.rowHeight = UITableViewAutomaticDimension;
        _groupAccouncementListView.tableView.estimatedRowHeight = 120;
        [self.view addSubview:_groupAccouncementListView];
        
        WEAK_SELF(self);
        [_groupAccouncementListView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.edges.equalTo(self.view);
        }];
        
        _groupAccouncementListView.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.pageIndex = 0;
            [self.groupAccouncementListView.tableView.mj_footer resetNoMoreData];
            [self requestGroupAccouncementList];
        }];
        
        _groupAccouncementListView.tableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.pageIndex++;
            [self requestGroupAccouncementList];
        }];
        
        
        
        _groupAccouncementListView.tableView.mj_footer.hidden = YES;
    }
    
    
    BATPerson *person = PERSON_INFO;
    if (person.Data.IsMaster) {
        WEAK_SELF(self);
        UIBarButtonItem *sendBarButtonItem = [[UIBarButtonItem alloc] bk_initWithBarButtonSystemItem:UIBarButtonSystemItemAdd handler:^(id sender) {
            STRONG_SELF(self);
            BATEditGroupAccouncementViewController *editGroupAccouncementVC = [[BATEditGroupAccouncementViewController alloc] init];
            editGroupAccouncementVC.groupID = self.groupID;
            editGroupAccouncementVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:editGroupAccouncementVC animated:YES];
        }];
        self.navigationItem.rightBarButtonItem = sendBarButtonItem;
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_groupAccouncementListView.tableView.mj_header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"群组公告";
    
    [_groupAccouncementListView.tableView registerNib:[UINib nibWithNibName:@"BATGroupAccouncementListTableViewCell" bundle:nil] forCellReuseIdentifier:@"BATGroupAccouncementListTableViewCell"];
    
    _dataSource = [NSMutableArray array];
    _pageIndex = 0;
    _pageSize = 10;
    
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BATGroupAccouncementListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATGroupAccouncementListTableViewCell" forIndexPath:indexPath];
    if (_dataSource.count > 0) {
        
        BATGroupAccouncementListData *groupAccouncementListData = _dataSource[indexPath.row];
        cell.creatorLabel.text = groupAccouncementListData.Creater;
        cell.timeLabel.text = groupAccouncementListData.CreatedTime;
        cell.contentLabel.text = groupAccouncementListData.NoticeContent;
        
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BATGroupAccouncementDetailViewController *groupAccouncementDetailVC = [[BATGroupAccouncementDetailViewController alloc] init];
    
    BATGroupAccouncementListData *groupAccouncementListData = _dataSource[indexPath.row];
    
    groupAccouncementDetailVC.groupAccouncementListData = groupAccouncementListData;
    groupAccouncementDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:groupAccouncementDetailVC animated:YES];
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

#pragma mark - 获取公告列表
- (void)requestGroupAccouncementList
{
    
    [HTTPTool requestWithURLString:@"/api/Group/GetNoticeList" parameters:@{@"groupId":@(_groupID),@"pageSize":@(_pageSize),@"pageIndex":@(_pageIndex)} type:kGET success:^(id responseObject) {
        
        [_groupAccouncementListView.tableView.mj_header endRefreshingWithCompletionBlock:^{
            self.isCompleteRequest = YES;
            [self.groupAccouncementListView.tableView reloadData];
        }];
        [_groupAccouncementListView.tableView.mj_footer endRefreshing];
        
        if (_pageIndex == 0) {
            [_dataSource removeAllObjects];
        }
        
        BATGroupAccouncementListModel *groupAccouncementListModel = [BATGroupAccouncementListModel mj_objectWithKeyValues:responseObject];
        
        [_dataSource addObjectsFromArray:groupAccouncementListModel.Data];
        
        if (groupAccouncementListModel.RecordsCount > 0) {
            _groupAccouncementListView.tableView.mj_footer.hidden = NO;
        } else {
            _groupAccouncementListView.tableView.mj_footer.hidden = YES;
        }
        
        if (_dataSource.count == groupAccouncementListModel.RecordsCount) {
            [_groupAccouncementListView.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        [_groupAccouncementListView.tableView reloadData];
        
    } failure:^(NSError *error) {
        [_groupAccouncementListView.tableView.mj_header endRefreshingWithCompletionBlock:^{
            self.isCompleteRequest = YES;
            [self.groupAccouncementListView.tableView reloadData];
        }];
        [_groupAccouncementListView.tableView.mj_footer endRefreshing];
        
        _pageIndex--;
        if (_pageIndex < 0) {
            _pageIndex = 0;
        }
    }];
    
    //    [HTTPTool requestWithURLString:@"/api/Group/GetNoticeList" parameters:@{@"GroupId":@(_groupID),@"pageSize":@(_pageSize),@"pageIndex":@(_pageIndex)} type:kGET success:^(id responseObject) {
    //
    //        [_groupAccouncementListView.tableView.mj_header endRefreshingWithCompletionBlock:^{
    //            self.isCompleteRequest = YES;
    //            [self.groupAccouncementListView.tableView reloadData];
    //        }];
    //        [_groupAccouncementListView.tableView.mj_footer endRefreshing];
    //
    //        if (_pageIndex == 0) {
    //            [_dataSource removeAllObjects];
    //        }
    //
    //        BATGroupAccouncementListModel *groupAccouncementListModel = [BATGroupAccouncementListModel mj_objectWithKeyValues:responseObject];
    //
    //        [_dataSource addObjectsFromArray:groupAccouncementListModel.Data];
    //
    //        if (groupAccouncementListModel.RecordsCount > 0) {
    //            _groupAccouncementListView.tableView.mj_footer.hidden = NO;
    //        } else {
    //            _groupAccouncementListView.tableView.mj_footer.hidden = YES;
    //        }
    //
    //        if (_dataSource.count == groupAccouncementListModel.RecordsCount) {
    //            [_groupAccouncementListView.tableView.mj_footer endRefreshingWithNoMoreData];
    //        }
    //
    //        [_groupAccouncementListView.tableView reloadData];
    //
    //    } failure:^(NSError *error) {
    //        [_groupAccouncementListView.tableView.mj_header endRefreshingWithCompletionBlock:^{
    //            self.isCompleteRequest = YES;
    //            [self.groupAccouncementListView.tableView reloadData];
    //        }];
    //        [_groupAccouncementListView.tableView.mj_footer endRefreshing];
    //        
    //        _pageIndex--;
    //        if (_pageIndex < 0) {
    //            _pageIndex = 0;
    //        }
    //    }];
}

@end
