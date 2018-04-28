//
//  BATBindingPhoneViewController.m
//  HealthBAT_Pro
//
//  Created by four on 16/9/12.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATBindingPhoneViewController.h"

#import "BATLoginModel.h"
#import "BATPerson.h"

#import "BATBindingOldPhoneViewController.h"

@interface BATBindingPhoneViewController ()<UITextFieldDelegate>

@property (nonatomic,strong) UIImageView *topImageView;
@property (nonatomic,strong) UITextField *phoneTF;
@property (nonatomic,strong) UITextField *codeTF;
@property (nonatomic,strong) UIButton *countdownButton;
@property (nonatomic,strong) UITextField *passwordTF;
@property (nonatomic,strong) UITextField *confirmPasswordTF;
@property (nonatomic,strong) UILabel *promptLable;
@property (nonatomic,strong) UIButton *bindingButton;
@property (nonatomic,strong) UIButton *bindingOldPhoneButton;


@end

@implementation BATBindingPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self layoutPages];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    
    WEAK_SELF(self);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithBarButtonSystemItem:UIBarButtonSystemItemStop handler:^(id sender) {
        STRONG_SELF(self);
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    [self.view endEditing:YES];
    return YES;
}

#pragma mark - action
-(void)bindingBAT {
    
    [self.view endEditing: YES];
    //判断输入框是否为空。(即无输入)
    if (self.phoneTF.text.length == 0) {
        [self showText:@"请输入手机号"];
        return;
    }
    if (self.codeTF.text.length == 0) {
        [self showText:@"请输入验证码"];
        return;
    }
    
    //判断输入的手机号码是否符合规范
    if (![Tools checkPhoneNumber:self.phoneTF.text]) {
        [self showText:@"请输入正确的手机号"];
        return;
    }
    
    //判断两次输入的密码是否一致(同时为空已处理)
    if (![self.confirmPasswordTF.text isEqualToString:self.passwordTF.text]) {
        [self showText:@"两次密码不一致，请重新输入"];
        return;
    }
    
    if ([self.passwordTF.text rangeOfString:@" "].location != NSNotFound) {
        [self showText:@"密码中不能包含空格"];
        return;
    }
    
    [self registerRequest];
}

#pragma mark - net
- (void)codeRequest {
    
    //判断输入的手机号码是否符合规范
    if (![Tools checkPhoneNumber:self.phoneTF.text]) {
        [self showText:@"请输入正确的手机号"];
        return;
    }
    
    [HTTPTool requestWithURLString:[NSString stringWithFormat:@"/api/Account/SendVerifyCode/%@/1",self.phoneTF.text] parameters:nil type:kGET success:^(id responseObject) {
        //创建获取验证码的定时器
        self.countdownButton.userInteractionEnabled = NO;
        self.countdownButton.backgroundColor = [UIColor clearColor];
        [self.countdownButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [Tools countdownWithTime:120 End:^{
            [self.countdownButton setTitle:@"获取验证码" forState:UIControlStateNormal];
            [self.countdownButton setTitleColor:BASE_COLOR forState:UIControlStateNormal];
            self.countdownButton.userInteractionEnabled = YES;
        } going:^(NSString *time) {
            [self.countdownButton setTitle:time forState:UIControlStateNormal];
        }];
    } failure:^(NSError *error) {
        
    }];
}

- (void)registerRequest {
    
    NSDictionary *ParametDict = @{@"OtherType":self.type,
                                  @"OtherKey":self.unionID,
                                  @"OtherToken":self.accountToken,
                                  @"PhoneNumber":self.phoneTF.text,
                                  @"Password":self.passwordTF.text,
                                  @"VerificationCode":self.codeTF.text,
                                  @"RegisterType":@"1"
                                  };
    
    //绑定手机号
    [HTTPTool requestWithURLString:@"/api/Account/LoginWithNoBind" parameters:ParametDict type:kPOST success:^(id responseObject) {
        
        
//        [self showSuccessWithText:@"绑定成功"];
        
        //改变登录状态
        SET_LOGIN_STATION(YES);
        
        if([self.type isEqualToString:@"1"]){
          //  [TalkingData trackEvent:@"100004" label:@"第三方微信登录"];
        }
        
        if ([self.type isEqualToString:@"2"]) {
           // [TalkingData trackEvent:@"100003" label:@"第三方QQ登录"];
        }
    
        BATLoginModel * login = [BATLoginModel mj_objectWithKeyValues:responseObject];
        //保存登录信息
        NSString *file = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/UserLogin.data"];
        [NSKeyedArchiver archiveRootObject:login toFile:file];
        [[NSUserDefaults standardUserDefaults] setValue:login.Data.Token forKey:@"Token"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //获取个人信息
        [self personInfoListRequest];
        
        //获取云通讯配置信息
        [[BATTIMManager sharedBATTIM] bat_loginTIM];
        
        //直接登录
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DINDING_PHONE_SUCCESS" object:self userInfo:nil];

        [self dismissViewControllerAnimated:YES completion:nil];

        
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

#pragma mark - layout
- (void)layoutPages {
    
    /**
     *  判断手机型号，调整整体布局
     */
    CGFloat lineSpa;
    CGFloat height;
    if (iPhone4) {
        lineSpa = 7;
        height = 35;
    }
    else if(iPhone5){
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
    }else{
        lineSpa = 20;
        height = 50;
    }
    
    WEAK_SELF(self);
    [self.view addSubview:self.topImageView];
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(64+20);
        
    }];
    
    [self.view addSubview:self.phoneTF];
    [self.phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(SCREEN_WIDTH-45);
        make.top.equalTo(self.topImageView.mas_bottom).offset(3*lineSpa);
        make.height.mas_equalTo(height);
    }];
    
    //手机号下划线
    UIView *phoneTFLine = [[UIView alloc]init];
    phoneTFLine.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:phoneTFLine];
    [phoneTFLine mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        
        make.top.equalTo(self.phoneTF.mas_bottom).offset(1);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(0.5);
        make.width.mas_equalTo(SCREEN_WIDTH-50);
    }];
    
    [self.view addSubview:self.countdownButton];
    [self.countdownButton mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        
        make.right.equalTo(self.view.mas_right).offset(-22.5);
        make.top.equalTo(self.phoneTF.mas_bottom).offset(lineSpa);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(height);
    }];
    
    //验证码分割线
    UIView *codeCutLine = [[UIView alloc]init];
    codeCutLine.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:codeCutLine];
    [codeCutLine mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        
        make.right.equalTo(self.countdownButton.mas_left).offset(-1);
        make.centerY.equalTo(self.countdownButton.mas_centerY);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(1);
    }];
    
    [self.view addSubview:self.codeTF];
    [self.codeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        
        make.left.equalTo(self.view.mas_left).offset(22.5);
        make.top.equalTo(self.phoneTF.mas_bottom).offset(lineSpa);
        make.right.equalTo(codeCutLine.mas_left).offset(-20);
        make.height.mas_equalTo(height);
    }];
    
    //验证码下划线
    UIView *codeTFLine = [[UIView alloc]init];
    codeTFLine.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:codeTFLine];
    [codeTFLine mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        
        make.top.equalTo(self.codeTF.mas_bottom).offset(1);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(0.5);
        make.width.mas_equalTo(SCREEN_WIDTH-50);
    }];
    
    [self.view addSubview:self.passwordTF];
    [self.passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(SCREEN_WIDTH-45);
        make.top.equalTo(self.codeTF.mas_bottom).offset(lineSpa);
        make.height.mas_equalTo(height);
    }];
    
    //密码下划线
    UIView *passwordTFLine = [[UIView alloc]init];
    passwordTFLine.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:passwordTFLine];
    [passwordTFLine mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        
        make.top.equalTo(self.passwordTF.mas_bottom).offset(1);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(0.5);
        make.width.mas_equalTo(SCREEN_WIDTH-50);
    }];
    
    [self.view addSubview:self.confirmPasswordTF];
    [self.confirmPasswordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(SCREEN_WIDTH-45);
        make.top.equalTo(self.passwordTF.mas_bottom).offset(lineSpa);
        make.height.mas_equalTo(height);
    }];
    
    //确认密码下划线
    UIView *surePasswordTFLine = [[UIView alloc]init];
    surePasswordTFLine.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:surePasswordTFLine];
    [surePasswordTFLine mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        
        make.top.equalTo(self.confirmPasswordTF.mas_bottom).offset(1);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(0.5);
        make.width.mas_equalTo(SCREEN_WIDTH-50);
    }];
    
    [self.view addSubview:self.bindingButton];
    [self.bindingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(SCREEN_WIDTH-45);
        make.top.equalTo(self.confirmPasswordTF.mas_bottom).offset(3*lineSpa);
        make.height.mas_equalTo(height);
    }];
    
    [self.view addSubview:self.bindingOldPhoneButton];
    [self.bindingOldPhoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.width.mas_equalTo(120);
        make.top.equalTo(self.bindingButton.mas_bottom).offset(lineSpa);
        make.height.mas_equalTo(20);
    }];
    
    [self.view addSubview:self.promptLable];
    [self.promptLable mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(SCREEN_WIDTH-45);
        make.bottom.equalTo(self.view.mas_bottom).offset(-lineSpa);
        make.height.mas_equalTo(25);
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

- (UITextField *)phoneTF {
    if (!_phoneTF) {
        _phoneTF = [UITextField textFieldWithfont:[UIFont systemFontOfSize:15] textColor:nil placeholder:@"请输入手机号" BorderStyle:UITextBorderStyleNone];
        _phoneTF.keyboardType = UIKeyboardTypePhonePad;
        UILabel *phoneLabel = [[UILabel alloc] init];
        phoneLabel.text = @"手机号：";
        [phoneLabel sizeToFit];
        _phoneTF.leftView = phoneLabel;
        _phoneTF.leftViewMode = UITextFieldViewModeAlways;
    }
    return _phoneTF;
}

- (UITextField *)codeTF {
    if (!_codeTF) {
        _codeTF = [UITextField textFieldWithfont:[UIFont systemFontOfSize:14] textColor:nil placeholder:@"请输入验证码" BorderStyle:UITextBorderStyleNone];
        _codeTF.keyboardType = UIKeyboardTypeNumberPad;
        UILabel *codeLabel = [[UILabel alloc] init];
        codeLabel.text = @"验证码：";
        [codeLabel sizeToFit];
        _codeTF.leftView = codeLabel;
        _codeTF.leftViewMode = UITextFieldViewModeAlways;
    }
    return _codeTF;
}

- (UIButton *)countdownButton {
    if (!_countdownButton) {
        _countdownButton = [UIButton buttonWithType:UIButtonTypeCustom Title:@"发送验证码" titleColor:BASE_COLOR backgroundColor:[UIColor clearColor] backgroundImage:nil Font:[UIFont systemFontOfSize:14]];
        _countdownButton.layer.cornerRadius = 5.0f;
        WEAK_SELF(self);
        [_countdownButton bk_whenTapped:^{
            STRONG_SELF(self);
            [self.view endEditing:YES];
            [self codeRequest];
        }];
    }
    return _countdownButton;
}

- (UILabel *)promptLable{
    if(!_promptLable){
        _promptLable = [UILabel labelWithFont:[UIFont systemFontOfSize:12] textColor:UIColorFromHEX(0x666666,1) textAlignment:NSTextAlignmentCenter];
        _promptLable.text = @"绑定常用手机，手机号直接登录更方便";
    }
    return _promptLable;
}

- (UITextField *)passwordTF {
    if (!_passwordTF) {
        _passwordTF = [UITextField textFieldWithfont:[UIFont systemFontOfSize:14] textColor:nil placeholder:@"请输入密码" BorderStyle:UITextBorderStyleNone];
        _passwordTF.secureTextEntry = YES;
        UILabel *passwordLabel = [[UILabel alloc] init];
        passwordLabel.text = @"密    码：";
        [passwordLabel sizeToFit];
        _passwordTF.leftView = passwordLabel;
        _passwordTF.leftViewMode = UITextFieldViewModeAlways;
    }
    return _passwordTF;
}

- (UITextField *)confirmPasswordTF {
    if (!_confirmPasswordTF) {
        _confirmPasswordTF = [UITextField textFieldWithfont:[UIFont systemFontOfSize:14] textColor:nil placeholder:@"请再次输入密码" BorderStyle:UITextBorderStyleNone];
        _confirmPasswordTF.secureTextEntry = YES;
        UILabel *confirmPasswordLabel = [[UILabel alloc] init];
        confirmPasswordLabel.text = @"确认密码：";
        [confirmPasswordLabel sizeToFit];
        _confirmPasswordTF.leftView = confirmPasswordLabel;
        _confirmPasswordTF.leftViewMode = UITextFieldViewModeAlways;
        _confirmPasswordTF.delegate = self;
        _confirmPasswordTF.returnKeyType = UIReturnKeyDone;
    }
    return _confirmPasswordTF;
}

- (UIButton *)bindingButton {
    if (!_bindingButton) {
        _bindingButton = [UIButton buttonWithType:UIButtonTypeCustom Title:@"信息补充" titleColor:[UIColor whiteColor] backgroundColor:BASE_COLOR backgroundImage:nil Font:[UIFont systemFontOfSize:17]];
        _bindingButton.layer.cornerRadius = 5.0f;
        WEAK_SELF(self);
        [_bindingButton bk_whenTapped:^{
            STRONG_SELF(self);
            [self bindingBAT];
            
        }];
    }
    return _bindingButton;
}

- (UIButton *)bindingOldPhoneButton {
    if (!_bindingOldPhoneButton) {
        _bindingOldPhoneButton = [UIButton buttonWithType:UIButtonTypeCustom Title:@"绑定已有账号" titleColor:BASE_COLOR  backgroundColor:[UIColor clearColor] backgroundImage:nil Font:[UIFont systemFontOfSize:14]];
        WEAK_SELF(self);
        [_bindingOldPhoneButton bk_whenTapped:^{
            STRONG_SELF(self);
            //绑定已有账号
            BATBindingOldPhoneViewController *bindingOldPhoneVC = [[BATBindingOldPhoneViewController alloc] init];
            
            bindingOldPhoneVC.accountToken = self.accountToken;
            bindingOldPhoneVC.unionID = self.unionID;
            bindingOldPhoneVC.type = self.type;
            
            [self.navigationController pushViewController:bindingOldPhoneVC animated:YES];
        }];
    }
    return _bindingOldPhoneButton;
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
