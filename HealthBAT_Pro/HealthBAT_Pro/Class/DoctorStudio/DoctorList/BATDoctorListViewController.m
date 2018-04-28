//
//  BATDoctorListViewController.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/4/1.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDoctorListViewController.h"
#import "BATCategoryTableViewCell.h"
#import "BATDoctorInfoTableViewCell.h"
#import "BATDoctorStudioDepartmentModel.h"
#import "BATDoctorStudioDoctorInfoModel.h"
#import "BATDoctorOfficeDetailController.h"
#import "BATDoctorStudioSearchViewController.h"
#import "BATDoctorStudioOrderListViewController.h"

@interface BATDoctorListViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,assign) BOOL isFilterAnimate;

@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,assign) NSInteger pageSize;

@property (nonatomic,assign) NSInteger pageIndex;

@property (nonatomic,strong) BATDoctorStudioDepartmentModel *doctorStudioDepartmentModel;

@property (nonatomic,strong) NSString *departmentID;

@property (nonatomic,assign) BATDoctorSort doctorSort;

@property (nonatomic,strong) NSString *titleType;

@property (nonatomic,strong) NSString *serviceType;

@end

@implementation BATDoctorListViewController

- (void)dealloc
{
    DDLogDebug(@"%s",__func__);
    
    [self removeSortFilerView];
}

- (void)loadView
{
    [super loadView];
    
    [self pageLayout];
    
    self.title = @"医生工作室";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.doctorListView.categoryTableView registerClass:[BATCategoryTableViewCell class] forCellReuseIdentifier:@"BATCategoryTableViewCell"];
    [self.doctorListView.doctorTableView registerClass:[BATDoctorInfoTableViewCell class] forCellReuseIdentifier:@"BATDoctorInfoTableViewCell"];
    
    [self requestGetDepartmentList];
    
    _dataSource = [NSMutableArray array];
    _pageIndex = 0;
    _pageSize = 10;
    _departmentID = @"";
    _serviceType = @"";
    _titleType = @"";
    _doctorSort = BATDoctorSort_Default;
    
    [self.doctorListView.doctorTableView.mj_header beginRefreshing];
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
    
    if (self.doctorListView.categoryTableView == tableView) {
        return 1;
    }
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.doctorListView.categoryTableView == tableView) {
        return self.doctorStudioDepartmentModel.Data.count;
    }
    
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.doctorListView.categoryTableView == tableView) {
        return 50;
    }
    
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.doctorListView.categoryTableView == tableView) {
        BATCategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATCategoryTableViewCell" forIndexPath:indexPath];
        
        if (self.doctorStudioDepartmentModel.Data.count > 0) {
            BATDoctorStudioDepartmentData *data = self.doctorStudioDepartmentModel.Data[indexPath.row];
            [cell.titleLabel setTitle:data.DepartmentName forState:UIControlStateNormal];
        }
        return cell;
    }
    
    BATDoctorInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATDoctorInfoTableViewCell" forIndexPath:indexPath];
    
    if (self.dataSource.count > 0) {
        
        BATDoctorStudioDoctorInfoData *data = [self.dataSource objectAtIndex:indexPath.row];
        
        [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:data.DoctorPic] placeholderImage:[UIImage imageNamed:@"医生"]];
        cell.doctorNameLabel.text = [NSString stringWithFormat:@"%@[%@]",data.DoctorName,data.DoctorTitle];
        cell.hospitalLabel.text = data.HospitalName;
        cell.departmentAndGoodAtLabel.text = [NSString stringWithFormat:@"%@:%@",data.DepartmentName,data.GoodAt];
        cell.priceLabel.text = [NSString stringWithFormat:@"￥%@起",data.Price];
        cell.priceCountLabel.text = [NSString stringWithFormat:@"%@人购买",data.BuyNum];
        
    }
    
    return cell;

}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.doctorListView.categoryTableView == tableView) {
        
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        
        if (self.doctorStudioDepartmentModel.Data.count > 0) {
            BATDoctorStudioDepartmentData *data = self.doctorStudioDepartmentModel.Data[indexPath.row];
            self.departmentID = data.ID;
            self.pageIndex = 0;
            [self.doctorListView.doctorTableView.mj_header beginRefreshing];
        }
        
    } else {
        BATDoctorOfficeDetailController *doctorOfficeDetailController = [[BATDoctorOfficeDetailController alloc] init];
        
        BATDoctorStudioDoctorInfoData *data = _dataSource[indexPath.row];
        doctorOfficeDetailController.doctorid = data.ID;
        doctorOfficeDetailController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:doctorOfficeDetailController animated:YES];
    }
}

#pragma mark - Action
- (void)controlAction:(UIControl *)control
{
    if (self.isFilterAnimate) {
        [self filterAnimate];
    } else {
        [self sortAnimate];
    }
    
}

- (void)sortAnimate
{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    [self.doctorSortView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(window.mas_right).offset(self.control.hidden ? -250 : 0);
    }];
    
    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [window setNeedsLayout];
        [window layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.control.hidden = !self.control.hidden;
    }];
}

- (void)filterAnimate
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    [self.filterView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(window.mas_right).offset(self.control.hidden ? -250 : 0);
    }];
    
    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [window setNeedsLayout];
        [window layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.control.hidden = !self.control.hidden;
    }];
}

- (void)removeSortFilerView
{
    [self.control removeFromSuperview];
    [self.doctorSortView removeFromSuperview];
}

#pragma mark - Net
#pragma mark - 获取科室
- (void)requestGetDepartmentList
{
    [HTTPTool requestWithURLString:@"/api/Doctor/GetDepartmentList" parameters:nil type:kGET success:^(id responseObject) {
        
        self.doctorStudioDepartmentModel = [BATDoctorStudioDepartmentModel mj_objectWithKeyValues:responseObject];
        
        BATDoctorStudioDepartmentData *all = [[BATDoctorStudioDepartmentData alloc] init];
        all.ID = @"";
        all.DepartmentName = @"全部";
        
        [self.doctorStudioDepartmentModel.Data insertObject:all atIndex:0];
        
        
        [self.doctorListView.categoryTableView reloadData];
        
        [self.doctorListView.categoryTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 获取医生
- (void)requestGetDoctorList
{
    [HTTPTool requestWithURLString:@"/api/Doctor/GetDoctorList" parameters:@{@"DepartmentID":self.departmentID,@"ServiceType":self.serviceType,@"TitleType":self.titleType,@"OrderType":@(self.doctorSort),@"PageIndex":@(self.pageIndex),@"PageSize":@(self.pageSize)} type:kPOST success:^(id responseObject) {
        
        WEAK_SELF(self);
        [self.doctorListView.doctorTableView.mj_header endRefreshingWithCompletionBlock:^{
            STRONG_SELF(self);
            [self.doctorListView.doctorTableView reloadData];
        }];
        [self.doctorListView.doctorTableView.mj_footer endRefreshing];
        
        if (_pageIndex == 0) {
            [_dataSource removeAllObjects];
        }
        
        BATDoctorStudioDoctorInfoModel *doctorStudioDoctorInfoModel = [BATDoctorStudioDoctorInfoModel mj_objectWithKeyValues:responseObject];
        
        [_dataSource addObjectsFromArray:doctorStudioDoctorInfoModel.Data];
        
        if (doctorStudioDoctorInfoModel.RecordsCount > 0) {
            self.doctorListView.doctorTableView.mj_footer.hidden = NO;
        } else {
            self.doctorListView.doctorTableView.mj_footer.hidden = YES;
        }
        
        if (_dataSource.count == doctorStudioDoctorInfoModel.RecordsCount) {
            //            [self.batOnlineLearningView.tableView.mj_footer endRefreshingWithNoMoreData];
            self.doctorListView.doctorTableView.mj_footer.hidden = YES;
        }
        
        [self.doctorListView.doctorTableView reloadData];

        
    } failure:^(NSError *error) {
        WEAK_SELF(self);
        [self.doctorListView.doctorTableView.mj_header endRefreshingWithCompletionBlock:^{
            STRONG_SELF(self);
            [self.doctorListView.doctorTableView reloadData];
        }];
        [self.doctorListView.doctorTableView.mj_footer endRefreshing];
        _pageIndex--;
        if (_pageIndex < 0) {
            _pageIndex = 0;
        }
        
    }];
}

#pragma mark - pageLayout
- (void)pageLayout
{
    [self.view addSubview:self.doctorListView];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    
    [window addSubview:self.control];
    [window addSubview:self.doctorSortView];
    [window addSubview:self.filterView];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"订单" style:UIBarButtonItemStylePlain handler:^(id sender) {
//        BATDoctorStudioOrderListViewController *orderListVC = [[BATDoctorStudioOrderListViewController alloc] init];
//        orderListVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:orderListVC animated:YES];
//        
//    }];
    
    BATGraditorButton *customBtn = [[BATGraditorButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [customBtn addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchUpInside];
    [customBtn setTitle:@"订单" forState:UIControlStateNormal];
    customBtn.enbleGraditor = YES;
    [customBtn setGradientColors:@[START_COLOR,END_COLOR]];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:customBtn];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
    WEAK_SELF(self);
    [self.doctorListView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self.view);
    }];
    
    [self.control mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];
    
    [self.doctorSortView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(250);
        make.left.equalTo(window.mas_right);
        make.bottom.top.equalTo(window);
    }];
    
    [self.filterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(250);
        make.left.equalTo(window.mas_right);
        make.bottom.top.equalTo(window);
    }];
}

- (void)moreAction {
    BATDoctorStudioOrderListViewController *orderListVC = [[BATDoctorStudioOrderListViewController alloc] init];
    orderListVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:orderListVC animated:YES];

}

#pragma mark - get & set
- (BATDoctorListView *)doctorListView
{
    if (_doctorListView == nil) {
        _doctorListView = [[BATDoctorListView alloc] init];
        _doctorListView.categoryTableView.delegate = self;
        _doctorListView.categoryTableView.dataSource = self;
        _doctorListView.doctorTableView.delegate = self;
        _doctorListView.doctorTableView.dataSource = self;
        
        WEAK_SELF(self);
        _doctorListView.doctorTableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.pageIndex = 0;
            [self.doctorListView.doctorTableView.mj_footer resetNoMoreData];
            [self requestGetDoctorList];
        }];
        
        _doctorListView.doctorTableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.pageIndex++;
            [self requestGetDoctorList];
        }];
        
        _doctorListView.doctorTableView.mj_footer.hidden = YES;
        
        _doctorListView.sortBlock = ^(){
            STRONG_SELF(self);
            [self sortAnimate];
            self.isFilterAnimate = NO;
        };
        
        _doctorListView.filterBlock = ^(){
            STRONG_SELF(self);
            [self filterAnimate];
            self.isFilterAnimate = YES;
        };
        
        _doctorListView.searchBlock = ^(){
            STRONG_SELF(self);
            BATDoctorStudioSearchViewController *doctorStudioSearchVC = [[BATDoctorStudioSearchViewController alloc] init];
            doctorStudioSearchVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:doctorStudioSearchVC animated:YES];
        };
    }
    return _doctorListView;
}

- (UIControl *)control
{
    if (_control == nil) {
        _control = [[UIControl alloc] init];
        _control.backgroundColor = [UIColor blackColor];
        _control.alpha = 0.5f;
        _control.hidden = YES;
        [_control addTarget:self action:@selector(controlAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _control;
}

- (BATDoctorSortView *)doctorSortView
{
    if (_doctorSortView == nil) {
        _doctorSortView = [[BATDoctorSortView alloc] init];
        _doctorSortView.backgroundColor = [UIColor whiteColor];
        
        WEAK_SELF(self);
        _doctorSortView.doctorSortFooterView.doctorSortFooterConfrimBlock = ^(){
            STRONG_SELF(self);
            [self sortAnimate];
            self.doctorSort = self.doctorSortView.doctorSort;
            self.pageIndex = 0;
            [self.doctorListView.doctorTableView.mj_header beginRefreshing];
        };
    }
    return _doctorSortView;
}

- (BATDoctorFilterView *)filterView
{
    if (_filterView == nil) {
        
        _filterView = [[BATDoctorFilterView alloc] init];
        _filterView.backgroundColor = [UIColor whiteColor];
        
        WEAK_SELF(self);
        _filterView.footerView.doctorFilterFooterConfrimBlock = ^(){
            STRONG_SELF(self);
            [self filterAnimate];
            
            self.titleType = self.filterView.title.count > 0 ? [self.filterView.title componentsJoinedByString:@","] : @"";
            self.serviceType = self.filterView.service.count > 0 ? [self.filterView.service componentsJoinedByString:@","] : @"";
            self.pageIndex = 0;
            [self.doctorListView.doctorTableView.mj_header beginRefreshing];
        };
    }
    return _filterView;
}

@end
