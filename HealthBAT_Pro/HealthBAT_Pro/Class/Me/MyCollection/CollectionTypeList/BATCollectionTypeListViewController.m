//
//  BATCollectionTypeListViewController.m
//  HealthBAT_Pro
//
//  Created by KM on 16/7/272016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATCollectionTypeListViewController.h"
#import "BATCollectionListViewController.h"

#import "DLTabedSlideView.h"
#import "BATSegmentControl.h"

@interface BATCollectionTypeListViewController ()<DLTabedSlideViewDelegate,UIScrollViewDelegate,BATSegmentControlDelegate>

@property (nonatomic,strong) UITableView *collectionTableView;
@property (nonatomic,copy  ) NSArray     *dataArray;
@property (nonatomic,strong) NSString *beginTime;

@property (nonatomic,strong) DLTabedSlideView *topSlideView;

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic, strong) BATSegmentControl *segmentControl;

@end

@implementation BATCollectionTypeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的收藏";
    [self.view addSubview:self.segmentControl];
    [self.view addSubview:self.scrollView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addSubViewControl];
    
    
    
//    self.view.backgroundColor = UIColorFromRGB(238, 238, 238, 1);
//    self.beginTime = [Tools getCurrentDateStringByFormat:@"yyyy-MM-dd HH:mm:ss"];
//    
//    [self pagesLayout];
    
}
- (void)addSubViewControl{
    
    BATCollectionListViewController *hosVc = [[BATCollectionListViewController alloc]init];
    hosVc.collectionType = BATCollectionHospital;
    
    BATCollectionListViewController *videoVC = [[BATCollectionListViewController alloc]init];
    videoVC.collectionType = BATCollectionLessons;

    BATCollectionListViewController *newsVc = [[BATCollectionListViewController alloc]init];
    newsVc.collectionType = BATCollectionNews;

    
    hosVc.view.frame = CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    
    videoVC.view.frame = CGRectMake(SCREEN_WIDTH, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    
    
    newsVc.view.frame = CGRectMake(SCREEN_WIDTH*2, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    
    
    [self addChildViewController:hosVc];
    [self addChildViewController:videoVC];
    [self addChildViewController:newsVc];
    
    
    
    [self.scrollView addSubview:hosVc.view];
    [self.scrollView addSubview:videoVC.view];
     [self.scrollView addSubview:newsVc.view];
    
    
    
}
#pragma mark - setter && getter
- (UIScrollView *)scrollView{
    if(!_scrollView){
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - CGRectGetMaxY(self.segmentControl.frame))];
        _scrollView.contentSize = CGSizeMake( SCREEN_WIDTH *3, 0);
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.backgroundColor = [UIColor grayColor];
        
    }
    return _scrollView;
}
- (BATSegmentControl *)segmentControl{
    if (!_segmentControl) {
        _segmentControl = [[BATSegmentControl alloc]initWithItems:@[@"医院",@"视频",@"资讯"]];
        _segmentControl.frame = CGRectMake(0, 0, SCREEN_WIDTH, 45);
        _segmentControl.backgroundColor = [UIColor whiteColor];
        _segmentControl.delegate = self;
    }
    return _segmentControl;
}
#pragma UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger page = (scrollView.contentOffset.x / scrollView.frame.size.width);
    
    self.segmentControl.selectedIndex = page;
}

#pragma BATSegmentControlDelagat
- (void)batSegmentedControl:(BATSegmentControl *)segmentedControl selectedIndex:(NSInteger)index{
    
    //    NSLog(@"%ld----",index);
    [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * index, 0) animated:YES];
}


-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [BATUserPortrayTools saveOperateModuleRequestWithURL:@"/kmStatistical-sync/saveOperateModule" pathName:@"个人中心-我的收藏记录" moduleId:4 beginTime:self.beginTime];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - DLTabedSlideViewDelegate
- (NSInteger)numberOfTabsInDLTabedSlideView:(DLTabedSlideView *)sender{

    return 3;
}
- (UIViewController *)DLTabedSlideView:(DLTabedSlideView *)sender controllerAt:(NSInteger)index{
    switch (index) {
            case 0:
        {
            BATCollectionListViewController *collectionListVC = [[BATCollectionListViewController alloc] init];
            collectionListVC.collectionType = BATCollectionHospital;
            collectionListVC.title = @"医院";
            return collectionListVC;
        }
            case 1:
        {
            BATCollectionListViewController *collectionListVC = [[BATCollectionListViewController alloc] init];
            collectionListVC.collectionType = BATCollectionLessons;
            collectionListVC.title = @"视频";
            return collectionListVC;
        }
            case 2:
        {
            BATCollectionListViewController *collectionListVC = [[BATCollectionListViewController alloc] init];
            collectionListVC.collectionType = BATCollectionNews;
            collectionListVC.title = @"资讯";
            return collectionListVC;
        }

        default:
            return nil;
    }
}

- (void)DLTabedSlideView:(DLTabedSlideView *)sender didSelectedAt:(NSInteger)index {
    
}

/*
#pragma mark - tableview协议方法
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
//        case 0:
//        {
//            //医生
//            BATCollectionListViewController *collectionListVC = [[BATCollectionListViewController alloc] init];
//            collectionListVC.collectionType = BATCollectionDoctor;
//            collectionListVC.title = @"我收藏的医生";
//            collectionListVC.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:collectionListVC animated:YES];
//
//        }
//            break;
        case 0:
        {
            //医院
            BATCollectionListViewController *collectionListVC = [[BATCollectionListViewController alloc] init];
            collectionListVC.collectionType = BATCollectionHospital;
            collectionListVC.title = @"我收藏的医院";
            collectionListVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:collectionListVC animated:YES];

        }
            break;
        case 1:
        {
            //资讯
            BATCollectionListViewController *collectionListVC = [[BATCollectionListViewController alloc] init];
            collectionListVC.collectionType = BATCollectionNews;
            collectionListVC.title = @"我收藏的资讯";
            collectionListVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:collectionListVC animated:YES];
        }
            break;

        default:
            break;
    }
}
*/
#pragma mark - layout
- (void)pagesLayout {
//    [self.view addSubview:self.collectionTableView];
    [self.view addSubview:self.topSlideView];

}

#pragma mark - setter && getter

- (DLTabedSlideView *)topSlideView {
    if (!_topSlideView) {
        _topSlideView = [[DLTabedSlideView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49 - 64)];
        _topSlideView.delegate = self;
        _topSlideView.baseViewController = self;
        _topSlideView.tabItemNormalColor = UIColorFromHEX(0x333333, 1);
        _topSlideView.tabItemSelectedColor = BASE_COLOR;
        _topSlideView.backgroundColor = [UIColor whiteColor];
        _topSlideView.tabbarTrackColor = BASE_COLOR;
        _topSlideView.tabbarBottomSpacing = 0.0;
        DLTabedbarItem *item1 = [DLTabedbarItem itemWithTitle:@"医院" image:nil selectedImage:nil];
        DLTabedbarItem *item2 = [DLTabedbarItem itemWithTitle:@"视频" image:nil selectedImage:nil];
        DLTabedbarItem *item3 = [DLTabedbarItem itemWithTitle:@"资讯" image:nil selectedImage:nil];
        _topSlideView.tabbarItems = @[item1, item2, item3];
        [_topSlideView buildTabbar];
        _topSlideView.selectedIndex = 0;
    }
    return _topSlideView;
}

/*
- (UITableView *)collectionTableView {
    if (!_collectionTableView) {
//        _dataArray = @[@"收藏的医生",@"收藏的医院",@"收藏的资讯"];
        _dataArray = @[@"收藏的医院",@"收藏的资讯"];

        _collectionTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _collectionTableView.delegate = self;
        _collectionTableView.dataSource = self;
        _collectionTableView.tableFooterView = [UIView new];
    }
    return _collectionTableView;
}
*/
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
