//
//  BATMyFindViewController.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/3/14.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATMyFindViewController.h"
#import "BATFindHotCell.h"
#import "YYText.h"
#import "BATMyTopicListViewcontroller.h"
#import "BATTopicTableViewCell.h"
#import "BATUserPersonCenterViewController.h"
#import "BATMyFindSearchController.h"
#import "BATHotTopicModel.h"
#import "BATHotTopicListModel.h"
#import "BATTopicDetailController.h"
#import "BATInvitationDetailController.h"
#import "BATTopicPersonController.h"
#import "UIButton+AFNetworking.h"
#import "BATPerson.h"
#import "BATTopicPersonController.h"
#import "BATGraditorButton.h"
#import "BATPersonDetailController.h"
#import "BATSendDynamicViewController.h"
@interface BATMyFindViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic,strong) UITableView *findTab;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,strong) NSMutableAttributedString *text;
@property (nonatomic,assign) CGFloat yyHeight;
@property (nonatomic,strong) UITextField *searchTF;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) BATHotTopicListModel *listModel;
@property (nonatomic,strong) NSString *KeyWord;
@property (nonatomic,assign) NSInteger currentIndex;
@end

@implementation BATMyFindViewController

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self pageLayout];
    
    [self getHotTopicLise];
    
    [self attentionRequest];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
    if (section == 0) {
        return 1;
    }
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        BATFindHotCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATFindHotCell"];
        
        if (self.listModel) {
            [cell confirgationCell:self.listModel];
        }
        
        cell.topicKeyTapBlock = ^(NSIndexPath *path,NSString *ID) {
            BATTopicDetailController *detailVC = [[BATTopicDetailController alloc]init];
            detailVC.ID = ID;
            [self.navigationController pushViewController:detailVC animated:YES];
        };
    
        return cell;
    }
    
    BATTopicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATTopicTableViewCell"];
    
    if (self.dataArray.count > 0) {
        HotTopicData *moment = self.dataArray[indexPath.row];
        moment.isShowTime = NO;
        cell.indexPath = indexPath;
        [cell configrationCell:moment];
        cell.moreButton.hidden = YES;
       // WEAK_SELF(self);
        cell.avatarAction = ^(NSIndexPath *cellIndexPath) {
          //  STRONG_SELF(self);
            DDLogWarn(@"头像点击%@",cellIndexPath);
            if (!LOGIN_STATION) {
                PRESENT_LOGIN_VC;
                return;
            }

            HotTopicData *moment = self.dataArray[cellIndexPath.row];
            
            //新个人主页控制器
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
            
            if (!LOGIN_STATION) {
                PRESENT_LOGIN_VC;
                return;
            }
            DDLogWarn(@"更多操作点击%@",cellIndexPath);
            HotTopicData *moment = self.dataArray[cellIndexPath.row];
            [self attendActionRequest:moment];
//            STRONG_SELF(self);
            //            [self moreAction:cellIndexPath];
            
        };
        
        cell.commentAction = ^(NSIndexPath *cellIndexPath) {
            
            if (!LOGIN_STATION) {
                PRESENT_LOGIN_VC;
                return;
            }
            DDLogWarn(@"评论按钮点击%@",cellIndexPath);
            //    STRONG_SELF(self);
            //            self.selectCommentIndexPath = cellIndexPath;
            //            [self.inputBar.textView becomeFirstResponder];

            
            NSString *urlString = nil;
            if (moment.IsUserFollow) {
                urlString = @"/api/dynamic/CancelOperation";
                [self AttendRequesetWithURL:urlString monent:moment];
            }else {
                urlString = @"/api/dynamic/ExecuteOperation";
                [self AttendRequesetWithURL:urlString monent:moment];
            }
        };

        
        cell.thumbsUpAction = ^(NSIndexPath *cellIndexPath) {
            
            if (!LOGIN_STATION) {
                PRESENT_LOGIN_VC;
                return;
            }
            DDLogWarn(@"点赞按钮点击%@",cellIndexPath);
//            STRONG_SELF(self);
            //   [self requestCancelAndThumpUp:cellIndexPath];
        };

    }
    return cell;
    
}

//对人关注
- (void)attendActionRequest:(HotTopicData *)topidData {
    
    NSString *url = nil;
    if (topidData.IsUserFollow) {
        url = @"/api/dynamic/CancelOperation";
    }else {
        url = @"/api/dynamic/ExecuteOperation";
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"3" forKey:@"RelationType"];
    [dict setObject:topidData.AccountID forKey:@"RelationID"];
    [HTTPTool requestWithURLString:url parameters:dict type:kPOST success:^(id responseObject) {
        
//        NSLog(@"%@",responseObject);
        topidData.IsUserFollow = !topidData.IsUserFollow;
        
        for (HotTopicData *data in self.dataArray) {
            if (data.AccountID == topidData.AccountID) {
                data.IsUserFollow = topidData.IsUserFollow;
            }
        }
        
        [self.findTab reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)AttendRequesetWithURL:(NSString *)url monent:(HotTopicData *)monent {
   
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"3" forKey:@"RelationType"];
    [dict setObject:monent.AccountID forKey:@"RelationID"];
    
    [HTTPTool requestWithURLString:url parameters:dict type:kPOST success:^(id responseObject) {
        
        monent.IsUserFollow = !monent.IsUserFollow;
        [self.findTab reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 42.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    if (section == 0) {
        return 10;
    }else {
        return 0.01;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

    if (section == 0) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        view.backgroundColor = BASE_BACKGROUND_COLOR;
        return view;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 42.5)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 150, 42.5)];
    title.textColor = UIColorFromHEX(0X333333, 1);
    title.font = [UIFont systemFontOfSize:15];
    [view addSubview:title];
    
   
    UIView *lineView =[[UIView alloc]initWithFrame:CGRectMake(0, 43, SCREEN_WIDTH, 1)];
    lineView.backgroundColor = BASE_BACKGROUND_COLOR;
    [view addSubview:lineView];
    
    if (section == 0) {
        title.text = @"热门话题";
    
        BATGraditorButton *moreLb = [[BATGraditorButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 20 - 150, 0, 150, 42.5)];
        moreLb.titleRect = CGRectMake(70, 10, 80, 30);
        moreLb.titleLabel.textAlignment = NSTextAlignmentRight;
//        moreLb.textColor = UIColorFromHEX(0X333333, 1);
        moreLb.enbleGraditor = YES;
        [moreLb setGradientColors:@[START_COLOR,END_COLOR]];
        moreLb.titleLabel.font = [UIFont systemFontOfSize:15];
        title.textColor = UIColorFromHEX(0X333333, 1);
        title.font = [UIFont systemFontOfSize:15];
        [moreLb addTarget:self action:@selector(pushAction) forControlEvents:UIControlEventTouchUpInside];
        [moreLb setTitle:@"更多话题" forState:UIControlStateNormal];
        [view addSubview:moreLb];
        
    }else {
        title.text = @"热门内容";
    }
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
    self.currentIndex = indexPath.row;
    HotTopicData *moment = self.dataArray[indexPath.row];
    moment.ReadNum = [NSString stringWithFormat:@"%zd", [moment.ReadNum integerValue]+1];
   
    [self.findTab reloadData];
    
    BATInvitationDetailController *invitationVC = [[BATInvitationDetailController alloc]init];
    invitationVC.ID = moment.ID;
    
    WEAK_SELF(self);
    invitationVC.priseBlock = ^(BOOL isPrise) {
        STRONG_SELF(self);
        HotTopicData *moment = self.dataArray[self.currentIndex];
        if (isPrise) {
            moment.StarNum += 1;
        }else {
            if (moment.StarNum <=0) {
                moment.StarNum = 0;
            }else {
                moment.StarNum -= 1;
            }
        }
        [_findTab reloadData];
    };
    [self.navigationController pushViewController:invitationVC animated:YES];
}

#pragma mark - Action
- (void)pushAction {

    BATMyTopicListViewcontroller *listVC = [[BATMyTopicListViewcontroller alloc]init];
    listVC.updateAction = ^(){
      
        [_findTab.mj_header beginRefreshing];
    };
    [self.navigationController pushViewController:listVC animated:YES];
}
- (void)pushEditVC {
    if (!LOGIN_STATION) {
        PRESENT_LOGIN_VC
        return;
    }
//    if (!self.listModel) {
//        return;
//    }
    BATSendDynamicViewController *postVC = [[BATSendDynamicViewController alloc]init];
//    postVC.topicListArr = self.listModel.Data;//进去请求更多话题第一页，讨论一下未选择话题和选择话题进去需不需要显示选择帖子话题。因为点击发布的时候需要ID
    //两个问题1、提示框，2、话题分页，是否需要新的接口，两个入口，选中问题
    [self.navigationController pushViewController:postVC animated:YES];
}

#pragma mark - 对某一行点赞或者取消点赞

- (void)requestCancelAndThumpUp:(NSIndexPath *)indexPath{
        //点赞某一行动态
        
        if (!LOGIN_STATION) {
            PRESENT_LOGIN_VC
            return;
        }
        
        BATMomentData *moment = self.dataArray[indexPath.row];
        
        NSDictionary *params = @{@"OBJ_TYPE":@(kBATCollectionLinkTypeCare), @"OBJ_ID":moment.PostId};
        
        [HTTPTool requestWithURLString:(!moment.MarkHelpful ? @"/api/CollectLink/AddCollectLink" : @"/api/CollectLink/CanelCollectLink") parameters:params type:kPOST success:^(id responseObject) {
            
            if (!moment.MarkHelpful) {
                moment.MarkHelpful = YES;
                moment.MarkHelpfulCount++;
            } else {
                moment.MarkHelpful = NO;
                moment.MarkHelpfulCount--;
                
                if (moment.MarkHelpfulCount < 0) {
                    moment.MarkHelpfulCount = 0;
                }
            }
            
            [self.findTab reloadData];
            
        } failure:^(NSError *error) {
            
        }];
        
        
}

- (void)reloadAction {
  
    [self.findTab.mj_header beginRefreshing];
}

#pragma mark - pageLayout
- (void)pageLayout {
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAction) name:@"SEND_DYNAMIC_SUCCESS" object:nil];
    
    self.dataArray = [NSMutableArray array];
    self.title = @"发现";
    
    /*
    BATPerson *person = PERSON_INFO;
    UIButton *rightButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton2.frame = CGRectMake(0, 0, 40, 40);
    rightButton2.clipsToBounds = YES;
    rightButton2.layer.cornerRadius = 20;
    rightButton2.layer.borderWidth = 1;
    rightButton2.layer.borderColor = [UIColor clearColor].CGColor;
    [rightButton2 addTarget:self action:@selector(pushCustomAction) forControlEvents:UIControlEventTouchUpInside];
    [rightButton2 setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:person.Data.PhotoPath]];
    UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc]initWithCustomView:rightButton2];
    self.navigationItem.rightBarButtonItem = deleteButton;
     */
    
    UIButton *customeView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [customeView setImage:[UIImage imageNamed:@"icon-bx"] forState:UIControlStateNormal];
    [customeView addTarget:self action:@selector(pushEditVC) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *sendBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:customeView];
    self.navigationItem.rightBarButtonItem = sendBarButtonItem;
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    headerView.backgroundColor = [UIColor whiteColor];
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
    [headerView addSubview:self.searchTF];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 1)];
    lineView.backgroundColor = BASE_BACKGROUND_COLOR;
    
    [headerView addSubview:lineView];
    [self.view addSubview:headerView];
    
//    self.findTab.tableHeaderView = headerView;
    
    [self.view addSubview:self.findTab];
    
    
}

//- (void)pushCustomAction {
//    BATTopicPersonController *personVC  = [[BATTopicPersonController alloc]init];
//    personVC.accountID = @"0";
//    [self.navigationController pushViewController:personVC animated:YES];
//}

#pragma mark - TextFiledDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    if (self.KeyWord.length == 0) {
        textField.enablesReturnKeyAutomatically = YES;
        return NO;
    }
    BATMyFindSearchController *listVC = [[BATMyFindSearchController alloc]init];
    listVC.KeyWord = self.KeyWord;
    [self.navigationController pushViewController:listVC animated:YES];
    self.searchTF.text = nil;
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textfiled {

    self.KeyWord = textfiled.text;
}
#pragma mark - NET

#pragma mark - 获取热门话题列表
- (void)getHotTopicLise {
  
    [HTTPTool requestWithURLString:@"/api/dynamic/GetTopicList"
                        parameters:@{
                                     @"pageIndex":@(self.currentPage),
                                     @"pageSize":@"10",
                                     @"CategoryID":@(1)
                                     }
                              type:kGET
                           success:^(id responseObject) {
                               
                               self.listModel = [BATHotTopicListModel mj_objectWithKeyValues:responseObject];
                               

                               for (HotTopicListData *data in self.listModel.Data) {
                                   data.Topic = [NSString stringWithFormat:@"#%@#",data.Topic];
                               }
                     
                               [self.findTab reloadData];
                               
                           } failure:^(NSError *error) {
                               
                               
                           }];
    
}

#pragma mark - 获取热门内容列表
- (void)attentionRequest {
    
    [HTTPTool requestWithURLString:@"/api/dynamic/GetPostList"
                        parameters:@{
                                     @"pageIndex":@(self.currentPage),
                                     @"pageSize":@"10",
                                     @"CategoryID":@(1)
                                     }
                              type:kGET
                           success:^(id responseObject) {
                               
                               [self.findTab.mj_header endRefreshingWithCompletionBlock:^{

                                    [self.findTab reloadData];
                               }];
                               
                               [self.findTab.mj_footer endRefreshing];
                               BATHotTopicModel * tmpModel = [BATHotTopicModel mj_objectWithKeyValues:responseObject];
                               
                               

                               
                               if (tmpModel.ResultCode == 0) {
                                   if (self.currentPage == 0) {
                                       self.dataArray = [NSMutableArray array];
                                   }
                                   
                                   [self.dataArray addObjectsFromArray:tmpModel.Data];
                                   
                                   if (tmpModel.RecordsCount > 0) {
                                       self.findTab.mj_footer.hidden = NO;
                                   } else {
                                       self.findTab.mj_footer.hidden = YES;
                                   }
                                   
                                   if (self.dataArray.count == tmpModel.RecordsCount) {
                                       [self.findTab.mj_footer endRefreshingWithNoMoreData];
                                   }
                                   [self.findTab reloadData];
                                   
//                                   if (self.dataArray.count == 0) {
//                                       [self.defaultView showDefaultView];
//                                   }
                               }
                               
                           } failure:^(NSError *error) {
                               
                               [self.findTab.mj_header endRefreshingWithCompletionBlock:^{
//                                   self.isCompleteRequest = YES;
//                                   [self.finalStage reloadData];
                               }];
                               [self.findTab.mj_footer endRefreshing];
                               self.currentPage --;
                               if (self.currentPage < 0) {
                                   self.currentPage = 0;
                               }
                               
//                               [self.defaultView showDefaultView];
                               
                           }];
    
    
}

#pragma mark - setter && getter
- (UITableView *)findTab {
    if (!_findTab) {
        _findTab = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT - 40 -60) style:UITableViewStylePlain];
        _findTab.delegate = self;
        _findTab.dataSource = self;
        _findTab.separatorStyle = UITableViewCellSeparatorStyleNone;
        _findTab.estimatedRowHeight = 250;
        _findTab.rowHeight = UITableViewAutomaticDimension;
        _findTab.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _findTab.tableFooterView = [UIView new];
        [_findTab registerNib:[UINib nibWithNibName:@"BATTopicTableViewCell" bundle:nil] forCellReuseIdentifier:@"BATTopicTableViewCell"];
        [_findTab registerClass:[BATFindHotCell class] forCellReuseIdentifier:@"BATFindHotCell"];
        
        
        WEAK_SELF(self);
        _findTab.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.currentPage = 0;
            [self attentionRequest];
        }];
        _findTab.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.currentPage ++;
            [self attentionRequest];
        }];
        
        _findTab.mj_footer.hidden = YES;
    }
    return _findTab;
}

- (UITextField *)searchTF {
    
    if (!_searchTF) {
        _searchTF = [UITextField textFieldWithfont:[UIFont systemFontOfSize:14] textColor:nil placeholder:nil BorderStyle:UITextBorderStyleNone];
        _searchTF.frame = CGRectMake(10, 5, SCREEN_WIDTH - 20, 30);
        _searchTF.clearButtonMode = UITextFieldViewModeNever;
        _searchTF.placeholder = @"搜话题、帖子、好友";
        _searchTF.textColor = UIColorFromHEX(0X999999, 1);
        _searchTF.returnKeyType = UIReturnKeySearch;
        _searchTF.backgroundColor = [UIColor colorWithPatternImage:[Tools imageFromColor:UIColorFromHEX(0Xf6f6f6, 1)]];
        [_searchTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _searchTF.clipsToBounds = YES;
        UIImageView *searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic-search"]];
        UIView *leftIcon = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
        [leftIcon addSubview:searchIcon];
        [searchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(leftIcon);
        }];
        _searchTF.leftView = leftIcon;
        _searchTF.leftViewMode = UITextFieldViewModeAlways;
        _searchTF.delegate = self;
        
        _searchTF.layer.cornerRadius = 5.0f;
        _searchTF.clipsToBounds = YES;
    }
    return _searchTF;
}

@end
