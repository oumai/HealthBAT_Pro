//
//  BATDoctorStudioChatViewController.m
//  HealthBAT_Pro
//
//  Created by KM on 17/4/112017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDoctorStudioChatViewController.h"
#import "KMChatHeaderCollectionReusableView.h"
#import "BATNotificationMessage.h"
#import "BATComplaintController.h"
#import "IQKeyboardManager.h"//键盘管理

#import "BATLoginModel.h"

@implementation BATDoctorStudioChatViewController


- (void)dealloc
{
    DDLogDebug(@"%s",__func__);
    
    //清空block
    [[BATRongCloudManager sharedBATRongCloudManager] setContinueIMBlock:nil];
    [[BATRongCloudManager sharedBATRongCloudManager] setEndIMBlock:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (![[BATRongCloudManager sharedBATRongCloudManager] bat_getRongCloudStatus]) {
        BATLoginModel *login = LOGIN_INFO;
        
        [[BATRongCloudManager sharedBATRongCloudManager] bat_loginRongCloudWithToken:login.Data.RongCloudToken success:^(NSString *userId) {
            
        } error:^(RCConnectErrorCode status) {
            //登录异常
            [self showErrorWithText:@"通信异常，请稍后再试或尝试重新登录" completion:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        } tokenIncorrect:^{
            //token异常
            [self showErrorWithText:@"通信信息异常，请稍后再试或尝试重新登录" completion:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }];
    }
    
    
    //设置回应医生的block
    WEAK_SELF(self);
    [[BATRongCloudManager sharedBATRongCloudManager] setContinueIMBlock:^(NSString *orderNo){
        STRONG_SELF(self);
        if (![orderNo isEqualToString:self.orderNo]) {
            return ;
        }
        
         //继续聊天
    }];
    
    [[BATRongCloudManager sharedBATRongCloudManager] setEndIMBlock:^(NSString *orderNo){
        STRONG_SELF(self);
        if (![orderNo isEqualToString:self.orderNo]) {
            return ;
        }
        
        //改变订单状态,结束
        [self closeOrderRequest];
        
        //结束聊天，去评价界面
        BATComplaintController *complaintVC = [[BATComplaintController alloc] init];
        complaintVC.OrderMSTID = self.orderNo;
        complaintVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:complaintVC animated:YES];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BATDoctorStudioOrderListRefresh" object:nil];
        
    }];
    
    
    //sectionHeaderView
    [self.conversationMessageCollectionView registerNib:[UINib nibWithNibName:@"KMChatHeaderCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"KMChatHeaderCollectionReusableView"];
    
    [self.chatSessionInputBarControl.pluginBoardView removeItemWithTag:PLUGIN_BOARD_ITEM_LOCATION_TAG];
    
    self.displayUserNameInCell = NO;
    
    UIBarButtonItem *closeBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"投诉" style:UIBarButtonItemStylePlain handler:^(id sender) {
        
        STRONG_SELF(self);
        BATComplaintController *complaintVC = [[BATComplaintController alloc] init];
        complaintVC.OrderMSTID = self.orderNo;
        complaintVC.isComplaint = YES;
        complaintVC.hidesBottomBarWhenPushed = YES;
        [complaintVC setCommitSuccessBlock:^{
            //隐藏按钮
            self.navigationItem.rightBarButtonItem = nil;
            self.chatSessionInputBarControl.hidden = YES;
            //投诉成功，给医生发送投诉的自定义融云消息
            BATNotificationMessage *messageContent = [BATNotificationMessage messageWithActionStatus:[NSString stringWithFormat:@"%ld",(long)batDoctorStudioTextImageStatus_PatientComplain] orderNo:self.orderNo targetId:self.targetId doctorName:self.doctorName patientName:self.patientName];
            
            [[BATRongCloudManager sharedBATRongCloudManager] bat_sendRongCloudMessageWithType:ConversationType_GROUP targetId:self.targetId content:messageContent pushContent:[NSString stringWithFormat:@"患者%@已经对您投诉",self.patientName] pushData:nil success:^(long messageId) {
                
            } error:^(RCErrorCode nErrorCode, long messageId) {
                
            }];
            
        }];
        [self.navigationController pushViewController:complaintVC animated:YES];
    }];
    
    self.navigationItem.rightBarButtonItem = closeBarButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    
    if (self.status == BATDoctorStudioConsultStatus_ConsultEnd || self.status == BATDoctorStudioConsultStatus_ConsultCompletion) {
        self.navigationItem.rightBarButtonItem = nil;
        self.chatSessionInputBarControl.hidden = YES;
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - UICollectionViewDataSource
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    KMChatHeaderCollectionReusableView *sectionHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"KMChatHeaderCollectionReusableView" forIndexPath:indexPath];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"病症描述：" forKey:@"title"];
    [dic setObject:self.IllnessDescription forKey:@"detail"];
    [dic setObject:self.images forKey:@"images"];
    
    [sectionHeaderView reloadHeader:dic complete:^{
        
    }];
    
    return sectionHeaderView;
}


#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return [self calHeaderViewSize];
}

#pragma mark 计算headerView size
- (CGSize )calHeaderViewSize
{
    //计算标题size
    
    CGFloat titleHeight = [Tools calculateHeightWithText:@"病症描述:" width:SCREEN_WIDTH - 40.0f font:[UIFont systemFontOfSize:15]];
    
    //计算详情size
    CGFloat detailHeight = [Tools calculateHeightWithText:self.IllnessDescription width:SCREEN_WIDTH - 40.0f font:[UIFont systemFontOfSize:15]];
    
    //计算collection size
    NSArray *pics = self.images;
    
    float picCollectionHeight = 0;
    
    //列数 图片在collectionview 上显示多少列
    NSInteger column = 0;
    
    //计算列数
    //1、默认是6列
    //2、MainScreenWidth - 40 - 50，40为collectionview左右距离supview的长度总和，50为默认6列时，item的间隔宽度总和
    //3、((int)MainScreenWidth - 90) % 50 == 0 求余，判断是否能显示6列，如不能整除就列数减一
    //4、得出最终的列数
    if (((int)SCREEN_WIDTH - 90) % 50 > 0) {
        column = ((int)SCREEN_WIDTH - 90) / 50;
    } else {
        column = ((int)SCREEN_WIDTH - 90) / 50 - 1;
    }
    
    //计算行数
    NSInteger row = 0;
    
    //图片求余 得出行数
    if (pics.count % column == 0) {
        row = pics.count / column;
    } else {
        row = pics.count / column + 1;
    }
    
    //计算collection size height
    picCollectionHeight = row * 50 + 10 * (row - 1);
    
    //10-10-标题高度-8-详情高度-8-图片collection-10-10
    return CGSizeMake(SCREEN_WIDTH, 10 + 10 + titleHeight + 8 + detailHeight + 8 + picCollectionHeight + 10 + 10);
    
}

#pragma mark - NET
- (void)closeOrderRequest {
    
    [HTTPTool requestWithURLString:@"/api/order/CloseConsultOrder" parameters:@{@"orderNo":self.orderNo} type:kGET success:^(id responseObject) {
        //隐藏输出框
        self.chatSessionInputBarControl.hidden = YES;
        self.navigationItem.rightBarButtonItem = nil;
        [self.view endEditing:YES];
    } failure:^(NSError *error) {
        
    }];
}

@end
