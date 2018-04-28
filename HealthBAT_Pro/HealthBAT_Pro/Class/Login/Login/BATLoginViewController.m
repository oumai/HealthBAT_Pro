//
//  LoginViewController.m
//  HealthBAT_Pro
//
//  Created by Skyrim on 16/7/13.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATLoginViewController.h"
//第三方
#import "SFHFKeychainUtils.h"
//子视图
#import "BATImageTextField.h"
#import "BATLoginModel.h"
//model
#import "BATPerson.h"
#import "BATTIMDataModel.h"

//ShareCategory
//#import "BATAppDelegate+BATShare.h"

//跳转试图
#import "BATRegisterViewController.h"
#import "BATForgetPasswordViewController.h"
#import "BATBindingPhoneViewController.h"

#import "BATTIMManager.h"
#import "BATVisitConfigModel.h"

#import "IQKeyboardManager.h"//键盘管理

#import "BATAppDelegate+BATResetLogin.h"//登录

#import "BATGraditorButton.h"

#import "BATAppDelegate+BATTabbar.h"

#import "KeychainItemWrapper.h"

#import "BATLoginAllianceView.h"

@interface BATLoginViewController ()<UITextFieldDelegate>
{
    NSString *userId;
    NSString *userToken;
}

@property (nonatomic,strong) UIImageView       *topImageView;
@property (nonatomic,strong) UIView            *moveBGView;

@property (nonatomic,strong) UITextField       *loginUserTF;
@property (nonatomic,strong) UITextField       *loginPasswordTF;

@property (nonatomic,strong) UITextField       *registerPhoneTF;
@property (nonatomic,strong) UITextField       *registerCodeTF;
@property (nonatomic,strong) UITextField       *registerPasswordTF;
@property (nonatomic,strong) UIButton          *registerCountdownButton;
@property (nonatomic,strong) UIButton          *registerShowPasswordButton;

@property (nonatomic,strong) BATGraditorButton          *loginButton;
@property (nonatomic,strong) BATGraditorButton          *registerButton;
@property (nonatomic,strong) UIButton          *goRegisterButton;
@property (nonatomic,strong) UIButton          *goLoginButton;
@property (nonatomic,strong) UIButton          *forgetPasswordButton;

@property (nonatomic,assign) BOOL              isLoginIn;

@property (nonatomic,strong) BATLoginAllianceView *allianceView;

@end

@implementation BATLoginViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self userLogout];

    self.isLoginIn = YES;
    
    self.view.backgroundColor = [UIColor whiteColor];

    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];

    WEAK_SELF(self);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithBarButtonSystemItem:UIBarButtonSystemItemStop handler:^(id sender) {
        STRONG_SELF(self);
        [self dismissProgress];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    //绑定手机成功通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bindingPhoneSucess) name:@"DINDING_PHONE_SUCCESS" object:nil];
    
    [self pagesLayout];


    self.loginUserTF.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"LOGIN_NAME"];
    if (self.loginUserTF.text.length == 0) {
        return;
    }
    NSError *error;
    NSString * password = [SFHFKeychainUtils getPasswordForUsername:self.loginUserTF.text andServiceName:ServiceName error:&error];
    if(error){
        DDLogError(@"从Keychain里获取密码出错：%@",error);
        return;
    }
    self.loginPasswordTF.text = password;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
   // [TalkingData trackPageBegin:@"登录"];
    
    //进入注册登录页面
    [NBSAppAgent trackEvent:ENTER_LOGIN_REGISTER_VC withEventTag:@"进入注册登录页面" withEventProperties:nil];
    
    
//#ifdef TESTING
//    
//    //判断本地的sessionID
//    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:kKMHealthCloudKey accessGroup:nil];
//    NSString * sessionID = [wrapper objectForKey:(id)kSecValueData];
//    
//    if (sessionID.length == 0 || !sessionID) {
//        //未能获取到sessionID
//        return;
//    }
//    
//    //判断sessionID是否有效
//    
//    [self loginRequestWithSessionID:sessionID];
//#endif

}

- (void)viewDidDisappear:(BOOL)animated {

    [super viewDidDisappear:animated];
    
    //[TalkingData trackPageEnd:@"登录"];
    
    [HTTPTool requestWithURLString:@"/api/Common/GetVisitConfig" parameters:nil type:kGET success:^(id responseObject) {
        BATVisitConfigModel *visitConfigModel = [BATVisitConfigModel mj_objectWithKeyValues:responseObject];
        [[NSUserDefaults standardUserDefaults] setBool:visitConfigModel.CanConsult forKey:@"CanConsult"];
        [[NSUserDefaults standardUserDefaults] setBool:visitConfigModel.CanRegister forKey:@"CanRegister"];
        [[NSUserDefaults standardUserDefaults] setBool:visitConfigModel.CanVisitShop forKey:@"CanVisitShop"];
        [[NSUserDefaults standardUserDefaults] synchronize];

    } failure:^(NSError *error) {

    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate

//-(void)textFieldDidEndEditing:(UITextField *)textField{
//
//    if (![Tools checkPhoneNumber:textField.text]) {
//        [self showErrorWithText:@"请输入正确的手机号码"];
//    }
//}

#pragma mark - Action
- (void)login {
    if (self.loginUserTF.text.length == 0) {
        [self showErrorWithText:@"请输入帐号或者手机号"];
        return;
    }

    if (self.loginPasswordTF.text.length == 0) {
        [self showErrorWithText:@"请输入密码"];
        return;
    }

    [self.view endEditing:YES];
    [self loginRequest];
}

- (void)bindingPhoneSucess{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:NO completion:nil];
    });
}

- (void)userLogout {

    //清空极光推送别名
//    [JPUSHService setAlias:@"" callbackSelector:nil object:nil];


    [[NSNotificationCenter defaultCenter] postNotificationName:@"APPLICATION_LOGOUT" object:nil];

    //改变登录状态
    SET_LOGIN_STATION(NO);

    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"Token"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [[BATTIMManager sharedBATTIM] bat_loginOutTIM];

    [[NSFileManager defaultManager] removeItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/UserLogin.data"] error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Person.data"] error:nil];

}

#pragma mark - NET
- (void)loginRequest {
    
    //点击了登录按钮
       [NBSAppAgent trackEvent:LOGIN_BUTTON_CLICK withEventTag:@"点击了登录按钮" withEventProperties:nil];
    
    [self showProgressWithText:@"正在登录"];

    BATAppDelegate *delegate = (BATAppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate bat_LoginWithUserName:self.loginUserTF.text password:self.loginPasswordTF.text Success:^{

        [self showSuccessWithText:@"登录成功"];
        //完成登录，退出登录界面
        [self dismissViewControllerAnimated:YES completion:nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Login_Success_Show_Consulition_Order_Data" object:nil];
        
        //设置健康咨询红点
//        BATAppDelegate *delegate = (BATAppDelegate *)[UIApplication sharedApplication].delegate;
//        NSArray *oldArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"channelIDArray"];
//        [delegate setTarBarWithMessageCount:oldArr.count];
        
    } failure:^(NSError *error) {
        
        [self showErrorWithText:error.localizedDescription];
    }];
}

//获取云通讯信息
- (void)getTIMDataRequest{
    
    [HTTPTool requestWithURLString:@"/api/Account/GetIMConfig" parameters:nil type:kGET success:^(id responseObject) {
        
        BATTIMDataModel *TIMData= [BATTIMDataModel mj_objectWithKeyValues:responseObject];
        
        if (TIMData.ResultCode == 0) {
            
            NSString *file = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/TIMData.data"];
            [NSKeyedArchiver archiveRootObject:TIMData toFile:file];
            
            [[BATTIMManager sharedBATTIM] bat_loginTIM];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)personInfoListRequest {

    [HTTPTool requestWithURLString:@"/api/Patient/Info" parameters:nil type:kGET success:^(id responseObject) {
        
        BATPerson * person = [BATPerson mj_objectWithKeyValues:responseObject];
        if (person.ResultCode == 0) {

            //保存登录信息
            NSString *file = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Person.data"];
            [NSKeyedArchiver archiveRootObject:person toFile:file];
        }
    } failure:^(NSError *error) {

    }];
}

#pragma mark - net
- (void)codeRequest {
    
    //判断输入的手机号码是否符合规范
    if (![Tools checkPhoneNumber:self.registerPhoneTF.text]) {
        [self showText:@"请输入正确的手机号"];
        return;
    }
    
    [self showProgress];
    
    //点击了获取授权码
     [NBSAppAgent trackEvent:AUTH_CODER_BUTTON_CLICK withEventTag:@"点击了获取授权码" withEventProperties:nil];
    
    [HTTPTool requestWithURLString:[NSString stringWithFormat:@"/api/Account/SendVerifyCode/%@/1",self.registerPhoneTF.text] parameters:nil type:kGET success:^(id responseObject) {
        
        [self dismissProgress];
        
        //创建获取验证码的定时器
        self.registerCountdownButton.userInteractionEnabled = NO;
        self.registerCountdownButton.backgroundColor = [UIColor clearColor];
        [self.registerCountdownButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [Tools countdownWithTime:120 End:^{
            [self.registerCountdownButton setTitle:@"获取验证码" forState:UIControlStateNormal];
            [self.registerCountdownButton setTitleColor:BASE_COLOR forState:UIControlStateNormal];
            self.registerCountdownButton.userInteractionEnabled = YES;
        } going:^(NSString *time) {
            [self.registerCountdownButton setTitle:time forState:UIControlStateNormal];
        }];
        
        
    } failure:^(NSError *error) {
        [self showErrorWithText:error.localizedDescription];
    }];
}

-(void)registerBAT {
    
    [self.view endEditing: YES];
    //判断输入框是否为空。(即无输入)
    if (self.registerPhoneTF.text.length == 0) {
        [self showText:@"请输入手机号"];
        return;
    }
    
    //判断输入的手机号码是否符合规范
    if (![Tools checkPhoneNumber:self.registerPhoneTF.text]) {
        [self showText:@"请输入正确的手机号"];
        return;
    }
    
    
    if (self.registerCodeTF.text.length == 0) {
        [self showText:@"请输入验证码"];
        return;
    }
    if (self.registerPasswordTF.text.length == 0) {
        [self showText:@"请输入密码"];
        return;
    }
    
    if(self.registerPasswordTF.text.length > 18){
        [self showText:@"密码过长，请重新输入"];
        return;
    }
    if(self.registerPasswordTF.text.length < 6){
        [self showText:@"密码过短，请重新输入"];
        return;
    }
    
    if ([self.registerPasswordTF.text rangeOfString:@" "].location != NSNotFound) {
        [self showText:@"密码中不能包含空格"];
        return;
    }
    
    
    [self registerRequest];
}

- (void)registerRequest {
    
    //点击注册按钮
    [NBSAppAgent trackEvent:REGISTER_BUTTON_CLICK withEventTag:@"点击注册按钮" withEventProperties:nil];
    
    NSDictionary *para = @{@"VerificationCode":self.registerCodeTF.text,@"Password":self.registerPasswordTF.text,@"PhoneNumber":self.registerPhoneTF.text,@"AccountLevel":@"BAT"};
    [self showProgress];
    [HTTPTool requestWithURLString:@"/api/NetworkMedical/UserRegister" parameters:para type:kPOST success:^(id responseObject) {
        
        [self showSuccessWithText:@"注册成功"];
        
      //  [TalkingData trackEvent:@"100001" label:@"注册"];
        
        BATLoginModel * login = [BATLoginModel mj_objectWithKeyValues:responseObject];
        
        if (login.ResultCode == 0) {
           
            BATAppDelegate *delegate = (BATAppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate successActionWithLogin:login userName:self.registerPhoneTF.text password:self.registerPasswordTF.text];
            
            //重新获取配置信息
            [[NSNotificationCenter defaultCenter] postNotificationName:@"APPLICATION_CONFIG_REQUEST" object:nil];
        }
        
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        
    } failure:^(NSError *error) {
        [self showErrorWithText:error.localizedDescription];

    }];
}

- (void)loginRequestWithSessionID:(NSString *)sessionID {
    
    [HTTPTool requestWithURLString:@"/api/networkmedical/login_sso" parameters:@{@"sessionid":sessionID} type:kGET success:^(id responseObject) {
        
        BATLoginModel *login = [BATLoginModel mj_objectWithKeyValues:responseObject];
        //弹出存储的账户
        
        self.allianceView.mobileLabel.text = [Tools replacePhoneMiddleWithPhoneNumber:login.Data.Mobile];
        
        [self.view addSubview:self.allianceView];
        [self.allianceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@0);
        }];
        
        WEAK_SELF(self);
        [self.allianceView setLoginBlock:^{
            BATAppDelegate *delegate = (BATAppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate successActionWithLogin:login userName:nil password:nil];
            STRONG_SELF(self);
            [self showSuccessWithText:@"登录成功"];
            //完成登录，退出登录界面
            [self dismissViewControllerAnimated:YES completion:nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Login_Success_Show_Consulition_Order_Data" object:nil];
            
            //设置健康咨询红点
//            NSArray *oldArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"channelIDArray"];
//            [delegate setTarBarWithMessageCount:oldArr.count];
        }];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Layout
- (void)pagesLayout {
    
    /**
     *  判断手机型号，调整整体布局
     */
    CGFloat lineSpa;
    CGFloat height;
    
   
    if(iPhone5){
        lineSpa = 10;
        height = 40;
    }else if(iPhone6){
        lineSpa = 15;
        height = 45;
    }else if(iPhone6p){
        lineSpa = 20;
        height = 50;
    }else if (iPhoneX) {
        lineSpa = 20;
        height = 50;
    }else {
        lineSpa = 7;
        height = 30;
    }
    

    WEAK_SELF(self);
    [self.view addSubview:self.topImageView];
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(64+20);
    }];
    
    
    //======滑动背景========================
    [self.view addSubview:self.moveBGView];
    [self.moveBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        
        make.top.equalTo(self.topImageView.mas_bottom).offset(3*lineSpa);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.height.mas_equalTo(3*(lineSpa + height) + 28);
        make.width.mas_equalTo(SCREEN_WIDTH*2);
    }];

    
    //======登录控件========================
    [self.moveBGView addSubview:self.loginUserTF];
    [self.loginUserTF mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        
        make.top.equalTo(self.moveBGView.mas_top).offset(0);
        make.left.equalTo(self.moveBGView.mas_left).offset(23);
        make.height.mas_equalTo(height);
        make.width.mas_equalTo(SCREEN_WIDTH-46);
    }];
    
    //手机号下划线
    UIView *userTFLine = [[UIView alloc]init];
    userTFLine.backgroundColor = [UIColor lightGrayColor];
    [self.moveBGView addSubview:userTFLine];
    [userTFLine mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        
        make.top.equalTo(self.loginUserTF.mas_bottom).offset(1);
        make.left.equalTo(self.moveBGView.mas_left).offset(23);
        make.height.mas_equalTo(0.5);
        make.width.mas_equalTo(SCREEN_WIDTH-46);
    }];

    [self.moveBGView addSubview:self.loginPasswordTF];
    [self.loginPasswordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);

        make.top.equalTo(self.loginUserTF.mas_bottom).offset(lineSpa);
        make.left.equalTo(self.moveBGView.mas_left).offset(23);
        make.height.mas_equalTo(height);
        make.width.mas_equalTo(SCREEN_WIDTH-46);
    }];
    
    //密码下划线
    UIView *passwordTFLine = [[UIView alloc]init];
    passwordTFLine.backgroundColor = [UIColor lightGrayColor];
    [self.moveBGView addSubview:passwordTFLine];
    [passwordTFLine mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        
        make.top.equalTo(self.loginPasswordTF.mas_bottom).offset(1);
        make.left.equalTo(self.moveBGView.mas_left).offset(23);
        make.height.mas_equalTo(0.5);
        make.width.mas_equalTo(SCREEN_WIDTH-46);
    }];
    
    [self.moveBGView addSubview:self.forgetPasswordButton];
    [self.forgetPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        
        make.right.equalTo(self.loginPasswordTF.mas_right);
        make.top.equalTo(self.loginPasswordTF.mas_bottom).offset(13);
    }];

    [self.view addSubview:self.loginButton];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);

        make.top.equalTo(self.moveBGView.mas_bottom).offset(0);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(height);
        make.width.mas_equalTo(SCREEN_WIDTH-40);
    }];
    
    [self.view addSubview:self.goRegisterButton];
    [self.goRegisterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.loginButton.mas_bottom).offset(32);
    }];
    
    
    //======注册控件========================
    [self.moveBGView addSubview:self.registerPhoneTF];
    [self.registerPhoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        
        make.top.equalTo(self.moveBGView.mas_top).offset(0);
        make.left.equalTo(self.moveBGView.mas_left).offset(23 + SCREEN_WIDTH);
        make.height.mas_equalTo(height);
        make.width.mas_equalTo(SCREEN_WIDTH-46);
    }];
    
    //手机号下划线
    UIView *phoneTFLine = [[UIView alloc]init];
    phoneTFLine.backgroundColor = [UIColor lightGrayColor];
    [self.moveBGView addSubview:phoneTFLine];
    [phoneTFLine mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        
        make.top.equalTo(self.registerPhoneTF.mas_bottom).offset(1);
        make.left.equalTo(self.moveBGView.mas_left).offset(23 + SCREEN_WIDTH);
        make.height.mas_equalTo(0.5);
        make.width.mas_equalTo(SCREEN_WIDTH-46);
    }];

    [self.moveBGView addSubview:self.registerCodeTF];
    [self.registerCodeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        
        make.left.equalTo(self.moveBGView.mas_left).offset(23 + SCREEN_WIDTH);
        make.top.equalTo(self.registerPhoneTF.mas_bottom).offset(lineSpa);
        make.height.mas_equalTo(height);
        make.width.mas_equalTo(SCREEN_WIDTH - 46 - 80);
    }];
    
    [self.moveBGView addSubview:self.registerCountdownButton];
    [self.registerCountdownButton mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        
        make.right.equalTo(self.moveBGView.mas_right).offset(-23);
        make.centerY.equalTo(self.registerCodeTF.mas_centerY);
    }];
    
    
    //验证码下划线
    UIView *codeTFLine = [[UIView alloc]init];
    codeTFLine.backgroundColor = [UIColor lightGrayColor];
    [self.moveBGView addSubview:codeTFLine];
    [codeTFLine mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        
        make.top.equalTo(self.registerCodeTF.mas_bottom).offset(1);
        make.left.equalTo(self.moveBGView.mas_left).offset(23 +SCREEN_WIDTH);
        make.height.mas_equalTo(0.5);
        make.width.mas_equalTo(SCREEN_WIDTH-46);
    }];
    
    [self.moveBGView addSubview:self.registerPasswordTF];
    [self.registerPasswordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        
        make.left.equalTo(self.moveBGView.mas_left).offset(23 + SCREEN_WIDTH);
        make.top.equalTo(self.registerCodeTF.mas_bottom).offset(lineSpa);
        make.height.mas_equalTo(height);
        make.width.mas_equalTo(SCREEN_WIDTH - 46 - 40);
    }];
    
    //密码下划线
    UIView *registerPasswordTFLine = [[UIView alloc]init];
    registerPasswordTFLine.backgroundColor = [UIColor lightGrayColor];
    [self.moveBGView addSubview:registerPasswordTFLine];
    [registerPasswordTFLine mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        
        make.top.equalTo(self.registerPasswordTF.mas_bottom).offset(1);
        make.left.equalTo(self.moveBGView.mas_left).offset(23 +SCREEN_WIDTH);
        make.height.mas_equalTo(0.5);
        make.width.mas_equalTo(SCREEN_WIDTH-46);
    }];
    
    [self.moveBGView addSubview:self.registerShowPasswordButton];
    [self.registerShowPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        
        make.centerY.equalTo(self.registerPasswordTF.mas_centerY);
        make.right.equalTo(self.moveBGView.mas_right).offset(-23);
    }];
    
    
    [self.view addSubview:self.registerButton];
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        
        make.top.equalTo(self.moveBGView.mas_bottom).offset(0);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(height);
        make.width.mas_equalTo(SCREEN_WIDTH-46);
    }];
    
    [self.view addSubview:self.goLoginButton];
    [self.goLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.registerButton.mas_bottom).offset(32);
    }];
}

#pragma mark - setter && getter
- (UIImageView *)topImageView {
    if (!_topImageView) {
        _topImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_login_logo"]];
        _topImageView.layer.cornerRadius = 7.0f;
        _topImageView.clipsToBounds = YES;
    }
    return _topImageView;
}

- (UIView *)moveBGView{
    if (!_moveBGView) {
        _moveBGView = [[UIView alloc]initWithFrame:CGRectZero];
    }
    return _moveBGView;
}

- (UITextField *)loginUserTF {
    if (!_loginUserTF) {
        _loginUserTF = [UITextField textFieldWithfont:[UIFont systemFontOfSize:15] textColor:BASE_COLOR placeholder:@"请输入手机号" BorderStyle:UITextBorderStyleNone];
        _loginUserTF.keyboardType = UIKeyboardTypePhonePad;
        _loginUserTF.delegate = self;
        
    }
    return _loginUserTF;
}

- (UITextField *)loginPasswordTF {

    if (!_loginPasswordTF) {
        
        _loginPasswordTF = [UITextField textFieldWithfont:[UIFont systemFontOfSize:15] textColor:BASE_COLOR placeholder:@"请输入密码" BorderStyle:UITextBorderStyleNone];
        _loginPasswordTF.secureTextEntry = YES;
    }
    return _loginPasswordTF;
}

- (BATGraditorButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [BATGraditorButton buttonWithType:UIButtonTypeCustom];
        
//        [_loginButton setFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20.0f, 40)];
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        _loginButton.layer.cornerRadius = 3.0f;
        _loginButton.layer.masksToBounds = YES;
        
        [_loginButton setGradientColors:@[START_COLOR,END_COLOR]];
        _loginButton.enablehollowOut = YES;
        _loginButton.titleColor  = [UIColor whiteColor];
        WEAK_SELF(self);
        [_loginButton bk_whenTapped:^{
            STRONG_SELF(self);

            [self login];

        }];
    }
    return _loginButton;
}

- (BATGraditorButton *)registerButton{
    if (!_registerButton) {
        
        _registerButton = [BATGraditorButton buttonWithType:UIButtonTypeCustom];
        
//        [_registerButton setFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20.0f, 40)];
        [_registerButton setTitle:@"注册" forState:UIControlStateNormal];
        _registerButton.layer.cornerRadius = 3.0f;
        _registerButton.layer.masksToBounds = YES;
        
        [_registerButton setGradientColors:@[START_COLOR,END_COLOR]];
        _registerButton.enablehollowOut = YES;
        _registerButton.titleColor  = [UIColor whiteColor];
        
        _registerButton.hidden = YES;
        WEAK_SELF(self);
        [_registerButton bk_whenTapped:^{
            STRONG_SELF(self);

            [self registerBAT];
            
        }];
    }
    return _registerButton;
}

- (UIButton *)goLoginButton{
    if (!_goLoginButton) {
        _goLoginButton = [UIButton buttonWithType:UIButtonTypeCustom Title:@"已有账号？去登录" titleColor:BASE_COLOR  backgroundColor:[UIColor clearColor] backgroundImage:nil Font:[UIFont systemFontOfSize:14]];
        _goLoginButton.hidden = YES;
        
        WEAK_SELF(self);
        [_goLoginButton bk_whenTapped:^{
            
            STRONG_SELF(self);
            [self.moveBGView mas_updateConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(self.view.mas_left).offset(0);
                
            }];
            [UIView animateWithDuration:0.35f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                [self.view setNeedsLayout];
                [self.view layoutIfNeeded];
            } completion:nil];
            self.registerButton.hidden = YES;
            self.goRegisterButton.hidden = NO;
            self.goLoginButton.hidden = YES;
            self.registerPasswordTF.text = @"";
            self.registerPhoneTF.text = @"";
            self.registerCodeTF.text = @"";
            
        }];
    }
    return _goLoginButton;
}

- (UIButton *)goRegisterButton {
    if (!_goRegisterButton) {
        _goRegisterButton = [UIButton buttonWithType:UIButtonTypeCustom Title:@"没有账号？去注册" titleColor:BASE_COLOR  backgroundColor:[UIColor clearColor] backgroundImage:nil Font:[UIFont systemFontOfSize:14]];
        
        WEAK_SELF(self);
        [_goRegisterButton bk_whenTapped:^{
            
            //点击了没有账号去注册按钮
             [NBSAppAgent trackEvent:GO_REGISTER_BUTTON_CLICK withEventTag:@"点击了没有账号去注册按钮" withEventProperties:nil];
            
            STRONG_SELF(self);
            [self.moveBGView mas_updateConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(self.view.mas_left).offset(-SCREEN_WIDTH);
                
            }];

            [UIView animateWithDuration:0.35f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                [self.view setNeedsLayout];
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {

                [self.registerPhoneTF becomeFirstResponder];
            }];

            self.registerButton.hidden = NO;
            self.goRegisterButton.hidden = YES;
            self.goLoginButton.hidden = NO;
            
           
        }];
    }
    return _goRegisterButton;
}

- (UIButton *)forgetPasswordButton {
    if (!_forgetPasswordButton) {
        _forgetPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom Title:@"忘记密码?" titleColor:BASE_COLOR  backgroundColor:[UIColor clearColor] backgroundImage:nil Font:[UIFont systemFontOfSize:14]];
        [_forgetPasswordButton bk_whenTapped:^{
            BATForgetPasswordViewController *forgetPasswordVC = [[BATForgetPasswordViewController alloc] init];
        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:forgetPasswordVC] animated:YES completion:nil];
        }];
    }
    return _forgetPasswordButton;

}


//=====注册控件====================
- (UITextField *)registerPhoneTF {
    if (!_registerPhoneTF) {
        _registerPhoneTF = [UITextField textFieldWithfont:[UIFont systemFontOfSize:15] textColor:BASE_COLOR placeholder:@"请输入手机号" BorderStyle:UITextBorderStyleNone];
        _registerPhoneTF.keyboardType = UIKeyboardTypePhonePad;
        _registerPhoneTF.delegate = self;
    }
    return _registerPhoneTF;
}

- (UITextField *)registerCodeTF {
    if (!_registerCodeTF) {
        _registerCodeTF = [UITextField textFieldWithfont:[UIFont systemFontOfSize:15] textColor:BASE_COLOR placeholder:@"请输入验证码" BorderStyle:UITextBorderStyleNone];
        _registerCodeTF.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _registerCodeTF;
}

- (UIButton *)registerCountdownButton {
    if (!_registerCountdownButton) {
        _registerCountdownButton = [UIButton buttonWithType:UIButtonTypeCustom Title:@"发送验证码" titleColor:BASE_COLOR backgroundColor:[UIColor clearColor] backgroundImage:nil Font:[UIFont systemFontOfSize:14]];
        [_registerCountdownButton sizeToFit];
        WEAK_SELF(self);
        [_registerCountdownButton bk_whenTapped:^{
            
            STRONG_SELF(self);
            [self.view endEditing:YES];
            [self codeRequest];
        }];
    }
    return _registerCountdownButton;
}

- (UITextField *)registerPasswordTF {
    if (!_registerPasswordTF) {
        _registerPasswordTF = [UITextField textFieldWithfont:[UIFont systemFontOfSize:15] textColor:BASE_COLOR placeholder:@"请输入密码" BorderStyle:UITextBorderStyleNone];
        _registerPasswordTF.secureTextEntry = YES;
    }
    return _registerPasswordTF;
}


- (UIButton *)registerShowPasswordButton{
    if (!_registerShowPasswordButton) {
        _registerShowPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom Title:@"" titleColor:BASE_COLOR backgroundColor:[UIColor clearColor] backgroundImage:[UIImage imageNamed:@"ic-xs"] Font:nil];
        [_registerShowPasswordButton sizeToFit];
        WEAK_SELF(self);
        [_registerShowPasswordButton bk_whenTapped:^{
            STRONG_SELF(self);
            if (self.registerPasswordTF.secureTextEntry) {
                self.registerPasswordTF.secureTextEntry = NO;
            }else{
                self.registerPasswordTF.secureTextEntry = YES;
            }
            
        }];
    }
    return _registerShowPasswordButton;
}

- (BATLoginAllianceView *)allianceView {
    
    if (!_allianceView) {
        
        _allianceView = [[BATLoginAllianceView alloc] initWithFrame:CGRectZero];
        
        WEAK_SELF(self);
        [_allianceView setDownBlock:^{
            STRONG_SELF(self);
            [self.allianceView removeFromSuperview];
        }];
    }
    return _allianceView;
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
