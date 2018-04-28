//
//  BATDoctorStudioPaySuccessViewController.m
//  HealthBAT_Pro
//
//  Created by KM on 17/4/112017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDoctorStudioPaySuccessViewController.h"
#import "BATPaySuccessInfoTableViewCell.h"

#import "BATDoctorStudioChatViewController.h"
#import "BATDoctorStudioOrderListViewController.h"
#import "BATDoctorListViewController.h"

@interface BATDoctorStudioPaySuccessViewController ()<UITableViewDelegate,UITableViewDataSource,BATPaySuccessViewDelegate>


@end

@implementation BATDoctorStudioPaySuccessViewController

- (void)dealloc
{
    _paySuccessView.tableView.delegate = nil;
    _paySuccessView.tableView.dataSource = nil;
    _paySuccessView.delegate = nil;
}

- (void)loadView
{
    [super loadView];
    
    if (_paySuccessView == nil) {
        _paySuccessView = [[BATPaySuccessView alloc] init];
        _paySuccessView.tableView.delegate = self;
        _paySuccessView.tableView.dataSource = self;
        _paySuccessView.delegate = self;
        [self.view addSubview:_paySuccessView];
        
        WEAK_SELF(self);
        [_paySuccessView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.edges.equalTo(self.view);
        }];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"支付结果";
    
    //添加咨询过的医生通知
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDARA_CONSULTED_DOCTOR" object:self userInfo:nil];
    
    NSMutableArray *vcArray = [NSMutableArray array];
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if (vc == self.navigationController.viewControllers.firstObject) {
            [vcArray insertObject:vc atIndex:0];
        } else if (vc == self.navigationController.viewControllers.lastObject) {
            [vcArray addObject:vc];
        }
    }
    
    self.navigationController.viewControllers = vcArray;
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifer = @"DetailCell";
    BATPaySuccessInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (cell == nil) {
        cell = [[BATPaySuccessInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifer];
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"付款方式";
        cell.detailTextLabel.text = _payType;
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"交易编号";
        cell.detailTextLabel.text = _orderNo;
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"付款时间";
        cell.detailTextLabel.text = [Tools getCurrentDateStringByFormat:@"yyyy年MM月dd日 HH:mm"];
    } else if (indexPath.row == 3) {
        cell.textLabel.text = @"付款金额";
        cell.detailTextLabel.textColor = [UIColor redColor];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%@元",_momey];
    }
    
    return cell;
}

#pragma mark - BATPaySuccessViewDelegate
- (void)paySuccessViewCallBtnClickedAction
{
    
    switch (_type) {
        case BATDoctorStudioOrderType_Video:{
            //视频

            break;
        }
        case BATDoctorStudioOrderType_Audio: {
            //音频跳到订单列表
            
            BATDoctorStudioOrderListViewController *orderListVC = [[BATDoctorStudioOrderListViewController alloc] init];
            [orderListVC setTopTabSelected:1];
            [self.navigationController pushViewController:orderListVC animated:YES];
            
            //用订单列表界面，替换支付成功界面
            NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
            [tmpArray replaceObjectAtIndex:[tmpArray indexOfObject:self] withObject:[[BATDoctorListViewController alloc] init]];
            self.navigationController.viewControllers = tmpArray;
            
            break;
        }
        case BATDoctorStudioOrderType_TextAndImage: {
            //图文
            if (!self.model) {
            
                [self showErrorWithText:@"订单信息错误"];
                return;
            }
            
            //去聊天界面
            BATDoctorStudioChatViewController *chatVC = [[BATDoctorStudioChatViewController alloc] initWithConversationType:ConversationType_GROUP targetId:self.model.Data.RoomID];
            [[BATRongCloudManager sharedBATRongCloudManager] bat_saveRongCloudUserInfoWithUserId:self.model.Data.DoctorId name:self.model.Data.DoctorName portraitUri:self.model.Data.DoctorPhotoPath];
            chatVC.IllnessDescription = self.model.Data.IllnessDescription;
            chatVC.orderNo = self.model.Data.OrderNo;
            chatVC.patientName = self.model.Data.PatientName;
            chatVC.doctorName = self.model.Data.DoctorName;
            if (self.model.Data.Images.length > 0) {
                chatVC.images = [NSArray arrayWithArray:[self.model.Data.Images componentsSeparatedByString:@","]];
            }
            else {
                chatVC.images = @[];
            }
            chatVC.title = self.model.Data.DoctorName;
            chatVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:chatVC animated:YES];
            
            //用订单列表界面，替换支付成功界面
            NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
            [tmpArray replaceObjectAtIndex:[tmpArray indexOfObject:self] withObject:[[BATDoctorStudioOrderListViewController alloc] init]];
            self.navigationController.viewControllers = tmpArray;
            
            break;
        }
        case BATDoctorStudioOrderType_HomeDoctor: {
            
            break;
        }
            
    }
    
}

#pragma mark - NET


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
