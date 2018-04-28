//
//  BATSameTopicController.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/3/17.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATSameTopicController.h"
#import "BATHeaderView.h"
#import "BATAttendView.h"
#import "BATTopicTableViewCell.h"
#import "BATHotTopicModel.h"
#import "BATTopicPersonController.h"
#import "BATInvitationDetailController.h"
#import "YYText.h"
#import "BATMyTopicListViewcontroller.h"
@interface BATSameTopicController ()<BATHeaderViewDelegate,UITableViewDelegate,UITableViewDataSource,BATAttendViewDelegate>
@property (nonatomic,strong) BATHeaderView *headerView;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,strong) UIScrollView *backScro;
@property (nonatomic,strong) BATAttendView *attendView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UITableView *bbsTableView;
@property (nonatomic,assign) NSInteger currentIndex;
@end

@implementation BATSameTopicController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self pageLayout];
    
    [self attentionRequest];
}


- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
}

- (void)pageLayout {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAction) name:@"TopicLikeMesDymaicRelaod" object:nil];
    
    self.dataArray = [NSMutableArray array];
    [self.view addSubview:self.attendView];

    self.title = @"跟我一样";
    self.headerView = [[BATHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45) withLineWidth:SCREEN_WIDTH/2];
    self.headerView.delegate = self;
    self.headerView.isHalf = YES;
    [self.headerView.chatBtn setTitle:@"共同关注" forState:UIControlStateNormal];
    [self.headerView.bookBtn setTitle:@"动态" forState:UIControlStateNormal];
    [self.headerView selectPages:0];
    [self.view addSubview:self.headerView];
    
    self.backScro = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, SCREEN_HEIGHT - 45)];
    self.backScro.delegate = self;
    [self.backScro setContentSize:CGSizeMake(SCREEN_WIDTH * 2, SCREEN_HEIGHT - 45)];
    self.backScro.pagingEnabled = YES;
    self.backScro.bounces = NO;
    [self.view addSubview:self.backScro];
    
    [self.backScro addSubview:self.bbsTableView];
    
    
    self.attendView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 45);
    [self.attendView setLeftTable];
    [self.backScro addSubview:self.attendView];
    
    
}

#pragma mark - UITableViewDelegate 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count > 0 ? self.dataArray.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BATTopicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATTopicTableViewCell"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (self.dataArray.count > 0) {
        HotTopicData *moment = self.dataArray[indexPath.row];
        cell.indexPath = indexPath;
        [cell configrationCell:moment];
        cell.moreButton.hidden = YES;
        // WEAK_SELF(self);
        cell.avatarAction = ^(NSIndexPath *cellIndexPath) {
            DDLogWarn(@"头像点击%@",cellIndexPath);
            if (!LOGIN_STATION) {
                PRESENT_LOGIN_VC;
            }
            BATTopicPersonController *personVC = [[BATTopicPersonController alloc]init];
            HotTopicData *moment = self.dataArray[cellIndexPath.row];
            personVC.accountID = moment.AccountID;
            [self.navigationController pushViewController:personVC animated:YES];
            
        };
        
        cell.moreAction = ^(NSIndexPath *cellIndexPath) {
            DDLogWarn(@"更多操作点击%@",cellIndexPath);
            HotTopicData *moment = self.dataArray[cellIndexPath.row];
            NSString *urlString = nil;
            if (moment.IsUserFollow) {
                urlString = @"/api/dynamic/CancelOperation";
                [self AttendRequesetWithURL:urlString monent:moment];
            }else {
                urlString = @"/api/dynamic/ExecuteOperation";
                [self AttendRequesetWithURL:urlString monent:moment];
            }
        };
        
    }
    return cell;
}

- (void)AttendRequesetWithURL:(NSString *)url monent:(HotTopicData *)monent {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"3" forKey:@"RelationType"];
    [dict setObject:monent.AccountID forKey:@"RelationID"];
    
    [HTTPTool requestWithURLString:url parameters:dict type:kPOST success:^(id responseObject) {
        
        monent.IsUserFollow = !monent.IsUserFollow;
        for (HotTopicData *data in self.dataArray) {
            if (data.AccountID == monent.AccountID) {
                data.IsUserFollow = monent.IsUserFollow;
            }
        }
        [self.bbsTableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
    HotTopicData *data = self.dataArray[indexPath.row];
    BATInvitationDetailController *invitationVC = [[BATInvitationDetailController alloc]init];
    invitationVC.ID = data.ID;
    
    self.currentIndex = indexPath.row;
    WEAK_SELF(self);
    invitationVC.priseBlock = ^(BOOL isPrise) {
        STRONG_SELF(self);
        HotTopicData *data = self.dataArray[self.currentIndex];
        if (isPrise) {
            data.StarNum += 1;
        }else {
            if (data.StarNum <= 0) {
                data.StarNum = 0;
            }else {
                data.StarNum -= 1;
            }
        }
        [_bbsTableView reloadData];
    };
    [self.navigationController pushViewController:invitationVC animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    if (scrollView == self.backScro) {
        NSInteger pages = scrollView.contentOffset.x / SCREEN_WIDTH;
        switch (pages) {
            case 0: {
                [self.headerView setLineViewPostionWihPage:0];
                
            }
                break;
            case 1: {
                [self.headerView setLineViewPostionWihPage:1];
                
            }
                break;
            default:
                break;
        }
    }
    
}

#pragma mark - BATAttendViewDelegate
- (void)BATRightTableView:(BATAttendView *)view accountID:(NSString *)account {
  
    BATTopicPersonController *personVC = [[BATTopicPersonController alloc]init];
    personVC.accountID = account;
    [self.navigationController pushViewController:personVC animated:YES];
    
}

- (void)BATRightTableView:(BATAttendView *)view indexPath:(NSIndexPath *)pathRow {

        BATMyTopicListViewcontroller *listVC = [[BATMyTopicListViewcontroller alloc]init];
    listVC.updateAction = ^(){
    
        [_attendView updateData];
        
    };
        [self.navigationController pushViewController:listVC animated:YES];
    
}



#pragma mark - NET
#pragma mark - 获取热门内容列表

- (void)reloadAction {
  
    self.currentPage = 0;
    [self attentionRequest];
    
}
- (void)attentionRequest {
    
    [HTTPTool requestWithURLString:@"/api/dynamic/GetLikeMePostList"
                        parameters:@{
                                     @"pageIndex":@(self.currentPage),
                                     @"pageSize":@"10",
                                     }
                              type:kGET
                           success:^(id responseObject) {
                               
                               [self.bbsTableView.mj_header endRefreshingWithCompletionBlock:^{
                                   
                                   [self.bbsTableView reloadData];
                               }];
                               
                               [self.bbsTableView.mj_footer endRefreshing];
                               BATHotTopicModel * tmpModel = [BATHotTopicModel mj_objectWithKeyValues:responseObject];
                               
                               
                               
                               
                               if (tmpModel.ResultCode == 0) {
                                   if (self.currentPage == 0) {
                                       self.dataArray = [NSMutableArray array];
                                   }
                                   
                                   [self.dataArray addObjectsFromArray:tmpModel.Data];
                                   
                                   if (tmpModel.RecordsCount > 0) {
                                       self.bbsTableView.mj_footer.hidden = NO;
                                   } else {
                                       self.bbsTableView.mj_footer.hidden = YES;
                                   }
                                   
                                   if (self.dataArray.count == tmpModel.RecordsCount) {
                                       [self.bbsTableView.mj_footer endRefreshingWithNoMoreData];
                                   }
                                   [self.bbsTableView reloadData];
                                   
                                   //                                   if (self.dataArray.count == 0) {
                                   //                                       [self.defaultView showDefaultView];
                                   //                                   }
                               }
                               
                           } failure:^(NSError *error) {
                               
                               [self.bbsTableView.mj_header endRefreshingWithCompletionBlock:^{
                                   //                                   self.isCompleteRequest = YES;
                                   //                                   [self.finalStage reloadData];
                               }];
                               [self.bbsTableView.mj_footer endRefreshing];
                               self.currentPage --;
                               if (self.currentPage < 0) {
                                   self.currentPage = 0;
                               }
                               
                           }];
    
    
}

#pragma mark - BATHeaderViewDelegate
- (void)BATHeaderViewSeleWithPage:(NSInteger)pages {
   
    switch (pages) {
        case 0: {
            [self.headerView setLineViewPostionWihPage:0];
            [UIView animateWithDuration:0.3 animations:^{
                [self.backScro setContentOffset:CGPointMake(0, 0)];
            }];
        }
            break;
        case 1: {
            [self.headerView setLineViewPostionWihPage:1];
            [UIView animateWithDuration:0.3 animations:^{
                [self.backScro setContentOffset:CGPointMake(SCREEN_WIDTH, 0)];
            }];
        }
            break;
        default:
            break;
    }
    
}

#pragma mark - Lazy Load
- (BATAttendView *)attendView {

    if (!_attendView) {
        _attendView = [[BATAttendView alloc]init];
        _attendView.delegate = self;
    }
    return _attendView;
}

- (UITableView *)bbsTableView {

    if (!_bbsTableView) {
        _bbsTableView = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 65) style:UITableViewStylePlain];
        _bbsTableView.delegate = self;
        _bbsTableView.dataSource = self;
        _bbsTableView.estimatedRowHeight = 250;
        _bbsTableView.rowHeight = UITableViewAutomaticDimension;
        [_bbsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_bbsTableView registerNib:[UINib nibWithNibName:@"BATTopicTableViewCell" bundle:nil] forCellReuseIdentifier:@"BATTopicTableViewCell"];
        
        WEAK_SELF(self);
        _bbsTableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.currentPage = 0;
            [self attentionRequest];
        }];
        _bbsTableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.currentPage ++;
            [self attentionRequest];
        }];
    }
    return _bbsTableView;
}

@end
