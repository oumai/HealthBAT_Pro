//
//  BATEditInfoViewController.m
//  CancerNeighbour
//
//  Created by Wilson on 15/10/27.
//  Copyright © 2015年 KM. All rights reserved.
//

#import "BATEditInfoViewController.h"

@interface BATEditInfoViewController () <UITextFieldDelegate,UITextViewDelegate> {
    
    UITextField *txtSearchField;
}

@end

@implementation BATEditInfoViewController

- (void)dealloc
{
    DDLogWarn(@"%@",self);
    _editInfoView.textView.delegate = nil;
    _editInfoView.textField.delegate = nil;
}

- (void)loadView
{
    [super loadView];
    
    if (_editInfoView == nil) {
        _editInfoView = [[BATEditInfoView alloc] initWithFrame:CGRectZero withEditType:_type];
        _editInfoView.textView.delegate = self;
        _editInfoView.textField.delegate = self;
        [self.view addSubview:_editInfoView];
        
        WEAK_SELF(self)
        [_editInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.edges.equalTo(self.view);
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    WEAK_SELF(self);
    UIBarButtonItem *saveBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"icon_right_save"] style:UIBarButtonItemStyleDone handler:^(id sender) {
        STRONG_SELF(self);
        [self rightBtnAction];
    }];

    self.navigationItem.rightBarButtonItem = saveBarButtonItem;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    [_editInfoView.textField addTarget:self action:@selector(textFieldValueChanged) forControlEvents:UIControlEventAllEditingEvents];
    
    switch (_type) {
        case kEditUserName: {
            self.title = @"昵称";
            _editInfoView.textField.text = self.person.Data.UserName;
             [_editInfoView.textField becomeFirstResponder];
            break;
        }
        case kEditSignature: {
            self.title = @"个性签名";
            _editInfoView.textField.text = self.person.Data.Signature;
            [_editInfoView.textView becomeFirstResponder];
            break;
        }
        case kEditHeight: {
            self.title = @"身高";
            _editInfoView.textField.text = [NSString stringWithFormat:@"%ld",(long)self.person.Data.Height];
            break;
        }
        case kEditWeight: {
            self.title = @"体重";
            _editInfoView.textField.text = [NSString stringWithFormat:@"%ld",(long)self.person.Data.Weight];
            break;
        }
        case kEditPastHistory: {
            self.title = @"过往病史";
            _editInfoView.textView.text = self.person.Data.Anamnese;
            [_editInfoView.textView becomeFirstResponder];
            break;
        }
        case kEditAllergyHistory: {
            self.title = @"过敏史";
            _editInfoView.textView.text = self.person.Data.Allergies;
            [_editInfoView.textView becomeFirstResponder];
            break;
        }
        case kEditHereditaryDisease: {
            self.title = @"家族遗传病";
            _editInfoView.textView.text = self.person.Data.GeneticDisease;
            [_editInfoView.textView becomeFirstResponder];
            break;
        }
        default:
            break;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
   // [TalkingData trackPageBegin:@"修改个人信息"];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
   // [TalkingData trackPageEnd:@"修改个人信息"];
}

- (void)rightBtnAction {


    switch (_type) {
        case kEditUserName: {
            if (_editInfoView.textField.text.length < 1 || _editInfoView.textField.text.length > 8) {
                [self showErrorWithText:@"昵称长度为1-8个字符"];
                return;
            }
            _person.Data.UserName = _editInfoView.textField.text;
            break;
        }
        case kEditSignature: {
            if (_editInfoView.textField.text.length > 25) {
                [self showErrorWithText:@"签名长度最多25个字符"];
                return;
            }
            _person.Data.Signature = _editInfoView.textField.text;

            break;
        }
        case kEditHeight: {
            if ( [_editInfoView.textField.text floatValue] - 60 < 0 || [_editInfoView.textField.text floatValue] - 300 > 0 || _editInfoView.textField.text.length==0) {
                [self showErrorWithText:@"身高范围：60-300cm"];
                return;
            }
            _person.Data.Height = [_editInfoView.textField.text intValue];

            break;
        }
        case kEditWeight: {
            if ([_editInfoView.textField.text floatValue] - 20 < 0 || [_editInfoView.textField.text floatValue] - 250 > 0 || _editInfoView.textField.text.length==0) {
                [self showErrorWithText:@"体重范围：20-250kg"];
                return;
            }
            _person.Data.Weight = [_editInfoView.textField.text intValue];

            break;
        } case kEditPastHistory: {
            
            if (_editInfoView.textView.text.length > 50) {
                [self showErrorWithText:@"过往病史长度最多50个字符"];
                return;
            }
            
            _person.Data.Anamnese = _editInfoView.textView.text;
            break;
        }
        case kEditAllergyHistory: {
            
            if (_editInfoView.textView.text.length > 50) {
                [self showErrorWithText:@"过敏史长度最多50个字符"];
                return;
            }
            
            _person.Data.Allergies = _editInfoView.textView.text;
            break;
        }
        case kEditHereditaryDisease: {
            
            if (_editInfoView.textView.text.length > 50) {
                [self showErrorWithText:@"家族遗传病长度最多50个字符"];
                return;
            }
            
            _person.Data.GeneticDisease = _editInfoView.textView.text;
            break;
        }
        default:
            break;
    }

    if (self.editPersonInfoBlock) {
        self.editPersonInfoBlock(_person);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)textFieldValueChanged {
    switch (_type) {
        case kEditUserName: {
            if (![_editInfoView.textField.text isEqualToString:_person.Data.UserName]) {
                self.navigationItem.rightBarButtonItem.enabled = YES;
            }
            else {
                self.navigationItem.rightBarButtonItem.enabled = NO;
            }
            break;
        }
        case kEditSignature: {
            if (![_editInfoView.textField.text isEqualToString:_person.Data.Signature]) {
                self.navigationItem.rightBarButtonItem.enabled = YES;
            }
            else {
                self.navigationItem.rightBarButtonItem.enabled = NO;
            }
            break;
        }
        case kEditHeight: {
            if ([_editInfoView.textField.text intValue] != (int)_person.Data.Height) {
                self.navigationItem.rightBarButtonItem.enabled = YES;
            }
            else {
                self.navigationItem.rightBarButtonItem.enabled = NO;
            }
            break;
        }
        case kEditWeight: {
            if ([_editInfoView.textField.text intValue] != (int)_person.Data.Weight) {
                self.navigationItem.rightBarButtonItem.enabled = YES;
            }
            else {
                self.navigationItem.rightBarButtonItem.enabled = NO;
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    switch (_type) {
        case kEditPastHistory: {
            if (![_editInfoView.textView.text isEqualToString:_person.Data.Anamnese]) {
                self.navigationItem.rightBarButtonItem.enabled = YES;
            }
            else {
                self.navigationItem.rightBarButtonItem.enabled = NO;
            }
            break;
        }
        case kEditAllergyHistory: {
            if (![_editInfoView.textView.text isEqualToString:_person.Data.Allergies]) {
                self.navigationItem.rightBarButtonItem.enabled = YES;
            }
            else {
                self.navigationItem.rightBarButtonItem.enabled = NO;
            }
            break;
        }
        case kEditHereditaryDisease: {
            if (![_editInfoView.textView.text isEqualToString:_person.Data.GeneticDisease]) {
                self.navigationItem.rightBarButtonItem.enabled = YES;
            }
            else {
                self.navigationItem.rightBarButtonItem.enabled = NO;
            }
            break;
        }
        default:
            break;
    }
}

@end
