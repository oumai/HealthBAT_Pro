//
//  BATMyTopicListViewcontroller.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/3/14.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATMyTopicListViewcontroller.h"
#import "BATTapicListCell.h"
#import "BATTopicListModel.h"
#import "BATTopicDetailController.h"

@interface BATMyTopicListViewcontroller ()<UITableViewDelegate,UITableViewDataSource,BATTapicListCellDelegate>

@property (nonatomic,strong) UITableView *topicTab;
@property (nonatomic,assign) NSInteger currentPage;

@property (nonatomic,strong) BATTopicListModel *model;

@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation BATMyTopicListViewcontroller

- (void)viewDidLoad {
    [super viewDidLoad];

    [self pageLayout];
    
    [self TopiceRequest];
}

- (BOOL)navigationShouldPopOnBackButton {

//    if (self.updateAction) {
//        self.updateAction();
//    }
    return YES;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    BATTapicListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATTapicListCell"];
    cell.delegate = self;
    cell.rowPath = indexPath;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    MyTopicListDataModel *model = self.dataArray[indexPath.row];
    
    BATTopicDetailController *topicDetailVC = [[BATTopicDetailController alloc]init];
    topicDetailVC.ID = model.ID;
    
    
    topicDetailVC.TopicDetailRefashBlock = ^(BOOL isAttend){

        model.IsTopicFollow = isAttend;
        [_topicTab reloadData];
        
    };
    [self.navigationController pushViewController:topicDetailVC animated:YES];
    
}

#pragma mark - BATTapicListCellDelegate
- (void)BATTapicListCellTopicAttenAction:(UIButton *)topicBtn row:(NSIndexPath *)rowPath {
    
    if (!LOGIN_STATION) {
        PRESENT_LOGIN_VC;
        return;
    }

    MyTopicListDataModel *model = self.dataArray[rowPath.row];
    
    NSString *url = nil;
    if (model.IsTopicFollow) {
        url = @"/api/dynamic/CancelOperation";
    }else {
        url = @"/api/dynamic/ExecuteOperation";
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"2" forKey:@"RelationType"];
    [dict setObject:model.ID forKey:@"RelationID"];
   
    [HTTPTool requestWithURLString:url parameters:dict type:kPOST success:^(id responseObject) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TopicLikeMesDymaicRelaod" object:nil];
        model.IsTopicFollow = !model.IsTopicFollow;
        
    
        NSInteger followNum = [model.FollowNum integerValue];
        if (model.IsTopicFollow) {
            followNum += 1;
            model.FollowNum = [NSString stringWithFormat:@"%zd",followNum];
        }else {
            if (![model.FollowNum isEqualToString:@"0"]) {
                followNum -= 1;
                model.FollowNum = [NSString stringWithFormat:@"%zd",followNum];
            }
        }
        
        if (model.IsTopicFollow) {
            if (self.updateAction) {
                self.updateAction();
            }
        }
        [self.topicTab reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark - NET
-(void)TopiceRequest {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"1" forKey:@"CategoryID"];
    [dict setObject:@(self.currentPage) forKey:@"pageIndex"];
    [dict setObject:@"10" forKey:@"pageSize"];

    [HTTPTool requestWithURLString:@"/api/dynamic/GetTopicList" parameters:dict type:kGET success:^(id responseObject) {
        
        self.topicTab.mj_footer.hidden = NO;
        
        [self.topicTab.mj_header endRefreshing];
        [self.topicTab.mj_footer endRefreshing];
        
        if (self.currentPage == 0) {
            [self.dataArray removeAllObjects];
        }
        
        self.model = [BATTopicListModel mj_objectWithKeyValues:responseObject];
        
        [self.dataArray addObjectsFromArray:self.model.Data];
        
        if (self.dataArray.count == self.model.RecordsCount) {
            [self.topicTab.mj_footer endRefreshingWithNoMoreData];
        }
        [self.topicTab reloadData];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - pageLayout
- (void)pageLayout {
    
    self.title = @"话题";

    self.dataArray = [NSMutableArray array];
    [self.view addSubview:self.topicTab];
    
}

#pragma mark - setter && getter
- (UITableView *)topicTab {
    if (!_topicTab) {
        _topicTab = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
        _topicTab.delegate = self;
        _topicTab.dataSource = self;
        _topicTab.estimatedRowHeight = 250;
        _topicTab.rowHeight = UITableViewAutomaticDimension;
        _topicTab.tableFooterView = [UIView new];
        _topicTab.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_topicTab registerClass:[BATTapicListCell class] forCellReuseIdentifier:@"BATTapicListCell"];
        
        WEAK_SELF(self);
        _topicTab.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.currentPage = 0;
            [self TopiceRequest];
        }];
        _topicTab.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.currentPage ++;
            [self TopiceRequest];
        }];
        
        _topicTab.mj_footer.hidden = YES;
    }
    return _topicTab;
}



@end
