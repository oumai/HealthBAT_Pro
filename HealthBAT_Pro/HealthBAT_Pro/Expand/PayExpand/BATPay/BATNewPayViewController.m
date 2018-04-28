//
//  BATNewPayViewController.m
//  HealthBAT_Pro
//
//  Created by four on 2017/5/11.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATNewPayViewController.h"

//class
#import "BATPayManager.h"

//view
#import "BATNewPayDoctorScheduleView.h"

//cell
#import "BATNewPayDoctorInfoCell.h"
#import "BATConfrimPayOptionsTableViewCell.h"
#import "BATNewPayServerInfoCell.h"

//model
#import "BATDoctorStudioCreateOrderModel.h"
#import "BATNewDoctorScheduleModel.h"
#import "BATDoctorStudioValidatePayModel.h"

#import "BATDoctorStudioPaySuccessViewController.h"

@interface BATNewPayViewController ()<UITableViewDelegate,UITableViewDataSource,BATNewConfirmPayViewDelegate>
/**
 *  选择支付方式
 */
@property (nonatomic,strong) NSIndexPath *selectIndexPath;

/**
 *  支付方式 0微信 1支付宝
 */
@property (nonatomic,assign) NSInteger paymeny;

@property (nonatomic,strong) BATNewPayDoctorScheduleView *doctorScheduleView;
@property (nonatomic,strong) BATNewDoctorScheduleModel *doctorScheduleModel;

@end

@implementation BATNewPayViewController

- (void)dealloc
{
    DDLogDebug(@"%@",self);
    _confirmPayView.tableView.delegate = nil;
    _confirmPayView.tableView.dataSource = nil;
    _confirmPayView.delegate = nil;
}

- (void)loadView
{
    [super loadView];
    
    if (_confirmPayView == nil) {
        _confirmPayView = [[BATNewConfirmPayView alloc] init];
        _confirmPayView.tableView.delegate = self;
        _confirmPayView.tableView.dataSource = self;
        _confirmPayView.delegate = self;
        [self.view addSubview:_confirmPayView];
        
        if(self.type == BATDoctorStudioOrderType_Audio || self.type == BATDoctorStudioOrderType_Video){
            _confirmPayView.tableFooterView.titleLable.hidden = NO;
            _confirmPayView.tableFooterView.descLabel.hidden = NO;
        }else{
            _confirmPayView.tableFooterView.titleLable.hidden = YES;
            _confirmPayView.tableFooterView.descLabel.hidden = YES;
        }
        
        WEAK_SELF(self);
        [_confirmPayView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.edges.equalTo(self.view);
        }];
        
        [self.view addSubview:self.doctorScheduleView];
        [self.doctorScheduleView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.edges.equalTo(self.view);
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //支付状态提示
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPayErrorText:) name:@"BATDoctorStudio_PayState_Cancel" object:nil];
    
    self.navigationItem.title = @"支付";
    
    if (!self.TimeStr) {
        self.TimeStr = @"预约时间";
    }

    _selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    
    [_confirmPayView.tableView registerClass:[BATConfrimPayOptionsTableViewCell class] forCellReuseIdentifier:@"BATConfrimPayOptionsTableViewCell"];
    [_confirmPayView.tableView registerClass:[BATNewPayDoctorInfoCell class] forCellReuseIdentifier:@"BATNewPayDoctorInfoCell"];
    [_confirmPayView.tableView registerClass:[BATNewPayServerInfoCell class] forCellReuseIdentifier:@"BATNewPayServerInfoCell"];
}

- (void)showPayErrorText:(NSNotification *)info{
    if(self.type == BATDoctorStudioOrderType_TextAndImage){
        [self showErrorWithText:@"支付取消，请在24小时之内再支付，不然取消订单"];
    }else{
        [self showErrorWithText:@"支付取消，请在15分钟之内再支付，不然取消订单"];
    }
}

#pragma mark - 获取医生排班
- (void)UpdateConsultOrder {
    
    [HTTPTool requestWithURLString:@"/api/order/UpdateConsultOrder" parameters:@{@"OrderNo":self.orderNo,@"ScheduleId":self.ScheduleId} type:kPOST success:^(id responseObject) {
        
        
    } failure:^(NSError *error) {
        
        [self showErrorWithText:error.localizedDescription];
    }];
}
- (void)getDoctorScheduleRequest{
    
//    [self showText:@"正在获取医生排版"];
    
    [HTTPTool requestWithURLString:@"/api/Doctor/SearchDoctorSchedule" parameters:@{@"doctorId":self.doctorID} type:kGET success:^(id responseObject) {
//        [self dismissProgress];
        
        self.doctorScheduleModel = [BATNewDoctorScheduleModel mj_objectWithKeyValues:responseObject];
        
        if(self.doctorScheduleModel.ResultCode == 0 && self.doctorScheduleModel.Data[0].DataWeek.WeekStr !=nil){
            
            self.doctorScheduleView.hidden = NO;
            
            [self.doctorScheduleView configrationData:self.doctorScheduleModel];
        }else{
            [self showText:@"暂无排版信息，请选择其他医生购买"];
        }
        
    } failure:^(NSError *error) {
        
        [self showErrorWithText:error.localizedDescription];
    }];
}


- (void)creatOrderRequest{
    
    NSDictionary *param;
    if (self.type == BATDoctorStudioOrderType_Audio || self.type == BATDoctorStudioOrderType_Video) {
        //语音视频，加入 排班信息
        if (!self.ScheduleId || self.ScheduleId.length == 0) {
            [self showErrorWithText:@"请选择预约时间"];
            return;
        }
        
        param = @{
                  @"DoctorID":self.doctorID,
                  @"OrderType":@(self.type),
                  @"OrderMoney":self.momey,
                  @"IllnessDescription":@"",
                  @"Images":@"",
                  @"ScheduleId":self.ScheduleId,
                  };
    }
    else {
        //图文
        param = @{
                  @"DoctorID":self.doctorID,
                  @"OrderType":@(self.type),
                  @"OrderMoney":self.momey,
                  @"IllnessDescription":@"",
                  @"Images":@""
                  };
    }
    
    [HTTPTool requestWithURLString:@"/api/order/CreateConsultOrder" parameters:param type:kPOST success:^(id responseObject) {
        
        
        BATDoctorStudioCreateOrderModel *model = [BATDoctorStudioCreateOrderModel mj_objectWithKeyValues:responseObject];
        if (model.ResultCode == 0) {
           
            self.orderNo = model.Data;
            
            if (_selectIndexPath.row == 0) {
                //支付宝支付
                [self requestAlipayFromBATAPI];
                
            } else if (_selectIndexPath.row == 1) {
                //微信支付
                [self requestWeChatPayFromBATAPI];
            }
            
        }
        else {
            
            [self showErrorWithText:model.ResultMessage];
        }
    } failure:^(NSError *error) {
        
        [self showErrorWithText:error.localizedDescription];
        
    }];

}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 ) {
        return 1;
    }else if (section == 1){
        return 2;
    }else{
        return 3;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 65;
    }
    return 45.0f;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
        headerView.backgroundColor = [UIColor whiteColor];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, headerView.frame.size.width - 30, headerView.frame.size.height)];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = UIColorFromHEX(0x666666, 1);
        titleLabel.text = @"选择支付方式";
        
        [headerView addSubview:titleLabel];
        return headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGFLOAT_MIN;
    }else if (section == 1){
        return 10;
    }else{
        return 45;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 10;
    }else{
        return CGFLOAT_MIN;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        BATNewPayDoctorInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATNewPayDoctorInfoCell"];
        
        
        [cell.doctorImageView sd_setImageWithURL:[NSURL URLWithString:self.doctorPhotoPath] placeholderImage:[UIImage imageNamed:@"医生"]];
        cell.doctorName.text = self.doctorName;
        cell.timeLable.text = self.TimeStr;
        
        if (self.type == BATDoctorStudioOrderType_TextAndImage) {
            //图文
            cell.rightIcon.hidden = YES;
            cell.timeLable.hidden = YES;
        }
        
        [cell setChooseConsultingTime:^{
            //选择时间
            [self getDoctorScheduleRequest];
        }];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
    }
    else if (indexPath.section == 1) {
        BATNewPayServerInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATNewPayServerInfoCell"];
        
        if (indexPath.row == 0) {
            cell.titleLabel.text = @"科室";
            cell.deseLabel.text = self.dept;
            cell.deseLabel.textColor = UIColorFromHEX(0x333333, 1);
        }else{
            
            switch (self.type) {
                case BATDoctorStudioOrderType_TextAndImage:
                    cell.titleLabel.text = @"图文咨询";
                    break;
                case BATDoctorStudioOrderType_Audio:
                    cell.titleLabel.text = @"语音咨询";
                    break;
                case BATDoctorStudioOrderType_Video:
                    cell.titleLabel.text = @"视频咨询";
                    break;
                default:
                    break;
            }
            cell.deseLabel.text = [NSString stringWithFormat:@"%@元",_momey];;
            cell.deseLabel.textColor = UIColorFromHEX(0xff4343, 1);
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else if (indexPath.section == 2) {
    
        BATConfrimPayOptionsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATConfrimPayOptionsTableViewCell" forIndexPath:indexPath];
        
        if (indexPath.row == 0) {
            cell.optionsTitleLabel.text = @"支付宝支付";
            cell.optionsImageView.image = [UIImage imageNamed:@"icon-zhifubao"];
        } else if (indexPath.row == 1){
            cell.optionsTitleLabel.text = @"微信支付";
            cell.optionsImageView.image = [UIImage imageNamed:@"icon-weixin-11"];
        } else{
            cell.optionsTitleLabel.text = @"康美钱包";
            cell.optionsImageView.image = [UIImage imageNamed:@"icon_kmpay"];
        }
        
        if (_selectIndexPath.row == indexPath.row) {
            cell.selectImageView.image = [UIImage imageNamed:@"btn-wicon-s"];
        } else {
            cell.selectImageView.image = [UIImage imageNamed:@"btn-wicon"];
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
    }
    
    return nil;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        if (_selectIndexPath != indexPath) {
            _selectIndexPath = indexPath;
            [tableView reloadData];
        }
    }
}


#pragma mark - BATConfirmPayViewDelegate
- (void)confirmPayBtnClickedAction
{
    if (!self.orderNo) {
        [self creatOrderRequest];
    }
    else {
        
        if (_selectIndexPath.row == 0) {
            //支付宝支付
            [self requestAlipayFromBATAPI];
            
        } else if (_selectIndexPath.row == 1) {
            //微信支付
            [self requestWeChatPayFromBATAPI];
        } else if (_selectIndexPath.row == 2) {
            //康美支付
            [self requestKMPayFromBATAPI];
        }
    }
}

//#pragma mark - BATConfirmPayViewDelegate
//- (void)ChooseBATNewPayDoctorScheduleView
//{
//    [self creatOrderRequest];
//}

#pragma mark - Action

#pragma mark - 支付成功进入支付成功界面

/*
 BAT支付成功
 */
- (void)paySuccessFromBATAPIWithType:(BATDoctorStudioPayType)type
{
    
    if (self.type == BATDoctorStudioOrderType_HomeDoctor) {
        //通知刷新
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Order_pay_success" object:nil];
        
//        //家庭医生订单
//        BATFamilyDoctorOrderDetailViewController *orderDetail = [[BATFamilyDoctorOrderDetailViewController alloc] init];
//        orderDetail.paySuccess = YES;
//        orderDetail.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:orderDetail animated:YES];
    }
    else {
        //非家庭医生订单，验证接口
        [HTTPTool requestWithURLString:@"/api/Pay/ValidateOrder" parameters:@{@"orderNo":self.orderNo,@"PayMethod":@(type)} type:kGET success:^(id responseObject) {
            
            BATDoctorStudioValidatePayModel *model = [BATDoctorStudioValidatePayModel mj_objectWithKeyValues:responseObject];
            
//            BATConfrimPayOptionsTableViewCell *cell = [_confirmPayView.tableView cellForRowAtIndexPath:_selectIndexPath];
            
            BATDoctorStudioPaySuccessViewController *paySuccessVC = [[BATDoctorStudioPaySuccessViewController alloc] init];
            paySuccessVC.hidesBottomBarWhenPushed = YES;
            paySuccessVC.type = _type;
            paySuccessVC.momey = _momey;
            if (_selectIndexPath.row == 0) {
                //支付宝支付
                paySuccessVC.payType = @"支付宝支付";
                
            } else if (_selectIndexPath.row == 1) {
                //微信支付
                paySuccessVC.payType = @"微信支付";
            } else if (_selectIndexPath.row == 2) {
                //康美支付
                paySuccessVC.payType = @"康美钱包";
            }
            paySuccessVC.orderNo = _orderNo;
            paySuccessVC.model = model;
            [self.navigationController pushViewController:paySuccessVC animated:YES];
            
            //移除支付界面
            NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
            [tmpArray removeObject:self];
            self.navigationController.viewControllers = tmpArray;
            
        } failure:^(NSError *error) {
            
            [self showErrorWithText:error.localizedDescription];
        }];
        
        
    }
    
}

#pragma mark - NET
#pragma mark - 微信支付

- (void)requestWeChatPayFromBATAPI
{
    WEAK_SELF(self);
    [self showProgress];
    [HTTPTool requestWithURLString:[NSString stringWithFormat:@"/api/pay/WxPay?orderNo=%@&payFee=%@",_orderNo,self.momey] parameters:nil type:kGET success:^(id responseObject) {
        STRONG_SELF(self);
        [[BATPayManager shareManager] pay:responseObject payType:BATPayType_WeChat orderNo:_orderNo complete:^(BOOL isSuccess) {
            DDLogWarn(@"支付验证回调");
            [self dismissProgress];
            if (isSuccess) {
                //支付成功
                [self paySuccessFromBATAPIWithType:BATDoctorStudioPayType_WXPay];
            }
        }];
        
    } failure:^(NSError *error) {
        
        [self showErrorWithText:error.localizedDescription];
    }];
}


#pragma mark - 支付宝支付

- (void)requestAlipayFromBATAPI
{
    WEAK_SELF(self);
    [self showProgress];
    [HTTPTool requestWithURLString:[NSString stringWithFormat:@"/api/pay/AliPay?orderNo=%@&payFee=%@",_orderNo,self.momey] parameters:nil type:kGET success:^(id responseObject) {
        STRONG_SELF(self);
        [self dismissProgress];
        [[BATPayManager shareManager] pay:responseObject payType:BATPayType_Alipay orderNo:_orderNo complete:^(BOOL isSuccess) {
            DDLogWarn(@"支付验证回调");
            [self dismissProgress];
            if (isSuccess) {
                //支付成功
                [self paySuccessFromBATAPIWithType:BATDoctorStudioPayType_ALiPay];
            }
        }];
        
    } failure:^(NSError *error) {
        [self showErrorWithText:error.localizedDescription];
    }];
}

#pragma mark - 康美支付
- (void)requestKMPayFromBATAPI
{
    WEAK_SELF(self);
    [self showProgress];
    
    [HTTPTool requestWithURLString:[NSString stringWithFormat:@"/api/pay/KmPay?orderNo=%@&payFee=%@&returnUrl=https://www.kmpay518.com/",_orderNo,self.momey] parameters:nil type:kGET success:^(id responseObject) {
        STRONG_SELF(self);
        [self dismissProgress];
        
        [[BATPayManager shareManager] pay:responseObject payType:BATPayType_KMPay orderNo:_orderNo complete:^(BOOL isSuccess) {
            DDLogWarn(@"支付验证回调");
            [self dismissProgress];
            if (isSuccess) {
                //支付成功
                [self paySuccessFromBATAPIWithType:BATDoctorStudioPayType_KMPay];
            }
        }];
        
    } failure:^(NSError *error) {
        [self showErrorWithText:error.localizedDescription];
    }];
}


- (BATNewPayDoctorScheduleView *)doctorScheduleView{

    if (!_doctorScheduleView) {
        _doctorScheduleView = [[BATNewPayDoctorScheduleView alloc]init];
        _doctorScheduleView.hidden = YES;
        WEAK_SELF(self);
        [_doctorScheduleView setBlackViewClick:^{
            STRONG_SELF(self);
            self.doctorScheduleView.hidden = YES;
        }];
        
        [_doctorScheduleView setNoScheduleCanChooseClick:^{
            STRONG_SELF(self);
            [self showText:@"该时段已不可预约！"];
        }];
        
        [_doctorScheduleView setChooseScheduleClick:^(NSInteger day,NSInteger row){
           STRONG_SELF(self);
            NewDoctorScheduleData *newDataWeek = self.doctorScheduleModel.Data[day];
            
            switch (row) {
                case 0:
                {
                    self.TimeStr = [NSString stringWithFormat:@"%@ 8:00-10:00",newDataWeek.DataWeek.DateStr];
                }
                    break;
                case 1:
                {
                    self.TimeStr = [NSString stringWithFormat:@"%@ 10:00-12:00",newDataWeek.DataWeek.DateStr];
                }
                    break;
                case 2:
                {
                     self.TimeStr = [NSString stringWithFormat:@"%@ 14:00-16:00",newDataWeek.DataWeek.DateStr];
                }
                    break;
                case 3:
                {
                    self.TimeStr = [NSString stringWithFormat:@"%@ 16:00-18:00",newDataWeek.DataWeek.DateStr];
                }
                    break;
                case 4:
                {
                    self.TimeStr = [NSString stringWithFormat:@"%@ 18:00-20:00",newDataWeek.DataWeek.DateStr];
                }
                    break;
                case 5:
                {
                    self.TimeStr = [NSString stringWithFormat:@"%@ 20:00-23:59",newDataWeek.DataWeek.DateStr];
                }
                    break;
                default:
                    break;
            }
            NSDictionary *dic = newDataWeek.ScheduleTimeList[row];
            self.ScheduleId = dic[@"ScheduleID"];
            
            //修改订单信息
            if (self.orderNo) {
                [self UpdateConsultOrder];
            }
            
            
            self.doctorScheduleView.hidden = YES;
            [self.confirmPayView.tableView reloadData];
            
            
        }];
    }
    return _doctorScheduleView;
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
