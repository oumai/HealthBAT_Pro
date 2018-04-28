//
//  BATDrugOrderAddressInfoViewController.m
//  HealthBAT_Pro
//
//  Created by wct on 2017/12/14.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDrugOrderAddressInfoViewController.h"

#import "BATDrugOrderCustomerTableViewCell.h"
#import "BATDrugOrderCommonInfoTableViewCell.h"
#import "BATDrugOrderLogisticsInfoTableViewCell.h"

#import "BATDrugOrderHeader.h"

#import "BATDrugOrderLogisticsModel.h"

#import "BATDrugOrderLogisticsDetailViewController.h"

static  NSString * const CUSTOMER_CELL = @"BATDrugOrderCustomerTableViewCell";
static  NSString * const COMMON_CELL = @"BATDrugOrderCommonInfoTableViewCell";
static  NSString * const LOGISTICS_CELL = @"BATDrugOrderLogisticsInfoTableViewCell";


@interface BATDrugOrderAddressInfoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *logisticsTableView;
@property (nonatomic,strong) BATDrugOrderLogisticsModel *logisticsModel;

@end

@implementation BATDrugOrderAddressInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self layoutPages];
    
    [self requestLogisticalInfo];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 3;
    }
    else if (section == 1) {
        
        return 1;
    }
    else if (section == 2) {
        
        return self.logisticsModel.Data.Details.count;
    }
    else {
        
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {

        //物流信息
        
        if (indexPath.row == 0) {
            BATDrugOrderLogisticsInfoTableViewCell *logisticsInfoCell = [tableView dequeueReusableCellWithIdentifier:LOGISTICS_CELL forIndexPath:indexPath];
            
            logisticsInfoCell.leftTitleLabel.text = [NSString stringWithFormat:@"运货单号：%@",self.logisticsModel.Data.LogisticNo];
            [logisticsInfoCell setQueryBlock:^{
               
                //查看物流详情
                DDLogDebug(@"查看物流信息");
                
                BATDrugOrderLogisticsDetailViewController *detailVC = [[BATDrugOrderLogisticsDetailViewController alloc] init];
                detailVC.phoneNumber = self.data.Member.Mobile;
                detailVC.LogisticNo = self.logisticsModel.Data.LogisticNo;
                [self.navigationController pushViewController:detailVC animated:YES];
            }];
            return logisticsInfoCell;
        }
        else {
            
            BATDrugOrderCommonInfoTableViewCell *logisticsInfoCell = [tableView dequeueReusableCellWithIdentifier:COMMON_CELL forIndexPath:indexPath];
            switch (indexPath.row) {
                case 1:
                {
                    logisticsInfoCell.leftTitleLabel.text = [NSString stringWithFormat:@"承运来源：%@",self.logisticsModel.Data.LogisticCompanyName];
                }
                    break;
                case 2:
                {
                    logisticsInfoCell.leftTitleLabel.text = [NSString stringWithFormat:@"收货地址：%@",[self.logisticsModel.Data.Consignee.Address  stringByReplacingOccurrencesOfString:@"," withString:@""]];
                }
                    break;
                default:
                    break;
            }
            
            return logisticsInfoCell;
        }
       
    }
    else if (indexPath.section == 1) {
        //患者信息
        BATDrugOrderCustomerTableViewCell *customerCell = [tableView dequeueReusableCellWithIdentifier:CUSTOMER_CELL forIndexPath:indexPath];
        customerCell.nameLabel.text = [NSString stringWithFormat:@"姓名：%@",self.data.Member.MemberName];
        customerCell.sexLabel.text = [NSString stringWithFormat:@"性别：%@",self.data.Member.Gender == 0 ? @"男":@"女"];
        customerCell.birthdayLabel.text = [NSString stringWithFormat:@"生日：%@",self.data.Member.Birthday];
        customerCell.phoneLabel.text = [NSString stringWithFormat:@"联系电话：%@",self.data.Member.Mobile];
        return customerCell;
    }
    else if (indexPath.section == 2) {
        //订单信息
        BATDrugOrderCommonInfoTableViewCell *orderInfoCell = [tableView dequeueReusableCellWithIdentifier:COMMON_CELL forIndexPath:indexPath];
        
        BATDrugOrderLogisticsDetailsModel *handleDetailModel;
        BATDrugOrderLogisticsDetailsModel *drugDetailModel;
        for (BATDrugOrderLogisticsDetailsModel *tmpDetail in self.logisticsModel.Data.Details) {
            
            if ([tmpDetail.ProductType isEqualToString:@"4"]) {
                //处方主体
                drugDetailModel = tmpDetail;
            }
            else {
                //其他（代煎）
                handleDetailModel = tmpDetail;
            }
        }
        
        switch (indexPath.row) {
            case 0:
            {
                orderInfoCell.leftTitleLabel.text = drugDetailModel.Subject;
                orderInfoCell.rightLabel.text = [NSString decimalNumberWithDouble:drugDetailModel.Fee];
            }
                break;
            case 1:
            {
                orderInfoCell.leftTitleLabel.text = @"待煎费用";
                orderInfoCell.rightLabel.text = [NSString decimalNumberWithDouble:handleDetailModel.Fee];
            }
                break;
            default:
                break;
        }
        orderInfoCell.rightLabel.textColor = [UIColor blackColor];
        
        return orderInfoCell;
    }
    else {
        //支付信息
        BATDrugOrderCommonInfoTableViewCell *payInfoCell = [tableView dequeueReusableCellWithIdentifier:COMMON_CELL forIndexPath:indexPath];
        payInfoCell.leftTitleLabel.text = [[self.logisticsModel.Data.TradeTime substringToIndex:16] stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        /* "PayType": 0,//支付类型 -1=免支付,0=康美支付,1=微信支付,2=支付宝,3=中国银联,4=MasterCard,5=PayPal,6=VISA */

        switch (self.logisticsModel.Data.PayType) {
            case -1:
                payInfoCell.rightLabel.text = @"免支付";
                break;
            case 0:
                payInfoCell.rightLabel.text = @"康美支付";
                break;
            case 1:
                payInfoCell.rightLabel.text = @"微信支付";
                break;
            case 2:
                payInfoCell.rightLabel.text = @"支付宝";
                break;
            case 3:
                payInfoCell.rightLabel.text = @"中国银联";
                break;
            case 4:
                payInfoCell.rightLabel.text = @"MasterCard";
                break;
            case 5:
                payInfoCell.rightLabel.text = @"PayPal";
                break;
            case 6:
                payInfoCell.rightLabel.text = @"VISA";
                break;
                
            default:
                break;
        }
        
        if (!self.logisticsModel) {
            payInfoCell.rightLabel.text = @"";
        }
        payInfoCell.rightLabel.textColor = UIColorFromRGB(60, 183, 0, 1);
        return payInfoCell;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    BATDrugOrderHeader *header = [[BATDrugOrderHeader alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
    [header setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0.5];

    switch (section) {
        case 0:
        {
            /*                  "LogisticState": 0,//物流状态 -1=待审核,0=已审核,1=已备货,2=已发货,3=配送中,4=已送达  */
            
            switch (self.logisticsModel.Data.LogisticState) {
                case -2:
                {
                    header.statusLaebl.text = @"待审核";
                }
                    break;
                case -1:
                {
                    header.statusLaebl.text = @"审核中";
                }
                    break;
                case 0:
                {
                    header.statusLaebl.text = @"已审核";
                }
                    break;
                case 1:
                {
                    header.statusLaebl.text = @"已备货";

                }
                    break;
                case 2:
                {
                    header.statusLaebl.text = @"已发货";

                }
                    break;
                case 3:
                {
                    header.statusLaebl.text = @"配送中";

                }
                    break;
                case 4:
                {
                    header.statusLaebl.text = @"已送达";

                }
                    break;
                default:
                    break;
            }
            
            if (!self.logisticsModel) {
                header.statusLaebl.text = @"";
            }
            header.statusLaebl.textColor = UIColorFromRGB(255, 0, 42, 1);
            header.titleLabel.text = @"物流信息";
        }
            break;
        case 1:
        {
            header.titleLabel.text = @"患者信息";
            header.statusLaebl.text = @"";
        }
            break;
        case 2:
        {
            header.titleLabel.text = @"订单信息";
            header.statusLaebl.text = [self.logisticsModel.Data.TradeTime substringToIndex:10];
            header.statusLaebl.textColor = [UIColor blackColor];
        }
            break;
        case 3:
        {
            header.titleLabel.text = @"支付信息";
            header.statusLaebl.text = @"";
        }
            break;
        default:
            break;
    }
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (section == 2) {
        
        BATDrugOrderHeader *footer = [[BATDrugOrderHeader alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
        [footer setTopBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0.5];
        
        
        BATDrugOrderListRecipeFilesModel *recipe = self.data.RecipeFiles > 0 ? self.data.RecipeFiles[0] : nil;
//        footer.statusLaebl.text = [NSString stringWithFormat:@"共计%@件商品 总价：%@",recipe.TCMQuantity,[NSString decimalNumberWithDouble:self.logisticsModel.Data.TotalFee]];
        NSAttributedString *atrStr = [[NSAttributedString alloc] initWithString:[NSString decimalNumberWithDouble:self.logisticsModel.Data.TotalFee] attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(249, 79, 79, 1)}];
        NSMutableAttributedString *tmpStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共计%@件商品 总价：",recipe.TCMQuantity]];
        [tmpStr appendAttributedString:atrStr];
        footer.statusLaebl.attributedText = tmpStr;
        
        [footer setBottomBorderWithColor:BASE_BACKGROUND_COLOR width:SCREEN_WIDTH height:10];
        return footer;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 2) {
        return 55;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        return 70;
    }
    
    return 45;
}

#pragma mark - net
- (void)requestLogisticalInfo {
  
    [HTTPTool requestWithKmWlyyBaseApiURLString:@"/Orders" parameters:@{@"OrderNo":self.data.Order.OrderNo} type:kGET success:^(id responseObject) {
        
        self.logisticsModel = [BATDrugOrderLogisticsModel mj_objectWithKeyValues:responseObject];
        
        [self.logisticsTableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - layout
- (void)layoutPages {
    
    self.title = @"物流详情";
    
    [self.view addSubview:self.logisticsTableView];
    [self.logisticsTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
}

#pragma mark - setter&getter
- (UITableView *)logisticsTableView {
    
    if (!_logisticsTableView) {
     
        _logisticsTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _logisticsTableView.backgroundColor = [UIColor clearColor];
        _logisticsTableView.showsVerticalScrollIndicator = NO;
        _logisticsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _logisticsTableView.rowHeight = 185;
        
        [_logisticsTableView registerClass:[BATDrugOrderCustomerTableViewCell class] forCellReuseIdentifier:CUSTOMER_CELL];
        [_logisticsTableView registerClass:[BATDrugOrderCommonInfoTableViewCell class] forCellReuseIdentifier:COMMON_CELL];
        [_logisticsTableView registerClass:[BATDrugOrderLogisticsInfoTableViewCell class] forCellReuseIdentifier:LOGISTICS_CELL];

        _logisticsTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 1)];
        _logisticsTableView.tableFooterView = [[UIView alloc] init];
        
        _logisticsTableView.delegate = self;
        _logisticsTableView.dataSource = self;
        
        _logisticsTableView.estimatedRowHeight = 0;
        _logisticsTableView.estimatedSectionHeaderHeight = 0;
        _logisticsTableView.estimatedSectionFooterHeight = 0;
    }
    return _logisticsTableView;
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
