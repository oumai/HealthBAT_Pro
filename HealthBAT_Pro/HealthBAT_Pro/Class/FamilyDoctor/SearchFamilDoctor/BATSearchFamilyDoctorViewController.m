//
//  BATSearchFamilDoctorViewController.m
//  HealthBAT_Pro
//
//  Created by four on 17/3/15.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATSearchFamilyDoctorViewController.h"

#import "BATTNearFamilyDoctorCell.h"
#import "BATFamilyDoctorDetailViewController.h"
#import "BATNearFamilyDoctorModel.h"

static NSString *const NEARDOCTOR_CELL = @"BATTNearFamilyDoctorCell";

typedef NS_ENUM(NSInteger,SearchState) {
    SearchStateNomal = 0,
    SearchStateInput = 1,
};

@interface BATSearchFamilyDoctorViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *searchDoctorListTableView;

@property (nonatomic,strong) BATDefaultView *defaultView;

@property (nonatomic,strong) UITextField *searchTF;

@property (nonatomic,copy) NSString *keyword;

@property (nonatomic,assign) SearchState searchState;

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

@implementation BATSearchFamilyDoctorViewController

- (void)dealloc
{
    DDLogWarn(@"%@",self);
    self.searchDoctorListTableView.delegate = nil;
    self.searchDoctorListTableView.dataSource = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self pagesLayout];
    
    _searchState = SearchStateNomal;
    _keyword = @"";
    _dataSource = [NSMutableArray array];
    _pageSize = 10;
    _pageIndex = 0;

}

- (void)viewWillAppear:(BOOL)animated{
    self.searchDoctorListTableView.mj_header.hidden = YES;
    self.searchDoctorListTableView.mj_footer.hidden = YES;
    [self.searchTF becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - #pragma mark - net
- (void)requesNearFamilyDoctorList{
    
    [HTTPTool requestWithURLString:@"/api/FamilyDoctor/GetFamilyDoctorList" parameters:@{@"keyword":_keyword,@"pageIndex":@(_pageIndex),@"pageSize":@(_pageSize)} type:kGET success:^(id responseObject) {
        
        [self.searchDoctorListTableView.mj_footer endRefreshing];
        [self.searchDoctorListTableView.mj_header endRefreshing];
        
        if (_pageIndex == 0) {
            [_dataSource removeAllObjects];
        }
        
        BATNearFamilyDoctorModel *nearFamilyDoctorModel = [BATNearFamilyDoctorModel mj_objectWithKeyValues:responseObject];
        
        [_dataSource addObjectsFromArray:nearFamilyDoctorModel.Data];
        
        if (nearFamilyDoctorModel.RecordsCount > 0) {
            self.searchDoctorListTableView.mj_footer.hidden = NO;
        } else {
            self.searchDoctorListTableView.mj_footer.hidden = YES;
        }
        
        if (_dataSource.count == nearFamilyDoctorModel.RecordsCount) {
            [self.searchDoctorListTableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.searchDoctorListTableView reloadData];
        
        if (_dataSource.count == 0) {
            [self.defaultView showDefaultView];
        }
        
    } failure:^(NSError *error) {
        
        [self.searchDoctorListTableView.mj_footer endRefreshing];
        [self.searchDoctorListTableView.mj_header endRefreshing];
        
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
    if (self.dataSource.count > 0) {
        
        BATNearFamilyDoctorData *data = self.dataSource[indexPath.row];
        
        [nearrDoctorCell.headerImageView sd_setImageWithURL:[NSURL URLWithString:data.DoctorPic] placeholderImage:[UIImage imageNamed:@"医生"]];
        nearrDoctorCell.nameLable.text = data.DoctorName;
        nearrDoctorCell.hosptialLable.text = data.HospitalName;
        nearrDoctorCell.departmentLable.text = data.DepartmentName;
    }
    
    return nearrDoctorCell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    BATFamilyDoctorDetailViewController *searchFamilyDoctorDetailVC = [[BATFamilyDoctorDetailViewController alloc] init];
    
    BATNearFamilyDoctorData *data = self.dataSource[indexPath.row];
    
    searchFamilyDoctorDetailVC.familyDoctroID = data.ID;
    
    searchFamilyDoctorDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchFamilyDoctorDetailVC animated:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    
    _keyword = textField.text;
    
    if (_keyword.length > 0) {
        _searchState = SearchStateInput;
        self.searchDoctorListTableView.mj_header.hidden = NO;
        self.searchDoctorListTableView.mj_footer.hidden = NO;
        self.defaultView.hidden = YES;
        [self.searchDoctorListTableView.mj_header beginRefreshing];
    } else {
        _searchState = SearchStateNomal;
        
        self.searchDoctorListTableView.mj_header.hidden = YES;
        self.searchDoctorListTableView.mj_footer.hidden = YES;
        [self.searchDoctorListTableView.mj_header endRefreshing];
    }
    
    return YES;
}

#pragma mark -pagesLayout
- (void)pagesLayout{
    
    WEAK_SELF(self);
    [self.view addSubview:self.searchDoctorListTableView];
    [self.searchDoctorListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:self.defaultView];
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self.view);
    }];
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.titleView = self.searchTF;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"取消" style:UIBarButtonItemStylePlain handler:^(id sender) {
        STRONG_SELF(self);
        //取消按钮的作用，取消搜索状态返回未搜索状态
        if ([self.searchTF isFirstResponder] || self.searchTF.text.length > 0) {
            
            [self.searchTF resignFirstResponder];
            self.searchTF.text = @"";
            _searchState = SearchStateNomal;
            self.defaultView.hidden = YES;
            self.searchDoctorListTableView.mj_header.hidden = YES;
            self.searchDoctorListTableView.mj_footer.hidden = YES;
            [self.searchDoctorListTableView.mj_footer resetNoMoreData];
            [self.searchDoctorListTableView reloadData];
            [self.searchDoctorListTableView setContentOffset:CGPointMake(0, 0) animated:NO];
            
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
}

#pragma mark -get&&set
- (UITableView *)searchDoctorListTableView{
    if (!_searchDoctorListTableView) {
        _searchDoctorListTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _searchDoctorListTableView.rowHeight = UITableViewAutomaticDimension;
        _searchDoctorListTableView.estimatedRowHeight = 100;
        _searchDoctorListTableView.delegate = self;
        _searchDoctorListTableView.dataSource = self;
        _searchDoctorListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _searchDoctorListTableView.backgroundColor = UIColorFromHEX(0xf1f1f1, 1);
        
        [_searchDoctorListTableView registerClass:[BATTNearFamilyDoctorCell class] forCellReuseIdentifier:NEARDOCTOR_CELL];
        
        WEAK_SELF(self);
        _searchDoctorListTableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            STRONG_SELF(self);
            DDLogInfo(@"下拉刷新！");
            self.pageIndex = 0;
            [self.searchDoctorListTableView.mj_footer resetNoMoreData];
            [self requesNearFamilyDoctorList];
        }];
        _searchDoctorListTableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            STRONG_SELF(self);
            DDLogInfo(@"上拉拉加载！");
            self.pageIndex++;
            [self requesNearFamilyDoctorList];
        }];
    }
    return _searchDoctorListTableView;
}

- (UITextField *)searchTF {
    
    if (!_searchTF) {
        
        _searchTF = [UITextField textFieldWithfont:[UIFont systemFontOfSize:14] textColor:nil placeholder:nil BorderStyle:UITextBorderStyleNone];
        _searchTF.clearButtonMode = UITextFieldViewModeNever;
        _searchTF.placeholder = @"搜索医生，科室";
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
        _searchTF.bounds = CGRectMake(0, 0, SCREEN_WIDTH - 60, 30);
        
        _searchTF.layer.cornerRadius = 2.0f;
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
