//
//  BATConfirmPayViewController.m
//  HealthBAT
//
//  Created by jlteams on 16/8/2.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATConfirmPayViewController.h"
//#import "Masonry.h"
//#import "KMTools.h"
#import "BATConfrimPayOptionsTableViewCell.h"
#import "BATPaySuccessViewController.h"
#import "BATPayManager.h"

#import "BATFamilyDoctorOrderDetailViewController.h"

//优惠码
#import "BATConfirmPayHeaderView.h"
#import "BATConfirmPayCouponCodeTableViewCell.h"

static  NSString * const COUPON_CODE_CELL = @"BATConfirmPayCouponCodeTableViewCell";

@interface BATConfirmPayViewController () <UITableViewDelegate,UITableViewDataSource,BATConfirmPayViewDelegate,UITextFieldDelegate>

/**
 *  选择支付方式
 */
@property (nonatomic,strong) NSIndexPath *selectIndexPath;

/**
 *  支付方式 0微信 1支付宝
 */
@property (nonatomic,assign) NSInteger paymeny;


@property (nonatomic,assign) BOOL isUseCouponCode;
@property (nonatomic,strong) NSString *couponCode;

@end

@implementation BATConfirmPayViewController

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
        _confirmPayView = [[BATConfirmPayView alloc] init];
        _confirmPayView.tableView.delegate = self;
        _confirmPayView.tableView.dataSource = self;
        _confirmPayView.delegate = self;
        [self.view addSubview:_confirmPayView];
        
        
        WEAK_SELF(self);
        [_confirmPayView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.edges.equalTo(self.view);
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //支付状态提示
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPayErrorText:) name:@"BATDoctorStudio_PayState_Cancel" object:nil];
    
    self.navigationItem.title = @"支付";

    _selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:2];

    [_confirmPayView.tableView registerClass:[BATConfrimPayOptionsTableViewCell class] forCellReuseIdentifier:@"BATConfrimPayOptionsTableViewCell"];
    [_confirmPayView.tableView registerClass:[BATConfirmPayCouponCodeTableViewCell class] forCellReuseIdentifier:COUPON_CODE_CELL];

//    [self paySuccess];
}


- (void)showPayErrorText:(NSNotification *)info{
    
    [self showErrorWithText:@"支付取消，请在30分钟之内再支付，不然取消订单"];
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if (self.couponCode.length > 0) {
            return 3;
        }
        return 1;
    }
    if (section == 1) {
        if (self.isUseCouponCode == YES) {
            return 1;
        }
        return 0;
    }
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 45)];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, headerView.frame.size.width - 30, headerView.frame.size.height)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = UIColorFromHEX(0x666666, 1);
        titleLabel.text = @"选择支付方式";
        
        [headerView addSubview:titleLabel];
        return headerView;
    }
    
    if (section == 1 && self.type == kConsultTypeTextAndImage ) {
        BATConfirmPayHeaderView *header = [[BATConfirmPayHeaderView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 45)];
        header.selcetedBtn.selected = self.isUseCouponCode;
        WEAK_SELF(self);
        [header setSelectCouponCodeBlock:^(BOOL isSelect){
            STRONG_SELF(self);
            self.isUseCouponCode = isSelect;
            BATConfirmPayCouponCodeTableViewCell *cell = [_confirmPayView.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
            if (self.isUseCouponCode == NO) {
                //不适用优惠券
                self.couponCode = @"";
            }
            cell.inputTF.text = @"";

            [self.confirmPayView.tableView reloadData];
        }];
        return header;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }
    
    if (self.type != kConsultTypeTextAndImage && section == 1) {
        
        return 0;
    }
    
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *cellIdentifer = @"DetailCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifer];
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.textColor = UIColorFromHEX(0x333333, 1);
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
            cell.detailTextLabel.textColor = UIColorFromHEX(0xff0000, 1);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        switch (indexPath.row) {
            case 0:
            {
                if (_type == kConsultTypeFree) {
                    cell.textLabel.text = @"免费咨询";
                }
                else if (_type == kConsultTypeTextAndImage) {
                    cell.textLabel.text = @"图文咨询";
                }
                else if (_type == kConsultTypeVideo) {
                    cell.textLabel.text = @"视频咨询";
                }
                else if (_type == kConsultTypeAudio) {
                    cell.textLabel.text = @"语音咨询";
                }
                cell.detailTextLabel.text = [NSString stringWithFormat:@"￥ %@元",_momey];
                
            }
                break;
            case 1:
            {
                cell.textLabel.text = @"优惠金额";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"￥ -%@元",_momey];

            }
                break;
            case 2:
            {
                cell.textLabel.text = @"支付金额";
                cell.detailTextLabel.text = @"￥ 0元";
            }
                break;
        }
        return cell;

    }
    
    if (indexPath.section == 1) {
        
        BATConfirmPayCouponCodeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:COUPON_CODE_CELL forIndexPath:indexPath];
        if ([cell.inputTF.text isEqualToString:self.couponCode] && self.couponCode.length > 0) {
            cell.inputTF.userInteractionEnabled = NO;
        }
        else {
            cell.inputTF.userInteractionEnabled = YES;
        }

        __weak BATConfirmPayCouponCodeTableViewCell *weakCell = cell;
        [cell setConfirmCouponCodeBlock:^(NSString *couponCode){
            [weakCell.inputTF resignFirstResponder];
            [self judgeCodeRequestWithCode:couponCode];
        }];
        return cell;
    }

    if (indexPath.section == 2) {
     
        BATConfrimPayOptionsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATConfrimPayOptionsTableViewCell" forIndexPath:indexPath];
        
        if (indexPath.row == 0) {
            cell.optionsTitleLabel.text = @"支付宝支付";
            cell.optionsImageView.image = [UIImage imageNamed:@"icon-zhifubao"];
        }
        else if (indexPath.row == 1) {
            cell.optionsTitleLabel.text = @"微信支付";
            cell.optionsImageView.image = [UIImage imageNamed:@"icon-weixin-11"];
        }
        else if (indexPath.row == 2) {
            cell.optionsTitleLabel.text = @"康美钱包";
            cell.optionsImageView.image = [UIImage imageNamed:@"icon_kmpay"];
        }
        
        if (_selectIndexPath.row == indexPath.row) {
            cell.selectImageView.image = [UIImage imageNamed:@"btn-wicon-s"];
        } else {
            cell.selectImageView.image = [UIImage imageNamed:@"btn-wicon"];
        }
        
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
    
    if (self.isUseCouponCode == YES) {
        [self freeConsulationRequest];
        return;
    }
    
    if (_selectIndexPath.row == 0) {
        //支付宝支付
        [self requestAlipay];
        
    } else if (_selectIndexPath.row == 1) {
        //微信支付
        
        if ([WXApi isWXAppInstalled]) {
            [self requestWeChatPay];
        } else {
            [self showText:@"未检测到微信客户端"];
        }
       
    } else if (_selectIndexPath.row == 2) {
        //康美支付
        [self requestKMPay];

    }
    
//    //调起支付状态更新接口
//    [self requestUpdatePayConsultRecord];
}

#pragma mark - Action

#pragma mark - 支付成功进入支付成功界面
- (void)paySuccess
{
    //通知刷新
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Order_pay_success" object:nil];
    
    BATConfrimPayOptionsTableViewCell *cell = [_confirmPayView.tableView cellForRowAtIndexPath:_selectIndexPath];

    BATPaySuccessViewController *paySuccessVC = [[BATPaySuccessViewController alloc] init];
    paySuccessVC.type = _type;
    paySuccessVC.momey = _momey;
    paySuccessVC.payType = cell.optionsTitleLabel.text;
    paySuccessVC.orderNo = _orderNo;
    [self.navigationController pushViewController:paySuccessVC animated:YES];

}

#pragma mark - NET
#pragma mark - 微信支付
/*
 网络医院支付
 */
- (void)requestWeChatPay
{
    WEAK_SELF(self);
    [self showProgress];
    [HTTPTool requestWithURLString:[NSString stringWithFormat:@"/api/NetworkMedical/WxPay?orderNo=%@&SellerID=%@",_orderNo,WeChatAppId] parameters:nil type:kGET success:^(id responseObject) {
        STRONG_SELF(self);
        [[BATPayManager shareManager] pay:responseObject payType:BATPayType_WeChat orderNo:_orderNo complete:^(BOOL isSuccess) {
            DDLogWarn(@"支付验证回调");
            [self dismissProgress];
            if (isSuccess) {
                //支付成功
                [self paySuccess];
            }
        }];
        
    } failure:^(NSError *error) {

    }];
}

#pragma mark - 支付宝支付
/*
 网络医院支付
 */
- (void)requestAlipay
{
    WEAK_SELF(self);
    [self showProgress];
    [HTTPTool requestWithURLString:[NSString stringWithFormat:@"/api/NetworkMedical/AliPay?orderNo=%@",_orderNo] parameters:nil type:kGET success:^(id responseObject) {
        STRONG_SELF(self);
        [self dismissProgress];
        [[BATPayManager shareManager] pay:responseObject payType:BATPayType_Alipay orderNo:_orderNo complete:^(BOOL isSuccess) {
            DDLogWarn(@"支付验证回调");
            [self dismissProgress];
            if (isSuccess) {
                //支付成功
                [self paySuccess];
            }
        }];
        
    } failure:^(NSError *error) {

    }];
}

#pragma mark - 康美支付
- (void)requestKMPay
{
    WEAK_SELF(self);
    [self showProgress];
    [HTTPTool requestWithURLString:[NSString stringWithFormat:@"/api/NetworkMedical/KMPay?orderNo=%@",_orderNo] parameters:nil type:kGET success:^(id responseObject) {
        STRONG_SELF(self);
        [[BATPayManager shareManager] pay:responseObject payType:BATPayType_KMPay orderNo:_orderNo complete:^(BOOL isSuccess) {
            DDLogWarn(@"支付验证回调");
            [self dismissProgress];
            if (isSuccess) {
                //支付成功
                [self paySuccess];
            }
        }];
        
    } failure:^(NSError *error) {

    }];
}

#pragma mark - 问诊码支付

- (void)freeConsulationRequest {
    
    BATConfirmPayCouponCodeTableViewCell *cell = [_confirmPayView.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    if (cell.inputTF.text.length == 0) {
        [self showErrorWithText:@"请输入验证码"];
        return;
    }
    
    if (self.couponCode.length == 0) {
        [self showErrorWithText:@"请确认优惠码"];
        return;
    }
    
    [HTTPTool requestWithURLString:@"/api/NetworkMedical/SinglePayment" parameters:@{@"orderNo":self.orderNo,@"code":self.couponCode} type:kGET success:^(id responseObject) {
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [self showErrorWithText:error.localizedDescription];
    }];
}

- (void)judgeCodeRequestWithCode:(NSString *)code {
    
    
    [HTTPTool requestWithURLString:@"/api/NetworkMedical/JudgeCode" parameters:@{@"code":code} type:kGET success:^(id responseObject) {
        
        
        self.couponCode = code;
        [self.confirmPayView.tableView reloadData];
        
    } failure:^(NSError *error) {
        [self showErrorWithText:error.localizedDescription];
    }];
}

//#pragma mark Request
//- (void)requestUpdatePayConsultRecord
//{
//    if (_selectIndexPath.row == 0) {
//        //支付宝
//        _paymeny = 1;
//    }
//    else if (_selectIndexPath.row == 1) {
//        //微信
//        _paymeny = 0;
//    }
//
//    NSDictionary *params = @{
//                             @"ConsultRecordID":@(_diseaseDescriptionModel.ID),
//                             @"Payment":@(_paymeny),
//                             @"OrderStatus":@"1", //0未支付 1支付成功
//                             @"PayTime":[Tools getCurrentDateStringByFormat:@"yyyy-MM-dd HH:mm"]
//                             };
//
//    [self showProgress];
//    [HTTPTool requestWithURLString:@"/api/OnlineConsult/UpdatePayConsultRecord" parameters:params type:kPOST success:^(id responseObject) {
//        [self dismissProgress];
//
//        //成功后进入下一界面
//        BATConfrimPayOptionsTableViewCell *cell = [_confirmPayView.tableView cellForRowAtIndexPath:_selectIndexPath];
//
//        BATPaySuccessViewController *paySuccessVC = [[BATPaySuccessViewController alloc] init];
//        paySuccessVC.type = _type;
//        paySuccessVC.diseaseDescriptionModel = _diseaseDescriptionModel;
//        paySuccessVC.accountID = _accountID;
//        paySuccessVC.momey = _momey;
//        paySuccessVC.doctorName = _doctorName;
//        paySuccessVC.doctiorPhotoPath = _doctiorPhotoPath;
//        paySuccessVC.payType = cell.optionsTitleLabel.text;
//        [self.navigationController pushViewController:paySuccessVC animated:YES];
//
//
//    } failure:^(NSError *error) {
//        [self dismissProgress];
//
//    }];
//
//}

@end
