//
//  BATPaySuccessViewController.m
//  HealthBAT
//
//  Created by jlteams on 16/8/2.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATPaySuccessViewController.h"
//#import "Masonry.h"
#import "BATPaySuccessInfoTableViewCell.h"
#import "BATPerson.h"
#import "BATChatConsultController.h"

//#import "WaitingViewController.h"
//#import "KMChatViewController.h"

//#define kQueueServer  @"www.jkbat.com"
//#define kQueuePort @"8806"

@interface BATPaySuccessViewController ()<UITableViewDelegate,UITableViewDataSource,BATPaySuccessViewDelegate>

@end

@implementation BATPaySuccessViewController

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

    self.navigationItem.title = @"支付成功";

    //添加咨询过的医生通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDARA_CONSULTED_DOCTOR" object:self userInfo:nil];
    
    NSMutableArray *vcArray = [NSMutableArray array];
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if (vc == self.navigationController.viewControllers.firstObject) {
            [vcArray insertObject:vc atIndex:0];
        } else if (vc == self.navigationController.viewControllers.lastObject) {
            [vcArray addObject:vc];
        }
    }
    
    self.navigationController.viewControllers = vcArray;
    
//    switch (_type) {
//        case kConsultTypeFree:
//        case kConsultTypeTextAndImage: {
//            [_paySuccessView.paySuccessFooterView.callBtn setTitle:@"咨询医生" forState:UIControlStateNormal];
//            break;
//        }
//        case kConsultTypeVideo: {
//            //视频
//            [_paySuccessView.paySuccessFooterView.callBtn setTitle:@"呼叫医生" forState:UIControlStateNormal];
//            
//            break;
//        }
//    }


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
        cell.detailTextLabel.text = [Tools getCurrentDateStringByFormat:@"yyyy年-MM月-dd日 hh:mm"];
    } else if (indexPath.row == 3) {
        cell.textLabel.text = @"付款金额";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%@元",_momey];
    }
    
    return cell;
}

#pragma mark - BATPaySuccessViewDelegate
- (void)paySuccessViewCallBtnClickedAction
{
 
    switch (_type) {
        case kConsultTypeFree:{
            //图文咨询＋免费咨询
            [self.navigationController popToRootViewControllerAnimated:YES];
            break;
        }
        case kConsultTypeTextAndImage: {
            //图文咨询＋免费咨询
             [self.navigationController popToRootViewControllerAnimated:YES];
            break;
        }
        case kConsultTypeVideo: {
            //视频
//            [self startAudioByType:kConsultTypeVideo];
            BATChatConsultController *chatCtl = [[BATChatConsultController alloc]init];
            chatCtl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:chatCtl animated:YES];
            break;
        }
        case kConsultTypeAudio: {
            //语音
//            [self startAudioByType:kConsultTypeVideo];
            BATChatConsultController *chatCtl = [[BATChatConsultController alloc]init];
            chatCtl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:chatCtl animated:YES];
            break;
        }
    }

}

#pragma mark Action
- (void)goToChatVC {
//    KMChatViewController *kmChatVC = [[KMChatViewController alloc] init];
//    kmChatVC.consultID = [NSString stringWithFormat:@"%ld",(long)_diseaseDescriptionModel.ID];
//    kmChatVC.doctiorPhotoPath = _doctiorPhotoPath;
//    kmChatVC.doctorName = _doctorName;
//    kmChatVC.accountID = _accountID;
//    [self.navigationController pushViewController:kmChatVC animated:YES];

}

- (void)startAudioByType:(NSInteger)type{
    
//    NSString *userName = @"";
//    
//    WaitingViewController *hallVC = [[WaitingViewController alloc] init];
//    hallVC.hidesBottomBarWhenPushed = YES;
////    hallVC.remainingTime = 1000;
//    hallVC.docId = _accountID;
//    hallVC.DoctorName = _doctorName;
//    hallVC.photoPath = _doctiorPhotoPath;
//    hallVC.serviceIn = YES;
//    hallVC.ConsultID = [NSString stringWithFormat:@"%ld",(long)_diseaseDescriptionModel.ID];
//    hallVC.service_Type = 2;
//    UserModel *user = [UserModel sharedUserModel];
//    userName = [NSString stringWithFormat:@"V_1_%@_%@",[user getSettingsValueWithKey:@"UserID"],[user getSettingsValueWithKey:@"UserName"]];
//    [AnyChatPlatform Connect:kQueueServer :[kQueuePort intValue]];
//    [AnyChatPlatform Login:userName :nil];
//    [self.navigationController pushViewController:hallVC animated:YES];


}


@end
