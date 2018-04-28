//
//  BATFreeClinicDoctorViewController.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/9/28.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATFreeClinicDoctorViewController.h"
#import "BATConsultationDepartmentDoctorTableViewCell.h"
#import "BATFreeClinicDoctorModel.h"
#import "BATWriteSingleDiseaseViewController.h"

static  NSString * const FREE_DOCTOR_CELL = @"FreeDoctorCell";

@interface BATFreeClinicDoctorViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,assign) NSInteger pageIndex;

@property (nonatomic,assign) NSInteger pageSize;

@property (nonatomic,strong) NSString *beginTime;

@property (nonatomic,assign) BOOL isPopAction;

@end

@implementation BATFreeClinicDoctorViewController

- (void)dealloc
{
    DDLogWarn(@"%@",self);
    _freeClinicDoctorView.tableView.delegate = nil;
    _freeClinicDoctorView.tableView.dataSource = nil;
}

- (void)loadView
{
    [super loadView];
    
    if (_freeClinicDoctorView == nil) {
        _freeClinicDoctorView = [[BATFreeClinicDoctorView alloc] init];
        _freeClinicDoctorView.tableView.delegate = self;
        _freeClinicDoctorView.tableView.dataSource = self;
        [self.view addSubview:_freeClinicDoctorView];
        
        WEAK_SELF(self);
        [_freeClinicDoctorView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.edges.equalTo(self.view);
        }];
        
        _freeClinicDoctorView.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.pageIndex = 1;
            [self.freeClinicDoctorView.tableView.mj_footer resetNoMoreData];
            [self requestGetFreeClinicDoctors];
        }];
        
        _freeClinicDoctorView.tableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.pageIndex++;
            [self requestGetFreeClinicDoctors];
        }];
    }
    
    self.title = @"今日义诊";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.isPopAction = YES;
    self.beginTime = [Tools getCurrentDateStringByFormat:@"yyyy-MM-dd HH:mm:ss"];
    [_freeClinicDoctorView.tableView registerClass:[BATConsultationDepartmentDoctorTableViewCell class] forCellReuseIdentifier:FREE_DOCTOR_CELL];
    
    _dataSource = [NSMutableArray array];
    _pageSize = 10;
    _pageIndex = 1;
    
    [_freeClinicDoctorView.tableView.mj_header beginRefreshing];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.isPopAction) {
         [BATUserPortrayTools saveOperateModuleRequestWithURL:@"/kmStatistical-sync/saveOperateModule" pathName:self.pathName moduleId:3 beginTime:self.beginTime];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BATConsultationDepartmentDoctorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FREE_DOCTOR_CELL forIndexPath:indexPath];
    
    if (_dataSource.count > 0) {
        FreeClinicDoctorData *doctor = _dataSource[indexPath.row];
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
        cell.descriptionLabel.text = [NSString stringWithFormat:@"擅长：%@",[doctor.Specialty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];;
    }

    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!LOGIN_STATION) {
        PRESENT_LOGIN_VC;
        return;
    }
    self.isPopAction = NO;
    FreeClinicDoctorData *doctor = _dataSource[indexPath.row];
    
    BATWriteSingleDiseaseViewController *writeSingleDiseaseVC = [[BATWriteSingleDiseaseViewController alloc]init];
    writeSingleDiseaseVC.type = kConsultTypeFree;
    writeSingleDiseaseVC.doctorID = doctor.DoctorID;
    writeSingleDiseaseVC.momey = @"0";
    writeSingleDiseaseVC.IsFreeClinicr = NO;
    writeSingleDiseaseVC.pathName = [NSString stringWithFormat:@"%@-免费咨询-%@",self.pathName,doctor.DoctorName];
    //                            writeSingleDiseaseVC.AccountID = [NSString stringWithFormat:@"%ld",(long)self.KMDoctorModel.Data.AccountID];
    //                            writeSingleDiseaseVC.momey = [NSString stringWithFormat:@"%.2f",self.KMDoctorModel.Data.WordConsultMoney];
    //                            writeSingleDiseaseVC.doctorName = self.KMDoctorModel.Data.UserName;
    //                            writeSingleDiseaseVC.doctiorPhotoPath = self.KMDoctorModel.Data.PhotoPath;
    writeSingleDiseaseVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:writeSingleDiseaseVC animated:YES];
}

#pragma mark - NET
//义诊医生
- (void)requestGetFreeClinicDoctors
{
    
    [HTTPTool requestWithURLString:@"/api/NetworkMedical/GetFreeClinicDoctors" parameters:@{@"pageIndex":@(_pageIndex),@"pageSize":@(_pageSize)} type:kGET success:^(id responseObject) {
        [_freeClinicDoctorView.tableView.mj_header endRefreshing];
        [_freeClinicDoctorView.tableView.mj_footer endRefreshing];
        
        if (_pageIndex == 1) {
            [_dataSource removeAllObjects];
        }
        
        BATFreeClinicDoctorModel *freeClinicDoctorModel = [BATFreeClinicDoctorModel mj_objectWithKeyValues:responseObject];
        
        [_dataSource addObjectsFromArray:freeClinicDoctorModel.Data];
        
        if (freeClinicDoctorModel.RecordsCount > 0) {
            _freeClinicDoctorView.tableView.mj_footer.hidden = NO;
        } else {
            _freeClinicDoctorView.tableView.mj_footer.hidden = YES;
        }
        
        if (_dataSource.count == freeClinicDoctorModel.RecordsCount) {
            [_freeClinicDoctorView.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        [_freeClinicDoctorView.tableView reloadData];
        
    } failure:^(NSError *error) {
        [_freeClinicDoctorView.tableView.mj_header endRefreshing];
        [_freeClinicDoctorView.tableView.mj_footer endRefreshing];
        _pageIndex--;
        if (_pageIndex < 1) {
            _pageIndex = 1;
        }
    }];
}

@end
