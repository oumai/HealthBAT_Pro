//
//  BATDoctorScheduleViewController.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/9/23.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATDoctorScheduleViewController.h"
#import "BATDoctorScheduleModel.h"
#import "BATDoctorScheduleConfrimViewController.h"

@interface BATDoctorScheduleViewController ()

@property (nonatomic,strong) BATDoctorScheduleModel *doctorScheduleModel;

@property (nonatomic,strong) NSString *beginTime;

@property (nonatomic,assign) BOOL isPopAction;

@end

@implementation BATDoctorScheduleViewController

- (void)dealloc
{
    DDLogWarn(@"%@",self);
}

- (void)loadView
{
    [super loadView];
    
    if (_doctorScheduleView == nil) {
        _doctorScheduleView = [[BATDoctorScheduleView alloc] init];
        [self.view addSubview:_doctorScheduleView];
        
        WEAK_SELF(self);
        [_doctorScheduleView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.edges.equalTo(self.view);
        }];
    }
    
    [self requestGetSchedule];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.isPopAction = YES;
    self.beginTime = [Tools getCurrentDateStringByFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    self.title = @"我的排班";
    
    [_doctorScheduleView.footerView.confirmButton addTarget:self action:@selector(confirmButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    
    //用户画像 模块操作
    if(self.isPopAction) {
    [BATUserPortrayTools saveOperateModuleRequestWithURL:@"/kmStatistical-sync/saveOperateModule" pathName:self.pathName moduleId:3 beginTime:self.beginTime];
    }
}

#pragma mark - Action
- (void)confirmButtonAction:(UIButton *)button
{
    DDLogWarn(@"确认");
    
    Schedulelist *scheduleList = _doctorScheduleModel.Data.ScheduleList[_doctorScheduleView.selectScheduleIndex];
    
    Dateweeklist *dateweeklist = _doctorScheduleModel.Data.DateWeekList[_doctorScheduleView.selectRegnumlistIndex];

    
    if (scheduleList.RegNumList.count > 0) {
        Regnumlist *regNumList = scheduleList.RegNumList[_doctorScheduleView.selectRegnumlistIndex];
        
        if (![regNumList.DoctorScheduleID isEqualToString:@"0"]) {
            
            self.isPopAction = NO;
            [BATUserPortrayTools saveOperateModuleRequestWithURL:@"/kmStatistical-sync/saveOperateModule" pathName:self.pathName moduleId:3 beginTime:self.beginTime];
            //预约
            BATDoctorScheduleConfrimViewController *doctorScheduleConfrimVC = [[BATDoctorScheduleConfrimViewController alloc] init];
            doctorScheduleConfrimVC.doctorID = _doctorId;
            doctorScheduleConfrimVC.type = _type;
            doctorScheduleConfrimVC.scheduleID = regNumList.DoctorScheduleID;
            doctorScheduleConfrimVC.momey = _momey;
            doctorScheduleConfrimVC.doctorName = _doctorName;
            doctorScheduleConfrimVC.departmentName = _departmentName;
            doctorScheduleConfrimVC.time = [NSString stringWithFormat:@"%@ %@-%@",dateweeklist.DateStr,scheduleList.StartTime,scheduleList.EndTime];
            doctorScheduleConfrimVC.IsFreeClinicr = _IsFreeClinicr;
            doctorScheduleConfrimVC.hidesBottomBarWhenPushed = YES;
            doctorScheduleConfrimVC.pathName = [NSString stringWithFormat:@"%@-订单确认",self.pathName];
            [self.navigationController pushViewController:doctorScheduleConfrimVC animated:YES];
            
        } else {
            [self showText:@"请选择预约时间"];
        }
    }
    
}

#pragma mark - NET
#pragma mark - 获取医生排班
- (void)requestGetSchedule
{
    
    [self showProgress];
    
    [HTTPTool requestWithURLString:@"/api/NetworkMedical/GetSchedule" parameters:@{@"doctorId":_doctorId} type:kGET success:^(id responseObject) {
        
        [self dismissProgress];
        
        _doctorScheduleModel = [BATDoctorScheduleModel mj_objectWithKeyValues:responseObject];
        
        [_doctorScheduleView configrationData:_doctorScheduleModel];
        
    } failure:^(NSError *error) {
        [self dismissProgress];
    }];
}

@end
