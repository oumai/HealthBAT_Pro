//
//  BATPayOTCViewController.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/12/19.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATPayOTCViewController.h"
#import "BATConfrimPayOptionsTableViewCell.h"
#import "BATPayOTCOrderNoCell.h"
#import "BATPayOTCOrderAmountCell.h"
#import "BATPayManager.h"
#import "BATDrugOrderListViewController.h"
#import "MQChatViewController.h"

@interface BATPayOTCViewController () <UITableViewDelegate,UITableViewDataSource>

/**
 *  选择支付方式
 */
@property (nonatomic,strong) NSIndexPath *selectIndexPath;

/**
 *  支付方式 0微信 1支付宝
 */
@property (nonatomic,assign) NSInteger paymeny;

@end

@implementation BATPayOTCViewController

- (void)loadView
{
    [super loadView];
    
    [self pageLayout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"支付";
    
    _selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    [self.payOTCView.tableView registerNib:[UINib nibWithNibName:@"BATPayOTCOrderAmountCell" bundle:nil] forCellReuseIdentifier:@"BATPayOTCOrderAmountCell"];
    [self.payOTCView.tableView registerNib:[UINib nibWithNibName:@"BATPayOTCOrderNoCell" bundle:nil] forCellReuseIdentifier:@"BATPayOTCOrderNoCell"];
    [self.payOTCView.tableView registerClass:[BATConfrimPayOptionsTableViewCell class] forCellReuseIdentifier:@"BATConfrimPayOptionsTableViewCell"];
    
    
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

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 ) {
        return 2;
    }
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.0f;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        
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
    }
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    if (section == 0) {
        return 10;
    }
    
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            BATPayOTCOrderNoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATPayOTCOrderNoCell" forIndexPath:indexPath];
            cell.OrderNoLabel.text = [NSString stringWithFormat:@"订单编号：%@",self.OrderNo];
            return cell;
        } else if (indexPath.row == 1) {
            BATPayOTCOrderAmountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATPayOTCOrderAmountCell" forIndexPath:indexPath];
            cell.OrderAmountLabel.text = [NSString stringWithFormat:@"￥%@元",self.TotalFee];
            return cell;
        }
    } else if (indexPath.section == 1) {
        
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
    if (indexPath.section == 1) {
        if (_selectIndexPath != indexPath) {
            _selectIndexPath = indexPath;
            [tableView reloadData];
        }
    }
}

#pragma mark - Action
- (void)confirmPayBtnClickedAction
{
    
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
}

#pragma mark - 支付成功进入支付成功界面
- (void)paySuccess
{
    DDLogDebug(@"支付成功");
    
    
    BOOL flag = NO;
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[BATDrugOrderListViewController class]]) {
            //如果是从药品订单进来的 支付成功后pop回药品订单
            flag = YES;
            [self.navigationController popToViewController:vc animated:NO];
            break;
        }
    }
    
    if (!flag) {
        //不是从药品订单进来的 跳转到药品订单
        
        //重新调整导航堆栈里的vc
        NSMutableArray *vcArray = [NSMutableArray array];
        
        for (UIViewController *vc in self.navigationController.viewControllers) {
            [vcArray addObject:vc];
            if ([vc isKindOfClass:[MQChatViewController class]]) {
                break;
            }
        }
        
//        [vcArray addObject:self];
        
        self.navigationController.viewControllers = vcArray;
        
        BATDrugOrderListViewController *drugOrderListVC = [[BATDrugOrderListViewController alloc] init];
        drugOrderListVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:drugOrderListVC animated:YES];
    }

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
    [HTTPTool requestWithKmWlyyBaseApiURLString:[NSString stringWithFormat:@"/Cashier/WxPay?OrderNo=%@&SellerID=%@",self.OrderNo,WeChatAppId] parameters:nil type:kGET success:^(id responseObject) {
        STRONG_SELF(self);
        [[BATPayManager shareManager] pay:responseObject payType:BATPayType_WeChat orderNo:self.OrderNo complete:^(BOOL isSuccess) {
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
    [HTTPTool requestWithKmWlyyBaseApiURLString:[NSString stringWithFormat:@"/Cashier/AliPay?orderNo=%@",self.OrderNo] parameters:nil type:kGET success:^(id responseObject) {
        STRONG_SELF(self);
        [self dismissProgress];
        [[BATPayManager shareManager] pay:responseObject payType:BATPayType_Alipay orderNo:self.OrderNo complete:^(BOOL isSuccess) {
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
    [HTTPTool requestWithKmWlyyBaseApiURLString:[NSString stringWithFormat:@"/api/NetworkMedical/KMPay?orderNo=%@",self.OrderNo] parameters:nil type:kGET success:^(id responseObject) {
        STRONG_SELF(self);
        [[BATPayManager shareManager] pay:responseObject payType:BATPayType_KMPay orderNo:self.OrderNo complete:^(BOOL isSuccess) {
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


#pragma mark - pageLayout
- (void)pageLayout
{
    [self.view addSubview:self.payOTCView];
    
    WEAK_SELF(self);
    [self.payOTCView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - get & set
- (BATPayOTCView *)payOTCView
{
    if (_payOTCView == nil) {
        _payOTCView = [[BATPayOTCView alloc] init];
        _payOTCView.tableView.delegate = self;
        _payOTCView.tableView.dataSource = self;
        WEAK_SELF(self);
        [_payOTCView.tableFooterView.confirmPayBtn bk_whenTapped:^{
            STRONG_SELF(self);
            [self confirmPayBtnClickedAction];
        }];
    }
    return _payOTCView;
}

@end
