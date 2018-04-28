//
//  BATListeninDoctorController.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/3/20.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATListeninDoctorController.h"
#import "BATTopicTableViewCell.h"
#import "BATHotTopicListModel.h"
#import "BATTopicPersonController.h"
#import "BATListenTopicCell.h"
#import "BATTopicDetailController.h"
#import "BATListenDoctorDetailController.h"
#import "BATInvitationDetailController.h"

#import "BATPersonDetailController.h"
@interface BATListeninDoctorController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *listenTab;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,assign) NSInteger currentPage;

@property (nonatomic,strong) BATHotTopicListModel *listModel;

@property (nonatomic,assign) NSInteger currentIndex;
@end

@implementation BATListeninDoctorController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self pageLayout];
    
    [self getHotTopicLise];
    
    [self attentionRequest];
}

- (void)pageLayout {

    self.title = @"聆听医声";
    self.dataArray = [NSMutableArray array];
    [self.view addSubview:self.listenTab];
}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return self.listModel.Data.count;
    }
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        return 70;
    }else {
    
        return UITableViewAutomaticDimension;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    if (indexPath.section == 1) {
        BATTopicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATTopicTableViewCell"];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if (self.dataArray.count > 0) {
            HotTopicData *moment = self.dataArray[indexPath.row];
            
            cell.indexPath = indexPath;
            [cell configrationCell:moment];
            cell.moreButton.hidden = YES;
            cell.sexView.hidden = YES;
            if (moment.ReplyType == 1) {
                cell.commentButton.hidden = YES;
                [cell.thumbsUpButton setTitle:[NSString stringWithFormat:@"阅读%@",moment.ReadNum] forState:UIControlStateNormal];
            }else {
                 cell.commentButton.hidden = NO;
                [cell.commentButton setTitle:[NSString stringWithFormat:@"阅读 %@",moment.ReadNum] forState:UIControlStateNormal];
                
                [cell.thumbsUpButton setTitle:[NSString stringWithFormat:@"点赞 %zd",moment.StarNum] forState:UIControlStateNormal];
            }
            
            
             WEAK_SELF(self);
            cell.avatarAction = ^(NSIndexPath *cellIndexPath) {
                STRONG_SELF(self);
                DDLogWarn(@"头像点击%@",cellIndexPath);
                if (!LOGIN_STATION) {
                    PRESENT_LOGIN_VC;
                    return;
                }
                HotTopicData *moment = self.dataArray[cellIndexPath.row];
                
                //个人主页控制器
                BATPersonDetailController *personDetailVC = [[BATPersonDetailController alloc]init];
                personDetailVC.accountID = moment.AccountID;
                [self.navigationController pushViewController:personDetailVC animated:YES];
                
                /*
                BATTopicPersonController *personVC = [[BATTopicPersonController alloc]init];
                personVC.accountID = moment.AccountID;
                [self.navigationController pushViewController:personVC animated:YES];
                 */
                
            };
            
            cell.moreAction = ^(NSIndexPath *cellIndexPath) {
                DDLogWarn(@"更多操作点击%@",cellIndexPath);
                STRONG_SELF(self);
                if (!LOGIN_STATION) {
                    PRESENT_LOGIN_VC
                    return;
                }
                
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
    }else {
        BATListenTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATListenTopicCell"];
         [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.path = indexPath;
        
        //关注按钮
        WEAK_SELF(self);
        cell.attendBlock = ^(NSIndexPath *path) {
            STRONG_SELF(self);
            if (!LOGIN_STATION) {
                PRESENT_LOGIN_VC
                return;
            }

            HotTopicListData *data = self.listModel.Data[path.row];
            NSString *urlString = nil;
            if (data.IsTopicFollow) {
                urlString = @"/api/dynamic/CancelOperation";
                [self AttendTopicRequesetWithURL:urlString monent:data type:2];
            }else {
                urlString = @"/api/dynamic/ExecuteOperation";
                [self AttendTopicRequesetWithURL:urlString monent:data type:2];
            }
            
        };
        if (self.listModel.Data >0) {
            cell.listData = self.listModel.Data[indexPath.row];
        }
        return cell;
    }
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 1) {
        self.currentIndex = indexPath.row;
        HotTopicData *moment = self.dataArray[indexPath.row];
        if (moment.ReplyType == 1) {
            BATListenDoctorDetailController *detailVC = [[BATListenDoctorDetailController alloc]init];
            detailVC.ID = moment.ID;
            detailVC.titleString = moment.Topic;
            
            
            WEAK_SELF(self);
            detailVC.listenDoctorBlock = ^(BOOL isAttend) {
                STRONG_SELF(self);
             HotTopicData *moment = self.dataArray[self.currentIndex];
              
                    for ( HotTopicData *data in self.dataArray) {
                        if ([data.AccountID isEqualToString:moment.AccountID]) {
                            data.IsUserFollow = isAttend;
                        }
                    }
                [_listenTab reloadData];
                
            };
            
            detailVC.listenDoctorUpdateReadNumBlock = ^(){
                
            HotTopicData *moment = self.dataArray[self.currentIndex];
               
                moment.ReadNum = [NSString stringWithFormat:@"%zd", [moment.ReadNum integerValue] + 1];
                [_listenTab reloadData];
                
            };
            [self.navigationController pushViewController:detailVC animated:YES];
        }else {
            BATInvitationDetailController *invitationDetailVC = [[BATInvitationDetailController alloc]init];
            invitationDetailVC.ID = moment.ID;
            invitationDetailVC.updateReadNumBlock = ^(){
              HotTopicData *moment = self.dataArray[self.currentIndex];
                moment.ReadNum = [NSString stringWithFormat:@"%zd", [moment.ReadNum integerValue] + 1];
                [_listenTab reloadData];
                
            };
            invitationDetailVC.priseBlock = ^(BOOL isPrise) {
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
                [_listenTab reloadData];
            };
            [self.navigationController pushViewController:invitationDetailVC animated:YES];
        }
      
    }else {
        
        HotTopicListData *listData = self.listModel.Data[indexPath.row];
        BATTopicDetailController *TopicDetailVC = [[BATTopicDetailController alloc]init];
        TopicDetailVC.ID = listData.ID;
        if (indexPath.row!=0) {
            TopicDetailVC.isAudio = NO;
        }else {
            TopicDetailVC.isAudio = YES;
        }
         [self.navigationController pushViewController:TopicDetailVC animated:YES];
    }
   

}

- (void)AttendTopicRequesetWithURL:(NSString *)url monent:(HotTopicListData *)monent type:(NSInteger)type {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@(type) forKey:@"RelationType"];
    [dict setObject:monent.ID forKey:@"RelationID"];
    
    [HTTPTool requestWithURLString:url parameters:dict type:kPOST success:^(id responseObject) {
        
        monent.IsTopicFollow = !monent.IsTopicFollow;
        [self.listenTab reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)AttendRequesetWithURL:(NSString *)url monent:(HotTopicData *)monent {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"3" forKey:@"RelationType"];
    [dict setObject:monent.AccountID forKey:@"RelationID"];
    
    [HTTPTool requestWithURLString:url parameters:dict type:kPOST success:^(id responseObject) {
        
        monent.IsUserFollow = !monent.IsUserFollow;
        
        for (HotTopicData *data in self.dataArray) {
            if ([data.AccountID isEqualToString:monent.AccountID]) {
                data.IsUserFollow = monent.IsUserFollow;
            }
        }
        [self.listenTab reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

    if (section == 1) {
        return nil;
    }
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    backView.backgroundColor = BASE_BACKGROUND_COLOR;
    return backView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return 0.01;
    }
    return 10;
}

#pragma mark - NET
#pragma mark - 获取热门内容列表
- (void)attentionRequest {
    
    [HTTPTool requestWithURLString:@"/api/dynamic/GetPostList"
                        parameters:@{
                                     @"pageIndex":@(self.currentPage),
                                     @"pageSize":@"10",
                                     @"CategoryID":@(2)
                                     }
                              type:kGET
                           success:^(id responseObject) {
                               
                               [self.listenTab.mj_header endRefreshingWithCompletionBlock:^{
                                   
                                   [self.listenTab reloadData];
                               }];
                               
                               [self.listenTab.mj_footer endRefreshing];
                               BATHotTopicModel * tmpModel = [BATHotTopicModel mj_objectWithKeyValues:responseObject];
                               
                               
                               
                               
                               if (tmpModel.ResultCode == 0) {
                                   if (self.currentPage == 0) {
                                       self.dataArray = [NSMutableArray array];
                                   }
                                   
                                   [self.dataArray addObjectsFromArray:tmpModel.Data];
                                   
                                   for (HotTopicData *data in self.dataArray) {
                                       data.isShowTime = NO;
                                   }
                                   
                                   if (tmpModel.RecordsCount > 0) {
                                       self.listenTab.mj_footer.hidden = NO;
                                   } else {
                                       self.listenTab.mj_footer.hidden = YES;
                                   }
                                   
                                   if (self.dataArray.count == tmpModel.RecordsCount) {
                                       [self.listenTab.mj_footer endRefreshingWithNoMoreData];
                                   }
                                   [self.listenTab reloadData];
                                   
                                   //                                   if (self.dataArray.count == 0) {
                                   //                                       [self.defaultView showDefaultView];
                                   //                                   }
                               }
                               
                           } failure:^(NSError *error) {
                               
                               [self.listenTab.mj_header endRefreshingWithCompletionBlock:^{
                                   //                                   self.isCompleteRequest = YES;
                                   //                                   [self.finalStage reloadData];
                               }];
                               [self.listenTab.mj_footer endRefreshing];
                               self.currentPage --;
                               if (self.currentPage < 0) {
                                   self.currentPage = 0;
                               }
                               
                               //                               [self.defaultView showDefaultView];
                               
                           }];
    
    
}

#pragma mark - 获取热门话题列表
- (void)getHotTopicLise {
    
    [HTTPTool requestWithURLString:@"/api/dynamic/GetTopicList"
                        parameters:@{
                                     @"pageIndex":@(self.currentPage),
                                     @"pageSize":@"10",
                                     @"CategoryID":@(2)
                                     }
                              type:kGET
                           success:^(id responseObject) {
                               
                               self.listModel = [BATHotTopicListModel mj_objectWithKeyValues:responseObject];
                               
                               
                               for (HotTopicListData *data in self.listModel.Data) {
                                   data.Topic = [NSString stringWithFormat:@"%@",data.Topic];
                               }
                               
                               [self.listenTab reloadData];
                               
                           } failure:^(NSError *error) {
                               
                               
                           }];
    
}



#pragma mark - Lazy Load
- (UITableView *)listenTab {

    if (!_listenTab) {
        _listenTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
        _listenTab.delegate = self;
        _listenTab.dataSource = self;
        _listenTab.estimatedRowHeight = 250;
        _listenTab.rowHeight = UITableViewAutomaticDimension;
         [_listenTab registerNib:[UINib nibWithNibName:@"BATListenTopicCell" bundle:nil] forCellReuseIdentifier:@"BATListenTopicCell"];
        [_listenTab registerNib:[UINib nibWithNibName:@"BATTopicTableViewCell" bundle:nil] forCellReuseIdentifier:@"BATTopicTableViewCell"];
        
        [_listenTab setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        WEAK_SELF(self);
        _listenTab.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.currentPage = 0;
            [self attentionRequest];
        }];
        _listenTab.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.currentPage ++;
            [self attentionRequest];
        }];

    }
    return _listenTab;
}

@end
