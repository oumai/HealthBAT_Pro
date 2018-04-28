//
//  MyGroupViewController.m
//  HealthBAT_Pro
//
//  Created by KM on 16/7/212016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATMyGroupViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "MJRefresh.h"
#import "BATGroupModel.h"
#import "BATGroupTableViewCell.h"
#import "BATGroupDetailViewController.h"

@interface BATMyGroupViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic,assign) int            currentPage;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UITableView    *myGroupListTableView;
@property (nonatomic,assign) BOOL isCompleteRequest;

@end

@implementation BATMyGroupViewController

- (void)dealloc
{
    DDLogWarn(@"%@",self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:BATRefreshGroupListNotification object:nil];
    
    [self pagesLayout];
    self.currentPage = 0;
    //    [self getMyGroup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self.myGroupListTableView.mj_header beginRefreshing];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BATGroupTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (self.dataArray.count > 0) {
        BATGroupData * group = self.dataArray[indexPath.section];
        [cell.groupImageView sd_setImageWithURL:[NSURL URLWithString:group.GroupIcon] placeholderImage:[UIImage imageNamed:@"默认"]];
        cell.groupNameLabel.text = group.GroupName;
        if (group) {
            cell.memberLabel.text = [NSString stringWithFormat:@"%ld位成员",(long)group.MemberCount];
        }
        cell.descriptionLabel.text = group.Description;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BATGroupData *group = self.dataArray[indexPath.section];
    BATGroupDetailViewController *groupDetailVC = [[BATGroupDetailViewController alloc] init];
    groupDetailVC.groupID = group.ID;
    groupDetailVC.groupName = group.GroupName;
    groupDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:groupDetailVC animated:YES];
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

#pragma mark - Action
- (void)refreshData
{
    [self.myGroupListTableView.mj_header beginRefreshing];
}

#pragma mark - NET
- (void)myGroupRequest {
    [HTTPTool requestWithURLString:@"/api/Group/MyGroups"
                        parameters:@{
                                     @"pageIndex":@(self.currentPage),
                                     @"pageSize":@"10"
                                     }
                              type:kGET success:^(id responseObject) {
                                  BATGroupModel * tmpGroup = [BATGroupModel mj_objectWithKeyValues:responseObject];
                                  [self.myGroupListTableView.mj_header endRefreshingWithCompletionBlock:^{
                                      self.isCompleteRequest = YES;
                                      [self.myGroupListTableView reloadData];
                                  }];
                                  [self.myGroupListTableView.mj_footer endRefreshing];
                                  if (tmpGroup.ResultCode == 0) {
                                      if (self.currentPage == 0) {
                                          self.dataArray = [NSMutableArray array];
                                      }
                                      
                                      [self.dataArray addObjectsFromArray:tmpGroup.Data];
                                      
                                      if (tmpGroup.RecordsCount > 0) {
                                          self.myGroupListTableView.mj_footer.hidden = NO;
                                      } else {
                                          self.myGroupListTableView.mj_footer.hidden = YES;
                                      }
                                      
                                      
                                      if (self.dataArray.count == tmpGroup.RecordsCount) {
                                          [self.myGroupListTableView.mj_footer endRefreshingWithNoMoreData];
                                      }
                                      [self.myGroupListTableView reloadData];
                                  }
                              }
                           failure:^(NSError *error) {
                               [self.myGroupListTableView.mj_header endRefreshingWithCompletionBlock:^{
                                   self.isCompleteRequest = YES;
                                   [self.myGroupListTableView reloadData];
                               }];
                               [self.myGroupListTableView.mj_footer endRefreshing];
                               self.currentPage --;
                               if (self.currentPage < 0) {
                                   self.currentPage = 0;
                               }
                               
                           }];
    
}

#pragma mark - layout
- (void)pagesLayout {
    [self.view addSubview:self.myGroupListTableView];
    
    WEAK_SELF(self);
    [self.myGroupListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}

#pragma mark - setter && getter
- (UITableView *)myGroupListTableView {
    if (!_myGroupListTableView) {
        _myGroupListTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _myGroupListTableView.delegate = self;
        _myGroupListTableView.dataSource = self;
        _myGroupListTableView.rowHeight = 100;
        _myGroupListTableView.tableFooterView = [UIView new];
        _myGroupListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myGroupListTableView.emptyDataSetSource = self;
        _myGroupListTableView.emptyDataSetDelegate = self;
        _myGroupListTableView.backgroundColor = [UIColor clearColor];
        [_myGroupListTableView registerClass:[BATGroupTableViewCell class] forCellReuseIdentifier:@"cell"];
        
        WEAK_SELF(self);
        _myGroupListTableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.currentPage = 0;
            [self.myGroupListTableView.mj_footer resetNoMoreData];
            [self myGroupRequest];
        }];
        _myGroupListTableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.currentPage ++;
            [self myGroupRequest];
        }];
        
        _myGroupListTableView.mj_footer.hidden = YES;
    }
    return _myGroupListTableView;
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
