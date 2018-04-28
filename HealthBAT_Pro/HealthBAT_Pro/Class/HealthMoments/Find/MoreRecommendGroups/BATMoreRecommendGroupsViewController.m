//
//  BATMoreRecommendGroupsViewController.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/29.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATMoreRecommendGroupsViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "BATRecommendGroupModel.h"
#import "BATRecommendGroupTableViewCell.h"

@interface BATMoreRecommendGroupsViewController () <UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource,UISearchBarDelegate>

@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,assign) NSInteger pageSize;

@property (nonatomic,assign) NSInteger pageIndex;

@property (nonatomic,assign) BOOL isCompleteRequest;

@end

@implementation BATMoreRecommendGroupsViewController

- (void)dealloc
{
    DDLogWarn(@"%@",self);
    _moreRecommendGroupsView.tableView.delegate = nil;
    _moreRecommendGroupsView.tableView.dataSource = nil;
    _moreRecommendGroupsView.tableView.emptyDataSetSource = nil;
    _moreRecommendGroupsView.tableView.emptyDataSetDelegate = nil;
}

- (void)loadView
{
    [super loadView];
    
    if (_moreRecommendGroupsView == nil) {
        _moreRecommendGroupsView = [[BATMoreRecommendGroupsView alloc] init];
        _moreRecommendGroupsView.tableView.delegate = self;
        _moreRecommendGroupsView.tableView.dataSource = self;
        _moreRecommendGroupsView.tableView.emptyDataSetSource = self;
        _moreRecommendGroupsView.tableView.emptyDataSetDelegate = self;
        [self.view addSubview:_moreRecommendGroupsView];

        WEAK_SELF(self)
        _moreRecommendGroupsView.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.pageIndex = 0;
            [self.moreRecommendGroupsView.tableView.mj_footer resetNoMoreData];
            [self requestRecommendGroup];
        }];
        
        _moreRecommendGroupsView.tableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.pageIndex++;
            [self requestRecommendGroup];
        }];
        
        _moreRecommendGroupsView.tableView.mj_footer.hidden = YES;
        
        [_moreRecommendGroupsView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.edges.equalTo(self.view);
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"推荐群组";
    
    [_moreRecommendGroupsView.tableView registerNib:[UINib nibWithNibName:@"BATRecommendGroupTableViewCell" bundle:nil] forCellReuseIdentifier:@"BATRecommendGroupTableViewCell"];
    
    _dataSource = [NSMutableArray array];
    _pageSize = 10;
    _pageIndex = 0;
    [_moreRecommendGroupsView.tableView.mj_header beginRefreshing];
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
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BATRecommendGroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATRecommendGroupTableViewCell" forIndexPath:indexPath];
    
    if (_dataSource.count > 0) {
        BATRecommendGroupData *recommendGroupData = _dataSource[indexPath.section];
        
        [cell.groupIconImageView sd_setImageWithURL:[NSURL URLWithString:recommendGroupData.GroupIcon] placeholderImage:[UIImage imageNamed:@"默认图"]];
        cell.groupNameLabel.text = recommendGroupData.GroupName;
        cell.groupMemberCountLabel.text = [NSString stringWithFormat:@"%ld位成员",(long)recommendGroupData.MemberCount];
        cell.groupDescLabel.text = recommendGroupData.Description;
        
        cell.joinGroupButton.tag = indexPath.section;
        
        [cell.joinGroupButton addTarget:self action:@selector(joinGroupButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
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



#pragma mark - NET

#pragma mark - 获取推荐群组
- (void)requestRecommendGroup
{
    [HTTPTool requestWithURLString:@"/api/Group/RecommendedGroups" parameters:@{@"pageSize":@(_pageSize),@"pageIndex":@(_pageIndex)} type:kGET success:^(id responseObject) {
        
        [_moreRecommendGroupsView.tableView.mj_header endRefreshingWithCompletionBlock:^{
            self.isCompleteRequest = YES;
            [self.moreRecommendGroupsView.tableView reloadData];
        }];
        [_moreRecommendGroupsView.tableView.mj_footer endRefreshing];
        
        if (_pageIndex == 0) {
            [_dataSource removeAllObjects];
        }
        
        BATRecommendGroupModel *recommendGroupModel = [BATRecommendGroupModel mj_objectWithKeyValues:responseObject];
        
        [_dataSource addObjectsFromArray:recommendGroupModel.Data];
        
        if (recommendGroupModel.RecordsCount > 0) {
            _moreRecommendGroupsView.tableView.mj_footer.hidden = NO;
        } else {
            _moreRecommendGroupsView.tableView.mj_footer.hidden = YES;
        }
        
        if (_dataSource.count == recommendGroupModel.RecordsCount) {
            [_moreRecommendGroupsView.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        [_moreRecommendGroupsView.tableView reloadData];

        
    } failure:^(NSError *error) {
        [_moreRecommendGroupsView.tableView.mj_header endRefreshingWithCompletionBlock:^{
            self.isCompleteRequest = YES;
            [self.moreRecommendGroupsView.tableView reloadData];
        }];
        [_moreRecommendGroupsView.tableView.mj_footer endRefreshing];
        _pageIndex--;
        if (_pageIndex < 0) {
            _pageIndex = 0;
        }
    }];
}

#pragma mark - 请求加入群组
- (void)requestJoinRecommendGroup:(BATRecommendGroupData *)model
{
    
    [HTTPTool requestWithURLString:[NSString stringWithFormat:@"/api/Group/Join?id=%ld", (long)model.ID] parameters:nil type:kPOST success:^(id responseObject) {
        
        [self showText:@"成功加入群组"];
        
        [_moreRecommendGroupsView.tableView.mj_header beginRefreshing];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Action
- (void)joinGroupButtonAction:(UIButton *)button
{
    BATRecommendGroupData *recommendGroupData = _dataSource[button.tag];
    
    [self requestJoinRecommendGroup:recommendGroupData];
}

@end
