//
//  BATConsultationDepartmentDetailViewController.m
//  HealthBAT_Pro
//
//  Created by Skyrim on 16/9/5.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATConsultationDepartmentDetailViewController.h"
#import "BATConsultationDepartmentDoctorTableViewCell.h"
#import "BATConsultationDoctorModel.h"
#import "BATConsultationDepartmentDetailModel.h"

#import "BATConsultationDoctorDetailViewController.h"
#import "BATNewConsultionDoctorDetailViewController.h"

#import "UIScrollView+EmptyDataSet.h"

static  NSString * const DOCTOR_CELL = @"DoctorCell";

@interface BATConsultationDepartmentDetailViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,UITextFieldDelegate>

@property (nonatomic,strong) UITableView *departmentDetailListTableView;
@property (nonatomic,strong) BATConsultationDoctorModel *consultedDoctorModel;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) int currentPage;
@property (nonatomic,strong) NSString *beginTime;
@property (nonatomic,assign) BOOL isPop;
@property (nonatomic,assign) BOOL isCompleteRequest;

@property (nonatomic,strong) BATDefaultView *defaultView;


@property (nonatomic,strong) NSString *keyWord;
@property (nonatomic,strong) UITextField *searchTF;

@end

@implementation BATConsultationDepartmentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.keyWord = @"";
    
    [self layoutPages];

    if (!self.isConsulted) {
        self.isConsulted = NO;
    }

    self.dataArray = [NSMutableArray array];

    [self.departmentDetailListTableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
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
        NSLog(@"11111");
    } failure:^(NSError *error) {
        
    }];
     */
    
    [BATUserPortrayTools saveOperateModuleRequestWithURL:@"/kmStatistical-sync/saveOperateModule" pathName:self.pathName moduleId:3 beginTime:self.beginTime];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (self.isConsulted) {

        ConsultationDoctorData *data = self.consultedDoctorModel.Data[0];
        return data.Doctors.count;
    }

    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    BATConsultationDepartmentDoctorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DOCTOR_CELL forIndexPath:indexPath];


    if (self.isConsulted) {

        //咨询过的医生
        ConsultationDoctorData *data = self.consultedDoctorModel.Data[0];
        ConsultationDoctors *doctor = data.Doctors[indexPath.row];
        [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:doctor.User.PhotoUrl] placeholderImage:[UIImage imageNamed:@"医生"]];

        cell.hospitalLevelImageView.hidden = YES;


//        if (![doctor.Grade isEqualToString:@"三甲"]) {
//            
//            cell.hospitalLevelImageView.hidden = YES;
//        }
//        else {
//            
//            cell.hospitalLevelImageView.hidden = NO;
//        }
//
//        switch (doctor.OnlineStatus) {
//            case 0:
//            {
//                //离线
//                cell.onlineStationImageView.image = [UIImage imageNamed:@"离线"];
//                cell.headerImageView.alpha = 0.5;
//            }
//                break;
//            case 1:
//            {
//                //忙碌
//                cell.onlineStationImageView.image = [UIImage imageNamed:@"忙碌"];
//                cell.headerImageView.alpha = 1;
//                
//            }
//                break;
//            default:
//            {
//                //在线
//                cell.onlineStationImageView.image = nil;
//                cell.headerImageView.alpha = 1;
//            }
//                break;
//        }
        
        cell.nameLabel.text = [NSString stringWithFormat:@"%@[%@]",doctor.DoctorName,doctor.Title];
        cell.departmentLabel.text = doctor.DepartmentName;
        cell.descriptionLabel.text = [NSString stringWithFormat:@"擅长：%@",[doctor.Specialty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
        
//        [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,doctor.PhotoPath]] placeholderImage:[UIImage imageNamed:@"医生"]];
//        if (![doctor.HospitalGrade isEqualToString:@"三级甲等"]) {
//
//            cell.hospitalLevelImageView.hidden = YES;
//        }
//        else {
//
//            cell.hospitalLevelImageView.hidden = NO;
//        }
//
//        switch (doctor.OnlineStatus) {
//            case 0:
//            {
//                //离线
//                cell.onlineStationImageView.image = [UIImage imageNamed:@"离线"];
//                cell.headerImageView.alpha = 0.5;
//            }
//                break;
//            case 1:
//            {
//                //忙碌
//                cell.onlineStationImageView.image = [UIImage imageNamed:@"忙碌"];
//                cell.headerImageView.alpha = 1;
//
//            }
//                break;
//            default:
//            {
//                //在线
//                cell.onlineStationImageView.image = nil;
//                cell.headerImageView.alpha = 1;
//            }
//                break;
//        }
//        cell.nameLabel.text = [NSString stringWithFormat:@"%@[%@]",doctor.UserName,doctor.jobTileName];
//        cell.departmentLabel.text = doctor.DepartmentName;
//        cell.descriptionLabel.text = doctor.Skilled;

    }

    else {

        //科室医生
        ConsultationDepartmentDetailData *doctor = self.dataArray[indexPath.row];
        [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:doctor.User.PhotoUrl] placeholderImage:[UIImage imageNamed:@"医生"]];

        cell.hospitalLevelImageView.hidden = YES;


//        if (![doctor.Grade isEqualToString:@"三甲"]) {
//            
//            cell.hospitalLevelImageView.hidden = YES;
//        }
//        else {
//            
//            cell.hospitalLevelImageView.hidden = NO;
//        }
        
//        switch (doctor.OnlineStatus) {
//            case 0:
//            {
//                //离线
//                cell.onlineStationImageView.image = [UIImage imageNamed:@"离线"];
//                cell.headerImageView.alpha = 0.5;
//            }
//                break;
//            case 1:
//            {
//                //忙碌
//                cell.onlineStationImageView.image = [UIImage imageNamed:@"忙碌"];
//                cell.headerImageView.alpha = 1;
//                
//            }
//                break;
//            default:
//            {
//                //在线
//                cell.onlineStationImageView.image = nil;
//                cell.headerImageView.alpha = 1;
//            }
//                break;
//        }
        
        cell.nameLabel.text = doctor.Title.length > 0 ? [NSString stringWithFormat:@"%@[%@]",doctor.DoctorName,doctor.Title] : doctor.DoctorName;
        cell.departmentLabel.text = doctor.DepartmentName;
        cell.descriptionLabel.text = [NSString stringWithFormat:@"擅长：%@",[doctor.Specialty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
        
//        ConsultationDepartmentDetailData *doctor = self.dataArray[indexPath.row];
//        [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,doctor.PhotoPath]] placeholderImage:[UIImage imageNamed:@"医生"]];
//        if (![doctor.HospitalGrade isEqualToString:@"三级甲等"]) {
//
//            cell.hospitalLevelImageView.hidden = YES;
//        }
//        else {
//
//            cell.hospitalLevelImageView.hidden = NO;
//        }
//
//        switch (doctor.OnlineStatus) {
//            case 0:
//            {
//                //离线
//                cell.onlineStationImageView.image = [UIImage imageNamed:@"离线"];
//                cell.headerImageView.alpha = 0.5;
//            }
//                break;
//            case 1:
//            {
//                //忙碌
//                cell.onlineStationImageView.image = [UIImage imageNamed:@"忙碌"];
//                cell.headerImageView.alpha = 1;
//
//            }
//                break;
//            default:
//            {
//                //在线
//                cell.onlineStationImageView.image = nil;
//                cell.headerImageView.alpha = 1;
//            }
//                break;
//        }
//
//        cell.nameLabel.text = [NSString stringWithFormat:@"%@[%@]",doctor.UserName,doctor.jobTileName];
//        cell.departmentLabel.text = doctor.DepartmentName;
//        cell.descriptionLabel.text = doctor.Skilled;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    self.isPop = NO;

    BATNewConsultionDoctorDetailViewController *doctorDetailVC = [[BATNewConsultionDoctorDetailViewController alloc] init];

    if (self.isConsulted) {

        //咨询过的医生
        ConsultationDoctorData *data = self.consultedDoctorModel.Data[0];
        ConsultationDoctors *doctor = data.Doctors[indexPath.row];
        doctorDetailVC.doctorID = doctor.DoctorID;
        doctorDetailVC.pathName = [NSString stringWithFormat:@"%@-%@",self.pathName,doctor.DoctorName];
    }
    else {

        //科室医生
        ConsultationDepartmentDetailData *doctor = self.dataArray[indexPath.row];
        doctorDetailVC.doctorID = doctor.DoctorID;
        doctorDetailVC.pathName = [NSString stringWithFormat:@"%@-%@",self.pathName,doctor.DoctorName];

    }
    
    [self.navigationController pushViewController:doctorDetailVC animated:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    _keyWord = textField.text;
    self.defaultView.hidden = YES;
    [self.departmentDetailListTableView.mj_header beginRefreshing];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    [textField resignFirstResponder];
    _keyWord = @"";
    self.defaultView.hidden = YES;
    [self.departmentDetailListTableView.mj_header beginRefreshing];
    return YES;
}

#pragma mark - net
//科室医生
- (void)doctorsListRequest {
    
    NSDictionary *parameters = @{
                                 @"DepartmentName":self.departmentName?self.departmentName:@"",
                                 @"pageIndex":@(self.currentPage),
                                 @"pageSize":@"10",
                                 @"keyWord":self.keyWord,
                                 };
    [HTTPTool requestWithURLString:@"/api/NetworkMedical/GetDoctorsByDepartment" parameters:parameters type:kGET success:^(id responseObject) {
        
        [self.departmentDetailListTableView.mj_header endRefreshingWithCompletionBlock:^{
            self.isCompleteRequest = YES;
            [self.departmentDetailListTableView reloadData];
        }];
        [self.departmentDetailListTableView.mj_footer endRefreshing];
        BATConsultationDepartmentDetailModel *departmentDetailModel = [BATConsultationDepartmentDetailModel mj_objectWithKeyValues:responseObject];
        if (self.currentPage == 1) {
            [self.dataArray removeAllObjects];
        }
        [self.dataArray addObjectsFromArray:departmentDetailModel.Data];
        if (self.dataArray.count >= departmentDetailModel.RecordsCount) {
            [self.departmentDetailListTableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.departmentDetailListTableView reloadData];
        
        if (_dataArray.count == 0) {
            [self.defaultView showDefaultView];
        }
        
    } failure:^(NSError *error) {
        self.currentPage --;
        [self.departmentDetailListTableView.mj_header endRefreshingWithCompletionBlock:^{
            self.isCompleteRequest = YES;
            [self.departmentDetailListTableView reloadData];
        }];
        [self.departmentDetailListTableView.mj_footer endRefreshing];
        
        [self.defaultView showDefaultView];
    }];

//    NSDictionary *parameters = @{
//                                 @"hospitalName":@"",
//                                 @"departmentName":self.departmentName?self.departmentName:@"",
//                                 @"doctorName":@"",
//                                 @"pageIndex":@(self.currentPage),
//                                 @"pageSize":@"10",
//                                 @"accountid":@""
//                                 };
//    [HTTPTool requestWithURLString:@"/api/Search/SearchDoctor" parameters:parameters type:kGET success:^(id responseObject) {
//
//        [self.departmentDetailListTableView.mj_header endRefreshing];
//        [self.departmentDetailListTableView.mj_footer endRefreshing];
//        BATConsultationDepartmentDetailModel *departmentDetailModel = [BATConsultationDepartmentDetailModel mj_objectWithKeyValues:responseObject];
//        if (self.currentPage == 0) {
//            [self.dataArray removeAllObjects];
//        }
//        [self.dataArray addObjectsFromArray:departmentDetailModel.Data];
//        if (self.dataArray.count >= departmentDetailModel.RecordsCount) {
//            [self.departmentDetailListTableView.mj_footer endRefreshingWithNoMoreData];
//        }
//        [self.departmentDetailListTableView reloadData];
//    } failure:^(NSError *error) {
//        self.currentPage --;
//        [self.departmentDetailListTableView.mj_header endRefreshing];
//        [self.departmentDetailListTableView.mj_footer endRefreshing];
//    }];
}

//咨询过的医生
- (void)consultedDoctorListReques {
    if (!LOGIN_STATION) {
        return;
    }
    
    [HTTPTool requestWithURLString:@"/api/NetworkMedical/GetMyVisitDoctors" parameters:nil type:kGET success:^(id responseObject) {
        
        [self.departmentDetailListTableView.mj_header endRefreshingWithCompletionBlock:^{
            self.isCompleteRequest = YES;
            [self.departmentDetailListTableView reloadData];
        }];
        [self.departmentDetailListTableView.mj_footer endRefreshingWithNoMoreData];
        self.consultedDoctorModel = [BATConsultationDoctorModel mj_objectWithKeyValues:responseObject];
        [self.departmentDetailListTableView reloadData];
        
        if (_dataArray.count == 0) {
            [self.defaultView showDefaultView];
        }
    } failure:^(NSError *error) {
        [self.departmentDetailListTableView.mj_header endRefreshingWithCompletionBlock:^{
            self.isCompleteRequest = YES;
            [self.departmentDetailListTableView reloadData];
        }];
        [self.departmentDetailListTableView.mj_footer endRefreshing];
        
        [self.defaultView showDefaultView];
    }];
//    [HTTPTool requestWithURLString:@"/api/OnlineConsult/ConsultedDoctors" parameters:nil type:kGET success:^(id responseObject) {
//
//        [self.departmentDetailListTableView.mj_header endRefreshing];
//        [self.departmentDetailListTableView.mj_footer endRefreshingWithNoMoreData];
//        self.consultedDoctorModel = [BATConsultationDoctorModel mj_objectWithKeyValues:responseObject];
//        [self.departmentDetailListTableView reloadData];
//    } failure:^(NSError *error) {
//        [self.departmentDetailListTableView.mj_header endRefreshing];
//        [self.departmentDetailListTableView.mj_footer endRefreshing];
//    }];
}


#pragma mark - layout
- (void)layoutPages {
    WEAK_SELF(self);
    
    self.isPop = YES;
    self.beginTime = [Tools getCurrentDateStringByFormat:@"yyyy-MM-dd HH:mm:ss"];
    [self.view addSubview:self.departmentDetailListTableView];
    [self.departmentDetailListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:self.defaultView];
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.bottom.right.left.top.equalTo(self.view);
    }];
    
    self.navigationItem.titleView = self.searchTF;
}

#pragma mark - getter
- (UITableView *)departmentDetailListTableView {

    if (!_departmentDetailListTableView) {
        _departmentDetailListTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _departmentDetailListTableView.rowHeight = 90;
        _departmentDetailListTableView.delegate = self;
        _departmentDetailListTableView.dataSource = self;
        _departmentDetailListTableView.tableFooterView = [UIView new];
        _departmentDetailListTableView.backgroundColor = BASE_BACKGROUND_COLOR;
        _departmentDetailListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        _departmentDetailListTableView.emptyDataSetSource = self;
        _departmentDetailListTableView.emptyDataSetDelegate = self;

        [_departmentDetailListTableView registerClass:[BATConsultationDepartmentDoctorTableViewCell class] forCellReuseIdentifier:DOCTOR_CELL];

        _departmentDetailListTableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{

            self.currentPage = 1;
            if (self.isConsulted) {
                [self consultedDoctorListReques];
            }
            else {
                [self doctorsListRequest];
            }
        }];

        _departmentDetailListTableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{

            self.currentPage ++;
            [self doctorsListRequest];
        }];
        
//        _departmentDetailListTableView.mj_footer.hidden = YES;

        if (self.isConsulted) {
            [_departmentDetailListTableView.mj_footer endRefreshingWithNoMoreData];
        }
    }
    return _departmentDetailListTableView;
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
            
            [self.departmentDetailListTableView.mj_header beginRefreshing];
        }];
        
    }
    return _defaultView;
}

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
