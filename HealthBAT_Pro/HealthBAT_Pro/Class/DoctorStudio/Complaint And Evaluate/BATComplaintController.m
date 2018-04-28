//
//  BATComplaintController.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/4/11.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATComplaintController.h"
#import "BATCustomButton.h"
#import "YYText.h"
#import "BATGraditorButton.h"
#import "BATDoctorStudioOrderListViewController.h"

typedef enum {
    EvaluateVeryNice = 0,             /// 满意
    EvaluateNice,              /// 十分满意
    EvaluateBad,               /// 不满意
} EvaluateMode;

@interface BATComplaintController ()<YYTextViewDelegate>

@property (nonatomic,strong) BATCustomButton *niceBtn;

@property (nonatomic,strong) BATCustomButton *veryNiceBtn;

@property (nonatomic,strong) BATCustomButton *badBtn;

@property (nonatomic,strong) YYTextView *textView;

@property (nonatomic,strong) BATGraditorButton *clikeBtn;

@property (nonatomic,strong) UIScrollView *backScro;

@property (nonatomic,strong) UIView *scroContentView;

@property (nonatomic,strong) NSString *dynamicContent;

@property (nonatomic,assign) BOOL isCommit;

@property (nonatomic,assign) NSInteger evaluate;

@end

@implementation BATComplaintController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.evaluate = 4;
//    self.isComplaint = YES;
    
    [self.view addSubview:self.backScro];
    [self.backScro mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(self.view);
        
    }];
    

    [self.backScro addSubview:self.scroContentView];
//    [self.scroContentView mas_makeConstraints:^(MASConstraintMaker *make) {
//       
////        make.edges.equalTo(self.backScro);
//        make.left.top.right.equalTo(self.scroContentView).offset(0);
//        make.height.mas_equalTo(SCREEN_HEIGHT + 100).priority(750);
//        make.width.mas_equalTo(SCREEN_WIDTH).priority(750);
//        
//    }];
    
    [self.scroContentView addSubview:self.niceBtn];
    [self.niceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(self.scroContentView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(80, 80));
        make.top.equalTo(self.scroContentView).offset(63);
        
    }];
    
    
    [self.scroContentView addSubview:self.veryNiceBtn];
    [self.veryNiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(self.niceBtn.mas_left).offset(-33);
        make.size.mas_equalTo(CGSizeMake(80, 80));
        make.centerY.equalTo(self.niceBtn.mas_centerY);
        
    }];
    
    [self.scroContentView addSubview:self.badBtn];
    [self.badBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.niceBtn.mas_right).offset(33);
        make.size.mas_equalTo(CGSizeMake(80, 80));
        make.centerY.equalTo(self.niceBtn.mas_centerY);
    }];
    
    [self.scroContentView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.scroContentView).offset(20);
        make.top.equalTo(self.niceBtn.mas_bottom).offset(30);
        make.right.equalTo(self.scroContentView.mas_right).offset(-20);
        make.height.mas_equalTo(133);
        
    }];
    
    [self.scroContentView addSubview:self.wordCountLabel];
    [self.wordCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.equalTo(self.textView.mas_bottom).offset(-10);
        make.right.equalTo(self.scroContentView.mas_right).offset(-30);
        
    }];
    
    [self.scroContentView addSubview:self.clikeBtn];
    [self.clikeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.left.equalTo(self.scroContentView).offset(20);
        make.right.equalTo(self.scroContentView.mas_right).offset(-20);
        make.height.mas_equalTo(45);
        make.top.equalTo(self.textView.mas_bottom).offset(50);
    }];
    
     self.title = @"评价";
    
    if (self.isComplaint) {
        self.veryNiceBtn.hidden = YES;
        self.badBtn.hidden = YES;
        
        [self.niceBtn setImage:[UIImage imageNamed:@"ic-bmy"] forState:UIControlStateNormal];
        [self.niceBtn setImage:[UIImage imageNamed:@"ic-bmy"] forState:UIControlStateSelected];
        [self.niceBtn setTitle:@"极不满意" forState:UIControlStateNormal];
        [self.niceBtn setTitleColor:BASE_COLOR forState:UIControlStateNormal];
        
        [self.clikeBtn setTitle:@"投诉" forState:UIControlStateNormal];
        self.title = @"投诉";
        self.textView.placeholderText = @"投诉";
    }
    
   
    
    
}

#pragma mark - YYTextViewDelegate
- (void)textViewDidChange:(YYTextView *)textView {

  
    
    if (textView.text.length>100) {
        textView.text = [textView.text substringToIndex:100];
    }
    
    _dynamicContent = textView.text;
    
    _wordCountLabel.text = [NSString stringWithFormat:@"%ld/100",(unsigned long)_dynamicContent.length];
    
}

#pragma mark - 提交评价或者投诉
- (void)commitRequest {

    
    
    if (self.isComplaint) {
     //   WEAK_SELF(self)
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"感谢您的咨询，继续投诉将结束咨询" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消投诉" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
           
        }];
        
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定投诉" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
           // STRONG_SELF(self);
            [self RequestAction];
        }];
        
        // Add the actions.
        [alertController addAction:otherAction];
        [alertController addAction:cancelAction];
        
        [self.navigationController presentViewController:alertController animated:YES completion:nil];

    }else {
     
        [self RequestAction];
    }
    
    
    
   
    
    

}

- (void)RequestAction {

    NSArray *arr = [_dynamicContent componentsSeparatedByString:@"\n"];
    if (arr.count > 0) {
        for (NSString *string in arr) {
            if (![string isEqualToString:@""]) {
                self.isCommit = YES;
            }
        }
    }else {
        self.isCommit = YES;
    }
    
    
    
    
    if (self.evaluate == 4) {
        self.evaluate = 1;
    }
    
    
    if (self.isComplaint) {
        self.evaluate = 3;
    }
    
    
    if (!self.isCommit) {
        if (self.isComplaint) {
            _dynamicContent = @"此次服务不满意，望重视.";
        }else {
            _dynamicContent = @"感谢医生的回复";
        }
        
        _isCommit = NO;
    }
    
    if (self.dynamicContent == nil && self.isComplaint == NO) {
        
        switch (self.evaluate) {
            case EvaluateBad:
                _dynamicContent = @"不满意";
                break;
            case EvaluateNice:
                 _dynamicContent = @"感谢医生的回复";
                break;
            case EvaluateVeryNice:
                 _dynamicContent = @"感谢医生的回复";
                break;
            default:
                break;
        }
        
    }
    
    if (self.dynamicContent == nil && self.isComplaint == YES) {
        _dynamicContent = @"此次服务不满意，望重视。";
    }
    
   
    [HTTPTool requestWithURLString:@"/api/OrderEvaluate/Evaluate" parameters:@{@"OrderMSTID":self.OrderMSTID,@"Evaluate":@(self.evaluate),@"Comment":_dynamicContent} type:kPOST success:^(id responseObject) {
        
        if (self.isComplaint) {
            [self showSuccessWithText:@"投诉成功！"];
            if (self.commitSuccessBlock) {
                self.commitSuccessBlock();
            }
        }
        else {
            [self showSuccessWithText:@"评价成功！"];
        }

        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FamilyDoctorEvaluationSuccess" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BATDoctorStudioOrderListRefresh" object:nil];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

            //跳转到订单列表
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[BATDoctorStudioOrderListViewController class]]) {
                    [self.navigationController popToViewController:vc animated:YES];
                    return ;
                }
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    } failure:^(NSError *error) {
        if (self.isComplaint) {
             [self showSuccessWithText:@"投诉失败！"];
        }else {
            [self showSuccessWithText:@"评价失败！"];

        }
    }];
    
}

#pragma mark -Action

- (void)btnClick:(UIButton *)btn {

    for (UIView *view in self.scroContentView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)view;
            btn.selected = NO;
        }
    }
    
    btn.selected = YES;
    
    switch (btn.tag) {
        case 0:
        {
            self.evaluate = EvaluateVeryNice;
            break;
        }
        case 1:
        {
            self.evaluate = EvaluateNice;
            break;
        }
        case 2:
        {
            self.evaluate = EvaluateBad;
            break;
        }
        default:
            break;
    }
    
}

#pragma mark - Lazy Load

- (BATCustomButton *)niceBtn {

    if (!_niceBtn) {
        _niceBtn = [[BATCustomButton alloc]init];
        
        [_niceBtn setImage:[UIImage imageNamed:@"ic-my_g"] forState:UIControlStateNormal];
        [_niceBtn setImage:[UIImage imageNamed:@"ic-my"] forState:UIControlStateSelected];
        
        [_niceBtn setTitle:@"满意" forState:UIControlStateNormal];
        
        [_niceBtn setTitleColor:BASE_COLOR forState:UIControlStateSelected];
        [_niceBtn setTitleColor:UIColorFromHEX(0X333333, 1) forState:UIControlStateNormal];
        
        _niceBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        
        _niceBtn.titleRect = CGRectMake(0, 60, 80, 15);
        _niceBtn.imageRect = CGRectMake(20, 10, 40, 40);
        _niceBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        
        _niceBtn.tag = 1;
        
        [_niceBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _niceBtn;
}

- (BATCustomButton *)veryNiceBtn {
    
    if (!_veryNiceBtn) {
        _veryNiceBtn = [[BATCustomButton alloc]init];
        
        [_veryNiceBtn setImage:[UIImage imageNamed:@"ic-fcmy_g"] forState:UIControlStateNormal];
        [_veryNiceBtn setImage:[UIImage imageNamed:@"ic-fcmy"] forState:UIControlStateSelected];
        
        [_veryNiceBtn setTitle:@"非常满意" forState:UIControlStateNormal];
        
        [_veryNiceBtn setTitleColor:BASE_COLOR forState:UIControlStateSelected];
        [_veryNiceBtn setTitleColor:UIColorFromHEX(0X333333, 1) forState:UIControlStateNormal];
        
        _veryNiceBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        
        _veryNiceBtn.titleRect = CGRectMake(0, 60, 80, 15);
        _veryNiceBtn.imageRect = CGRectMake(20, 10, 40, 40);
        _veryNiceBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        _veryNiceBtn.tag = 0;
        
        [_veryNiceBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return _veryNiceBtn;
}

- (BATCustomButton *)badBtn {
    
    if (!_badBtn) {
        _badBtn = [[BATCustomButton alloc]init];
        
        [_badBtn setImage:[UIImage imageNamed:@"ic-bmy_g"] forState:UIControlStateNormal];
        [_badBtn setImage:[UIImage imageNamed:@"ic-bmy"] forState:UIControlStateSelected];
        
        [_badBtn setTitle:@"不满意" forState:UIControlStateNormal];
        
        [_badBtn setTitleColor:BASE_COLOR forState:UIControlStateSelected];
        [_badBtn setTitleColor:UIColorFromHEX(0X333333, 1) forState:UIControlStateNormal];
        
        _badBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        
        _badBtn.titleRect = CGRectMake(0, 60, 80, 15);
        _badBtn.imageRect = CGRectMake(20, 10, 40, 40);
        _badBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _badBtn.tag = 2;
        
        [_badBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _badBtn;
}

- (YYTextView *)textView {

    if (!_textView) {
        _textView = [[YYTextView alloc]init];
        _textView.placeholderText = @"有想对医生说的话吗？点击输入";
        _textView.placeholderTextColor = UIColorFromHEX(0X999999, 1);
        _textView.font = [UIFont systemFontOfSize:15];
        _textView.layer.borderColor = UIColorFromHEX(0X999999, 1).CGColor;
        _textView.layer.borderWidth = 0.5;
        _textView.delegate = self;
        _textView.textContainerInset = UIEdgeInsetsMake(15, 10, 0, 0);
    }
    return _textView;
}

- (UILabel *)wordCountLabel {

    if (!_wordCountLabel) {
        _wordCountLabel = [[UILabel alloc]init];
        _wordCountLabel.textColor = UIColorFromHEX(0X999999, 1);
        _wordCountLabel.font = [UIFont systemFontOfSize:15];
        _wordCountLabel.text = @"0/100";
    }
    return _wordCountLabel;
}

- (BATGraditorButton *)clikeBtn {

    if (!_clikeBtn) {
        _clikeBtn = [[BATGraditorButton alloc]init];
        _clikeBtn.clipsToBounds = YES;
        _clikeBtn.layer.cornerRadius = 5;
//        _clikeBtn.backgroundColor = BASE_COLOR;
        _clikeBtn.enablehollowOut = YES;
        _clikeBtn.titleColor = [UIColor whiteColor];
        [_clikeBtn setGradientColors:@[START_COLOR,END_COLOR]];
        [_clikeBtn setTitle:@"发表评价" forState:UIControlStateNormal];
      //  [_clikeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _clikeBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_clikeBtn addTarget:self action:@selector(commitRequest) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clikeBtn;
}

- (UIScrollView *)backScro {

    if (!_backScro) {
        _backScro = [[UIScrollView alloc]init];
        _backScro.backgroundColor = [UIColor whiteColor];
        _backScro.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_backScro setContentSize:CGSizeMake(0, SCREEN_HEIGHT + 100)];
    }
    return _backScro;
}

- (UIView *)scroContentView {

    if (!_scroContentView) {
        _scroContentView = [[UIView alloc]init];
        _scroContentView.backgroundColor = [UIColor whiteColor];
        _scroContentView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT + 100);
    }
    return _scroContentView;
}

@end
