//
//  BATEvaluateListController.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/4/12.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATEvaluateListController.h"
#import "BATTopicRecordModel.h"
#import "BATCourseCommentTableViewCell.h"
#import "BATTopicPersonController.h"
#import "BATPersonDetailController.h"

@interface BATEvaluateListController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) BATTopicRecordModel *CommentsModel;

@property (nonatomic,strong) UITableView *evaluateTab;

@property (nonatomic,strong) NSString *contentString;

@property (nonatomic,strong) NSString *ParentID;

@property (nonatomic,strong) NSString *ParentLevelID;

@property (nonatomic,assign) NSInteger currentPage;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) BATDefaultView             *defaultView;

@end

@implementation BATEvaluateListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"评价";
    
    self.dataArray = [NSMutableArray array];
    
    [self GetCommentRequest];
    
    WEAK_SELF(self);
    [self.view addSubview:self.evaluateTab];
    [self.evaluateTab mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:self.defaultView];
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self.view);
    }];
}


#pragma mark - 获取回复列表
- (void)GetCommentRequest {
    
    /*
     [HTTPTool requestWithURLString:@"/api/OrderEvaluate/GetEvaluateList" parameters:@{@"doctorID":self.doctorid,@"pageIndex":@"0",@"pageSize":@"10"}  type:kGET success:^(id responseObject) {
     
     [_severTab.mj_header endRefreshing];
     [_severTab.mj_footer endRefreshing];
     
     _severTab.mj_footer.hidden = NO;
     
     self.CommentsModel = [BATTopicRecordModel mj_objectWithKeyValues:responseObject];
     
     for (TopicReplyData *data in self.CommentsModel.Data) {
     data.ReplyContent = data.Comment;
     data.CreatedTime = data.EvaluateTime;
     for (secondReplyData *secData in data.secondReplyList) {
     secData.ReplyContent = secData.Comment;
     }
     }
     
     
     if (self.CommentsModel.Data.count == [self.CommentsModel.RecordsCount integerValue]) {
     [self.severTab.mj_footer endRefreshingWithNoMoreData];
     }
     [_severTab reloadData];
     */
    
    [HTTPTool requestWithURLString:@"/api/OrderEvaluate/GetEvaluateList" parameters:@{@"doctorID":self.doctorid,@"pageIndex":@(self.currentPage),@"pageSize":@"10"} type:kGET success:^(id responseObject) {
        
        [_evaluateTab.mj_header endRefreshing];
        [_evaluateTab.mj_footer endRefreshing];
        
        _evaluateTab.mj_footer.hidden = NO;
        
        if (self.currentPage == 0) {
            [self.dataArray removeAllObjects];
        }
        
        self.CommentsModel = [BATTopicRecordModel mj_objectWithKeyValues:responseObject];

        for (TopicReplyData *data in self.CommentsModel.Data) {
            data.ReplyContent = data.Comment;
            data.CreatedTime = data.EvaluateTime;
            
            for (secondReplyData *secData in data.secondReplyList) {
                secData.ReplyContent = secData.Comment;
            }
        }
        
        [self.dataArray addObjectsFromArray:self.CommentsModel.Data];
        
        if (self.dataArray.count == [self.CommentsModel.RecordsCount integerValue]) {
            [_evaluateTab.mj_footer endRefreshingWithNoMoreData];
        }
        
        [_evaluateTab reloadData];
        
        if (self.dataArray.count == 0) {
            [self.defaultView showDefaultView];
        }
        
    } failure:^(NSError *error) {
        
        [_evaluateTab.mj_header endRefreshing];
        [_evaluateTab.mj_footer endRefreshing];
        
        [self.defaultView showDefaultView];
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    

     return self.dataArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

        BATCourseCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATCourseCommentTableViewCell"];
        cell.indexPath = indexPath;
        [cell configTopicData:self.dataArray[indexPath.row]];
    
    
    TopicReplyData *data = self.dataArray[indexPath.row];
    if (data.IsComplaint) {
        cell.rightUpBtn.hidden = NO;
    }else {
        cell.rightUpBtn.hidden = YES;
    }
    
        cell.commnetButton.hidden = YES;
        cell.commentCountLabel.hidden = YES;
        cell.likeCountLabel.hidden = YES;
        cell.likeButton.hidden = YES;
    
        cell.likeAction = ^(NSIndexPath *cellIndexPath) {
            
            if (!LOGIN_STATION) {
                PRESENT_LOGIN_VC
                return;
            }
            
            TopicReplyData *data = self.CommentsModel.Data[cellIndexPath.row];
            

            NSString *urlString = nil;
            if (data.IsSetStar) {
                
                urlString = @"/api/dynamic/CancelOperation";
                [self AttendTopicRequesetWithURL:urlString monent:data type:1];
                
            }else {
                urlString = @"/api/dynamic/ExecuteOperation";
                [self AttendTopicRequesetWithURL:urlString monent:data type:1];
            }
            
        };
        cell.commentAction = ^(NSIndexPath *cellIndexPath) {
            
            if (!LOGIN_STATION) {
                PRESENT_LOGIN_VC
                return;
            }
            
            TopicReplyData *data = self.CommentsModel.Data[cellIndexPath.row];
            self.ParentID = data.ID;
            self.ParentLevelID = data.ID;
           
            
        };
        
        //头像点击回调
        cell.headimgTapBlocks =^(NSIndexPath *path) {
            TopicReplyData *data = self.CommentsModel.Data[path.row];
            
            //新个人主页控制器
            BATPersonDetailController *personDetailVC = [[BATPersonDetailController alloc]init];
            personDetailVC.accountID = data.AccountID;
            
            [self.navigationController pushViewController:personDetailVC animated:YES];
            /*
            BATTopicPersonController *topicPersonVC = [[BATTopicPersonController alloc]init];
            topicPersonVC.accountID = data.AccountID;
            [self.navigationController pushViewController:topicPersonVC animated:YES];
             */
            
        };
        return cell;

}

- (void)AttendTopicRequesetWithURL:(NSString *)url monent:(TopicReplyData *)monent type:(NSInteger)type {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@(type) forKey:@"RelationType"];
    [dict setObject:monent.ID forKey:@"RelationID"];
    
    [HTTPTool requestWithURLString:url parameters:dict type:kPOST success:^(id responseObject) {
        
        
        if (!monent.IsSetStar) {
            monent.IsSetStar = YES;
            monent.StarNum ++;
        } else {
            monent.IsSetStar = NO;
            monent.StarNum--;
            
            if (monent.StarNum < 0) {
                monent.StarNum = 0;
            }
        }
        [self.evaluateTab reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Lazy Load
- (UITableView *)evaluateTab {
    
    if (!_evaluateTab) {
        _evaluateTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 50) style:UITableViewStylePlain];
        _evaluateTab.delegate = self;
        _evaluateTab.dataSource = self;
        _evaluateTab.estimatedRowHeight = 250;
        _evaluateTab.rowHeight = UITableViewAutomaticDimension;
        _evaluateTab.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_evaluateTab setSeparatorStyle:UITableViewCellSeparatorStyleNone];
       
        [_evaluateTab registerClass:[BATCourseCommentTableViewCell class] forCellReuseIdentifier:@"BATCourseCommentTableViewCell"];
        WEAK_SELF(self);
        _evaluateTab.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.currentPage = 0;
            [self GetCommentRequest];
        }];
        
        _evaluateTab.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.currentPage ++;
            [self GetCommentRequest];
        }];
        
    }
    return _evaluateTab;
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
            [self GetCommentRequest];
        }];
        
    }
    return _defaultView;
}



@end
