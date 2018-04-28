//
//  BATHealthFollowViewController.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/2/21.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHealthFollowViewController.h"
#import "BATHealthFollowCell.h"
#import "BATFindViewController.h"
#import "BATCourseSearchViewController.h"
#import "BATCourseDetailViewController.h"
#import "BATCourseNewDetailViewController.h"
#import "BATMyProjectController.h"

#import "BATHealthFollowMenuCell.h"
#import "BATHealthFollowTableCell.h"

@interface BATHealthFollowViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,assign) BOOL canScroll;

@end

@implementation BATHealthFollowViewController

- (instancetype)init
{
    self = [super init];
    if (self) {

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(healthFollowViewCanScroll:) name:@"HealthFollowViewCanScrollNotification" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(healthFollowViewScrollToOneIndex:) name:@"Health_Attion_Pop_More_From_Home" object:nil];
        
    }
    return self;
}

- (void)dealloc
{
    self.healthFollowView.tableView.dataSource = nil;
    self.healthFollowView.tableView.delegate = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadView
{
    [super loadView];
    
    
    [self pageLayout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"健康关注";
    
    self.canScroll = YES;

    [self.healthFollowView.tableView setContentOffset:CGPointMake(0, 60)];

//    [self isShowGuide];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BATHealthFollowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATHealthFollowCell" forIndexPath:indexPath];
    
    WEAK_SELF(self);
    cell.healthCourseClick = ^(BATCourseData *data){
        STRONG_SELF(self);
        [self requestUpdataCourseReadingNum:indexPath model:data];
        
        BATCourseNewDetailViewController *courseDetailVC = [[BATCourseNewDetailViewController alloc] init];
        courseDetailVC.courseID = data.ID;
        courseDetailVC.isPushFromHome = NO;
        courseDetailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:courseDetailVC animated:YES];
        
    };
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.canScroll) {
        [self.healthFollowView.tableView setContentOffset:CGPointMake(0, self.healthFollowView.tableHeaderView.frame.size.height) animated:NO];
        return;
    }
    
    if (scrollView.contentOffset.y >= self.healthFollowView.tableHeaderView.frame.size.height && self.canScroll) {
        self.canScroll = NO;
        [self.healthFollowView.tableView setContentOffset:CGPointMake(0, self.healthFollowView.tableHeaderView.frame.size.height) animated:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BATHealthFollowTableCellTableCanScrollNotification" object:nil];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {

    if (scrollView.contentOffset.y < 60 && scrollView.contentOffset.y > 0) {

        if (scrollView.contentOffset.y < 30) {
            [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
        else {
            [scrollView setContentOffset:CGPointMake(0, 60) animated:YES];
        }
    }
}


- (void)healthFollowViewCanScroll:(NSNotification *)notif
{
    self.canScroll = YES;
}

- (void)healthFollowViewScrollToOneIndex:(NSNotification *)sender{
    
    BATHealtFocusType type = [sender.object intValue];
    
    DDLogInfo(@"传出的type === %ld",(long)type);
    
    //先拿到类别选择Cell
    BATHealthFollowCell *cell = [self.healthFollowView.tableView  cellForRowAtIndexPath: [NSIndexPath indexPathForRow:0 inSection:0]];
  
    
    NSIndexPath *clIndexPath =  [NSIndexPath indexPathForRow:type-1
                                                 inSection:0];
    
    [cell.collectionView selectItemAtIndexPath:clIndexPath animated:NO scrollPosition:UICollectionViewScrollPositionLeft];
    
    [cell.categoryView categoryAnimate:(100+type - 1)];
}

#pragma mark - Net
- (void)requestUpdataCourseReadingNum:(NSIndexPath *)indexPath model:(BATCourseData *)model
{
    [HTTPTool requestWithURLString:[NSString stringWithFormat:@"/api/trainingteacher/course/updatereadingnum/%ld",(long)model.ID] parameters:nil type:kGET success:^(id responseObject) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:BATRefreshIndexPathModelNotification object:@{@"courseID":@(model.ID),@"isCollection":@(NO),@"commentState":@(NO),@"isRead":@(YES)}];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - pageLayout
- (void)pageLayout
{
    [self.view addSubview:self.healthFollowView];
    WEAK_SELF(self);
    [self.healthFollowView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self.view);
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 20, 40);
    [btn bk_whenTapped:^{
        [self.tabBarController setSelectedIndex:0];
    }];
    [btn setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
}

#pragma mark - get & set
- (BATHealthFollowView *)healthFollowView
{
    if (_healthFollowView == nil) {
        _healthFollowView = [[BATHealthFollowView alloc] init];
        _healthFollowView.tableView.delegate = self;
        _healthFollowView.tableView.dataSource = self;
        _healthFollowView.tableView.rowHeight = SCREEN_HEIGHT - 64 - 49;

        [_healthFollowView.tableView registerClass:[BATHealthFollowCell class] forCellReuseIdentifier:@"BATHealthFollowCell"];
        
        WEAK_SELF(self);
        _healthFollowView.healthFollowMenuView.collectionCellClicked = ^(NSIndexPath *indexPath) {
            STRONG_SELF(self);
            switch (indexPath.row) {
                case 0:
                {
                    if (!LOGIN_STATION) {
                        PRESENT_LOGIN_VC;
                        return;
                    }
                    
                    DDLogWarn(@"我的方案");
                    BATMyProjectController *projectVC = [[BATMyProjectController alloc]init];
                    projectVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:projectVC animated:YES];
                    
                    /*
                    DDLogWarn(@"发现");
                    BATFindViewController *findVC = [[BATFindViewController alloc] init];
                    findVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:findVC animated:YES];
                     */
                }
                    
                    break;
                case 1:
                {
//                    DDLogWarn(@"帖子");
//                    BATMyFocusBBSController *myFocusBBSController = [[BATMyFocusBBSController alloc] init];
//                    myFocusBBSController.hidesBottomBarWhenPushed = YES;
//                    [self.navigationController pushViewController:myFocusBBSController animated:YES];
                }
                    break;
                case 2:
                {
                    if (!LOGIN_STATION) {
                        PRESENT_LOGIN_VC;
                        return;
                    }
                    DDLogWarn(@"我的方案");
                    BATMyProjectController *projectVC = [[BATMyProjectController alloc]init];
                    projectVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:projectVC animated:YES];
                    
                }
                    break;
                    
                default:
                    break;
            }
        };
        
        _healthFollowView.healthFollowSearchView.healthFollowSearchClick = ^(){
            STRONG_SELF(self);
            BATCourseSearchViewController *batCourseSearchVC = [[BATCourseSearchViewController alloc] init];
            batCourseSearchVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:batCourseSearchVC animated:YES];
        };
        
        _healthFollowView.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HealthFollow" object:nil];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.healthFollowView.tableView.mj_header endRefreshing];
            });
            
        }];
    }
    return _healthFollowView;
}


@end
