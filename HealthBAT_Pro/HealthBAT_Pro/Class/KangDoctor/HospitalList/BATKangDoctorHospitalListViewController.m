//
//  BATKangDoctorHospitalListViewController.m
//  HealthBAT_Pro
//
//  Created by KM on 17/7/172017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATKangDoctorHospitalListViewController.h"
#import "BATKangDoctorHospitalTableViewCell.h"
#import "BATKangDoctorHospitalModel.h"

#import "BATRegisterDepartmentListViewController.h"

static  NSString * const HOSPITAL_LIST_CELL = @"BATKangDoctorHospitalTableViewCell";

@interface BATKangDoctorHospitalListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *hospitalListTableView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation BATKangDoctorHospitalListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.dataArray = [NSMutableArray array];
    
    [self layoutPages];
    
    [self hospitalDataRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BATKangDoctorHospitalTableViewCell *hospitalCell = [tableView dequeueReusableCellWithIdentifier:HOSPITAL_LIST_CELL forIndexPath:indexPath];
    
    BATKangDoctorHospitalData *hospitalData = self.dataArray[indexPath.row];
    
    [hospitalCell.hospitalImageView sd_setImageWithURL:[NSURL URLWithString:hospitalData.pictureUrl] placeholderImage:[UIImage imageNamed:@"默认图"]];
    hospitalCell.hospitalNameLabel.text = hospitalData.resultTitle;
    hospitalCell.hospitalLocationLabel.text = hospitalData.address;
    hospitalCell.distanceLabel.text = hospitalData.geoDistance;

    return hospitalCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BATKangDoctorHospitalData *hospitalData = self.dataArray[indexPath.row];

    BATRegisterDepartmentListViewController *departmentVC = [[BATRegisterDepartmentListViewController alloc] init];
    departmentVC.hospitalId = [hospitalData.resultId integerValue];
    departmentVC.hospitalName = hospitalData.resultTitle;
    [self.navigationController pushViewController:departmentVC animated:YES];
}

#pragma mark - net
- (void)hospitalDataRequest {
    
    NSDictionary *para = nil;

    if (self.lat && self.lon) {
        para = @{@"lat":@(self.lat),@"lon":@(self.lon)};
    }
    
    [HTTPTool requestWithSearchURLString:@"/elasticsearch/searchapp/searchNearHospital" parameters:para success:^(id responseObject) {
        
        BATKangDoctorHospitalModel *hospitalModel = [BATKangDoctorHospitalModel mj_objectWithKeyValues:responseObject];
        if (hospitalModel.resultCode != 0) {
            [self showErrorWithText:hospitalModel.msg];
        }
        
        [self.dataArray addObjectsFromArray:hospitalModel.resultData];
        [self.hospitalListTableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - layout
- (void)layoutPages {
    
    self.title = @"附近的医院";
    
    [self.view addSubview:self.hospitalListTableView];
    [self.hospitalListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
}

#pragma mark - getter
- (UITableView *)hospitalListTableView {
    
    if (!_hospitalListTableView) {
        
        _hospitalListTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _hospitalListTableView.showsVerticalScrollIndicator = NO;
        _hospitalListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _hospitalListTableView.backgroundColor = BASE_BACKGROUND_COLOR;
        _hospitalListTableView.rowHeight = 100.f;

        [_hospitalListTableView registerClass:[BATKangDoctorHospitalTableViewCell class] forCellReuseIdentifier:HOSPITAL_LIST_CELL];
    
        
        _hospitalListTableView.delegate = self;
        _hospitalListTableView.dataSource = self;

    }
    return _hospitalListTableView;
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
