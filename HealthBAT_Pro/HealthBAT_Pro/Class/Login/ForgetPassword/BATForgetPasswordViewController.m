//
//  BATForgetPasswordViewController.m
//  HealthBAT_Pro
//
//  Created by KM on 16/8/242016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATForgetPasswordViewController.h"

#import "BATGraditorButton.h"

@interface BATForgetPasswordViewController ()<UITextFieldDelegate>

@property (nonatomic,strong) UIImageView *topImageView;
@property (nonatomic,strong) UITextField *phoneTF;
@property (nonatomic,strong) UITextField *codeTF;
@property (nonatomic,strong) UIButton *countdownButton;
@property (nonatomic,strong) UITextField *passwordTF;
//@property (nonatomic,strong) UITextField *confirmPasswordTF;
@property (nonatomic,strong) BATGraditorButton *confirmButton;
@property (nonatomic,strong) UIImageView *showPwd;
@property (nonatomic,assign) BOOL isShowPwd;
@end

@implementation BATForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    _isShowPwd = NO;
    
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
-(void)checkValue {

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
    if (self.passwordTF.text.length == 0) {
        [self showText:@"请输入密码"];
        return;
    }

    if(self.passwordTF.text.length > 18){
        [self showText:@"密码过长，请重新输入"];
        return;
    }
    if(self.passwordTF.text.length < 6){
        [self showText:@"密码过短，请重新输入"];
        return;
    }

    //判断输入的手机号码是否符合规范
    if (![Tools checkPhoneNumber:self.phoneTF.text]) {
        [self showText:@"请输入正确的手机号"];
        return;
    }

//    //判断两次输入的密码是否一致(同时为空已处理)
//    if (![self.confirmPasswordTF.text isEqualToString:self.passwordTF.text]) {
//        [self showText:@"两次密码不一致，请重新输入"];
//        return;
//    }
    
    if ([self.passwordTF.text rangeOfString:@" "].location != NSNotFound) {
        [self showText:@"密码中不能包含空格"];
        return;
    }
    
    [self forgetPasswordRequest];
}

#pragma mark - net
- (void)codeRequest {

    //判断输入的手机号码是否符合规范
    if (![Tools checkPhoneNumber:self.phoneTF.text]) {
        [self showText:@"请输入正确的手机号码"];
        return;
    }

    [self showProgress];

    [HTTPTool requestWithURLString:[NSString stringWithFormat:@"/api/Account/SendVerifyCode/%@/2",self.phoneTF.text] parameters:nil type:kGET success:^(id responseObject) {

        [self dismissProgress];
        
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

        [self showErrorWithText:error.localizedDescription];
    }];
}

- (void)forgetPasswordRequest {

//    NSDictionary *para = @{@"VerifyCode":self.codeTF.text,@"NewPassword":self.passwordTF.text,@"ConfirmPassword":self.confirmPasswordTF.text,@"PhoneNumber":self.phoneTF.text};
    
    NSDictionary *para = @{@"VerifyCode":self.codeTF.text,@"NewPassword":self.passwordTF.text,@"PhoneNumber":self.phoneTF.text};
    //
    ///api/Account/ChangePassword
    [HTTPTool requestWithURLString:@"/api/account/forgetchangepassword" parameters:para type:kPOST success:^(id responseObject) {
        [self showText:@"修改成功"];
        [self dismissViewControllerAnimated:YES completion:nil];
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
        
        make.left.equalTo(self.view.mas_left).offset(25);
        make.width.mas_equalTo(SCREEN_WIDTH - 45 - 40);
        make.top.equalTo(self.codeTF.mas_bottom).offset(lineSpa);
        make.height.mas_equalTo(height);
    }];
    
    [self.view addSubview:self.showPwd];
    [self.showPwd mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerY.equalTo(self.passwordTF.mas_centerY);
        make.width.mas_equalTo(25);
        make.right.equalTo(self.view.mas_right).offset(-25);
        make.height.mas_equalTo(15);
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
    
//    [self.view addSubview:self.confirmPasswordTF];
//    [self.confirmPasswordTF mas_makeConstraints:^(MASConstraintMaker *make) {
//        STRONG_SELF(self);
//        
//        make.centerX.equalTo(self.view.mas_centerX);
//        make.width.mas_equalTo(SCREEN_WIDTH-45);
//        make.top.equalTo(self.passwordTF.mas_bottom).offset(lineSpa);
//        make.height.mas_equalTo(height);
//    }];
    
//    //确认密码下划线
//    UIView *surePasswordTFLine = [[UIView alloc]init];
//    surePasswordTFLine.backgroundColor = [UIColor lightGrayColor];
//    [self.view addSubview:surePasswordTFLine];
//    [surePasswordTFLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        STRONG_SELF(self);
//        
//        make.top.equalTo(self.confirmPasswordTF.mas_bottom).offset(1);
//        make.centerX.equalTo(self.view.mas_centerX);
//        make.height.mas_equalTo(0.5);
//        make.width.mas_equalTo(SCREEN_WIDTH-50);
//    }];
    
    [self.view addSubview:self.confirmButton];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(SCREEN_WIDTH-45);
        make.top.equalTo(self.passwordTF.mas_bottom).offset(3*lineSpa);
        make.height.mas_equalTo(height);
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
    }
    return _phoneTF;
}

- (UITextField *)codeTF {
    if (!_codeTF) {
        _codeTF = [UITextField textFieldWithfont:[UIFont systemFontOfSize:14] textColor:nil placeholder:@"请输入验证码" BorderStyle:UITextBorderStyleNone];
        _codeTF.keyboardType = UIKeyboardTypeNumberPad;
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

- (UITextField *)passwordTF {
    if (!_passwordTF) {
        _passwordTF = [UITextField textFieldWithfont:[UIFont systemFontOfSize:14] textColor:nil placeholder:@"请输入6-18位密码" BorderStyle:UITextBorderStyleNone];
        _passwordTF.secureTextEntry = YES;
    }
    return _passwordTF;
}

//- (UITextField *)confirmPasswordTF {
//    if (!_confirmPasswordTF) {
//        _confirmPasswordTF = [UITextField textFieldWithfont:[UIFont systemFontOfSize:14] textColor:nil placeholder:@"请再次输入密码" BorderStyle:UITextBorderStyleNone];
//        _confirmPasswordTF.secureTextEntry = YES;
//        _confirmPasswordTF.leftViewMode = UITextFieldViewModeAlways;
//        _confirmPasswordTF.delegate = self;
//        _confirmPasswordTF.returnKeyType = UIReturnKeyDone;
//    }
//    return _confirmPasswordTF;
//}

- (BATGraditorButton *)confirmButton {
    if (!_confirmButton) {
//        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom Title:@"确认修改" titleColor:[UIColor whiteColor] backgroundColor:BASE_COLOR backgroundImage:nil Font:[UIFont systemFontOfSize:17]];
//        _confirmButton.layer.cornerRadius = 5.0f;
        _confirmButton = [BATGraditorButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton setTitle:@"确认" forState:UIControlStateNormal];
        _confirmButton.layer.cornerRadius = 3.0f;
        _confirmButton.layer.masksToBounds = YES;
        
        [_confirmButton setGradientColors:@[START_COLOR,END_COLOR]];
        _confirmButton.enablehollowOut = YES;
        _confirmButton.titleColor  = [UIColor whiteColor];
        WEAK_SELF(self);
        [_confirmButton bk_whenTapped:^{
            STRONG_SELF(self);
            [self checkValue];
        }];
    }
    return _confirmButton;
}

- (UIImageView *)showPwd{

    if(!_showPwd){
        _showPwd = [[UIImageView alloc]init];
        _showPwd.image = [UIImage imageNamed:@"ic-xs"];
        _showPwd.userInteractionEnabled = YES;
        [_showPwd bk_whenTapped:^{
            if (_isShowPwd == NO) {
                self.passwordTF.secureTextEntry = NO;
                _isShowPwd = YES;
            }else{
                self.passwordTF.secureTextEntry = YES;
                _isShowPwd = NO;
            }
        }];
    }

    return _showPwd;
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
