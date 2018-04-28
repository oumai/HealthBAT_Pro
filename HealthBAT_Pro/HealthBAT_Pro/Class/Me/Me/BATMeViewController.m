//
//  MeViewController.m
//  HealthBAT_Pro
//
//  Created by KM on 16/7/62016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATMeViewController.h"
#import "BATMeTableViewCell.h"
#import "BATPerson.h"
#import "BATLoginModel.h"
#import "BATMessageModel.h"
#import "BATChooseTreatmentPersonController.h"
#import "BATLoginViewController.h"
#import "BATMySetViewController.h"
#import "BATCollectionTypeListViewController.h"
#import "BATAddressManageViewController.h"
//#import "BATPersonInfoViewController.h"
 #import "BATAddressListViewController.h"
#import "BATServiceRecordViewController.h"
#import "BATUserPersonCenterViewController.h"
#import "BATMyFollowViewController.h"
#import "BATMyFansViewController.h"
//#import "BATFileListController.h"
#import "BATChatConsultController.h"
#import "BATMallOrderViewController.h"
#import "BATMessageCenterViewController.h"
#import "WZLBadgeImport.h"
#import "BATMyFamilyDoctorOrderListViewController.h"
#import "BATTopicPersonController.h"
#import "UIScrollView+ScalableCover.h"
#import "BATComplaintController.h"
#import "BATDoctorStudioOrderListViewController.h"
#import "BATHealthFilesListVC.h"
#import "BATMyPromoCodeViewController.h"
#import "BATTumorOrderViewController.h" // 肿瘤订单
#import "BATDrugOrderListViewController.h"//药品订单
#import "BATPersonDetailController.h"
#import "BATConsultationIndexViewController.h"
#import "BATMemberCenterViewController.h"

#import "BATBackRoundGuideFloatingView.h" //RoundGuide浮窗
#import "BATMeSectionHeaderView.h"        //区头View
#import "BATMemberInfoModel.h"

//#import "BATBuyOTCViewController.h"

@interface BATMeViewController ()

/**
 *  数据源
 */
@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,strong) BATBackRoundGuideFloatingView *backRoundGuideFloatingView;

@property (nonatomic,assign) CGPoint beginPoint;

@end

@implementation BATMeViewController

- (void)dealloc
{
    _meView.tableView.delegate = nil;
    _meView.tableView.dataSource = nil;
    _meView.userInfoView.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadView
{
    [super loadView];
    
    if (_meView == nil) {
        _meView = [[BATMeView alloc] init];
        _meView.tableView.delegate = self;
        _meView.tableView.dataSource = self;
        _meView.userInfoView.delegate = self;
        [self.view addSubview:_meView];
        
        WEAK_SELF(self);
        [_meView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.right.equalTo(self.view);
//            .with.insets(UIEdgeInsetsMake(-20, 0, 0, 0));
            if(@available(iOS 11.0, *)) {
                make.top.equalTo(@0);
            }
            else {
                make.top.equalTo(@-20);
            }

            if (@available(iOS 11.0,*)) {
                if (iPhoneX) {
                    make.bottom.equalTo(@(-83));
                }
                else {
                    make.bottom.equalTo(@(-49));
                }
            } else {
                make.bottom.equalTo(self.view);
            }

        }];
    }
    
    [self.view addSubview:self.backRoundGuideFloatingView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestAllData) name:@"Me" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(meNewAPNSMessage) name:@"NEW_APNS_MESSAGE" object:nil];
    
    //设置数据源
    /*
     就医订单  文案 改成 医生工作室订单；
     咨询订单  文案 改成 咨询医生订单；
     家庭服务订单 文案 改成 家庭医生订单；
     
     */
    _dataSource = [NSMutableArray arrayWithObjects:
                   
                   @[
//                     @{@"title":@"个人资料",@"image":@"person_grzl"},
                     @{@"title":@"就诊人管理",@"image":@"personCenter_Health_archives"},
                     @{@"title":@"我的收藏",@"image":@"personCenter_collect"},
                     @{@"title":@"会员中心",@"image":@"personCenter_collect"},
                     //@{@"title":@"我的优惠码",@"image":@"personCenter_yhm"},
                     ],
                   
                   @[
                     @{@"title":@"防癌筛查订单",@"image":@"icon_fatj"},
                     @{@"title":@"药品订单",@"image":@"icon-wdcfd"},
                     @{@"title":@"我的收货地址",@"image":@"icon-wdshd"},
                     ],
                   @[
                     
                     //@{@"title":@"咨询医生订单",@"image":@"personCenter_zixun"},
                     @{@"title":@"医生工作室订单",@"image":@"personCenter_jydd"},
                     @{@"title":@"物流订单",@"image":@"personCenter_logistics"},
                     @{@"title":@"服务记录",@"image":@"personCenter_Service_record"},
                     
                     ],
                   
                   @[
                     @{@"title":@"设置",@"image":@"personCenter_setting"},
                     @{@"title":@"客服电话",@"image":@"personCenter_phone"},
                     ],
                   
                   nil];
    
    if (!LOGIN_STATION) {
        //未登录
        PRESENT_LOGIN_VC
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)meNewAPNSMessage {
    
    //    if ([[UIApplication sharedApplication] applicationIconBadgeNumber]>0) {
    //        [self.meView.userInfoView.messageButton.imageView showBadge];
    //    }else{
    //        [self.meView.userInfoView.messageButton.imageView clearBadge];
    //    }
    
    [self getDataResquest];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    //    self.backRoundGuideFloatingView.hidden = !self.isFromRoundGuide;
    
    if (!LOGIN_STATION) {
        [_meView.userInfoView configureWithModel:nil];
        
        [self.meView.tableView reloadData];
    }
    else {
        //已经登陆
        [self personInfoListRequest];
        
        //        if ([[UIApplication sharedApplication] applicationIconBadgeNumber]>0) {
        //            [self.meView.userInfoView.messageButton.imageView showBadge];
        //        }else{
        //            [self.meView.userInfoView.messageButton.imageView clearBadge];
        //        }
        
        [self getDataResquest];
        
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}


#pragma mark - UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sectionArray = _dataSource[section];
    
    return sectionArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 ? 120 : 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (section != 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 10)];
        return view;
    }

    BATMeSectionHeaderView *sectionView = [[BATMeSectionHeaderView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 120)];
    
    [sectionView setPushNextVCBlock:^(NSInteger integer){
        
        if (!LOGIN_STATION) {
            PRESENT_LOGIN_VC;
            return ;
        }
        
        if (integer == 0) {
            
            BATMyPromoCodeViewController *promoCodeVC = [[BATMyPromoCodeViewController alloc]init];
            promoCodeVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:promoCodeVC animated:YES];
        }
        else if (integer == 1)
        {
            //            BATConsultationIndexViewController * consulationVC = [BATConsultationIndexViewController new];
            //            consulationVC.hidesBottomBarWhenPushed = YES;
            //            consulationVC.isPersoncenter = YES;
            //            [self.navigationController pushViewController:consulationVC animated:YES];
            //咨询医生订单
            if (CANCONSULT) {
                BATChatConsultController *chatCtl = [[BATChatConsultController alloc]init];
                chatCtl.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:chatCtl animated:YES];
            }else {
                [self showText:@"您好,咨询功能升级中\n请稍后再试!"];
            }
            
            
        }
        else if (integer == 2)
        {
            //家庭服务订单
            
            BATMyFamilyDoctorOrderListViewController *myFamilyDoctorOrderListVC = [[BATMyFamilyDoctorOrderListViewController alloc]init];
            myFamilyDoctorOrderListVC.hidesBottomBarWhenPushed = YES;
            myFamilyDoctorOrderListVC.selectedIndex = 0;
            [self.navigationController pushViewController:myFamilyDoctorOrderListVC animated:YES];
        }
    }];
    return sectionView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"BATMeTableViewCell";
    BATMeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell = [[BATMeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (_dataSource.count > 0) {
    
        NSArray *sectionArray = _dataSource[indexPath.section];
        
        NSDictionary *dict = sectionArray[indexPath.row];
        cell.iconImageView.image= [UIImage imageNamed:dict[@"image"]];
        cell.titleLabel.text = [NSString stringWithFormat:@"%@",dict[@"title"]];
        
        if (indexPath.section == 0 && indexPath.row == 2) {
            cell.stateImageView.hidden = NO;
            
            BATMemberInfoModel *memberInfoModel = MEMBER_INFO;
            
            if (memberInfoModel.Data.Status != 0) {
                //vip用户显示续费
                cell.stateImageView.image = [UIImage imageNamed:@"btn-xf"];
            } else {
                //非vip用户显示购买
                cell.stateImageView.image = [UIImage imageNamed:@"btn-gm"];
            }
            
        } else {
            cell.stateImageView.hidden = YES;
        }
        
    }
    
    return cell;
}


#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //判断是否登录状态
    if (!LOGIN_STATION) {
        PRESENT_LOGIN_VC
        return;
    }
    
    if (indexPath.section == 0){
//        if (indexPath.row == 0) {
//
//            //个人资料
//            BATPersonInfoViewController *personInfoVC = [[BATPersonInfoViewController alloc]init];
//
//            //隐藏tabBar
//            personInfoVC.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:personInfoVC animated:YES];
//        }else
            if (indexPath.row == 0) {
            //健康档案
            if (CANCONSULT) {
                BATHealthFilesListVC *treatmentCtl = [[BATHealthFilesListVC alloc]init];
                treatmentCtl.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:treatmentCtl animated:YES];
            }else {
                [self showText:@"您好,健康档案升级中\n请稍后再试!"];
            }
            
        } else if (indexPath.row == 1) {
            //我的收藏
            BATCollectionTypeListViewController *collectionVC = [[BATCollectionTypeListViewController alloc]init];
            collectionVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:collectionVC animated:YES];
        } else if (indexPath.row == 2) {
//            //我的优惠码
//            BATMyPromoCodeViewController *promoCodeVC = [[BATMyPromoCodeViewController alloc]init];
//            promoCodeVC.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:promoCodeVC animated:YES];
            
            BATMemberCenterViewController *memberCenterVC = [[BATMemberCenterViewController alloc] init];
            memberCenterVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:memberCenterVC animated:YES];
        }
    }else if(indexPath.section == 1){
        switch (indexPath.row) {
            case 0: {
                //防癌筛查订单
                BATTumorOrderViewController *serviceRecordVC = [[BATTumorOrderViewController alloc]init];
                serviceRecordVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:serviceRecordVC animated:YES];
            }
                break;
            case 1: {
                //药品订单
                BATDrugOrderListViewController *drugOrderVC = [[BATDrugOrderListViewController alloc]init];
                drugOrderVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:drugOrderVC animated:YES];
            }
                break;
            case 2: {
                //我的收获地址
                BATAddressManageViewController *addressManageVC = [[BATAddressManageViewController alloc] init];
                addressManageVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:addressManageVC animated:YES];
            }
                break;
        }
    }else if(indexPath.section == 2){
        switch (indexPath.row) {
            case 0: {
                //医生工作室订单
                BATDoctorStudioOrderListViewController *serviceRecordVC = [[BATDoctorStudioOrderListViewController alloc]init];
                serviceRecordVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:serviceRecordVC animated:YES];
            }
                break;
            case 1:{
                //物流订单
                BATMallOrderViewController *mallOrderVC = [[BATMallOrderViewController alloc] init];
                mallOrderVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:mallOrderVC animated:YES];
            }
                break;
            case 2:{
                //服务纪录
                BATServiceRecordViewController *serviceRecordVC = [[BATServiceRecordViewController alloc]init];
                serviceRecordVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:serviceRecordVC animated:YES];
            }
                break;
        }
    }else if(indexPath.section == 3){
        if (indexPath.row == 0) {
            //设置
            BATMySetViewController *mySetVC = [[BATMySetViewController alloc]init];
            mySetVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:mySetVC animated:YES];
        } else if (indexPath.row == 1) {
            //客服电话
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"呼叫客服:4008886158转1" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认呼叫" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                dispatch_queue_t queue = dispatch_queue_create("com.HealthBAT.tel", NULL);
                
                dispatch_async(queue, ^{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:4008886158"]];
                });
                
            }];
            
            [alert addAction:cancelAction];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}

#pragma mark - UITouch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    
    if (touch.view == self.backRoundGuideFloatingView) {
        self.beginPoint = [touch locationInView:self.backRoundGuideFloatingView];
    }
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    if (touch.view == self.backRoundGuideFloatingView) {
        
        CGPoint currentPosition = [touch locationInView:self.backRoundGuideFloatingView];
        
        //偏移量
        float offsetX = currentPosition.x - self.beginPoint.x;
        float offsetY = currentPosition.y - self.beginPoint.y;
        
        //移动后的中心坐标
        self.backRoundGuideFloatingView.center = CGPointMake(self.backRoundGuideFloatingView.center.x + offsetX, self.backRoundGuideFloatingView.center.y + offsetY);
        
        if (self.backRoundGuideFloatingView.center.x != self.backRoundGuideFloatingView.frame.size.width / 2) {
            CGFloat x = self.backRoundGuideFloatingView.frame.size.width/2;
            CGFloat y = self.backRoundGuideFloatingView.center.y;
            
            self.backRoundGuideFloatingView.center = CGPointMake(x, y);
        }
        
        //y轴上下极限坐标
        if (self.backRoundGuideFloatingView.center.y > (self.backRoundGuideFloatingView.superview.frame.size.height-self.backRoundGuideFloatingView.frame.size.height/2)-49) {
            CGFloat x = self.backRoundGuideFloatingView.center.x;
            CGFloat y = self.backRoundGuideFloatingView.superview.frame.size.height-self.backRoundGuideFloatingView.frame.size.height/2-49;
            
            self.backRoundGuideFloatingView.center = CGPointMake(x, y);
        }
        else if (self.backRoundGuideFloatingView.center.y <= (self.backRoundGuideFloatingView.frame.size.height/2 + 20)) {
            CGFloat x = self.backRoundGuideFloatingView.center.x;
            CGFloat y = (self.backRoundGuideFloatingView.frame.size.height/2 + 20);
            
            self.backRoundGuideFloatingView.center = CGPointMake(x, y);
        }
    }
    
}


#pragma mark - private
- (void)requestAllData {
    
    if (LOGIN_STATION) {
        [self personInfoListRequest];
    }
}

#pragma mark - NET
- (void)personInfoListRequest {
    [HTTPTool requestWithURLString:@"/api/Patient/Info" parameters:nil type:kGET success:^(id responseObject) {
        
        BATPerson *person = [BATPerson mj_objectWithKeyValues:responseObject];
        
        if (person.ResultCode == 0) {
            
            [_meView.userInfoView configureWithModel:person];
            
            [self.meView.tableView reloadData];
            
            //保存个人信息
            NSString *file = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Person.data"];
            [NSKeyedArchiver archiveRootObject:person toFile:file];
            
            //获取用户数据成功
            [[NSNotificationCenter defaultCenter] postNotificationName:BATLoginSuccessGetUserInfoSucessNotification object:person];
            
        }
        
    } failure:^(NSError *error) {
    }];
}

//消息列表
- (void)getDataResquest{
    
    if (!LOGIN_STATION) {
        
        return;
    }
    
    [HTTPTool requestWithURLString:@"/api/MessagePush/GetAllMessageLst?pageIndex=0&pageSize=10" parameters:nil type:kGET success:^(id responseObject) {
        
        
        NSInteger unReadNums = 0;
        
        BATMessageModel *messageModel = [BATMessageModel mj_objectWithKeyValues:responseObject];
        
        for(BATMessagesData *pic in messageModel.Data) {
            
            unReadNums = unReadNums + pic.MsgCount;
        }
        
        if (unReadNums > 0) {
            [self.meView.userInfoView.messageButton.imageView showBadge];
        } else {
            [self.meView.userInfoView.messageButton.imageView clearBadge];
        }
        
        //判断是否还有未读数据
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:unReadNums];
        [JPUSHService setBadge:unReadNums];
        
        
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark UserInfoViewDelegate
- (void)showAvatorAction
{
    if (!LOGIN_STATION) {
        PRESENT_LOGIN_VC;
        return;
    }
    //    [SJAvatarBrowser showImage:_meView.userInfoView.avatorImageView];
    
    
    //新个人主页控制器
    
    BATPerson *person = PERSON_INFO;
    BATPersonDetailController *personVC = [[BATPersonDetailController alloc]init];
    personVC.accountID = [NSString stringWithFormat:@"%zd",person.Data.AccountID];
    personVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:personVC animated:YES];
    
    
    /*
     旧个人主页控制器
     BATPerson *person = PERSON_INFO;
     BATTopicPersonController *personVC = [[BATTopicPersonController alloc]init];
     personVC.accountID = [NSString stringWithFormat:@"%zd",person.Data.AccountID];
     personVC.hidesBottomBarWhenPushed = YES;
     [self.navigationController pushViewController:personVC animated:YES];
     */
}

//- (void)showMyFriendAction
//{
//    //判断是否登录状态
//    if (!LOGIN_STATION) {
//        PRESENT_LOGIN_VC
//        return;
//    }
//
//
//    BATMyFollowViewController *myFollowVC = [[BATMyFollowViewController alloc] init];
//    myFollowVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:myFollowVC animated:YES];
//}

//- (void)showMyFansAction
//{
//    //判断是否登录状态
//    if (!LOGIN_STATION) {
//        PRESENT_LOGIN_VC
//        return;
//    }
//
//
//    BATMyFansViewController *myFansVC = [[BATMyFansViewController alloc] init];
//    myFansVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:myFansVC animated:YES];
//
//}

- (void)goLoginAction
{
    PRESENT_LOGIN_VC
}

- (void)goMessageCenterAction{

    BATMessageCenterViewController *messageCenterVC = [[BATMessageCenterViewController alloc] init];
    messageCenterVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:messageCenterVC animated:YES];
}

//- (void)goUserInfoAction
//{
//    //    //个人信息
//    BATPersonInfoViewController *personInfoVC = [[BATPersonInfoViewController alloc]init];
//    //隐藏tabBar
//    personInfoVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:personInfoVC animated:YES];
//}

#pragma mark - setter && getter
- (BATBackRoundGuideFloatingView *)backRoundGuideFloatingView
{
    if (_backRoundGuideFloatingView == nil) {
        
        _backRoundGuideFloatingView = [[BATBackRoundGuideFloatingView alloc] initWithFrame:CGRectMake(0, 20, 91, 23.5)];

        if (iPhoneX) {
            _backRoundGuideFloatingView.frame = CGRectMake(0, 40, 91, 23.5);
        }

        _backRoundGuideFloatingView.hidden = NO;
        
        
    }
    return _backRoundGuideFloatingView;
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
