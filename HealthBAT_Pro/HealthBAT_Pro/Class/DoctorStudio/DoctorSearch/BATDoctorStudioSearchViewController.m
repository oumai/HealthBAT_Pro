//
//  BATDoctorStudioSearchViewController.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/4/5.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDoctorStudioSearchViewController.h"
#import "BATDoctorStudioSearchInfoTableViewCell.h"
#import "BATDoctorStudioDoctorInfoModel.h"
#import "BATDoctorOfficeDetailController.h"

@interface BATDoctorStudioSearchViewController () <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,assign) NSInteger pageSize;

@property (nonatomic,assign) NSInteger pageIndex;

@property (nonatomic,strong) UITextField *searchTF;

/**
 *  关键词
 */
@property (nonatomic,strong) NSString *keyWord;

@property (nonatomic,assign) BOOL isCompleteRequest;

@property (nonatomic,strong) BATDefaultView *defaultView;

@end

@implementation BATDoctorStudioSearchViewController

- (void)dealloc
{
    DDLogWarn(@"%s",__func__);
}

- (void)loadView
{
    [super loadView];
    
    [self pageLayout];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.doctorStudioSearchView.tableView registerClass:[BATDoctorStudioSearchInfoTableViewCell class] forCellReuseIdentifier:@"BATDoctorStudioSearchInfoTableViewCell"];
    
    _pageSize = 10;
    _pageIndex = 0;
    _keyWord = @"";
    _dataSource = [NSMutableArray array];
    
    [self.searchTF becomeFirstResponder];
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

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BATDoctorStudioSearchInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATDoctorStudioSearchInfoTableViewCell" forIndexPath:indexPath];
    
    if (self.dataSource.count > 0) {
        
        BATDoctorStudioDoctorInfoData *data = [self.dataSource objectAtIndex:indexPath.row];
        
        [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:data.DoctorPic] placeholderImage:[UIImage imageNamed:@"医生"]];
        cell.doctorNameLabel.text = [NSString stringWithFormat:@"%@[%@]",data.DoctorName,data.DoctorTitle];
        cell.hospitalLabel.text = data.HospitalName;
        cell.departmentAndGoodAtLabel.text = [NSString stringWithFormat:@"%@:%@",data.DepartmentName,data.GoodAt];
        
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BATDoctorOfficeDetailController *doctorOfficeDetailController = [[BATDoctorOfficeDetailController alloc] init];
    BATDoctorStudioDoctorInfoData *data = _dataSource[indexPath.row];
    doctorOfficeDetailController.doctorid = data.ID;
    doctorOfficeDetailController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:doctorOfficeDetailController animated:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    _keyWord = textField.text;
    [self.doctorStudioSearchView.tableView.mj_header beginRefreshing];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    
    [textField resignFirstResponder];
    _keyWord = @"";
    [self.defaultView removeFromSuperview];
    [self.dataSource removeAllObjects];
    [self.doctorStudioSearchView.tableView reloadData];
    return YES;
}

#pragma mark - Net
- (void)requestSearchDoctor
{
    [HTTPTool requestWithURLString:@"/api/doctor/search" parameters:@{@"keyword":self.keyWord,@"pageIndex":@(self.pageIndex),@"pageSize":@(self.pageSize)} type:kGET success:^(id responseObject) {
        [self.doctorStudioSearchView.tableView.mj_header endRefreshingWithCompletionBlock:^{
            self.isCompleteRequest = YES;
            [self.doctorStudioSearchView.tableView reloadData];
        }];
        [self.doctorStudioSearchView.tableView.mj_footer endRefreshing];
        
        if (_pageIndex == 0) {
            [_dataSource removeAllObjects];
        }
        
        BATDoctorStudioDoctorInfoModel *doctorStudioDoctorInfoModel = [BATDoctorStudioDoctorInfoModel mj_objectWithKeyValues:responseObject];
        
        [_dataSource addObjectsFromArray:doctorStudioDoctorInfoModel.Data];
        
        if (doctorStudioDoctorInfoModel.RecordsCount > 0) {
            self.doctorStudioSearchView.tableView.mj_footer.hidden = NO;
        } else {
            self.doctorStudioSearchView.tableView.mj_footer.hidden = YES;
        }
        
        if (_dataSource.count == doctorStudioDoctorInfoModel.RecordsCount) {
            [self.doctorStudioSearchView.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        if (_dataSource.count == 0) {
            [self.defaultView showDefaultView];
        }
        
        [self.doctorStudioSearchView.tableView reloadData];
        
    } failure:^(NSError *error) {
        [self.doctorStudioSearchView.tableView.mj_header endRefreshingWithCompletionBlock:^{
            self.isCompleteRequest = YES;
            [self.self.doctorStudioSearchView.tableView reloadData];
        }];
        [self.doctorStudioSearchView.tableView.mj_footer endRefreshing];
        _pageIndex--;
        if (_pageIndex < 0) {
            _pageIndex = 0;
        }
        
        [self.defaultView showDefaultView];
    }];
}

#pragma mark - pageLayout
- (void)pageLayout
{
    [self.view addSubview:self.doctorStudioSearchView];
    
    
    WEAK_SELF(self);
    [self.doctorStudioSearchView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:self.defaultView];
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.top.equalTo(self.view);
    }];
    
    
    self.navigationItem.hidesBackButton = YES;
    
    self.navigationItem.titleView = self.searchTF;
}

#pragma mark - get & set
- (BATDoctorStudioSearchView *)doctorStudioSearchView
{
    if (_doctorStudioSearchView == nil) {
        _doctorStudioSearchView = [[BATDoctorStudioSearchView alloc] init];
        _doctorStudioSearchView.tableView.delegate = self;
        _doctorStudioSearchView.tableView.dataSource = self;
        
        WEAK_SELF(self);
        _doctorStudioSearchView.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.pageIndex = 0;
            [self.doctorStudioSearchView.tableView.mj_footer resetNoMoreData];
            [self requestSearchDoctor];
        }];
        
        _doctorStudioSearchView.tableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.pageIndex++;
            [self requestSearchDoctor];
        }];
        
        _doctorStudioSearchView.tableView.mj_footer.hidden = YES;
        
    }
    return _doctorStudioSearchView;
}

- (UITextField *)searchTF {
    if (!_searchTF) {
        _searchTF = [UITextField textFieldWithfont:[UIFont systemFontOfSize:14] textColor:nil placeholder:nil BorderStyle:UITextBorderStyleNone];
        _searchTF.clearButtonMode = UITextFieldViewModeAlways;
        _searchTF.placeholder = @"搜索医生名，科室、疾病";
        _searchTF.textColor = UIColorFromHEX(0x666666, 1);
        _searchTF.backgroundColor = BASE_BACKGROUND_COLOR;
        _searchTF.returnKeyType = UIReturnKeySearch;
        
        
        UIImageView *searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic-search"]];
        UIView *leftIcon = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
        [leftIcon addSubview:searchIcon];
        [searchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(leftIcon);
        }];
        _searchTF.leftView = leftIcon;
        _searchTF.leftViewMode = UITextFieldViewModeAlways;
        _searchTF.delegate = self;
        _searchTF.bounds = CGRectMake(0, 0, SCREEN_WIDTH - 40, 30);
        
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
            
            [self requestSearchDoctor];
        }];
        
    }
    return _defaultView;
}

@end
