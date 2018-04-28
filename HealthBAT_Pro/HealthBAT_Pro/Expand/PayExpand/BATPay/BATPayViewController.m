//
//  BATPayViewController.m
//  HealthBAT_Pro
//
//  Created by four on 2017/4/14.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATPayViewController.h"

#import "BATConfrimPayOptionsTableViewCell.h"

#import "BATPayManager.h"

#import "BATFamilyDoctorOrderDetailViewController.h"
#import "BATDoctorStudioPaySuccessViewController.h"

@interface BATPayViewController ()<UITableViewDelegate,UITableViewDataSource,BATConfirmPayViewDelegate>

/**
 *  选择支付方式
 */
@property (nonatomic,strong) NSIndexPath *selectIndexPath;

/**
 *  支付方式 0微信 1支付宝
 */
@property (nonatomic,assign) NSInteger paymeny;

@end

@implementation BATPayViewController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"支付";
    
    _selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    
    [_confirmPayView.tableView registerClass:[BATConfrimPayOptionsTableViewCell class] forCellReuseIdentifier:@"BATConfrimPayOptionsTableViewCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 45)];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, headerView.frame.size.width - 30, headerView.frame.size.height)];
        titleLabel.backgroundColor = [UIColor clearColor];
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
        return 10;
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
        
        if (_type == BATDoctorStudioOrderType_TextAndImage) {
            cell.textLabel.text = @"图文咨询";
        }
        else if (_type == BATDoctorStudioOrderType_Video) {
            cell.textLabel.text = @"视频咨询";
        }
        else if (_type == BATDoctorStudioOrderType_Audio) {
            cell.textLabel.text = @"语音咨询";
        }
        else if (_type == BATDoctorStudioOrderType_HomeDoctor) {
            cell.textLabel.text = @"家庭医生";
        }
        
        cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%@元",_momey];
        
        return cell;
    }
    
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

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (_selectIndexPath != indexPath) {
            _selectIndexPath = indexPath;
            [tableView reloadData];
        }
    }
}


#pragma mark - BATConfirmPayViewDelegate
- (void)confirmPayBtnClickedAction
{
    
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
        
        //家庭医生订单
        BATFamilyDoctorOrderDetailViewController *orderDetail = [[BATFamilyDoctorOrderDetailViewController alloc] init];
        orderDetail.paySuccess = YES;
        orderDetail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:orderDetail animated:YES];
    }
    else {
        //非家庭医生订单，验证接口
        [HTTPTool requestWithURLString:@"/api/Pay/ValidateOrder" parameters:@{@"orderNo":self.orderNo,@"PayMethod":@(type)} type:kGET success:^(id responseObject) {
            
            BATDoctorStudioValidatePayModel *model = [BATDoctorStudioValidatePayModel mj_objectWithKeyValues:responseObject];
            
            BATConfrimPayOptionsTableViewCell *cell = [_confirmPayView.tableView cellForRowAtIndexPath:_selectIndexPath];
            
            BATDoctorStudioPaySuccessViewController *paySuccessVC = [[BATDoctorStudioPaySuccessViewController alloc] init];
            paySuccessVC.hidesBottomBarWhenPushed = YES;
            paySuccessVC.type = _type;
            paySuccessVC.momey = _momey;
            paySuccessVC.payType = cell.optionsTitleLabel.text;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
