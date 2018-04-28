//
//  BATBuyOTCViewController.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/12/13.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATBuyOTCViewController.h"
#import "BATUserAddressTableViewCell.h"
#import "BATBuyOTCSectionTitleTableViewCell.h"
#import "BATItemPriceTableViewCell.h"
#import "BATTotalTableViewCell.h"
#import "BATAddressListViewController.h"
#import "BATModifyAddressViewController.h"
#import "BATAddressModel.h"
#import "BATAddressAlertView.h"
#import "BATOTCOrderDetailModel.h"
#import "BATPayOTCViewController.h"

@interface BATBuyOTCViewController () <UITableViewDelegate,UITableViewDataSource>

/**
 收货人
 */
@property (nonatomic,strong) BATAddressData *addressData;

/**
 没收货地址时，alertView
 */
@property (nonatomic,strong) BATAddressAlertView *addressAlertView;

/**
 订单状态
 */
@property (nonatomic,assign) NSInteger OrderState;

/**
 订单详情
 */
@property (nonatomic,strong) BATOTCOrderDetailModel *orderDetailModel;

/**
 是否代煎
 */
@property (nonatomic,assign) BOOL isReplace;

@end

@implementation BATBuyOTCViewController

- (void)dealloc
{
    DDLogDebug(@"%s",__func__);
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadView
{
    [super loadView];
    
    [self pageLayout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = @"购买处方";
    
    [self.buyOTCView.tableView registerNib:[UINib nibWithNibName:@"BATUserAddressTableViewCell" bundle:nil] forCellReuseIdentifier:@"BATUserAddressTableViewCell"];
    [self.buyOTCView.tableView registerNib:[UINib nibWithNibName:@"BATBuyOTCSectionTitleTableViewCell" bundle:nil] forCellReuseIdentifier:@"BATBuyOTCSectionTitleTableViewCell"];
    [self.buyOTCView.tableView registerNib:[UINib nibWithNibName:@"BATItemPriceTableViewCell" bundle:nil] forCellReuseIdentifier:@"BATItemPriceTableViewCell"];
    [self.buyOTCView.tableView registerNib:[UINib nibWithNibName:@"BATTotalTableViewCell" bundle:nil] forCellReuseIdentifier:@"BATTotalTableViewCell"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectReceiptUser:) name:BATOTCSelectReceiptUserNotification object:nil];
    
    if (self.OrderNo != nil) {
        [self requestOrders];
    }
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

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    return self.isReplace ? 4 : 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 1) {
        return UITableViewAutomaticDimension;
    }
    
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 64;
    }
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            BATBuyOTCSectionTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATBuyOTCSectionTitleTableViewCell" forIndexPath:indexPath];
            cell.titleLabel.text = @"收货信息";
            return cell;
        } else if (indexPath.row == 1) {
            BATUserAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATUserAddressTableViewCell" forIndexPath:indexPath];
            
            if (self.orderDetailModel) {
                
                cell.nameLabel.text = [NSString stringWithFormat:@"收货人：%@",self.orderDetailModel.Data.Consignee.Name];
                cell.phoneLabel.text = self.orderDetailModel.Data.Consignee.Tel;
                cell.addressLabel.text = [NSString stringWithFormat:@"收货地址：%@",[self.orderDetailModel.Data.Consignee.Address stringByReplacingOccurrencesOfString:@"," withString:@""]];
            }
            

            return cell;
        }
        
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            BATBuyOTCSectionTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATBuyOTCSectionTitleTableViewCell" forIndexPath:indexPath];
            cell.titleLabel.text = @"订单信息";
            return cell;
        } else if (indexPath.row == 1 || (self.isReplace && indexPath.row == 2)) {
            BATItemPriceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATItemPriceTableViewCell" forIndexPath:indexPath];
            if (indexPath.row == 1) {
                cell.titleLabel.text = @"中药处方";
                for (DetailModel *dm in self.orderDetailModel.Data.Details) {
                    if (dm.ProductType == 4) {
                        cell.priceLabel.text = [NSString stringWithFormat:@"￥%@元",[NSString decimalNumberWithDouble:dm.Fee]];
                        break;
                    }
                }
                
            } else if (indexPath.row == 2) {
                cell.titleLabel.text = @"代煎费用";

                for (DetailModel *dm in self.orderDetailModel.Data.Details) {
                    if (dm.ProductType != 4 && self.isReplace) {
                        cell.priceLabel.text = [NSString stringWithFormat:@"￥%@元",[NSString decimalNumberWithDouble:dm.Fee]];
                        break;
                    }
                }
            }
    
            return cell;
        } else if (indexPath.row == [tableView numberOfRowsInSection:1] - 1) {
            BATTotalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATTotalTableViewCell" forIndexPath:indexPath];
            
            for (DetailModel *dm in self.orderDetailModel.Data.Details) {
                if (dm.ProductType != 4 && self.isReplace) {
                    cell.totalItemLabel.text = [NSString stringWithFormat:@"共计%ld件商品",(long)dm.Quantity];
                    break;
                }
                
                if (dm == self.orderDetailModel.Data.Details.lastObject) {
                    cell.totalItemLabel.text = [NSString stringWithFormat:@"共计%ld件商品",(long)dm.Quantity];
                }
                
            }
            
            [cell totalPrice:[NSString stringWithFormat:@"总价：￥%@",[NSString decimalNumberWithDouble:self.orderDetailModel.Data.TotalFee]]];
            

            return cell;
        }
    }
    return nil;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 1) {
        BATAddressListViewController *addressListVC = [[BATAddressListViewController alloc] init];
        addressListVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:addressListVC animated:YES];
    }
}

#pragma mark - Action
#pragma mark - 选择收货人
- (void)selectReceiptUser:(NSNotification *)notif
{
    
//    if (!self.buyOTCView.tableView.delegate && !self.buyOTCView.tableView.dataSource) {
//        self.buyOTCView.tableView.delegate = self;
//        self.buyOTCView.tableView.dataSource = self;
//        self.buyOTCView.tableView.tableFooterView = self.buyOTCView.footView;
//    }
    
    
    _addressData = (BATAddressData *)[notif object];
    
    if ([_addressData.AddressID isEqualToString:@""] || _addressData.AddressID == nil) {
        [self requestGetAllAddressList];
    } else {
        if (self.OrderNo != nil) {
            [self requestOrdersConfirm];
        }
        
        [self.buyOTCView.tableView reloadData];
    }
        

    
//    if ([notif object] == nil) {
//        [self requestGetAllAddressList];
//    } else {
//        _addressData = (BATAddressData *)[notif object];
//
//        if (![self.orderDetailModel.Data.Consignee.Id isEqualToString:_addressData.AddressID]) {
//
//            if (self.OrderNo != nil) {
//                [self requestOrdersConfirm];
//            }
//
//            [self.buyOTCView.tableView reloadData];
//        }
//    }
    

}

#pragma mark - NET
#pragma mark - 接口获取地址列表
- (void)requestGetAllAddressList
{
    [self showProgress];
    
    [HTTPTool requestWithKmWlyyBaseApiURLString:@"/userAddresses/getUserAddressList" parameters:nil type:kGET success:^(id responseObject) {
        BATAddressModel *addressModel = [BATAddressModel mj_objectWithKeyValues:responseObject];
        
        [self dismissProgress];
        
        if (addressModel.Data.count == 0 || !addressModel.Data) {
            [self.addressAlertView show];
        } else {
            
            if (([_addressData.AddressID isEqualToString:@""] || _addressData.AddressID == nil) && _addressData != nil) {
                for (BATAddressData *data in addressModel.Data) {
                    if (data == addressModel.Data.firstObject) {
                        //没有地址时要添加新地址后。要再次获取一次地址列表拿到地址id
                        _addressData = addressModel.Data.firstObject;
                    }
                }
                
                [self requestOrdersConfirm];
            }
        }
        
    } failure:^(NSError *error) {
        [self showErrorWithText:error.localizedDescription];
    }];
}

#pragma mark - 获取订单详情
- (void)requestOrders
{
    [HTTPTool requestWithKmWlyyBaseApiURLString:@"/Orders" parameters:@{@"OrderNo":self.OrderNo} type:kGET success:^(id responseObject) {
        
        self.orderDetailModel = [BATOTCOrderDetailModel mj_objectWithKeyValues:responseObject];
        
        if ([self.orderDetailModel.Data.Consignee.Name isEqualToString:@""]
            &&[self.orderDetailModel.Data.Consignee.Address isEqualToString:@""]
            &&[self.orderDetailModel.Data.Consignee.Tel isEqualToString:@""]) {
            
            [self requestGetAllAddressList];
            
        }
        
        for (DetailModel *dm in self.orderDetailModel.Data.Details) {
            if (dm.ProductType != 4) {
                self.isReplace = YES;
                break;
            }
            
            if (dm == self.orderDetailModel.Data.Details.lastObject) {
                self.isReplace = NO;
            }
        }
        
        [self.buyOTCView.tableView reloadData];

    } failure:^(NSError *error) {
        [self showErrorWithText:error.localizedDescription];
    }];
}

//#pragma mark - 购买处方
//- (void)requestBuyOrder
//{
//    //生成订单
//    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    [param setObject:self.OPDRegisterID forKey:@"OPDRegisterID"];
//    [param setObject:@[self.RecipeNo] forKey:@"RecipeNos"];
//
//    NSString *address = [NSString stringWithFormat:@"%@%@%@%@",_addressData.ProvinceName,_addressData.CityName,_addressData.AreaName,_addressData.DetailAddress];
//
//    [param setObject:@{@"Id":_addressData.AddressID,@"Address":address,@"Name":_addressData.UserName,@"Tel":_addressData.Mobile} forKey:@"Consignee"];
//
//    [HTTPTool requestWithKmWlyyBaseApiURLString:@"/UserRecipeOrders" parameters:param type:kPOST success:^(id responseObject) {
//
//        self.OrderNo = [[responseObject objectForKey:@"Data"] objectForKey:@"OrderNo"];
//        self.OrderState = [[[responseObject objectForKey:@"Data"] objectForKey:@"OrderState"] integerValue];
//
//        [self requestOrders];
//
//    } failure:^(NSError *error) {
//        self.buyOTCView.payBtn.enabled = NO;
//        [self showErrorWithText:error.localizedDescription];
//
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self.navigationController popViewControllerAnimated:YES];
//        });
//
//    }];
//}

#pragma mark - 确认订单
- (void)requestOrdersConfirm
{
    //修改地址后调用
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.OrderNo forKey:@"OrderNo"];
    [param setObject:@"" forKey:@"UserPackageID"];
    [param setObject:@"0" forKey:@"Privilege"];
    
    NSString *address = [NSString stringWithFormat:@"%@%@%@%@",_addressData.ProvinceName,_addressData.CityName,_addressData.AreaName,_addressData.DetailAddress];
    [param setObject:@{@"Id":_addressData.AddressID,@"Address":address,@"Name":_addressData.UserName,@"Tel":_addressData.Mobile} forKey:@"Consignee"];
    
    [HTTPTool requestWithKmWlyyBaseApiURLString:@"/Orders/Confirm" parameters:param type:kPOST success:^(id responseObject) {
        
//        self.orderDetailModel = [BATOTCOrderDetailModel mj_objectWithKeyValues:responseObject];
        
        [self requestOrders];
        
    } failure:^(NSError *error) {
        [self showErrorWithText:error.localizedDescription];
    }];
}

#pragma mark - pageLayout
- (void)pageLayout
{
    [self.view addSubview:self.buyOTCView];
    
    WEAK_SELF(self);
    [self.buyOTCView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self);
    }];
}

#pragma mark - get & set
- (BATBuyOTCView *)buyOTCView
{
    if (_buyOTCView == nil) {
        _buyOTCView = [[BATBuyOTCView alloc] init];
        _buyOTCView.tableView.delegate = self;
        _buyOTCView.tableView.dataSource = self;
        
        WEAK_SELF(self);
        [_buyOTCView.payBtn bk_whenTapped:^{
            STRONG_SELF(self);
            
            if ([self.orderDetailModel.Data.Consignee.Name isEqualToString:@""]
                &&[self.orderDetailModel.Data.Consignee.Address isEqualToString:@""]
                &&[self.orderDetailModel.Data.Consignee.Tel isEqualToString:@""]) {
                
                [self showText:@"请选择收货地址"];
                return;
                
            }
            BATPayOTCViewController *payOTCVC = [[BATPayOTCViewController alloc] init];
            payOTCVC.OrderNo = self.OrderNo;
            payOTCVC.TotalFee = [NSString decimalNumberWithDouble:self.orderDetailModel.Data.TotalFee];
            payOTCVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:payOTCVC animated:YES];
        }];
    }
    return _buyOTCView;
}

- (BATAddressAlertView *)addressAlertView
{
    if (_addressAlertView == nil) {
        _addressAlertView = [[UINib nibWithNibName:@"BATAddressAlertView" bundle:nil] instantiateWithOwner:self options:nil].firstObject;
        
        WEAK_SELF(self);
        _addressAlertView.cancelBlock = ^{
            DDLogDebug(@"取消");
        };
        
        _addressAlertView.conrimBlock = ^{
            DDLogDebug(@"确定");
            STRONG_SELF(self);
            BATModifyAddressViewController *modifyAddressVC = [[BATModifyAddressViewController alloc] init];
            modifyAddressVC.isModify = NO;
            modifyAddressVC.isFromBuyOTC = YES;
            modifyAddressVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:modifyAddressVC animated:YES];
        };
    }
    return _addressAlertView;
}

@end
