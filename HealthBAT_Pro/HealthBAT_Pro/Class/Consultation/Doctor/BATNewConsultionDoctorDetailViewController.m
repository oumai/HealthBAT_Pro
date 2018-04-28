//
//  BATNewConsultionDoctorDetailViewController.m
//  HealthBAT_Pro
//
//  Created by four on 2017/5/23.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATNewConsultionDoctorDetailViewController.h"

//model
#import "BATConsultationDoctorDetailModel.h"

//cell
#import "BATDoctorOfficeHeadCell.h"
#import "BATDoctorServiceCell.h"
#import "BATDoctorOfficeIntroduceCell.h"

//vc
#import "BATWriteSingleDiseaseViewController.h"
#import "BATDoctorScheduleViewController.h"
#import "BATDoctorScheduleViewController.h"

//view
#import "BATDoctorServiceBottomView.h"

@interface BATNewConsultionDoctorDetailViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,strong) UITableView *doctorDetailTableView;

@property (nonatomic,strong) BATDoctorServiceBottomView *bottomView;

@property (nonatomic,strong) BATDefaultView *defaultView;

@property (nonatomic,strong) BATConsultationDoctorDetailModel *KMDoctorModel;

@property (nonatomic,assign) ConsultType type;

@end

@implementation BATNewConsultionDoctorDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view

    self.title = @"医生详情";
    
    [self pageLayout];
    
    [self KMDoctorDetailRequest];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0: {
            if (indexPath.row == 0) {
                BATDoctorOfficeHeadCell *headCell = [tableView dequeueReusableCellWithIdentifier:@"BATDoctorOfficeHeadCell"];
                [headCell.headImage sd_setImageWithURL:[NSURL URLWithString:self.KMDoctorModel.Data.User.PhotoUrl] placeholderImage:[UIImage imageNamed:@"医生"]];
                headCell.nameLb.text = self.KMDoctorModel ? [NSString stringWithFormat:@"%@ [%@]",self.KMDoctorModel.Data.DoctorName,self.KMDoctorModel.Data.Title] : @"姓名 职称";
                headCell.hosptialLb.text = self.KMDoctorModel ? [NSString stringWithFormat:@"%@  %@",self.KMDoctorModel.Data.HospitalName,self.KMDoctorModel.Data.DepartmentName] : @"医院 科室";
                [headCell setSelectionStyle:UITableViewCellSelectionStyleNone];
                return headCell;
                
            }
            else if(indexPath.row == 1){
                
                BATDoctorServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATDoctorServiceCell"];
                
                for (ConsultationDoctorDetailDoctorservices *doctorService in self.KMDoctorModel.Data.DoctorServices) {
                
                    if (doctorService.ServiceType == 1) {
                        
                        if (CANCONSULT ? doctorService.ServiceSwitch : NO) {
                            [cell.chatImage setImage:[UIImage imageNamed:@"ic-Picture-consulting"]];
                            [cell.chatContentLb setTitle:[NSString stringWithFormat:@"%.2f/次",doctorService.ServicePrice] forState:UIControlStateNormal] ;
                            
                        }else {
                            [cell.chatImage setImage:[UIImage imageNamed:@"ic-Picture-consulting-s"]];
                            [cell.chatContentLb setTitle:@"暂未开通" forState:UIControlStateNormal] ;
                        }

                    }
                    else if (doctorService.ServiceType == 2) {
                        
                        if (CANCONSULT ? ((doctorService.ServiceSwitch && self.KMDoctorModel.Data.ScheduleCount > 0) ? YES : NO) : NO) {
                            [cell.audioimage setImage:[UIImage imageNamed:@"ic-Voice"]];
                            [cell.AudioContentLb setTitle:[NSString stringWithFormat:@"%.2f/次",doctorService.ServicePrice] forState:UIControlStateNormal];
                            
                        }else {
                            [cell.audioimage setImage:[UIImage imageNamed:@"ic-Voice-s"]];
                            [cell.AudioContentLb setTitle:@"暂未开通" forState:UIControlStateNormal] ;
                            
                        }
                        
                    }
                    else if (doctorService.ServiceType == 3){
                        
                        if (CANCONSULT ? ((doctorService.ServiceSwitch && self.KMDoctorModel.Data.ScheduleCount > 0) ? YES : NO) : NO) {
                            [cell.videoImage setImage:[UIImage imageNamed:@"ic-video"]];
                            [cell.ViedoContentLb setTitle:[NSString stringWithFormat:@"%.2f/次",doctorService.ServicePrice] forState:UIControlStateNormal];
                            
                        }else {
                            [cell.videoImage setImage:[UIImage imageNamed:@"ic-video-s"]];
                            [cell.ViedoContentLb setTitle:@"暂未开通" forState:UIControlStateNormal] ;
                            
                        }
                    }
                }
                
                cell.SeverTapBlock = ^(NSInteger tag) {
                    
                    switch (tag) {
                        case 1230: {
                            
                            self.type = kConsultTypeTextAndImage;
                            for (ConsultationDoctorDetailDoctorservices *doctorService in self.KMDoctorModel.Data.DoctorServices) {
                                
                                if (doctorService.ServiceType == 1) {

                                    if (CANCONSULT ? doctorService.ServiceSwitch : NO) {
                                        [self.bottomView.severStartBtn setTitle:[NSString stringWithFormat:@"图文咨询(%.2f元/次)",doctorService.ServicePrice]  forState:UIControlStateNormal];
                                    }else {
                                        [self.bottomView.severStartBtn setTitle:@"暂未开通"  forState:UIControlStateNormal];
                                    }
                                    
                                    
                                }
                                
                            }
                        }
                            break;
                        case 1231: {
                             self.type = kConsultTypeAudio;
                            for (ConsultationDoctorDetailDoctorservices *doctorService in self.KMDoctorModel.Data.DoctorServices) {
                                
                                if (doctorService.ServiceType == 2) {
                                    
                                    
                                    if (CANCONSULT ? ((doctorService.ServiceSwitch && self.KMDoctorModel.Data.ScheduleCount > 0) ? YES : NO) : NO) {
                                        [self.bottomView.severStartBtn setTitle:[NSString stringWithFormat:@"语音咨询(%.2f/次)",doctorService.ServicePrice]  forState:UIControlStateNormal];
                                    }else {
                                        [self.bottomView.severStartBtn setTitle:@"暂未开通"  forState:UIControlStateNormal];
                                    }
                                    
                                   
                                }

                            }
                        }
                            break;
                        case 1232: {
                            self.type = kConsultTypeVideo;
                            for (ConsultationDoctorDetailDoctorservices *doctorService in self.KMDoctorModel.Data.DoctorServices) {
                                
                                if (doctorService.ServiceType == 3) {
                                    
                                    if (CANCONSULT ? ((doctorService.ServiceSwitch && self.KMDoctorModel.Data.ScheduleCount > 0) ? YES : NO) : NO) {
                                        [self.bottomView.severStartBtn setTitle:[NSString stringWithFormat:@"视频咨询(%.2f/次)",doctorService.ServicePrice]  forState:UIControlStateNormal];
                                    }else {
                                        [self.bottomView.severStartBtn setTitle:@"暂未开通"  forState:UIControlStateNormal];
                                    }
                                    
                                    
                                }
                            }
                            break;
                    }
                        default:
                            break;
                    }
                };
                
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                return cell;
            }
        }
            break;
        case 1: {
            if(indexPath.row == 0){
                BATDoctorOfficeIntroduceCell *contentCell = [tableView dequeueReusableCellWithIdentifier:@"BATDoctorOfficeIntroduceCell"];
                contentCell.IntroduceLb.text = @"擅长";
                contentCell.IntroduceContent.text= self.KMDoctorModel.Data.Specialty;
                [contentCell setSelectionStyle:UITableViewCellSelectionStyleNone];
                return contentCell;
            }else {
                BATDoctorOfficeIntroduceCell *contentCell = [tableView dequeueReusableCellWithIdentifier:@"BATDoctorOfficeIntroduceCell"];
                contentCell.IntroduceLb.text = @"简介";
                contentCell.IntroduceContent.text = self.KMDoctorModel.Data.Intro;
                [contentCell setSelectionStyle:UITableViewCellSelectionStyleNone];
                return contentCell;
            }
        }
            break;
        default:
            break;
    }
    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0 && indexPath.row == 1) {
        return 132;
    }else{
        return UITableViewAutomaticDimension;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {
        return 10;
    }else{
        return 0;
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
        
        self.type = kConsultTypeTextAndImage;
        
        for (ConsultationDoctorDetailDoctorservices *doctorService in self.KMDoctorModel.Data.DoctorServices) {
            if (doctorService.ServiceType == 1) {
            
                if (CANCONSULT ? doctorService.ServiceSwitch : NO) {
                    [self.bottomView.severStartBtn setTitle:[NSString stringWithFormat:@"图文咨询(%.2f元/次)",doctorService.ServicePrice]  forState:UIControlStateNormal];
                }else {
                    [self.bottomView.severStartBtn setTitle:@"暂未开通" forState:UIControlStateNormal];
                }
            }
            
        }

        
        [self.doctorDetailTableView reloadData];
    } failure:^(NSError *error) {
        [self dismissProgress];
        [self.defaultView showDefaultView];
    }];
}


#pragma mark - pagelayuts
- (void)pageLayout {
    
    WEAK_SELF(self);
    
    [self.view addSubview:self.doctorDetailTableView];
    [self.doctorDetailTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.right.top.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(-50);
    }];
    
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.right.bottom.equalTo(self.view).offset(0);
        make.height.mas_equalTo(50);
    }];
    
    [self.view addSubview:self.defaultView];
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}

#pragma mark - set&&get
- (UITableView *)doctorDetailTableView {
    
    if (!_doctorDetailTableView) {
        _doctorDetailTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _doctorDetailTableView.delegate = self;
        _doctorDetailTableView.dataSource = self;
        _doctorDetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _doctorDetailTableView.estimatedRowHeight = 100;
        _doctorDetailTableView.backgroundColor = UIColorFromHEX(0xf1f1f1, 1);
        
        [_doctorDetailTableView registerNib:[UINib nibWithNibName:@"BATDoctorOfficeHeadCell" bundle:nil] forCellReuseIdentifier:@"BATDoctorOfficeHeadCell"];
        [_doctorDetailTableView registerClass:[BATDoctorServiceCell class] forCellReuseIdentifier:@"BATDoctorServiceCell"];
        [_doctorDetailTableView registerNib:[UINib nibWithNibName:@"BATDoctorOfficeIntroduceCell" bundle:nil] forCellReuseIdentifier:@"BATDoctorOfficeIntroduceCell"];
    }
    return _doctorDetailTableView;
}


- (BATDoctorServiceBottomView *)bottomView {
    
    if (!_bottomView) {
        _bottomView = [[BATDoctorServiceBottomView alloc]init];
        WEAK_SELF(self);
        _bottomView.startSeverTap = ^() {
            
            STRONG_SELF(self);
            switch (self.type) {
                    
                case kConsultTypeTextAndImage: {
                    
                    if (!LOGIN_STATION) {
                        PRESENT_LOGIN_VC;
                        return;
                    }
                    
                    if (!self.KMDoctorModel) {
                        return;
                    }
                    
                    for (ConsultationDoctorDetailDoctorservices *doctorService in self.KMDoctorModel.Data.DoctorServices) {
                        
                        if (doctorService.ServiceType == 1) {
                            
                            
                            if (CANCONSULT ? doctorService.ServiceSwitch : NO) {
                                BATWriteSingleDiseaseViewController *writeSingleDiseaseVC = [[BATWriteSingleDiseaseViewController alloc]init];
                                writeSingleDiseaseVC.type = kConsultTypeTextAndImage;
                                writeSingleDiseaseVC.doctorID = self.KMDoctorModel.Data.DoctorID;
                                writeSingleDiseaseVC.momey = [NSString stringWithFormat:@"%.2f",doctorService.ServicePrice];
                                writeSingleDiseaseVC.IsFreeClinicr = NO;
                                
                                writeSingleDiseaseVC.hidesBottomBarWhenPushed = YES;
                                [self.navigationController pushViewController:writeSingleDiseaseVC animated:YES];
                                
                                break;
                            }
                        }
                        
                    }

                    
                }
                    break;
                case kConsultTypeAudio:{
                    
                    if (!self.KMDoctorModel) {
                        return;
                    }
                    
                    for (ConsultationDoctorDetailDoctorservices *doctorService in self.KMDoctorModel.Data.DoctorServices) {
                        
                        if (doctorService.ServiceType == 2) {
                            
                            if (CANCONSULT ? ((doctorService.ServiceSwitch && self.KMDoctorModel.Data.ScheduleCount > 0) ? YES : NO) : NO) {
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
                                break;
                            }
                        }
                        
                    }

                }
                    break;
                case kConsultTypeVideo:{
                    
                    if (!self.KMDoctorModel) {
                        return;
                    }
                    
                    for (ConsultationDoctorDetailDoctorservices *doctorService in self.KMDoctorModel.Data.DoctorServices) {
                        
                        if (doctorService.ServiceType == 3) {
                            
                            if (CANCONSULT ? ((doctorService.ServiceSwitch && self.KMDoctorModel.Data.ScheduleCount > 0) ? YES : NO) : NO) {
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
                                break;
                            }
                        }
                    }
                }
                    break;
                default:
                    break;
            }
        };
    }
    return _bottomView;
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
            //获取咨询的医生的数据
            [self KMDoctorDetailRequest];
        }];
    }
    return _defaultView;
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

@end
