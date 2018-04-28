//
//  BATDoctorStudioVideoListViewController.m
//  HealthBAT_Pro
//
//  Created by KM on 17/4/122017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDoctorStudioVideoListViewController.h"

#import "BATDoctorStudioVideoListCell.h"
#import "BATDoctorStudioVideoDisableTableViewCell.h"

#import "BATDoctorStudioVideoListModel.h"

#import "BATNewPayViewController.h"
#import "BATCallViewController.h"
#import "BATDoctorStudioOrderDetailViewController.h"
#import "UIImage+Tool.h"
static  NSString * const VIDEO_CELL = @"BATDoctorStudioVideoListCell";
static  NSString * const VIDEO_DISABLE_CELL = @"BATDoctorStudioVideoDisableTableViewCell";


@interface BATDoctorStudioVideoListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *videoListTableView;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) BOOL isClick;

@property (nonatomic,strong) BATDefaultView             *defaultView;

@end

@implementation BATDoctorStudioVideoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self pagesLayout];
    self.dataArray = [NSMutableArray array];
    [self.videoListTableView.mj_header beginRefreshing];
    
    self.isClick = YES;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DoctorStudioVideoOrderData *data = self.dataArray[indexPath.section];
    
    switch (data.ConsultStatus) {
        case BATDoctorStudioConsultStatus_Consulting:
        {
            BATDoctorStudioVideoListCell *listCell = [tableView dequeueReusableCellWithIdentifier:VIDEO_CELL];
            listCell.nameLable.text = [NSString stringWithFormat:@"服务医生：%@",data.DoctorName];
            listCell.serviceTypeLabel.text = @"服务类型：语音咨询";
            NSDate *ScheduleDate = [Tools dateWithDateString:data.ScheduleDate Format:@"yyyy-MM-dd HH:mm:ss"];
            listCell.serviceTimeLabel.text = [NSString stringWithFormat:@"服务时间：%@ %@-%@",[Tools getDateStringWithDate:ScheduleDate Format:@"yyyy-MM-dd"],data.StartTime,data.EndTime];
            
            listCell.statusImageView.image = [UIImage imageNamed:@"wz-zxz"];
            [listCell.consulationBtn setBackgroundImage:[UIImage imageNamed:@"进入诊室"] forState:UIControlStateNormal];
            [listCell setConsultationBlock:^{
                
                if (self.isClick == NO) {
                    //已经点过了，不可以重复点击
                    return ;
                }
                
                self.isClick = NO;
                
                [self CanEnterRoomRequestWithOrderNo:data.OrderNo complete:^(BOOL canEnter) {
                    self.isClick = YES;
                    
                    if (canEnter == YES) {
                        //进入诊室
                        BATCallViewController *callRoomVC = [[BATCallViewController alloc] init];
                        callRoomVC.doctorName = data.DoctorName;
                        callRoomVC.doctorPic = data.DoctorPic;
                        callRoomVC.doctorTitle = data.DoctorTitle;
                        callRoomVC.hospitalName = data.HospitalName;
                        callRoomVC.departmentName = data.DepartmentName;
                        
                        callRoomVC.roomID = data.RoomID;
                        callRoomVC.doctorID = data.DoctorID;
                        callRoomVC.callState = BATCallState_Call;//呼叫状态
                        callRoomVC.orderNo = data.OrderNo;
                        [self presentViewController:callRoomVC animated:YES completion:nil];
                    }
                    else {
                        [self showErrorWithText:@"请在预约时间段内进入诊室"];
                    }
                }];
            }];
            
            return listCell;
        }
            break;
        case BATDoctorStudioConsultStatus_ConsultCompletion:
        {
    
            BATDoctorStudioVideoDisableTableViewCell *disableCell = [tableView dequeueReusableCellWithIdentifier:VIDEO_DISABLE_CELL];
            
            disableCell.nameLable.text = [NSString stringWithFormat:@"服务医生：%@",data.DoctorName];
            disableCell.serviceTypeLabel.text = @"服务类型：语音咨询";
            NSDate *ScheduleDate = [Tools dateWithDateString:data.ScheduleDate Format:@"yyyy-MM-dd HH:mm:ss"];
            disableCell.serviceTimeLabel.text = [NSString stringWithFormat:@"服务时间：%@ %@-%@",[Tools getDateStringWithDate:ScheduleDate Format:@"yyyy-MM-dd"],data.StartTime,data.EndTime];
            
            disableCell.statusImageView.image = [UIImage imageNamed:@"wz-qxwc"];

            return disableCell;
        }
            break;
        case BATDoctorStudioConsultStatus_WaitingPay:
        {
            BATDoctorStudioVideoListCell *listCell = [tableView dequeueReusableCellWithIdentifier:VIDEO_CELL];
            listCell.nameLable.text = [NSString stringWithFormat:@"服务医生：%@",data.DoctorName];
            listCell.serviceTypeLabel.text = @"服务类型：语音咨询";
            NSDate *ScheduleDate = [Tools dateWithDateString:data.ScheduleDate Format:@"yyyy-MM-dd HH:mm:ss"];
            listCell.serviceTimeLabel.text = [NSString stringWithFormat:@"服务时间：%@ %@-%@",[Tools getDateStringWithDate:ScheduleDate Format:@"yyyy-MM-dd"],data.StartTime,data.EndTime];
            
            listCell.statusImageView.image = [UIImage imageNamed:@"wz-dzf"];
            [listCell.consulationBtn setBackgroundImage:[UIImage imageNamed:@"支付"] forState:UIControlStateNormal];
            listCell.consulationBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
            [listCell.consulationBtn setTitle:@"支付" forState:UIControlStateHighlighted];
            [listCell.consulationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [listCell.consulationBtn setBackgroundImage:[UIImage createImageWithColor:UIColorFromHEX(0x2accbe, 1)] forState:UIControlStateHighlighted];
            [listCell setConsultationBlock:^{
                //去支付
                BATNewPayViewController *payVC = [[BATNewPayViewController alloc] init];
                
                //音视频修改订单所传的参数
                payVC.ScheduleId = data.ScheduleId;
                NSDate *ScheduleDate = [Tools dateWithDateString:data.ScheduleDate Format:@"yyyy-MM-dd HH:mm:ss"];
                payVC.TimeStr = [NSString stringWithFormat:@"%@ %@-%@",[Tools getDateStringWithDate:ScheduleDate Format:@"MM月dd日"],data.StartTime,data.EndTime];
                
                //正常参数
                payVC.type = data.OrderType;
                payVC.momey = data.OrderMoney;
                payVC.orderNo = data.OrderNo;
                payVC.doctorName = data.DoctorName;
                payVC.doctorPhotoPath = data.DoctorPic;
                payVC.doctorID = data.DoctorID;
                payVC.dept = data.DepartmentName;
                payVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:payVC animated:YES];
            }];
            
            return listCell;
        }
            break;
        case BATDoctorStudioConsultStatus_NoAnswer:
        {
            BATDoctorStudioVideoListCell *listCell = [tableView dequeueReusableCellWithIdentifier:VIDEO_CELL];
            listCell.nameLable.text = [NSString stringWithFormat:@"服务医生：%@",data.DoctorName];
            listCell.serviceTypeLabel.text = @"服务类型：语音咨询";
            NSDate *ScheduleDate = [Tools dateWithDateString:data.ScheduleDate Format:@"yyyy-MM-dd HH:mm:ss"];
            listCell.serviceTimeLabel.text = [NSString stringWithFormat:@"服务时间：%@ %@-%@",[Tools getDateStringWithDate:ScheduleDate Format:@"yyyy-MM-dd"],data.StartTime,data.EndTime];
            
            listCell.statusImageView.image = [UIImage imageNamed:@"wz-whf"];
            [listCell.consulationBtn setBackgroundImage:[UIImage imageNamed:@"进入诊室"] forState:UIControlStateNormal];
            
            [listCell setConsultationBlock:^{
                
                if (self.isClick == NO) {
                    //已经点过了，不可以重复点击
                    return ;
                }
                
                self.isClick = NO;
                
                [self CanEnterRoomRequestWithOrderNo:data.OrderNo complete:^(BOOL canEnter) {
                    self.isClick = YES;
                    
                    if (canEnter == YES) {
                        //进入诊室
                        BATCallViewController *callRoomVC = [[BATCallViewController alloc] init];
                        callRoomVC.doctorName = data.DoctorName;
                        callRoomVC.doctorPic = data.DoctorPic;
                        callRoomVC.doctorTitle = data.DoctorTitle;
                        callRoomVC.hospitalName = data.HospitalName;
                        callRoomVC.departmentName = data.DepartmentName;
                        
                        callRoomVC.roomID = data.RoomID;
                        callRoomVC.doctorID = data.DoctorID;
                        callRoomVC.callState = BATCallState_Call;//呼叫状态
                        callRoomVC.orderNo = data.OrderNo;
                        [self presentViewController:callRoomVC animated:YES completion:nil];
                    }
                    else {
                        [self showErrorWithText:@"请在预约时间段内进入诊室"];
                    }
                }];
            }];
            
            return listCell;
        }
            break;
        case BATDoctorStudioConsultStatus_Cancel:
        {
            BATDoctorStudioVideoDisableTableViewCell *disableCell = [tableView dequeueReusableCellWithIdentifier:VIDEO_DISABLE_CELL];
            
            disableCell.nameLable.text = [NSString stringWithFormat:@"服务医生：%@",data.DoctorName];
            disableCell.serviceTypeLabel.text = @"服务类型：语音咨询";
            NSDate *ScheduleDate = [Tools dateWithDateString:data.ScheduleDate Format:@"yyyy-MM-dd HH:mm:ss"];
            disableCell.serviceTimeLabel.text = [NSString stringWithFormat:@"服务时间：%@ %@-%@",[Tools getDateStringWithDate:ScheduleDate Format:@"yyyy-MM-dd"],data.StartTime,data.EndTime];
            
            disableCell.statusImageView.image = [UIImage imageNamed:@"wz-qxqx"];

            return disableCell;
            
        }
            break;
        case BATDoctorStudioConsultStatus_ConsultEnd:
        {
            BATDoctorStudioVideoDisableTableViewCell *disableCell = [tableView dequeueReusableCellWithIdentifier:VIDEO_DISABLE_CELL];
            
            disableCell.nameLable.text = [NSString stringWithFormat:@"服务医生：%@",data.DoctorName];
            disableCell.serviceTypeLabel.text = @"服务类型：语音咨询";
            NSDate *ScheduleDate = [Tools dateWithDateString:data.ScheduleDate Format:@"yyyy-MM-dd HH:mm:ss"];
            disableCell.serviceTimeLabel.text = [NSString stringWithFormat:@"服务时间：%@ %@-%@",[Tools getDateStringWithDate:ScheduleDate Format:@"yyyy-MM-dd"],data.StartTime,data.EndTime];
            
            disableCell.statusImageView.image = [UIImage imageNamed:@"wz-qxjs"];

            return disableCell;
        }
            break;
    }
    

    return nil;
    }

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DoctorStudioVideoOrderData *data = self.dataArray[indexPath.section];
    
    BATDoctorStudioOrderDetailViewController *orderDetailVC = [[BATDoctorStudioOrderDetailViewController alloc] init];
    orderDetailVC.orderNo = data.OrderNo;
    orderDetailVC.createTime = data.CreatedTime;
    orderDetailVC.type = data.OrderType;
    orderDetailVC.payStatus = data.OrderPayStatus;
    orderDetailVC.price = data.OrderMoney;
    orderDetailVC.orderStatus = data.OrderStatus;
    [self.navigationController pushViewController:orderDetailVC animated:YES];
}

#pragma mark - NET
- (void)videoOrderListRequest {
    
    [HTTPTool requestWithURLString:@"/api/Order/GetPatientOrder" parameters:@{@"orderType":@"2",@"pageIndex":@(self.currentPage),@"pageSize":@"10"} type:kGET success:^(id responseObject) {
        
        [self.videoListTableView.mj_header endRefreshing];
        [self.videoListTableView.mj_footer endRefreshing];
        
        BATDoctorStudioVideoListModel *model = [BATDoctorStudioVideoListModel mj_objectWithKeyValues:responseObject];
        
        
        [self.dataArray addObjectsFromArray:model.Data];
        
        if (self.dataArray.count >= model.RecordsCount) {
            [self.videoListTableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        [self.videoListTableView reloadData];
        
        if(self.dataArray.count == 0){
            [self.defaultView showDefaultView];
            self.defaultView.reloadButton.hidden = YES;
        }
        
    } failure:^(NSError *error) {
        
        [self.videoListTableView.mj_header endRefreshing];
        [self.videoListTableView.mj_footer endRefreshing];
        self.currentPage --;
        if (self.currentPage < 0) {
            self.currentPage = 0;
        }
//        [self showErrorWithText:error.localizedDescription];
        
        [self.defaultView showDefaultView];
    }];
}

- (void)CanEnterRoomRequestWithOrderNo:(NSString *)orderNo complete:(void(^)(BOOL canEnter))complete{
    
    [HTTPTool requestWithURLString:@"/api/order/CanEnterRoom" parameters:@{@"orderNo":orderNo} type:kGET success:^(id responseObject) {
        
        BOOL data = [responseObject[@"Data"] boolValue];
        
        if (complete) {
            complete(data);
        }
        
    } failure:^(NSError *error) {
        
        if (complete) {
            complete(NO);
        }
        
        [self showErrorWithText:error.localizedDescription];
    }];
}

#pragma mark - layout
- (void)pagesLayout {
    
    [self.view addSubview:self.videoListTableView];
    [self.videoListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    
    [self.view addSubview:self.defaultView];
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - getter
- (UITableView *)videoListTableView {
    
    if (!_videoListTableView) {
        
        _videoListTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _videoListTableView.frame = self.view.bounds;
        
        [_videoListTableView registerClass:[BATDoctorStudioVideoListCell class] forCellReuseIdentifier:VIDEO_CELL];
        [_videoListTableView registerClass:[BATDoctorStudioVideoDisableTableViewCell class] forCellReuseIdentifier:VIDEO_DISABLE_CELL];
        
        _videoListTableView.estimatedRowHeight = 150;
        
        _videoListTableView.tableFooterView = [UIView new];
        _videoListTableView.backgroundColor = [UIColor clearColor];
        _videoListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        _videoListTableView.delegate = self;
        _videoListTableView.dataSource = self;
        
        _videoListTableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
           
            self.currentPage = 0;
            [self.dataArray removeAllObjects];
            [self videoOrderListRequest];
        }];
        
        _videoListTableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            self.currentPage ++;
            [self videoOrderListRequest];
        }];
        
    }
    return _videoListTableView;
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
            [self videoOrderListRequest];
        }];
        
    }
    return _defaultView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
