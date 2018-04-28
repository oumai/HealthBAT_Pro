//
//  BATAddTreatmentController.m
//  TableViewTest
//
//  Created by kmcompany on 16/9/22.
//  Copyright © 2016年 sword. All rights reserved.
//

#import "BATAddTreatmentController.h"
#import "BATChooseTreatmentPersonController.h"
#import "BATChooseEntiyModel.h"
@interface BATAddTreatmentController ()<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property(nonatomic,strong)UIView *lastView;
@property(nonatomic,strong)NSMutableArray *backViewArr;
@property(nonatomic,strong)UIDatePicker *pickerView;
@property(nonatomic,strong)NSArray *pickerNameArr;
@property(nonatomic,strong)MyResData *model;
@property(nonatomic,strong)NSMutableArray *contentArr;

@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *phoneNumber;
@property(nonatomic,strong)NSString *idNumber;
@property(nonatomic,strong)NSString *relationString;

@property(nonatomic,strong)UIButton *clickBtn;

@property (nonatomic,strong) NSString *beginTime;
@end

@implementation BATAddTreatmentController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutPages];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [BATUserPortrayTools saveOperateModuleRequestWithURL:@"/kmStatistical-sync/saveOperateModule" pathName:@"个人中心-就诊人管理-添加就诊人" moduleId:4 beginTime:self.beginTime];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

-(void)popAction:(UIButton *)btnSender {
    for (UIView *objects in self.backViewArr) {
        for (id object in objects.subviews) {
            if ([object isKindOfClass:[UITextField class]]) {
                UITextField *textfiled = (UITextField *)object;
                switch (textfiled.tag) {
                    case 0:
                        if ([textfiled.text isEqualToString:@""]||textfiled.text == nil) {
                            [self showText:@"请输入姓名"];
                            return;
                        }else {
                            _name = [textfiled.text mutableCopy];
                        }
                        break;
                    case 1:
                        if ([textfiled.text isEqualToString:@""]||textfiled.text == nil) {
                            [self showText:@"请输入手机号码"];
                            return;
                        }else {
                            BOOL isPhoneNum = [Tools checkPhoneNumber:textfiled.text];
                            if (!isPhoneNum) {
                                [self showText:@"请输入正确的手机号码"];
                                return;
                            }else {
                                _phoneNumber = [textfiled.text mutableCopy];
                            }
                        }
                        break;
                    case 2:
                        if ([textfiled.text isEqualToString:@""]||textfiled.text == nil) {
                            [self showText:@"请输入身份证号"];
                            return;
                        }else {

                            _idNumber = [textfiled.text mutableCopy];

//                            BOOL isID = [Tools checkIdentityCardNo:textfiled.text];
//                            if (!isID) {
//                                [self showText:@"请输入正确的证件号码"];
//                                return;
//                            }else {
//                                _idNumber = [textfiled.text mutableCopy];
//                            }
                        }
                        break;
                    case 3:
                        if ([textfiled.text isEqualToString:@""]||textfiled.text == nil) {
                            [self showText:@"请输入关系信息"];
                            return;
                        }else {
//                            关系（0-自己、1-配偶、2-父亲、3-母亲、4-儿子、5女儿、6-其他）
                            NSInteger relationString = 0;
                            if ([textfiled.text isEqualToString:@"自己"]) {
                                relationString = 0;
                            }else if([textfiled.text  isEqualToString:@"配偶"]) {
                                relationString = 1;
                            }else if([textfiled.text  isEqualToString:@"父亲"]) {
                                relationString = 2;
                            }else if([textfiled.text  isEqualToString:@"母亲"]) {
                                relationString = 3;
                            }else if([textfiled.text  isEqualToString:@"儿子"]) {
                                relationString = 4;
                            }else if([textfiled.text  isEqualToString:@"女儿"]) {
                                relationString = 5;
                            }else if([textfiled.text  isEqualToString:@"其他"]) {
                                relationString = 6;
                            }
                            _relationString = [[NSString stringWithFormat:@"%zd",relationString] mutableCopy];
                        }
                        break;
                }
            }
        }
    }
    
        [self AddTreatmentRequest];
    

}



- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

//返回每列里边的行数（必须实现）
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.pickerNameArr.count;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.pickerNameArr[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    for (UIView *objects in self.backViewArr) {
        for (id object in objects.subviews) {
            if ([object isKindOfClass:[UITextField class]]) {
                UITextField *textfiled = (UITextField *)object;
                if (textfiled.tag==3) {
                    textfiled.text = self.pickerNameArr[row];
                }
            }
        }
    }

}

#pragma mark -layoutPages
-(void)layoutPages {
    self.beginTime = [Tools getCurrentDateStringByFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.view.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
    if (!self.editModel) {
        self.title = @"添加就诊人";
    }else {
        self.title = @"修改就诊人信息";
    }
    NSArray *nameArr = @[@"姓        名",@"手机号码",@"身份证号",@"关        系"];
    NSArray *textfiledName = @[@"请输入姓名",@"请输入手机号码",@"请输入证件号码",@"请选择身份关系"];
    
    WEAK_SELF(self)
    for (int i = 0; i<4; i++) {
        UIView *backView = [[UIView alloc]init];
        
        
        [self.view addSubview:backView];
        backView.backgroundColor = [UIColor whiteColor];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self)
            make.height.mas_equalTo(45);
            CGFloat TopPins = 10 + i*(46);
            
            make.top.equalTo(self.view).offset(TopPins);
            
            CGFloat width = SCREEN_WIDTH;
            
            make.width.mas_equalTo(width);
            
            if (i==0) {
                make.left.equalTo(self.view).offset(0);
            }else {
                make.left.equalTo(self.lastView.mas_left);
            }
            
        }];
        
        UILabel *titleLb = [[UILabel alloc]init];
        titleLb.textColor = UIColorFromHEX(0X333333, 1);
        titleLb.font = [UIFont systemFontOfSize:14];
        titleLb.text = nameArr[i];
        [backView addSubview:titleLb];
        [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backView).offset(15);
            make.centerY.equalTo(backView.mas_centerY);
        }];
        
        UITextField *textFiled = [[UITextField alloc]init];
        textFiled.delegate = self;
        textFiled.tag = i;
        textFiled.font = [UIFont systemFontOfSize:14];
        
        if (i==1) {
            textFiled.keyboardType = UIKeyboardTypePhonePad;
        }
        
        if (self.editModel) {
            switch (i) {
                case 0: {
                    textFiled.text = self.editModel.name;
                    break;
                }
                case 1:{
                    textFiled.text = self.editModel.phoneNumber;
                    break;
                }
                case 2:{
                    textFiled.text = self.editModel.personID;
                    break;
                }
                case 3:{
                    textFiled.text = self.editModel.relateship;
                    break;
                }
            }
        }
        
        [backView addSubview:textFiled];
        
        NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc]initWithString:textfiledName[i]];
        [placeholder addAttribute:NSForegroundColorAttributeName
                            value:UIColorFromHEX(0X999999, 1)
                            range:NSMakeRange(0, [textfiledName[i] length])];
        [placeholder addAttribute:NSFontAttributeName
                            value:[UIFont systemFontOfSize:14]
                            range:NSMakeRange(0, [textfiledName[i] length])];
        textFiled.attributedPlaceholder = placeholder;
        
        [textFiled mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLb.mas_right).offset(25);
            make.right.equalTo(backView.mas_right).offset(-10);
            make.top.equalTo(backView.mas_top).offset(14.5);
        }];
        
        self.lastView = backView;
        [self.backViewArr addObject:backView];
        
        if (i==3) {
            _clickBtn = [UIButton new];
            _clickBtn.clipsToBounds = YES;
            _clickBtn.layer.borderColor = BASE_COLOR.CGColor;
            _clickBtn.layer.borderWidth = 1;
            _clickBtn.layer.cornerRadius = 5;
            _clickBtn.backgroundColor = BASE_COLOR;
            [_clickBtn setTitle:@"保存" forState:UIControlStateNormal];
            [_clickBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            [_clickBtn addTarget:self action:@selector(popAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.view addSubview:_clickBtn];
            [_clickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.view.mas_left).offset(10);
                make.right.equalTo(self.view.mas_right).offset(-10);
                make.top.equalTo(self.lastView.mas_bottom).offset(40);
                make.height.equalTo(@40);
            }];
            
            textFiled.delegate = self;
            [textFiled setInputView:self.pickerView];
            
        }
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField.tag == 3) {
        textField.text = @"本人";
    }
}

#pragma mark -NET
-(void)AddTreatmentRequest {
    
    [self showProgressWithText:@"正在提交"];
    _clickBtn.enabled = NO;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:self.name forKey:@"MemberName"];
    [dict setValue:self.idNumber forKey:@"IDNumber"];
    [dict setValue:self.phoneNumber forKey:@"Mobile"];
    [dict setValue:self.relationString forKey:@"Relation"];
    
    [dict setValue:@"" forKey:@"Address"];
    [dict setValue:@"" forKey:@"Email"];
    [dict setValue:@"" forKey:@"PostCode"];
    
    if (self.editModel) {
        
        [dict setValue:self.editModel.userID forKey:@"UserID"];
        [dict setValue:self.editModel.memberID forKey:@"MemberID"];

    [HTTPTool requestWithURLString:@"/api/NetworkMedical/UpdateUserMember" parameters:dict type:kPOST success:^(id responseObject) {
        [self showText:@"修改成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
              [self.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(NSError *error) {
        [self showErrorWithText:error.localizedDescription];

        _clickBtn.enabled = YES;
    }];
        
    }else {
        
    [HTTPTool requestWithURLString:@"/api/NetworkMedical/InsertUserMember" parameters:dict type:kPOST success:^(id responseObject) {
        [self showText:@"添加成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [self.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(NSError *error) {
        [self showErrorWithText:error.localizedDescription];

        _clickBtn.enabled = YES;
    }];
    }
}

#pragma mark -SETTER - GETTER
- (UIPickerView *)pickerView
{
    //初始化一个PickerView
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(50, 300, 300, 200)];
    pickerView.tag = 1000;
    //指定Picker的代理
    pickerView.dataSource = self;
    pickerView.delegate = self;
    pickerView.backgroundColor = [UIColor clearColor];
    //是否要显示选中的指示器(默认值是NO)
    pickerView.showsSelectionIndicator = YES;
    
    return pickerView;
}

-(NSMutableArray *)backViewArr {
    if (!_backViewArr) {
        _backViewArr = [NSMutableArray array];
    }
    return _backViewArr;
}

-(NSArray *)pickerNameArr {
    if (!_pickerNameArr) {
        _pickerNameArr = @[@"本人",@"配偶",@"父亲",@"母亲",@"儿子",@"女儿",@"其他"];
    }
    return _pickerNameArr;
}

-(NSMutableArray *)contentArr {
    if(!_contentArr){
        _contentArr = [NSMutableArray array];
    }
    return _contentArr;
}

@end
