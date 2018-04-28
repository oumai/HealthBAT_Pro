//
//  BATOrderRequestViewController.m
//  HealthBAT_Pro
//
//  Created by four on 17/3/16.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATOrderRequestViewController.h"

#import "BATFamilyDoctorOrderInfoView.h"
#import "BATContractDetailViewController.h"
#import "BATFamilyDoctorOrderDetailModel.h"

#import "BATGraditorButton.h"

#import "BATMyFamilyDoctorOrderListViewController.h"

@interface BATOrderRequestViewController ()

@property (nonatomic,strong) BATFamilyDoctorOrderInfoView *familyDoctorOrderInfoView;

@property (nonatomic,strong) BATGraditorButton *buyButton;

@property (nonatomic,strong) BATDefaultView             *defaultView;

@property (nonatomic,strong) BATFamilyDoctorOrderDetailModel  *orderDetailModel;

@property (nonatomic,assign) BOOL           requestSuccess;

@end

@implementation BATOrderRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _requestSuccess = NO;
    
    [self pagesLayout];
    
    [self requestOrderDetail];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





#pragma mark - net
- (void)requestOrderDetail{

    [HTTPTool requestWithURLString:@"/api/FamilyDoctor/GetFamilyDoctorOrderEntity" parameters:@{@"orderNo":self.orderNO} type:kGET success:^(id responseObject) {

        
        self.orderDetailModel = [BATFamilyDoctorOrderDetailModel mj_objectWithKeyValues:responseObject];
        if (self.orderDetailModel.ResultCode == 0) {
            _requestSuccess = YES;
            [self.familyDoctorOrderInfoView loadFamilyDoctorOrderDetail:self.orderDetailModel];
        }
        
    } failure:^(NSError *error) {
        
        [self.defaultView showDefaultView];
    }];
}


- (void)requestBuyOrder{
    
    
    [HTTPTool requestWithURLString:@"/api/Order/SendOrderNotice" parameters:@{@"orderNo":self.orderNO} type:kGET success:^(id responseObject) {
        
        
        BOOL codeStr = [[responseObject objectForKey:@"Data"] boolValue];
        if (codeStr == YES) {
            //发送成功
            [self showText:@"已发送请求等待医生确认您的订单"];

            BATMyFamilyDoctorOrderListViewController *orderListVC = [[BATMyFamilyDoctorOrderListViewController alloc]init];
            orderListVC.selectedIndex = 0;
            orderListVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:orderListVC animated:YES];
            
            
            //延时操作，去掉栈中的结果页面
            [self bk_performBlock:^(id obj) {
                
                NSMutableArray *vcArray = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
                for (UIViewController *vc in self.navigationController.viewControllers) {
                   
                    if ([vc isKindOfClass:self.class]) {
                        [vcArray removeObject:vc];
                        self.navigationController.viewControllers = vcArray;
                        break;
                    }
                }
            } afterDelay:1.0];
            
        }
        
    } failure:^(NSError *error) {
        
        [self showErrorWithText:error.localizedDescription];
    }];
    
}

#pragma mark - pagesLayout

- (void)pagesLayout{

    self.title = @"订单请求";
    
    WEAK_SELF(self);
    [self.view addSubview:self.familyDoctorOrderInfoView];
    [self.familyDoctorOrderInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(170);
    }];
    
    [self.view addSubview:self.buyButton];
    [self.buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.top.equalTo(self.familyDoctorOrderInfoView.mas_bottom).offset(80);
        make.height.mas_equalTo(50);
    }];
    
    [self.view addSubview:self.defaultView];
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - set&get

- (BATFamilyDoctorOrderInfoView *)familyDoctorOrderInfoView{
    if (!_familyDoctorOrderInfoView) {
        _familyDoctorOrderInfoView = [[BATFamilyDoctorOrderInfoView alloc]initWithFrame:CGRectZero];
        _familyDoctorOrderInfoView.userInteractionEnabled = YES;
        [_familyDoctorOrderInfoView bk_whenTapped:^{
            
            BATContractDetailViewController *detailVC = [[BATContractDetailViewController alloc]init];
            detailVC.orderNO = self.orderDetailModel.Data.OrderNo;
            detailVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detailVC animated:YES];
            
        }];
    }
    return _familyDoctorOrderInfoView;
}


//- (UIButton *)buyButton{
//    if (!_buyButton) {
//        _buyButton = [UIButton buttonWithType:UIButtonTypeCustom Title:@"发送请求" titleColor:[UIColor whiteColor] backgroundColor:BASE_COLOR backgroundImage:nil Font:[UIFont systemFontOfSize:20]];
//        _buyButton.layer.cornerRadius = 8.f;
//        [_buyButton bk_whenTapped:^{
//           
//            DDLogInfo(@"开始跳转购买！");
//            if (_requestSuccess == YES) {
//                [self requestBuyOrder];
//            }else{
//                [self requestOrderDetail];
//            }
//            
//        }];
//    }
//    return _buyButton;
//}


- (BATGraditorButton *)buyButton{
    
    if (!_buyButton) {
        _buyButton = [[BATGraditorButton alloc] initWithFrame:CGRectZero];
        [_buyButton setTitle:@"发送请求" forState:UIControlStateNormal] ;
        _buyButton.enablehollowOut = YES;
        _buyButton.titleLabel.font = [UIFont systemFontOfSize:20];
        _buyButton.titleColor = [UIColor whiteColor];
        _buyButton.clipsToBounds = YES;
        _buyButton.layer.cornerRadius = 5.f;
        [_buyButton setGradientColors:@[START_COLOR,END_COLOR]];
        [_buyButton bk_whenTapped:^{
            
            DDLogInfo(@"购买服务！");
            DDLogInfo(@"开始跳转购买！");
            if (_requestSuccess == YES) {
                [self requestBuyOrder];
            }else{
                [self requestOrderDetail];
            }
        }];
    }
    return _buyButton;
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
            [self requestOrderDetail];
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
