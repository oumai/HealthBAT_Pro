//
//  MQChatViewController.m
//  MeiQiaSDK
//
//  Created by ijinmao on 15/10/28.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "MQChatViewController.h"
#import "MQChatViewTableDataSource.h"
#import "MQChatViewService.h"
#import "MQCellModelProtocol.h"
#import "MQChatDeviceUtil.h"
#import "MQInputBar.h"
#import "MQToast.h"
#import "MQRecordView.h"
#import "MQBundleUtil.h"
#import "MQImageUtil.h"
#import "MQDefinition.h"
#import "MQEvaluationView.h"
#import "MQAssetUtil.h"
#import "MQStringSizeUtil.h"
#import "MQTransitioningAnimation.h"
#import "UIView+Layout.h"
#import "MQCustomizedUIText.h"
#import "IQKeyboardManager.h"//键盘管理
#import "BATMoreView.h"

#import "BATVideoView.h"
#import "BATNewMessageModel.h"

#import "BATDieaseInfoDeatilController.h"
#import "BATRootTabBarController.h"
#import "BATWriteSingleDiseaseViewController.h"
#import "BATCheckDetailViewController.h"

static CGFloat const kMQChatViewInputBarHeight = 50.0;
#ifdef INCLUDE_MEIQIA_SDK
@interface MQChatViewController () <UITableViewDelegate, MQChatViewServiceDelegate, MQInputBarDelegate, UIImagePickerControllerDelegate, MQChatTableViewDelegate, MQChatCellDelegate, MQRecordViewDelegate, MQServiceToViewInterfaceErrorDelegate,UINavigationControllerDelegate, MQEvaluationViewDelegate>
#else
@interface MQChatViewController () <UITableViewDelegate, MQChatViewServiceDelegate, MQInputBarDelegate, UIImagePickerControllerDelegate, MQChatTableViewDelegate, MQChatCellDelegate, MQRecordViewDelegate,UINavigationControllerDelegate, MQEvaluationViewDelegate,TIMMessageListener>
#endif

@end

@interface MQChatViewController()

@property (nonatomic, strong) id evaluateBarButtonItem;//保存隐藏的barButtonItem

@end

@implementation MQChatViewController {
    MQChatViewConfig *chatViewConfig;
    MQChatViewTableDataSource *tableDataSource;
    MQChatViewService *chatViewService;
    MQInputBar *chatInputBar;
    MQRecordView *recordView;
    MQEvaluationView *evaluationView;
    
    BATMoreView *moreView;
    
    BOOL isMQCommunicationFailed;  //判断是否通信没有连接上
    UIStatusBarStyle previousStatusBarStyle;//当前statusBar样式
    BOOL previousStatusBarHidden;   //调出聊天视图界面前是否隐藏 statusBar
    
    BATVideoView *batVideoView;
    UIAlertController *alert;
    BATNewMessageModel *model;
    UIPanGestureRecognizer *panGestureRecognizer;
    BOOL isVideoView;

    BOOL isPop;
    BOOL isChangeNaviHeight;
}

- (void)dealloc {
    NSLog(@"清除chatViewController");
    [self removeDelegateAndObserver];
    [chatViewConfig setConfigToDefault];
    [chatViewService setCurrentInputtingText:chatInputBar.textView.text];
#ifdef INCLUDE_MEIQIA_SDK
    [self closeMeiqiaChatView];
#endif
    [MQCustomizedUIText reset];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithChatViewManager:(MQChatViewConfig *)config {
    if (self = [super init]) {
        chatViewConfig = config;
    }
    return  self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handelWithMessage:) name:@"CUSTOM_MESSAGE" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goDiseaseDetailVC:) name:@"GO_DISEASE_DETAIL_VC" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goAskDoctorVC:) name:@"GO_ASK_DOCTOR_VC" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickOTCMessage:) name:BATClickOTCMessageNotification object:nil];
   
    //监测导航栏变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (layoutControllerSubViews) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    isChangeNaviHeight = NO;

    previousStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
    previousStatusBarHidden = [UIApplication sharedApplication].statusBarHidden;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
//    [[UIApplication sharedApplication] setStatusBarStyle:[MQChatViewConfig sharedConfig].chatViewStyle.statusBarStyle];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;

    [self setNeedsStatusBarAppearanceUpdate];
    
    self.view.backgroundColor = [MQChatViewConfig sharedConfig].chatViewStyle.backgroundColor ?: [UIColor colorWithWhite:0.95 alpha:1];
    [self setNavBar];
    [self initChatTableView];
    [self initchatViewService];
    [self initEvaluationView];
    [self initTableViewDataSource];
    [self initMoreView];
    [self initInputBar];
    chatViewService.chatViewWidth = self.chatTableView.frame.size.width;
    [chatViewService sendLocalWelcomeChatMessage];
    
#ifdef INCLUDE_MEIQIA_SDK
    [self updateNavBarTitle:[MQBundleUtil localizedStringForKey:@"wait_agent"]];
    isMQCommunicationFailed = NO;
    [self addObserver];
#endif    
    
    [_chatTableView startLoadingTopRefreshView];

    if (chatViewConfig.firstMessage.length > 0) {
        [self sendTextMessage:chatViewConfig.firstMessage];
    }

    BOOL result =  [[NSUserDefaults standardUserDefaults] boolForKey:@"startVideo"];
    if (result == YES) {
        
        isVideoView = YES;
        
        //发起视频聊天，图文上添加视频界面
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self creatVideoView];
        
            panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(moveView:)];
            
            [self changeRoomStateRequestWithState:BATChatRoomState_Consulting];
        });
       
    }
}

- (void)layoutControllerSubViews{
    
        //改变了
        isChangeNaviHeight = YES;
        batVideoView.frame = CGRectMake(batVideoView.orgin.x, 84, batVideoView.frame.size.width, batVideoView.frame.size.height);
    
        CGRect inputBarFrame = CGRectMake(self.chatTableView.frame.origin.x, self.chatTableView.frame.origin.y+self.chatTableView.frame.size.height - kMQChatViewInputBarHeight - 20, self.chatTableView.frame.size.width, kMQChatViewInputBarHeight);
        [chatInputBar updateFrame:inputBarFrame];

}

#pragma mark - 视频聊天代码
- (void)creatVideoView{
    NSString *channelStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"AGDKeyChannel"];
    NSString *chanelKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"AGDKeyVendorKey"];
    
    //最新聊天UI
    batVideoView = [[BATVideoView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 44)];
    batVideoView.backgroundColor = [UIColor lightGrayColor];
    batVideoView.AGDKeyChannel = channelStr;
    batVideoView.AGDKeyVendorKey = chanelKey;
    [batVideoView joinWithKey:chanelKey andWithChannel:channelStr];
    [[UIApplication sharedApplication].keyWindow addSubview:batVideoView];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:batVideoView];
}

- (void)moveView:(UIPanGestureRecognizer *)pan{
    CGPoint point = [pan translationInView:self.view];
    NSLog(@"X:%f;Y:%f",point.x,point.y);
    
    pan.view.center = CGPointMake(pan.view.center.x + point.x, pan.view.center.y + point.y);
    [pan setTranslation:CGPointMake(0, 0) inView:self.view];
    
    if (pan.view.center.x - batVideoView.frame.size.width/2.0 < 0) {
        [UIView animateWithDuration:0.25 animations:^{
            batVideoView.frame = CGRectMake(0, isChangeNaviHeight == YES?pan.view.center.y - batVideoView.frame.size.height/2.0 + 20:pan.view.center.y - batVideoView.frame.size.height/2.0, batVideoView.frame.size.width, batVideoView.frame.size.height);
        }];
    }
    
    if (pan.view.center.x + batVideoView.frame.size.width/2.0 > SCREEN_WIDTH) {
        [UIView animateWithDuration:0.25 animations:^{
            batVideoView.frame = CGRectMake(SCREEN_WIDTH - batVideoView.frame.size.width,isChangeNaviHeight == YES? pan.view.center.y - batVideoView.frame.size.height/2.0 + 20:pan.view.center.y - batVideoView.frame.size.height/2.0 ,batVideoView.frame.size.width, batVideoView.frame.size.height);
        }];
    }
    
    if (pan.view.center.y + batVideoView.frame.size.height/2.0 > SCREEN_HEIGHT - 50) {
        [UIView animateWithDuration:0.25 animations:^{
            batVideoView.frame = CGRectMake(pan.view.center.x - batVideoView.frame.size.width/2.0,SCREEN_HEIGHT - 50 - batVideoView.frame.size.height , batVideoView.frame.size.width, batVideoView.frame.size.height);
        }];
    }
    
    if (pan.view.center.y - batVideoView.frame.size.height/2.0 < 64) {
        [UIView animateWithDuration:0.25 animations:^{
            batVideoView.frame = CGRectMake(pan.view.center.x - batVideoView.frame.size.width/2.0, isChangeNaviHeight == YES ? 64 + 20:64 , batVideoView.frame.size.width, batVideoView.frame.size.height);
        }];
    }
}

- (void)keyboardWillShow:(NSNotification *)info{
    BOOL result =  [[NSUserDefaults standardUserDefaults] boolForKey:@"startVideo"];
    if (result && isVideoView == NO) {
        [UIView animateWithDuration:0.25 animations:^{
            batVideoView.frame = CGRectMake(batVideoView.frame.origin.x, isChangeNaviHeight == YES ?84:64, batVideoView.frame.size.width, batVideoView.frame.size.height);
        }];
    }
    
}

- (void)goDiseaseDetailVC:(NSNotification *)noti {

    BATDieaseInfoDeatilController *diseaseInfoDetailVC = [[BATDieaseInfoDeatilController alloc] init];
    diseaseInfoDetailVC.type = [noti.userInfo[@"TypeID"] integerValue];
    diseaseInfoDetailVC.ID = noti.userInfo[@"DiseaseID"];
    [self.navigationController pushViewController:diseaseInfoDetailVC animated:YES];
}


- (void)goAskDoctorVC:(NSNotification *)noti {


    if (!LOGIN_STATION) {
        PRESENT_LOGIN_VC;
        return;
    }

    BATWriteSingleDiseaseViewController *writeSingleDiseaseVC = [[BATWriteSingleDiseaseViewController alloc]init];
    writeSingleDiseaseVC.type = kConsultTypeFree;
    writeSingleDiseaseVC.pathName = @"咨询-免费咨询";
    writeSingleDiseaseVC.IsFreeClinicr = NO;
    writeSingleDiseaseVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:writeSingleDiseaseVC animated:YES];


//    [self dismissChatViewController];
//
//    UIWindow *mainWindow = MAIN_WINDOW;
//    BATRootTabBarController *rootTabBar = (BATRootTabBarController *)mainWindow.rootViewController;
//    UINavigationController * nav = rootTabBar.viewControllers[0];
//    [nav popToRootViewControllerAnimated:NO];
//
//    [rootTabBar setSelectedIndex:2];




//    [mainWindow.rootViewController.tabBarController setSelectedIndex:2];
//    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - 在图文咨询中点击OTC消息
- (void)clickOTCMessage:(NSNotification *)notification
{
    
    NSDictionary *data = [notification object];
    
    BATCheckDetailViewController *checkDetailVC = [[BATCheckDetailViewController alloc] init];
    checkDetailVC.OPDRegisterID = data[@"OPDRegisterID"];
    checkDetailVC.RecipeFileUrl = data[@"RecipeImgUrl"];
//    checkDetailVC.RecipeFileID = data[@"RecipeFileID"];
    checkDetailVC.RecipeNo = data[@"RecipeNo"];
//    checkDetailVC.RecipeName = data[@"RecipeName"];
//    checkDetailVC.Amount = data[@"Amount"];
//    checkDetailVC.ReplaceDose = [data[@"ReplaceDose"] integerValue];
//    checkDetailVC.ReplacePrice = data[@"ReplacePrice"];
//    checkDetailVC.TCMQuantity = [data[@"TCMQuantity"] integerValue];
    checkDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:checkDetailVC animated:YES];
    
}

//#pragma mark - TIMMessageListener
//- (void)onNewMessage:(NSArray*) msgs {
//    
//    //接受消息，判断当前状态
//    for (TIMMessage *message in msgs) {
//        int cnt = [message elemCount];
//        
//        for (int i = 0; i < cnt; i++) {
//            TIMElem * elem = [message getElem:i];
//            
//            if ([elem isKindOfClass:[TIMCustomElem class]]) {
//                TIMCustomElem * customElem = (TIMCustomElem * )elem;
//                
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wdeprecated-declarations"
//                if ([customElem.ext isEqualToString:@"Room.StateChanged"]) {
//                    NSString *string = [[NSString alloc] initWithData:customElem.data encoding:NSUTF8StringEncoding];
//                    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//                    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
//                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//                    DDLogError(@"%@",dic);
//                    
//                    [self handelWithMessage:dic];
//                }
//#pragma clang diagnostic pop
//                
//            }
//        }
//    }
//}

#pragma mark - private
- (void)handelWithMessage:(NSNotification *)info {
    NSDictionary *dic = info.userInfo;
    model = [BATNewMessageModel mj_objectWithKeyValues:dic];
    
    switch (model.ServiceType) {
        case kDoctorServerWordImageType: {
            
            break;
        }
        case kDoctorServerAudioType: {
            //音频
            switch (model.State) {

                case BATChatRoomState_NoVisit: {
                    
                    break;
                }
                case BATChatRoomState_Waiting: {
                    [alert dismissViewControllerAnimated:YES completion:nil];
                    
                    break;
                }
                case BATChatRoomState_Consulting: {
                    
                    break;
                }
                case BATChatRoomState_Consulted: {
                    //医生离开
                    [self showCancelAlertWithTitle:@"结束服务" action:^(UIAlertAction * _Nonnull action){
                        [self changeRoomStateRequestWithState:BATChatRoomState_Consulted];
                        [[BATTIMManager sharedBATTIM] bat_removeMessagelistener:self];
                        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                    }];
                    break;
                }
                case BATChatRoomState_Calling: {
                    
                }
                case BATChatRoomState_Leaving: {
                    //医生离开
                    [self showCancelAlertWithTitle:@"中断服务" action:^(UIAlertAction * _Nonnull action){
                        [self changeRoomStateRequestWithState:BATChatRoomState_NoVisit];
                        [[BATTIMManager sharedBATTIM] bat_removeMessagelistener:self];
                        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                    }];
                    break;
                }
            }
            break;
        }
        case kDoctorServerVideoType: {
            
            switch (model.State) {
                case BATChatRoomState_NoVisit: {
                    
                    break;
                }
                case BATChatRoomState_Waiting: {

                }
                case BATChatRoomState_Consulting: {
                    
                    break;
                }
                case BATChatRoomState_Consulted: {
                    //医生离开
                    [self showCancelAlertWithTitle:@"结束服务" action:^(UIAlertAction * _Nonnull action){
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:BATENDSEVERICE object:nil];
                        
                        [self changeRoomStateRequestWithState:BATChatRoomState_Consulted];
                        
                        [[BATTIMManager sharedBATTIM] bat_removeMessagelistener:self];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"QUIT_CHATView_OF_VIDEO" object:self];
                        
                        [batVideoView.agoraKit leaveChannel:^(AgoraRtcStats *stat) {
                            
                        }];
                        
                        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                    }];

                    break;
                }
                case BATChatRoomState_Calling: {

                }
                case BATChatRoomState_Leaving: {
                    [self.view endEditing:YES];
                    //医生离开
                    [self showCancelAlertWithTitle:@"中断服务" action:^(UIAlertAction * _Nonnull action){
                        
                        [self changeRoomStateRequestWithState:BATChatRoomState_NoVisit];
                        
                        [[BATTIMManager sharedBATTIM] bat_removeMessagelistener:self];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"QUIT_CHATView_OF_VIDEO" object:self];
                        
                        [batVideoView.agoraKit leaveChannel:^(AgoraRtcStats *stat) {
                            
                        }];
                        
                        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                    }];
                    
                    break;
                }


            }
            
            break;
        }
        case kDoctorServerHomeDoctor: {
            
            break;
        }
        case kDoctorServerRemote: {
            
            break;
        }
    }
}

- (void)showCancelAlertWithTitle:(NSString *)title action:(void (^)(UIAlertAction * _Nonnull action))action {
    
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        
//        [self changeRoomStateRequestWithState:BATChatRoomState_Consulting];
//        
//    }];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"离开" style:UIAlertActionStyleDestructive handler:action];
//    [alertView addAction:cancelAction];
    [alertView addAction:confirmAction];
    [self presentViewController:alertView animated:YES completion:nil];
    
    alert = alertView;
}

#pragma mark - net
//改变状态
- (void)changeRoomStateRequestWithState:(BATChatRoomState)state {
    
    NSString *roomID = [[NSUserDefaults standardUserDefaults] objectForKey:@"AGDKeyChannel"];
    
    if (roomID) {
        [HTTPTool requestWithURLString:@"/api/NetworkMedical/UpdateRoomState" parameters:@{@"ChannelID":roomID,@"State":@(state)} type:kGET success:^(id responseObject) {
            
            DDLogDebug(@"===============改变状态成功了===============");
        } failure:^(NSError *error) {
            DDLogDebug(@"===============改变状态失败了===============");
            
        }];
    }
    

}

#pragma mark - 视频聊天代码

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    isPop = YES;

    [[NSNotificationCenter defaultCenter] postNotificationName:MQAudioPlayerDidInterruptNotification object:nil];
    
    //只有视频咨询的时候才走
    BOOL result =  [[NSUserDefaults standardUserDefaults] boolForKey:@"startVideo"];
    if (result) {
        [batVideoView removeFromSuperview];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"startVideo"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //离开聊天房间
//        [self changeRoomStateRequestWithState:BATChatRoomState_CutConnection];
        [batVideoView.agoraKit leaveChannel:^(AgoraRtcStats *stat) {
            
        }];
    }
    

//    //当横屏时，恢复原来的 statusBar 是否 hidden
//    if (viewSize.height < viewSize.width) {
//        [[UIApplication sharedApplication] setStatusBarHidden:previousStatusBarHidden];
//    }
//    //恢复原来的导航栏透明模式
//    self.navigationController.navigationBar.translucent = previousStatusBarTranslucent;
//    //恢复原来的导航栏时间条
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;

    [[IQKeyboardManager sharedManager] setEnable:YES];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //更新view frame
    if (isPop == NO) {
        [self updateContentViewsFrame];

    }

    [[IQKeyboardManager sharedManager] setEnable:NO];

}

- (void)viewWillDisappear:(BOOL)animated {
    [batVideoView removeFromSuperview];
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIView setAnimationsEnabled:YES];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissChatViewController {
    //移除房间数据
    NSUserDefaults *roomIDDefaults = [NSUserDefaults standardUserDefaults];
    [roomIDDefaults removeObjectForKey:@"TalkRoomIDDefaults"];
    
    
    if ([MQChatViewConfig sharedConfig].presentingAnimation == MQTransiteAnimationTypePush) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self.view.window.layer addAnimation:[MQTransitioningAnimation createDismissingTransiteAnimation:[MQChatViewConfig sharedConfig].presentingAnimation] forKey:nil];
            [self dismissViewControllerAnimated:NO completion:nil];
        }
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)addObserver {
#ifdef INCLUDE_MEIQIA_SDK
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMQCommunicationErrorNotification:) name:MQ_COMMUNICATION_FAILED_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveRefreshOutgoingAvatarNotification:) name:MQChatTableViewShouldRefresh object:nil];
#endif
}

- (void)removeDelegateAndObserver {
    self.navigationController.delegate = nil;
    chatViewService.delegate = nil;
    tableDataSource.chatCellDelegate = nil;
    self.chatTableView.chatTableViewDelegate = nil;
    self.chatTableView.delegate = nil;
    chatInputBar.delegate = nil;
    recordView.recordViewDelegate = nil;
#ifdef INCLUDE_MEIQIA_SDK
    chatViewService.errorDelegate = nil;
#endif
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma 初始化viewModel
- (void)initchatViewService {
    chatViewService = [[MQChatViewService alloc] init];
    chatViewService.delegate = self;
#ifdef INCLUDE_MEIQIA_SDK
    chatViewService.errorDelegate = self;
#endif
}

#pragma 初始化tableView dataSource
- (void)initTableViewDataSource {
    tableDataSource = [[MQChatViewTableDataSource alloc] initWithChatViewService:chatViewService];
    tableDataSource.chatCellDelegate = self;
    self.chatTableView.dataSource = tableDataSource;
}

#pragma 初始化所有Views
/**
 * 初始化聊天的tableView
 */
- (void)initChatTableView {
    [self setChatTableViewFrame];
    self.chatTableView = [[MQChatTableView alloc] initWithFrame:chatViewConfig.chatViewFrame style:UITableViewStylePlain];
    self.chatTableView.contentInset = UIEdgeInsetsMake(0, 0, kMQChatViewInputBarHeight, 0);
    self.chatTableView.chatTableViewDelegate = self;
    self.chatTableView.delegate = self;
    [self.view addSubview:self.chatTableView];
}

/**
 * 初始化聊天的inpur bar
 */
- (void)initInputBar {
    CGRect inputBarFrame = CGRectMake(self.chatTableView.frame.origin.x, self.chatTableView.frame.origin.y+self.chatTableView.frame.size.height, self.chatTableView.frame.size.width, kMQChatViewInputBarHeight);
//    chatInputBar = [[MQInputBar alloc] initWithFrame:inputBarFrame
//                                           superView:self.view
//                                           tableView:self.chatTableView
//                                     enableSendVoice:[MQChatViewConfig sharedConfig].enableSendVoiceMessage
//                                     enableSendImage:[MQChatViewConfig sharedConfig].enableSendImageMessage
//                                    photoSenderImage:[MQChatViewConfig sharedConfig].photoSenderImage
//                               photoHighlightedImage:[MQChatViewConfig sharedConfig].photoSenderHighlightedImage
//                                    voiceSenderImage:[MQChatViewConfig sharedConfig].voiceSenderImage
//                               voiceHighlightedImage:[MQChatViewConfig sharedConfig].voiceSenderHighlightedImage
//                                 keyboardSenderImage:[MQChatViewConfig sharedConfig].keyboardSenderImage
//                            keyboardHighlightedImage:[MQChatViewConfig sharedConfig].keyboardSenderHighlightedImage
//                                 resignKeyboardImage:[MQChatViewConfig sharedConfig].resignKeyboardImage
//                      resignKeyboardHighlightedImage:[MQChatViewConfig sharedConfig].resignKeyboardHighlightedImage];

    if (chatViewConfig.isSearchDisease) {
        chatInputBar = [[MQInputBar alloc] initWithFrame:inputBarFrame
                                               superView:self.view
                                               tableView:self.chatTableView
                                         isSearchDisease:[MQChatViewConfig sharedConfig].isSearchDisease
                                         enableSendVoice:[MQChatViewConfig sharedConfig].enableSendVoiceMessage
                                         enableSendImage:[MQChatViewConfig sharedConfig].enableSendImageMessage
                                        photoSenderImage:[MQChatViewConfig sharedConfig].photoSenderImage
                                   photoHighlightedImage:[MQChatViewConfig sharedConfig].photoSenderHighlightedImage
                                        voiceSenderImage:[MQChatViewConfig sharedConfig].voiceSenderImage
                                   voiceHighlightedImage:[MQChatViewConfig sharedConfig].voiceSenderHighlightedImage
                                     keyboardSenderImage:[MQChatViewConfig sharedConfig].keyboardSenderImage
                                keyboardHighlightedImage:[MQChatViewConfig sharedConfig].keyboardSenderHighlightedImage
                                     resignKeyboardImage:[MQChatViewConfig sharedConfig].resignKeyboardImage
                          resignKeyboardHighlightedImage:[MQChatViewConfig sharedConfig].resignKeyboardHighlightedImage];
    }
    else {

        chatInputBar = [[MQInputBar alloc] initWithFrame:inputBarFrame
                                               superView:self.view
                                               tableView:self.chatTableView
                                                moreView:moreView
                                         enableSendVoice:[MQChatViewConfig sharedConfig].enableSendVoiceMessage
                                         enableSendImage:[MQChatViewConfig sharedConfig].enableSendImageMessage
                                        photoSenderImage:[MQChatViewConfig sharedConfig].photoSenderImage
                                   photoHighlightedImage:[MQChatViewConfig sharedConfig].photoSenderHighlightedImage
                                        voiceSenderImage:[MQChatViewConfig sharedConfig].voiceSenderImage
                                   voiceHighlightedImage:[MQChatViewConfig sharedConfig].voiceSenderHighlightedImage
                                     keyboardSenderImage:[MQChatViewConfig sharedConfig].keyboardSenderImage
                                keyboardHighlightedImage:[MQChatViewConfig sharedConfig].keyboardSenderHighlightedImage
                                     resignKeyboardImage:[MQChatViewConfig sharedConfig].resignKeyboardImage
                          resignKeyboardHighlightedImage:[MQChatViewConfig sharedConfig].resignKeyboardHighlightedImage];
    }


    chatInputBar.delegate = self;
    [self.view addSubview:chatInputBar];
    chatInputBar.textView.text = [chatViewService getPreviousInputtingText];
    self.inputBarView = chatInputBar;
    self.inputBarTextView = chatInputBar.textView.internalTextView;

    self.inputBarView.hidden = [MQChatViewConfig sharedConfig].isHideInPutBar;

    
}

- (void)initMoreView {
    
    CGRect moreViewFrame = CGRectMake(self.chatTableView.frame.origin.x, self.view.frame.size.height, self.chatTableView.frame.size.width, 80);
    
    moreView = [[BATMoreView alloc] initWithFrame:moreViewFrame];
    
//    [self.view addSubview:moreView];
}

/**
 * 初始化评价的 alertView
 */
- (void)initEvaluationView {
    evaluationView = [[MQEvaluationView alloc] init];
    evaluationView.delegate = self;
}

#pragma 添加消息通知的observer
- (void)setNotificationObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resignKeyboardFirstResponder:) name:MQChatViewKeyboardResignFirstResponderNotification object:nil];
}

#pragma 消息通知observer的处理函数
- (void)resignKeyboardFirstResponder:(NSNotification *)notification {
    [self.view endEditing:true];
}

#pragma MQChatTableViewDelegate
- (void)didTapChatTableView:(UITableView *)tableView {
    [self.view endEditing:true];
}

//下拉刷新，获取以前的消息
- (void)startLoadingTopMessagesInTableView:(UITableView *)tableView {
//#ifndef INCLUDE_MEIQIA_SDK
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.chatTableView finishLoadingTopRefreshViewWithCellNumber:1 isLoadOver:true];
//    });
//#else
//    [chatViewService startGettingHistoryMessages];
//#endif
    
    [chatViewService startGettingHistoryMessages:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.chatTableView finishLoadingTopRefreshViewWithCellNumber:1 isLoadOver:true];
        });
    }];
}

//上拉刷新，获取更新的消息
- (void)startLoadingBottomMessagesInTableView:(UITableView *)tableView {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.chatTableView finishLoadingBottomRefreshView];
    });
}

#pragma 编辑导航栏 - Demo用到的收取消息按钮
- (void)setNavBar {
    if ([MQChatViewConfig sharedConfig].didSetStatusBarStyle) {
//        [UIApplication sharedApplication].statusBarStyle = [MQChatViewConfig sharedConfig].statusBarStyle;
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    if ([MQChatViewConfig sharedConfig].navBarRightButton) {
        return;
    }
    BOOL result =  [[NSUserDefaults standardUserDefaults] boolForKey:@"startVideo"];
    if (result == YES) {
        UIBarButtonItem *changeChatType = [[UIBarButtonItem alloc]initWithTitle:@"聊天切换" style:(UIBarButtonItemStylePlain) target:self action:@selector(tapNavigationRightBtnOfChangeChatType:)];
        self.navigationItem.rightBarButtonItem = changeChatType;
        
        UIBarButtonItem *quitChatType = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_zixun_Over"] style:UIBarButtonItemStylePlain target:self action:@selector(levelRoomAndQuitChatViewController:)];
        self.navigationItem.leftBarButtonItem = quitChatType;
    }
//#ifndef INCLUDE_MEIQIA_SDK
//    UIBarButtonItem *loadMessageButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"收取消息" style:(UIBarButtonItemStylePlain) target:self action:@selector(tapNavigationRightBtn:)];
//    self.navigationItem.rightBarButtonItem = loadMessageButtonItem;
//#else
//    if (![MQChatViewConfig sharedConfig].enableEvaluationButton) {
//        return;
//    }
//    
//    UIBarButtonItem *rightNavButtonItem = [[UIBarButtonItem alloc]initWithTitle:[MQBundleUtil localizedStringForKey:@"meiqia_evaluation_sheet"] style:(UIBarButtonItemStylePlain) target:self action:@selector(tapNavigationRightBtn:)];
//    self.navigationItem.rightBarButtonItem = rightNavButtonItem;
//#endif
}

- (void)tapNavigationRightBtn:(id)sender {
#ifndef INCLUDE_MEIQIA_SDK
    [chatViewService loadLastMessage];
    [self chatTableViewScrollToBottomWithAnimated:true];
    //显示评价
    [evaluationView showEvaluationAlertView];
#else
    [self showEvaluationAlertView];
#endif
}


#pragma mark - 视频界面
- (void)tapNavigationRightBtnOfChangeChatType:(id)sender {
    
    [self.view endEditing:YES];
    BOOL result =  [[NSUserDefaults standardUserDefaults] boolForKey:@"startVideo"];
    batVideoView.bgView.backgroundColor = [UIColor clearColor];
    batVideoView.remoteView.backgroundColor = [UIColor clearColor];
    batVideoView.localView.backgroundColor = [UIColor clearColor];
    
    if (result == YES) {
        if (isVideoView == YES) {
            //增加视频界面变形操作
            UIBarButtonItem *changeChatType = [[UIBarButtonItem alloc]initWithTitle:@"视频切换" style:(UIBarButtonItemStylePlain) target:self action:@selector(tapNavigationRightBtnOfChangeChatType:)];
            self.navigationItem.rightBarButtonItem = changeChatType;

            [UIView animateWithDuration:1 animations:^{
                
                if (isChangeNaviHeight) {
                     batVideoView.frame = CGRectMake(SCREEN_WIDTH - 130, 64  + 20 , 130, 165);
                }else{
                     batVideoView.frame = CGRectMake(SCREEN_WIDTH - 130, 64, 130, 165);
                }
               
                batVideoView.localView.hidden = YES;
                isVideoView = NO;
                

                [batVideoView addGestureRecognizer:panGestureRecognizer];
            }];
        }else{
            //增加视频界面变形操作
            UIBarButtonItem *changeChatType = [[UIBarButtonItem alloc]initWithTitle:@"聊天切换" style:(UIBarButtonItemStylePlain) target:self action:@selector(tapNavigationRightBtnOfChangeChatType:)];
            self.navigationItem.rightBarButtonItem = changeChatType;

            [UIView animateWithDuration:1 animations:^{

//                batVideoView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
                if (isChangeNaviHeight) {
                    batVideoView.frame = CGRectMake(0, 64 + 20, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 20);
                }else{
                    batVideoView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
                }
                batVideoView.localView.hidden = NO;
                isVideoView = YES;
                
                [batVideoView removeGestureRecognizer:panGestureRecognizer];
            }];
            
        }
    }

}

- (void)levelRoomAndQuitChatViewController:(id)sender {
    [self.view endEditing:YES];

    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"是否离开" message:nil preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"离开" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"QUIT_CHATView_OF_VIDEO" object:self];

        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }];

    [alertView addAction:cancelAction];
    [alertView addAction:confirmAction];
    [self presentViewController:alertView animated:YES completion:nil];
}

- (void)didSelectNavigationRightButton {
    NSLog(@"点击了自定义导航栏右键，开发者可在这里增加功能。");
}

#pragma UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<MQCellModelProtocol> cellModel = [chatViewService.cellModels objectAtIndex:indexPath.row];
    return [cellModel getCellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    
//    DDLogDebug(@"%@",chatViewService.cellModels);    
}

#pragma UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.chatTableView scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.chatTableView scrollViewDidScroll:scrollView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self.chatTableView scrollViewDidEndScrollingAnimation:scrollView];
}

#pragma MQChatViewServiceDelegate
- (void)hideRightBarButtonItem:(BOOL)enabled {
    //如果开发者自定义了导航栏右键，则不隐藏
    if ([MQChatViewConfig sharedConfig].navBarRightButton) {
        return;
    }
    
    if (enabled) {
        self.evaluateBarButtonItem = self.navigationItem.rightBarButtonItem;
        self.navigationItem.rightBarButtonItem = nil;
    } else {
        if (self.evaluateBarButtonItem) {
            self.navigationItem.rightBarButtonItem = self.evaluateBarButtonItem;
        }
    }
}

- (void)didGetHistoryMessagesWithCellNumber:(NSInteger)cellNumber isLoadOver:(BOOL)isLoadOver{
    [self.chatTableView finishLoadingTopRefreshViewWithCellNumber:cellNumber isLoadOver:isLoadOver];
//    [self.chatTableView reloadData];
    [self reloadChatTableView];
}

- (void)didUpdateCellModelWithIndexPath:(NSIndexPath *)indexPath {
    [self.chatTableView updateTableViewAtIndexPath:indexPath];
}

- (void)reloadChatTableView {
    CGSize preContentSize = self.chatTableView.contentSize;
    [self.chatTableView reloadData];
    if (!CGSizeEqualToSize(preContentSize, self.chatTableView.contentSize)) {
        [self scrollTableViewToBottom];
    }
}

- (void)scrollTableViewToBottom {
    [self chatTableViewScrollToBottomWithAnimated:false];
}

- (void)showEvaluationAlertView {
    [chatInputBar.textView resignFirstResponder];
    [evaluationView showEvaluationAlertView];
}

- (BOOL)isChatRecording {
    return [recordView isRecording];
}

#ifdef INCLUDE_MEIQIA_SDK
- (void)didScheduleClientWithViewTitle:(NSString *)viewTitle agentStatus:(MQChatAgentStatus)agentStatus{
    [self updateNavTitleWithAgentName:viewTitle agentStatus:agentStatus];
}
#endif

- (void)didReceiveMessage {
    //判断是否显示新消息提示
    if ([self.chatTableView isTableViewScrolledToBottom]) {
        [self chatTableViewScrollToBottomWithAnimated:true];
    } else {
        if ([MQChatViewConfig sharedConfig].enableShowNewMessageAlert) {
            [MQToast showToast:[MQBundleUtil localizedStringForKey:@"display_new_message"] duration:1.5 window:self.view];
        }
    }
}

- (void)showToastViewWithContent:(NSString *)content {
    [MQToast showToast:content duration:1.0 window:self.view];
}

#pragma MQInputBarDelegate
-(BOOL)sendTextMessage:(NSString*)text {
    if (self.isInitializing) {
        [MQToast showToast:@"wait_agent" duration:3 window:self.view];
        return NO;
    }

    if (chatViewConfig.isSearchDisease == YES) {
        //查病界面，模拟发送
        [chatViewService searchDiseaseSendTextMessageWithContent:text];
    }
    else {
        //咨询界面
        [chatViewService sendTextMessageWithContent:text];
    }

    [self chatTableViewScrollToBottomWithAnimated:true];
    return YES;
}

-(void)sendImageWithSourceType:(UIImagePickerControllerSourceType)sourceType {
    NSString *mediaPermission = [MQChatDeviceUtil isDeviceSupportImageSourceType:(int)sourceType];
    if (!mediaPermission) {
        return;
    }
    if (![mediaPermission isEqualToString:@"ok"]) {
        [MQToast showToast:[MQBundleUtil localizedStringForKey:mediaPermission] duration:2 window:self.view];
        return;
    }
    
    self.navigationController.delegate = self;
    //兼容ipad打不开相册问题，使用队列延迟
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType               = (int)sourceType;
        picker.delegate                 = (id)self;
        picker.modalPresentationStyle = UIModalPresentationOverFullScreen;
        picker.view.backgroundColor = [UIColor whiteColor];
        [self presentViewController:picker animated:YES completion:nil];
    }];
}

-(void)inputting:(NSString*)content {
    //用户正在输入
    [chatViewService sendUserInputtingWithContent:content];
}

-(void)chatTableViewScrollToBottomWithAnimated:(BOOL)animated {
    NSInteger lastCellIndex = chatViewService.cellModels.count;
    if (lastCellIndex == 0) {
        return;
    }
    [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:lastCellIndex-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:animated];
}

-(void)beginRecord:(CGPoint)point {
    if (TARGET_IPHONE_SIMULATOR){
        [MQToast showToast:[MQBundleUtil localizedStringForKey:@"simulator_not_support_microphone"] duration:2 window:self.view];
        return;
    }
    
    //停止播放的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:MQAudioPlayerDidInterruptNotification object:nil];
    
    //判断是否开启了语音权限
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        //首先记录点击语音的时间，如果第一次授权，则确定授权的时间会较长，这时不应该初始化record view
        CGFloat tapVoiceTimeInMilliSeconds = [NSDate timeIntervalSinceReferenceDate] * 1000;
        [MQChatDeviceUtil isDeviceSupportMicrophoneWithPermission:^(BOOL permission) {
            CGFloat getPermissionTimeInMilliSeconds = [NSDate timeIntervalSinceReferenceDate] * 1000;
            if (getPermissionTimeInMilliSeconds - tapVoiceTimeInMilliSeconds > 100) {
                return ;
            }
            if (permission) {
                [self initRecordView];
            } else {
                [MQToast showToast:[MQBundleUtil localizedStringForKey:@"microphone_denied"] duration:2 window:self.view];
            }
        }];
    } else {
        [self initRecordView];
    }
}

- (void)initRecordView {
    //如果开发者不自定义录音界面，则将播放界面显示出来
    if (!recordView) {
        recordView = [[MQRecordView alloc] initWithFrame:CGRectMake(0,
                                                                    0,
                                                                    self.chatTableView.frame.size.width,
                                                                    /*viewSize.height*/[UIScreen mainScreen].bounds.size.height - chatInputBar.frame.size.height)
                                       maxRecordDuration:[MQChatViewConfig sharedConfig].maxVoiceDuration];
        recordView.recordMode = [MQChatViewConfig sharedConfig].recordMode;
        recordView.keepSessionActive = [MQChatViewConfig sharedConfig].keepAudioSessionActive;
        recordView.recordViewDelegate = self;
        [self.view addSubview:recordView];
    }
    [recordView reDisplayRecordView];
    [recordView startRecording];
}

-(void)finishRecord:(CGPoint)point {
    [recordView stopRecord];
    [self didEndRecord];
}

-(void)cancelRecord:(CGPoint)point {
    [recordView cancelRecording];
    [self didEndRecord];
}

-(void)changedRecordViewToCancel:(CGPoint)point {
    recordView.revoke = true;
}

-(void)changedRecordViewToNormal:(CGPoint)point {
    recordView.revoke = false;
}

- (void)didEndRecord {
    
}

#pragma MQRecordViewDelegate
- (void)didFinishRecordingWithAMRFilePath:(NSString *)filePath {
    [chatViewService sendVoiceMessageWithAMRFilePath:filePath];
    [self chatTableViewScrollToBottomWithAnimated:true];
}

- (void)didUpdateVolumeInRecordView:(UIView *)recordView volume:(CGFloat)volume {
    
}

#pragma UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *type          = [info objectForKey:UIImagePickerControllerMediaType];
    //当选择的类型是图片
    if (![type isEqualToString:@"public.image"]) {
        return;
    }
    UIImage *image          =  [MQImageUtil fixrotation:[info objectForKey:UIImagePickerControllerOriginalImage]];
    [picker dismissViewControllerAnimated:YES completion:^{
        [chatViewService sendImageMessageWithImage:image];
        [self chatTableViewScrollToBottomWithAnimated:true];
    }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma UINavigationControllerDelegate 设置当前 statusBarStyle
-(void)navigationController:(UINavigationController *)navigationController
     willShowViewController:(UIViewController *)viewController
                   animated:(BOOL)animated
{
    //修改status样式
    if ([navigationController isKindOfClass:[UIImagePickerController class]]) {
//        [UIApplication sharedApplication].statusBarStyle = previousStatusBarStyle;
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;

    }
    self.navigationController.delegate = nil;
}

#pragma MQChatCellDelegate
- (void)showToastViewInCell:(UITableViewCell *)cell toastText:(NSString *)toastText {
    [MQToast showToast:toastText duration:1.0 window:self.view];
}

- (void)resendMessageInCell:(UITableViewCell *)cell resendData:(NSDictionary *)resendData {
    //先删除之前的消息
    NSIndexPath *indexPath = [self.chatTableView indexPathForCell:cell];
    [chatViewService resendMessageAtIndex:indexPath.row resendData:resendData];
    [self chatTableViewScrollToBottomWithAnimated:true];
}

- (void)didSelectMessageInCell:(UITableViewCell *)cell messageContent:(NSString *)content selectedContent:(NSString *)selectedContent {
    
}

- (void)didTapMessageInCell:(UITableViewCell *)cell {
    NSIndexPath *indexPath = [self.chatTableView indexPathForCell:cell];
    [chatViewService didTapMessageCellAtIndex:indexPath.row];
}

#pragma MQEvaluationViewDelegate
- (void)didSelectLevel:(NSInteger)level comment:(NSString *)comment {
    NSLog(@"评价 level = %d\n评价内容 = %@", (int)level, comment);
    [chatViewService sendEvaluationLevel:level comment:comment];
}

#pragma ios7以下系统的横屏的事件
//- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
//{
//    NSLog(@"willAnimateRotationToInterfaceOrientation");
//    viewSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
//}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self updateContentViewsFrame];
    [self.view endEditing:YES];
}

#pragma ios8以上系统的横屏的事件
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self updateContentViewsFrame];
    }];
    [self.view endEditing:YES];
}

//更新viewConroller中所有的view的frame
- (void)updateContentViewsFrame {
    //更新tableView的frame
    [self setChatTableViewFrame];
    //更新cellModel的frame
    chatViewService.chatViewWidth = self.chatTableView.frame.size.width;
    [chatViewService updateCellModelsFrame];
    [self reloadChatTableView];
    //更新inputBar的frame
    CGRect inputBarFrame = CGRectMake(self.chatTableView.frame.origin.x, self.chatTableView.frame.origin.y+self.chatTableView.frame.size.height - kMQChatViewInputBarHeight, self.chatTableView.frame.size.width, kMQChatViewInputBarHeight);
    [chatInputBar updateFrame:inputBarFrame];
    //更新recordView的frame
    CGRect recordViewFrame = CGRectMake(0,
                                        0,
                                        self.chatTableView.frame.size.width,
                                        self.view.viewHeight);
    [recordView updateFrame:recordViewFrame];
}

- (void)setChatTableViewFrame {
    //更新tableView的frame
    chatViewConfig.chatViewFrame = self.view.bounds;
    [self.chatTableView updateFrame:chatViewConfig.chatViewFrame];
}

#ifdef INCLUDE_MEIQIA_SDK
#pragma MQServiceToViewInterfaceErrorDelegate 后端返回的数据的错误委托方法
- (void)getLoadHistoryMessageError {
    [self.chatTableView finishLoadingTopRefreshViewWithCellNumber:0 isLoadOver:false];
    [MQToast showToast:[MQBundleUtil localizedStringForKey:@"load_history_message_error"] duration:1.0 window:self.view];
}

/**
 *  更新导航栏title
 */
- (void)updateNavBarTitle:(NSString *)title {
    //如果开发者设定了 title ，则不更新 title
    if ([MQChatViewConfig sharedConfig].navTitleText) {
        return;
    }
    self.navigationItem.title = title;
}

/**
 *  根据是否正在分配客服，更新导航栏title
 */
- (void)updateNavTitleWithAgentName:(NSString *)agentName agentStatus:(MQChatAgentStatus)agentStatus {
    //如果开发者设定了 title ，则不更新 title
    if ([MQChatViewConfig sharedConfig].navTitleText) {
        return;
    }
    UIView *titleView = [UIView new];
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = agentName;
    titleLabel.font = [UIFont systemFontOfSize:16.0];
    titleLabel.textColor = [MQChatViewConfig sharedConfig].navTitleColor;
    CGFloat titleHeight = [MQStringSizeUtil getHeightForText:agentName withFont:titleLabel.font andWidth:self.view.frame.size.width];
    CGFloat titleWidth = [MQStringSizeUtil getWidthForText:agentName withFont:titleLabel.font andHeight:titleHeight];
    UIImageView *statusImageView = [UIImageView new];
    switch (agentStatus) {
        case MQChatAgentStatusOnDuty:
            statusImageView.image = [MQAssetUtil agentOnDutyImage];
            break;
        case MQChatAgentStatusOffDuty:
            statusImageView.image = [MQAssetUtil agentOffDutyImage];
            break;
        case MQChatAgentStatusOffLine:
            statusImageView.image = [MQAssetUtil agentOfflineImage];
            break;
        default:
            break;
    }
    
    if ([titleLabel.text isEqualToString:[MQBundleUtil localizedStringForKey:@"no_agent_title"]]) {
        statusImageView.image = nil;
    }
    
    statusImageView.frame = CGRectMake(0, titleHeight/2 - statusImageView.image.size.height/2, statusImageView.image.size.width, statusImageView.image.size.height);
    titleLabel.frame = CGRectMake(statusImageView.frame.size.width + 8, 0, titleWidth, titleHeight);
    titleView.frame = CGRectMake(0, 0, titleLabel.frame.origin.x + titleLabel.frame.size.width, titleHeight);
    [titleView addSubview:statusImageView];
    [titleView addSubview:titleLabel];
    self.navigationItem.titleView = titleView;
}

/**
 *  收到美洽通信连接失败的通知
 */
- (void)didReceiveMQCommunicationErrorNotification:(NSNotification *)notification {
    if (isMQCommunicationFailed) {
        return;
    }
    isMQCommunicationFailed = true;
    [MQToast showToast:[MQBundleUtil localizedStringForKey:@"meiqia_communication_failed"] duration:1.0 window:self.view];
}


- (void)didReceiveRefreshOutgoingAvatarNotification:(NSNotification *)notification {
    if ([notification.object isKindOfClass:[UIImage class]]) {
        [chatViewService refreshOutgoingAvatarWithImage:notification.object];
    }
}

- (void)closeMeiqiaChatView {
    if ([self.navigationItem.title isEqualToString:[MQBundleUtil localizedStringForKey:@"no_agent_title"]]) {
        [chatViewService dismissingChatViewController];
    }
}

#endif


@end
