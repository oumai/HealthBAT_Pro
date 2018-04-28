//
//  BATNearFamilyDoctorViewController.m
//  HealthBAT_Pro
//
//  Created by four on 17/3/15.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATNearFamilyDoctorViewController.h"
#import "BATHomeViewController.h"
#import "UIButton+TouchAreaInsets.h"

#import "BATTNearFamilyDoctorCell.h"
#import "BATFamilyDoctorDetailViewController.h"
#import "BATNearFamilyDoctorModel.h"

static NSString *const NEARDOCTOR_CELL = @"BATTNearFamilyDoctorCell";

@interface BATNearFamilyDoctorViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) BATDefaultView             *defaultView;

@property (nonatomic,strong) UITableView                *nearDoctorListTableView;

/**
 *  数据源
 */
@property (nonatomic,strong) NSMutableArray *dataSource;

/**
 *  页码
 */
@property (nonatomic,assign) NSInteger pageIndex;
/**
 *  每页显示条数
 */
@property (nonatomic,assign) NSInteger pageSize;


@end

@implementation BATNearFamilyDoctorViewController

- (void)dealloc
{
    DDLogDebug(@"====BATNearFamilyDoctorViewController===dealloc==");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupNav];
    _dataSource = [NSMutableArray array];
    self.title = @"附近医生";
    _pageSize = 10;
    _pageIndex = 0;
    [self pagesLayout];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.nearDoctorListTableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 设置导航栏
*/
- (void)setupNav{
    
    
        UIButton *disMissBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 15, 15)];
//    disMissBtn.backgroundColor = [UIColor redColor];
        //增大按钮额外点击区域
        disMissBtn.touchAreaInsets = UIEdgeInsetsMake(0, 20, 0, 10);
        
        disMissBtn.contentMode = UIViewContentModeLeft;
        [disMissBtn setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
        [disMissBtn addTarget:self action:@selector(disMissNearFamilyDoctorVC) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *disMissBtnItem = [[UIBarButtonItem alloc]initWithCustomView:disMissBtn];
        
        //调整左边按钮距离屏幕左边的位置
        UIBarButtonItem *nagetiveSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                       target:nil action:nil];
        
        nagetiveSpacer.width = -10;
    
        self.navigationItem.leftBarButtonItems = @[nagetiveSpacer,disMissBtnItem];
}

//dismiss 当前控制器，并且发送通知到BATFamilyDoctorViewController控制器，并且返回到首页
- (void)disMissNearFamilyDoctorVC{
    
    [self dismissViewControllerAnimated:NO completion:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"BACKHOMEVC" object:nil];
    
    
}
#pragma mark - net
- (void)requesNearFamilyDoctorList{
    
    [HTTPTool requestWithURLString:@"/api/FamilyDoctor/GetFamilyDoctorList" parameters:@{@"keyword":@"",@"pageIndex":@(_pageIndex),@"pageSize":@(_pageSize)} type:kGET success:^(id responseObject) {
        
        [self.nearDoctorListTableView.mj_footer endRefreshing];
        [self.nearDoctorListTableView.mj_header endRefreshing];
        
        if (_pageIndex == 0) {
            [_dataSource removeAllObjects];
        }
        
        BATNearFamilyDoctorModel *nearFamilyDoctorModel = [BATNearFamilyDoctorModel mj_objectWithKeyValues:responseObject];
        
        [_dataSource addObjectsFromArray:nearFamilyDoctorModel.Data];
        
        if (nearFamilyDoctorModel.RecordsCount > 0) {
            self.nearDoctorListTableView.mj_footer.hidden = NO;
        } else {
             self.nearDoctorListTableView.mj_footer.hidden = YES;
        }
        
        if (_dataSource.count == nearFamilyDoctorModel.RecordsCount) {
            [self.nearDoctorListTableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.nearDoctorListTableView reloadData];
        
        if (_dataSource.count == 0) {
            [self.defaultView showDefaultView];
        }
        
    } failure:^(NSError *error) {
        
        [self.nearDoctorListTableView.mj_footer endRefreshing];
        [self.nearDoctorListTableView.mj_header endRefreshing];
        
        _pageIndex--;
        if (_pageIndex < 0) {
            _pageIndex = 0;
        }
        
        [self.defaultView showDefaultView];
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BATTNearFamilyDoctorCell *nearrDoctorCell = [tableView dequeueReusableCellWithIdentifier:NEARDOCTOR_CELL forIndexPath:indexPath];
    if (_dataSource.count > 0) {
        
        BATNearFamilyDoctorData *data = _dataSource[indexPath.row];
        [nearrDoctorCell.headerImageView sd_setImageWithURL:[NSURL URLWithString:data.DoctorPic] placeholderImage:[UIImage imageNamed:@"医生"]];
        nearrDoctorCell.nameLable.text = data.DoctorName;
        nearrDoctorCell.hosptialLable.text = data.HospitalName;
        nearrDoctorCell.departmentLable.text = data.DepartmentName;
    }
    return nearrDoctorCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BATNearFamilyDoctorData *data = _dataSource[indexPath.row];
    
    BATFamilyDoctorDetailViewController *familyDoctorDetailVC = [[BATFamilyDoctorDetailViewController alloc] init];
    familyDoctorDetailVC.familyDoctroID = data.ID;
    familyDoctorDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:familyDoctorDetailVC animated:YES];
}

#pragma mark -pagesLayout
- (void)pagesLayout{
   
    
    WEAK_SELF(self);
    [self.view addSubview:self.nearDoctorListTableView];
    [self.nearDoctorListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:self.defaultView];
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self.view);
    }];
}

#pragma mark -get&&set
- (UITableView *)nearDoctorListTableView{
    if (!_nearDoctorListTableView) {
        _nearDoctorListTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _nearDoctorListTableView.rowHeight = UITableViewAutomaticDimension;
        _nearDoctorListTableView.estimatedRowHeight = 100;
        _nearDoctorListTableView.delegate = self;
        _nearDoctorListTableView.dataSource = self;
        _nearDoctorListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _nearDoctorListTableView.backgroundColor = UIColorFromHEX(0xf1f1f1, 1);
        
        [_nearDoctorListTableView registerClass:[BATTNearFamilyDoctorCell class] forCellReuseIdentifier:NEARDOCTOR_CELL];
        
        WEAK_SELF(self);
        _nearDoctorListTableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            STRONG_SELF(self);
            DDLogInfo(@"下拉刷新！");
            self.pageIndex = 0;
            [self.nearDoctorListTableView.mj_footer resetNoMoreData];
            [self requesNearFamilyDoctorList];
        }];
        _nearDoctorListTableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            STRONG_SELF(self);
            DDLogInfo(@"上拉拉加载！");
            self.pageIndex++;
            [self requesNearFamilyDoctorList];
        }];
    }
    return _nearDoctorListTableView;
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
            [self requesNearFamilyDoctorList];
        }];
        
    }
    return _defaultView;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
