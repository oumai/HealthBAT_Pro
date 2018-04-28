//
//  BATHealthThreeSecondsController.m
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/12/11.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHealthThreeSecondsController.h"
#import "BATHealthThreeSecondsStatisController.h"
#import "BATHealthThreeSecondSleepController.h"
#import "BATHealthThreeSecondsCalendarController.h"  //日历
#import "BATHealthThreeSecondsFoodEnterController.h" //食物录入
#import "BATHealthThreeSecondsDetailController.h" // 详情
#import "BATHealthyReportViewController.h"   //报告
#import "BATHealthyInfoViewController.h" // 修改资料
#import "BATEatSearchTwiceViewController.h" // 搜索

#import "HealthKitManage.h"
#import "BATPhotoPickHelper.h"
#import "TZImagePickerController.h"
#import <SVProgressHUD/SVProgressHUD.h>

#import "BATHealthThreeSecondsDateCell.h"  //日期
#import "BATHealthThreeSecondsCameraCell.h"  //相机
#import "BATHealthThreeSecondsArrowCell.h"
#import "BATHealthThreeSecondsRunRecordCell.h"  //跑步记录
#import "BATHealthThreeSecondsHumorCell.h"    //表情
#import "BATHealthThreeSecondsEmojiView.h"   //表情
#import "BATHealthThreeSecondsDrinkWateRecordCell.h" //喝水记录
#import "BATHealthThreeSecondsModel.h"
#import "BATPerson.h"
#import "UIColor+Gradient.h"
#import "UIButton+TouchAreaInsets.h"
#import "BATHealthThreeSecondsTopChangeDateView.h"
//
#import "BATClockManager.h"


static NSString *const DateCellID = @"BATHealthThreeSecondsDateCell";
static NSString *const CameraCellID = @"BATHealthThreeSecondsCameraCell";
static NSString *const ArrowCellID = @"BATHealthThreeSecondsArrowCell";
static NSString *const RunRecordCellID = @"BATHealthThreeSecondsRunRecordCell";
static NSString *const DrinkWateRecordCellID = @"BATHealthThreeSecondsDrinkWateRecordCell";
static NSString *const HumorCellID = @"BATHealthThreeSecondsHumorCell";

@interface BATHealthThreeSecondsController ()<UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, TZImagePickerControllerDelegate, BATHealthThreeSecondsTopChangeDateViewDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)UIButton *bottomHealthReportButton;
@property(nonatomic, strong)UIButton *tableViewFooterButton;
@property(nonatomic, assign)double stepNum;
@property(nonatomic, assign)BOOL isGetStep;
//@property(nonatomic, strong)UIImage *selImage;
@property(nonatomic, strong)NSMutableDictionary *dataSourceDictM;
@property(nonatomic, strong)NSMutableDictionary *parameterDictM;
@property(nonatomic, strong)BATHealthThreeSecondsModel *model;
@property(nonatomic, strong)BATPerson *loginUserModel;
@property(nonatomic, strong)NSString *date;
@end

@implementation BATHealthThreeSecondsController

- (void)dealloc{
    
    DDLogDebug(@"===BATHealthThreeSecondsController====dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    [self commonInit];
    [self registerCell];
    [self addNotification];
    [self getStepCount:self.date];
    [self loadDataRequest:self.date];
    //注册本地通知
    [self registerLocalNotification];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    BOOL birthday = self.loginUserModel.Data.Birthday.length;
    BOOL height = self.loginUserModel.Data.Height;
    BOOL weight = self.loginUserModel.Data.Weight;
    
    NSString *formatStr = ( birthday && height && weight) ?  @"修改个人资料" : @"完善个人资料";
    [self.tableViewFooterButton setTitle:formatStr forState:UIControlStateNormal];
    
    
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    [self.bottomHealthReportButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.mas_equalTo(0);
        make.height.equalTo(@58);
        
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.bottom.mas_equalTo(self.bottomHealthReportButton.mas_top).offset(-5);
        
    }];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
        //移除BATHealthyInfoViewController
        NSMutableArray *childVcs = [NSMutableArray arrayWithArray:self.navigationController.childViewControllers];
        for (UIViewController *tempVC in childVcs) {
            
            if ([tempVC isKindOfClass:[BATHealthyInfoViewController class]]) {
                
                [childVcs removeObject:tempVC];
                break;
                
            }
            
        }
        self.navigationController.viewControllers = childVcs;
}



#pragma mark - 初始化

     
- (void)commonInit{
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bottomHealthReportButton];
    [self.view addSubview:self.tableView];
    self.loginUserModel = PERSON_INFO;
    self.date = [self dateConverStr];
        
}
- (void)addNotification{
    
    //添加食物成功刷新数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addFoodSuccessRefreshData:) name:@"ADDFOODSUCCESSREFRESHDATA" object:nil];
   
}

/**
 将当期日期转为字符串日期
 */
- (NSString *)dateConverStr{
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    return  [formatter stringFromDate:date];
}
/**
 设置导航栏
 */
- (void)setupNav{
    
    self.title = @"健康3秒钟";
   
//    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 15, 15)];
//    backButton.touchAreaInsets = UIEdgeInsetsMake(20, 20, 20, 20);
//    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    [backButton setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
//    backButton.imageView.contentMode = UIViewContentModeLeft;
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];


    UIButton *recordButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    [recordButton addTarget:self action:@selector(recordButtonClick)
           forControlEvents:UIControlEventTouchUpInside];
    [recordButton setTitle:@"统计" forState:UIControlStateNormal];
    recordButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [recordButton setTitleColor:UIColorFromHEX(0x6ccc56, 1) forState:UIControlStateNormal];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:recordButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
}

/**
 注册cell
 */
- (void)registerCell{
    
    //[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ID"];
    [self.tableView registerClass:[BATHealthThreeSecondsDateCell class] forCellReuseIdentifier:DateCellID];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BATHealthThreeSecondsCameraCell class]) bundle:nil] forCellReuseIdentifier:CameraCellID];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BATHealthThreeSecondsArrowCell class]) bundle:nil] forCellReuseIdentifier:ArrowCellID];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BATHealthThreeSecondsRunRecordCell class]) bundle:nil] forCellReuseIdentifier:RunRecordCellID];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BATHealthThreeSecondsDrinkWateRecordCell class]) bundle:nil] forCellReuseIdentifier:DrinkWateRecordCellID];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BATHealthThreeSecondsHumorCell class]) bundle:nil] forCellReuseIdentifier:HumorCellID];
    
}

- (void)registerLocalNotification {
    
    NSInteger accountID = self.loginUserModel.Data.AccountID;
    NSInteger saveAccountID = [[NSUserDefaults standardUserDefaults] integerForKey:isRecordHealthThreeSecondAccountID];
    if (accountID != saveAccountID) {//切换账号后，首次进入健康三秒钟界面则从新注册本地通知
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:isRecordHealthThreeSecondNotification];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:BATHealthThreeSecondDateKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    if ([[NSUserDefaults standardUserDefaults] boolForKey:isRecordHealthThreeSecondNotification] == NO) {
        [[BATClockManager shared] registerHealthThreeSecondLocalNotificationWithTitle:nil body:@"要坚持记录，为你的健康打卡！"date:nil];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:isRecordHealthThreeSecondNotification];
        [[NSUserDefaults standardUserDefaults] setInteger:accountID forKey:isRecordHealthThreeSecondAccountID];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}
#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0 || section == 4 ||section == 5) {
        return 1;
    }
    return 2;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    //日历
    if (indexPath.section == 0) {
        
        BATHealthThreeSecondsDateCell  *dateCell = [tableView dequeueReusableCellWithIdentifier:DateCellID];
        dateCell.topChangeDateView.delegate = self;
        dateCell.topChangeDateView.defauDateStr = self.date;

        return dateCell;
        
        
        //饮食详情
    }else if (indexPath.section == 1) {
        
        
        if (indexPath.row == 0) {
            
            BATHealthThreeSecondsArrowCell *arrowCell = [tableView dequeueReusableCellWithIdentifier:ArrowCellID];
            arrowCell.iconImageView.image = [UIImage imageNamed:@"diet"];
            arrowCell.infoButton.hidden = YES;
            arrowCell.rightLabel.hidden = NO;
            arrowCell.arrowImageView.hidden = NO;
            arrowCell.leftLabel.text = @"饮食指南";
            arrowCell.rightLabel.text = @"饮食详情";
            return arrowCell;
            
        }else{
            //相机
            BATHealthThreeSecondsCameraCell *cameraCell = [tableView dequeueReusableCellWithIdentifier:CameraCellID];
            cameraCell.calorieLabel.text = [NSString stringWithFormat:@"%@卡路里",self.model.CaloriesIntake];
            cameraCell.cameraButtonClick = ^{
                [self cameraButtonClick];
            };
            return cameraCell;
            
        }
        
        
        //喝水记录
    }else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            
            BATHealthThreeSecondsArrowCell *arrowCell = [tableView dequeueReusableCellWithIdentifier:ArrowCellID];
            arrowCell.iconImageView.image = [UIImage imageNamed:@"Drink_water"];
            arrowCell.rightLabel.hidden = YES;
            arrowCell.arrowImageView.hidden = YES;
            arrowCell.infoButton.hidden = NO;
            arrowCell.leftLabel.text = @"喝水记录";
            arrowCell.infoButtonBlock = ^{
                [self showText:@"每杯水200ml"];
            };
            return arrowCell;
            
        }else{
            
             BATHealthThreeSecondsDrinkWateRecordCell *drinkWaterRecordCell = [tableView dequeueReusableCellWithIdentifier:DrinkWateRecordCellID];
            UIImage *image = self.model.DrinkingWater ? [UIImage imageNamed:@"Minus_SignH"] :  [UIImage imageNamed:@"Minus_Sign"];
            [drinkWaterRecordCell.reduceButton setImage:image forState:UIControlStateNormal];
            drinkWaterRecordCell.drinkingWaterCount = self.model.DrinkingWater;
            drinkWaterRecordCell.wateCountLabel.text = [NSString stringWithFormat:@"x  %ld",(long)self.model.DrinkingWater];
            
            //点击问号详情
            drinkWaterRecordCell.drinkWateRecordInfoBlock = ^{
                
                [SVProgressHUD showInfoWithStatus:@"每被杯水容量为200ml哦~"];
                
            };
            
            //喝水加减一
            drinkWaterRecordCell.drinkWateButtonBlock = ^(NSInteger wateCount) {
//              NSInteger maxDrinkWateCount = self.loginUserModel.Data.Weight > 200 ? 15 : 12;
                if (wateCount > 25) {
                    [self showText:@"每天最多可以喝25杯水哦~"];
                    return ;
                }
                 
                //组装参数更新数据
                [self.parameterDictM setValue:[NSString stringWithFormat:@"%ld",(long)wateCount] forKey:@"DrinkingWater"];
                [self updateDataRequestWithDict:self.parameterDictM indexPath:indexPath];
            };
            
            
            return drinkWaterRecordCell;
            
        }
        
        
        //步数记录
    }else if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            
            BATHealthThreeSecondsArrowCell *arrowCell = [tableView dequeueReusableCellWithIdentifier:ArrowCellID];
            arrowCell.iconImageView.image = [UIImage imageNamed:@"steps"];
            arrowCell.infoButton.hidden = YES;
            arrowCell.rightLabel.hidden = YES;
            arrowCell.arrowImageView.hidden = NO;
            arrowCell.leftLabel.text = @"步数记录";
            
            return arrowCell;
        }else{
            //N步数=N*0.6*0.001公里=60*N*0.6*0.001*1.036卡路里
            BATHealthThreeSecondsRunRecordCell *runRecordCell = [tableView dequeueReusableCellWithIdentifier:RunRecordCellID];
            runRecordCell.accessoryType = UITableViewCellAccessoryNone;
            runRecordCell.stepCountLabel.text = [NSString stringWithFormat:@"%.0f",self.stepNum];
            if (self.stepNum) {
                runRecordCell.calorieLabel.text = [NSString stringWithFormat:@"%0.2f公里/%0.2f卡路里",self.stepNum*0.6*0.001,self.stepNum*0.04];
            }else{
                runRecordCell.calorieLabel.text = @"0公里/0卡路里";
            }
            
            return runRecordCell;
            
        }
        
        
        //睡眠指南
    }else if (indexPath.section == 4) {
        
        BATHealthThreeSecondsArrowCell *arrowCell = [tableView dequeueReusableCellWithIdentifier:ArrowCellID];
        arrowCell.iconImageView.image = [UIImage imageNamed:@"sleep"];
        arrowCell.leftLabel.text = @"睡眠指南";
        arrowCell.rightLabel.text = [NSString stringWithFormat:@"%@小时",self.model.SleepHours];
        arrowCell.infoButton.hidden = YES;
        arrowCell.rightLabel.hidden = NO;
        arrowCell.arrowImageView.hidden = NO;
        return arrowCell;
        
        //心情
    }else if (indexPath.section == 5) {
        
        BATHealthThreeSecondsHumorCell *humorCell = [tableView dequeueReusableCellWithIdentifier:HumorCellID];
        if (self.model.Mood) {
            humorCell.emojiButtonBgView.selIndex = self.model.Mood;
        }
        //心情状态,1.高兴,2.愉快,3.平和,4.低落,5.生气,0.未填写心情记录
        humorCell.emojiButtonBgView.emojiButtonBlock = ^(NSInteger emojiBtnTag) {
//            NSLog(@"表情按钮的tag是===%ld",emojiBtnTag);
            //组装参数,更新数据
            [self.parameterDictM setValue:[NSString stringWithFormat:@"%ld",(long)emojiBtnTag] forKey:@"Mood"];
            [self updateDataRequestWithDict:self.parameterDictM indexPath:indexPath];
            
        };
        
        return humorCell;
    }
    
    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 45;
    }else if (indexPath.section == 1){
        
        return indexPath.row ? 205/2 : 47.5;
        
    }else if (indexPath.section == 2){
        return indexPath.row ? 136/2 : 47.5;
        
    }else if (indexPath.section == 3){
        return indexPath.row ? 136/2 : 47.5;
        
    }else if (indexPath.section == 4){
        return  104/2;
        
    }else if (indexPath.section == 5){
        
        return  106/2;
    }
    
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 饮食详情
    if (indexPath.section == 1 && indexPath.row == 0) {
        
        NSLog(@"=====进入饮食详情");
        BATHealthThreeSecondsDetailController *detailVC = [[BATHealthThreeSecondsDetailController alloc]init];
        detailVC.date = self.date;
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }else if (indexPath.section == 3 ) {////健康步数

        [self alertShowMessage:@"请前往-设置->隐私->健康->健康BAT-打开权限" cancelBtnTitle:@"确定"];
        
        
    }else if (indexPath.section == 4) { //闹钟
        BATHealthThreeSecondSleepController *sleepVC = [[BATHealthThreeSecondSleepController alloc] initWithSelectedDate:self.date
                                                                                                                 bedTime:self.model.BedTime
                                                                                                               getUpTime:self.model.GetUpTime makeSureComplete:^(NSDictionary *timeDict) {
            self.model.SleepHours = [timeDict objectForKey:@"SleepHours"];
            //组装参数更新数据
            [self.parameterDictM addEntriesFromDictionary:timeDict];
             [self updateDataRequestWithDict:self.parameterDictM indexPath:indexPath];
            
        }];
        
        [self.navigationController pushViewController:sleepVC animated:YES];
        
    }
    
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 55)];
        headView.backgroundColor = [UIColor whiteColor];
        
        UILabel *headLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 30)];
        headLabel.textColor = UIColorFromHEX(0x333333, 1);
        headLabel.font = [UIFont boldSystemFontOfSize:16];
        headLabel.textAlignment = NSTextAlignmentCenter;
        headLabel.backgroundColor = [UIColor whiteColor];
        headLabel.text = @"每日健康指标";
        [headView addSubview:headLabel];
        return headView;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 55;
    }
    return CGFLOAT_MIN;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 5) {
        return CGFLOAT_MIN;
    }
    return 10;
}
#pragma mark - BATHealthThreeSecondsTopChangeDateViewDelegate

- (void)leftButtonDidClick:(UIButton *)leftButton date:(NSString *)date{
    
     [self getCurrentDataWithDate:date];
    
}

- (void)centerButtonDidClick:(UIButton *)centerButton callBackBlock:(void (^)(NSString *))callBackBlock{
    
    BATHealthThreeSecondsCalendarController *calendarVC = [[BATHealthThreeSecondsCalendarController alloc]init];
    calendarVC.selectedDateStr = self.date;
    [self.navigationController pushViewController:calendarVC animated:YES];
    calendarVC.backBlock = ^(NSString *selDate) {
        
        _date = selDate;
        callBackBlock(selDate);
        
        [self getCurrentDataWithDate:selDate];
    };
    
}
- (void)rightButtonDidClick:(UIButton *)rightButton date:(NSString *)date{
   
    [self getCurrentDataWithDate:date];
    
}

- (void)getCurrentDataWithDate:(NSString *)date{
    
    self.date = date;
    //请求当天数据                                              
    [self loadDataRequest:date];
    //获取当天步数
    [self getStepCount:date];
}
#pragma mark - Action
/**
 导航栏返回按钮点击
 */
- (void)backButtonClick{
    
//    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
    
}
/**
 点击统计按钮
 */
- (void)recordButtonClick{
    
    BATHealthThreeSecondsStatisController *statisVC = [[BATHealthThreeSecondsStatisController alloc] init];
    [self.navigationController pushViewController:statisVC animated:YES];
}
/**
 每日健康报告调用  
 */
- (void)bottomHealthReportButtonClick{
    
    //必要条件
    BOOL height = self.loginUserModel.Data.Height;
    BOOL Weight = self.loginUserModel.Data.Weight;
    BOOL Birthday = self.loginUserModel.Data.Birthday.length;
    
    //年龄必须在18到64之间
    if (self.loginUserModel.Data.Age < 18   || self.loginUserModel.Data.Age > 64) {
         [self alertShowMessage:@"抱歉，暂时无法评估，您的年龄不在评估范围18岁—64岁内" cancelBtnTitle:@"确定"];
        return;
    }
    
    //必要条件
    if (!height || !Weight || !Birthday) {
        //弹出健康资料界面
          [self alertShowMessage:@"暂时无法进行健康评估,请先完善健康资料" cancelBtnTitle:@"取消"];
        return;
    }
    
    
    NSInteger count = 0;
    
    if (self.model.DrinkingWater) {  //饮水
        count ++;
    }

    if (self.model.Mood) { //表情
        count ++;
    }

    if (![self.model.CaloriesIntake isEqualToString:@"0.00"]) { //卡路里
        count ++;
    }

    if (![self.model.SleepHours isEqualToString:@"0.00"]) { //睡眠
        count ++;
    }
    if (self.stepNum) { //步数
        count ++;
    }
    
    //5个条件中是否满足3个条件
    BOOL isGetReport = count <3 ? NO : YES;
    
    if (!isGetReport) {
        //弹出健康资料界面
        [self alertShowMessage:@"请至少提供三项健康数据" cancelBtnTitle:@"确定"];
        return;
    }
    
    //健康报告界面
    BATHealthyReportViewController *reportVC = [[BATHealthyReportViewController alloc]init];
    reportVC.date = self.date;
    reportVC.Calory = self.model.CaloriesIntake;
    reportVC.DrinkCupNum = [NSString stringWithFormat:@"%ld",(long)self.model.DrinkingWater];
    reportVC.SleepHour = self.model.SleepHours;
    reportVC.Steps = [NSString stringWithFormat:@"%.0f",self.stepNum];
    reportVC.Mood = [NSString stringWithFormat:@"%ld",(long)self.model.Mood];
    [self.navigationController pushViewController:reportVC animated:YES];
    
}
/**
 健康报告提示信息
 */
- (void)alertShowMessage:(NSString *)message cancelBtnTitle:(NSString *)cancelTitle{
    

    UIAlertController *alertSheet = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    if ([message isEqualToString:@"暂时无法进行健康评估,请先完善健康资料"]) {
        
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"去完善" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self pushEditInfoVC];
            
            
        }];
        
         [alertSheet addAction:sureAction];
    }
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    
    }];
     [alertSheet addAction:cancelAction];
   
    [self presentViewController:alertSheet animated:YES completion:nil];
    
}

/**
 修改完善个人信息
 */
- (void)pushEditInfoVC{
    
    BATHealthyInfoViewController *editInfoVc = [[BATHealthyInfoViewController alloc]init];
    editInfoVc.isShowNavButton = NO;
    [self.navigationController pushViewController:editInfoVc animated:YES];
    
}
/**
 进入食物录入界面
 */
- (void)pushFoodEnterVcWithImage:(UIImage *)selImage dateStr:(NSString *)dateStr{
    
    BATHealthThreeSecondsFoodEnterController *foodEnterVc = [[BATHealthThreeSecondsFoodEnterController alloc]initWithSelImage:selImage date:dateStr];
//    foodEnterVc.selImage = selImage;
//    foodEnterVc.dateStr = self.date;
    [self.navigationController pushViewController:foodEnterVc animated:YES];
    
}
/**
 点击相机调用
 */
- (void)cameraButtonClick{
    
    WeakSelf
    UIAlertController *alertSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //调用相机
        if (![BATPhotoPickHelper checkCameraAuthorizationStatus]) {
            return;
        }
        UIImagePickerController *pickerVc = [[UIImagePickerController alloc]init];
        pickerVc.delegate = weakSelf;
        pickerVc.sourceType =  UIImagePickerControllerSourceTypeCamera;
        [weakSelf presentViewController:pickerVc animated:YES completion:nil];
        
    }];
    
    
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //从相册选择
        [self choosePhoto];
        
    }];
    
    UIAlertAction *manualAction = [UIAlertAction actionWithTitle:@"手动" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //跳转到搜索界面
        BATEatSearchTwiceViewController *searchVc = [[BATEatSearchTwiceViewController alloc]init];
        searchVc.dateStr = self.date;
        [weakSelf.navigationController pushViewController:searchVc animated:YES];
        
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertSheet addAction:cameraAction];
    [alertSheet addAction:photoAction];
    [alertSheet addAction:manualAction];
    [alertSheet addAction:cancelAction];
    
    [self presentViewController:alertSheet animated:YES completion:nil];
    
    
}
/**
 从相册选择
 */
- (void)choosePhoto{
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePickerVc.photoWidth = SCREEN_WIDTH;
    imagePickerVc.allowPickingMultipleVideo = NO;
    // 你可以通过block或者代理，来得到用户选择的照片.
    WeakSelf
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {

        [weakSelf pushFoodEnterVcWithImage:photos.lastObject dateStr:weakSelf.date];
      
        
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
    
}

#pragma mark - 获取步数

/**
 获取步数
 */
- (void)getStepCount:(NSString *)dateStr
{
    
    //将字符串转为时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //  设置日期格式
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *date = [formatter dateFromString:dateStr];
    
    //获取步数
    HealthKitManage *manage = [HealthKitManage shareInstance];
    WEAK_SELF(self);
    
    [manage authorizeHealthKit:^(BOOL success, NSError *error) {
        
        if (success) {
            [manage getStepCountFromDate:date completion:^(double value, NSError *error) {
                STRONG_SELF(self);
                
                if (value) {
                    
                    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 *NSEC_PER_SEC));
                    dispatch_after(time, dispatch_get_main_queue(), ^{
                        self.isGetStep = YES;
                        self.stepNum = value;
                        self.model.WalkSteps = [NSString stringWithFormat:@"%f",value];
                        
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:3];
                        //刷新
//                        [self.tableView reloadRowsAtIndexPaths:@[indexPath,] withRowAnimation:UITableViewRowAnimationNone];
                        
                        //主动更新行走步数
                        NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
                        [dictM setValue:@(value) forKey:@"WalkSteps"];
                        [dictM setValue:dateStr forKey:@"DataDate"];
                        [self updateDataRequestWithDict:dictM indexPath:indexPath];
                        
                        
                    });
                }
                
            }];
            
        }
        else {
            self.stepNum = 0;
            self.isGetStep = NO;
        }
    }];
}

#pragma mark - Request
#pragma mark - 获取当前时间段数据
- (void)addFoodSuccessRefreshData:(NSNotification *)notification{
//    NSLog(@"%@===",notification);
    self.date =  [notification.userInfo objectForKey:@"date"];
    
    [self loadDataRequest:self.date];
    
}
- (void)loadDataRequest:(NSString  *)dateStr{
    

    //组装参数
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    dictM[@"Data.AccountID"] = @(self.loginUserModel.Data.AccountID);
    dictM[@"date"] = dateStr;
    
    WeakSelf
    [HTTPTool requestWithURLString:@"api/EatCircle/GetHealthData" parameters:dictM type:kGET success:^(id responseObject) {
        
        
        DDLogDebug(@"---------%@",responseObject);
        
        weakSelf.model = [BATHealthThreeSecondsModel mj_objectWithKeyValues:responseObject[@"Data"]];
        
        [weakSelf.tableView reloadData];
        
    } failure:^(NSError *error) {
        
        DDLogDebug(@"---------%@",error);
        [self showErrorWithText:@"网络异常,请稍微再试~"];
    }];
    
    
}
#pragma mark - 更新数据
- (void)updateDataRequestWithDict:(NSMutableDictionary *)dictM
                        indexPath:(NSIndexPath*)indexPath{
    
    WeakSelf
    /*
     AccountID    用户ID    number
     DataDate    数据日期    string
     CaloriesIntake    当天摄入的总卡路里数    number
     DrinkingWater    当天喝水总杯数    number
     WalkingDistance    行走距离    number
     CaloriesConsume    当天消耗的总卡路里数    number
     WalkSteps    步数    number
     SleepHours    睡眠小时数    number
     BedTime    就寝时间    string
     GetUpTime    起床时间    string
     Mood    心情状态,2非常好,1好,0一般,-1不好,-2很糟糕    number
     LastModifiedTime    数据更新时间    string
     ResultCode    返回码，0 代表无错误 -1代表有错误
     
     */
    dictM[@"AccountID"] = @(self.loginUserModel.Data.AccountID);
    dictM[@"DataDate"] = self.date;    //日期
    
    [HTTPTool requestWithURLString:@"api/EatCircle/UpdateHealthData" parameters:dictM type:kPOST success:^(id responseObject) {
        
        
        weakSelf.model = [BATHealthThreeSecondsModel mj_objectWithKeyValues:responseObject[@"Data"]];
        
//        [weakSelf.tableView reloadData];
        //刷新
        [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
    } failure:^(NSError *error) {
        
        [self showErrorWithText:@"网络异常,请稍微再试~"];
    }];
    
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    // 选取完图片后跳转回原控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    // 从info中将图片取出，并加载到imageView当中
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
//    self.selImage = image;
    // 创建保存图像时需要传入的选择器对象（回调方法格式固定）
    SEL selectorToCall = @selector(image:didFinishSavingWithError:contextInfo:);
    // 将图像保存到相册（第三个参数需要传入上面格式的选择器对象）
    UIImageWriteToSavedPhotosAlbum(image, self, selectorToCall, NULL);
    
}
// 保存图片后到相册后，回调的相关方法，查看是否保存成功
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error == nil){
        DDLogDebug(@"%@-------=======",contextInfo);
        //保存照片成功后重新加载数据
        [self pushFoodEnterVcWithImage:image dateStr:self.date];
        
    } else {
        DDLogDebug(@"保存照片失败");
    }
}


#pragma mark - lazy load

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = self.tableViewFooterButton;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        
    }
    return _tableView;
}

- (UIButton *)bottomHealthReportButton{
    if (!_bottomHealthReportButton) {
        _bottomHealthReportButton = [[UIButton alloc]init];
        _bottomHealthReportButton.backgroundColor = UIColorFromHEX(0x6ccc56, 1);
        [_bottomHealthReportButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _bottomHealthReportButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_bottomHealthReportButton setTitle:@"每日健康报告" forState:UIControlStateNormal];
        [_bottomHealthReportButton addTarget:self action:@selector(bottomHealthReportButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomHealthReportButton;
}
- (UIButton *)tableViewFooterButton{
    if (!_tableViewFooterButton) {
        _tableViewFooterButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
        _tableViewFooterButton.backgroundColor = [UIColor whiteColor];
        _tableViewFooterButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_tableViewFooterButton setTitleColor:[UIColor gradientFromColor:START_COLOR toColor:END_COLOR withHeight:70] forState:UIControlStateNormal];
      
        [_tableViewFooterButton addTarget:self action:@selector(pushEditInfoVC) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tableViewFooterButton;
}
- (NSMutableDictionary *)parameterDictM{
    if (!_parameterDictM) {
        _parameterDictM = [NSMutableDictionary dictionary];
    }
    return _parameterDictM;
}
- (NSMutableDictionary *)dataSourceDictM{
    if (!_dataSourceDictM) {
        _dataSourceDictM = [NSMutableDictionary dictionary];
    }
    return _dataSourceDictM;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
