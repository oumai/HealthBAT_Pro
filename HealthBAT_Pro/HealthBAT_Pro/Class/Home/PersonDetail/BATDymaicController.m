//
//  BATDymaicController.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/3/27.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDymaicController.h"
#import "BATTopicTableViewCell.h"
#import "BATInvitationDetailController.h"
#import "BATDefaultView.h"
#import "BATListenDoctorDetailController.h"
@interface BATDymaicController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *dymaicTab;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,assign) NSInteger currentPage;

@property (nonatomic,strong) BATDefaultView *defaultView;

@property (nonatomic,assign) NSInteger currentIndex;

@end

@implementation BATDymaicController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self pageLayout];
    
    [self attentionRequest];
    
   
}


- (void)pageLayout {

    self.dataArray = [NSMutableArray array];
    [self.view addSubview:self.dymaicTab];
    
    
    [self.view addSubview:self.defaultView];
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.top.equalTo(self.view);
    }];

    
    
}


#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
            BATTopicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATTopicTableViewCell"];
            if (self.dataArray.count > 0) {
                HotTopicData *moment = self.dataArray[indexPath.row];
                moment.isShowTime = NO;
                cell.indexPath = indexPath;
                [cell configrationCell:moment];
                cell.sexView.hidden = YES;
                if (moment.ReplyType == 1) {
                    cell.commentButton.hidden = YES;
                    [cell.thumbsUpButton setTitle:[NSString stringWithFormat:@"阅读%@",moment.ReadNum] forState:UIControlStateNormal];
                }else {
                    cell.commentButton.hidden = NO;
                    [cell.commentButton setTitle:[NSString stringWithFormat:@"阅读 %@",moment.ReadNum] forState:UIControlStateNormal];
                    
                    [cell.thumbsUpButton setTitle:[NSString stringWithFormat:@"点赞 %zd",moment.StarNum] forState:UIControlStateNormal];
                }
    
                // WEAK_SELF(self);
                cell.avatarAction = ^(NSIndexPath *cellIndexPath) {
                    DDLogWarn(@"头像点击%@",cellIndexPath);
                    if (!LOGIN_STATION) {
                        PRESENT_LOGIN_VC;
                    }
    
    
                };
    
                cell.moreButton.hidden = YES;
            }
            return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    self.currentIndex = indexPath.row;
    HotTopicData *moment = self.dataArray[indexPath.row];
    if (moment.ReplyType == 1) {
        
        BATListenDoctorDetailController *listenVC = [[BATListenDoctorDetailController alloc]init];
        listenVC.ID = moment.ID;
        
        listenVC.listenDoctorUpdateReadNumBlock = ^(){
        
             HotTopicData *moment = self.dataArray[indexPath.row];
            moment.ReadNum = [NSString stringWithFormat:@"%zd", [moment.ReadNum integerValue] + 1];
            [_dymaicTab reloadData];
            
        };
        
        [self.navigationController pushViewController:listenVC animated:YES];
        
    }else {
    BATInvitationDetailController *invitationVC = [[BATInvitationDetailController alloc]init];
    invitationVC.ID = moment.ID;
    
    WEAK_SELF(self);
    invitationVC.priseBlock = ^(BOOL isPrise) {
        STRONG_SELF(self);
    HotTopicData *moment = self.dataArray[self.currentIndex];
        if (isPrise) {
            moment.StarNum += 1;
        }else {
        
            if (moment.StarNum <= 0) {
                moment.StarNum = 0;
            }else {
                moment.StarNum -= 1;
            }
        }
        [_dymaicTab reloadData];
    };
        
    invitationVC.updateReadNumBlock = ^() {
        STRONG_SELF(self);
        HotTopicData *moment = self.dataArray[self.currentIndex];
       
        moment.ReadNum = [NSString stringWithFormat:@"%zd", [moment.ReadNum integerValue] + 1];
        [_dymaicTab reloadData];
            
        };
    [self.navigationController pushViewController:invitationVC animated:YES];
    }
    
}

#pragma mark - 获取热门内容列表
- (void)attentionRequest {
    
    [HTTPTool requestWithURLString:@"/api/dynamic/GetMyPostList"
                        parameters:@{
                                     @"pageIndex":@(self.currentPage),
                                     @"pageSize":@"10",
                                     @"accountId":self.AccountID
                                     }
                              type:kGET
                           success:^(id responseObject) {
                               
                               [self.dymaicTab.mj_footer endRefreshing];
                               [self.dymaicTab.mj_header endRefreshing];
                               
                               self.dymaicTab.mj_footer.hidden = NO;
                               [self.dymaicTab.mj_header endRefreshingWithCompletionBlock:^{
                                   
                                   [self.dymaicTab reloadData];
                               }];
                               
                               [self.dymaicTab.mj_footer endRefreshing];
                               BATHotTopicModel * tmpModel = [BATHotTopicModel mj_objectWithKeyValues:responseObject];
                               
                               
                               
                               
                               if (tmpModel.ResultCode == 0) {
                                   if (self.currentPage == 0) {
                                       self.dataArray = [NSMutableArray array];
                                   }
                                   
                                   [self.dataArray addObjectsFromArray:tmpModel.Data];
                                   
                                   if (tmpModel.RecordsCount > 0) {
                                       self.dymaicTab.mj_footer.hidden = NO;
                                   } else {
                                       self.dymaicTab.mj_footer.hidden = YES;
                                   }
                                   
                                   if (self.dataArray.count == tmpModel.RecordsCount) {
                                       [self.dymaicTab.mj_footer endRefreshingWithNoMoreData];
                                   }
                                   [self.dymaicTab reloadData];
                                   
                                   if (self.dataArray.count == 0) {
                                        [self.defaultView showDefaultView];
                                     //  self.defaultView.reloadButton.hidden = NO;
                                    }
                               }
                               
                           } failure:^(NSError *error) {
                               
                               [self.dymaicTab.mj_footer endRefreshing];
                               [self.dymaicTab.mj_header endRefreshing];
                               

                               self.currentPage --;
                               if (self.currentPage < 0) {
                                   self.currentPage = 0;
                               }
                               
                                [self.defaultView showDefaultView];
                            //   self.defaultView.reloadButton.hidden = NO;
                               
                           }];
    
    
}


#pragma mark - Lazy Load
- (UITableView *)dymaicTab {
    
    if (!_dymaicTab) {
        _dymaicTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 188) style:UITableViewStylePlain];
        _dymaicTab.delegate = self;
        _dymaicTab.dataSource = self;
      
       
        _dymaicTab.estimatedRowHeight = 250;
        _dymaicTab.rowHeight = UITableViewAutomaticDimension;
        [_dymaicTab setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_dymaicTab registerNib:[UINib nibWithNibName:@"BATTopicTableViewCell" bundle:nil] forCellReuseIdentifier:@"BATTopicTableViewCell"];
        
        WEAK_SELF(self);
                _dymaicTab.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
                    STRONG_SELF(self);
                    self.currentPage = 0;
                    [self attentionRequest];
                }];
        
        _dymaicTab.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.currentPage ++;
            [self attentionRequest]; 
        }];
        
        _dymaicTab.mj_footer.hidden = YES;
    }
    return _dymaicTab;
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
            
            [self.dymaicTab.mj_header beginRefreshing];
        }];
        
    }
    return _defaultView;
}

@end
