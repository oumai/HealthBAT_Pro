//
//  BATDoctorScheduleConfrimViewController.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/9/28.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATDoctorScheduleConfrimViewController.h"
#import "BATDoctorScheduleConfrimInfoCell.h"
//#import "BATFileListController.h"
#import "BATHealthFilesListVC.h"
#import "BATChooseEntiyModel.h"
#import "BATDiseaseDescriptionModel.h"
#import "BATConfirmPayViewController.h"
#import "BATChatConsultController.h"

@interface BATDoctorScheduleConfrimViewController () <UITableViewDelegate,UITableViewDataSource>

/**
 *  家庭成员
 */
@property (nonatomic,strong) MyResData *myResData;

/**
 *  memberID
 */
@property (nonatomic,strong) NSString *memberID;

@property (nonatomic,strong) NSString *beginTime;

@property (nonatomic,assign) BOOL isPopAction;

@end

@implementation BATDoctorScheduleConfrimViewController

- (void)dealloc
{
    DDLogWarn(@"%@",self);
    _doctorScheduleConfrimView.tableView.delegate = nil;
    _doctorScheduleConfrimView.tableView.dataSource = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadView
{
    [super loadView];
    
    if (_doctorScheduleConfrimView == nil) {
        _doctorScheduleConfrimView = [[BATDoctorScheduleConfrimView alloc] init];
        _doctorScheduleConfrimView.tableView.delegate = self;
        _doctorScheduleConfrimView.tableView.dataSource = self;
        [self.view addSubview:_doctorScheduleConfrimView];
        
        WEAK_SELF(self);
        [_doctorScheduleConfrimView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.edges.equalTo(self.view);
        }];
    }

    self.title = @"订单确认";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.isPopAction = YES;
    
    self.beginTime = [Tools getCurrentDateStringByFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    [_doctorScheduleConfrimView.confirmButton addTarget:self action:@selector(confirmButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    [_doctorScheduleConfrimView.tableView registerClass:[BATDoctorScheduleConfrimInfoCell class] forCellReuseIdentifier:@"BATDoctorScheduleConfrimInfoCell"];
    
    [self requestGetDefaultUserMembers];
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
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BATDoctorScheduleConfrimInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATDoctorScheduleConfrimInfoCell" forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"医生:"];
        [string yy_setKern:[NSNumber numberWithInt:30] range:NSMakeRange(0, 1)];
        string.yy_font = [UIFont systemFontOfSize:14];
        string.yy_color = UIColorFromHEX(0x333333, 1);
        cell.titleLabel.attributedText = string;
        cell.contentLabel.text = _doctorName;
    } else if (indexPath.row == 1) {
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"时间:"];
        [string yy_setKern:[NSNumber numberWithInt:30] range:NSMakeRange(0, 1)];
        string.yy_font = [UIFont systemFontOfSize:14];
        string.yy_color = UIColorFromHEX(0x333333, 1);
        cell.titleLabel.attributedText = string;
        cell.contentLabel.text = _time;
    } else if (indexPath.row == 2) {
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"科室:"];
        [string yy_setKern:[NSNumber numberWithInt:30] range:NSMakeRange(0, 1)];
        string.yy_font = [UIFont systemFontOfSize:14];
        string.yy_color = UIColorFromHEX(0x333333, 1);
        cell.titleLabel.attributedText = string;
        cell.contentLabel.text = _departmentName;
    } else if (indexPath.row == 3) {
        cell.titleLabel.text = @"预约服务:";
        
        
        NSMutableAttributedString *content = nil;
        
        if (_type == kConsultTypeVideo) {
            content = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"视频咨询 %@元/次",_momey]];
        } else if (_type == kConsultTypeAudio) {
            content = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"语音咨询 %@元/次",_momey]];
        }
        
        [content setAttributes:@{NSForegroundColorAttributeName:UIColorFromHEX(0xff0000, 1)} range:NSMakeRange(5, content.length - 5)];
        
        cell.contentLabel.attributedText = content;
        
    } else if (indexPath.row == 4) {
        cell.titleLabel.text = @"就  诊  人:";
        if (_myResData != nil) {
            cell.contentLabel.text = _myResData.MemberName;
        } else {
            cell.contentLabel.text = @"请选择就诊人";
        }
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 4) {
        //选择就诊人信息
        BATHealthFilesListVC *chooseTreatmentPersonVC = [[BATHealthFilesListVC alloc] init];
        chooseTreatmentPersonVC.isConsultionAndAppointmentYes = YES;
        WEAK_SELF(self)
        [chooseTreatmentPersonVC setChooseBlock:^(ChooseTreatmentModel *chooseTreatmentModel) {
            STRONG_SELF(self)
            _myResData = [[MyResData alloc] init];
            _myResData.MemberName = chooseTreatmentModel.name;
            _myResData.MemberID = chooseTreatmentModel.memberID;
            _myResData.UserID = chooseTreatmentModel.userID;
            _myResData.Mobile = chooseTreatmentModel.phoneNumber;
            self.memberID = chooseTreatmentModel.memberID;
            _myResData.IsPerfect = chooseTreatmentModel.IsPerfect;
//            _doctorScheduleConfrimView.confirmButton.enabled = YES;
            
            [_doctorScheduleConfrimView.tableView reloadData];
            
        }];
        chooseTreatmentPersonVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:chooseTreatmentPersonVC animated:YES];
    }
}

#pragma mark - Action

#pragma mark - 确认
- (void)confirmButtonAction
{
    [self requestSubmitBooking];
}

#pragma mark - NET
#pragma mark - 获取默认就诊人
- (void)requestGetDefaultUserMembers
{
    [self showProgressWithText:@"正在加载"];
    [HTTPTool requestWithURLString:@"/api/NetworkMedical/GetDefaultUserMembers" parameters:nil type:kGET success:^(id responseObject) {
        [self dismissProgress];
        
        BATChooseEntiyModel *chooseEntiyModel = [BATChooseEntiyModel mj_objectWithKeyValues:responseObject];
        if (chooseEntiyModel.Data.count > 0) {
            self.memberID = [chooseEntiyModel.Data[0] MemberID];
            _myResData = chooseEntiyModel.Data[0];
            
            if (!_myResData.IsPerfect) {
                [self showText:@"请完善就诊人信息"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    BATHealthFilesListVC *filedVC = [[BATHealthFilesListVC alloc]init];
                    filedVC.isConsultionAndAppointmentYes = YES;
                    [filedVC setChooseBlock:^(ChooseTreatmentModel *chooseTreatmentModel) {
                        
                        _myResData.MemberName = chooseTreatmentModel.name;
                        _myResData.MemberID = chooseTreatmentModel.memberID;
                        _myResData.UserID = chooseTreatmentModel.userID;
                        _myResData.Mobile = chooseTreatmentModel.phoneNumber;
                        _myResData.IsPerfect = chooseTreatmentModel.IsPerfect;
                        self.memberID = chooseTreatmentModel.memberID;
                        [_doctorScheduleConfrimView.tableView reloadData];
                        
                    }];
                    [self.navigationController pushViewController:filedVC animated:YES];
                });
            }
        }
        
        
        
        [_doctorScheduleConfrimView.tableView reloadData];
        
    } failure:^(NSError *error) {
        [self showErrorWithText:error.localizedDescription];

    }];
}

#pragma mark - 提交预约
- (void)requestSubmitBooking
{
    _doctorScheduleConfrimView.confirmButton.enabled = NO;
    
    self.isPopAction = NO;
    [BATUserPortrayTools saveOperateModuleRequestWithURL:@"/kmStatistical-sync/saveOperateModule" pathName:self.pathName moduleId:3 beginTime:self.beginTime];
    
    
    if (_myResData == nil) {
        [self showErrorWithText:@"请选择就诊人"];
        _doctorScheduleConfrimView.confirmButton.enabled = YES;
        return;
    }
    
    if (!_myResData.IsPerfect) {
        [self showText:@"请完善就诊人信息"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            BATHealthFilesListVC *filedVC = [[BATHealthFilesListVC alloc]init];
            filedVC.isConsultionAndAppointmentYes = YES;
            [self.navigationController pushViewController:filedVC animated:YES];
        });
         _doctorScheduleConfrimView.confirmButton.enabled = YES;
        return;
    }
    
    NSInteger opdType = 0;
    if (_type == kConsultTypeVideo) {
        opdType = 3;
    } else if (_type == kConsultTypeAudio) {
        opdType = 2;
    }
    
    [self showProgressWithText:@"正在提交订单!"];
    
    [HTTPTool requestWithURLString:@"/api/NetworkMedical/InsertUserOPDRegister" parameters:@{@"MemberID":_myResData.MemberID,@"ScheduleID":_scheduleID,@"OPDType":@(opdType)} type:kPOST success:^(id responseObject) {
        _doctorScheduleConfrimView.confirmButton.enabled = YES;
        BATDiseaseDescriptionModel *diseaseDescriptionModel = [BATDiseaseDescriptionModel mj_objectWithKeyValues:responseObject];
        
        if ([diseaseDescriptionModel.Data.ActionStatus isEqualToString:@"Success"]) {
            [self dismissProgress];

            if (diseaseDescriptionModel.Data.OrderState == -1 || diseaseDescriptionModel.Data.OrderState == 0) {
                
                BATConfirmPayViewController *confirmPayVC = [[BATConfirmPayViewController alloc] init];
                confirmPayVC.type = _type;
                confirmPayVC.orderNo = diseaseDescriptionModel.Data.OrderNO;
                confirmPayVC.momey = _momey;
                confirmPayVC.isTheNormalProcess = YES;
                [self.navigationController pushViewController:confirmPayVC animated:YES];
                
            } else {
                BATChatConsultController *chatCtl = [[BATChatConsultController alloc]init];
                chatCtl.cusultType = _type;
                chatCtl.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:chatCtl animated:YES];
            }
            
//            if ([_momey doubleValue] == 0 && _IsFreeClinicr) {
//          
//            } else {
//                //成功后进入一界面
//
//            }
        } else if ([diseaseDescriptionModel.Data.ActionStatus isEqualToString:@"Repeat"]) {
            
            [self showErrorWithText:@"不能重复预约，或请重新选择就诊人！"];
            
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                BATChatConsultController *chatCtl = [[BATChatConsultController alloc]init];
//                chatCtl.cusultType = _type;
//                chatCtl.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:chatCtl animated:YES];
//            });
            
        } else {
            [self showErrorWithText:diseaseDescriptionModel.Data.ErrorInfo];
        }
        
    } failure:^(NSError *error) {
        _doctorScheduleConfrimView.confirmButton.enabled = YES;
//        if (![error.userInfo[@"Data"] isKindOfClass:[NSNull class]]) {
//            if ([error.userInfo[@"Data"] isKindOfClass:[NSDictionary class]]) {
//                NSDictionary *dic = error.userInfo[@"Data"];
//                if ([dic[@"ErrorInfo"] isKindOfClass:[NSString class]] && ![dic[@"ErrorInfo"] isEqualToString:@""]) {
//                    [self showErrorWithText:error.userInfo[@"Data"][@"ErrorInfo"]];
//                }
//            }
//        }
        [self showErrorWithText:error.localizedDescription];

    }];
}

@end
