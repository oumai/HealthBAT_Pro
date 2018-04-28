//
//  BATBindingOldPhoneViewController.m
//  HealthBAT_Pro
//
//  Created by four on 16/10/12.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATBindingOldPhoneViewController.h"

#import "BATLoginModel.h"
#import "BATPerson.h"

@interface BATBindingOldPhoneViewController ()<UITextFieldDelegate>

@property (nonatomic,strong) UIImageView *topImageView;
@property (nonatomic,strong) UITextField *phoneTF;
@property (nonatomic,strong) UITextField *passwordTF;
@property (nonatomic,strong) UIButton *sureButton;

@end

@implementation BATBindingOldPhoneViewController

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
    
        
        [self.navigationController popViewControllerAnimated:YES];
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
-(void)bindingOldPhoneBAT {
    
    [self.view endEditing: YES];
    //判断输入框是否为空。(即无输入)
    if (self.phoneTF.text.length == 0) {
        [self showText:@"请输入手机号"];
        return;
    }
    
    //判断输入的手机号码是否符合规范
    if (![Tools checkPhoneNumber:self.phoneTF.text]) {
        [self showText:@"请输入正确的手机号"];
        return;
    }
    
    if ([self.passwordTF.text rangeOfString:@" "].location != NSNotFound) {
        [self showText:@"密码中不能包含空格"];
        return;
    }
    
    [self bindingOldPhoneRequest];
}


- (void)bindingOldPhoneRequest{
    
    NSDictionary *ParametDict = @{@"OtherType":self.type,
                                  @"OtherKey":self.unionID,
                                  @"OtherToken":self.accountToken,
                                  @"PhoneNumber":self.phoneTF.text,
                                  @"Password":self.passwordTF.text,
                                  @"VerificationCode":@"",
                                  @"RegisterType":@"2"
                                  };
    
    //绑定手机号
    [HTTPTool requestWithURLString:@"/api/Account/LoginWithNoBind" parameters:ParametDict type:kPOST success:^(id responseObject) {
        DDLogDebug(@"==========绑定已有账号成功==========");
        
        //改变登录状态
        SET_LOGIN_STATION(YES);
        
//        if([self.type isEqualToString:@"1"]){
//            [TalkingData trackEvent:@"100004" label:@"第三方微信登录"];
//        }
//        
//        if ([self.type isEqualToString:@"2"]) {
//            [TalkingData trackEvent:@"100003" label:@"第三方QQ登录"];
//        }
        

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
        
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        
        
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
    
    [self.view addSubview:self.passwordTF];
    [self.passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(SCREEN_WIDTH-45);
        make.top.equalTo(self.phoneTF.mas_bottom).offset(lineSpa);
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
    
    
    [self.view addSubview:self.sureButton];
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
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
        UILabel *phoneLabel = [[UILabel alloc] init];
        phoneLabel.text = @"手机号：";
        [phoneLabel sizeToFit];
        _phoneTF.leftView = phoneLabel;
        _phoneTF.leftViewMode = UITextFieldViewModeAlways;
    }
    return _phoneTF;
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
        _passwordTF.delegate = self;
        _passwordTF.returnKeyType = UIReturnKeyDone;
    }
    return _passwordTF;
}


- (UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom Title:@"确认" titleColor:[UIColor whiteColor] backgroundColor:BASE_COLOR backgroundImage:nil Font:[UIFont systemFontOfSize:17]];
        _sureButton.layer.cornerRadius = 5.0f;
        WEAK_SELF(self);
        [_sureButton bk_whenTapped:^{
            STRONG_SELF(self);
            [self bindingOldPhoneBAT];
            
        }];
    }
    return _sureButton;
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
