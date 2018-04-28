//
//  HomeViewController.m
//  HealthBAT_Pro
//
//  Created by KM on 16/7/52016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATHomeViewController.h"

#import "BATHomeTopSearchView.h"

//子视图
#import "BATKangDoctorView.h"//康博士

#import "BATHomeHeaderView.h"//header
#import "BATHomeTopCircleTableViewCell.h"//顶部轮播图
//#import "BATHomePublicNoticeTableViewCell.h"//公告
//#import "BATHomeConsultationTableViewCell.h"//咨询 3.5
#import "BATHomeNewConsultationTableViewCell.h"//咨询 3.6
#import "BATHomeDoctorTableViewCell.h"//医生
//#import "BATHomeMallTableViewCell.h"//商城cell
#import "BATHomeNewMallTableViewCell.h"//商城cell 3.8
#import "BATHomeDoctorHorderTableViewCell.h"//医部落
#import "BATHomeOnlineStudyTableViewCell.h"//在线学习-->改为健康关注，cell不变
#import "BATHomeAssessmentTableViewCell.h"//健康评测
//#import "BATHomeHealthStepTableViewCell.h"//健康计步
#import "BATHomeNewHealthStepTableViewCell.h"//健康计步
#import "BATHomeHealthPlanTableViewCell.h"//健康计划
//#import "BATHomeNewsTableViewCell.h"//健康资讯
#import "BATHomeDetailNewsTableViewCell.h"//健康资讯

#import "BATBackRoundGuideFloatingView.h" //RoundGuide浮窗
#import "BATHomeHealthyCommunityCell.h" // 健康社区

//model
#import "BATHomeTopCirclePictureModel.h"
#import "BATNewsModel.h"
#import "BATHealthAssessmentModel.h"
//#import "BATPublicNoticeDataModel.h"
#import "BATMallInfoModel.h"
#import "BATLoginModel.h"
#import "BATHomeOnlineStudyModel.h"
#import "BATPerson.h"
#import "BATHealthFocusModel.h"
#import "BATDoctorStatusModel.h"
#import "BATHealthPlanModel.h"
#import "BATHotPostModel.h"
#import "BATMomentsModel.h"
#import "BATMessageModel.h"
#import "BATHomeNewsListModel.h"

//跳转视图
#import "BATHealthAssessmentViewController.h"
//#import "BATIntelligentGuideViewController.h"
#import "BATNewsDetailViewController.h"//新闻
#import "BATRegisterHospitalListViewController.h"
#import "BATSearchViewController.h"
//#import "QRCodeReaderViewController.h"
//#import "BATMessageViewController.h"//消息
#import "BATMessageCenterViewController.h"
#import "BATTodayOfferViewController.h"//今日特价
//#import "BATHomePackageViewController.h"
//#import "BATHomeTraditionMedicineViewController.h"
#import "BATTraditionMedicineHumanUIViewController.h"
#import "BATTraditionFirstViewController.h"
//#import "BATHomeMedicineViewController.h"
#import "BATHealthAssessmentMoreViewController.h"
//#import "BATSelfDiagnosisController.h"
#import "BATHumanBodyController.h"//快速查病
#import "BATHomeTopPicLinkViewController.h"
//#import "BATCourseDetailViewController.h"
//#import "MQChatViewManager.h"
//#import "BATOnlineLearningViewController.h"
//#import "MyZoneViewController.h"
//#import "BATUserPersonCenterViewController.h"
//#import "BATMyFocusBBSController.h"
//#import "BATBBSDetailController.h"
#import "BATCourseNewDetailViewController.h"//健康关注
#import "BATFamilyDoctorViewController.h"//家庭医生
//#import "BATDrKangViewController.h"//康博士
#import "BATNewDrKangViewController.h"//康博士
#import "BATHomeMallViewController.h"//商城
#import "BATTrainStudioIndexViewController.h"//培训工作室
#import "BATTrainStudioViewController.h" //培训工作室
#import "BATHealthPlanViewController.h"//健康计划
#import "BATInvitationDetailController.h"//文字帖子
#import "BATListenDoctorDetailController.h"//聆听医声帖子
//#import "BATAuthenticateIndexViewController.h"
//#import "BATDoctorStudioViewController.h"
//#import "BATAuthenticateResultViewController.h"
#import "BATDoctorListViewController.h"//名医工作室
#import "BATSameTopicController.h" //跟我一样
#import "BATMyFindViewController.h"//发现
#import "BATListeninDoctorController.h"//聆听医声
#import "BATHomeHealthNewsListViewController.h"//新闻资讯列表
#import "BATHomeNewsNoMoreDataFooterView.h" // tableView底部无更多数据

#import "BATCategoryListViewController.h"
#import "BATDiteGuideListViewController.h" //吃货圈
#import "BATHealthThreeSecondsController.h" //健康三秒钟
#import "BATHealthyInfoViewController.h" // 健康3秒钟,编辑资料

#import "HealthKitManage.h"//healthKit

//第三方
#import "MJRefresh.h"
//#import "UINavigationBar+Awesome.h"
#import "SFHFKeychainUtils.h"
#import "WZLBadgeImport.h"

//标示符
static  NSString * const TOP_CIRCLE_CELL = @"TopCircleCell";
//static  NSString * const PUBLIC_NOTICE_CELL = @"PublicNoticeCell";
static  NSString * const CONSULTATION_CELL = @"ConsultationCell";
static  NSString * const MALL_CELL = @"MallCell";
static  NSString * const ASSESSMENT_CELL = @"AssessmentCell";
static  NSString * const NEWS_CELL = @"NewsCell";
static  NSString * const ONLINE_STUDY_CELL = @"OnlineStudyCell";
//static  NSString * const HOT_POST_CELL = @"BATHealthCircleTableViewCell";
static  NSString * const DOCTOR_CELL = @"BATHomeDoctorTableViewCell";
static  NSString * const DOCTOR_HORDER_CELL = @"BATHomeDoctorHorderTableViewCell";
static  NSString * const HEALTH_STEP_CELL = @"BATHomeHealthStepTableViewCell";
static  NSString * const HEALTH_PLAN_CELL = @"BATHomeHealthPlanTableViewCell";

static  NSString * const HOT_NEWS_LAST_DATE = @"HotNewsLastTime";//新闻资讯刷新时间

static NSString * const HealthyCommunityCellID = @"BATHomeHealthyCommunityCell";


static NSString * const HomeNewsNoMoreDataFooterViewID = @"BATHomeNewsNoMoreDataFooterView";


@interface BATHomeViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIWebViewDelegate>

@property (nonatomic,strong) BATHomeTopSearchView *topSearchView;

@property (nonatomic,strong) NSMutableArray *titleArray;
@property (nonatomic,strong) NSMutableArray *topPictureUrlArray;
@property (nonatomic,strong) BATHomeTopCirclePictureModel *circlePictureModel;
@property (nonatomic,strong) BATNewsModel *news;
@property (nonatomic,strong) BATHealthAssessmentModel *healthAssessment;
@property (nonatomic,strong) BATMallInfoModel *todayOfferModel;
@property (nonatomic,strong) BATMallInfoModel *medicineModel;
//@property (nonatomic,strong) BATPublicNoticeDataModel *publicNotice;
@property (nonatomic,strong) BATMomentsModel *hotPostModel;
@property (nonatomic,strong) BATHealthFocusModel *healthFocusModel;
@property (nonatomic,strong) BATDoctorStatusModel *doctorStatusModel;
@property (nonatomic,strong) BATHealthPlanModel *healthPlanModel;
@property (nonatomic,strong) BATHotPostModel *hotPost;

@property (nonatomic,strong) NSTimer *countDownTimer;

@property (nonatomic,assign) double stepNum;//步数
@property (nonatomic,assign) BOOL isGetStep;

@property (nonatomic,strong) UITableView *homeTableView;
@property (nonatomic,strong) UITextField *searchTF;
@property (nonatomic,strong) NSString *styleString;
@property (nonatomic,strong) UIButton *messageBtn;
@property (nonatomic,strong) BATKangDoctorView *kangDoctorView;
@property (nonatomic,strong) UIImageView *searchIcon;

@property (nonatomic,assign) CGPoint beginPoint;
@property (nonatomic,assign) NSTimeInterval countDownTime;

@property (nonatomic,copy) NSArray *newsArray;

@property (nonatomic,strong) UIWebView *cacheWebView;
@property (nonatomic,strong) NSArray *cacheUrlArray;

//聚光灯
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,assign) int featureTimes;
@property (nonatomic,strong) UIImageView *maskImageView;
@property (nonatomic,strong) UIImageView *desImageView;
@property (nonatomic,strong) UIImageView *yesImageView;
@property (nonatomic,strong) UIImageView *noImageView;

//联动滚动
//@property (nonatomic,assign) BOOL canScroll;
//@property (nonatomic,assign) float newsTopY;

@property (nonatomic,assign) BOOL isExpandMallCell;
@property (nonatomic,assign) BOOL isExpandHorderCell;

//@property (nonatomic,strong) UIImageView *animationImageView;

@property (nonatomic,assign) NSInteger newsListInteger;

@property (nonatomic,strong) BATBackRoundGuideFloatingView *backRoundGuideFloatingView;

@end

@implementation BATHomeViewController

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"首页";
    self.newsListInteger = 0;
   
    [self pagesLayout];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestAllData) name:@"Home" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homeTableCanScroll) name:@"NEWS_LOCK_SCROLL" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homeHideBottom) name:@"NEWS_TABLE_UP" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homeShowBottom) name:@"NEWS_TABLE_DOWN" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector
     (goMessageVC) name:@"NOTIFICATION_PUSH_MESSAGE_VC" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homeNewAPNSMessage) name:@"NEW_APNS_MESSAGE" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(judgeIsEnterTraditionMedicineRequest) name:@"ENTER_TRADITIONMEDICINE_SUCCESS" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectHealthFoucsVC:) name:@"Health_Attion_Pop_More" object:nil];
    
    //登录成功根据用户性别更换康博士机器人背景图
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeDoctorKangImage) name:BATLoginSuccessGetUserInfoSucessNotification object:nil];
//    //正常退出登录
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeDoctorKangImage) name:@"LOGINOUT" object:nil];
//    //被挤掉退出登录
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeDoctorKangImage) name:@"APPLICATION_LOGOUT" object:nil];
    //登陆成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cacheBegin) name:@"BAT_LOGIN_SUCCESS" object:nil];

    //进入首页，主动调用，根据性别修改康博士图片
//    [self changeDoctorKangImage];
    
//    [self isShowGuide];
    
    self.titleArray = [NSMutableArray array];//顶部轮播文字数组
    self.topPictureUrlArray = [NSMutableArray array];//顶部轮播图片数组
    
    self.isGetStep = NO;

    self.isExpandMallCell = NO;
    self.isExpandHorderCell = NO;
    
    [self cacheBegin];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - override
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
//    self.backRoundGuideFloatingView.hidden = !self.isFromRoundGuide;
    
    //消息中心
    WEAK_SELF(self);
    [self bk_performBlock:^(id obj) {
        STRONG_SELF(self);
        [self getDataResquest];
    } afterDelay:10.f];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    //请求数据
//    if (!self.healthFocusModel) {
//        [self onlineStudyRequest];//获取在线学习
//    }
    if (self.topPictureUrlArray.count == 0) {
        [self topCirclePictureRequest];//顶部轮播图
    }
//    if (!self.publicNotice) {
//        [self publicNoticesRequest];//获取公告
//    }
    if (!self.healthAssessment) {
        [self healthAssessmentRequest];//获取健康评测
    }
    if (!self.hotPostModel) {
        [self hotPostRequest];//获取热门帖子
    }
    
//    if (!self.healthPlanModel) {
//        [self videoDataRequest];//健康计划
//    }
    
    if (self.newsArray.count == 0) {
        [self hotNewsListRequest];
    }
    
//    [self todayOfferInfoRequest];//今日特价
    
}


- (void)homeNewAPNSMessage {
    
    [self getDataResquest];
}

- (void)selectHealthFoucsVC:(NSNotification*)sender{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Health_Attion_Pop_More_From_Home" object:@([sender.object intValue])];
        
        [self.tabBarController setSelectedIndex:1];
    });
}


#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 9;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 8) {
        return self.newsArray.count;
    }
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        //顶部轮播图
        BATHomeTopCircleTableViewCell *topCircleCell = [tableView dequeueReusableCellWithIdentifier:TOP_CIRCLE_CELL forIndexPath:indexPath];
        topCircleCell.circlePictureView.placeholderImage = [UIImage imageNamed:@"home_default_img"];
        topCircleCell.circlePictureView.imageURLStringsGroup = self.topPictureUrlArray;
        [topCircleCell setTopPicClick:^(NSInteger index) {
            
            HomeTopPictureData *data = self.circlePictureModel.Data[index];
            
            switch (data.CarouselType) {
                case kBATHomeADType_None:
                {
    
                }
                    break;
                case kBATHomeADType_H5:
                {
                    //普通H5
                    BATHomeTopPicLinkViewController *vc = [[BATHomeTopPicLinkViewController alloc] init];
                    vc.title = data.CarouselTitle;
                    vc.url = [NSURL URLWithString:data.LinkAddress];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case kBATHomeADType_DrKang:
                {
                    //康博士 BATNewDrKangViewController.h
//                    BATDrKangViewController *kangDoctorVC = [[BATDrKangViewController alloc] init];
//                    kangDoctorVC.hidesBottomBarWhenPushed = YES;
//                    [self.navigationController pushViewController:kangDoctorVC animated:YES];
                    
                    BATNewDrKangViewController *kangDoctorVC = [[BATNewDrKangViewController alloc] init];
                    kangDoctorVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:kangDoctorVC animated:YES];
                }
                    break;
                case kBATHomeADType_Guoyiguan:
                {
                    //国医馆
                    if (!LOGIN_STATION) {
                        PRESENT_LOGIN_VC;
                        return ;
                    }
                    
                    BATTraditionMedicineHumanUIViewController *humanVC = [[BATTraditionMedicineHumanUIViewController alloc] init];
                    humanVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:humanVC animated:YES];
                }
                    break;
                case kBATHomeADType_Assessment:
                {
                    //健康评测
                    BATHealthAssessmentViewController * healthAssessmentVC = [[BATHealthAssessmentViewController alloc] init];
                    healthAssessmentVC.hidesBottomBarWhenPushed = YES;
                    healthAssessmentVC.title = data.CarouselTitle;
                    healthAssessmentVC.assessmentID = [data.RelationID integerValue];
                    healthAssessmentVC.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/App/TemplateIndex/%d?token=%@&mid=%@",APP_WEB_DOMAIN_URL,[data.RelationID intValue],LOCAL_TOKEN,[Tools getPostUUID]]];
                    [self.navigationController pushViewController:healthAssessmentVC animated:YES];
                    
                }
                    break;
                case kBATHomeADType_Mall:
                {
                    //健康商城
                    [self goMallVCWihtURL:data.LinkAddress title:data.CarouselTitle];
                }
                    break;
                case kBATHomeADType_FollowVideo:
                {
                    //健康关注-视频
                    BATCourseNewDetailViewController *courseDetailVC = [[BATCourseNewDetailViewController alloc] init];
                    courseDetailVC.courseID = [data.RelationID integerValue];
                    courseDetailVC.isPushFromHome = NO;
                    courseDetailVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:courseDetailVC animated:YES];
                }
                    break;
                case kBATHomeADType_News:
                {
                    //健康资讯
                    BATNewsDetailViewController *newsDetailVC = [[BATNewsDetailViewController alloc] init];
                    newsDetailVC.hidesBottomBarWhenPushed = YES;
                    newsDetailVC.newsID = data.RelationID;
                    newsDetailVC.titleStr = data.CarouselTitle;
                    [self.navigationController pushViewController:newsDetailVC animated:YES];
                    
                }
                    break;
                case kBATHomeADType_Find:
                {
                    //发现
                    BATMyFindViewController *findVC = [[BATMyFindViewController alloc]init];
                    findVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:findVC animated:YES];
                }
                    break;
            }
        }];
        return topCircleCell;
    }
    
    if (indexPath.section == 1) {
        //医生
        BATHomeDoctorTableViewCell *doctorCell = [tableView dequeueReusableCellWithIdentifier:DOCTOR_CELL forIndexPath:indexPath];
        [doctorCell setDoctorClick:^(NSIndexPath *clickIndex) {
            if (!LOGIN_STATION) {
                PRESENT_LOGIN_VC;
                return ;
            }
            switch (clickIndex.row) {
                    case 0:
                {
                    //医生工作室
                    
                    BATDoctorListViewController *doctorListVC = [[BATDoctorListViewController alloc] init];
                    doctorListVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:doctorListVC animated:YES];
                }
                    break;
                    case 1:
                {
                    
                    //培训工作室
                    
                    BATTrainStudioViewController *trainStudioVc = [[BATTrainStudioViewController alloc]init];
                    trainStudioVc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:trainStudioVc animated:YES];
                    
                    /**
                    BATTrainStudioIndexViewController *trainerIndexVC = [[BATTrainStudioIndexViewController alloc] init];
                    trainerIndexVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:trainerIndexVC animated:YES];
                    */
                }
                    break;
                    case 2:
                {
                    
                    BATTraditionMedicineHumanUIViewController *humanVC = [[BATTraditionMedicineHumanUIViewController alloc] init];
                    humanVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:humanVC animated:YES];
                    
                }
                    break;
                    case 3:
                {
                    //家庭医生
                    BATFamilyDoctorViewController * messageVC = [BATFamilyDoctorViewController new];
                    messageVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:messageVC animated:YES];
                }
                    break;
            }
        }];
        return doctorCell;
    }
    
    if (indexPath.section == 2) {
        //咨询
        BATHomeNewConsultationTableViewCell *consultationCell = [tableView dequeueReusableCellWithIdentifier:CONSULTATION_CELL forIndexPath:indexPath];
        [consultationCell setConsultationClick:^(NSIndexPath *clickIndex) {
            switch (clickIndex.row) {
                case 0:
                {
                    //点击了没有账号去注册按钮
                    [NBSAppAgent trackEvent:HOME_SYMPTOM_DIACRISIS_CLICK withEventTag:@"点击了没有账号去注册按钮" withEventProperties:nil];
                    
                    //症状自诊
                    BATHumanBodyController *diagnoVC = [BATHumanBodyController new];
                    diagnoVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:diagnoVC animated:YES];
                }
                    break;
                case 1:
                {
                    //预约挂号
                    if (CANREGISTER) {
                        
                        BATRegisterHospitalListViewController * hospitalVC = [BATRegisterHospitalListViewController new];
                        hospitalVC.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:hospitalVC animated:YES];
                    }
                    else {
                        
                        [self showText:@"您好,预约挂号功能升级中,请稍后再试!"];
                    }
                    
                }
                    break;
                case 2:
                {
                    
                    //咨询医生
                    [BATUserPortrayTools saveOperateModuleRequestWithURL:@"/kmStatistical-sync/saveOperateModule" pathName:@"首页-咨询医生" moduleId:1 beginTime:[Tools getCurrentDateStringByFormat:@"yyyy-MM-dd HH:mm:ss"]];
                    [self.tabBarController setSelectedIndex:3];
                    
                }
                    break;
            }
        }];
        
        return consultationCell;
        
    }
    
    if (indexPath.section == 3) {
        //商城cell
        BATHomeNewMallTableViewCell *mallCell = [tableView dequeueReusableCellWithIdentifier:MALL_CELL forIndexPath:indexPath];
        
        if (self.isExpandMallCell) {
         
            [mallCell.anfangzhuayaoView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(220.0/750*SCREEN_WIDTH);
            }];
            
            [mallCell.shanshihanfangView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(220.0/750*SCREEN_WIDTH);
            }];
            
            [mallCell.ninedotnineView.bottomImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(@-30);
            }];
            
            mallCell.anfangzhuayaoView.hidden = NO;
            mallCell.shanshihanfangView.hidden = NO;
        }
        else {
            
            [mallCell.anfangzhuayaoView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(0);
            }];
            
            [mallCell.shanshihanfangView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(0);
            }];
            
            [mallCell.ninedotnineView.bottomImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(@-30);
            }];
            
            mallCell.anfangzhuayaoView.hidden = YES;
            mallCell.shanshihanfangView.hidden = YES;
        }
        //baseUrl : http://www.jkbat.com/mallRedirect.html?
        [mallCell setBigPharmacyBlock:^{
            //大药房
            if (!CANVISITSHOP) {
                
                [self showText:@"各位客官,今日特价商品已抢完..."];
                return ;
            }
            
            //点击了首页大药房
            //http://m.km1818.com/bat/rcxyzd.html
            [self goMallVCWihtURL:@"http://m.km1818.com/bat/rcxyzd.html" title:@"大药房"];
        }];
        
        [mallCell setHealthMallBlock:^{
            //健康超市
            if (!CANVISITSHOP) {
                
                [self showText:@"各位客官,今日特价商品已抢完..."];
                return ;
            }
            //http://m.km1818.com/bat/jkcs.html
            [self goMallVCWihtURL:@"http://m.km1818.com/bat/jkcs.html" title:@"健康超市"];

        }];
        
        [mallCell setMedicalInstrumentsBlock:^{
            //医疗器械
            if (!CANVISITSHOP) {
                
                [self showText:@"各位客官,今日特价商品已抢完..."];
                return ;
            }
            //http://m.km1818.com/bat/ylqx.html
            [self goMallVCWihtURL:@"http://m.km1818.com/bat/ylqx.html" title:@"医疗器械"];
        }];
        
        [mallCell setHealthcareBlock:^{
            //营养保健
            if (!CANVISITSHOP) {
                
                [self showText:@"各位客官,今日特价商品已抢完..."];
                return ;
            }
            //http://m.km1818.com/bat/bjg.html
            [self goMallVCWihtURL:@"http://m.km1818.com/bat/bjg.html" title:@"营养保健"];
        }];
        
        [mallCell setAnfangzhuayaoBlock:^{
            if (!CANVISITSHOP) {
                
                [self showText:@"各位客官,今日特价商品已抢完..."];
                return ;
            }
            //http://m.km1818.com/wap/afzy01.html
            [self goMallVCWihtURL:@"http://m.km1818.com/wap/afzy01.html" title:@"按方抓药"];
        }];
        
        [mallCell setShanshihanfangBlock:^{
            if (!CANVISITSHOP) {
                
                [self showText:@"各位客官,今日特价商品已抢完..."];
                return ;
            }
            //http://m.km1818.com/wap/518ss.html
            [self goMallVCWihtURL:@"http://m.km1818.com/wap/518ss.html" title:@"膳食汉方"];
        }];
        
        [mallCell setNinedotnineBlock:^{
            if (!CANVISITSHOP) {
                
                [self showText:@"各位客官,今日特价商品已抢完..."];
                return ;
            }
            //http://m.km1818.com/bat/tejia.html
            [self goMallVCWihtURL:@"http://m.km1818.com/bat/tejia.html" title:@"9.9特卖"];
        }];
        
        return mallCell;
    }
    
    //健康社区
    if (indexPath.section == 4) {
        
        BATHomeHealthyCommunityCell *healthyCommunityCell = [tableView dequeueReusableCellWithIdentifier:HealthyCommunityCellID];
        healthyCommunityCell.backgroundColor = [UIColor whiteColor];
        
        //发现
        healthyCommunityCell.findItemBlock = ^{
            
            //发现
            BATMyFindViewController *findVC = [[BATMyFindViewController alloc]init];
            findVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:findVC animated:YES];
            
        };
        
        //和我一样
        healthyCommunityCell.sameMeItemBlcok = ^{
            
            BATSameTopicController *sameTopicVC = [[BATSameTopicController alloc]init];
            sameTopicVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sameTopicVC animated:YES];
            
        };
        
        //饮食指南/吃货圈
        healthyCommunityCell.gietGuildeItemBlock = ^{
            
            //吃货圈
             [NBSAppAgent trackEvent:HOME_DIET_GUIDE_CLICK withEventTag:@"点击了进入吃货圈" withEventProperties:nil];
            
            BATDiteGuideListViewController *diteGuideListVC = [[BATDiteGuideListViewController alloc]init];
            diteGuideListVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:diteGuideListVC animated:YES];
            
        };
        return healthyCommunityCell;
        
        /*
        //医部落
        BATHomeDoctorHorderTableViewCell *doctorHorderCell = [tableView dequeueReusableCellWithIdentifier:DOCTOR_HORDER_CELL forIndexPath:indexPath];
        if (self.hotPost.Data > 0) {
            doctorHorderCell.hotNoteArray = self.hotPost.Data;
            [doctorHorderCell.hotNoteTableView reloadData];
            
            [doctorHorderCell.hotNoteTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(200);

            }];
        }
        
        if (self.isExpandHorderCell == NO) {
            doctorHorderCell.hotNoteArray = @[];
            [doctorHorderCell.hotNoteTableView reloadData];
            
            [doctorHorderCell.hotNoteTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(0);
            }];
        }
        
        [doctorHorderCell setDoctorHorderClick:^(NSIndexPath *clickIndex) {
            
            switch (clickIndex.row) {
                case 0:
                {
                    if (!LOGIN_STATION) {
                        PRESENT_LOGIN_VC
                        return;
                    }
                    //跟我一样
                    BATSameTopicController *sameTopicVC = [[BATSameTopicController alloc]init];
                    sameTopicVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:sameTopicVC animated:YES];
                    
                }
                    break;
                case 1:
                {
                    //发现
                    BATMyFindViewController *findVC = [[BATMyFindViewController alloc]init];
                    findVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:findVC animated:YES];

                }
                    break;
            }
        }];
        
        [doctorHorderCell setHotNoteClick:^(NSIndexPath *clickIndex) {
            if (!self.hotPost) {
                return ;
            }
            HotPostData *data = self.hotPost.Data[clickIndex.row];
            
            if (data.ReplyType == 0) {
                //文字
                BATInvitationDetailController *invitationVC = [[BATInvitationDetailController alloc]init];
                invitationVC.ID = data.ID;
                invitationVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:invitationVC animated:YES];
            }
            else if (data.ReplyType == 1) {
                //聆听医声
                BATListenDoctorDetailController *listenVC = [[BATListenDoctorDetailController alloc] init];
                listenVC.ID = data.ID;
                listenVC.title = data.Title;
                listenVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:listenVC animated:YES];
            }

        }];
        return doctorHorderCell;
        */
    }
    
    
    if (indexPath.section == 5) {
        //健康关注
        BATHomeOnlineStudyTableViewCell * studyCell = [tableView dequeueReusableCellWithIdentifier:ONLINE_STUDY_CELL forIndexPath:indexPath];
        
        [studyCell setStudyClicked:^(NSIndexPath *clickedIndexPath) {

            BATCategoryListViewController *categoryListVC = [[BATCategoryListViewController alloc]init];
            
            switch (clickedIndexPath.section) {
                case 0:
                    categoryListVC.title = @"美容";
                    break;
                case 1:
                    categoryListVC.title = @"养生";
                    break;
                case 2:
                    categoryListVC.title = @"减肥";
                    break;
                case 3:
                    categoryListVC.title = @"塑型";
                    break;
                default:
                    break;
            }
            /** categoryId - > 1 : 美容 2:养生 3 ：减肥  4 ： 塑型*/
            categoryListVC.categoryId = [NSString stringWithFormat:@"%ld",(long)(clickedIndexPath.section + 1)];
            categoryListVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:categoryListVC animated:YES];
            
        }];
        return studyCell;
        
    }
    
    
    if (indexPath.section == 6) {
        //健康评测
        BATHomeAssessmentTableViewCell * assessmentCell = [tableView dequeueReusableCellWithIdentifier:ASSESSMENT_CELL forIndexPath:indexPath];
        if (self.healthAssessment.Data.count > 0) {
            assessmentCell.dataArray = self.healthAssessment.Data;
            [assessmentCell.assessmentCollectionView reloadData];
        }
        [assessmentCell setAssessmentClick:^(NSIndexPath *clickedIndexPath) {
            
            if (clickedIndexPath.section == 0) {
                //肿瘤健康评测
                if (!LOGIN_STATION) {
                    PRESENT_LOGIN_VC;
                    return ;
                }
                else {
                    BATPerson *person = PERSON_INFO;
                    
                    BATAssessmentData * assessmentdata = self.healthAssessment.Data[clickedIndexPath.section];
                    BATHealthAssessmentViewController * healthAssessmentVC = [[BATHealthAssessmentViewController alloc] init];
                    healthAssessmentVC.hidesBottomBarWhenPushed = YES;
                    healthAssessmentVC.title = assessmentdata.Theme;
                    healthAssessmentVC.assessmentID = assessmentdata.ID;
                    healthAssessmentVC.url = [NSURL URLWithString:[NSString stringWithFormat:@"https://ctms.anticancer365.com/CustomTestPaper/index_917304b8c2a6.html?from=bat&mobile=%@",person.Data.PhoneNumber]];
                    [self.navigationController pushViewController:healthAssessmentVC animated:YES];
                    return;
                }
            }
            BATAssessmentData * assessmentdata = self.healthAssessment.Data[clickedIndexPath.section];
            BATHealthAssessmentViewController * healthAssessmentVC = [[BATHealthAssessmentViewController alloc] init];
            healthAssessmentVC.hidesBottomBarWhenPushed = YES;
            healthAssessmentVC.title = assessmentdata.Theme;
            healthAssessmentVC.assessmentID = assessmentdata.ID;
            healthAssessmentVC.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/App/TemplateIndex/%ld?token=%@&mid=%@",APP_WEB_DOMAIN_URL,(long)assessmentdata.ID,LOCAL_TOKEN,[Tools getPostUUID]]];
            [self.navigationController pushViewController:healthAssessmentVC animated:YES];
        }];
        return assessmentCell;
    }
    
    if (indexPath.section == 7) {
        //健康记录
        BATHomeNewHealthStepTableViewCell *healthStepCell = [tableView dequeueReusableCellWithIdentifier:HEALTH_STEP_CELL forIndexPath:indexPath];
        if (self.isGetStep == NO) {
            [self getStepCount];
        }
        NSString *stepNum = [NSString stringWithFormat:@"%.0f",self.stepNum];
        NSString *calStr = [NSString stringWithFormat:@"%.0f",self.stepNum*0.04];
        NSString *fatStr = [NSString stringWithFormat:@"%.0f",self.stepNum*0.04/9.0];
        [healthStepCell.leftView.stepBtn setTitle:stepNum forState:UIControlStateNormal];
        healthStepCell.calView.contentLabel.text = calStr;
        healthStepCell.fatView.contentLabel.text = fatStr;
        return healthStepCell;
    }
    
    if (indexPath.section == 8) {
        //健康资讯
        BATHomeDetailNewsTableViewCell *newsCell = [tableView dequeueReusableCellWithIdentifier:NEWS_CELL forIndexPath:indexPath];

        HomeNewsContent * data = self.newsArray[indexPath.row];
        if (data.mainImage.length > 0) {
            
            [newsCell.newsImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",data.mainImage]] placeholderImage:[UIImage imageNamed:@"默认图"]];
            [newsCell.newsImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(115);
                make.height.mas_equalTo(75);
            }];
        }
        else {
            [newsCell.newsImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(0);
                make.height.mas_equalTo(0);
            }];
            
        }
        newsCell.newsTitleLabel.text = [data.title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        newsCell.readTimeLabel.text = [NSString stringWithFormat:@"阅读量：%@",data.readingQuantity];
        
        return newsCell;
        
    }
    
    return nil;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
     BATPerson *loginUserModel = PERSON_INFO;
    
    //健康记录--健康3秒钟
    if (indexPath.section == 7) {
        
        if ( !LOGIN_STATION) {
            PRESENT_LOGIN_VC;
            return;
        }
        
        BOOL isEdit = (loginUserModel.Data.Weight && loginUserModel.Data.Height && loginUserModel.Data.Birthday.length);

        if (!isEdit && ![[NSUserDefaults standardUserDefaults]boolForKey:isFirstEnterHealthThreeSecond]) {

                //完善资料
                BATHealthyInfoViewController *editInfo = [[BATHealthyInfoViewController alloc]init];
                editInfo.isShowNavButton = YES;
                editInfo.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:editInfo animated:YES];
            
        }else{

            //健康3秒钟
            BATHealthThreeSecondsController *healthThreeSecondsVC = [[BATHealthThreeSecondsController alloc]init];
            healthThreeSecondsVC.hidesBottomBarWhenPushed = YES;
//            healthThreeSecondsVC.isGetStep = self.isGetStep;
//            healthThreeSecondsVC.stepNum = self.stepNum;
            [self.navigationController pushViewController:healthThreeSecondsVC animated:YES];
        }
    
    
    }
    
    if (indexPath.section == 8) {
        
        HomeNewsContent * data = self.newsArray[indexPath.row];
        
        if ([data.categoryName isEqualToString:@"康健专题"]) {
            if (!LOGIN_STATION) {
                PRESENT_LOGIN_VC
                return;
            }
        }
        
        [self addReadingQuantityRequestWithNewID:[data.ID integerValue]];
        BATNewsDetailViewController *newsDetailVC = [[BATNewsDetailViewController alloc] init];
        newsDetailVC.hidesBottomBarWhenPushed = YES;
        newsDetailVC.newsID = data.ID;
        newsDetailVC.titleStr = data.title;
        newsDetailVC.categoryName = data.categoryName;
        newsDetailVC.categoryId = data.categoryId;
        newsDetailVC.isSaveOpera = YES;
        data.readingQuantity = [NSString stringWithFormat:@"%d",[data.readingQuantity intValue]+1];
        newsDetailVC.pathName = [NSString stringWithFormat:@"首页-%@-%@",self.styleString,data.title];
        [self.navigationController pushViewController:newsDetailVC animated:YES];
        
        [self.homeTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
            //顶部轮播图
            return (SCREEN_WIDTH*28.0/75.0);
            break;
        case 1:
            //医生
            return 95;
            break;
        case 2:
            //咨询
            return 159;
            break;

        case 3:
            //商城
            if (self.isExpandMallCell) {
                return (220+320+220)/750.0*SCREEN_WIDTH;
            }
            else {
                return (320+220)/750.0*SCREEN_WIDTH;
            }
            break;
        case 4:
            //健康社区
            /*
            if (self.isExpandHorderCell == YES) {
                return 75+100*2;
            }
            else {
                return 75;
            }
             */
            return 150;
            break;
        case 5:
            //健康关注
            return 110;
            break;
        case 6:
            //评测
            return 100 + 20;
            break;
        case 7:
            //健康计步
            return 290.0/750*SCREEN_WIDTH;
            break;
        case 8:
            //资讯
            return 90;
            break;
    }
    
    return 0;
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0 || section == 1 || section == 2) {
        
        return nil;
    }
    
    WEAK_SELF(self);
    BATHomeHeaderView * header = [[BATHomeHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    
    header.changeButton.hidden = YES;
    if (section == 3) {
        
        header.leftImageView.image = [UIImage imageNamed:@"A"];
        header.rightButton.hidden = YES;
        [header.leftButton setTitle:@"健康商城" forState:UIControlStateNormal];
        header.rightButton.hidden = YES;
    }
    if (section == 4) {
        
        header.leftImageView.image = [UIImage imageNamed:@"T"];
        header.rightButton.hidden = YES;
        [header.leftButton setTitle:@"健康社区" forState:UIControlStateNormal];
        header.rightButton.hidden = YES;
    }
    if (section == 5) {
        
        header.rightButton.hidden = YES;
        [header.leftButton setTitle:@"健康关注" forState:UIControlStateNormal];
    }
    if (section == 6) {
        
        header.rightButton.hidden = NO;
        [header.leftButton setTitle:@"健康测评" forState:UIControlStateNormal];
        [header setRightTap:^{
            
            STRONG_SELF(self);
            [self healthAssessmentMore];
        }];
    }
    
    if (section == 7) {
        header.rightButton.hidden = YES;
        [header.leftButton setTitle:@"健康记录" forState:UIControlStateNormal];
    }
    
    if (section == 8) {
        header.rightButton.hidden = YES;
        header.changeButton.hidden = NO;
        [header.leftButton setTitle:@"健康资讯" forState:UIControlStateNormal];
        [header setRightTap:^{
            
            //BATHomeHealthNewsListViewController *newsListVC = [[BATHomeHealthNewsListViewController alloc] init];
            //newsListVC.hidesBottomBarWhenPushed = YES;
            //[self.navigationController pushViewController:newsListVC animated:YES];
            
            self.newsListInteger = self.newsListInteger + 1;
            [self hotNewsListRequest];
        }];
    }
    
    return header;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (section == 8) {
        BATHomeNewsNoMoreDataFooterView *noMoreDataFooterView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HomeNewsNoMoreDataFooterViewID];
        noMoreDataFooterView.backgroundColor = [UIColor whiteColor];
        return noMoreDataFooterView;
    }
    return nil;
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0 || section == 1 || section == 2) {
        
        return CGFLOAT_MIN;
    }
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if ( section == 0) {
        return CGFLOAT_MIN;
    }else if (section == 8){
        
        return 40;
    }
    return 10;
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    [self expandCell];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    [self expandCell];
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    BATSearchViewController *searchVC = [[BATSearchViewController alloc] init];
    searchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
    return NO;
}


#pragma mark - UIResponder
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    
    [super touchesBegan:touches withEvent:event];

    UITouch *touch = [touches anyObject];
    
    if (touch.view == self.kangDoctorView) {
        self.beginPoint = [touch locationInView:self.kangDoctorView];
    } else if (touch.view == self.backRoundGuideFloatingView) {
        self.beginPoint = [touch locationInView:self.backRoundGuideFloatingView];
    }
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    if (touch.view == self.kangDoctorView) {
        CGPoint currentPosition = [touch locationInView:self.kangDoctorView];
        
        //偏移量
        float offsetX = currentPosition.x - self.beginPoint.x;
        float offsetY = currentPosition.y - self.beginPoint.y;
        
        //移动后的中心坐标
        self.kangDoctorView.center = CGPointMake(self.kangDoctorView.center.x + offsetX, self.kangDoctorView.center.y + offsetY);
        
        //x轴左右极限坐标
        if (self.kangDoctorView.center.x > (self.kangDoctorView.superview.frame.size.width-self.kangDoctorView.frame.size.width/2)) {
            CGFloat x = self.kangDoctorView.superview.frame.size.width-self.kangDoctorView.frame.size.width/2;
            CGFloat y = self.kangDoctorView.center.y;
            
            self.kangDoctorView.center = CGPointMake(x, y);
        }
        else if (self.kangDoctorView.center.x < (self.kangDoctorView.superview.frame.size.width-self.kangDoctorView.frame.size.width/2)) {
            CGFloat x = (self.kangDoctorView.superview.frame.size.width-self.kangDoctorView.frame.size.width/2);
            CGFloat y = self.kangDoctorView.center.y;
            
            self.kangDoctorView.center = CGPointMake(x, y);
        }
        
        //y轴上下极限坐标
        if (self.kangDoctorView.center.y > (self.kangDoctorView.superview.frame.size.height-self.kangDoctorView.frame.size.height/2)-49) {
            CGFloat x = self.kangDoctorView.center.x;
            CGFloat y = self.kangDoctorView.superview.frame.size.height-self.kangDoctorView.frame.size.height/2-49;
            
            self.kangDoctorView.center = CGPointMake(x, y);
        }
        else if (self.kangDoctorView.center.y <= self.kangDoctorView.frame.size.height/2) {
            CGFloat x = self.kangDoctorView.center.x;
            CGFloat y = self.kangDoctorView.frame.size.height/2;
            
            self.kangDoctorView.center = CGPointMake(x, y);
        }

    } else if (touch.view == self.backRoundGuideFloatingView) {
        
        CGPoint currentPosition = [touch locationInView:self.backRoundGuideFloatingView];
        
        //偏移量
        float offsetX = currentPosition.x - self.beginPoint.x;
        float offsetY = currentPosition.y - self.beginPoint.y;
        
        //移动后的中心坐标
        self.backRoundGuideFloatingView.center = CGPointMake(self.backRoundGuideFloatingView.center.x + offsetX, self.backRoundGuideFloatingView.center.y + offsetY);
        
        //x轴左右极限坐标
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
        else if (self.backRoundGuideFloatingView.center.y <= self.backRoundGuideFloatingView.frame.size.height/2) {
            CGFloat x = self.backRoundGuideFloatingView.center.x;
            CGFloat y = self.backRoundGuideFloatingView.frame.size.height/2;
            
            self.backRoundGuideFloatingView.center = CGPointMake(x, y);
        }
    }
    
}

#pragma mark - action
- (void)homeTableCanScroll {
    
//    self.canScroll = YES;
}

- (void)goMessageVC {
//    BATMessageViewController * messageVC = [BATMessageViewController new];
//    messageVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:messageVC animated:YES];
    BATMessageCenterViewController *messageCenterVC = [[BATMessageCenterViewController alloc] init];
    messageCenterVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:messageCenterVC animated:YES];
}

- (void)searchDoctorMore {
    
    DDLogDebug(@"寻医看病");
}

- (void)healthSelfAssessmentMore {
    
    DDLogDebug(@"健康自测 更多");
}

- (void)healthAssessmentMore {
    
    DDLogDebug(@"健康评测 更多");
    BATHealthAssessmentMoreViewController * moreHealthAssessmentVC = [[BATHealthAssessmentMoreViewController alloc] init];
    moreHealthAssessmentVC.hidesBottomBarWhenPushed = YES;
    moreHealthAssessmentVC.title = @"健康评测";
    moreHealthAssessmentVC.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/App/TemplateList?token=%@&mid=%@",APP_WEB_DOMAIN_URL,LOCAL_TOKEN,[Tools getPostUUID]]];
    [self.navigationController pushViewController:moreHealthAssessmentVC animated:YES];
}


- (void)requestAllData {
    
    [self topCirclePictureRequest];//顶部轮播图
    [self healthAssessmentRequest];//获取健康评测
//    [self todayOfferInfoRequest];//今日特价
//    [self onlineStudyRequest];//在线学习
    [self hotPostRequest];//获取热门帖子
//    [self publicNoticesRequest];//获取公告
    
    [self requestGetDoctorStatusEntity]; //判断医生工作室状态
    
//    [self videoDataRequest];//获取健康计划
    
    [self getStepCount];//获取步数

    [self hotNewsListRequest];//刷新新闻
    
    [self bk_performBlock:^(id obj) {
        [self.homeTableView.mj_header endRefreshing];
    } afterDelay:2.0];
    
}

- (void)homeShowBottom {
    
    [UIView animateWithDuration:0.35 animations:^{
        self.tabBarController.tabBar.frame = CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49);
    }];
}

- (void)homeHideBottom {
    
    [UIView animateWithDuration:0.35 animations:^{
        self.tabBarController.tabBar.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 49);
    }];
}



#pragma mark - private
- (void)isShowGuide {
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"Guide_version"] isEqualToString:[Tools getLocalVersion]]) {

        return;
    }

    [[NSUserDefaults standardUserDefaults] setObject:[Tools getLocalVersion] forKey:@"Guide_version"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(newFeatureGuide)];
    [self.bgView addGestureRecognizer:tap];
    
    [self.tabBarController.view addSubview:self.bgView];
    [self newFeatureGuide];
}

- (void)newFeatureGuide {
    
    
    CGRect rect = CGRectZero;
    
    switch (self.featureTimes) {

        case 0:
        {
            //康博士
//            CGRect firstRect = [self.kangDoctorView convertRect:self.kangDoctorView.frame toView:self.view];
            CGRect firstRect = self.kangDoctorView.frame ;

            self.maskImageView.image = [UIImage imageNamed:@"Home_Doctor_Kang"];
            [self.maskImageView sizeToFit];
            float tmpHeight;
            if (iPhoneX) {
                tmpHeight = 44+44;
            }
            else {
                tmpHeight = 20+44;
            }
            self.maskImageView.center = CGPointMake(CGRectGetMidX(firstRect), CGRectGetMidY(firstRect)+tmpHeight);
            
            self.desImageView.image = [UIImage imageNamed:@"wz"];
            [self.desImageView sizeToFit];
            self.desImageView.center = CGPointMake(self.view.center.x, CGRectGetMaxY(self.maskImageView.frame)+CGRectGetHeight(self.maskImageView.bounds)/2.0);
            self.desImageView.bounds = CGRectMake(0, 0, CGRectGetWidth(self.desImageView.bounds), CGRectGetHeight(self.desImageView.bounds));
            
            self.yesImageView.image = [UIImage imageNamed:@"but-hd"];
            [self.yesImageView sizeToFit];
            self.yesImageView.frame = CGRectMake(CGRectGetMinX(self.desImageView.frame)+60, CGRectGetMaxY(self.desImageView.frame)+10, CGRectGetWidth(self.yesImageView.bounds), CGRectGetHeight(self.yesImageView.bounds));
            WEAK_SELF(self);
            [self.yesImageView bk_whenTapped:^{
                
                [self newFeatureGuide];
                
                //点击康博士
                [NBSAppAgent trackEvent:HOME_DOCTORKANG_BUTTON_CLICK withEventTag:@"点击康博士" withEventProperties:nil];
                
                
                STRONG_SELF(self);
                
//                BATDrKangViewController *kangDoctorVC = [[BATDrKangViewController alloc] init];
//                kangDoctorVC.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:kangDoctorVC animated:YES];
                
                BATNewDrKangViewController *kangDoctorVC = [[BATNewDrKangViewController alloc] init];
                kangDoctorVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:kangDoctorVC animated:YES];
            }];
            
            self.noImageView.image = [UIImage imageNamed:@"but-nit"];
            [self.noImageView sizeToFit];
            self.noImageView.frame = CGRectMake(CGRectGetMaxX(self.yesImageView.frame)+30, CGRectGetMaxY(self.desImageView.frame)+10, CGRectGetWidth(self.noImageView.bounds), CGRectGetHeight(self.noImageView.bounds));

            
            [self.bgView addSubview:self.desImageView];
            [self.bgView addSubview:self.maskImageView];
            [self.bgView addSubview:self.yesImageView];
            [self.bgView addSubview:self.noImageView];
        }
            break;

        default:
            break;
    }
    
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:[UIScreen mainScreen].bounds];
    [path appendPath:[[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:5.0f] bezierPathByReversingPath]];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    [self.bgView.layer setMask:shapeLayer];
    
    self.featureTimes ++;
    
    if (self.featureTimes == 2) {
        [self.bgView removeFromSuperview];
        self.bgView = nil;
    }
}


//展开cell
- (void)expandCell {

    for (UITableViewCell *cell in [self.homeTableView visibleCells]) {
        
        if ([cell isKindOfClass:[BATHomeNewMallTableViewCell class]]) {
            
            if (self.isExpandMallCell == YES) {
                return;
            }
            
            self.isExpandMallCell = YES;

            WEAK_SELF(self);
            [self bk_performBlock:^(id obj) {
                STRONG_SELF(self);
                
                [self.homeTableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationAutomatic];
//                [self todayOfferInfoRequest];
                
            } afterDelay:2];
        }
    }
    
    for (UITableViewCell *cell in [self.homeTableView visibleCells]) {
     
        if ([cell isKindOfClass:[BATHomeDoctorHorderTableViewCell class]]) {
            
            if (self.isExpandHorderCell == YES) {
                return;
            }
            
            self.isExpandHorderCell = YES;
            
            WEAK_SELF(self);
            [self bk_performBlock:^(id obj) {
                STRONG_SELF(self);
                
                [self.homeTableView reloadSections:[NSIndexSet indexSetWithIndex:4] withRowAnimation:UITableViewRowAnimationAutomatic];
                
            } afterDelay:2];
        }
    }
}

- (void)goMallVCWihtURL:(NSString *)url title:(NSString *)title {
    
    BATHomeMallViewController *homeMallVC = [[BATHomeMallViewController alloc] init];
    homeMallVC.url = url;
    homeMallVC.title = title;
    homeMallVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:homeMallVC animated:YES];
}

- (void)getStepCount
{
    HealthKitManage *manage = [HealthKitManage shareInstance];
    WEAK_SELF(self);
    
    [manage authorizeHealthKit:^(BOOL success, NSError *error) {
        
        if (success) {
            [manage getStepCountFromDate:[NSDate date] completion:^(double value, NSError *error) {
                STRONG_SELF(self);
                dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 *NSEC_PER_SEC));
                dispatch_after(time, dispatch_get_main_queue(), ^{
                    
                    self.stepNum = value;
                    self.isGetStep = YES;

                    [self.homeTableView reloadSections:[NSIndexSet indexSetWithIndex:7] withRowAnimation:UITableViewRowAnimationAutomatic];
                });
            }];
     
        }
        else {
            self.stepNum = 0;
            self.isGetStep = NO;
        }
    }];
    
   
}

#pragma mark - NET
//轮播图请求
- (void)topCirclePictureRequest {
    
    [HTTPTool requestWithURLString:@"/api/GetCarouselList" parameters:nil type:kGET success:^(id responseObject) {
        
        self.circlePictureModel = [BATHomeTopCirclePictureModel mj_objectWithKeyValues:responseObject];
        [self.titleArray removeAllObjects];
        [self.topPictureUrlArray removeAllObjects];
        for (HomeTopPictureData *data in self.circlePictureModel.Data) {
            
            [self.titleArray addObject:data.CarouselTitle];
            [self.topPictureUrlArray addObject:data.CarouselUrl];
        }
        [self.homeTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.homeTableView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        
        [self.homeTableView.mj_header endRefreshing];
    }];
}

//今日特价请求
/*
- (void)todayOfferInfoRequest {
    
    NSDictionary *para;
    if (LOGIN_STATION) {
        
        BATLoginModel *login = LOGIN_INFO;
        para = @{@"userId":@(login.Data.ID),@"deviceCode":[Tools getPostUUID]};
    }
    else {
        
        para = @{@"deviceCode":[Tools getPostUUID]};
    }
    
    [HTTPTool requestWithMallURLString:@"/kmHealthMall-web/discount/getDiscountImgAndTimeAndPrice" parameters:para success:^(id responseObject) {
        
        [self.homeTableView.mj_header endRefreshing];

        self.todayOfferModel = [BATMallInfoModel mj_objectWithKeyValues:responseObject];
        
        //2016-09-23 16:43:35
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate* severTime = [formatter dateFromString:self.todayOfferModel.resultData.time];
        
        NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:severTime];
        NSDate *startDate = [calendar dateFromComponents:components];
        NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
        
        DDLogDebug(@"服务器时间----------------%@",severTime);
        
        self.countDownTime = [endDate timeIntervalSinceDate:severTime];
        
        DDLogError(@"倒计时  －－－－－－%f",self.countDownTime);
        
        
        BATHomeNewMallTableViewCell *mallCell = [self.homeTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
        [mallCell.todayOfferGoodView.timeLabel setCountDownTime:self.countDownTime];
        [mallCell.todayOfferGoodView.timeLabel start];
        mallCell.todayOfferGoodView.nameLabel.text = self.todayOfferModel.resultData.productName;
        if (self.todayOfferModel.resultData.imgPath.length > 0) {
            
            [mallCell.todayOfferGoodView.leftImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://img.km1818.com/product%@",self.todayOfferModel.resultData.imgPath]] placeholderImage:[UIImage imageNamed:@"默认图"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                if (!image) {
                    return ;
                }
                if (self.todayOfferModel.resultData.discountPrice > 0) {
                    
                    mallCell.todayOfferGoodView.priceLabel.hidden = NO;
                    mallCell.todayOfferGoodView.priceLabel.text = [NSString stringWithFormat:@"￥ %.2f",self.todayOfferModel.resultData.discountPrice];
                }
            }];
        }

        
    } failure:^(NSError *error) {
        
        [self.homeTableView.mj_header endRefreshing];
    }];
}
*/


//热门帖子
- (void)hotPostRequest {
    
    [HTTPTool requestWithURLString:@"/api/dynamic/GetHotPostList"
                        parameters:@{@"pageIndex":@(0),@"pageSize":@(2)}
                              type:kGET
                           success:^(id responseObject) {
                               self.hotPost = [BATHotPostModel mj_objectWithKeyValues:responseObject];
                               [self.homeTableView reloadSections:[NSIndexSet indexSetWithIndex:4] withRowAnimation:UITableViewRowAnimationAutomatic];
                           }
                           failure:^(NSError *error) {
                               
                           }];
}

////在线学习-->>健康关注
//- (void)onlineStudyRequest {
//    
//    [HTTPTool requestWithURLString:@"/api/TrainingTeacher/GetHotCourseList" parameters:nil type:kGET success:^(id responseObject) {
//        
//        self.healthFocusModel = [BATHealthFocusModel mj_objectWithKeyValues:responseObject];
//        if (self.healthFocusModel.ResultCode == 0) {
//            
//            [self.homeTableView reloadSections:[NSIndexSet indexSetWithIndex:5] withRowAnimation:UITableViewRowAnimationAutomatic];
//        }
//    } failure:^(NSError *error) {
//        
//    }];
//}

//健康评测
- (void)healthAssessmentRequest {
    
    [HTTPTool requestWithURLString:@"/api/Evaluating/Search" parameters:@{@"pageIndex":@0,@"pageSize":@6} type:kGET success:^(id responseObject) {
        
        self.healthAssessment = [BATHealthAssessmentModel mj_objectWithKeyValues:responseObject];
        [self.homeTableView reloadSections:[NSIndexSet indexSetWithIndex:6] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.homeTableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        
        [self.homeTableView.mj_header endRefreshing];
        
    }];
}

////健康计划
//- (void)videoDataRequest {
//    
//    [HTTPTool requestWithURLString:@"/api/HealthManager/GetSportList" parameters:@{@"typeId":@(0)} type:kGET success:^(id responseObject) {
//        
//        self.healthPlanModel = [BATHealthPlanModel mj_objectWithKeyValues:responseObject];
//        
//        [self.homeTableView reloadSections:[NSIndexSet indexSetWithIndex:7] withRowAnimation:UITableViewRowAnimationAutomatic];
//        
//    } failure:^(NSError *error) {
//        
//    }];
//}

//阅读量
- (void)addReadingQuantityRequestWithNewID:(NSInteger)newID {
    
    [HTTPTool requestWithURLString:[NSString stringWithFormat:@"/api/News/UpdateReadingQuantity?id=%ld",(long)newID] parameters:nil type:kGET success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}



//更新阅读量
- (void)requestUpdataCourseReadingNum:(NSIndexPath *)indexPath model:(BATHomeHealthFocusData *)model
{
    [HTTPTool requestWithURLString:[NSString stringWithFormat:@"/api/trainingteacher/course/updatereadingnum/%ld",(long)model.ID] parameters:nil type:kGET success:^(id responseObject) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:BATRefreshIndexPathModelNotification object:@{@"courseID":@(model.ID),@"isCollection":@(NO),@"commentState":@(NO),@"isRead":@(YES)}];
        
    } failure:^(NSError *error) {
        
    }];
}

/*
//判断国医馆是否进入过了
- (void)judgeIsEnterTraditionMedicineRequest {
    
    BATPerson *person = PERSON_INFO;
    if (person.Data.IsFirstVisitMedicine == 0) {
        return;
    }
    
    [HTTPTool requestWithURLString:@"/api/ChineseMedicine/IsExistPatientInfo" parameters:nil type:kGET success:^(id responseObject) {
        
        NSDictionary *dict = responseObject;
        
        DDLogDebug(@"%d===%@",person.Data.IsFirstVisitMedicine,[dict objectForKey:@"Data"]);
        
        person.Data.IsFirstVisitMedicine = [[dict objectForKey:@"Data"] boolValue];
        
        DDLogDebug(@"%d===%@",person.Data.IsFirstVisitMedicine,[dict objectForKey:@"Data"]);
        
        //保存登录信息
        NSString *file = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Person.data"];
        [NSKeyedArchiver archiveRootObject:person toFile:file];
        
    } failure:^(NSError *error) {
        
    }];
}
*/

//医生工作室 培训工作室 审核状态
- (void)requestGetDoctorStatusEntity
{
    
    if (!LOGIN_STATION) {
        return;
    }
    
    [HTTPTool requestWithURLString:@"/api/Doctor/GetDoctorStatusEntity" parameters:nil type:kGET success:^(id responseObject) {
        
        self.doctorStatusModel = [BATDoctorStatusModel mj_objectWithKeyValues:responseObject];
        
        //        [self.homeTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:3]] withRowAnimation:UITableViewRowAnimationAutomatic];
        
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
            [self.topSearchView.messageBtn.imageView showBadge];
        } else {
            [self.topSearchView.messageBtn.imageView clearBadge];
        }
        
        //判断是否还有未读数据
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:unReadNums];
        [JPUSHService setBadge:unReadNums];

        
    } failure:^(NSError *error) {

    }];
}

- (void)hotNewsListRequest {
    
    NSTimeInterval time;
    
    //存入本次刷新时间
    [[NSUserDefaults standardUserDefaults] setValue:[NSDate date] forKey:HOT_NEWS_LAST_DATE];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    time = [[NSDate date] timeIntervalSince1970];

    
    //请求数据
    [HTTPTool requestWithSearchURLString:@"/elasticsearch/recommend/gethotnews" parameters:@{@"page":@(self.newsListInteger),@"lastFlashTime":@(floor(time*1000)),@"userdeviceid":[Tools getUUID]} success:^(id responseObject) {

        BATHomeNewsListModel *news = [BATHomeNewsListModel mj_objectWithKeyValues:responseObject];
        self.newsArray = news.resultData.content;
        
        [self.homeTableView reloadSections:[NSIndexSet indexSetWithIndex:8] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark - layout
- (void)pagesLayout {
    
    self.styleString = @"推荐";
    self.navigationItem.titleView = self.topSearchView;
    
    [self.view addSubview:self.homeTableView];
    [self.homeTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    
#ifdef __IPHONE_11_0
    if (@available(iOS 11.0, *)) {
        
        if (iPhoneX) {
            
            [self.homeTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 83, 0));
            }];
        }
        else {
            
            [self.homeTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 49, 0));
            }];
        }
    }
#endif
    
    
    [self.view addSubview:self.kangDoctorView];
    [self.view addSubview:self.backRoundGuideFloatingView];
}


#pragma mark - setter && getter
- (BATHomeTopSearchView *)topSearchView {
    
    if (!_topSearchView) {
        
        _topSearchView = [[BATHomeTopSearchView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        WEAK_SELF(self);
        [_topSearchView setSearchBlock:^{
        
            //点击了首页导航栏搜索按钮
            [NBSAppAgent trackEvent:HOME_NAV_SEARCH_BAR_CLICK withEventTag:@"点击了首页导航栏搜索按钮" withEventProperties:nil];
            
            STRONG_SELF(self);
            BATSearchViewController *searchVC = [[BATSearchViewController alloc] init];
            searchVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:searchVC animated:YES];
        }];
        
        [_topSearchView setMessageBlock:^{
            STRONG_SELF(self);
            
            if (!LOGIN_STATION) {
                PRESENT_LOGIN_VC
                return;
            }
            
            [self goMessageVC];
        }];
    }
    return _topSearchView;
}

- (UITableView *)homeTableView {
    
    if (!_homeTableView) {
        
        _homeTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        _homeTableView.showsVerticalScrollIndicator = NO;
        _homeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _homeTableView.backgroundColor = BASE_BACKGROUND_COLOR;
        
        _homeTableView.estimatedRowHeight = 0;
        _homeTableView.estimatedSectionHeaderHeight = 0;
        _homeTableView.estimatedSectionFooterHeight = 0;
        
        [_homeTableView registerClass:[BATHomeTopCircleTableViewCell class] forCellReuseIdentifier:TOP_CIRCLE_CELL];
        [_homeTableView registerClass:[BATHomeNewConsultationTableViewCell class] forCellReuseIdentifier:CONSULTATION_CELL];
        [_homeTableView registerClass:[BATHomeDoctorTableViewCell class] forCellReuseIdentifier:DOCTOR_CELL];
        [_homeTableView registerClass:[BATHomeNewMallTableViewCell class] forCellReuseIdentifier:MALL_CELL];
        [_homeTableView registerClass:[BATHomeAssessmentTableViewCell class] forCellReuseIdentifier:ASSESSMENT_CELL];
        [_homeTableView registerClass:[BATHomeDetailNewsTableViewCell class] forCellReuseIdentifier:NEWS_CELL];
        [_homeTableView registerClass:[BATHomeOnlineStudyTableViewCell class] forCellReuseIdentifier:ONLINE_STUDY_CELL];
        [_homeTableView registerClass:[BATHomeDoctorHorderTableViewCell class] forCellReuseIdentifier:DOCTOR_HORDER_CELL];
        [_homeTableView registerClass:[BATHomeNewHealthStepTableViewCell class] forCellReuseIdentifier:HEALTH_STEP_CELL];
        [_homeTableView registerClass:[BATHomeHealthPlanTableViewCell class] forCellReuseIdentifier:HEALTH_PLAN_CELL];
        
        [_homeTableView registerClass:[BATHomeHealthyCommunityCell class] forCellReuseIdentifier:HealthyCommunityCellID];
        
        
        [_homeTableView registerNib:[UINib nibWithNibName:NSStringFromClass([BATHomeNewsNoMoreDataFooterView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:HomeNewsNoMoreDataFooterViewID];
        
        _homeTableView.delegate = self;
        _homeTableView.dataSource = self;
        
        WEAK_SELF(self);
        _homeTableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            
            STRONG_SELF(self);
            [self requestAllData];
        }];
        
    }
    return _homeTableView;
}

- (UITextField *)searchTF {
    
    if (!_searchTF) {
        
        _searchTF = [UITextField textFieldWithfont:[UIFont systemFontOfSize:13] textColor:nil placeholder:nil BorderStyle:UITextBorderStyleNone];
        _searchTF.clearButtonMode = UITextFieldViewModeNever;
        _searchTF.text = @"搜索疾病、症状、药品、医院、养老院、医生";
        _searchTF.textColor = STRING_LIGHT_COLOR;
        
        UIView *leftIcon = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
        [leftIcon addSubview:self.searchIcon];
        [self.searchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(leftIcon);
        }];
        
        _searchTF.leftView = leftIcon;
        _searchTF.leftViewMode = UITextFieldViewModeAlways;
        _searchTF.delegate = self;
        _searchTF.bounds = CGRectMake(0, 0, SCREEN_WIDTH - 40, 30);
        _searchTF.backgroundColor = BASE_BACKGROUND_COLOR;
        
        _searchTF.layer.cornerRadius = 3.0f;
        _searchTF.clipsToBounds = YES;
    }
    return _searchTF;
}

- (UIImageView *)searchIcon {
    
    if (!_searchIcon) {
        _searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic-search"]];
    }
    return _searchIcon;
}

- (UIButton *)messageBtn {
    
    if (!_messageBtn) {
        
        _messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _messageBtn.frame = CGRectMake(0, 0, 40, 47);
        [_messageBtn setImage:[UIImage imageNamed:@"icon-ld"] forState:UIControlStateNormal];
        _messageBtn.imageView.clipsToBounds = NO;
        _messageBtn.imageView.badgeCenterOffset = CGPointMake(-4, 5);
        [_messageBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
    
        WEAK_SELF(self);
        [_messageBtn bk_whenTapped:^{
            STRONG_SELF(self);
            
            if (!LOGIN_STATION) {
                PRESENT_LOGIN_VC
                return;
            }
            
            [self goMessageVC];
        }];
    }
    return _messageBtn;
}

- (BATKangDoctorView *)kangDoctorView {
    
    if (!_kangDoctorView) {
       // 220 × 211
        _kangDoctorView = [[BATKangDoctorView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-220/2.0, SCREEN_WIDTH*42.0/75.0-220/2.0-50, 220/2.0, 211/2.0)];
        [_kangDoctorView sizeToFit];
        WEAK_SELF(self);
        [_kangDoctorView setTapped:^{
            
            //点击康博士
             [NBSAppAgent trackEvent:HOME_DOCTORKANG_BUTTON_CLICK withEventTag:@"点击康博士" withEventProperties:nil];
            
            
            STRONG_SELF(self);

//            BATDrKangViewController *kangDoctorVC = [[BATDrKangViewController alloc] init];
//            kangDoctorVC.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:kangDoctorVC animated:YES];
            
            BATNewDrKangViewController *kangDoctorVC = [[BATNewDrKangViewController alloc] init];
            kangDoctorVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:kangDoctorVC animated:YES];
        }];
        _kangDoctorView.backgroundColor = [UIColor clearColor];
    }
    return _kangDoctorView;
}

- (UIView *)bgView {
    
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _bgView.backgroundColor = UIColorFromHEX(0x323232,0.8);
    }
    return _bgView;
}

- (UIImageView *)maskImageView {
    
    if (!_maskImageView) {
        _maskImageView = [[UIImageView alloc] init];
    }
    return _maskImageView;
}

- (UIImageView *)desImageView {
    
    if (!_desImageView) {
        _desImageView = [[UIImageView alloc] init];
    }
    return _desImageView;
}

- (UIImageView *)yesImageView {
    
    if (!_yesImageView) {
        
        _yesImageView = [[UIImageView alloc] init];
        _yesImageView.userInteractionEnabled = YES;
    }
    return _yesImageView;
}

- (UIImageView *)noImageView {
    
    if (!_noImageView) {
        
        _noImageView = [[UIImageView alloc] init];
    }
    return _noImageView;
}

- (BATBackRoundGuideFloatingView *)backRoundGuideFloatingView
{
    if (_backRoundGuideFloatingView == nil) {
        
        _backRoundGuideFloatingView = [[BATBackRoundGuideFloatingView alloc] initWithFrame:CGRectMake(0, 0, 91, 23.5)];
        _backRoundGuideFloatingView.hidden = NO;
        
        
    }
    return _backRoundGuideFloatingView;
}

- (UIWebView *)cacheWebView {
    
    if (!_cacheWebView) {
        _cacheWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
        _cacheWebView.delegate = self;
        _cacheWebView.tag = 0;
    }
    return _cacheWebView;
}
#pragma mark -

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [self requestCacheUrl];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    if([error code] == NSURLErrorCancelled) {
        
    }
    else {
        
        
    }
    [self requestCacheUrl];
}

- (void)requestCacheUrl {
    
    self.cacheWebView.tag ++;
    
    if (self.cacheWebView.tag == self.cacheUrlArray.count) {
        self.cacheWebView = nil;
        return;
    }
    
    NSString *url = self.cacheUrlArray[self.cacheWebView.tag];
    

    
    [self.cacheWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

- (void)cacheBegin {
    
    NSString *firstUrl = @"http://m.km1818.com/bat/rcxyzd.html";

    [self.cacheWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:firstUrl]]];
}

- (NSArray *)cacheUrlArray {
    
    if (!_cacheUrlArray) {
        
        NSString *health360Url;
        if (LOGIN_STATION) {
            
            BATPerson *person = PERSON_INFO;
            
            NSString *appkey = @"e38ad4f48133c76ad8e6165ccc427211";
            NSString *appSecret = @"dbf2dcc52133c76ad8e61600eeafa583";
            NSString *timestamp = [Tools getDateStringWithDate:[NSDate date] Format:@"yyyy-MM-dd HH:mm:ss"];//当前日期
            NSString *phone = person.Data.PhoneNumber;//手机号
            
            NSArray *array = @[appkey,appSecret,timestamp];
            
            array = [array sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                return [obj1 compare:obj2];
            }];
            
            NSString *tmpSign = @"";
            for (NSString *string in array) {
                tmpSign = [tmpSign stringByAppendingString:string];
            }
            
            NSString *sign = [Tools md5String:tmpSign];
            
            health360Url = [NSString stringWithFormat:@"%@?appkey=%@&timestamp=%@&sign=%@&phone=%@&src=2",KM_HEALTH360_URL,appkey,timestamp,sign,phone];
        }
        else {
            
            health360Url = [NSString stringWithFormat:@"%@?appkey=&timestamp=&sign=&phone=0&src=2",KM_HEALTH360_URL];
        }
        
        _cacheUrlArray = @[
                           health360Url,
                           @"http://m.km1818.com/bat/rcxyzd.html?kmCloud",
                           @"http://m.km1818.com/bat/jkcs.html?kmCloud",
                           @"http://m.km1818.com/bat/ylqx.html?kmCloud",
                           @"http://m.km1818.com/bat/bjg.html?kmCloud",
                           @"http://m.km1818.com/wap/afzy01.html?kmCloud",
                           @"http://m.km1818.com/wap/518ss.html?kmCloud",
                           @"http://m.km1818.com/bat/tejia.html?kmCloud",
                           ];
        
    }
    return _cacheUrlArray;
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
