//
//  DoctorDutyViewController.m
//  HealthBAT_Pro
//
//  Created by Skyrim on 16/7/16.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATDoctorDutyViewController.h"
#import "BATDoctorInfoView.h"
#import "BATDutyTableViewCell.h"
#import "BATDutyModel.h"

#import "BATRegisterHospitalRegisterViewController.h"

#import "UIScrollView+EmptyDataSet.h"

@interface BATDoctorDutyViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic,strong) BATDoctorInfoView *topView;
@property (nonatomic,strong) UITableView       *dutyListTableView;
@property (nonatomic,strong) BATDutyModel      *dutyModel;

@end

@implementation BATDoctorDutyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"医生预约详情";
    
    [self pagesLayout];
    [self doctorScheduleRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dutyModel.Data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BATDutyTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"dutyCell" forIndexPath:indexPath];
    BATDutyData * duty = self.dutyModel.Data[indexPath.row];
    cell.timeLabel.text = [NSString stringWithFormat:@"%@%@",duty.TO_DATE,duty.TIME_TYPE_DESC];
    cell.countLabel.text = [NSString stringWithFormat:@"剩余%ld",(long)duty.LEFT_NUM];
    cell.priceLabel.text = [NSString stringWithFormat:@"¥%ld",(long)duty.GUAHAO_AMT];
    if (duty.LEFT_NUM > 0) {
        cell.registerButton.enabled = YES;
        [cell.registerButton setTitle:@"去挂号" forState:UIControlStateNormal];
        [cell.registerButton setBackgroundColor:BASE_COLOR];
    }
    else {
        cell.registerButton.enabled = NO;
        [cell.registerButton setTitle:@"号源已满" forState:UIControlStateNormal];
        [cell.registerButton setBackgroundColor:[UIColor grayColor]];
    }
    WEAK_SELF(self);
    [cell setHospitalRegister:^{
        //去挂号
        
        //登录判断
        if (!LOGIN_STATION) {
            PRESENT_LOGIN_VC
            return ;
        }

        STRONG_SELF(self);
        BATRegisterHospitalRegisterViewController * vc = [BATRegisterHospitalRegisterViewController new];
        vc.hospitalName = self.doctor.UNIT_NAME;
        vc.hospitalID = [self.doctor.UNIT_ID integerValue];
        vc.departmentName = self.doctor.DEP_NAME;
        vc.departmentID = [self.doctor.DEP_ID integerValue];
        vc.doctorName = self.doctor.DOCTOR_NAME;
        vc.doctorID = self.doctor.DOCTOR_ID;
        vc.ZCID = self.doctor.ZCID;
        vc.duty = duty;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    return cell;
}

#pragma mark - DZNEmptyDataSetSource
//返回标题文字
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f], NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

//返回详情文字
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"暂无该医生排班信息";
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName: [UIColor lightGrayColor], NSParagraphStyleAttributeName: paragraph};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

#pragma mark - NET
- (void)doctorScheduleRequest {
    NSDictionary *parammeters = @{
                                         @"uid":self.doctor.UNIT_ID,
                                       @"depid":self.doctor.DEP_ID,
                                       @"docid":@(self.doctor.DOCTOR_ID),
                                  @"begin_date":@"",
                                    @"end_date":@"",
                                        @"date":@""
                                  };
    [HTTPTool requestWithURLString:@"/api/AppointmentDoctor/GetSchedulingList" parameters:parammeters type:kGET success:^(id responseObject) {
        self.dutyModel = [BATDutyModel mj_objectWithKeyValues:responseObject];
        [self.dutyListTableView reloadData];
    } failure:^(NSError *error) {

    }];
}

#pragma mark - layout
- (void)pagesLayout {
    [self.view addSubview:self.dutyListTableView];
}

#pragma mark - setter && getter
- (UITableView *)dutyListTableView {

    if (!_dutyListTableView) {
        
        _dutyListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
        _dutyListTableView.delegate = self;
        _dutyListTableView.dataSource = self;
        [_dutyListTableView registerClass:[BATDutyTableViewCell class] forCellReuseIdentifier:@"dutyCell"];
        _dutyListTableView.tableFooterView = [UIView new];
        _dutyListTableView.tableHeaderView = self.topView;
        _dutyListTableView.emptyDataSetSource = self;
        _dutyListTableView.emptyDataSetDelegate = self;
    }
    return _dutyListTableView;
}

- (BATDoctorInfoView *)topView {
    if (!_topView) {
        _topView = [[BATDoctorInfoView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120) imageUrl:self.doctor.IMAGE name:self.doctor.DOCTOR_NAME level:self.doctor.ZCID hospital:self.doctor.UNIT_NAME des:self.doctor.EXPERT];
    }
    return _topView;
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
