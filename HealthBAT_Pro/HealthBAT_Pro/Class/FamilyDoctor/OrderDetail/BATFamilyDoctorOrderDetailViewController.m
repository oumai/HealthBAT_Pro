//
//  BATFamilyDoctorOrderDetailViewController.m
//  HealthBAT_Pro
//
//  Created by four on 2017/4/11.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATFamilyDoctorOrderDetailViewController.h"

#import "BATFamilyDoctorOrderDetailView.h"
#import "BATFamilyDoctorOrderInfoModel.h"
#import "BATFamilyDoctorOrderDetailBottomView.h"
#import "BATFamilyDoctorPaySuccessCell.h"
#import "BATComplaintController.h"
#import "BATPayViewController.h"
#import "BATContractDetailViewController.h"
#import "BATMyFamilyDoctorOrderListViewController.h"

#import "BATFamilyDoctorOrderInfoBottomCell.h"
#import "BATFamilyDoctorOrderInfoTopCell.h"
#import "BATFamilyDoctorOrderInfoMidCell.h"


static NSString *const OrderInfoBottomCell = @"BATFamilyDoctorOrderInfoBottomCell";
static NSString *const OrderInfoTopCell = @"BATFamilyDoctorOrderInfoTopCell";
static NSString *const OrderInfoMidCell = @"BATFamilyDoctorOrderInfoMidCell";
static NSString *const PaySuccessCell = @"BATFamilyDoctorPaySuccessCell";

@interface BATFamilyDoctorOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) BATFamilyDoctorOrderDetailView *orderStateView;

@property (nonatomic,strong) UITableView *familyDoctorOrderDetailTableView;

@property (nonatomic,strong) BATDefaultView *defaultView;

@property (nonatomic,strong) BATFamilyDoctorOrderInfoModel *orderInfoModel;

@property (nonatomic,strong) BATFamilyDoctorOrderDetailBottomView *bottomView;

@property (nonatomic,strong) UIAlertController *alert;

@end

@implementation BATFamilyDoctorOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self pagesLayout];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:@"FamilyDoctorEvaluationSuccess" object:nil];
    
//    self.paySuccess = YES;
    
    if (self.paySuccess == YES) {
        [self.orderStateView reloadViewWithData:BATFamilyDoctorOrderPaySuccess isComment:NO IsOrder:NO];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PaySuccess_popWaitService" object:nil];
        
        NSMutableArray *vcArray = [NSMutableArray array];
        
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if (vc == self.navigationController.viewControllers.firstObject) {
                [vcArray insertObject:vc atIndex:0];
            }else if ([vc isKindOfClass:[BATMyFamilyDoctorOrderListViewController class]]) {
                [vcArray addObject:vc];
            }else if (vc == self.navigationController.viewControllers.lastObject) {
                [vcArray addObject:vc];
            }
        }
        
        self.navigationController.viewControllers = vcArray;
        
    }else{
        [self requestAllOrderList];
    }

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - action

- (void)reloadData{
    [self requestAllOrderList];
    
    self.bottomView = nil;
    [self.view addSubview:self.bottomView];
}

- (void)updateBottomViewLayouts{
    [UIView animateWithDuration:0 animations:^{
        self.bottomView.frame = CGRectMake(0, SCREEN_HEIGHT - 64 - 45, SCREEN_WIDTH, 45);
    }];
}

- (void)showCancelAlertWithTitle:(NSString *)title action:(void (^)(UIAlertAction * _Nonnull action))action {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"再想一下" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:action];
    [alert addAction:cancelAction];
    [alert addAction:confirmAction];
    [self presentViewController:alert animated:YES completion:nil];
    
    self.alert = alert;
}

#pragma mark - net
- (void)requestAllOrderList{
    
    [HTTPTool requestWithURLString:@"/api/Order/GetFamilyDoctor" parameters:@{@"orderNo":self.orderNo} type:kGET success:^(id responseObject) {
        
        [self.familyDoctorOrderDetailTableView.mj_footer endRefreshing];
        [self.familyDoctorOrderDetailTableView.mj_header endRefreshing];
        
        self.orderInfoModel = [BATFamilyDoctorOrderInfoModel mj_objectWithKeyValues:responseObject];
        
        if (self.orderInfoModel.ResultCode == 0) {
            [self.familyDoctorOrderDetailTableView reloadData];
            
            [self.orderStateView reloadViewWithData:self.OrderStateShow isComment:self.orderInfoModel.Data.IsComment IsOrder:self.orderInfoModel.Data.IsOrder];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self updateBottomViewLayouts];
                [self.bottomView cellWithData:self.OrderStateShow isComment:self.orderInfoModel.Data.IsComment];
                
                });

        }else{
            [self.defaultView showDefaultView];
        }
        
    } failure:^(NSError *error) {
        [self.familyDoctorOrderDetailTableView.mj_footer endRefreshing];
        [self.familyDoctorOrderDetailTableView.mj_header endRefreshing];
        [self.defaultView showDefaultView];
    }];
    
}

/*
 取消订单
 */
- (void)requestCancelOrder:(NSString *)orderNO{
    
    
    [HTTPTool requestWithURLString:@"/api/order/CannelOrder" parameters:@{@"OrderNo":orderNO} type:kPOST success:^(id responseObject) {
        
        BOOL codeStr = [[responseObject objectForKey:@"Data"] boolValue];
        if (codeStr == YES) {
            
            [self showSuccessWithText:@"取消成功！"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self updateBottomViewLayouts];
                [self.bottomView cellWithData:0 isComment:self.orderInfoModel.Data.IsComment];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"BATFamilyDoctorDetail_Cancel" object:nil];
            });
            
        }
        
    } failure:^(NSError *error) {
        
        [self showErrorWithText:@"取消失败，请重新尝试!"];
    }];
    
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (self.paySuccess == YES) {
        return 1;
    }
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.paySuccess == YES) {
        return 1;
    }
    
    if (section==0) {
        return 1;
    }else if (section == 1){
        //有服务时间才显示4个
        return 1;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.paySuccess == YES) {
        BATFamilyDoctorPaySuccessCell *cell = [tableView dequeueReusableCellWithIdentifier:PaySuccessCell forIndexPath:indexPath];
        return cell;
    }

    if (indexPath.section ==0) {
        BATFamilyDoctorOrderInfoTopCell *cell = [tableView dequeueReusableCellWithIdentifier:OrderInfoTopCell];
        cell.nameDescLabel.text = self.orderInfoModel.Data.UserName;
        cell.phoneDescLabel.text = self.orderInfoModel.Data.PhoneNumber;
        cell.addressDescLabel.text = self.orderInfoModel.Data.Address;
        return cell;
        
    }else if (indexPath.section == 1){
        
        BATFamilyDoctorOrderInfoMidCell *cell = [tableView dequeueReusableCellWithIdentifier:OrderInfoMidCell];
        cell.serverTypeDescLabel.text = self.orderInfoModel.Data.OrderServerName;
        cell.serverDoctorNameDescLabel.text = self.orderInfoModel.Data.DoctorName;
        cell.consultServerDescLabel.text = [NSString stringWithFormat:@"%ld个月（%.2f元）",(long)self.orderInfoModel.Data.OrderServerTime,self.orderInfoModel.Data.OrderMoney];;
        cell.serverTimeDescLabel.text = self.orderInfoModel.Data.ServerTime;
        return cell;

    }else if (indexPath.section == 2){
         BATFamilyDoctorOrderInfoBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:OrderInfoBottomCell];
        cell.orderNumberDescLabel.text = self.orderInfoModel.Data.OrderNo;
        cell.serverCostDescLabel.text = [NSString stringWithFormat:@"￥%.2f",self.orderInfoModel.Data.OrderMoney];
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}



#pragma mark -pagesLayout
- (void)pagesLayout{
    self.title = @"订单详情";
    
    WEAK_SELF(self);
    [self.view addSubview:self.familyDoctorOrderDetailTableView];
    [self.familyDoctorOrderDetailTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-45);
    }];
    
    [self.view addSubview:self.bottomView];
    
    [self.view addSubview:self.defaultView];
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self.view);
    }];
}

#pragma mark -get&&set
- (BATFamilyDoctorOrderDetailView *)orderStateView{
    if (!_orderStateView) {
        _orderStateView = [[BATFamilyDoctorOrderDetailView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    }
    
    return _orderStateView;
}


- (UITableView *)familyDoctorOrderDetailTableView{
    if (!_familyDoctorOrderDetailTableView) {
        _familyDoctorOrderDetailTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _familyDoctorOrderDetailTableView.estimatedRowHeight = 200;
        _familyDoctorOrderDetailTableView.rowHeight = UITableViewAutomaticDimension;
        _familyDoctorOrderDetailTableView.delegate = self;
        _familyDoctorOrderDetailTableView.dataSource = self;
        _familyDoctorOrderDetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _familyDoctorOrderDetailTableView.backgroundColor = UIColorFromHEX(0xf1f1f1, 1);
        
      
        [_familyDoctorOrderDetailTableView registerClass:[BATFamilyDoctorPaySuccessCell class] forCellReuseIdentifier:PaySuccessCell];
        [_familyDoctorOrderDetailTableView registerClass:[BATFamilyDoctorOrderInfoBottomCell class] forCellReuseIdentifier:OrderInfoBottomCell];
        [_familyDoctorOrderDetailTableView registerClass:[BATFamilyDoctorOrderInfoTopCell class] forCellReuseIdentifier:OrderInfoTopCell];
        [_familyDoctorOrderDetailTableView registerClass:[BATFamilyDoctorOrderInfoMidCell class] forCellReuseIdentifier:OrderInfoMidCell];
        
        _familyDoctorOrderDetailTableView.tableHeaderView = self.orderStateView;
    }
    return _familyDoctorOrderDetailTableView;
}

- (BATFamilyDoctorOrderDetailBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[BATFamilyDoctorOrderDetailBottomView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 64, SCREEN_WIDTH, 45)];
        
        WEAK_SELF(self);
        switch (self.OrderStateShow) {
            case BATFamilyDoctorOrderCancel:
            {
                //订单已取消，只显示合同
            }
                break;
            case BATFamilyDoctorOrderWaitAccept:
            {
                //等待接单，显示取消订单、合同
                [self.bottomView setRequestBtnClickBlock:^{
                    DDLogInfo(@"取消订单！");
                    STRONG_SELF(self);
                    
                    [self showCancelAlertWithTitle:@"取消订单" action:^(UIAlertAction * _Nonnull action){
                        //用户点取消
                        [self requestCancelOrder:self.orderInfoModel.Data.OrderNo];
                    }];
                }];
            }
                break;
            case BATFamilyDoctorOrderWaitPay:
                //等待付款，支付、取消订单、合同
            {
                [self.bottomView setRequestBtnClickBlock:^{
                    DDLogInfo(@"支付！");
                    STRONG_SELF(self);
                    //进入支付界面
                    BATPayViewController *payVC = [[BATPayViewController alloc] init];
                    payVC.type = BATDoctorStudioOrderType_HomeDoctor;
                    payVC.orderNo = self.orderInfoModel.Data.OrderNo;
                    payVC.momey = [NSString stringWithFormat:@"%.2f",self.orderInfoModel.Data.OrderMoney];
                    [self.navigationController pushViewController:payVC animated:YES];
                }];
                
                [self.bottomView setCancelOrderBtnClickBlock:^{
                    DDLogInfo(@"取消订单！");
                    STRONG_SELF(self);
 
                    [self showCancelAlertWithTitle:@"取消订单" action:^(UIAlertAction * _Nonnull action){
                        //用户点取消
                        [self requestCancelOrder:self.orderInfoModel.Data.OrderNo];
                    }];

                }];
            }
                break;
            case BATFamilyDoctorOrderFinish:
                //已完成 评价、合同
            {
                [self.bottomView setRequestBtnClickBlock:^{
                    DDLogInfo(@"评价！");
                    STRONG_SELF(self);
                    BATComplaintController *complaintVC = [[BATComplaintController alloc] init];
                    complaintVC.OrderMSTID = self.orderInfoModel.Data.OrderNo;
                    complaintVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:complaintVC animated:YES];
                }];
            }
                break;
            case BATFamilyDoctorOrderHavePay:
                //已支付  合同
                break;
            default:
                break;
        }
        
        [self.bottomView setContractDetailBtnClickBlock:^{
            DDLogInfo(@"附件合同");
            STRONG_SELF(self);
            BATContractDetailViewController *contractDetail = [[BATContractDetailViewController alloc] init];
            
            contractDetail.orderNO = self.orderInfoModel.Data.OrderNo;
            contractDetail.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:contractDetail animated:YES];
        }];

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
            [self requestAllOrderList];
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
