//
//  BATConsultationDoctorDetailViewController.m
//  HealthBAT_Pro
//
//  Created by KM on 16/9/62016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATConsultationDoctorDetailViewController.h"

#import "BATConsultationDoctorInfoView.h"
#import "BATConsultationDoctorSkillTableViewCell.h"
#import "BATSkillExpandTableViewCell.h"
#import "BATConsultationActionTableViewCell.h"
#import "BATConsultationExplainTableViewCell.h"
#import "BATDutyTableViewCell.h"
#import "BATConsulationDoctorInfoTableViewCell.h"

#import "BATConsultationDoctorDetailModel.h"
#import "BATHospitalRegisterDoctorModel.h"
#import "BATDutyModel.h"

#import "BATWriteSingleDiseaseViewController.h"
#import "BATRegisterHospitalRegisterViewController.h"

#import "UIScrollView+ScalableCover.h"

#import "BATDoctorScheduleViewController.h"


static  NSString * const SKILL_CELL = @"SkillCell";
static  NSString * const BRIEF_INTRODUCTION_CELL = @"BriefIntroductionCell";
static  NSString * const SKILL_EXPAND_CELL = @"SkillExpandCell";
static  NSString * const CONSULT_CELL = @"ConsultCell";
static  NSString * const EXPLAIN_CELL = @"ExplainCell";
static  NSString * const DUTY_CELL = @"DutyCell";

@interface BATConsultationDoctorDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *doctorDetailTableView;
@property (nonatomic,strong) BATConsultationDoctorInfoView *doctorInfoView;
@property (nonatomic,strong) BATConsultationDoctorDetailModel *KMDoctorModel;
@property (nonatomic,strong) BATHospitalRegisterDoctorModel *HRDoctorModel;
@property (nonatomic,strong) BATDutyModel *dutyModel;
@property (nonatomic,strong) NSString *beginTime;
@property (nonatomic,assign) BOOL isPopAction;

@property (nonatomic,copy) NSString *notice;

@property (nonatomic,strong) BATDefaultView *defaultView;

//@property (nonatomic,copy) NSString *explainString;
//@property (nonatomic,assign) float explainHeight;
//@property (nonatomic,assign) float skillHeight;
//@property (nonatomic,assign) float introHeight;
//@property (nonatomic,assign) BOOL isExpand;

@end

@implementation BATConsultationDoctorDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"医生详情";

    [self layoutPages];

//    self.isExpand = NO;

//    self.explainString = @"1、为珍惜您的咨询机会，请全部围绕病情进行沟通，避免无关内容。\n2、如果大夫48小时之内没有回复，或者超过48小时才回复，我们将全额退还您支付的费用。\n3、如果您对大夫回复不满意，可以申请向管理员求助，如果情况属实，我们会全额为您退款，让您的付出有所保障。";
//    self.explainHeight = [Tools calculateHeightWithText:self.explainString width:SCREEN_WIDTH-20 font:[UIFont systemFontOfSize:12] lineHeight:12] + 20;
    
    _notice = @"";

    if (self.isKMDoctor) {
        //获取咨询的医生的数据
        [self KMDoctorDetailRequest];
    }
    else {
        //获取160的医生数据
        [self doctorOf160DetailRequest];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   
}
-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
   // [TalkingData trackPageEnd:@"预约挂号"];
    
    if (self.isPopAction) {
        if (self.isSaveOperate) {
            [self saveOperate];
        }else {
            [self popAction];
        }
    }
}
//搜索游览接口
-(void)popAction {
    [BATUserPortrayTools saveUserBrowseRequestWithURL:@"/kmStatistical-sync/saveUserBrowse" moduleName:@"doctor_info" moduleId:self.doctorID beginTime:self.beginTime browsePage:self.pathName];
}
//模块点击接口
-(void)saveOperate {
    NSInteger modelID = 0;
    if ([self.pathName hasPrefix:@"首页"]) {
        modelID = 1;
    }else {
        modelID = 3;
    }
    [BATUserPortrayTools saveOperateModuleRequestWithURL:@"/kmStatistical-sync/saveOperateModule" pathName:self.pathName moduleId:modelID beginTime:self.beginTime];
}

#pragma mark - UITableViewDataSource UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    if (self.isKMDoctor) {

        return 2;
    }
    else {

        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (self.isKMDoctor) {
        if (section == 0) {
            return 2;
        }
        else if (section == 1) {
            return 3;
        }
        return 0;
    }
    else {

        if (section == 0) {

//            if (self.skillHeight <= 14*3+20+20) {
//                return 1;
//            }
//            return 2;
            return 1;
        }

        return self.dutyModel.Data.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (self.isKMDoctor) {

        //可咨询的医生
        if (indexPath.section == 0) {

            if (indexPath.row == 0) {
                //擅长
                BATConsulationDoctorInfoTableViewCell *skillCell = [tableView dequeueReusableCellWithIdentifier:BRIEF_INTRODUCTION_CELL forIndexPath:indexPath];
                if (self.KMDoctorModel) {
                    
                    [skillCell.skilLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.bottom.equalTo(skillCell.contentView.mas_bottom);
                    }];
                    
                    skillCell.titleLabel.text = @"擅长：";
                    skillCell.skilLabel.text = self.KMDoctorModel.Data.Specialty;
                }
                return skillCell;
            }
            else {
                
                //简介
                BATConsulationDoctorInfoTableViewCell *skillCell = [tableView dequeueReusableCellWithIdentifier:BRIEF_INTRODUCTION_CELL forIndexPath:indexPath];
                if (self.KMDoctorModel) {
                    [skillCell.skilLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.bottom.equalTo(skillCell.contentView.mas_bottom).offset(-10);
                    }];
                    skillCell.titleLabel.text = @"简介：";
                    skillCell.skilLabel.text = self.KMDoctorModel.Data.Intro;
                }
                return skillCell;
                
//                //展开
//                BATSkillExpandTableViewCell *skillExpandCell = [tableView dequeueReusableCellWithIdentifier:SKILL_EXPAND_CELL forIndexPath:indexPath];
//                return skillExpandCell;
            }
        }
        else if (indexPath.section == 1) {
            //咨询
            BATConsultationActionTableViewCell *actionCell = [tableView dequeueReusableCellWithIdentifier:CONSULT_CELL forIndexPath:indexPath];
            if (indexPath.row == 0) {

//                actionCell.leftImageView.image = [UIImage imageNamed:@"ic-free"];
//                actionCell.nameLabel.text = @"免费咨询";
//                actionCell.detailLabel.text = @"医生可能无法立即回答您的问题";
//                actionCell.priceLabel.text = @"";
//                actionCell.numberTitleLabel.text = @"";
//                actionCell.numberLabel.text = @"";
//
//                if (self.KMDoctorModel.Data.FreeConsultRecordID != -1) {
//                    //当前有正在进行中的语音咨询
//                    [actionCell.consulteButton setTitle:@"继续咨询" forState:UIControlStateNormal];
//                }
//                else {
//                    [actionCell.consulteButton setTitle:@"立即咨询" forState:UIControlStateNormal];
//                }
//
//                [actionCell setConsultBlock:^{
//                    DDLogError(@"免费咨询");
//                    //免费咨询
//                    if (!LOGIN_STATION) {
//                        PRESENT_LOGIN_VC;
//                        return;
//                    }
//
//                    if (self.KMDoctorModel.Data.FreeConsultRecordID != -1) {
//                        //当前有正在进行中的免费咨询
////                    KMChatViewController *kmChatVC = [[KMChatViewController alloc] init];
////                    kmChatVC.doctorInfoData = _doctorInfoData;
////                    kmChatVC.consultID = [NSString stringWithFormat:@"%ld",(long)self.doctor.FreeConsultRecordID];
////                    kmChatVC.doctiorPhotoPath = self.doctor.PhotoPath;
////                    kmChatVC.doctorName = self.doctor.UserName;
////                    kmChatVC.accountID = self.doctor.AccountID;
////                    [self.navigationController pushViewController:kmChatVC animated:YES];
//
//                        return ;
//                    }
//
//                    BATWriteSingleDiseaseViewController *writeSingleDiseaseVC = [[BATWriteSingleDiseaseViewController alloc]init];
//                    writeSingleDiseaseVC.type = kConsultTypeFree;
//                    writeSingleDiseaseVC.AccountID = [NSString stringWithFormat:@"%ld",(long)self.KMDoctorModel.Data.AccountID];
//                    writeSingleDiseaseVC.momey = @"0";
//                    writeSingleDiseaseVC.doctorName = self.KMDoctorModel.Data.UserName;
//                    writeSingleDiseaseVC.doctiorPhotoPath = self.KMDoctorModel.Data.PhotoPath;
//                    writeSingleDiseaseVC.hidesBottomBarWhenPushed = YES;
//                    [self.navigationController pushViewController:writeSingleDiseaseVC animated:YES];
//                }];
                
                for (ConsultationDoctorDetailDoctorservices *doctorService in self.KMDoctorModel.Data.DoctorServices) {
                    if (doctorService.ServiceType == 1) {
                        //图文咨询
                        
                        
                        
                        actionCell.leftImageView.image = [UIImage imageNamed:@"ic-Picture-consulting-1"];
                        actionCell.nameLabel.text = @"图文咨询";
                        actionCell.detailLabel.text = @"";
                        actionCell.priceLabel.text = [NSString stringWithFormat:@"￥%.2f元",doctorService.ServicePrice];
                        
//                        actionCell.numberTitleLabel.text = @"号源：";
//                        actionCell.numberLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)self.KMDoctorModel.Data.TodayWordConsultNum,(long)self.KMDoctorModel.Data.WordSourceNum];
                        
//                        if (self.KMDoctorModel.Data.WordConsultRecordID != -1) {
//                            //当前有正在进行中的语音咨询
//                            [actionCell.consulteButton setTitle:@"继续咨询" forState:UIControlStateNormal];
//                        }
//                        else {
//                            [actionCell.consulteButton setTitle:@"立即咨询" forState:UIControlStateNormal];
//                        }
                        
                        [actionCell.consulteButton setTitle:@"立即咨询" forState:UIControlStateNormal];
                        actionCell.consulteButton.enabled = CANCONSULT ? doctorService.ServiceSwitch : NO;
                        
                        [actionCell setConsultBlock:^{
                            self.isPopAction = NO;
                            DDLogError(@"图文咨询");
                            
                            if (!LOGIN_STATION) {
                                PRESENT_LOGIN_VC;
                                return;
                            }
                            
//                            if (self.KMDoctorModel.Data.WordConsultRecordID != -1) {
                                //当前有正在进行中的图文咨询
                                //                    KMChatViewController *kmChatVC = [[KMChatViewController alloc] init];
                                //                    kmChatVC.doctorInfoData = _doctorInfoData;
                                //                    kmChatVC.consultID = [NSString stringWithFormat:@"%ld",(long)self.doctor.FreeConsultRecordID];
                                //                    kmChatVC.doctiorPhotoPath = self.doctor.PhotoPath;
                                //                    kmChatVC.doctorName = self.doctor.UserName;
                                //                    kmChatVC.accountID = self.doctor.AccountID;
                                //                    [self.navigationController pushViewController:kmChatVC animated:YES];
//                                
//                                return ;
//                            }
                            
                            BATWriteSingleDiseaseViewController *writeSingleDiseaseVC = [[BATWriteSingleDiseaseViewController alloc]init];
                            writeSingleDiseaseVC.type = kConsultTypeTextAndImage;
                            writeSingleDiseaseVC.doctorID = self.KMDoctorModel.Data.DoctorID;
                            writeSingleDiseaseVC.momey = [NSString stringWithFormat:@"%.2f",doctorService.ServicePrice];
                            writeSingleDiseaseVC.IsFreeClinicr = NO;
//                            writeSingleDiseaseVC.AccountID = [NSString stringWithFormat:@"%ld",(long)self.KMDoctorModel.Data.AccountID];
//                            writeSingleDiseaseVC.momey = [NSString stringWithFormat:@"%.2f",self.KMDoctorModel.Data.WordConsultMoney];
//                            writeSingleDiseaseVC.doctorName = self.KMDoctorModel.Data.UserName;
//                            writeSingleDiseaseVC.doctiorPhotoPath = self.KMDoctorModel.Data.PhotoPath;
                            writeSingleDiseaseVC.hidesBottomBarWhenPushed = YES;
                            [self.navigationController pushViewController:writeSingleDiseaseVC animated:YES];
                        }];
                        
                        break;
                        
                    }
                }
                

            }
            else if (indexPath.row == 1) {
                
                for (ConsultationDoctorDetailDoctorservices *doctorService in self.KMDoctorModel.Data.DoctorServices) {
                    if (doctorService.ServiceType == 2) {
                        //语音咨询
                        
                        actionCell.leftImageView.image = [UIImage imageNamed:@"ic-Voice-1"];
                        actionCell.nameLabel.text = @"语音咨询";
                        actionCell.detailLabel.text = @"";
                        actionCell.priceLabel.text = [NSString stringWithFormat:@"￥%.2f元",doctorService.ServicePrice];
                      //  actionCell.numberTitleLabel.text = @"号源：";
                      //  actionCell.numberLabel.text = [NSString stringWithFormat:@"%ld",(long)self.KMDoctorModel.Data.ScheduleCount];
//                        actionCell.numberTitleLabel.text = @"号源：";
//                        actionCell.numberLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)self.KMDoctorModel.Data.TodayWordConsultNum,(long)self.KMDoctorModel.Data.WordSourceNum];
                        
//                        if (self.KMDoctorModel.Data.WordConsultRecordID != -1) {
//                            //当前有正在进行中的语音咨询
//                            [actionCell.consulteButton setTitle:@"继续咨询" forState:UIControlStateNormal];
//                        }
//                        else {
//                            [actionCell.consulteButton setTitle:@"立即咨询" forState:UIControlStateNormal];
//                        }
                        
                        [actionCell.consulteButton setTitle:@"立即咨询" forState:UIControlStateNormal];
                        actionCell.consulteButton.enabled = CANCONSULT ? ((doctorService.ServiceSwitch && self.KMDoctorModel.Data.ScheduleCount > 0) ? YES : NO) : NO;
                        
                        [actionCell setConsultBlock:^{
                             self.isPopAction = NO;
                            DDLogError(@"语音咨询");
                            
                            if (!LOGIN_STATION) {
                                PRESENT_LOGIN_VC;
                                return;
                            }
                            
//                            if (self.KMDoctorModel.Data.WordConsultRecordID != -1) {
                                //当前有正在进行中的图文咨询
                                //                    KMChatViewController *kmChatVC = [[KMChatViewController alloc] init];
                                //                    kmChatVC.doctorInfoData = _doctorInfoData;
                                //                    kmChatVC.consultID = [NSString stringWithFormat:@"%ld",(long)self.doctor.FreeConsultRecordID];
                                //                    kmChatVC.doctiorPhotoPath = self.doctor.PhotoPath;
                                //                    kmChatVC.doctorName = self.doctor.UserName;
                                //                    kmChatVC.accountID = self.doctor.AccountID;
                                //                    [self.navigationController pushViewController:kmChatVC animated:YES];
//                                
//                                return ;
//                            }
                            
//                            BATWriteSingleDiseaseViewController *writeSingleDiseaseVC = [[BATWriteSingleDiseaseViewController alloc]init];
//                            writeSingleDiseaseVC.type = kConsultTypeTextAndImage;
//                            writeSingleDiseaseVC.AccountID = [NSString stringWithFormat:@"%ld",(long)self.KMDoctorModel.Data.AccountID];
//                            writeSingleDiseaseVC.momey = [NSString stringWithFormat:@"%.2f",self.KMDoctorModel.Data.WordConsultMoney];
//                            writeSingleDiseaseVC.doctorName = self.KMDoctorModel.Data.UserName;
//                            writeSingleDiseaseVC.doctiorPhotoPath = self.KMDoctorModel.Data.PhotoPath;
//                            writeSingleDiseaseVC.hidesBottomBarWhenPushed = YES;
//                            [self.navigationController pushViewController:writeSingleDiseaseVC animated:YES];
                            
                            BATDoctorScheduleViewController *doctorScheduleVC = [[BATDoctorScheduleViewController alloc] init];
                            doctorScheduleVC.type = kConsultTypeAudio;
                            doctorScheduleVC.doctorId = self.KMDoctorModel.Data.DoctorID;
                            doctorScheduleVC.doctorName = self.KMDoctorModel.Data.DoctorName;
                            doctorScheduleVC.departmentName = self.KMDoctorModel.Data.DepartmentName;
                            doctorScheduleVC.momey =  [NSString stringWithFormat:@"%.2f",doctorService.ServicePrice];
                            doctorScheduleVC.pathName = [NSString stringWithFormat:@"%@-语音咨询",self.pathName];
                            doctorScheduleVC.IsFreeClinicr = self.KMDoctorModel.Data.IsFreeClinicr;
                            doctorScheduleVC.hidesBottomBarWhenPushed = YES;
                            [self.navigationController pushViewController:doctorScheduleVC animated:YES];
                        }];
                        
                        break;
                    }
                }

            }
            else if (indexPath.row == 2) {
                
                for (ConsultationDoctorDetailDoctorservices *doctorService in self.KMDoctorModel.Data.DoctorServices) {
                    if (doctorService.ServiceType == 3) {
                        //视频咨询
                        
                        actionCell.leftImageView.image = [UIImage imageNamed:@"ic-video-1"];
                        actionCell.nameLabel.text = @"视频咨询";
                        actionCell.detailLabel.text = @"";
                        actionCell.priceLabel.text = [NSString stringWithFormat:@"￥%.2f元",doctorService.ServicePrice];
                    //    actionCell.numberTitleLabel.text = @"号源：";
                   //     actionCell.numberLabel.text = [NSString stringWithFormat:@"%ld",(long)self.KMDoctorModel.Data.ScheduleCount];
                        
//                        if (self.KMDoctorModel.Data.VoiceConsultRecordID != -1) {
//                            //当前有正在进行中的语音咨询
//                            [actionCell.consulteButton setTitle:@"继续咨询" forState:UIControlStateNormal];
//                        }
//                        else {
//                            [actionCell.consulteButton setTitle:@"立即咨询" forState:UIControlStateNormal];
//                        }
                        
                        [actionCell.consulteButton setTitle:@"立即咨询" forState:UIControlStateNormal];
                        actionCell.consulteButton.enabled = CANCONSULT ? ((doctorService.ServiceSwitch && self.KMDoctorModel.Data.ScheduleCount > 0) ? YES : NO) : NO;
                        
                        [actionCell setConsultBlock:^{
                             self.isPopAction = NO;
                            DDLogError(@"视频咨询");
                            
                            if (!LOGIN_STATION) {
                                PRESENT_LOGIN_VC;
                                return;
                            }
                            
//                            if (self.KMDoctorModel.Data.VoiceConsultRecordID != -1) {
//                                //当前有正在进行中的语音咨询
//                                
//                                return ;
//                            }
//                            
//                            BATWriteSingleDiseaseViewController *writeSingleDiseaseVC = [[BATWriteSingleDiseaseViewController alloc]init];
//                            writeSingleDiseaseVC.type = kConsultTypeTextAndImage;
//                            writeSingleDiseaseVC.AccountID = [NSString stringWithFormat:@"%ld",(long)self.KMDoctorModel.Data.AccountID];
//                            writeSingleDiseaseVC.momey = [NSString stringWithFormat:@"%.2f",self.KMDoctorModel.Data.VoiceConsultMoney];
//                            writeSingleDiseaseVC.doctorName = self.KMDoctorModel.Data.UserName;
//                            writeSingleDiseaseVC.doctiorPhotoPath = self.KMDoctorModel.Data.PhotoPath;
//                            writeSingleDiseaseVC.hidesBottomBarWhenPushed = YES;
//                            [self.navigationController pushViewController:writeSingleDiseaseVC animated:YES];
                            
                            BATDoctorScheduleViewController *doctorScheduleVC = [[BATDoctorScheduleViewController alloc] init];
                            doctorScheduleVC.type = kConsultTypeVideo;
                            doctorScheduleVC.doctorId = self.KMDoctorModel.Data.DoctorID;
                            doctorScheduleVC.doctorName = self.KMDoctorModel.Data.DoctorName;
                            doctorScheduleVC.departmentName = self.KMDoctorModel.Data.DepartmentName;
                            doctorScheduleVC.momey =  [NSString stringWithFormat:@"%.2f",doctorService.ServicePrice];
                            doctorScheduleVC.pathName = [NSString stringWithFormat:@"%@-视频咨询",self.pathName];
                            doctorScheduleVC.IsFreeClinicr = self.KMDoctorModel.Data.IsFreeClinicr;
                            doctorScheduleVC.hidesBottomBarWhenPushed = YES;
                            [self.navigationController pushViewController:doctorScheduleVC animated:YES];
                            
                        }];
                        
                        break;
                    }
                }
            }
            
            return actionCell;
        }
//        else {
//            //说明
//            BATConsultationExplainTableViewCell *explainStringCell = [tableView dequeueReusableCellWithIdentifier:EXPLAIN_CELL forIndexPath:indexPath];
//            explainStringCell.explainLabel.text = self.explainString;
//            return explainStringCell;
//        }
        return nil;
    }
    else {
        //160医生，可挂号
        if (indexPath.section == 0) {

            if (indexPath.row == 0) {
//                //擅长
//                BATConsultationDoctorSkillTableViewCell *skillCell = [tableView dequeueReusableCellWithIdentifier:SKILL_CELL forIndexPath:indexPath];
//                if (self.HRDoctorModel) {
//                    NSMutableAttributedString *skillString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"擅长：%@",self.HRDoctorModel.Data.TREAT_LIMIT]];
//                    [skillString addAttribute:NSForegroundColorAttributeName
//                                        value:UIColorFromHEX(0x333333, 1)
//                                        range:NSMakeRange(0, 3)];
//                    [skillString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, skillString.length)];
//                    skillCell.skilLabel.attributedText = skillString;
//                }
//                return skillCell;
                
                //擅长
                BATConsulationDoctorInfoTableViewCell *skillCell = [tableView dequeueReusableCellWithIdentifier:BRIEF_INTRODUCTION_CELL forIndexPath:indexPath];
                if (self.HRDoctorModel) {
                    
                    skillCell.titleLabel.text = @"擅长：";
                    skillCell.skilLabel.text = [self.HRDoctorModel.Data.EXPERT isEqualToString:@""]?@"暂无":[self.HRDoctorModel.Data.EXPERT stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                }
                return skillCell;
                
            }
//            else {
//                //展开
//                BATSkillExpandTableViewCell *skillExpandCell = [tableView dequeueReusableCellWithIdentifier:SKILL_EXPAND_CELL forIndexPath:indexPath];
//                return skillExpandCell;
//
//            }
            return nil;
        }
        else {

            BATDutyTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:DUTY_CELL forIndexPath:indexPath];
            BATDutyData * duty = self.dutyModel.Data[indexPath.row];
            cell.timeLabel.text = [NSString stringWithFormat:@"%@%@",duty.TO_DATE,duty.TIME_TYPE_DESC];
            cell.countLabel.text = [NSString stringWithFormat:@"剩余%ld",(long)duty.LEFT_NUM];
            cell.priceLabel.text = [NSString stringWithFormat:@"¥%ld",(long)duty.GUAHAO_AMT];
            if (duty.LEFT_NUM > 0) {


                cell.registerButton.enabled = CANREGISTER ? YES : NO;
//                [cell.registerButton setTitle:@"去挂号" forState:UIControlStateNormal];
                [cell.registerButton setBackgroundImage:[UIImage imageNamed:@"btn-qgh"] forState:UIControlStateNormal];
                
//                if (cell.registerButton.enabled) {
//                    [cell.registerButton setBackgroundColor:BASE_COLOR];
//                } else {
//                    [cell.registerButton setBackgroundColor:[UIColor grayColor]];
//                }
                
            }
            else {
                cell.registerButton.enabled = NO;
//                [cell.registerButton setTitle:@"号源已满" forState:UIControlStateNormal];
                [cell.registerButton setBackgroundImage:[UIImage imageNamed:@"btn-hyym"] forState:UIControlStateNormal];
             //   [cell.registerButton setBackgroundColor:UIColorFromHEX(0xcdcdcd, 1)];
            }
            WEAK_SELF(self);
            [cell setHospitalRegister:^{
                //去挂号
                 self.isPopAction = NO;
                //登录判断
                if (!LOGIN_STATION) {
                    PRESENT_LOGIN_VC
                    return ;
                }

                STRONG_SELF(self);
                BATRegisterHospitalRegisterViewController * vc = [BATRegisterHospitalRegisterViewController new];
                vc.hospitalName = self.HRDoctorModel.Data.UNIT_NAME;
                vc.hospitalID = [self.HRDoctorModel.Data.UNIT_ID integerValue];
                vc.departmentName = self.HRDoctorModel.Data.DEP_NAME;
                vc.departmentID = [self.HRDoctorModel.Data.DEP_ID integerValue];
                vc.doctorName = self.HRDoctorModel.Data.DOCTOR_NAME;
                vc.doctorID = self.HRDoctorModel.Data.DOCTOR_ID;
                vc.ZCID = self.HRDoctorModel.Data.ZCID;
                vc.duty = duty;
                [self.navigationController pushViewController:vc animated:YES];
            }];
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (self.isKMDoctor) {
        //可咨询医生
        if (indexPath.section == 0) {
            
            if (indexPath.row == 0) {
                return UITableViewAutomaticDimension;
            } else if (indexPath.row == 1) {
                return UITableViewAutomaticDimension;
            }

//            if (indexPath.row == 0) {
//                if (self.isExpand) {
//
//                    return self.skillHeight + 20;
//                }
//                else {
//
//                    if (self.skillHeight <= 14*3+20+20) {
//
//                        return self.skillHeight+20;
//                    }
//                    return 14*3+20+20;
//                }
//            }
//            else {
//
//                return 30;
//            }
        }
        else if (indexPath.section == 1) {
            
            return 75;
        }
        
//        return self.explainHeight+20;
        return 0;
    }
    else {
        //160医生
        if (indexPath.section == 0) {

//            if (indexPath.row == 0) {
//                if (self.isExpand) {
//
//                    return self.skillHeight + 20;
//                }
//                else {
//
//                    if (self.skillHeight <= 14*3+20+20) {
//
//                        return self.skillHeight+20;
//                    }
//                    return 14*3+20+20;
//                }
//            }
//            else {
//
//                return 30;
//            }
            return UITableViewAutomaticDimension;

        }

        return 44;
    }

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

//    if (self.isKMDoctor) {
//        
        if (section == 1) {
    
            UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
            sectionHeaderView.backgroundColor = [UIColor whiteColor];
            
            UILabel *label = [UILabel labelWithFont:[UIFont systemFontOfSize:16] textColor:UIColorFromHEX(0x333333, 1) textAlignment:NSTextAlignmentLeft];
            label.frame = CGRectMake(15, 0, sectionHeaderView.frame.size.width - 30, 40);
            if (section == 1) {
                label.text = @"医生所提供服务";
            }
            //        else if (section == 2) {
            //            header.text = @"  详细说明";
            //        }
            [label setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0.5];
            
            [sectionHeaderView addSubview:label];
            
            return sectionHeaderView;
        }
//    }
//
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (!self.isKMDoctor && self.dutyModel.Data.count == 0) {
        if (section == 1) {
            
            UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 352)];
            sectionHeaderView.backgroundColor = [UIColor clearColor];
            
            UILabel *label = [UILabel labelWithFont:[UIFont systemFontOfSize:16] textColor:UIColorFromHEX(0x666666, 1) textAlignment:NSTextAlignmentLeft];
            label.frame = CGRectMake(15, 0, sectionHeaderView.frame.size.width - 30, 352);
            label.text = _notice;
            label.textAlignment = NSTextAlignmentCenter;
            
            [sectionHeaderView addSubview:label];
            
            return sectionHeaderView;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

//    if (self.isKMDoctor) {
//
//        if (section == 1) {
//            return 40;
//        }
////        if (section == 2) {
////            return 40;
////        }
//        return 0;
//    }
//    else {
//
//        return 0;
//    }
    
    if (section == 1) {
        return 40;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.KMDoctorModel) {

        if (section == 1) {
            return CGFLOAT_MIN;
        }
        return 10;
    }
    else {

        if (section == 1) {
            if (self.dutyModel.Data.count == 0) {
                return 300;
            }
            return CGFLOAT_MIN;
        }
        return 10;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

//    if (self.HRDoctorModel) {
//        if (indexPath.section == 0) {
//            
//            if (self.skillHeight < 14*3+20+20) {
//                
//                //简介很短，不需要展开
//                return;
//            }
//            
//            self.isExpand = !self.isExpand;
//            BATConsultationDoctorSkillTableViewCell *skillCell = (BATConsultationDoctorSkillTableViewCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//            BATSkillExpandTableViewCell *skillExpandCell = (BATSkillExpandTableViewCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
//            if (self.isExpand) {
//                skillCell.skilLabel.numberOfLines = 0;
//                skillExpandCell.expandButton.selected = YES;
//            }
//            else {
//                skillCell.skilLabel.numberOfLines = 3;
//                skillExpandCell.expandButton.selected = NO;
//            }
//            [tableView reloadData];
//        }
//    }
}

#pragma mark - action

- (void)collectionDoctor {

    if (self.isKMDoctor) {

//        if (self.KMDoctorModel.Data.IsCollectLink) {
//
//            //取消收藏
//            [self cancelCollectionRequest];
//        }
//        else {
//
//            //收藏
//            [self collectionRequest];
//        }
    }
    else {

        if (self.HRDoctorModel.Data.IsCollectLink) {

            //取消收藏
            [self cancelCollectionRequest];
        }
        else {

            //收藏
            [self collectionRequest];
        }
    }
}


#pragma mark - net
/**
 *  获取本地医生详情
 */
- (void)KMDoctorDetailRequest{

    [self showProgress];
    [HTTPTool requestWithURLString:@"/api/NetworkMedical/GetDoctorDetail" parameters:@{@"doctorId":self.doctorID} type:kGET success:^(id responseObject) {

        [self dismissProgress];
        self.KMDoctorModel = [BATConsultationDoctorDetailModel mj_objectWithKeyValues:responseObject];
        [self.doctorInfoView loadConsultationDoctorDetail:self.KMDoctorModel];
     //   [self.doctorDetailTableView addScalableCoverWithImage:[Tools imageFromColor:BASE_COLOR]];
        
        //        self.skillHeight = [Tools calculateHeightWithText:[NSString stringWithFormat:@"擅长：%@",self.KMDoctorModel.Data.Skilled] width:SCREEN_WIDTH-20 font:[UIFont systemFontOfSize:14] lineHeight:14] + 20;
        //        self.introHeight =  [Tools calculateHeightWithText:[NSString stringWithFormat:@"擅长：%@",self.HRDoctorModel.Data.TREAT_LIMIT] width:SCREEN_WIDTH-20 font:[UIFont systemFontOfSize:14] lineHeight:14]+20;
        
        
        [self.doctorDetailTableView reloadData];
    } failure:^(NSError *error) {
        [self dismissProgress];
        [self.defaultView showDefaultView];
    }];

//    [HTTPTool requestWithURLString:@"/api/Doctor/DoctorDetail" parameters:@{@"ID":@(self.doctorID)} type:kGET success:^(id responseObject) {
//
//        self.KMDoctorModel = [BATConsultationDoctorDetailModel mj_objectWithKeyValues:responseObject];
//        self.doctorDetailTableView.tableHeaderView = self.doctorInfoView;
//        [self.doctorDetailTableView addScalableCoverWithImage:[Tools imageFromColor:BASE_COLOR]];
//
////        self.skillHeight = [Tools calculateHeightWithText:[NSString stringWithFormat:@"擅长：%@",self.KMDoctorModel.Data.Skilled] width:SCREEN_WIDTH-20 font:[UIFont systemFontOfSize:14] lineHeight:14] + 20;
////        self.introHeight =  [Tools calculateHeightWithText:[NSString stringWithFormat:@"擅长：%@",self.HRDoctorModel.Data.TREAT_LIMIT] width:SCREEN_WIDTH-20 font:[UIFont systemFontOfSize:14] lineHeight:14]+20;
//
//
//        [self.doctorDetailTableView reloadData];
//    } failure:^(NSError *error) {
//
//    }];
}

/**
 *  获取160的医生详情
 */
- (void)doctorOf160DetailRequest {

    [HTTPTool requestWithURLString:@"/api/DoctorExternal/AppointmentGetDotorDetail" parameters:@{@"ID":self.doctorID} type:kGET success:^(id responseObject) {
        [self dismissProgress];
        self.HRDoctorModel = [BATHospitalRegisterDoctorModel mj_objectWithKeyValues:responseObject];
        [self.doctorInfoView loadHospitalRegisterDoctor:self.HRDoctorModel];
     //   [self.doctorDetailTableView addScalableCoverWithImage:[Tools imageFromColor:BASE_COLOR]];

//        self.skillHeight = [Tools calculateHeightWithText:[NSString stringWithFormat:@"擅长：%@",self.HRDoctorModel.Data.TREAT_LIMIT] width:SCREEN_WIDTH-20 font:[UIFont systemFontOfSize:14] lineHeight:14]+20;
//        self.introHeight =  [Tools calculateHeightWithText:[NSString stringWithFormat:@"擅长：%@",self.HRDoctorModel.Data.TREAT_LIMIT] width:SCREEN_WIDTH-20 font:[UIFont systemFontOfSize:14] lineHeight:14]+20;

        [self doctorScheduleRequest];

    } failure:^(NSError *error) {
        [self dismissProgress];
       [self.defaultView showDefaultView];
    }];
}

- (void)doctorScheduleRequest {

    [self showProgress];
    NSDictionary *parammeters = @{
                                  @"uid":self.HRDoctorModel.Data.UNIT_ID,
                                  @"depid":self.HRDoctorModel.Data.DEP_ID,
                                  @"docid":@(self.HRDoctorModel.Data.DOCTOR_ID),
                                  @"begin_date":@"",
                                  @"end_date":@"",
                                  @"date":@""
                                  };
    [HTTPTool requestWithURLString:@"/api/AppointmentDoctor/GetSchedulingList" parameters:parammeters type:kGET success:^(id responseObject) {
        [self dismissProgress];
        self.dutyModel = [BATDutyModel mj_objectWithKeyValues:responseObject];
        
        if (self.dutyModel.Data.count == 0) {
            _notice = @"您好，该医生暂无排班信息";
        }
        
        [self.doctorDetailTableView reloadData];
    } failure:^(NSError *error) {
        [self dismissProgress];
        [self.defaultView showDefaultView];
    }];
}

- (void)cancelCollectionRequest {

//    NSString *urlString = [NSString stringWithFormat:@"/api/CollectLink/UnfavoriteDoctor?doctorId=%ld",(long)(self.isKMDoctor?self.KMDoctorModel.Data.AccountID:self.HRDoctorModel.Data.DOCTOR_ID)];
//
//    [HTTPTool requestWithURLString:urlString parameters:nil type:kPOST success:^(id responseObject) {
//
//        [self showSuccessWithText:@"取消成功"];
//
//        self.doctorInfoView.collectionButton.selected = NO;
//        if (self.isKMDoctor) {
//            self.KMDoctorModel.Data.IsCollectLink = NO;
//        }
//        else {
//            self.HRDoctorModel.Data.IsCollectLink = NO;
//        }
//    } failure:^(NSError *error) {
//
//    }];
}

#pragma maek - 添加医生收藏
- (void)collectionRequest {

//    NSString *urlString = [NSString stringWithFormat:@"/api/CollectLink/AddCollectLink?doctorId=%ld&hospitalId=&newsId=&DynamicId=&Type=%@" ,(long)(self.isKMDoctor?self.KMDoctorModel.Data.AccountID:self.HRDoctorModel.Data.DOCTOR_ID),self.isKMDoctor?@(0):@(1)];
//
//
//    [HTTPTool requestWithURLString:urlString parameters:nil type:kPOST success:^(id responseObject) {
//
//        [self showSuccessWithText:@"收藏成功"];
//
//        self.doctorInfoView.collectionButton.selected = YES;
//        if (self.isKMDoctor) {
//            self.KMDoctorModel.Data.IsCollectLink = YES;
//        }
//        else {
//            self.HRDoctorModel.Data.IsCollectLink = YES;
//        }
//
//    } failure:^(NSError *error) {
//
//    }];
}

#pragma mark - layout
- (void)layoutPages {
    self.isPopAction = YES;
    self.beginTime = [Tools getCurrentDateStringByFormat:@"yyyy-MM-dd HH:mm:ss"];
    [self.view addSubview:self.doctorDetailTableView];
    [self.doctorDetailTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:self.defaultView];
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - getter
- (BATConsultationDoctorInfoView *)doctorInfoView {

    if (!_doctorInfoView) {

//        _doctorInfoView = [[BATConsultationDoctorInfoView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 115) docotrDetailModel:self.KMDoctorModel or:self.HRDoctorModel];
        _doctorInfoView = [[BATConsultationDoctorInfoView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 115)];
        WEAK_SELF(self);
        [_doctorInfoView setCollectionDoctorBlock:^{
            STRONG_SELF(self);
            [self collectionDoctor];
        }];
    }
    return _doctorInfoView;
}

- (UITableView *)doctorDetailTableView {

    if (!_doctorDetailTableView) {
        _doctorDetailTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _doctorDetailTableView.delegate = self;
        _doctorDetailTableView.dataSource = self;
        _doctorDetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _doctorDetailTableView.estimatedRowHeight = 100;
        _doctorDetailTableView.backgroundColor = UIColorFromHEX(0xf1f1f1, 1);
        
        [_doctorDetailTableView registerClass:[BATConsultationDoctorSkillTableViewCell class] forCellReuseIdentifier:SKILL_CELL];
//        [_doctorDetailTableView registerClass:[BATSkillExpandTableViewCell class] forCellReuseIdentifier:SKILL_EXPAND_CELL];
        [_doctorDetailTableView registerClass:[BATConsulationDoctorInfoTableViewCell class] forCellReuseIdentifier:BRIEF_INTRODUCTION_CELL];
        [_doctorDetailTableView registerClass:[BATConsultationActionTableViewCell class] forCellReuseIdentifier:CONSULT_CELL];
        [_doctorDetailTableView registerClass:[BATConsultationExplainTableViewCell class] forCellReuseIdentifier:EXPLAIN_CELL];
        [_doctorDetailTableView registerClass:[BATDutyTableViewCell class] forCellReuseIdentifier:DUTY_CELL];
        
        _doctorDetailTableView.tableHeaderView = self.doctorInfoView;


    }
    return _doctorDetailTableView;
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
            if (self.isKMDoctor) {
                //获取咨询的医生的数据
                [self KMDoctorDetailRequest];
            }
            else {
                //获取160的医生数据
                [self doctorOf160DetailRequest];
            }
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
