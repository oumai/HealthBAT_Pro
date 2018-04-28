//
//  BATTopicPersonController.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/3/17.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATTopicPersonController.h"
#import "BATPersonDetailCell.h"
#import "UINavigationBar+Awesome.h"
#import "BATTopicPersonHeaderView.h"
#import "BATTopicTableViewCell.h"
#import "BATTopicPersonModel.h"
#import "UINavigationBar+Awesome.h"
#import "BATInvitationDetailController.h"
#import "BATPerson.h"
#import "BATDymaicController.h"
#import "BATTopicController.h"
#import "BATMyAttendController.h"
#import "BATMyFansViewController.h"
@interface BATTopicPersonController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *personTab;

@property (nonatomic,strong) BATTopicPersonHeaderView *headerView;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,assign) NSInteger currentPage;

@property (nonatomic,strong) BATTopicPersonModel *model;

@property (nonatomic,strong) UIView *navView;

@property (nonatomic,strong) UIView *lineView;

@property (nonatomic,assign) BOOL isPopBlock;

@property (nonatomic,strong) UIScrollView *mainScrollView;

@end

@implementation BATTopicPersonController

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
//    
//    self.navigationController.navigationBar.translucent=YES;
//    
//    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
//                                                  forBarMetrics:UIBarMetricsDefault];
//    
//    self.navigationController.navigationBar.shadowImage = [UIImage new];
//    
//    [self.navigationController.navigationBar lt_setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0]];
    self.navigationController.navigationBar.hidden = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[BATTopicPersonController class]]) {
            break;
        }

        if (![vc isKindOfClass:[BATTopicPersonController class]]) {
            self.navigationController.navigationBar.hidden = NO;
        }
        
        if (vc == self.navigationController.viewControllers.lastObject) {
            self.navigationController.navigationBar.hidden = NO;
        }
        

    }
    
}


- (void)viewDidDisappear:(BOOL)animated {
  
    [super viewDidDisappear:animated];
//    NSLog(@"viewDidDisappear %zd",self.navigationController.viewControllers.count);
//     NSLog(@"viewDidDisappear %@",self.navigationController.viewControllers);


    
//    NSInteger count = self.navigationController.viewControllers.count;
//    NSString *className  = NSStringFromClass([self class]);
//    for (int i=0; i<count; i++) {
//        UIViewController *VC = self.navigationController.viewControllers[i];
//         NSString *subName  = NSStringFromClass([VC class]);
//        if ([subName isEqualToString:className]) {
//            self.navigationController.navigationBar.hidden = YES;
//        }else {
//            self.navigationController.navigationBar.hidden = NO;
//        }
//    }
//    
//    if (count == 0) {
//        self.navigationController.navigationBar.hidden = NO;
//    }
  
    
    
//    self.navigationController.navigationBar.translucent = NO;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPersonDetailRequest) name:@"DETAILRELOAD" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPersonDetailRequest) name:@"TopiDetailReload" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPersonDetailRequest) name:@"PersonHeadImageAction" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPersonDetailRequest) name:@"MyAttendTopic" object:nil];
    [self pageLayout];
    
    
    [self getPersonDataRequest];
    
    [self setNavView];

}

- (void)setNavView {

    self.navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    self.navView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    
    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 63, SCREEN_WIDTH, 1)];
    self.lineView.backgroundColor = [BASE_LINECOLOR colorWithAlphaComponent:0];
    [self.navView addSubview:self.lineView];
    
    UILabel *titleLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
    titleLb.text = @"个人主页";
    titleLb.textAlignment = NSTextAlignmentCenter;
    titleLb.font = [UIFont systemFontOfSize:20];
    titleLb.textColor = [UIColor whiteColor];
    [self.navView addSubview:titleLb];
    
    UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"back-icon-w"]];
    img.frame = CGRectMake(10,titleLb.center.y - 10, 20, 20);
    [self.navView addSubview:img];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 100, 44)];
    [btn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:btn];
    
    [self.view addSubview:self.navView];
}

- (void)popAction {
   
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)pageLayout {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.dataArray = [NSMutableArray array];
    
    self.mainScrollView = [[UIScrollView alloc] init];
    _mainScrollView.frame = CGRectMake(0, 188, self.view.frame.size.width, self.view.frame.size.height - 188);
    _mainScrollView.scrollEnabled = NO;
    _mainScrollView.contentSize = CGSizeMake(self.view.frame.size.width * 4, 0);
    // 开启分页
    _mainScrollView.pagingEnabled = YES;
    // 没有弹簧效果
    _mainScrollView.bounces = NO;
    // 隐藏水平滚动条
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    // 设置代理
    _mainScrollView.delegate = self;
    [self.view addSubview:_mainScrollView];
    
   
    
   
    
    self.title = @"个人主页";
    
    [self.view addSubview:self.personTab];
    
    

}

- (void)loadTableAction {
//    
    BATDymaicController *oneVC = [[BATDymaicController alloc] init];
    oneVC.AccountID = self.model.Data.AccountID;
    oneVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 188);
    [self.mainScrollView addSubview:oneVC.view];
    [self addChildViewController:oneVC];
    
    [self setupChildViewController];

}

// 添加所有子控制器
- (void)setupChildViewController {
    // 动态
//    BATDymaicController *oneVC = [[BATDymaicController alloc] init];
//    oneVC.view.frame = CGRectMake(0, 0 , SCREEN_WIDTH, SCREEN_HEIGHT - 188);
//    oneVC.AccountID = self.model.Data.AccountID;
//    [self.mainScrollView addSubview:oneVC.view];
// //   [self addChildViewController:oneVC];
    
   
    
    // 关注的话题
    BATTopicController *twoVC = [[BATTopicController alloc] init];
    twoVC.accountID = self.model.Data.AccountID;
    twoVC.view.frame = CGRectMake(SCREEN_WIDTH, 0 , SCREEN_WIDTH, SCREEN_HEIGHT - 188);
    [self.mainScrollView addSubview:twoVC.view];
    [self addChildViewController:twoVC];
    
    // 关注的人
    BATMyAttendController *threeVC = [[BATMyAttendController alloc] init];
    threeVC.accountID = self.model.Data.AccountID;
    threeVC.view.frame = CGRectMake(SCREEN_WIDTH * 2, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 188);
    [self.mainScrollView addSubview:threeVC.view];
    [self addChildViewController:threeVC];
    
    // 粉丝
    BATMyFansViewController *fourVC = [[BATMyFansViewController alloc] init];
    fourVC.accountID = self.model.Data.AccountID;
    fourVC.view.frame = CGRectMake(SCREEN_WIDTH * 3, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 188);
    [self.mainScrollView addSubview:fourVC.view];
    [self addChildViewController:fourVC];
    

     _mainScrollView.scrollEnabled = YES;
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    
    if (indexPath.section == 1) {
         HotTopicData *moment = self.dataArray[indexPath.row];
        BATInvitationDetailController *invitationVC = [[BATInvitationDetailController alloc]init];
        invitationVC.ID = moment.ID;
        [self.navigationController pushViewController:invitationVC animated:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

        BATPersonDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATPersonDetailCell"];
        cell.model = self.model;
    
    
    cell.ChangeScrollView = ^(NSInteger tag){
      
        //[UIView animateWithDuration:0.3 animations:^{
             [self.mainScrollView setContentOffset:CGPointMake(SCREEN_WIDTH * tag, 0)];
       // }];
       
    };
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

        return 56;

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

        return 10;

}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        backView.backgroundColor = BASE_BACKGROUND_COLOR;
        return backView;

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    
//    if (scrollView == self.personTab) {
//        NSInteger contentY = scrollView.contentOffset.y + 20;
//        
//        if (contentY >= 0 && contentY <= 44) {
//            self.navView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:(contentY/44.0)];
//            self.lineView.backgroundColor = [UIColorFromHEX(0xeeeeee, 1) colorWithAlphaComponent:(contentY/44.0)];
//            NSLog(@"%f",((ABS(contentY)/44.0)));
//        }
//        
//        
//        if (contentY > 44) {
//            self.navView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1.0];
//            self.lineView.backgroundColor = [UIColorFromHEX(0xeeeeee, 1) colorWithAlphaComponent:1];
//        }
//
//    }
}

// 显示控制器的view
- (void)showVc:(NSInteger)index {
    
    CGFloat offsetX = index * self.view.frame.size.width;
    
    UIViewController *vc = self.childViewControllers[index];
    
    // 判断控制器的view有没有加载过,如果已经加载过,就不需要加载
    if (vc.isViewLoaded) return;
    
    [self.mainScrollView addSubview:vc.view];
    vc.view.frame = CGRectMake(offsetX, 0, self.view.frame.size.width, self.view.frame.size.height);
//    [self.mainScrollView setContentOffset:CGPointMake(offsetX, 0)];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    // 计算滚动到哪一页
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    // 1.添加子控制器view
    [self showVc:index];
   
    if (scrollView == self.mainScrollView) {
        NSInteger page = scrollView.contentOffset.x/SCREEN_WIDTH;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PersonDetailMainScrollViewChange" object:@{@"page":@(page)}];
    }
    
  
}

#pragma mark - 获取个人详情
- (void)getPersonDataRequest {

    [HTTPTool requestWithURLString:@"/api/dynamic/GetAccountDetail" parameters:@{@"accountId":self.accountID} type:kGET success:^(id responseObject) {
        
        self.model = [BATTopicPersonModel mj_objectWithKeyValues:responseObject];
        
        [self.headerView.headImage sd_setImageWithURL:[NSURL URLWithString:self.model.Data.PhotoPath]];
        self.headerView.nameLb.text = self.model.Data.UserName;
        self.headerView.AttendBtn.selected = self.model.Data.IsUserFollow;
        
        
        [self loadTableAction];
        
        BATPerson *person = PERSON_INFO;
        if (person.Data.AccountID == [self.model.Data.AccountID integerValue]) {
            self.headerView.AttendBtn.hidden = YES;
        }else {
            self.headerView.AttendBtn.hidden = NO;
        }
        
        [self.personTab reloadData];
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark - Lazy Load
- (UITableView *)personTab {

    if (!_personTab) {
        _personTab = [[UITableView alloc]initWithFrame:CGRectMake(0, -20, SCREEN_WIDTH, 208) style:UITableViewStylePlain];
        _personTab.delegate = self;
        _personTab.dataSource = self;
        _personTab.scrollEnabled = NO;
        self.headerView = [[[NSBundle mainBundle] loadNibNamed:@"BATTopicPersonHeaderView" owner:self options:nil] lastObject];
        
        WEAK_SELF(self);
        self.headerView.attendAction = ^(){
             STRONG_SELF(self);
            
            if (!LOGIN_STATION) {
                PRESENT_LOGIN_VC
                return;
            }
            
            NSString *urlString = nil;
            if (self.model.Data.IsUserFollow) {
                urlString = @"/api/dynamic/CancelOperation";
                [self AttendRequesetWithURL:urlString];
            }else {
                urlString = @"/api/dynamic/ExecuteOperation";
                [self AttendRequesetWithURL:urlString];
            }
        };
        _personTab.tableHeaderView = self.headerView;
        _personTab.estimatedRowHeight = 250;
        _personTab.rowHeight = UITableViewAutomaticDimension;
        
        [_personTab registerNib:[UINib nibWithNibName:@"BATPersonDetailCell" bundle:nil] forCellReuseIdentifier:@"BATPersonDetailCell"];
        [_personTab registerNib:[UINib nibWithNibName:@"BATTopicTableViewCell" bundle:nil] forCellReuseIdentifier:@"BATTopicTableViewCell"];

    }
    return _personTab;
}

- (void)AttendRequesetWithURL:(NSString *)url{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"3" forKey:@"RelationType"];
    [dict setObject:self.model.Data.AccountID forKey:@"RelationID"];
   
    [HTTPTool requestWithURLString:url parameters:dict type:kPOST success:^(id responseObject) {
        
        [self getPersonDetailRequest];
        
         [[NSNotificationCenter defaultCenter] postNotificationName:@"PersonHeadImageAction" object:nil];
        
        self.isPopBlock = YES;
        
        if (self.PersonRefreshBlock) {
            self.PersonRefreshBlock(self.isPopBlock);
        }
        
        self.model.Data.IsUserFollow = !self.model.Data.IsUserFollow;
        self.headerView.AttendBtn.selected = self.model.Data.IsUserFollow;
        [self.personTab reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)getPersonDetailRequest {

    [HTTPTool requestWithURLString:@"/api/dynamic/GetAccountDetail" parameters:@{@"accountId":self.accountID} type:kGET success:^(id responseObject) {
        
        self.model = [BATTopicPersonModel mj_objectWithKeyValues:responseObject];
        
        [self.headerView.headImage sd_setImageWithURL:[NSURL URLWithString:self.model.Data.PhotoPath]];
        self.headerView.nameLb.text = self.model.Data.UserName;
        self.headerView.AttendBtn.selected = self.model.Data.IsUserFollow;
        
        BATPerson *person = PERSON_INFO;
        if (person.Data.AccountID == [self.model.Data.AccountID integerValue]) {
            self.headerView.AttendBtn.hidden = YES;
        }else {
            self.headerView.AttendBtn.hidden = NO;
        }
        
        [self.personTab reloadData];
    } failure:^(NSError *error) {
        
    }];
}


@end
