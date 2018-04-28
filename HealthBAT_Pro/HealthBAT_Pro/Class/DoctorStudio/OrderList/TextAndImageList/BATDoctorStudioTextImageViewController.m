//
//  BATDoctorStudioTextImageViewController.m
//  HealthBAT_Pro
//
//  Created by KM on 17/4/122017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDoctorStudioTextImageViewController.h"
#import "BATDoctorStudioTextImageTableViewCell.h"

#import "BATDoctorStudioOrderModel.h"
#import "BATPerson.h"

#import "BATDoctorStudioChatViewController.h"
//#import "BATPayViewController.h"
#import "BATNewPayViewController.h"
#import "BATComplaintController.h"
#import "BATDoctorStudioOrderDetailViewController.h"
#import "UIImage+Tool.h"
static  NSString * const TEXT_IMAGE_CELL = @"BATDoctorStudioTextImageTableViewCell";

@interface BATDoctorStudioTextImageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *orderListTableView;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,strong) NSMutableArray *dataArray;


@property (nonatomic,strong) BATDefaultView             *defaultView;

@end

@implementation BATDoctorStudioTextImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataArray = [NSMutableArray array];
    [self pagesLayout];
    
    [self.orderListTableView.mj_header beginRefreshing];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshOrder) name:@"BATDoctorStudioOrderListRefresh" object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BATDoctorStudioTextImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TEXT_IMAGE_CELL forIndexPath:indexPath];

    DoctorStudioOrderData *data = self.dataArray[indexPath.section];
    BATPerson *person = PERSON_INFO;

    cell.nameLabel.text = [NSString stringWithFormat:@"就诊人:%@",data.Name];
    cell.serviceDoctorLabel.text = [NSString stringWithFormat:@"服务医生:%@",data.DoctorName];
    cell.serveTimeLabel.text = [NSString stringWithFormat:@"服务时间:%@",data.OrderExpireTime];
    cell.orderTimeLabel.text = [NSString stringWithFormat:@"下单时间:%@",data.CreatedTime];
    cell.commentButton.hidden = YES;
    cell.actionButton.hidden = NO;

    /*
     1. 新增订单，订单状态未支付、咨询状态待支付、支付状态未付款、评价状态未评价
     如果是图文订单,新增1个在24小时患者未支付定时任务，如果支付状态未付款，订单状态改成已取消、咨询状态改成咨询取消
     如果是视频语音订单,新增1个在15分钟患者未支付定时任务，如果支付状态未付款，订单状态改成已取消、咨询状态改成咨询取消
     新增1个在排班有效期结束订单定时任务，
     如果支付状态未付款，订单状态改成已取消、咨询状态改成咨询取消
     如果支付状态已付款，咨询状态未回复，订单状态改成已取消、咨询状态改成咨询结束，支付状态改为已退款（调用退款接口,消息推送）
     如果支付状态已付款，咨询状态咨询中，订单状态改成已完成、咨询状态改成咨询完成
     2. 调用支付接口，支付成功，订单状态改成已支付、咨询状态改成未回复、支付状态改成已付款
     图文订单，新增1个在24小时医生未回复结束订单定时任务，如果咨询状态未回复，订单状态改成已取消、咨询状态改成咨询结束、支付状态改成已退款（调用退款接口，消息推送）
     3. 医生第一次回复(语音视频)患者消息,订单状态改成未完成，咨询状态改成咨询中
     图文订单，医生已回复，新增1个在24小时结束订单定时任务，如果咨询状态咨询中，订单状态改成已完成、咨询状态改成咨询完成
     4. 图文订单医生发起结束咨询，患者同意并评价，订单状态改成已完成，咨询状态改成咨询完成，评价状态改成已评价
     
     订单状态： 5-未支付，6-已支付，7-未完成，3-已完成，4-已取消
     支付状态：0-未付款，1-已付款，11-已退款
     咨询状态：3-待支付，4-未回复，5-咨询取消，6-咨询结束，1-咨询中，2-咨询完成
     评价状态： 0-未评价，1-已评价
     
     */
    
    switch (data.ConsultStatus) {
        case BATDoctorStudioConsultStatus_Consulting:
        {
            cell.statusImageView.image = [UIImage imageNamed:@"wz-zxz"];
            //未完成
            [cell.actionButton setBackgroundImage:[UIImage imageNamed:@"咨询"] forState:UIControlStateNormal];
            [cell.actionButton setTitle:@"咨询" forState:UIControlStateHighlighted];
            [cell.actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [cell.actionButton setBackgroundImage:[UIImage createImageWithColor:UIColorFromHEX(0x2accbe, 1)] forState:UIControlStateHighlighted];
            [cell setActionBlock:^{
                BATDoctorStudioChatViewController *chatVC = [[BATDoctorStudioChatViewController alloc] initWithConversationType:ConversationType_GROUP targetId:data.RoomID];
                [[BATRongCloudManager sharedBATRongCloudManager] bat_saveRongCloudUserInfoWithUserId:data.DoctorID name:data.DoctorName portraitUri:data.DoctorPic];
                chatVC.orderNo = data.OrderNo;
                chatVC.IllnessDescription = data.IllnessDescription;
                chatVC.status = data.ConsultStatus;
                chatVC.doctorName = data.DoctorName;
                chatVC.patientName = person.Data.UserName;
                if (data.Images.length > 0) {
                    chatVC.images = [NSArray arrayWithArray:[data.Images componentsSeparatedByString:@","]];
                }
                else {
                    chatVC.images = @[];
                }
                chatVC.title = data.DoctorName;
                chatVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:chatVC animated:YES];
            }];
        }
            break;
        case BATDoctorStudioConsultStatus_ConsultCompletion:
        {
            cell.statusImageView.image = [UIImage imageNamed:@"wz-qxwc"];
            [cell.actionButton setBackgroundImage:[UIImage imageNamed:@"咨询详情"] forState:UIControlStateNormal];
            cell.actionButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
            [cell.actionButton setTitle:@"咨询详情" forState:UIControlStateHighlighted];
            [cell.actionButton setTitleColor:UIColorFromRGB(122, 122, 122, 1) forState:UIControlStateHighlighted];
            [cell.actionButton setBackgroundImage:[UIImage createImageWithColor:UIColorFromHEX(0xf0f0f0, 1)] forState:UIControlStateHighlighted];
            [cell setActionBlock:^{
                BATDoctorStudioChatViewController *chatVC = [[BATDoctorStudioChatViewController alloc] initWithConversationType:ConversationType_GROUP targetId:data.RoomID];
                [[BATRongCloudManager sharedBATRongCloudManager] bat_saveRongCloudUserInfoWithUserId:data.DoctorID name:data.DoctorName portraitUri:data.DoctorPic];
                chatVC.orderNo = data.OrderNo;
                chatVC.IllnessDescription = data.IllnessDescription;
                chatVC.status = data.ConsultStatus;
                chatVC.doctorName = data.DoctorName;
                chatVC.patientName = person.Data.UserName;
                chatVC.status = BATDoctorStudioConsultStatus_ConsultCompletion;
                if (data.Images.length > 0) {
                    chatVC.images = [NSArray arrayWithArray:[data.Images componentsSeparatedByString:@","]];
                }
                else {
                    chatVC.images = @[];
                }
                chatVC.title = data.DoctorName;
                chatVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:chatVC animated:YES];
            }];
            
            //评价
            switch (data.IsComment) {
                case BATDoctorStudioCommentStatus_Commented:
                {
                    
                }
                    break;
                case BATDoctorStudioCommentStatus_NoComment:
                {
                    cell.commentButton.hidden = NO;
                    [cell setCommentBlock:^{
                        DDLogDebug(@"评价");
                        //未评价
                        BATComplaintController *complaintVC = [[BATComplaintController alloc] init];
                        complaintVC.OrderMSTID = data.OrderNo;
                        complaintVC.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:complaintVC animated:YES];
                    }];
                }
                    break;
            }
        }
            break;
        case BATDoctorStudioConsultStatus_WaitingPay:
        {
            cell.statusImageView.image = [UIImage imageNamed:@"wz-dzf"];
            [cell.actionButton setBackgroundImage:[UIImage imageNamed:@"支付"] forState:UIControlStateNormal];
            cell.actionButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
            [cell.actionButton setTitle:@"支付" forState:UIControlStateHighlighted];
            [cell.actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [cell.actionButton setBackgroundImage:[UIImage createImageWithColor:UIColorFromHEX(0x2accbe, 1)] forState:UIControlStateHighlighted];
            [cell setActionBlock:^{
                DDLogDebug(@"去支付");
                //去支付页面
                BATNewPayViewController *payVC = [[BATNewPayViewController alloc] init];
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
        }
            break;
        case BATDoctorStudioConsultStatus_NoAnswer:
        {
            cell.statusImageView.image = [UIImage imageNamed:@"wz-whf"];
            //未完成
            [cell.actionButton setBackgroundImage:[UIImage imageNamed:@"咨询"] forState:UIControlStateNormal];
            [cell.actionButton setTitle:@"咨询" forState:UIControlStateHighlighted];
            [cell.actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [cell.actionButton setBackgroundImage:[UIImage createImageWithColor:UIColorFromHEX(0x2accbe, 1)] forState:UIControlStateHighlighted];
            [cell setActionBlock:^{
                BATDoctorStudioChatViewController *chatVC = [[BATDoctorStudioChatViewController alloc] initWithConversationType:ConversationType_GROUP targetId:data.RoomID];
                [[BATRongCloudManager sharedBATRongCloudManager] bat_saveRongCloudUserInfoWithUserId:data.DoctorID name:data.DoctorName portraitUri:data.DoctorPic];
                chatVC.orderNo = data.OrderNo;
                chatVC.IllnessDescription = data.IllnessDescription;
                chatVC.status = data.ConsultStatus;
                chatVC.doctorName = data.DoctorName;
                chatVC.patientName = person.Data.UserName;
                if (data.Images.length > 0) {
                    chatVC.images = [NSArray arrayWithArray:[data.Images componentsSeparatedByString:@","]];
                }
                else {
                    chatVC.images = @[];
                }
                chatVC.title = data.DoctorName;
                chatVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:chatVC animated:YES];
            }];
        }
            break;
        case BATDoctorStudioConsultStatus_Cancel:
        {
            cell.statusImageView.image = [UIImage imageNamed:@"wz-qxqx"];
            cell.actionButton.hidden = YES;

        }
            break;
        case BATDoctorStudioConsultStatus_ConsultEnd:
        {
            cell.statusImageView.image = [UIImage imageNamed:@"wz-qxjs"];
            [cell.actionButton setBackgroundImage:[UIImage imageNamed:@"咨询详情"] forState:UIControlStateNormal];
            cell.actionButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
            [cell.actionButton setTitle:@"咨询详情" forState:UIControlStateHighlighted];
            [cell.actionButton setTitleColor:UIColorFromRGB(122, 122, 122, 1) forState:UIControlStateHighlighted];
            [cell.actionButton setBackgroundImage:[UIImage createImageWithColor:UIColorFromHEX(0xf0f0f0, 1)] forState:UIControlStateHighlighted];
            [cell setActionBlock:^{
                BATDoctorStudioChatViewController *chatVC = [[BATDoctorStudioChatViewController alloc] initWithConversationType:ConversationType_GROUP targetId:data.RoomID];
                [[BATRongCloudManager sharedBATRongCloudManager] bat_saveRongCloudUserInfoWithUserId:data.DoctorID name:data.DoctorName portraitUri:data.DoctorPic];
                chatVC.orderNo = data.OrderNo;
                chatVC.IllnessDescription = data.IllnessDescription;
                chatVC.status = data.ConsultStatus;
                chatVC.doctorName = data.DoctorName;
                chatVC.patientName = person.Data.UserName;
                chatVC.status = BATDoctorStudioConsultStatus_ConsultEnd;
                if (data.Images.length > 0) {
                    chatVC.images = [NSArray arrayWithArray:[data.Images componentsSeparatedByString:@","]];
                }
                else {
                    chatVC.images = @[];
                }
                chatVC.title = data.DoctorName;
                chatVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:chatVC animated:YES];
            }];
            
            //评价
            switch (data.IsComment) {
                case BATDoctorStudioCommentStatus_Commented:
                {
                    
                }
                    break;
                case BATDoctorStudioCommentStatus_NoComment:
                {
                    cell.commentButton.hidden = NO;
                    [cell setCommentBlock:^{
                        DDLogDebug(@"评价");
                        //未评价
                        BATComplaintController *complaintVC = [[BATComplaintController alloc] init];
                        complaintVC.OrderMSTID = data.OrderNo;
                        complaintVC.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:complaintVC animated:YES];
                    }];
                }
                    break;
            }
        }
            break;
    }
    
    
    return cell;
     
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DoctorStudioOrderData *data = self.dataArray[indexPath.section];

    BATDoctorStudioOrderDetailViewController *orderDetailVC = [[BATDoctorStudioOrderDetailViewController alloc] init];
    orderDetailVC.orderNo = data.OrderNo;
    orderDetailVC.createTime = data.CreatedTime;
    orderDetailVC.type = data.OrderType;
    orderDetailVC.payStatus = data.OrderPayStatus;
    orderDetailVC.price = data.OrderMoney;
    orderDetailVC.orderStatus = data.OrderStatus;
    [self.navigationController pushViewController:orderDetailVC animated:YES];
}

#pragma mark - action
- (void)refreshOrder {
    
    [self.orderListTableView.mj_header beginRefreshing];
}

#pragma mark - NET
- (void)textImageOrderListRequest {
    
    [HTTPTool requestWithURLString:@"/api/Order/GetPatientOrder" parameters:@{@"orderType":@"3",@"pageIndex":@(self.currentPage),@"pageSize":@"10"} type:kGET success:^(id responseObject) {
        
        [self.orderListTableView.mj_header endRefreshing];
        [self.orderListTableView.mj_footer endRefreshing];
        
        BATDoctorStudioOrderModel *model = [BATDoctorStudioOrderModel mj_objectWithKeyValues:responseObject];
        [self.dataArray addObjectsFromArray:model.Data];
        
        if (self.dataArray.count >= model.RecordsCount) {
            [self.orderListTableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        [self.orderListTableView reloadData];
        
        if(self.dataArray.count == 0){
            [self.defaultView showDefaultView];
        }
        
    } failure:^(NSError *error) {
        
        [self.orderListTableView.mj_header endRefreshing];
        [self.orderListTableView.mj_footer endRefreshing];
        self.currentPage --;
        if (self.currentPage < 0) {
            self.currentPage = 0;
        }
//        [self showErrorWithText:error.localizedDescription];
        
        [self.defaultView showDefaultView];
    }];
}


#pragma mark - Layout
- (void)pagesLayout {
    
    [self.view addSubview:self.orderListTableView];
    [self.orderListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    
    [self.view addSubview:self.defaultView];
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - getter
- (UITableView *)orderListTableView {
    
    if (!_orderListTableView) {
        
        _orderListTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        [_orderListTableView registerClass:[BATDoctorStudioTextImageTableViewCell class] forCellReuseIdentifier:TEXT_IMAGE_CELL];
        
        _orderListTableView.rowHeight = UITableViewAutomaticDimension;
        _orderListTableView.estimatedRowHeight = 180;
        _orderListTableView.tableFooterView = [UIView new];
        _orderListTableView.backgroundColor = [UIColor clearColor];
        _orderListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _orderListTableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            
            self.currentPage = 0;
            [self.dataArray removeAllObjects];
            [self textImageOrderListRequest];
        }];
        
        _orderListTableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
           
            self.currentPage ++;
            [self textImageOrderListRequest];
        }];
        
        _orderListTableView.delegate = self;
        _orderListTableView.dataSource = self;
    }
    return _orderListTableView;
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
            [self textImageOrderListRequest];
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
