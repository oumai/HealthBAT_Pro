//
//  BATFindDoctorListViewController.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/9/22.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATFindDoctorListViewController.h"
#import "BATConsultationDepartmentDoctorTableViewCell.h"
#import "BATFindDoctorModel.h"
#import "BATFindSearchBarView.h"
#import "BATNewConsultionDoctorDetailViewController.h"
#import "BATDoctorScheduleViewController.h"

static NSString *consultationDepartmentDoctorTableViewCelldentifier = @"BATConsultationDepartmentDoctorTableViewCell";

@interface BATFindDoctorListViewController () <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UITextFieldDelegate>

/**
 *  页码
 */
@property (nonatomic,assign) NSInteger pageIndex;

/**
 *  每页数量
 */
@property (nonatomic,assign) NSInteger pageSize;

/**
 *  数据源
 */
@property (nonatomic,strong) NSMutableArray *dataSource;

/**
 *  关键字
 */
@property (nonatomic,strong) NSString *keyWord;

/**
 *  头部searchBarView
 */
//@property (nonatomic,strong) BATFindSearchBarView *findSearchBarView;

@property (nonatomic,strong) UITextField *searchTF;

@property (nonatomic,assign) BOOL isPop;

@property (nonatomic,strong) NSString *beginTime;

@property (nonatomic,strong) BATDefaultView *defaultView;

@end

@implementation BATFindDoctorListViewController

- (void)dealloc
{
    DDLogWarn(@"%@",self);
    _findDoctorListView.tableView.delegate = nil;
    _findDoctorListView.tableView.dataSource = nil;
//    _findSearchBarView.searchBar.delegate = nil;
}

- (void)loadView
{
    [super loadView];
    
    if (_findDoctorListView == nil) {
        _findDoctorListView = [[BATFindDoctorListView alloc] init];
        _findDoctorListView.tableView.delegate = self;
        _findDoctorListView.tableView.dataSource = self;
        _findDoctorListView.tableView.rowHeight = 90;
        _findDoctorListView.tableView.tableFooterView = [UIView new];
        _findDoctorListView.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_findDoctorListView];
        
        WEAK_SELF(self);
        [_findDoctorListView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.edges.equalTo(self.view);
        }];
        
        _findDoctorListView.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.pageIndex = 1;
            [self.findDoctorListView.tableView.mj_footer resetNoMoreData];
            [self requestGetDoctors];
        }];
        
        _findDoctorListView.tableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.pageIndex++;
            [self requestGetDoctors];
        }];
        
        _findDoctorListView.tableView.mj_footer.hidden = YES;
        



        self.navigationItem.titleView = self.searchTF;

        
        [_findDoctorListView addSubview:self.defaultView];
        [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.left.top.equalTo(self.view);
        }];

//        _findSearchBarView = [[BATFindSearchBarView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
//        _findSearchBarView.searchBar.delegate = self;
//        _findSearchBarView.searchBar.placeholder = @"搜医生";
//        self.navigationItem.titleView = _findSearchBarView;
//        
//        _findSearchBarView.cancelBlock = ^(){
//            STRONG_SELF(self);
//            //取消按钮的作用，取消搜索状态返回未搜索状态
//            if ([self.findSearchBarView.searchBar isFirstResponder] || self.findSearchBarView.searchBar.text.length > 0) {
//                [self.findSearchBarView.searchBar resignFirstResponder];
//                
//                self.findSearchBarView.searchBar.text = @"";
//                self.keyWord = @"";
//                [self.findDoctorListView.tableView.mj_header beginRefreshing];
//            }
//        };
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.findSearchBarView.searchBar resignFirstResponder];
    if (self.isPop) {
        [self popAction];
    }
}


-(void)popAction {
    /*
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[Tools getPostUUID] forKey:@"deviceNo"];
    [dict setValue:@(1) forKey:@"deviceType"];
    if (LOGIN_STATION) {
        [dict setValue:[Tools getCurrentID] forKey:@"userId"];
    }
    
    NSString *ipString = [Tools get4GorWIFIAddress];
    [dict setValue:ipString forKey:@"userIp"];
    [dict setValue:self.pathName forKey:@"moduleName"];
    [dict setValue:@(3) forKey:@"moduleId"];
    [dict setValue:self.beginTime forKey:@"createdTime"];
    [dict setValue:[Tools getCurrentDateStringByFormat:@"yyyy-MM-dd HH:mm:ss"] forKey:@"leaveTime"];
    //获取ip
    [HTTPTool requestWithSearchURLString:@"/kmStatistical-sync/saveOperateModule" parameters:dict success:^(id responseObject) {
   
    } failure:^(NSError *error) {
        
    }];
     */
    
    [BATUserPortrayTools saveOperateModuleRequestWithURL:@"/kmStatistical-sync/saveOperateModule" pathName:self.pathName moduleId:3 beginTime:self.beginTime];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_findDoctorListView.tableView registerClass:[BATConsultationDepartmentDoctorTableViewCell class] forCellReuseIdentifier:consultationDepartmentDoctorTableViewCelldentifier];
    
    _dataSource = [NSMutableArray array];
    _pageSize = 10;
    _pageIndex = 1;
    _keyWord = @"";
    
    self.beginTime = [Tools getCurrentDateStringByFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.isPop = YES;
    
    [_findDoctorListView.tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BATConsultationDepartmentDoctorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:consultationDepartmentDoctorTableViewCelldentifier forIndexPath:indexPath];
    
    if (_dataSource.count > 0) {
        //医生
        BATFindDoctorData *doctor = _dataSource[indexPath.row];
        [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:doctor.User.PhotoUrl] placeholderImage:[UIImage imageNamed:@"医生"]];

        cell.hospitalLevelImageView.hidden = YES;
    
        cell.nameLabel.text = doctor.Title.length > 0 ? [NSString stringWithFormat:@"%@[%@]",doctor.DoctorName,doctor.Title] : doctor.DoctorName;
        cell.departmentLabel.text = doctor.DepartmentName;
        cell.descriptionLabel.text = doctor.Specialty;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.isPop = NO;
    BATNewConsultionDoctorDetailViewController *doctorDetailVC = [[BATNewConsultionDoctorDetailViewController alloc] init];
    BATFindDoctorData *doctor = _dataSource[indexPath.row];
    doctorDetailVC.doctorID = doctor.DoctorID;
    doctorDetailVC.pathName = [NSString stringWithFormat:@"%@-%@",self.pathName,doctor.DoctorName];
    [self.navigationController pushViewController:doctorDetailVC animated:YES];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    _keyWord = searchBar.text;
    [_findDoctorListView.tableView.mj_header beginRefreshing];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    _keyWord = textField.text;
    self.defaultView.hidden = YES;
    [_findDoctorListView.tableView.mj_header beginRefreshing];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    [textField resignFirstResponder];
    _keyWord = @"";
    self.defaultView.hidden = YES;
    [_findDoctorListView.tableView.mj_header beginRefreshing];
    return YES;
}

#pragma mark - NET
- (void)requestGetDoctors
{
    [HTTPTool requestWithURLString:@"/api/NetworkMedical/GetDoctors"
                        parameters:@{@"pageIndex":@((long)_pageIndex),
                                     @"pageSize":@((long)_pageSize),
                                     @"keyWord":_keyWord
                                     }
                              type:kGET
                           success:^(id responseObject)  {
        
        [_findDoctorListView.tableView.mj_header endRefreshing];
        [_findDoctorListView.tableView.mj_footer endRefreshing];
        
        if (_pageIndex == 1) {
            [_dataSource removeAllObjects];
        }
        
        BATFindDoctorModel *findDoctorModel = [BATFindDoctorModel mj_objectWithKeyValues:responseObject];
        
        [_dataSource addObjectsFromArray:findDoctorModel.Data];
        
        if (findDoctorModel.RecordsCount > 0) {
            _findDoctorListView.tableView.mj_footer.hidden = NO;
        } else {
            _findDoctorListView.tableView.mj_footer.hidden = YES;
        }
        
        if (_dataSource.count == findDoctorModel.RecordsCount) {
            [_findDoctorListView.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
                               if (_dataSource.count == 0) {
                                   [self.defaultView showDefaultView];
                               }
                               
        [_findDoctorListView.tableView reloadData];
                               
                               
        
    } failure:^(NSError *error) {
        [_findDoctorListView.tableView.mj_header endRefreshing];
        [_findDoctorListView.tableView.mj_footer endRefreshing];
        _pageIndex--;
        if (_pageIndex < 1) {
            _pageIndex = 1;
        }
        
        [self.defaultView showDefaultView];
    }];
}

#pragma mark - getter
- (UITextField *)searchTF {
    if (!_searchTF) {
        
        _searchTF = [UITextField textFieldWithfont:[UIFont systemFontOfSize:13] textColor:nil placeholder:@"搜医生" BorderStyle:UITextBorderStyleNone];
        _searchTF.clearButtonMode = UITextFieldViewModeAlways;
        _searchTF.textColor = STRING_LIGHT_COLOR;
        
        UIImageView *searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"搜索图标"]];
        UIView *leftIcon = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
        [leftIcon addSubview:searchIcon];
        [searchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(leftIcon);
        }];
        
        _searchTF.leftView = leftIcon;
        _searchTF.leftViewMode = UITextFieldViewModeAlways;
        _searchTF.delegate = self;
        _searchTF.bounds = CGRectMake(0, 0, SCREEN_WIDTH - 40, 30);
        _searchTF.backgroundColor = BASE_BACKGROUND_COLOR;
        _searchTF.returnKeyType = UIReturnKeySearch;
        
        
        _searchTF.layer.cornerRadius = 3.0f;
        _searchTF.clipsToBounds = YES;
    }
    return _searchTF;
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
            
            [self.findDoctorListView.tableView.mj_header beginRefreshing];

        }];
        
    }
    return _defaultView;
}
@end
