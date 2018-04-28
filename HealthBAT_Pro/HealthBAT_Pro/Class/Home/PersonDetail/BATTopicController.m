//
//  BATTopicController.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/3/27.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATTopicController.h"
#import "BATMyFansTableViewCell.h"
#import "BATHotTopicListModel.h"
#import "BATDefaultView.h"
#import "BATPerson.h"
#import "BATTopicDetailController.h"
@interface BATTopicController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *topicTab;

@property (nonatomic,assign) NSInteger pageIndex;

@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,strong) BATDefaultView *defaultView;

@end

@implementation BATTopicController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = [NSMutableArray array];
    
    [self.view addSubview:self.topicTab];
    
    [self.view addSubview:self.defaultView];
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.top.equalTo(self.view);
    }];
    
    [self topicRequest];
    
   
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    BATMyFansTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATMyFansTableViewCell" forIndexPath:indexPath];
    
    if (_dataSource.count > 0) {
        cell.indexPath = indexPath;
        HotTopicListData *myFansData = _dataSource[indexPath.row];
        [cell configrationCell:myFansData];
        
        WEAK_SELF(self);
        cell.followUser = ^(){
            STRONG_SELF(self);
            [self requestFollow:myFansData indexPath:indexPath];
        };
        
    }
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 70.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     HotTopicListData *myFansData = _dataSource[indexPath.row];
    BATTopicDetailController *topicDetailVC = [[BATTopicDetailController alloc]init];
    topicDetailVC.ID = myFansData.ID;
    [self.navigationController pushViewController:topicDetailVC animated:YES];
}

#pragma mark - NET 
- (void)topicRequest {

    NSString *accountID = nil;
    if (self.accountID) {
        accountID = self.accountID;
    }else {
        accountID = @"";
    }
    [HTTPTool requestWithURLString:@"/api/dynamic/GetMyOrOtherTopicList" parameters:@{@"pageIndex":@(_pageIndex),@"pageSize":@(10),@"accountId":accountID,} type:kGET success:^(id responseObject) {
        
        self.topicTab.mj_footer.hidden = NO;
        
        [_topicTab.mj_footer endRefreshing];
        [_topicTab.mj_header endRefreshing];
        
        if (_pageIndex == 0) {
            [_dataSource removeAllObjects];
        }
        
        BATHotTopicListModel *myFansModel = [BATHotTopicListModel mj_objectWithKeyValues:responseObject];
        
        [_dataSource addObjectsFromArray:myFansModel.Data];
        
        BATPerson *person = PERSON_INFO;
        for (HotTopicListData *data in _dataSource) {
            if ([NSString stringWithFormat:@"%zd",person.Data.AccountID] == self.accountID) {
                data.IsShowBtn = YES;
            }else {
                data.IsShowBtn = NO;
            }
        }
        
        
        if (myFansModel.RecordsCount > 0) {
            _topicTab.mj_footer.hidden = NO;
        } else {
            _topicTab.mj_footer.hidden = YES;
        }
        
        if (_dataSource.count == myFansModel.RecordsCount) {
            [_topicTab.mj_footer endRefreshingWithNoMoreData];
        }
        
        [_topicTab reloadData];
        
        if (_dataSource.count == 0) {
            [self.defaultView showDefaultView];
            // self.defaultView.reloadButton.hidden = NO;
        }
        
    } failure:^(NSError *error) {
        [_topicTab.mj_header endRefreshing];
        [_topicTab.mj_footer endRefreshing];
        _pageIndex--;
        if (_pageIndex < 0) {
            _pageIndex = 0;
        }
        
        [_topicTab.mj_footer endRefreshing];
        [_topicTab.mj_header endRefreshing];
        
         [self.defaultView showDefaultView];
        //self.defaultView.reloadButton.hidden = NO;
    }];


}

#pragma mark - 关注或取消关注
- (void)requestFollow:(HotTopicListData *)model indexPath:(NSIndexPath *)indexPath
{
    
    NSString *urlString = nil;
    if (model.IsTopicFollow) {
        urlString = @"/api/dynamic/CancelOperation";
        
    }else {
        urlString = @"/api/dynamic/ExecuteOperation";
    }
    
   
    [HTTPTool requestWithURLString:urlString parameters:@{@"RelationType":@"2",@"RelationID":model.ID} type:kPOST success:^(id responseObject) {
        
        model.IsTopicFollow = !model.IsTopicFollow;
        
        [_dataSource removeObjectAtIndex:indexPath.row];
        
        if (_dataSource.count == 0) {
            [self.defaultView showDefaultView];
            // self.defaultView.reloadButton.hidden = NO;
        }else {
            self.defaultView.hidden = YES;
        }
        
        [_topicTab reloadData];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"MyAttendTopic" object:nil];
    } failure:^(NSError *error) {
        
    }];
    
}


#pragma mark - Lazy Load
- (UITableView *)topicTab {
    
    if (!_topicTab) {
        _topicTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 188) style:UITableViewStylePlain];
        _topicTab.delegate = self;
        _topicTab.dataSource = self;
        _topicTab.tableFooterView = [UIView new];
        [_topicTab registerNib:[UINib nibWithNibName:@"BATMyFansTableViewCell" bundle:nil] forCellReuseIdentifier:@"BATMyFansTableViewCell"];
        
        WEAK_SELF(self);
        _topicTab.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.pageIndex = 0;
            [self topicRequest];
        }];
        _topicTab.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.pageIndex ++;
            [self topicRequest];
        }];
        
        _topicTab.mj_footer.hidden = YES;
    }
    return _topicTab;
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
            
            [self.topicTab.mj_header beginRefreshing];
        }];
        
    }
    return _defaultView;
}

@end
