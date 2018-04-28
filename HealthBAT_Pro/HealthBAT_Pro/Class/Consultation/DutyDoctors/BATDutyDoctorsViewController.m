//
//  BATDutyDoctorsViewController.m
//  HealthBAT_Pro
//
//  Created by mac on 2017/12/19.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDutyDoctorsViewController.h"
#import "BATConsultationDepartmentDoctorTableViewCell.h"
#import "BATDutyDoctorsModel.h"

#import "BATNewConsultionDoctorDetailViewController.h"

static  NSString * const DOCTOR_CELL = @"BATConsultationDepartmentDoctorTableViewCell";

@interface BATDutyDoctorsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *dutyDoctorsListTableView;
@property (nonatomic,assign) NSInteger pageIndex;
@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) BATDefaultView *defaultView;

@end

@implementation BATDutyDoctorsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataArray = [NSMutableArray array];
    self.pageIndex = 1;
    
    [self layoutPages];
    [self.dutyDoctorsListTableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BATDutyDoctorsDataModel *data = self.dataArray[indexPath.row];
    
    BATConsultationDepartmentDoctorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DOCTOR_CELL forIndexPath:indexPath];
    
    [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:data.User.PhotoUrl] placeholderImage:[UIImage imageNamed:@"医生"]];
    
    cell.hospitalLevelImageView.hidden = YES;
    
    cell.nameLabel.text = data.TitleName.length > 0 ? [NSString stringWithFormat:@"%@[%@]",data.DoctorName,data.TitleName] : data.DoctorName;
    cell.departmentLabel.text = data.DepartmentName;
    cell.descriptionLabel.text = data.Specialty;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BATDutyDoctorsDataModel *data = self.dataArray[indexPath.row];

    BATNewConsultionDoctorDetailViewController *doctorDetailVC = [[BATNewConsultionDoctorDetailViewController alloc] init];
    doctorDetailVC.doctorID = data.DoctorID;
    [self.navigationController pushViewController:doctorDetailVC animated:YES];
}

#pragma mark - net
- (void)requestDutyDoctors {
    
    
    
    [HTTPTool requestWithKmWlyyBaseApiURLString:@"/Doctors/GetAvailableDoctors" parameters:@{@"CurrentPage":@(self.pageIndex),@"PageSize":@"10",@"Keyword":@"",@"ScheduleDate":[Tools getCurrentDateStringByFormat:@"yyyy-MM-dd"]} type:kGET success:^(id responseObject) {
       
        [self.dutyDoctorsListTableView.mj_header endRefreshing];
        [self.dutyDoctorsListTableView.mj_footer endRefreshing];
        
        BATDutyDoctorsModel *dutyDoctorsModel = [BATDutyDoctorsModel mj_objectWithKeyValues:responseObject];
        
        [self.dataArray addObjectsFromArray:dutyDoctorsModel.Data];
        
        if (self.dataArray.count >= dutyDoctorsModel.Total) {
            [self.dutyDoctorsListTableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        if (self.dataArray.count == 0) {
            
            [self.defaultView showDefaultView];
            self.defaultView.reloadButton.hidden = YES;
        }
        
        [self.dutyDoctorsListTableView reloadData];
        
    } failure:^(NSError *error) {
        
        [self.dutyDoctorsListTableView.mj_header endRefreshing];
        [self.dutyDoctorsListTableView.mj_footer endRefreshing];
        self.pageIndex--;
        if (_pageIndex < 1) {
            _pageIndex = 1;
        }
        
        [self.defaultView showDefaultView];
    }];
}

#pragma mark - layoutPages
- (void)layoutPages {
    
    self.title = @"值班医生";
    
    [self.view addSubview:self.dutyDoctorsListTableView];
    [self.dutyDoctorsListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    
    [self.view addSubview:self.defaultView];
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
}

#pragma mark - getter
- (UITableView *)dutyDoctorsListTableView {
    
    if (!_dutyDoctorsListTableView) {
        
        _dutyDoctorsListTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _dutyDoctorsListTableView.showsVerticalScrollIndicator = NO;
        _dutyDoctorsListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _dutyDoctorsListTableView.rowHeight = 90;
        
        [_dutyDoctorsListTableView registerClass:[BATConsultationDepartmentDoctorTableViewCell class] forCellReuseIdentifier:DOCTOR_CELL];
        
        _dutyDoctorsListTableView.tableFooterView = [[UIView alloc] init];
        
        _dutyDoctorsListTableView.delegate = self;
        _dutyDoctorsListTableView.dataSource = self;
        
        _dutyDoctorsListTableView.estimatedRowHeight = 0;
        _dutyDoctorsListTableView.estimatedSectionHeaderHeight = 0;
        _dutyDoctorsListTableView.estimatedSectionFooterHeight = 0;
        
        WEAK_SELF(self);
        _dutyDoctorsListTableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.pageIndex = 1;
            [_dutyDoctorsListTableView.mj_footer resetNoMoreData];
            [self.dataArray removeAllObjects];
            [self requestDutyDoctors];
        }];
        
        _dutyDoctorsListTableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.pageIndex ++;
            [self requestDutyDoctors];
        }];
        
    }
    return _dutyDoctorsListTableView;
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
            
            [self.dutyDoctorsListTableView.mj_header beginRefreshing];
            
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
