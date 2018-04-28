//
//  BATKangDoctorViewController.m
//  HealthBAT_Pro
//
//  Created by Skyrim on 2017/1/5.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDrKangViewController.h"

#import "BATDrKangAskInputBar.h"
#import "BATDrKangInputBar.h"

#import "BATEqualCellSpaceFlowLayout.h"
#import "BATDrKangBottomCollectionViewCell.h"
#import "BATDrKangDiseaseView.h"
#import "BATDrKangDetailView.h"

#import "BATDrKangModel.h"
#import "BATDrKangResultModel.h"
#import "BATDrKangIntroductionModel.h"
#import "BATDrKangMsgHistoryModel.h"
#import "BATLoginModel.h"
#import "BATPerson.h"

#import "BATRegisterHospitalListViewController.h"//预约挂号
#import "BATRegisterDepartmentListViewController.h"//预约挂号科室
#import "BATKangDoctorHospitalListViewController.h"
#import "BATDrKangHistoryViewController.h"//历史记录
#import "BATHealthThreeSecondsController.h"  //健康3秒钟
#import "BATHealthyInfoViewController.h"  //健康3秒钟健康资料
#import "BATHealthThreeSecondsStatisController.h" //健康3秒钟 统计
#import "BATHealth360EvaluationViewController.h"//健康360健康评估
#import "BATFindDoctorListViewController.h"//健康咨询 医生列表界面

#import "BATJSObject.h"//JS

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <AVFoundation/AVFoundation.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件

//第三方
#import "STPickerSingle.h"
#import "STPickerDate.h"
#import "YCXMenu.h"

#import "iflyMSC/IFlyMSC.h"
#import "ISRDataHelper.h"

#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"

static  NSString * const DEVICE_FIRST_RECORD = @"DEVICE_FIRST_RECORD";

static  NSString * const BOTTOM_CELL = @"BottomCollectionViewCell";

#define HistoryPath [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/HistoryPath.sqlite"]


/**
 康博士当前页面状况

 - BATDrKangViewStationChat: 聊天
 - BATDrKangViewStationWelcome: 欢迎
 - BATDrKangViewStationAskView: 特殊问题页面
 */
typedef NS_ENUM(NSInteger, BATDrKangViewStation) {
    
    BATDrKangViewStationChat = 1000,
    BATDrKangViewStationWelcome = 1001,
    BATDrKangViewStationAskView = 1002,
};

/**
 康博士右上角按钮枚举

 - BATDrKangRightBarButtonHistory: 历史智能问诊
 - BATDrKangRightBarButtonEvaluation: 健康评估
 - BATDrKangRightBarButtonHealthThreeSecond: 健康3秒钟
 */
typedef NS_ENUM(NSInteger, BATDrKangRightBarButtonItems) {

    BATDrKangRightBarButtonHistory = 2000,
    BATDrKangRightBarButtonEvaluation = 2001,
    BATDrKangRightBarButtonHealthThreeSecond = 2002,
};

@interface BATDrKangViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,AVAudioPlayerDelegate,YYTextViewDelegate,IFlySpeechRecognizerDelegate,IFlySpeechSynthesizerDelegate,BMKGeoCodeSearchDelegate,UIWebViewDelegate,STPickerSingleDelegate,STPickerDateDelegate>

//JS
@property (nonatomic,strong) JSContext *context;
@property (nonatomic,copy) NSString *webFilePath;

@property (nonatomic,strong) NSArray *items;//右上合集按钮

//咨询基本信息UI 欢迎UI
@property (nonatomic,strong) UIButton *navBackButton;
@property (nonatomic,strong) UIImageView *topImageView;
@property (nonatomic,strong) BATDrKangAskInputBar *askInputBar;
@property (nonatomic,strong) UIButton *questionButton;

//chatUI
@property (nonatomic,strong) UIImageView *titleImageView;
@property (nonatomic,strong) UIWebView *chatWebView;//聊天主体（H5）
@property (nonatomic,strong) NSMutableArray *bottomKeyArray;
@property (nonatomic,strong) UICollectionView *bottomCollectionView;//底部快速按钮
@property (nonatomic,strong) BATDrKangInputBar *inputBar;//底部输入栏
@property (nonatomic,assign) BOOL isIntelligent;//判断是否进入智能问诊模式

@property (nonatomic,strong) BATDrKangDetailView *detailView;
@property (nonatomic,strong) BATDrKangDiseaseView *diseaseView;

//音乐播放
@property (nonatomic,strong) AVAudioPlayer *audioPlayer;

//语音识别
@property (nonatomic,strong) UIImageView *voiceAlertView;
@property (nonatomic,strong) IFlySpeechRecognizer *iFlySpeechRecognizer;//不带界面的识别对象
@property (nonatomic,copy) NSString *result;

//语音合成
@property (nonatomic,strong) IFlySpeechSynthesizer *iFlySpeechSynthesizer;

//地理坐标
@property (nonatomic,assign) BOOL isFirstLocationFail;
@property (nonatomic,assign) BOOL isGetLocation;
@property (nonatomic,assign) CLLocationCoordinate2D currentLocation;
@property (nonatomic,assign) double hospitalLatitude;
@property (nonatomic,assign) double hospitalLongitude;

//最大字数
@property (nonatomic,assign) int maxWordNumber;

//数据库，历史记录存储
@property (nonatomic,strong) FMDatabase *historyDB;

@property (nonatomic,assign) BOOL isExecutiveOrder;//记录是否正在执行order，当order执行完返回康博士时，需要发出end命令
@property (nonatomic,assign) BATDrKangViewStation station;//康博士当前页面状态

@end

@implementation BATDrKangViewController

- (void)dealloc {
    
    self.titleImageView.hidden = YES;
    self.titleImageView = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.title = @"康博士";
    
    self.result = @"";
    self.isFirstLocationFail = YES;
    self.isIntelligent = NO;
    
    //本地记录历史记录
    [self createDatabaseTable];
    
//    self.bottomKeyArray = @[@"智能问诊",@"常见疾病",@"历史评估",@"健康3秒钟"];
    self.bottomKeyArray = [NSMutableArray array];
    self.maxWordNumber = 100;
    
    //加载本地html文件
    NSString *resPath = [[NSBundle mainBundle] resourcePath];
    self.webFilePath = [resPath stringByAppendingPathComponent:@"msgBoxIndex.html"];
    [self.chatWebView loadRequest:[[NSURLRequest alloc] initWithURL:[[NSURL alloc] initFileURLWithPath:self.webFilePath]]];
    // 加载子控件
    [self layoutPages];
    //判断是否为初次进入
    if ([[NSUserDefaults standardUserDefaults] boolForKey:DEVICE_FIRST_RECORD] != YES) {

        [self showWelcomeView];
    }
    else {

        [self showChat];
        [self sendTextRequestWithContent:@"start" isSound:NO];
    }
    
    //keyboard
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //开始定位
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BEGIN_GET_LOCATION" object:nil];

    //定位成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLocationInfo:) name:@"LOCATION_INFO" object:nil];
    //定位失败，用深圳作为默认地址
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLocationFailure) name:@"LOCATION_FAILURE" object:nil];
    
    //评价通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(evaluationSendMessage:) name:@"DrKangEvaluationResultNotification" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:DEVICE_FIRST_RECORD] != YES) {
        
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    else {
        self.titleImageView.hidden = NO;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    if (self.isExecutiveOrder) {
        [self sendTextRequestWithContent:@"end" isSound:NO];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self.iFlySpeechSynthesizer stopSpeaking];
    [self.iFlySpeechRecognizer stopListening];
    
    [self.diseaseView removeFromSuperview];
    self.diseaseView = nil;
    
    self.titleImageView.hidden = YES;
}

#pragma mark - UIWebViewDelegate
- (void)sendMsg:(NSString *)content {
    
    NSString *avatarUrl = @"";
    if (LOGIN_STATION) {
        BATPerson *person = PERSON_INFO;
        avatarUrl = person.Data.PhotoPath;
    }
    
    if (avatarUrl == nil) {
        avatarUrl = @"";
    }
    
    if (!content) {
        content = @"";
    }
    NSDictionary *dic = @{@"content":content,@"icon":avatarUrl};
    NSString *jsonStr = [Tools dataTojsonString:dic];
    [self.chatWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"sendMsg(%@)",jsonStr]];
}

- (void)receiveMsg:(NSString *)content {
    
    if ([content containsString:@"</a>"]) {
        [self.inputBar.textView resignFirstResponder];
    }
    
    NSString *avatarUrl = @"";
    avatarUrl = @"http://upload.jkbat.com/Files/20180116/yau1i23f.emz.png";
    if (!content) {
        content = @"";
    }
    NSDictionary *dic = @{@"content":content,@"icon":avatarUrl};
    NSString *jsonStr = [Tools dataTojsonString:dic];
    [self.chatWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"receiveMsg(%@)",jsonStr]];
}

- (void)receiveMusic:(NSString *)index {
    
    NSDictionary *dic = @{@"content":@"243",@"msgType":@5,@"value":index};
    NSString *jsonStr = [Tools dataTojsonString:dic];
    [self.chatWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"receiveMsg(%@)",jsonStr]];
}

- (void)scrollToBottom {
    
    NSDictionary *dic = @{};
    NSString *jsonStr = [Tools dataTojsonString:dic];
    [self.chatWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"scrollToBottom(%@)",jsonStr]];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if ([request.URL.absoluteString containsString:[[NSURL alloc] initFileURLWithPath:self.webFilePath].absoluteString]
        || [request.URL.absoluteString containsString:[NSURL URLWithString:@"about:blank"].absoluteString]) {
        
        return YES;
    }
    
    NSURL *URL = request.URL;
    DDLogDebug(@"%@",URL);
    NSString *tmpUrl = URL.absoluteString;
    NSDictionary *urlPara = [Tools getParametersWithUrlString:tmpUrl];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:urlPara];
    [dic setObject:tmpUrl forKey:@"url"];
    
    [self linkClickWithPara:dic];
    
    return NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    self.context = [self.chatWebView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    BATJSObject *jsObject = [[BATJSObject alloc] init];
    self.context[@"HealthBAT"] = jsObject;
    
    WEAK_SELF(self);
    [jsObject setDrKangPlayMusicBlock:^(NSString *index) {
        STRONG_SELF(self);
        //播放音乐
        if ([self.audioPlayer isPlaying]) {
            [self.audioPlayer stop];
            self.audioPlayer = nil;
        }
        else {
            [self audioPlayerWithIndex:[index intValue]];
        }
    }];
    
    NSMutableArray *msgHistoryArray = [self getTodayMsgHistory];
    if (msgHistoryArray.count > 0) {
        //加载历史记录
        for (BATDrKangMsgHistoryModel * msg in msgHistoryArray) {
            
            if ([msg.sender isEqualToString:@"Me"]) {
                
                [self sendMsg:msg.content];
            }
            else {
                [self receiveMsg:msg.content];
            }
        }
    }

    if ([[NSUserDefaults standardUserDefaults] boolForKey:DEVICE_FIRST_RECORD] != YES) {
        
        [self sendTextRequestWithContent:@"first" isSound:NO];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.bottomKeyArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BATDrKangBottomCollectionViewCell *bottomCell = [collectionView dequeueReusableCellWithReuseIdentifier:BOTTOM_CELL forIndexPath:indexPath];
    bottomCell.keyWordLabel.text = self.bottomKeyArray[indexPath.row];
    
//    [bottomCell.keyWordLabel setTitle:self.bottomKeyArray[indexPath.row] forState:UIControlStateNormal];
//    [bottomCell.keyLabel setTitle:self.bottomKeyArray[indexPath.row] forState:UIControlStateNormal];
    
    return bottomCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size = CGSizeZero;
    CGSize textSize = [self.bottomKeyArray[indexPath.row] boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    size = CGSizeMake(textSize.width+25, 35);
    
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //欢迎界面，进入康博士正常聊天界面
    if ([[NSUserDefaults standardUserDefaults] boolForKey:DEVICE_FIRST_RECORD] != YES) {
        //存储标识
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:DEVICE_FIRST_RECORD];
        [[NSUserDefaults standardUserDefaults] synchronize];

        //重新加载，清除欢迎语句
        [self.chatWebView loadRequest:[[NSURLRequest alloc] initWithURL:[[NSURL alloc] initFileURLWithPath:self.webFilePath]]];

        //进入聊天界面
        [self showChat];
        [self sendTextRequestWithContent:@"start" isSound:NO];
        return;
    }
    
    NSString *bottomKey = self.bottomKeyArray[indexPath.row];
    [self sendMsg:bottomKey];
    [self insertMsgWithContent:bottomKey AndSender:@"Me"];
    [self sendTextRequestWithContent:bottomKey isSound:NO];

    //正常交互
    
    
    /*
    switch (indexPath.section) {
        case 0:
        {
            //职能问诊
            NSString *bottomKey = self.bottomKeyArray[indexPath.section];
            [self sendMsg:bottomKey];
            [self insertMsgWithContent:bottomKey AndSender:@"Me"];
            [self sendTextRequestWithContent:bottomKey isSound:NO];
        }
            break;
        case 1:
        {
            //常见疾病
            [self.view endEditing:YES];
            
            self.diseaseView = nil;
        
            self.diseaseView.titleArray = @[@"呼吸系统疾病",@"循环系统疾病",@"消化系统疾病"];
            self.diseaseView.dataDic =  @{
                                          @"呼吸系统疾病":@[@"慢性支气管炎",@"肺炎",@"急性上呼吸道感染"],
                                          @"循环系统疾病":@[@"高血压",@"冠心病",@"急性脑血管病",@"心力衰竭",@"心律失常",@"风湿性心脏病"],
                                          @"消化系统疾病":@[@"胃炎",@"胃溃疡",@"胆囊炎",@"肠炎",@"胆石症"],
                                          };
            
            [self.navigationController.view addSubview:self.diseaseView];
            [self.diseaseView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(@0);
            }];
        }
            break;
        case 2:
        {
            //历史评估
            BATDrKangHistoryViewController *historyVC = [[BATDrKangHistoryViewController alloc] init];
            [self.navigationController pushViewController:historyVC animated:YES];
        }
            break;
            
        case 3:
        {
            //健康3秒钟
            [self pushHealthThreeSecondsVC];
        }
            break;
    }
     */
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    
    //音频播放完毕
    
}

#pragma mark - YYTextViewDelegate
- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        
        //特殊问题
        if (textView == self.askInputBar.textView) {
            
            NSString *content = [self.askInputBar.textView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            if (content.length == 0) {
                return NO;
            }
            
            if ([self.askInputBar.tmpQuestion containsString:@"name"]) {
                
            }
            else if ([self.askInputBar.tmpQuestion containsString:@"sex"]) {
                
            }
            else if ([self.askInputBar.tmpQuestion containsString:@"age"]) {
                
            }
            else if ([self.askInputBar.tmpQuestion containsString:@"height"]) {
                
                if ([self.askInputBar.textView.text floatValue] < 20 || [self.askInputBar.textView.text floatValue] > 300) {
                    
                    [self showErrorWithText:@"请输入正确的身高"];
                    return NO;
                }
            }
            else if ([self.askInputBar.tmpQuestion containsString:@"weight"]) {
                
                if ([self.askInputBar.textView.text floatValue] < 2 || [self.askInputBar.textView.text floatValue] > 500) {
                    
                    [self showErrorWithText:@"请输入正确的体重"];
                    return NO;
                }
            }
            
            
            [self sendTextRequestWithContent:self.askInputBar.textView.text isSound:NO];
            self.askInputBar.textView.text = @"";

            return NO;
        }
        
        //正常输入框
        if ([self.inputBar.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
            return NO;
        }
        [self sendMsg:self.inputBar.textView.text];
        [self insertMsgWithContent:self.inputBar.textView.text AndSender:@"Me"];

        [self sendTextRequestWithContent:self.inputBar.textView.text isSound:NO];
        
        self.inputBar.textView.text = @"";
        
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(YYTextView *)textView {
    
    CGSize sizeThatShouldFitTheContent = [textView sizeThatFits:textView.frame.size];
    CGFloat constant = MAX(50, MIN(sizeThatShouldFitTheContent.height + 10 + 10,100));
    //每次textView的文本改变后 修改chatBar的高度
    [self.inputBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(constant);
    }];
    textView.scrollEnabled = self.inputBar.frame.size.height >= 100;
}

- (BOOL)textViewShouldBeginEditing:(YYTextView *)textView {
    
    //解决textView大小不定时 contentOffset不正确的bug
    //固定了textView后可以设置滚动YES
    CGSize sizeThatShouldFitTheContent = [textView sizeThatFits:textView.frame.size];
    //每次textView的文本改变后 修改chatBar的高度
    CGFloat chatBarHeight = MAX(50, MIN(sizeThatShouldFitTheContent.height + 10 + 10,100));
    
    textView.scrollEnabled = chatBarHeight >= 100;
    
    return YES;
}

#pragma mark - IFlySpeechRecognizerDelegate
- (void) onError:(IFlySpeechError *) errorCode {
    
    if (errorCode.errorCode == 20006) {
        
        //录音失败
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            
            if (granted) {
                
                // 用户同意获取麦克风
                
            }
            else {
                //用户未允许麦克风，提示用户
                UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"麦克风权限已关闭" message:@"请到设置->隐私->麦克风开启权限" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[UIApplication sharedApplication] openURL:[NSURL  URLWithString:UIApplicationOpenSettingsURLString]];
                    
                    return ;
                }];
                UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:okAction];
                [alert addAction:cancelAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }];
    }
    
    [self bk_performBlock:^(id obj) {
        self.voiceAlertView.hidden = YES;
    } afterDelay:1];
}

- (void) onResults:(NSArray *) results isLast:(BOOL)isLast;
{
    NSMutableString *resultString = [[NSMutableString alloc] init];
    NSDictionary *dic = results[0];
    for (NSString *key in dic) {
        [resultString appendFormat:@"%@",key];
    }
    
    NSString * resultFromJson =  [ISRDataHelper stringFromJson:resultString];
    _result = [NSString stringWithFormat:@"%@%@", _result,resultFromJson];
    
    if (isLast){
        self.voiceAlertView.hidden = YES;
        
        if (self.result.length == 0) {
            self.result = @"";
            return;
        }
        
        [self sendMsg:self.result];
        [self insertMsgWithContent:self.result AndSender:@"Me"];

        [self sendTextRequestWithContent:self.result isSound:YES];
        
        self.result = @"";
    }
}

#pragma mark - IFlySpeechSynthesizerDelegate
//合成结束，此代理必须要实现
- (void) onCompleted:(IFlySpeechError *) error{
    
}
//合成开始
- (void) onSpeakBegin{
    
}
//合成缓冲进度
- (void) onBufferProgress:(int) progress message:(NSString *)msg{
    
}
//合成播放进度
- (void) onSpeakProgress:(int) progress{
    
}


#pragma mark - STPickerDateDelegate
- (void)pickerDate:(STPickerDate *)pickerDate year:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    
    NSString *yearStr = [NSString stringWithFormat:@"%ld",(long)year];
    NSString *monthStr;
    if (month < 10) {
        monthStr = [NSString stringWithFormat:@"0%ld",(long)month];
    }
    else {
        monthStr = [NSString stringWithFormat:@"%ld",(long)month];
        
    }
    NSString *dayStr;
    
    if (day < 10) {
        dayStr = [NSString stringWithFormat:@"0%ld",(long)day];
    }
    else {
        dayStr = [NSString stringWithFormat:@"%ld",(long)day];
    }
    
    NSString *dateString = [NSString stringWithFormat:@"%@%@%@",yearStr,monthStr,dayStr];
    
    DDLogDebug(@"%@",dateString);
    
    //发送年龄
    [self sendMsg:dateString];
    [self insertMsgWithContent:dateString AndSender:@"Me"];
    [self sendTextRequestWithContent:dateString isSound:NO];
}

#pragma mark - STPickerSingleDelegate
- (void)pickerSingle:(STPickerSingle *)pickerSingle selectedTitle:(NSString *)selectedTitle {

    DDLogDebug(@"%@",selectedTitle);
    
    //发送性别
    [self sendMsg:selectedTitle];
    [self insertMsgWithContent:selectedTitle AndSender:@"Me"];
    [self sendTextRequestWithContent:selectedTitle isSound:NO];
}


#pragma mark - action
- (void)keyboardWillShow:(NSNotification *)noti {
    
    CGRect keyboardFrame = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    double duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    NSInteger animation = [noti.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    WEAK_SELF(self);
    [UIView animateWithDuration:duration delay:duration options:animation animations:^{
        STRONG_SELF(self);
        [self.bottomCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            if(@available(iOS 11.0, *)) {
                if (iPhoneX) {
                    make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset((-keyboardFrame.size.height-49+34));
                }
                else {
                    make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset((-keyboardFrame.size.height-49));
                }
            }
            else {
                make.bottom.equalTo(@(-keyboardFrame.size.height-49));
            }
        }];
        
        [self.inputBar mas_updateConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            if(@available(iOS 11.0, *)) {
                if (iPhoneX) {
                    make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset((-keyboardFrame.size.height+34));
                }
                else {
                    make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset((-keyboardFrame.size.height));
                }
            }
            else {
                make.bottom.equalTo(@(-keyboardFrame.size.height));
            }
        }];
        
        [self.chatWebView mas_updateConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.bottom.equalTo(self.bottomCollectionView.mas_top).offset(2);
        }];
        
        [self.askInputBar mas_updateConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            if(@available(iOS 11.0, *)) {
                if (iPhoneX) {
                    make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset((-keyboardFrame.size.height+34));
                }
                else {
                    make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset((-keyboardFrame.size.height));
                }
            }
            else {
                make.bottom.equalTo(@(-keyboardFrame.size.height));
            }
        }];
        
        [UIView animateWithDuration:0.35f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.view setNeedsLayout];
            [self.view layoutIfNeeded];
        } completion:nil];
        
    } completion:nil];
    
    [self bk_performBlock:^(id obj) {
        
        STRONG_SELF(self);
        [self scrollToBottom];
    } afterDelay:duration];
}

- (void)keyboardWillHide:(NSNotification *)noti {
    
    double duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    NSInteger animation = [noti.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    WEAK_SELF(self);
    [UIView animateWithDuration:duration delay:0.0f options:animation animations:^{
        STRONG_SELF(self);

        [self.bottomCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            if(@available(iOS 11.0, *)) {
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-49);
            }
            else {
                make.bottom.equalTo(@-49);
            }
        }];
        [self.inputBar mas_updateConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            if(@available(iOS 11.0, *)) {
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(0);
            }
            else {
                make.bottom.equalTo(@0);
            }
        }];
        [self.chatWebView mas_updateConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.bottom.equalTo(self.bottomCollectionView.mas_top).offset(2);
        }];
        [self.view layoutIfNeeded];
    } completion:nil];
    
    [self bk_performBlock:^(id obj) {
        
        STRONG_SELF(self);
        [self scrollToBottom];
    } afterDelay:duration];
}

//定位失败
- (void)handleLocationFailure {
    
}

//定位成功
- (void)handleLocationInfo:(NSNotification *)locationNotification {
    
    //定位成功过了，不需要去隐私重新设置
    _isFirstLocationFail = NO;
    
    //阻止多次回调
    if (self.isGetLocation) {
        
        return;
    }
    self.isGetLocation = YES;
    
    BMKReverseGeoCodeResult * result = locationNotification.userInfo[@"location"];
    DDLogWarn(@"%@",result);
    
    self.currentLocation = result.location;
}

- (void)evaluationSendMessage:(NSNotification *)evaluationNoti {
    
    NSString *result = evaluationNoti.userInfo[@"result"];
    if ([result isEqualToString:@"1"]) {
        //满意
        [self receiveMsg:@"感谢您的使用，您的满意是我们最大的动力。"];
        [self insertMsgWithContent:@"感谢您的使用，您的满意是我们最大的动力。" AndSender:@"DrKang"];
    }
    else {
        //不满意
        [self receiveMsg:@"感谢您的反馈，我们将持续优化，为您提供更好的服务。"];
        [self insertMsgWithContent:@"感谢您的反馈，我们将持续优化，为您提供更好的服务。" AndSender:@"DrKang"];

    }
}

#pragma mark - Database
//创建表
- (void)createDatabaseTable {
    
    if ([self.historyDB open]) {
        
        NSString *tableName = [Tools getDateStringWithDate:[NSDate date] Format:@"yyyyMMdd"];
        tableName = [NSString stringWithFormat:@"history_%@",tableName];
        if ([self.historyDB tableExists:tableName] == NO) {
            
            NSString *sqlStr = [NSString stringWithFormat:@"create table %@ (id integer primary key, sender text, content text)",tableName];
            [self.historyDB executeUpdate:sqlStr];
        }
    }
    [self.historyDB close];
}

//增加
-(void)insertMsgWithContent:(NSString *)content AndSender:(NSString *)sender {
    
    if ([self.historyDB open]) {
        
        NSString *tableName = [Tools getDateStringWithDate:[NSDate date] Format:@"yyyyMMdd"];
        tableName = [NSString stringWithFormat:@"history_%@",tableName];
        NSString *sqlStr = [NSString stringWithFormat:@"insert into %@ (content, sender) values (?, ?)",tableName];
        
        [self.historyDB executeUpdate:sqlStr,content,sender];
    }
    [self.historyDB close];
}

//查询历史记录
-(NSMutableArray*)getTodayMsgHistory {
    
    NSMutableArray * array = [NSMutableArray array];
    
    if ([self.historyDB open]) {
        //执行查询语句，得到结果集
        NSString *tableName = [Tools getDateStringWithDate:[NSDate date] Format:@"yyyyMMdd"];
        tableName = [NSString stringWithFormat:@"history_%@",tableName];
        NSString *sqlStr = [NSString stringWithFormat:@"select * from %@",tableName];
        
        FMResultSet * set = [self.historyDB executeQuery:sqlStr];
        while ([set next]) {
            BATDrKangMsgHistoryModel * msg = [[BATDrKangMsgHistoryModel alloc] init];
            msg.sender = [set stringForColumn:@"sender"];
            msg.content = [set stringForColumn:@"content"];
            [array addObject:msg];
        }
        [set close];
    }
    [self.historyDB close];
    return array ;
}

#pragma mark - private
//点击了超链接，判断参数
- (void)linkClickWithPara:(NSDictionary *)dic {
    
    if ([dic.allKeys containsObject:@"flag"]) {
        
        NSString *flag = dic[@"flag"];
        flag = [flag stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        //直接跳转
        if ([flag isEqualToString:@"咨询医生"]) {
            
            [self goConsultation];
            return;
        }else if ([flag isEqualToString:@"健康3秒钟"]){
            
            [self pushHealthThreeSecondsVC];
            
        }
        else if ([flag isEqualToString:@"预约挂号"]) {
            
            if ([dic.allKeys containsObject:@"id"]) {
                //跳转到指定的医院
                NSString *hospitalName = dic[@"hospitalName"];
                hospitalName = [hospitalName stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [self goHospitalRegisterWithHospitalID:dic[@"id"] hospitalName:hospitalName];
            }
            else {
                //预约挂号
                [self goHospitalRegister];
            }
            return;
        }
        else if ([flag isEqualToString:@"周边医院"]) {
            
            BATKangDoctorHospitalListViewController *hospitalListVC = [[BATKangDoctorHospitalListViewController alloc] init];
            hospitalListVC.lat = self.currentLocation.latitude;
            hospitalListVC.lon = self.currentLocation.longitude;
            [self.navigationController pushViewController:hospitalListVC animated:YES];
            return;
        }
        else if ([flag isEqualToString:@"快速查病"]) {
            
            
            return;
        }
        else if ([flag isEqualToString:@"telephone"]) {
            
            NSString *content = dic[flag];
            content = [content stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            content = [content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",content]]];
            return;
        }
        else if ([flag isEqualToString:@"address"]) {
            
            NSString *oreillyAddress = dic[flag];
            oreillyAddress = [oreillyAddress stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            CLGeocoder *myGeocoder = [[CLGeocoder alloc] init];
            [myGeocoder geocodeAddressString:oreillyAddress completionHandler:^(NSArray *placemarks, NSError *error) {
                if ([placemarks count] > 0 && error == nil) {
                    NSLog(@"Found %lu placemark(s).", (unsigned long)[placemarks count]);
                    CLPlacemark *firstPlacemark = [placemarks objectAtIndex:0];
                    NSLog(@"Longitude = %f", firstPlacemark.location.coordinate.longitude);
                    NSLog(@"Latitude = %f", firstPlacemark.location.coordinate.latitude);
                    self.hospitalLongitude = firstPlacemark.location.coordinate.longitude;
                    self.hospitalLatitude = firstPlacemark.location.coordinate.latitude;
                    
                    [self openUrlWithDestination:dic[@"content"]];
                }
                else if ([placemarks count] == 0 && error == nil) {
                    NSLog(@"Found no placemarks.");
                    
                } else if (error != nil) {
                    NSLog(@"An error occurred = %@", error);
                }
            }];
            
            return;
        }
        
        //发信息，并等待回复
        if (![flag isEqualToString:@"症状列表"] && ![flag isEqualToString:@"展开更多"]) {
            [self sendMsg:flag];
            [self insertMsgWithContent:flag AndSender:@"Me"];

        }
    }
    
    if ([dic.allKeys containsObject:@"url"]) {
        
        NSString *url = dic[@"url"];
        if ([dic.allKeys containsObject:@"resultLength"] && [dic[@"resultLength"] intValue] == -1) {
            //服务器主动加入参数 resultLength=-1 ,展开详情
            
            [self detailRequestWithURL:url];
        }
        else {
            
            url = [NSString stringWithFormat:@"%@&resultLength=%@",url,@(self.maxWordNumber)];
            [self eventRequestWithURL:url];
        }
    }
}

//欢迎语
- (void)welcomeMessage {
    
    /*
     您好，我是康博士。
     有什么我可以帮助的吗？关于快速查病、预约挂号、健康咨询
     都可以找我了解。
     除此之外，我还能为您提供健康管理服务:
     1.依据您提供的数据为您建立健康档案；
     2.对您的健康数据进行个性化的智能风险评估分析；
     3.针对风险评估结果为您提供在线咨询服务。
     */
    NSString *html =
    @"<html>"
    "<head></head>"
    "<body>"
    "<p style=\"margin: 0;color: #333;font-size: 15px;line-height: 22px;\">你好，我是康博士。</p>"
    "<div style=\"margin: 0;color: #333;font-size: 15px;line-height: 22px;\">"
    "有什么我可以帮助的吗？ 关于快速查病、"
    "<a href=\"http://search.jkbat.com/elasticsearch/mrKang?flag=预约挂号\" style=\"text-decoration: none;color: #0182eb;\">预约挂号</a>"
    "<font color=\"#0182eb\">、</font>"
    "<a href=\"http://search.jkbat.com/elasticsearch/mrKang?flag=咨询医生\" style=\"text-decoration: none;color: #0182eb;\">健康咨询</a>都可以找我了解。"
    "</div>"
    "<p style=\"margin: 0;color: #333;font-size: 15px;line-height: 22px;\">除此之外，我还能为您提供健康管理服务:</p>"
    "<p style=\"margin: 0;color: #333;font-size: 15px;line-height: 22px;\">1.依据您提供的数据为您建立健康档案；</p>"
    "<p style=\"margin: 0;color: #333;font-size: 15px;line-height: 22px;\">2.对您的健康数据进行个性化的智能风险评估分析；</p>"
    "<p style=\"margin: 0;color: #333;font-size: 15px;line-height: 22px;\">3.针对风险评估结果为您提供在线咨询服务。</p>"
    "</body>"
    "</html>";
    
    [self receiveMsg:html];
    [self insertMsgWithContent:html AndSender:@"DrKang"];

}

- (float)caculateAudioDurationSecondsWith:(int)musicIndex {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%d",musicIndex] ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:path];
    AVURLAsset* audioAsset =[AVURLAsset URLAssetWithURL:url options:nil];
    CMTime audioDuration = audioAsset.duration;
    float audioDurationSeconds =CMTimeGetSeconds(audioDuration);
    return audioDurationSeconds;
}

- (void)audioPlayerWithIndex:(int)musicIndex {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%d",musicIndex] ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:path];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.audioPlayer.delegate = self;
    [self.audioPlayer play];
}

//地图
-(void)openUrlWithDestination:(NSString *)destination {
    
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"" message:@"请选择" preferredStyle:UIAlertControllerStyleActionSheet];
    
    NSString *baiduMapUrl = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=目的地&mode=driving&coord_type=gcj02",self.hospitalLatitude,self.hospitalLongitude]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if ([self isCanOpenUrlWithString:baiduMapUrl]) {
        
        UIAlertAction *baidumap = [UIAlertAction actionWithTitle:@"百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self openURLWithString:baiduMapUrl];
        }];
        
        [alter addAction:baidumap];
    }
    
    NSString *gaodeMapUrl = [[NSString stringWithFormat:@"iosamap://path?sourceApplication=applicationName&sid=BGVIS1&slat=%f&slon=%f&sname=%@&did=BGVIS2&dlat=%f&dlon=%f&dname=%@&dev=0&m=0&t=0",self.currentLocation.latitude,self.currentLocation.longitude,@"我的位置",self.hospitalLatitude,self.hospitalLongitude,destination]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if ([self isCanOpenUrlWithString:gaodeMapUrl]) {
        
        UIAlertAction *gaodedmap = [UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self openURLWithString:gaodeMapUrl];
        }];
        
        [alter addAction:gaodedmap];
    }
    
    NSString *aaMapUrl = [NSString stringWithFormat:@"qqmap://map/routeplan?type=drive&fromcoord=%f,%f&tocoord=%f,%f&policy=1",self.currentLocation.latitude,self.currentLocation.longitude,self.hospitalLatitude,self.hospitalLongitude];
    if ([self isCanOpenUrlWithString:aaMapUrl]) {
        
        UIAlertAction *qqmap = [UIAlertAction actionWithTitle:@"腾讯地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self openURLWithString:aaMapUrl];
        }];
        
        [alter addAction:qqmap];
    }
    
    UIAlertAction *acton = [UIAlertAction actionWithTitle:@"苹果地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(self.hospitalLatitude,self.hospitalLongitude);
        MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:loc addressDictionary:nil]];
        [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                       launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
                                       MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
    }];
    [alter addAction:acton];
    
    UIAlertAction *cancleacton = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alter addAction:cancleacton];
    
    
    [self presentViewController:alter animated:YES completion:nil];
}

-(void)openURLWithString:(NSString *)urlString {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

-(bool)isCanOpenUrlWithString:(NSString *)urlString {
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlString]]) {
        
        return YES;
    }
    else {
        
        return NO;
    }
}


//到指定的医院预约挂号
- (void)goHospitalRegisterWithHospitalID:(NSString *)hospitalID hospitalName:(NSString *)hospitalName {
    
    if (!CANREGISTER) {
        [self showText:@"您好,预约挂号功能升级中,请稍后再试!"];
        return;
    }
    
    BATRegisterDepartmentListViewController * departmentListVC = [BATRegisterDepartmentListViewController new];
    departmentListVC.hospitalId = [hospitalID integerValue];
    departmentListVC.hospitalName = hospitalName;
    [self.navigationController pushViewController:departmentListVC animated:YES];
    
}
//预约挂号
- (void)goHospitalRegister {
    
    if (!CANREGISTER) {
        [self showText:@"您好,预约挂号功能升级中,请稍后再试!"];
        return;
    }
    
    BATRegisterHospitalListViewController * hospitalVC = [BATRegisterHospitalListViewController new];
    hospitalVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:hospitalVC animated:YES];
    
}

//在线咨询 健康咨询
- (void)goConsultation {
    
    BATFindDoctorListViewController *findDoctorListVC = [[BATFindDoctorListViewController alloc] init];
    [self.navigationController pushViewController:findDoctorListVC animated:YES];
}

//跳转到智能问诊历史记录
- (void)pushDrKangHistoryVC {
    
    BATDrKangHistoryViewController *historyVC = [[BATDrKangHistoryViewController alloc] init];
    [self.navigationController pushViewController:historyVC animated:YES];
}

//跳转到健康3秒钟统计界面
- (void)pushHealthThreeSecondsVC{
    
    if ( !LOGIN_STATION) {
        PRESENT_LOGIN_VC;
        return;
    }
    
    BATPerson *loginUserModel = PERSON_INFO;
    
    BOOL isEdit = (loginUserModel.Data.Weight && loginUserModel.Data.Height && loginUserModel.Data.Birthday.length);
    
    if ( !LOGIN_STATION) {
        PRESENT_LOGIN_VC;
        return;
    }
    
    
    if (!isEdit && ![[NSUserDefaults standardUserDefaults]boolForKey:@"isFirstEnterHealthThreeSecond"]) {
        
        //完善资料
        BATHealthyInfoViewController *editInfo = [[BATHealthyInfoViewController alloc]init];
        editInfo.isShowNavButton = YES;
        editInfo.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:editInfo animated:YES];
        
        
    }else{
        
        //健康3秒钟
        BATHealthThreeSecondsController *healthThreeSecondsVC = [[BATHealthThreeSecondsController alloc]init];
        healthThreeSecondsVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:healthThreeSecondsVC animated:YES];
    }
}

 //跳转到健康3秒钟统计界面
- (void)pushHealthThreeSecondsStatisVC{
    
    if ( !LOGIN_STATION) {
        PRESENT_LOGIN_VC;
        return;
    }
    
    BATPerson *loginUserModel = PERSON_INFO;
    
    BOOL isEdit = (loginUserModel.Data.Weight && loginUserModel.Data.Height && loginUserModel.Data.Birthday.length);
    
    if ( !LOGIN_STATION) {
        PRESENT_LOGIN_VC;
        return;
    }
    
    
    if (!isEdit && ![[NSUserDefaults standardUserDefaults]boolForKey:@"isFirstEnterHealthThreeSecond"]) {
        
        //完善资料
        BATHealthyInfoViewController *editInfo = [[BATHealthyInfoViewController alloc]init];
        editInfo.isShowNavButton = YES;
        editInfo.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:editInfo animated:YES];
        
        
    }else{
        
        //健康3秒钟统计
        BATHealthThreeSecondsStatisController *healthThreeSecondsStatisVC = [[BATHealthThreeSecondsStatisController alloc]init];
        healthThreeSecondsStatisVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:healthThreeSecondsStatisVC animated:YES];
    }
}

//健康360的评估页面
- (void)pushHealth360EvaluationVC {
    
    if (!LOGIN_STATION) {
        PRESENT_LOGIN_VC;
        return;
    }
    BATHealth360EvaluationViewController *evaluationVC = [[BATHealth360EvaluationViewController alloc] init];
    evaluationVC.urlSuffix = @"&redirect=/H5/src/index.html?src=2#/healthEvaluateReport/////2";
    [self.navigationController pushViewController:evaluationVC animated:YES];
}

//健康360的健康档案页面
- (void)pushHealth360DocumentVC {
    
    if (!LOGIN_STATION) {
        PRESENT_LOGIN_VC;
        return;
    }
    BATHealth360EvaluationViewController *documentVC = [[BATHealth360EvaluationViewController alloc] init];
    documentVC.urlSuffix = @"&redirect=/H5/src/index.html?src=2#/healthRecordIndex/2";
    [self.navigationController pushViewController:documentVC animated:YES];
}

- (void)sexPickerView{
    
    NSMutableArray *dataM = [NSMutableArray arrayWithArray:@[@"男性",@"女性"]];
    STPickerSingle *pickerSingle = [[STPickerSingle alloc]init];
    
    pickerSingle.backgroundColor = [UIColor clearColor];
    pickerSingle.buttonLeft.hidden = YES;
    
    pickerSingle.widthPickerComponent = 40;
    //设置默认选中的按钮
    pickerSingle.buttonRight.selected = YES;
    /** 2.边线,选择器和上方tool之间的边线 */
    pickerSingle.lineView = [[UIView alloc]init];
    //设置按钮边框颜色
    pickerSingle.borderButtonColor = [UIColor whiteColor];
    //设置数据源
    [pickerSingle setArrayData:dataM];
    //设置弹出视图的标题
    [pickerSingle setTitle:@"请选择"];
    //设置视图的位置为屏幕下方
    [pickerSingle setContentMode:STPickerContentModeBottom];
    [pickerSingle setDelegate:self];
    [pickerSingle show];
}

- (void)birthdayPickerView {
    
    STPickerDate *datePicker = [[STPickerDate alloc] init];
    [datePicker selectCustomDate:[NSDate date]];

    datePicker.backgroundColor = [UIColor clearColor];
    datePicker.buttonLeft.hidden = YES;
    
    //设置默认选中的按钮
    datePicker.buttonRight.selected = YES;
    /** 2.边线,选择器和上方tool之间的边线 */
    datePicker.lineView = [[UIView alloc]init];
    //设置按钮边框颜色
    datePicker.borderButtonColor = [UIColor whiteColor];
    //设置弹出视图的标题
    [datePicker setTitle:@"请选择出生日期"];
    //设置视图的位置为屏幕下方
    [datePicker setContentMode:STPickerContentModeBottom];
    [datePicker setDelegate:self];
    
    
    [datePicker show];
    
}

//执行order
- (void)executiveOrder:(NSString *)order {
    
    self.isExecutiveOrder = YES;
    
    if ([order isEqualToString:@"login"]) {
        //跳转登陆
        PRESENT_LOGIN_VC;
    }
    else if ([order containsString:@"healthCounseling"]) {
        //跳转健康咨询
        [self goConsultation];
    }
    else if ([order containsString:@"healthReport"]) {
        //跳转健康报告
        [self pushHealth360EvaluationVC];
    }
    else if ([order containsString:@"health360"]) {
        //跳转健康360（健康档案）
        [self pushHealth360DocumentVC];
    }
    else if ([order containsString:@"health3s"]) {
        //跳转健康3s
        [self pushHealthThreeSecondsVC];
    }
    else if ([order containsString:@"show"]) {
        //小管家跳转
        
    }
}

- (void)showChat {
    
    self.station = BATDrKangViewStationChat;
    
    [self.askInputBar.textView resignFirstResponder];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    self.titleImageView.hidden = NO;
    self.chatWebView.hidden = NO;
    self.bottomCollectionView.hidden = NO;
    self.inputBar.hidden = NO;
    
    self.navBackButton.hidden = YES;
    self.topImageView.hidden = YES;
    self.questionButton.hidden = YES;
    self.askInputBar.hidden = YES;

    [self.chatWebView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
    }];
    
    [UIView animateWithDuration:0.0f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    } completion:nil];
    
    
    self.bottomKeyArray = [NSMutableArray array];
    [self.bottomCollectionView reloadData];
    [self reloadEmptyCollectionView];
}

- (void)showWelcomeView {
    
    self.station = BATDrKangViewStationWelcome;

    [self.navigationController setNavigationBarHidden:YES animated:YES];

    self.titleImageView.hidden = YES;
    self.askInputBar.hidden = YES;
    self.questionButton.hidden = YES;
    
    self.navBackButton.hidden = NO;
    self.topImageView.hidden = NO;
    self.chatWebView.hidden = NO;
    self.bottomCollectionView.hidden = NO;
    self.inputBar.hidden = NO;
    
    [self.chatWebView mas_updateConstraints:^(MASConstraintMaker *make) {
        if (iPhoneX) {
            make.top.equalTo(@(44+284.0/750.0*SCREEN_WIDTH));
        }
        else {
            make.top.equalTo(@(20+284.0/750.0*SCREEN_WIDTH));
        }
    }];
    
    [UIView animateWithDuration:0.0f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    } completion:nil];
    
    self.bottomKeyArray = [NSMutableArray arrayWithObjects:@"那我体验一下", nil];
    [self.bottomCollectionView reloadData];
    
}

- (void)showAskViewWithQuestion:(NSString *)question {
    
    self.station = BATDrKangViewStationAskView;

    [self.inputBar.textView resignFirstResponder];

    [self.navigationController setNavigationBarHidden:YES animated:YES];

    //隐藏输入框、底部按钮、聊天界面
    self.titleImageView.hidden = YES;
    self.chatWebView.hidden = YES;
    self.bottomCollectionView.hidden = YES;
    self.inputBar.hidden = YES;
    
    //显示填写基础信息的界面
    self.navBackButton.hidden = NO;
    self.topImageView.hidden = NO;
    self.askInputBar.hidden = NO;
    self.questionButton.hidden = NO;
    
    if ([question containsString:@"name"]) {
        
        self.askInputBar.hidden = NO;
        self.askInputBar.tmpQuestion = @"name";
        self.askInputBar.textView.keyboardType = UIKeyboardTypeDefault;
        [self.askInputBar.textView becomeFirstResponder];
        
        NSArray *tmpArray = [question componentsSeparatedByString:@":"];
        NSString *tmpQuestion;
        if (tmpArray.count > 1) {
            tmpQuestion = tmpArray.lastObject;
        }
        else {
            tmpQuestion = @"请问怎么称呼？";
        }
        [self.questionButton setTitle:tmpQuestion forState:UIControlStateNormal];
        [self receiveMsg:tmpQuestion];
        [self insertMsgWithContent:tmpQuestion AndSender:@"DrKang"];
    }
    else if ([question containsString:@"sex"]) {
        
        [self.askInputBar.textView resignFirstResponder];
        self.askInputBar.hidden = YES;
        self.askInputBar.tmpQuestion = @"sex";

        NSArray *tmpArray = [question componentsSeparatedByString:@":"];
        NSString *tmpQuestion;
        if (tmpArray.count > 1) {
            tmpQuestion = tmpArray.lastObject;
        }
        else {
            tmpQuestion = @"请问您的性别？";
        }
        [self.questionButton setTitle:tmpQuestion forState:UIControlStateNormal];
        [self receiveMsg:tmpQuestion];
        [self insertMsgWithContent:tmpQuestion AndSender:@"DrKang"];
        
        [self sexPickerView];
    }
    else if ([question containsString:@"age"]) {
        
        [self.askInputBar.textView resignFirstResponder];
        self.askInputBar.hidden = YES;
        self.askInputBar.tmpQuestion = @"age";

        NSArray *tmpArray = [question componentsSeparatedByString:@":"];
        NSString *tmpQuestion;
        if (tmpArray.count > 1) {
            tmpQuestion = tmpArray.lastObject;
        }
        else {
            tmpQuestion = @"请问您的年龄？";
        }
        [self.questionButton setTitle:tmpQuestion forState:UIControlStateNormal];
        [self receiveMsg:tmpQuestion];
        [self insertMsgWithContent:tmpQuestion AndSender:@"DrKang"];
        
        [self birthdayPickerView];
    }
    else if ([question containsString:@"height"]) {
        
        self.askInputBar.hidden = NO;
        self.askInputBar.tmpQuestion = @"height";
        self.askInputBar.textView.keyboardType = UIKeyboardTypeDecimalPad;
        [self.askInputBar.textView becomeFirstResponder];
        
        NSArray *tmpArray = [question componentsSeparatedByString:@":"];
        NSString *tmpQuestion;
        if (tmpArray.count > 1) {
            tmpQuestion = tmpArray.lastObject;
        }
        else {
            tmpQuestion = @"请问您的身高？";
        }
        [self.questionButton setTitle:tmpQuestion forState:UIControlStateNormal];
        [self receiveMsg:tmpQuestion];
        [self insertMsgWithContent:tmpQuestion AndSender:@"DrKang"];
    }
    else if ([question containsString:@"weight"]) {
        
        self.askInputBar.hidden = NO;
        self.askInputBar.tmpQuestion = @"weight";
        self.askInputBar.textView.keyboardType = UIKeyboardTypeDecimalPad;
        [self.askInputBar.textView becomeFirstResponder];
        
        NSArray *tmpArray = [question componentsSeparatedByString:@":"];
        NSString *tmpQuestion;
        if (tmpArray.count > 1) {
            tmpQuestion = tmpArray.lastObject;
        }
        else {
            tmpQuestion = @"请问您的体重？";
        }
        [self.questionButton setTitle:tmpQuestion forState:UIControlStateNormal];
        [self receiveMsg:tmpQuestion];
        [self insertMsgWithContent:tmpQuestion AndSender:@"DrKang"];
    }
}

//bottomCollectionView 数组为空时，reload时flowLayout不会执行layoutAttributesForElementsInRect，手动更改collectionView的高度
- (void)reloadEmptyCollectionView {
    
    [self.bottomCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
    }];
    [self.chatWebView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottomCollectionView.mas_top).offset(2);
    }];
    [UIView animateWithDuration:0.0f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    } completion:nil];
}

#pragma mark - net
- (void)sendTextRequestWithContent:(NSString *)content isSound:(BOOL)isSound {
    
    //发送新消息，停止语音回答
    [self.iFlySpeechSynthesizer stopSpeaking];
    
    BATLoginModel *login = LOGIN_INFO;
    
    [HTTPTool requestWithDrKangURLString:@"/drkang/test/chatWithDrKang"
                              parameters:@{
                                           @"keyword":content,
                                           @"userDeviceId":[Tools getPostUUID],
                                           @"userId":LOGIN_STATION ? @(login.Data.ID) : @"",
                                           @"lat":@(self.currentLocation.latitude),
                                           @"lon":@(self.currentLocation.longitude),
                                           @"requestSource":@"phone"
                                           }
                                 success:^(id responseObject) {
                                     
                                     if (!responseObject) {
                                         
                                         return ;
                                     }
                                     
                                     if ([responseObject isKindOfClass:[NSArray class]]) {
                                         
                                         NSArray *resultArray = [BATDrKangResultModel mj_objectArrayWithKeyValuesArray:responseObject];
                                         NSMutableArray *tmpAnswerArray = [NSMutableArray array];
                                         BOOL tmpError = NO;//临时记录是否存在error的返回选项
                                         BOOL tmpAskStation = NO;//临时记录当前页面状态是否为特殊问题界面
                                         
                                         for (BATDrKangResultModel *result in resultArray) {
                                             
                                             if ([result.msg isEqualToString:@"txt"]) {
                                                 
                                                 //对话内容
                                                 if (result.resultData.length > 0 && ![result.resultData isEqualToString:@"null"]) {
                                                     
                                                     [self receiveMsg:result.resultData];
                                                     [self insertMsgWithContent:result.resultData AndSender:@"DrKang"];
                                                     
                                                     if (isSound) {
                                                         
                                                         NSString *string = [[Tools filterHTML:result.resultData] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"@／：；（）¥「」＂、[]{}#%-*+=_\\|~＜＞$€^•'@#$%^&*()_+'\""]];
                                                         string = [string stringByReplacingOccurrencesOfString:@"～" withString:@" "];
                                                         string = [string stringByReplacingOccurrencesOfString:@"_" withString:@" "];
                                                         
                                                         DDLogDebug(@"%@",string);
                                                         
                                                         [self.iFlySpeechSynthesizer startSpeaking:string];
                                                     }
                                                 }
                                             }
                                             else if ([result.msg isEqualToString:@"answer"]) {
                                                 //底部选项
                                                 [tmpAnswerArray addObject:result.resultData];
                                             }
                                             else if ([result.msg isEqualToString:@"order"]) {
                                                 //跳转命令
                                                 [self executiveOrder:result.resultData];
                                             }
                                             else if ([result.msg isEqualToString:@"error"]) {
                                                 //错误
                                                 tmpError = YES;
                                             }
                                             else if ([result.msg isEqualToString:@"question"]) {
                                                 //个人信息咨询
                                                 tmpAskStation = YES;
                                                 [self showAskViewWithQuestion:result.resultData];
                                             }
                                             else {
                                                 //抛出
                                                 [self receiveMsg:result.resultData];
                                             }
                                         }
                                         
                                         if (tmpAskStation == YES) {
                                             
                                             
                                             return;
                                         }
                                         
                                         if (tmpAskStation == NO && self.station == BATDrKangViewStationAskView) {
                                             
                                             [self showChat];
                                         }
                                         
                                         //没有错误命令，刷新底部按钮
                                         if (tmpError == NO) {
                                             
                                             self.bottomKeyArray = tmpAnswerArray;
                                             [self.bottomCollectionView reloadData];
                                             //当answer为空时，需要调整界面
                                             if (tmpAnswerArray.count == 0) {
                                                 [self reloadEmptyCollectionView];
                                             }
                                         }
                                         
                                         if (self.bottomKeyArray.count > 0) {
                                             //需要点选，收起键盘
                                             [self.inputBar.textView resignFirstResponder];
                                         }
                                     }
                                     else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                                         
                                         BATDrKangModel *model = [BATDrKangModel mj_objectWithKeyValues:responseObject];
                                         
                                         [self receiveMsg:model.resultData];
                                         [self insertMsgWithContent:model.resultData AndSender:@"DrKang"];
                                     }

                                 } failure:^(NSError *error) {

                                     
                                 }];
}

- (void)eventRequestWithURL:(NSString *)url {
    
    //发送新消息，停止语音回答
    [self.iFlySpeechSynthesizer stopSpeaking];
    
    
    BATLoginModel *login = LOGIN_INFO;
    url = [NSString stringWithFormat:@"%@&userDeviceId=%@&userId=%ld",url,[Tools getPostUUID],(long)login.Data.ID];
    
    [XMCenter sendRequest:^(XMRequest *request) {
        request.url = url;
        request.httpMethod = kPOST;
        request.requestSerializerType = kXMRequestSerializerRAW;
    } onSuccess:^(id responseObject) {
        if (!responseObject) {
            
            return ;
        }
        
        if ([responseObject isKindOfClass:[NSArray class]]) {
            
            NSArray *resultArray = [BATDrKangResultModel mj_objectArrayWithKeyValuesArray:responseObject];
            NSMutableArray *tmpAnswerArray = [NSMutableArray array];
            BOOL tmpError = NO;//临时记录是否存在error的返回选项
            BOOL tmpAskStation = NO;//临时记录当前页面状态是否为特殊问题界面
            
            for (BATDrKangResultModel *result in resultArray) {
                
                if ([result.msg isEqualToString:@"txt"]) {
                    
                    //对话内容
                    if (result.resultData.length > 0 && ![result.resultData isEqualToString:@"null"]) {
                        
                        [self receiveMsg:result.resultData];
                        [self insertMsgWithContent:result.resultData AndSender:@"DrKang"];
                        
                    }
                }
                else if ([result.msg isEqualToString:@"answer"]) {
                    //底部选项
                    [tmpAnswerArray addObject:result.resultData];
                }
                else if ([result.msg isEqualToString:@"order"]) {
                    //跳转命令
                    [self executiveOrder:result.resultData];
                }
                else if ([result.msg isEqualToString:@"error"]) {
                    //错误
                    tmpError = YES;
                }
                else if ([result.msg isEqualToString:@"question"]) {
                    //个人信息咨询
                    tmpAskStation = YES;
                    [self showAskViewWithQuestion:result.resultData];
                }
                else {
                    //抛出
                    [self receiveMsg:result.resultData];
                }
            }
            
            if (tmpAskStation == YES) {
                
                
                return;
            }
            
            if (tmpAskStation == NO && self.station == BATDrKangViewStationAskView) {
                
                [self showChat];
            }
            
            //没有错误命令，刷新底部按钮
            if (tmpError == NO) {
                
                self.bottomKeyArray = tmpAnswerArray;
                [self.bottomCollectionView reloadData];
                //当answer为空时，需要调整界面
                if (tmpAnswerArray.count == 0) {
                    [self reloadEmptyCollectionView];
                }
            }
            
            if (self.bottomKeyArray.count > 0) {
                //需要点选，收起键盘
                [self.inputBar.textView resignFirstResponder];
            }

        }
        else if ([responseObject isKindOfClass:[NSDictionary class]]) {
            
            BATDrKangModel *model = [BATDrKangModel mj_objectWithKeyValues:responseObject];
            
            [self receiveMsg:model.resultData];
            [self insertMsgWithContent:model.resultData AndSender:@"DrKang"];
        }

    } onFailure:^(NSError *error) {
        
    } onFinished:^(id responseObject, NSError *error) {
        
    }];
}

- (void)detailRequestWithURL:(NSString *)url {
    
    //停止语音回答
    [self.iFlySpeechSynthesizer stopSpeaking];
    
    BATLoginModel *login = LOGIN_INFO;
    url = [NSString stringWithFormat:@"%@&userDeviceId=%@&userId=%ld",url,[Tools getPostUUID],(long)login.Data.ID];
    
    [XMCenter sendRequest:^(XMRequest *request) {
        request.url = url;
        request.httpMethod = kPOST;
        request.requestSerializerType = kXMRequestSerializerRAW;
    } onSuccess:^(id responseObject) {
        
        if (!responseObject) {
            
            return ;
        }
        
        BATDrKangModel *model = [BATDrKangModel mj_objectWithKeyValues:responseObject];
        
        //展开详情
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 6.5;// 字体的行间距
        
        NSDictionary *attributes = @{
                                     NSForegroundColorAttributeName :UIColorFromRGB(51, 51, 51, 1),
                                     NSFontAttributeName:[UIFont systemFontOfSize:16],
                                     NSParagraphStyleAttributeName:paragraphStyle
                                     };
        self.detailView.detailTextView.attributedText = [[NSAttributedString alloc] initWithString:model.resultData attributes:attributes];
        
        UIWindow *window = MAIN_WINDOW;
        [window addSubview:self.detailView];
        [self.detailView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@0);
        }];
        
        
    } onFailure:^(NSError *error) {
        
    } onFinished:^(id responseObject, NSError *error) {
        
    }];
}

- (void)introductionRequest {
    
    BATLoginModel *login = LOGIN_INFO;
 
    [HTTPTool requestWithDrKangURLString:@"/drkang/test/welcome"
                              parameters: @{
                                            @"keyword":@"",
                                            @"userDeviceId":[Tools getPostUUID],
                                            @"userId":LOGIN_STATION ? @(login.Data.ID) : @"",
                                            @"lat":@(self.currentLocation.latitude),
                                            @"lon":@(self.currentLocation.longitude),
                                            @"requestSource":@"phone"
                                            }
                                 success:^(id responseObject) {
        
                                     
                                     if (!responseObject) {
                                         
                                         return ;
                                     }
                                     
                                     NSArray *resultArray = [BATDrKangResultModel mj_objectArrayWithKeyValuesArray:responseObject];
                                     
                                     for (BATDrKangResultModel *result in resultArray) {
                                         
                                         if ([result.msg isEqualToString:@"txt"]) {
                                             
                                             //对话内容
                                             if (result.resultData.length > 0 && ![result.resultData isEqualToString:@"null"]) {
                                                 
                                                 [self receiveMsg:result.resultData];
                                             }
                                         }
                                         else {
                                             //抛出
                                             [self receiveMsg:result.resultData];
                                         }
                                     }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - layout
- (void)layoutPages {

    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"icon_lishijilu"] style:UIBarButtonItemStylePlain handler:^(id sender) {
       
        [YCXMenu setHasShadow:YES];
        [YCXMenu setBackgrounColorEffect:YCXMenuBackgrounColorEffectSolid];
        [YCXMenu setSeparatorColor:BASE_LINECOLOR];
        [YCXMenu setCornerRadius:5.f];

        [YCXMenu showMenuInView:self.view fromRect:CGRectMake(SCREEN_WIDTH - 55, 0, 60, 0) menuItems:self.items selected:^(NSInteger index, YCXMenuItem *item) {
            
            switch (item.tag) {
                case BATDrKangRightBarButtonHistory:
                {
                    //智能问诊历史评估
                    [self pushDrKangHistoryVC];
                }
                    break;
                    
                case BATDrKangRightBarButtonEvaluation:
                {
                    //健康360 健康评估
                    [self pushHealth360EvaluationVC];
                }
                    break;
                    
                case BATDrKangRightBarButtonHealthThreeSecond:
                {
                    //健康3秒钟统计
                    [self pushHealthThreeSecondsStatisVC];
                }
                    break;
                    
                default:
                    break;
            }
        }];
        //最后设置颜色，否则阴影有问题，第三方库的bug
        [YCXMenu setTintColor:[UIColor whiteColor]];
    }];
    
    WEAK_SELF(self);
    
    UIWindow *window = MAIN_WINDOW;
    [window addSubview:self.titleImageView];
    [self.titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(@0);
    }];
    
    [self.view addSubview:self.chatWebView];
    [self.chatWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(@0);
//        if(@available(iOS 11.0, *)) {
//            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-89);
//        }
//        else {
//            make.bottom.equalTo(@-89);
//        }
    }];
    
    [self.view addSubview:self.bottomCollectionView];
    [self.bottomCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        if(@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-49);
        }
        else {
            make.bottom.equalTo(@-49);
        }
        make.left.right.equalTo(@0);
        make.height.mas_equalTo(45);
    }];
    
    [self.view addSubview:self.inputBar];
    [self.inputBar mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.right.equalTo(@0);
        if(@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }
        else {
            make.bottom.equalTo(@0);
        }
        make.height.mas_equalTo(49);
    }];
    
    [self.view addSubview:self.voiceAlertView];
    [self.voiceAlertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(@0);
    }];
    
    
    [self.view addSubview:self.topImageView];
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        if (iPhoneX) {
            make.top.equalTo(@44);
        }
        else {
            make.top.equalTo(@20);
        }
        make.height.mas_equalTo(284.0/750.0*SCREEN_WIDTH);
    }];
    
    [self.view addSubview:self.questionButton];
    [self.questionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.centerY.equalTo(@-50);
    }];
    
    [self.view addSubview:self.askInputBar];
    [self.askInputBar mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.right.equalTo(@0);
        if(@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }
        else {
            make.bottom.equalTo(@0);
        }
        make.height.mas_equalTo(50);
    }];
    
    [self.view addSubview:self.navBackButton];
    [self.navBackButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        if (iPhoneX) {
            make.top.equalTo(@44);
        }
        else {
            make.top.equalTo(@20);
        }
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
}

#pragma mark - getter
- (NSArray *)items {
    
    if (!_items) {
        
        YCXMenuItem *historyItem = [YCXMenuItem menuItem:@"历史智能问诊"
                                                   image:[UIImage imageNamed:@"icon_zhinengwenzhen"]
                                                     tag:BATDrKangRightBarButtonHistory
                                                userInfo:@{@"type":@(BATDrKangRightBarButtonHistory)}];
        historyItem.foreColor = STRING_MID_COLOR;
        
        YCXMenuItem *evaluationItem = [YCXMenuItem menuItem:@"健康评估"
                                                   image:[UIImage imageNamed:@"icon_jiankangpingu"]
                                                     tag:BATDrKangRightBarButtonEvaluation
                                                userInfo:@{@"type":@(BATDrKangRightBarButtonEvaluation)}];
        evaluationItem.foreColor = STRING_MID_COLOR;

        YCXMenuItem *healthThreeSecondItem = [YCXMenuItem menuItem:@"健康3秒钟统计"
                                                   image:[UIImage imageNamed:@"icon_tongji"]
                                                     tag:BATDrKangRightBarButtonHealthThreeSecond
                                                userInfo:@{@"type":@(BATDrKangRightBarButtonHealthThreeSecond)}];
        healthThreeSecondItem.foreColor = STRING_MID_COLOR;

        _items = @[
                   historyItem,
                   evaluationItem,
                   healthThreeSecondItem,
                   ];
    }
    return _items;
}
- (UIButton *)navBackButton {
    
    if (!_navBackButton) {
        
        _navBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
        WEAK_SELF(self);
        [_navBackButton bk_whenTapped:^{
            STRONG_SELF(self);
            [self.navigationController popViewControllerAnimated:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [_navBackButton setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
        [_navBackButton setImageEdgeInsets:UIEdgeInsetsMake(0, -40, 0, 0)];
        
        _navBackButton.hidden = YES;
    }
    return _navBackButton;
}
- (UIImageView *)topImageView {
    
    if (!_topImageView) {
        
        _topImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img-dh"]];
        _topImageView.hidden = YES;

    }
    return _topImageView;
}

- (UIImageView *)titleImageView {
    
    if (!_titleImageView) {
        
        _titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top-kbs"]];
        _titleImageView.hidden = YES;

    }
    return _titleImageView;
}

- (UIButton *)questionButton {
    
    if (!_questionButton) {
        
        _questionButton = [UIButton buttonWithType:UIButtonTypeCustom Title:@"" titleColor:UIColorFromRGB(51, 51, 51, 1) backgroundColor:nil backgroundImage:nil Font:[UIFont systemFontOfSize:15]];
        [_questionButton setImage:[UIImage imageNamed:@"icon-xr"] forState:UIControlStateNormal];
        [_questionButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        
        _questionButton.hidden = YES;
    }
    return _questionButton;
}
- (BATDrKangAskInputBar *)askInputBar {
    
    if (!_askInputBar) {
        
        _askInputBar = [[BATDrKangAskInputBar alloc] initWithFrame:CGRectZero];
        _askInputBar.textView.delegate = self;
        _askInputBar.hidden = YES;

        WEAK_SELF(self);
        [_askInputBar.nextBtn bk_whenTapped:^{
            STRONG_SELF(self);
            NSString *content = [self.askInputBar.textView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            if (content.length == 0) {
                return ;
            }
            
            if ([self.askInputBar.tmpQuestion containsString:@"name"]) {
                
            }
            else if ([self.askInputBar.tmpQuestion containsString:@"sex"]) {
                
            }
            else if ([self.askInputBar.tmpQuestion containsString:@"age"]) {
                
            }
            else if ([self.askInputBar.tmpQuestion containsString:@"height"]) {
                
                if ([self.askInputBar.textView.text floatValue] < 20 || [self.askInputBar.textView.text floatValue] > 300) {
                    
                    [self showErrorWithText:@"请输入正确的身高"];
                    return;
                }
            }
            else if ([self.askInputBar.tmpQuestion containsString:@"weight"]) {
                
                if ([self.askInputBar.textView.text floatValue] < 2 || [self.askInputBar.textView.text floatValue] > 500) {
                    
                    [self showErrorWithText:@"请输入正确的体重"];
                    return;
                }
            }
            
            [self sendMsg:content];
            [self insertMsgWithContent:content AndSender:@"Me"];
            [self sendTextRequestWithContent:content isSound:NO];
            self.askInputBar.textView.text = @"";
        }];
    }
    return _askInputBar;
}


- (UIWebView *)chatWebView {
    
    if (!_chatWebView) {
        _chatWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
        _chatWebView.delegate = self;
//        _chatWebView.scrollView.delegate = self;
//        _chatWebView.multipleTouchEnabled=NO;
        _chatWebView.scrollView.scrollEnabled = NO;
        _chatWebView.scrollView.showsVerticalScrollIndicator = NO;
        _chatWebView.backgroundColor = BASE_BACKGROUND_COLOR;
        _chatWebView.scrollView.backgroundColor = BASE_BACKGROUND_COLOR;
    }
    return _chatWebView;
}

- (UICollectionView *)bottomCollectionView {
    
    if (!_bottomCollectionView) {
        BATEqualCellSpaceFlowLayout *flow = [[BATEqualCellSpaceFlowLayout alloc] initWithType:AlignWithCenter betweenOfCell:5];

        WEAK_SELF(self);
        [flow setResetCollectionRect:^(CGFloat contentSizeHeight) {
            STRONG_SELF(self);
        
            [self.bottomCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(contentSizeHeight);
            }];
            [self.chatWebView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.bottomCollectionView.mas_top).offset(2);
            }];
            [UIView animateWithDuration:0.0f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                [self.view setNeedsLayout];
                [self.view layoutIfNeeded];
            } completion:nil];
            [self scrollToBottom];
        }];
        
        _bottomCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flow];
        _bottomCollectionView.backgroundColor = BASE_BACKGROUND_COLOR;
        _bottomCollectionView.showsHorizontalScrollIndicator = NO;
        _bottomCollectionView.delegate = self;
        _bottomCollectionView.dataSource = self;
        
        [_bottomCollectionView registerClass:[BATDrKangBottomCollectionViewCell class] forCellWithReuseIdentifier:BOTTOM_CELL];
    }
    return _bottomCollectionView;
}

- (BATDrKangInputBar *)inputBar {
    
    if (!_inputBar) {
        
        _inputBar = [[BATDrKangInputBar alloc] initWithFrame:CGRectZero];
        _inputBar.textView.delegate = self;
        WEAK_SELF(self);
        [_inputBar setSendTextMessageBlock:^{
            STRONG_SELF(self);
            if ([self.inputBar.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
                return ;
            }
            
            [self sendMsg:self.inputBar.textView.text];
            [self insertMsgWithContent:self.inputBar.textView.text AndSender:@"Me"];

            [self sendTextRequestWithContent:self.inputBar.textView.text isSound:NO];
            
            self.inputBar.textView.text = @"";
        }];
        
        //切换输入模式
        [_inputBar setChangeInputModeBlock:^{
            STRONG_SELF(self);
            
            //从欢迎界面跳转到正常聊天界面
            if ([[NSUserDefaults standardUserDefaults] boolForKey:DEVICE_FIRST_RECORD] != YES) {
                //存储标识
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:DEVICE_FIRST_RECORD];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                //重新加载，清除欢迎语句
                [self.chatWebView loadRequest:[[NSURLRequest alloc] initWithURL:[[NSURL alloc] initFileURLWithPath:self.webFilePath]]];
                
                //进入聊天界面
                [self showChat];
                return ;
            }
            
            self.inputBar.textView.hidden = !self.inputBar.textView.hidden;
            self.inputBar.soundInputButton.hidden = !self.inputBar.soundInputButton.hidden;
            
            if (self.inputBar.textView.hidden == NO) {
                [self.inputBar.textView becomeFirstResponder];
                [self.inputBar.changeButton setImage:[UIImage imageNamed:@"icon-yl"] forState:UIControlStateNormal];
                [self.inputBar.notiBtn setTitle:@" 免打字" forState:UIControlStateNormal];
            }
            else {
                [self.inputBar.textView resignFirstResponder];
                [self.inputBar.changeButton setImage:[UIImage imageNamed:@"icon-jp"] forState:UIControlStateNormal];
                [self.inputBar.notiBtn setTitle:@" 打字" forState:UIControlStateNormal];
            }
            
        }];
        
        //开始语音识别
        [_inputBar setRecognizerBeginBlock:^{
            STRONG_SELF(self);
            
            //从欢迎界面跳转到正常聊天界面
            if ([[NSUserDefaults standardUserDefaults] boolForKey:DEVICE_FIRST_RECORD] != YES) {
                //存储标识
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:DEVICE_FIRST_RECORD];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                //重新加载，清除欢迎语句
                [self.chatWebView loadRequest:[[NSURLRequest alloc] initWithURL:[[NSURL alloc] initFileURLWithPath:self.webFilePath]]];
                
                //进入聊天界面
                [self showChat];
                return ;
            }

            
            [self.iFlySpeechRecognizer cancel];
            [self.iFlySpeechSynthesizer stopSpeaking];//语音输入时停止语音回答
            
            [self.iFlySpeechRecognizer startListening];
            
            self.voiceAlertView.image = [UIImage imageNamed:@"icon-qxfs"];
            self.voiceAlertView.hidden = NO;
            
        }];
        
        [_inputBar setRecognizerStopBlock:^{
            STRONG_SELF(self);
            
            [self.iFlySpeechRecognizer stopListening];
            
        }];
        
        [_inputBar setRecognizerAlertBlock:^{
            STRONG_SELF(self);
            self.voiceAlertView.image = [UIImage imageNamed:@"icon-sksz"];
            self.voiceAlertView.hidden = NO;
            
        }];
        
        [_inputBar setRecognizerCancelBlock:^{
            STRONG_SELF(self);
            self.voiceAlertView.hidden = YES;
            [self.iFlySpeechRecognizer cancel];
        }];
        
        [_inputBar setRecognizerContinueBlock:^{
            STRONG_SELF(self);
            self.voiceAlertView.image = [UIImage imageNamed:@"icon-qxfs"];
            self.voiceAlertView.hidden = NO;
            
        }];
    }
    return _inputBar;
}

- (UIImageView *)voiceAlertView {
    
    if (!_voiceAlertView) {
        _voiceAlertView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-qxfs"]];
        [_voiceAlertView sizeToFit];
        _voiceAlertView.hidden = YES;
    }
    return _voiceAlertView;
}

- (BATDrKangDetailView *)detailView {
    
    if (!_detailView) {
        _detailView = [[BATDrKangDetailView alloc] initWithFrame:CGRectZero];
        WEAK_SELF(self);
        [_detailView setDownBlock:^{
            STRONG_SELF(self);
            [self.detailView removeFromSuperview];
        }];
    }
    return _detailView;
}

- (BATDrKangDiseaseView *)diseaseView {
    
    if (!_diseaseView) {
        _diseaseView = [[BATDrKangDiseaseView alloc] initWithFrame:CGRectZero];
        WEAK_SELF(self);
        [_diseaseView setDownBlock:^{
            STRONG_SELF(self);
            [self.diseaseView removeFromSuperview];
        }];
        
        [_diseaseView setSelectedDisease:^(NSString *disease){
            
            STRONG_SELF(self);
            [self.diseaseView removeFromSuperview];
            [self sendMsg:disease];
            [self insertMsgWithContent:disease AndSender:@"Me"];

            [self sendTextRequestWithContent:disease isSound:NO];
            
        }];
        
        [_diseaseView setTopBlock:^{
            
            STRONG_SELF(self);
            [self.diseaseView removeFromSuperview];
        }];
    }
    return _diseaseView;
}

- (IFlySpeechRecognizer *)iFlySpeechRecognizer {
    
    if (!_iFlySpeechRecognizer) {
        _iFlySpeechRecognizer = [IFlySpeechRecognizer sharedInstance];
        
        [_iFlySpeechRecognizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
        
        //设置听写模式
        [_iFlySpeechRecognizer setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
        _iFlySpeechRecognizer.delegate = self;
        
        //设置最长录音时间
        [_iFlySpeechRecognizer setParameter:@"60000" forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
        //设置后端点
        //        [_iFlySpeechRecognizer setParameter:instance.vadEos forKey:[IFlySpeechConstant VAD_EOS]];
        //设置前端点
        //        [_iFlySpeechRecognizer setParameter:instance.vadBos forKey:[IFlySpeechConstant VAD_BOS]];
        
        //网络等待时间
        [_iFlySpeechRecognizer setParameter:@"30000" forKey:[IFlySpeechConstant NET_TIMEOUT]];
        
        //设置采样率，推荐使用16K
        [_iFlySpeechRecognizer setParameter:@"16000" forKey:[IFlySpeechConstant SAMPLE_RATE]];
        
        //设置语言
        [_iFlySpeechRecognizer setParameter:@"zh_cn" forKey:[IFlySpeechConstant LANGUAGE]];
        //设置方言
        [_iFlySpeechRecognizer setParameter:@"mandarin" forKey:[IFlySpeechConstant ACCENT]];
        //设置是否返回标点符号
        [_iFlySpeechRecognizer setParameter:@"1" forKey:[IFlySpeechConstant ASR_PTT]];
        
    }
    return _iFlySpeechRecognizer;
}

- (IFlySpeechSynthesizer *)iFlySpeechSynthesizer {
    
    if (!_iFlySpeechSynthesizer) {
        // 创建合成对象，为单例模式
        _iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance];
        _iFlySpeechSynthesizer.delegate = self;
        //设置语音合成的参数
        //语速,取值范围 0~100
        [_iFlySpeechSynthesizer setParameter:@"50" forKey:[IFlySpeechConstant SPEED]];
        //音量;取值范围 0~100
        [_iFlySpeechSynthesizer setParameter:@"50" forKey: [IFlySpeechConstant VOLUME]];
        //发音人,默认为”xiaoyan”;可以设置的参数列表可参考个 性化发音人列表
        [_iFlySpeechSynthesizer setParameter:@"vixq" forKey: [IFlySpeechConstant VOICE_NAME]];
        //音频采样率,目前支持的采样率有 16000 和 8000
        [_iFlySpeechSynthesizer setParameter:@"8000" forKey: [IFlySpeechConstant SAMPLE_RATE]];
        //asr_audio_path保存录音文件路径，如不再需要，设置value为nil表示取消，默认目录是documents
        [_iFlySpeechSynthesizer setParameter:nil forKey: [IFlySpeechConstant TTS_AUDIO_PATH]];
        //        [_iFlySpeechSynthesizer setParameter:@"tts.pcm" forKey: [IFlySpeechConstant TTS_AUDIO_PATH]];
        //启动合成会话
        
    }
    return _iFlySpeechSynthesizer;
}

- (FMDatabase *)historyDB {
    
    if (!_historyDB) {
        
        _historyDB = [[FMDatabase alloc] initWithPath:HistoryPath];
    }
    return _historyDB;
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


