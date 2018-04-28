//
//  BATConsultationIndexViewController.m
//  HealthBAT_Pro
//
//  Created by four on 16/11/22.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATConsultationIndexViewController.h"

//跳转
#import "BATSearchViewController.h"
#import "BATWriteSingleDiseaseViewController.h"
#import "MQChatViewManager.h"
#import "BATSearchViewController.h"
#import "BATConsultationDepartmentDetailViewController.h"
#import "BATConsultationDepartmentListViewController.h"
#import "BATFindDoctorListViewController.h"
#import "BATChatConsultController.h"
#import "BATDutyDoctorsViewController.h"

//view
//#import "BATConsultionIndexShowWriteView.h"
#import "NewPagedFlowView.h"
//#import "PGIndexBannerSubiew.h"
#import "BATFreeClinicDoctorSubview.h"
#import "BATConsultionNoContentView.h"
#import "BATConsultionHomeNewTopView.h"
#import "BATConsultionHomeNewTopCollectionView.h"

//model
#import "BATOrderChatModel.h"
#import "BATFreeClinicDoctorModel.h"

//class
#import "AFViewShaker.h"
//#import "NSDate+BATTimeCatagory.h"
//#import "BATAppDelegate+BATTabbar.h"

@interface BATConsultationIndexViewController ()<UITextFieldDelegate,NewPagedFlowViewDelegate, NewPagedFlowViewDataSource>
{
    CGFloat _commentWriteViewHeight;  //WriteView实际高度
    CGFloat _commentBigHeight;  //scrollview实际高度
    CGFloat _commentMidHeight;  //scrollview显示高度
    CGFloat _commentFontPoor;
    CGFloat _currentTime;
//    CGFloat _commentRang;
}


//@property (nonatomic,strong) BATConsultionIndexShowWriteView *writeView;

@property (nonatomic,strong) BATConsultionNoContentView *noContentView;

@property (nonatomic,strong) BATConsultionHomeNewTopView *topView;

@property (nonatomic,strong) BATConsultionHomeNewTopCollectionView *topCollectionView;

@property (nonatomic,strong) UIView *backgroudView;

//分母、线、分子
//@property (nonatomic, strong) UILabel *denominatorLabel;
//@property (nonatomic, strong) UILabel *segmentationLabel;
//@property (nonatomic, strong) UILabel *molecularLabel;
//卡片省略号
@property (nonatomic,assign) NSInteger timeNum;
@property (nonatomic,strong) NSTimer *timer;
//卡片
@property (nonatomic,strong) NewPagedFlowView *pageFlowView;
@property (nonatomic,strong) UIScrollView *bottomScrollView;

@property (nonatomic,assign) NSInteger chatCurrentPage;

//@property (nonatomic,strong) BATOrderChatModel *chatModel;
@property (nonatomic,strong) BATFreeClinicDoctorModel *freeClinicDoctorModel;

@property (nonatomic,strong) BATGraditorButton *moreBtn;

//部门数组
@property (nonatomic,strong) NSArray *deptArray;
//@property (nonatomic,strong) NSMutableArray *freeDoctortArray;

//红点显示
@property (nonatomic,assign) BOOL isShowRedPoint;
@end

@implementation BATConsultationIndexViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.chatCurrentPage = 1;
    self.isShowRedPoint = NO;
    self.deptArray = [NSMutableArray arrayWithCapacity:0];
//    self.freeDoctortArray = [NSMutableArray arrayWithCapacity:0];
    
    //先做一次清空小红点的操作
//    BATAppDelegate *delegate = (BATAppDelegate *)[UIApplication sharedApplication].delegate;
//    [delegate setTarBarWithMessageCount:self.isShowRedPoint];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestAllData) name:@"Consultation" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestAllData) name:@"Get_New_Message_From_Doctor" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestAllData) name:@"Order_pay_success" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestAllData) name:@"Login_Success_Show_Consulition_Order_Data" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestAllData) name:@"Login_Out_Hidden_Consultion_Order_Data" object:nil];
    
    [self setDeptArray];
    
    [self layoutPages];
    
    if(LOGIN_STATION){
        self.noContentView.hidden = NO;
//        [self getOrderListRequest];
        //获取义诊医生
        [self requestGetFreeClinicDoctors];
    }else{
        self.pageFlowView.hidden = YES;
        self.noContentView.hidden = NO;

        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panNoContentCliack:)];
        [self.bottomScrollView addGestureRecognizer:pan];
    }

}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //进入咨询页面
    [NBSAppAgent trackEvent:TABBAR_CONSULT_CLICK withEventTag:@"点击了TabBar咨询" withEventProperties:nil];
    
    if (LOGIN_STATION) {
        if (![[BATTIMManager sharedBATTIM] bat_getLoginStatus]) {
            [[BATTIMManager sharedBATTIM] bat_loginTIM];
        }
    }
    
   

    if(LOGIN_STATION){
        self.noContentView.hidden = NO;
        self.pageFlowView.hidden = YES;
        
        //获取义诊医生
        [self requestGetFreeClinicDoctors];
    }else{
        self.pageFlowView.hidden = YES;
        self.noContentView.hidden = NO;

        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panNoContentCliack:)];
        [self.noContentView addGestureRecognizer:pan];
    }
    
    self.timeNum = 0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(action:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];

}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [self.timer invalidate];
}



- (void)setDeptArray{
    
    self.deptArray = @[@{@"deptName":@"全科医疗科",@"imageName":@"icon-consultion-qkylk"},
                      @{@"deptName":@"儿科",@"imageName":@"icon-consultion-ek"},
                      @{@"deptName":@"皮肤科",@"imageName":@"icon-consultion-pfk"},
                      @{@"deptName":@"康复医学科",@"imageName":@"icon-consultion-kfyxk"},
                      @{@"deptName":@"内科",@"imageName":@"icon-consultion-nk"},
                      @{@"deptName":@"肿瘤科",@"imageName":@"icon-consultion-zl"},
                      @{@"deptName":@"妇产科",@"imageName":@"icon-consultion-ck"},
                      @{@"deptName":@"外科",@"imageName":@"icon-consultion-pfk"},
                      @{@"deptName":@"口腔科",@"imageName":@"icon-consultion-kqemk"},
                      @{@"deptName":@"中医科",@"imageName":@"icon-consultion-zyk"},
                      @{@"deptName":@"急诊医学科",@"imageName":@"icon-consultion-jzyxk"},
                      @{@"deptName":@"更多",@"imageName":@"icon-consultion-gd"}];
    
}

- (void)action:(id)sender{
    self.timeNum = (self.timeNum + 1) % 3;
    switch (self.timeNum) {
        case 0:
            self.noContentView.ellipsisLabel.text = @".";
            break;
        case 1:
            self.noContentView.ellipsisLabel.text = @"..";
            break;
        case 2:
            self.noContentView.ellipsisLabel.text = @"...";
            break;
        default:
            break;
    }
}

- (void)requestAllData{
    
    if(LOGIN_STATION){
//        [self getOrderListRequest];
    }else{
        self.pageFlowView.hidden = YES;
        self.noContentView.hidden = NO;
//        self.denominatorLabel.hidden = YES;
//        self.molecularLabel.hidden = YES;
//        self.segmentationLabel.hidden = YES;
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panNoContentCliack:)];
        [self.bottomScrollView addGestureRecognizer:pan];
    }
}

#pragma mark - 免费咨询
//- (void)pushFreeConsultion{
//
//    if (!LOGIN_STATION) {
//        PRESENT_LOGIN_VC
//        return;
//    }
//
//    if (CANCONSULT) {
//        //免费咨询
//        BATWriteSingleDiseaseViewController *writeSingleDiseaseVC = [[BATWriteSingleDiseaseViewController alloc]init];
//        writeSingleDiseaseVC.type = kConsultTypeFree;
//        writeSingleDiseaseVC.pathName = @"咨询-免费咨询";
//        writeSingleDiseaseVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:writeSingleDiseaseVC animated:YES];
//    } else {
//        [self showText:@"您好,免费咨询功能升级中\n请稍后再试!"];
//    }
//}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    BATSearchViewController *searchVC = [[BATSearchViewController alloc] init];
    searchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


#pragma mark NewPagedFlowView Datasource
- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
    
//    self.molecularLabel.text = @"1";
//    self.denominatorLabel.text =[NSString stringWithFormat:@"%lu",(unsigned long)self.chatModel.Data.count];
//
//    return self.chatModel.Data.count;
    
    //产品设计只取一个医生
    return self.freeClinicDoctorModel.Data.count;
}

- (UIView *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    BATFreeClinicDoctorSubview *bannerView = (BATFreeClinicDoctorSubview *)[flowView dequeueReusableCell];
    if (!bannerView) {
        bannerView = [[BATFreeClinicDoctorSubview alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 84, _commentMidHeight)];
        bannerView.layer.cornerRadius = 4;
        bannerView.layer.masksToBounds = YES;
    }

//    [bannerView.doctorIconView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"医生"]];
//    [ bannerView.doctorNameLabel setTitle:@"王医生 主治医生" forState:UIControlStateNormal] ;
//    bannerView.deptLabel.text = @"全科";
//    bannerView.countLabel.text = @"义诊次数20/20";
//    bannerView.timeLabel.text = [NSString stringWithFormat:@"坐诊时间：%@",@"8:30-17:00"];
    
    FreeClinicDoctorData *data = self.freeClinicDoctorModel.Data[index];

    [bannerView.doctorIconView sd_setImageWithURL:[NSURL URLWithString:data.User.PhotoUrl] placeholderImage:[UIImage imageNamed:@"医生"]];
    [ bannerView.doctorNameLabel setTitle:[NSString stringWithFormat:@"%@ %@",data.DoctorName,data.Title] forState:UIControlStateNormal] ;
    bannerView.deptLabel.text = data.DepartmentName;
    if (data.DoctorClinic.CurrentCount == data.DoctorClinic.AcceptCount) {
         bannerView.countLabel.text = @"今天义诊已结束！";
    }else{
        bannerView.countLabel.text = [NSString stringWithFormat:@"义诊次数 %ld/%ld",(long)(data.DoctorClinic.AcceptCount - data.DoctorClinic.CurrentCount),(long)data.DoctorClinic.AcceptCount];
    }
   
    bannerView.timeLabel.text = [NSString stringWithFormat:@"坐诊时间：%@",@"8:30-17:00"];
    
    return bannerView;
}


#pragma mark NewPagedFlowView Delegate
- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView {

    return CGSizeMake(SCREEN_WIDTH - 84, _commentMidHeight);
}

- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
    
    
    //点击了咨询按钮
    [NBSAppAgent trackEvent:CONSULT_VC_CONSULT_DCOTOR_CLICK withEventTag:@"点击了咨询按钮" withEventProperties:nil];
    
    FreeClinicDoctorData *data = self.freeClinicDoctorModel.Data[subIndex];
    
    BATWriteSingleDiseaseViewController *writeSingleDiseaseVC = [[BATWriteSingleDiseaseViewController alloc]init];
    writeSingleDiseaseVC.type = kConsultTypeFree;
    writeSingleDiseaseVC.doctorID = data.DoctorID;
//    writeSingleDiseaseVC.momey = [NSString stringWithFormat:@"%.2f",doctorService.ServicePrice];
    writeSingleDiseaseVC.IsFreeClinicr = YES;
    writeSingleDiseaseVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:writeSingleDiseaseVC animated:YES];
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView {
    
    DDLogInfo(@"ViewController 滚动到了第%ld页",(long)pageNumber);
    
//    self.molecularLabel.text = [NSString stringWithFormat:@"%ld",(long)pageNumber+1];
//    self.denominatorLabel.text =[NSString stringWithFormat:@"%lu",(unsigned long)self.chatModel.Data.count];
}

//抖动效果
- (void)panCliack:(UIPanGestureRecognizer *)pan{
    
    [[[AFViewShaker alloc] initWithView:self.pageFlowView] shake];
}

//抖动效果
- (void)panNoContentCliack:(UIPanGestureRecognizer *)pan{
    
    [[[AFViewShaker alloc] initWithView:self.noContentView] shake];
}

/**
 *  文字加属性
 *
 *  @return 富文本属性数组
 */
- (NSArray *)titleAddAttribute:(NSString *)descStr font:(NSUInteger)font{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 5;
    
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:font], NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@0.2f
                          };
    
    NSMutableAttributedString *descAttributedStr = [[NSMutableAttributedString alloc] initWithString:descStr attributes:dic];
    
    NSArray *array = @[descAttributedStr,dic];
    return array;
}

#pragma mark - NET

//- (void)getOrderListRequest{
//
//    [HTTPTool requestWithURLString:@"/api/NetworkMedical/GetNowSysTime" parameters:nil type:kGET success:^(id responseObject) {
//        NSString *timeStr = responseObject[@"Data"];
//        DDLogInfo(@"timeStr ====%@====",timeStr);
//        NSInteger currentTime = [NSDate cTimestampFromString:timeStr format:@"yyyy-MM-dd HH:mm:ss"];
//        DDLogInfo(@"currentTime ====%ld====",(long)currentTime);
//        _currentTime = currentTime;
//    } failure:^(NSError *error) {
//
//    }];
//
//    NSMutableDictionary *chatdict = [NSMutableDictionary dictionary];
//    [chatdict setValue:@(self.chatCurrentPage) forKey:@"CurrentPage"];
//    [chatdict setValue:@"10" forKey:@"pageSize"];
//    [chatdict setValue:@"" forKey:@"keyWord"];
//    [chatdict setValue:@"" forKey:@"consultType"];
//    [chatdict setValue:@"true" forKey:@"IsPayed"];
//
//    [HTTPTool requestWithURLString:@"/api/NetworkMedical/GetUserConsults" parameters:chatdict type:kGET success:^(id responseObject) {
//
//        self.chatModel = [BATOrderChatModel mj_objectWithKeyValues:responseObject];
//        DDLogInfo(@"======删除之前数据个数=====%lu" ,(unsigned long)self.chatModel.Data.count);
//
//        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
//        for (int i=0; i<self.chatModel.Data.count ; i++) {
//            OrderResData *data = self.chatModel.Data[i];
//
//            NSInteger OrderTime = [NSDate cTimestampFromString:data.Order.OrderTime format:@"yyyy-MM-dd HH:mm:ss"];
//            NSInteger showTime = _currentTime - OrderTime;
//
//            if (showTime >= 604800) {
//                //过了7天的直接删除,因为没有历史记录了
//                [arr addObject:data];
//            }
//        }
//
//        [self.chatModel.Data removeObjectsInArray:arr];
//        [arr removeAllObjects];
//
//
//        for (int i=0; i<self.chatModel.Data.count ; i++) {
//            OrderResData *data = self.chatModel.Data[i];
//
//            NSInteger OrderTime = [NSDate cTimestampFromString:data.Order.OrderTime format:@"yyyy-MM-dd HH:mm:ss"];
//            NSInteger showTime = _currentTime - OrderTime;
//
//            //没过7天的
//            //没回复。且过24小时的影藏
//            if (data.AnswerTime == nil || [data.AnswerTime isEqualToString:@"0001-01-01 00:00:00"]) {
//                //没回复的时间就是 nil或者"0001-01-01 00:00:00"显示
//                if (showTime > 86400) {
//                    //过了24小时的
//                    [arr addObject:data];
//                }
//            }
//        }
//
//        [self.chatModel.Data removeObjectsInArray:arr];
//        [arr removeAllObjects];
//        DDLogInfo(@"======删除之后数据个数=====%lu" ,(unsigned long)self.chatModel.Data.count);
//
//        //0个订单不显示,1个订单不能滑动，加抖动效果
//        if (self.chatModel.Data.count == 0) {
//            self.pageFlowView.hidden = YES;
//            self.noContentView.hidden = NO;
////            self.molecularLabel.hidden = YES;
////            self.denominatorLabel.hidden = YES;
////            self.segmentationLabel.hidden = YES;
//
//            UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panNoContentCliack:)];
//            [_bottomScrollView addGestureRecognizer:pan];
//
//            //没有有效订单，直接无红点
//            BATAppDelegate *delegate = (BATAppDelegate *)[UIApplication sharedApplication].delegate;
//            [delegate setTarBarWithMessageCount:NO];
//            //清除保存的会话ID
//            NSArray *oldArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"channelIDArray"];
//            NSMutableArray *newArray = [NSMutableArray arrayWithArray:oldArr];
//            [newArray removeAllObjects];
//            NSUserDefaults *channleDefaults = [NSUserDefaults standardUserDefaults];
//            [channleDefaults setObject:newArray forKey:@"channelIDArray"];
//            [channleDefaults synchronize];
//
//        }else if(self.chatModel.Data.count == 1){
//            UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panCliack:)];
//            [_bottomScrollView addGestureRecognizer:pan];
//
//            self.pageFlowView.hidden = NO;
//            self.noContentView.hidden = YES;
////            self.molecularLabel.hidden = NO;
////            self.denominatorLabel.hidden = NO;
////            self.segmentationLabel.hidden = NO;
//
//        }else{
//            self.pageFlowView.hidden = NO;
//            self.noContentView.hidden = YES;
////            self.molecularLabel.hidden = NO;
////            self.denominatorLabel.hidden = NO;
////            self.segmentationLabel.hidden = NO;
//
//        }
//
//        [self.pageFlowView reloadData];
//
//    } failure:^(NSError *error) {
//        self.noContentView.hidden = NO;
//    }];
//}

////提醒回复
//- (void)requestRemindDoctorConsultion:(NSInteger )index{
//
//    //处理订单消息表示数组
//    OrderResData *orderModel = self.chatModel.Data[index];
//
//    [HTTPTool requestWithURLString:@"/api/Consult/AddNotice" parameters:@{@"Title":@"患者回复提醒 ",@"Summary":@"",@"Content":@"有新的患者消息需要立即回复",@"NoticeSecondType":@"15",@"Target":@"3",@"ToUser":orderModel.Doctor.DoctorID,} type:kPOST success:^(id responseObject) {
//
//        NSString  *resultCode = [responseObject objectForKey:@"ResultCode"];
//
//        if ([resultCode integerValue] == 0) {
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"已提醒医生回复" message:nil preferredStyle:UIAlertControllerStyleAlert];
//
//            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//
//            }];
//
//            [alert addAction:cancelAction];
//            [self presentViewController:alert animated:YES completion:nil];
//
//        }
//
//    } failure:^(NSError *error) {
//
//        [self showText:@"提醒失败！请再次尝试"];
//    }];
//}

//义诊医生
- (void)requestGetFreeClinicDoctors {
    
    if (CANCONSULT) {
        [HTTPTool requestWithURLString:@"/api/NetworkMedical/GetFreeClinicDoctors" parameters:@{@"pageIndex":@1,@"pageSize":@8} type:kGET success:^(id responseObject) {
            self.freeClinicDoctorModel = [BATFreeClinicDoctorModel mj_objectWithKeyValues:responseObject];
            
//            [self.freeDoctortArray removeAllObjects];
//            if (self.freeClinicDoctorModel.Data.count >0) {
//                for (int i=0; i < self.freeClinicDoctorModel.Data.count; i++) {
//                    FreeClinicDoctorData *data = self.freeClinicDoctorModel.Data[i];
//                    [self.freeDoctortArray addObject:data];
//                }
//            }
//            self.topCollectionView.todayFreeClinicArray = self.freeDoctortArray;
//            [self.topCollectionView remakelayouts];
//            [self.topCollectionView.collectionView reloadData];
            
            
            
            if (self.freeClinicDoctorModel.Data.count >0){
                
                self.noContentView.hidden = YES;
                self.pageFlowView.hidden = NO;
                
                if(self.freeClinicDoctorModel.Data.count == 1){
                    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panCliack:)];
                    [_bottomScrollView addGestureRecognizer:pan];
                }
                
                self.noContentView.hidden = YES;
                self.pageFlowView.hidden = NO;
                [self.pageFlowView reloadData];
            }else{
                self.pageFlowView.hidden = YES;
                self.noContentView.hidden = NO;
               
                UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panNoContentCliack:)];
                [self.bottomScrollView addGestureRecognizer:pan];
            }
            
        } failure:^(NSError *error) {
            self.pageFlowView.hidden = YES;
            self.noContentView.hidden = NO;
        }];
    }
}

#pragma mark - action
- (void)showCollectionView{
    self.backgroudView.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    [UIView animateWithDuration:1 animations:^{
        self.topCollectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
    
    [self.topCollectionView layoutIfNeeded];
    [self.topCollectionView setNeedsLayout];
}

- (void)hiddenCollctionView{
    self.tabBarController.tabBar.hidden = NO;
    [UIView animateWithDuration:1 animations:^{
        self.topCollectionView.frame = CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.backgroudView.hidden = YES;
    });
    
    [self.topCollectionView layoutIfNeeded];
    [self.topCollectionView setNeedsLayout];
}

#pragma mark - layout
- (void)layoutPages{
    
    
    if (iPhone5) {
        _commentBigHeight = 320;
        _commentMidHeight = 270;
        _commentFontPoor = 5;
//        _commentWriteViewHeight = 60;
//        _commentRang = 10;
    }else if (iPhone6){
        _commentBigHeight = 410;
        _commentMidHeight = 350;
        _commentFontPoor = 3;
//        _commentWriteViewHeight = 74;
//        _commentRang = 0;
    }else{
        _commentBigHeight = 410;
        _commentMidHeight = 380;
        _commentFontPoor = 0;
//        _commentWriteViewHeight = 74;
//        _commentRang = 0;
    }
    
    
    self.view.backgroundColor = BASE_BACKGROUND_COLOR;
    self.navigationItem.title = @"健康咨询";
    
    WEAK_SELF(self);
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc]initWithCustomView:self.moreBtn];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 40, 40);
    
    [btn bk_whenTapped:^{
        STRONG_SELF(self);
        [self hiddenCollctionView];
        if (self.isFromRoundGuide) {
            BATAppDelegate *appDelegate = (BATAppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate.window.rootViewController presentViewController:appDelegate.navHomeVC animated:NO completion:nil];
        }
        else if (self.isPersoncenter)
        {
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];

        }
        else {
            [self.tabBarController setSelectedIndex:0];
        }
    }];
    [btn setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -40, 0, 0)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(70);
    }];
    
    [self.view addSubview:self.noContentView];
    [self.noContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(self.view.mas_top).offset(80);
        make.left.equalTo(self.view.mas_left).offset(45);
        make.height.mas_equalTo(_commentBigHeight - 20);
        make.width.mas_equalTo(SCREEN_WIDTH - 90);
    }];
    
    [self.view addSubview:self.bottomScrollView];
    [self.bottomScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(self.view.mas_top).offset(80);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.height.mas_equalTo(_commentBigHeight);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
//    [self.view addSubview:self.writeView];
//    [self.writeView mas_makeConstraints:^(MASConstraintMaker *make) {
//        STRONG_SELF(self);
//        make.bottom.equalTo(self.view.mas_bottom).offset(-77 + _commentRang);
//        make.left.equalTo(self.view.mas_left).offset(50);
//        make.height.mas_equalTo(_commentWriteViewHeight);
//        make.width.mas_equalTo(SCREEN_WIDTH - 50 - 50);
//    }];
    
    [self.bottomScrollView addSubview:self.pageFlowView];
//
//    [self.view addSubview:self.denominatorLabel];
//    [self.denominatorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        STRONG_SELF(self);
//        make.top.equalTo(self.view.mas_top).offset(70);
//        make.right.equalTo(self.view.mas_right).offset(-10);
//        [self.denominatorLabel sizeToFit];
//    }];
//
//
//    [self.view addSubview:self.segmentationLabel];
//    [self.segmentationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        STRONG_SELF(self);
//        make.bottom.equalTo(self.denominatorLabel.mas_bottom).offset(-3);
//        make.right.equalTo(self.denominatorLabel.mas_left);
//        [self.segmentationLabel sizeToFit];
//    }];
//
//
//    [self.view addSubview:self.molecularLabel];
//    [self.molecularLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        STRONG_SELF(self);
//        make.bottom.equalTo(self.denominatorLabel.mas_bottom).offset(3);
//        make.right.equalTo(self.segmentationLabel.mas_left);
//        [self.molecularLabel sizeToFit];
//    }];
    
    [self.view addSubview:self.noContentView];
    [self.noContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(self.view.mas_top).offset(80);
        make.left.equalTo(self.view.mas_left).offset(45);
        make.height.mas_equalTo(_commentBigHeight - 20);
        make.width.mas_equalTo(SCREEN_WIDTH - 90);
    }];
    
    [self.view addSubview:self.backgroudView];
    [self.backgroudView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:self.topCollectionView];
}

#pragma mark -get*set

- (BATConsultionNoContentView *)noContentView{
    if (!_noContentView) {
        _noContentView = [[BATConsultionNoContentView alloc] initWithFrame:CGRectZero];
        _noContentView.hidden = YES;
        
        [_noContentView bk_whenTapped:^{
            
            if (!LOGIN_STATION) {
                PRESENT_LOGIN_VC;
                return ;
            }
            
            //值班医生
            BATDutyDoctorsViewController *dutyDoctorsVC = [[BATDutyDoctorsViewController alloc] init];
            dutyDoctorsVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:dutyDoctorsVC animated:YES];
        }];
    }
    return _noContentView;
}

//- (BATConsultionIndexShowWriteView *)writeView{
//    if (!_writeView) {
//        _writeView = [[BATConsultionIndexShowWriteView alloc]init];
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushFreeConsultion)];
//        [_writeView addGestureRecognizer:tap];
//        _writeView.layer.cornerRadius = 5.f;
//    }
//    return _writeView;
//}


//- (UILabel *)molecularLabel {
//
//    if (_molecularLabel == nil) {
//        _molecularLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//        _molecularLabel.textColor = START_COLOR;
//        _molecularLabel.font = [UIFont systemFontOfSize:30.0];
//        _molecularLabel.textAlignment = NSTextAlignmentRight;
//        _molecularLabel.hidden = YES;
//    }
//
//    return _molecularLabel;
//}
//- (UILabel *)segmentationLabel {
//
//    if (_segmentationLabel == nil) {
//        _segmentationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//        _segmentationLabel.textColor = START_COLOR;
//        _segmentationLabel.font = [UIFont systemFontOfSize:18.0];
//        _segmentationLabel.textAlignment = NSTextAlignmentCenter;
//        _segmentationLabel.hidden = YES;
//        _segmentationLabel.text = @"/";
//    }
//
//    return _segmentationLabel;
//}
//
//- (UILabel *)denominatorLabel {
//
//    if (_denominatorLabel == nil) {
//        _denominatorLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//        _denominatorLabel.textColor = [UIColor blackColor];
//        _denominatorLabel.font = [UIFont systemFontOfSize:18.0];
//        _denominatorLabel.textAlignment = NSTextAlignmentLeft;
//        _denominatorLabel.hidden = YES;
//    }
//
//    return _denominatorLabel;
//}


- (NewPagedFlowView *)pageFlowView{
    if (!_pageFlowView) {
        _pageFlowView = [[NewPagedFlowView alloc] initWithFrame:CGRectMake(0, 8, SCREEN_WIDTH, _commentMidHeight)];
        _pageFlowView.backgroundColor = [UIColor clearColor];
        _pageFlowView.delegate = self;
        _pageFlowView.dataSource = self;
        _pageFlowView.minimumPageAlpha = 0.1;
        _pageFlowView.minimumPageScale = 0.85;
        _pageFlowView.orientation = NewPagedFlowViewOrientationHorizontal;
        _pageFlowView.isOpenAutoScroll = NO;
        
    }
    return _pageFlowView;
};

- (UIScrollView *)bottomScrollView{
    if (!_bottomScrollView) {
        _bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _bottomScrollView.backgroundColor = [UIColor clearColor];
    }
    
    return _bottomScrollView;
}

- (BATConsultionHomeNewTopView *)topView{
    if (!_topView) {
        _topView = [[BATConsultionHomeNewTopView alloc]init];
        WEAK_SELF(self);
        [_topView setPushTopViewBlock:^{
            STRONG_SELF(self);
            
//            [self requestGetFreeClinicDoctors];
            
            self.topCollectionView.deptArray = self.deptArray;
            
            [self.topCollectionView remakelayouts];
            
            [self showCollectionView];
        }];
//        
//        [_topView setPushSearchDoctorBlock:^{
//            STRONG_SELF(self);
//            //找医生
//            BATFindDoctorListViewController *findDoctorListVC = [[BATFindDoctorListViewController alloc] init];
//            findDoctorListVC.hidesBottomBarWhenPushed = YES;
//            findDoctorListVC.pathName = @"咨询-找医生咨询";
//            [self.navigationController pushViewController:findDoctorListVC animated:YES];
//        }];
    }
    return _topView;
}

- (BATGraditorButton *)moreBtn{
    if (!_moreBtn) {
        _moreBtn = [[BATGraditorButton alloc]initWithFrame:CGRectMake(0, 0, 40, 44)];
        [_moreBtn setTitle:@"订单" forState:UIControlStateNormal] ;
        _moreBtn.enbleGraditor = YES;
        [_moreBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0 ,-20)];
        [_moreBtn setGradientColors:@[START_COLOR,END_COLOR]];
        WEAK_SELF(self);
        [_moreBtn bk_whenTapped:^{
            STRONG_SELF(self);

            [self hiddenCollctionView];

            if (!LOGIN_STATION) {
                PRESENT_LOGIN_VC
                return;
            }
            
            if (!CANCONSULT) {
                [self showText:@"您好,咨询功能升级中\n请稍后再试!"];
                return;
            }
            
            BATChatConsultController *chatCtl = [[BATChatConsultController alloc]init];
            chatCtl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:chatCtl animated:YES];
        }];
    }
    return _moreBtn;
}

- (BATConsultionHomeNewTopCollectionView *)topCollectionView{
    if (!_topCollectionView) {
        _topCollectionView = [[BATConsultionHomeNewTopCollectionView alloc]initWithFrame:CGRectMake(0, - SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT )];
        WEAK_SELF(self);
        
        [_topCollectionView setClickHiddenCollectionViewBolok:^{
            STRONG_SELF(self);
            [self hiddenCollctionView];
        }];
        
        [_topCollectionView setClickBeginEditingBolok:^{
           //搜索
            STRONG_SELF(self);
            [self hiddenCollctionView];

            //找医生
            BATFindDoctorListViewController *findDoctorListVC = [[BATFindDoctorListViewController alloc] init];
            findDoctorListVC.hidesBottomBarWhenPushed = YES;
            findDoctorListVC.pathName = @"咨询-找医生咨询";
            [self.navigationController pushViewController:findDoctorListVC animated:YES];
        }];
        
        [_topCollectionView setDeptClickBlock:^(NSIndexPath *indexPath){
            STRONG_SELF(self);

            [self hiddenCollctionView];
            
//            if(indexPath.section == 1){
//                //今日义诊
//                FreeClinicDoctorData *doctor = self.freeDoctortArray[indexPath.row];
//
//                BATWriteSingleDiseaseViewController *writeSingleDiseaseVC = [[BATWriteSingleDiseaseViewController alloc]init];
//                writeSingleDiseaseVC.type = kConsultTypeFree;
//                writeSingleDiseaseVC.doctorID = doctor.DoctorID;
//                writeSingleDiseaseVC.momey = @"0";
//                writeSingleDiseaseVC.IsFreeClinicr = YES;
//                writeSingleDiseaseVC.pathName = [NSString stringWithFormat:@"咨询-今日义诊-%@",doctor.DoctorName];
//                writeSingleDiseaseVC.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:writeSingleDiseaseVC animated:YES];
//            }
            if(indexPath.section == 1){
                if (indexPath.row == 11) {
                    
                    //更多
                    BATConsultationDepartmentListViewController *departmentListVC = [[BATConsultationDepartmentListViewController alloc] init];
                    departmentListVC.pathName = @"咨询-更多";
                    departmentListVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:departmentListVC animated:YES];
                    
                    return;
                }
                
                //科室
                NSDictionary *dict = self.deptArray[indexPath.row];
                
                BATConsultationDepartmentDetailViewController *departDetailVC = [[BATConsultationDepartmentDetailViewController alloc] init];
                departDetailVC.hidesBottomBarWhenPushed = YES;
                departDetailVC.title = [dict objectForKey:@"deptName"];
                departDetailVC.pathName = [NSString stringWithFormat:@"咨询-%@-更多",[dict objectForKey:@"deptName"]];
                departDetailVC.departmentName = [dict objectForKey:@"deptName"];
                departDetailVC.isConsulted = NO;
                [self.navigationController pushViewController:departDetailVC animated:YES];
            }
        }];
    }
    
    return _topCollectionView;
}

- (UIView *)backgroudView{
    if (!_backgroudView) {
        _backgroudView = [[UIView alloc]initWithFrame:CGRectZero];
        _backgroudView.backgroundColor = [UIColor blackColor];
        _backgroudView.alpha = 0.5;
        _backgroudView.hidden = YES;
    }
    return _backgroudView;
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
