//
//  BATDoctorStudioOrderDetailViewController.m
//  HealthBAT_Pro
//
//  Created by KM on 17/6/202017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDoctorStudioOrderDetailViewController.h"

#import "BATDoctorStudioOrderDetailTableViewCell.h"
#import "BATDoctorStudioOrderDetailOrderStatusTableViewCell.h"

static  NSString * const DETAIL_CELL = @"BATDoctorStudioOrderDetailTableViewCell";
static  NSString * const STATUS_CELL = @"BATDoctorStudioOrderDetailOrderStatusTableViewCell";

@interface BATDoctorStudioOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *orderDetailTableView;
@property (nonatomic,copy) NSArray *dataArray;

@end

@implementation BATDoctorStudioOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self layoutPageViews];
    
    self.dataArray = @[@[@""],@[@"订单编号",@"下单时间",@"订单类型",],@[@"支付状态",@"付款金额"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDeleagete && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *tmpArray = self.dataArray[section];
    return tmpArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        BATDoctorStudioOrderDetailOrderStatusTableViewCell *statusCell = [tableView dequeueReusableCellWithIdentifier:STATUS_CELL forIndexPath:indexPath];
        
        
        switch (self.orderStatus) {
            case BATDoctorStudioOrderStatus_Completion:
            {
                statusCell.iconImageView.image = [UIImage imageNamed:@"icon-cg"];
                statusCell.desLabel.text = @"订单已完成";
            }
                break;
            case BATDoctorStudioOrderStatus_Cancel:
            {
                statusCell.iconImageView.image = [UIImage imageNamed:@"icon-qx"];
                statusCell.desLabel.text = @"订单已取消";
            }
                break;
            case BATDoctorStudioOrderStatus_NoPay:
            {
                statusCell.iconImageView.image = [UIImage imageNamed:@"icon-qx"];
                statusCell.desLabel.text = @"订单未支付";
            }
                break;
            case BATDoctorStudioOrderStatus_Paid:
            {
                statusCell.iconImageView.image = [UIImage imageNamed:@"icon-cg"];
                statusCell.desLabel.text = @"订单已支付";
            }
                break;
            case BATDoctorStudioOrderStatus_NoCompletion:
            {
                statusCell.iconImageView.image = [UIImage imageNamed:@"icon-cg"];
                statusCell.desLabel.text = @"订单未完成";
            }
                break;
        }
        
        return statusCell;
    }
    
    BATDoctorStudioOrderDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DETAIL_CELL forIndexPath:indexPath];
    
    cell.titleLabel.text = self.dataArray[indexPath.section][indexPath.row];
    
    switch (indexPath.section) {
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    //订单编号
                    cell.desLabel.text = self.orderNo;
                }
                    break;
                case 1:
                {
                    //下单时间
                    cell.desLabel.text = self.createTime;
                }
                    break;
                case 2:
                {
                    //订单类型
                    switch (self.type) {
                        case BATDoctorStudioOrderType_Video:
                        {
                            cell.desLabel.text = @"视频咨询";
                        }
                            break;
                        case BATDoctorStudioOrderType_Audio:
                        {
                            cell.desLabel.text = @"语音咨询";
                        }
                            break;
                        case BATDoctorStudioOrderType_TextAndImage:
                        {
                            cell.desLabel.text = @"图文咨询";
                        }
                            break;
                        case BATDoctorStudioOrderType_HomeDoctor:
                        {
                            cell.desLabel.text = @"家庭医生";
                        }
                            break;
                    }
                }
                    break;
            }
        }
            break;
        case 2:
        {
            switch (indexPath.row) {
                case 0:
                {
                    //支付状态
                    switch (self.payStatus) {
                        case BATDoctorStudioPayStatus_NoPay:
                        {
                            cell.desLabel.text = @"未支付";
                        }
                            break;
                        case BATDoctorStudioPayStatus_Payed:
                        {
                            cell.desLabel.text = @"已支付";
                        }
                            break;
                        case BATDoctorStudioPayStatus_Refund:
                        {
                            cell.desLabel.text = @"已退款";
                        }
                            break;
                    }
                }
                    break;
                case 1:
                {
                    cell.desLabel.text = self.price;
                }
                    break;
    
            }
        }
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return 110;
    }
    
    return 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 10;
}

#pragma mark - layout
- (void)layoutPageViews {
    
    self.title = @"订单详情";
    
    [self.view addSubview:self.orderDetailTableView];
    [self.orderDetailTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
}

#pragma mark - getter
- (UITableView *)orderDetailTableView {
    
    if (!_orderDetailTableView) {
        
        _orderDetailTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _orderDetailTableView.backgroundColor = [UIColor clearColor];
        _orderDetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_orderDetailTableView registerClass:[BATDoctorStudioOrderDetailTableViewCell class] forCellReuseIdentifier:DETAIL_CELL];
        [_orderDetailTableView registerClass:[BATDoctorStudioOrderDetailOrderStatusTableViewCell class] forCellReuseIdentifier:STATUS_CELL];
        _orderDetailTableView.tableFooterView = [[UIView alloc] init];
        
        _orderDetailTableView.delegate = self;
        _orderDetailTableView.dataSource = self;
    }
    return _orderDetailTableView;
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
