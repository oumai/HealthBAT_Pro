//
//  BATMyAttendController.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/3/27.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATMyAttendController.h"
#import "BATDefaultView.h"
#import "BATMyFansModel.h"
#import "BATMyFansTableViewCell.h"
#import "BATTopicPersonController.h"
#import "BATPerson.h"
#import "BATPersonDetailController.h"

@interface BATMyAttendController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *attendTab;

@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,assign) NSInteger pageIndex;

@property (nonatomic,strong) BATDefaultView *defaultView;

@end

@implementation BATMyAttendController

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAction) name:@"DETAILRELOAD" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAction) name:@"PersonHeadImageAction" object:nil];
    
    self.dataSource = [NSMutableArray array];
    
    [self attendRequest];
    
    [self.view addSubview:self.attendTab];
    
    [self.view addSubview:self.defaultView];
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.top.equalTo(self.view);
    }];
    
}

- (void)reloadAction {
  
    self.pageIndex = 0;
    [self attendRequest];
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    BATMyFansTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATMyFansTableViewCell" forIndexPath:indexPath];
    
    if (_dataSource.count > 0) {
        cell.indexPath = indexPath;
        BATMyFansData *myFansData = _dataSource[indexPath.row];
        [cell configrationEachAttendCell:myFansData];
        
        WEAK_SELF(self);
        cell.followUser = ^(){
            STRONG_SELF(self);        
            if (myFansData.IsAttned) {
            
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否取消关注" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    
                }];
                
                UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    STRONG_SELF(self);
                    
                    [self requestFollow:myFansData indexPath:indexPath];
                }];
                
                [alertController addAction:otherAction];
                [alertController addAction:cancelAction];
                
                [self.navigationController presentViewController:alertController animated:YES completion:nil];
            }else {
                  [self requestFollow:myFansData indexPath:indexPath];
            }
        
        };
    
    
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BATMyFansData *myFansData = _dataSource[indexPath.row];
    
    //新个人主页控制器
    BATPersonDetailController *personDetailVC = [[BATPersonDetailController alloc]init];
    personDetailVC.accountID = [NSString stringWithFormat:@"%zd",myFansData.AccountID];
    [self.navigationController pushViewController:personDetailVC animated:YES];
   /*
    BATTopicPersonController *userPersonCenterVC = [[BATTopicPersonController alloc] init];
    
    userPersonCenterVC.accountID = [NSString stringWithFormat:@"%zd",myFansData.AccountID];
    [self.navigationController pushViewController:userPersonCenterVC animated:YES];
    */
}

#pragma mark - 关注或取消关注
- (void)requestFollow:(BATMyFansData *)model indexPath:(NSIndexPath *)indexPath
{
    
    NSString *urlString = nil;
        if (model.IsAttned) {
            urlString = @"/api/dynamic/CancelOperation";
    
        }else {
            urlString = @"/api/dynamic/ExecuteOperation";
    
        }
    
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:@"3" forKey:@"RelationType"];
        [dict setObject:@(model.AccountID) forKey:@"RelationID"];
    
        [HTTPTool requestWithURLString:urlString parameters:dict type:kPOST success:^(id responseObject) {
    
            [[NSNotificationCenter defaultCenter] postNotificationName:@"FANSTABLEVIEWRELOAD" object:nil];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"TopiDetailReload" object:nil];
            model.IsAttned = !model.IsAttned;
//            [self.dataSource removeObjectAtIndex:indexPath.row];
            [_attendTab reloadData];
            if (_dataSource.count == 0) {
                [self.defaultView showDefaultView];
            }

        } failure:^(NSError *error) {
            
        }];
    
    
}

#pragma mark - NET 
- (void)attendRequest {

    NSString *accountID = nil;
    if (self.accountID) {
        accountID = self.accountID;
    }else {
        accountID = @"";
    }
    
    [HTTPTool requestWithURLString:@"/api/dynamic/GetMyFollowUser" parameters:@{@"pageIndex":@(_pageIndex),@"pageSize":@(10),@"accountId":accountID,} type:kGET success:^(id responseObject) {
        
  
         _attendTab.mj_footer.hidden = NO;
        
        [_attendTab.mj_footer endRefreshing];
        [_attendTab.mj_header endRefreshing];
        
        if (_pageIndex == 0) {
            [_dataSource removeAllObjects];
        }
        
        BATMyFansModel *myFansModel = [BATMyFansModel mj_objectWithKeyValues:responseObject];
        
        [_dataSource addObjectsFromArray:myFansModel.Data];
        
        BATPerson *person = PERSON_INFO;
        if (_dataSource.count>0) {
            for (int i=0; i<_dataSource.count; i++) {
                BATMyFansData *data = _dataSource[i];
                if (person.Data.AccountID == data.AccountID) {
//                    [_dataSource removeObjectAtIndex:i];
                }else {
                    if ([NSString stringWithFormat:@"%zd",person.Data.AccountID] == self.accountID) {
                        data.IsShowBtn = YES;
                    }else {
                    data.IsShowBtn = NO;
                    }
                }
                
                data.IsAttned = YES;
            }
        }
       
        
        
//        for (BATMyFansData *data in _dataSource) {
//            if ([NSString stringWithFormat:@"%zd",person.Data.AccountID] == self.accountID) {
//                data.IsShowBtn = YES;
//            }else {
//                data.IsShowBtn = NO;
//            }
//            
//            data.IsAttned = YES;
//        }
        
        if (myFansModel.RecordsCount > 0) {
            _attendTab.mj_footer.hidden = NO;
        } else {
            _attendTab.mj_footer.hidden = YES;
        }
        
        if (_dataSource.count == myFansModel.RecordsCount) {
            [_attendTab.mj_footer endRefreshingWithNoMoreData];
        }
        
        [_attendTab reloadData];
        
        if (_dataSource.count == 0) {
            [self.defaultView showDefaultView];
          //  self.defaultView.reloadButton.hidden = NO;
        }else {
            self.defaultView.hidden = YES;
        }
        
    } failure:^(NSError *error) {
        [_attendTab.mj_header endRefreshing];
        [_attendTab.mj_footer endRefreshing];
        _pageIndex--;
        if (_pageIndex < 0) {
            _pageIndex = 0;
        }
        
        [_attendTab.mj_footer endRefreshing];
        [_attendTab.mj_header endRefreshing];
        
        [self.defaultView showDefaultView];
        ///self.defaultView.reloadButton.hidden = NO;
    }];
}

#pragma mark - Lazy Load
- (UITableView *)attendTab {

    if (!_attendTab) {
        _attendTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 45 - 10) style:UITableViewStylePlain];
        _attendTab.delegate = self;
        _attendTab.dataSource = self;
        _attendTab.tableFooterView = [UIView new];
        [_attendTab registerNib:[UINib nibWithNibName:@"BATMyFansTableViewCell" bundle:nil] forCellReuseIdentifier:@"BATMyFansTableViewCell"];
        
        WEAK_SELF(self);
        _attendTab.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.pageIndex = 0;
            [self attendRequest];
        }];
        _attendTab.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.pageIndex ++;
            [self attendRequest];
        }];
        _attendTab.mj_footer.hidden = YES;
    }
    return _attendTab;
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
            
            [self.attendTab.mj_header beginRefreshing];
            
        }];
        
    }
    return _defaultView;
}

@end
