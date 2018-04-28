//
//  BATHealthyInfoTableViewCell.m
//  HealthBAT_Pro
//
//  Created by 黄帆 on 2017/12/16.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHealthyInfoTableViewCell.h"
#import "BATHealthyInfoButton.h"
@interface BATHealthyInfoTableViewCell ()<UITextFieldDelegate>

@property (strong, nonatomic) BATHealthyInfoButton *maleBtn;
@property (strong, nonatomic) BATHealthyInfoButton *famleBtn;
@property (strong, nonatomic) UIView *buttonBGView;
@end;
@implementation BATHealthyInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    
    [self.contentView addSubview:self.buttonBGView];
    
    _contentTextF.keyboardType = UIKeyboardTypeNumberPad;
    
    _contentTextF.delegate = self;
    [_contentTextF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_buttonBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(90);
        make.top.bottom.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView).offset(-SCREEN_WIDTH * 0.2);
    }];
    
    
    if (self.status == SLstatus) {
        self.contentTextF.hidden = YES;
        self.buttonBGView.hidden = NO;
        
    } else {
        self.contentTextF.hidden = NO;
        self.buttonBGView.hidden = YES;
        
    }
    [_maleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(self.buttonBGView.mas_width).multipliedBy(0.48);
        make.width.mas_equalTo(50);
        make.left.top.bottom.mas_equalTo(self.buttonBGView);
    }];
    
    [_famleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(50);
        make.top.bottom.mas_equalTo(self.buttonBGView);
        make.left.mas_equalTo(_maleBtn.mas_right).offset(10);
    }];
    
    self.contentTextF.enabled = self.enableNow;
    //先要设置 两个按钮的选中状态
    if (self.sexStr) {
        if ([self.sexStr isEqualToString:@"1"]) {//1是男性 - _ -
            self.maleBtn.selected = YES;
            self.famleBtn.selected = NO;
            
            
        } else {
            
            self.maleBtn.selected = NO;
            self.famleBtn.selected = YES;
            
        }
    }
}
- (void)masoryOurView {
    
    
    
}

-  (UIView *)buttonBGView {
    
    if (!_buttonBGView) {
        
        _buttonBGView = [[UIView alloc] init];
//        _buttonBGView.backgroundColor = [UIColor yellowColor];
        _maleBtn = [BATHealthyInfoButton buttonWithType:UIButtonTypeCustom];
        _famleBtn = [BATHealthyInfoButton buttonWithType:UIButtonTypeCustom];
//        _maleBtn.backgroundColor = [UIColor redColor];
//        _famleBtn.backgroundColor = [UIColor redColor];
        
        [_maleBtn setImage:[UIImage imageNamed:@"Radio"] forState:UIControlStateSelected];
        [_maleBtn setImage:[UIImage imageNamed:@"Radior"] forState:UIControlStateNormal];
 
        [_famleBtn setImage:[UIImage imageNamed:@"Radio"] forState:UIControlStateSelected];
        [_famleBtn setImage:[UIImage imageNamed:@"Radior"] forState:UIControlStateNormal];
        
        [_maleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_famleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [_maleBtn setTitle:@"男" forState:UIControlStateNormal];
        [_famleBtn setTitle:@"女" forState:UIControlStateNormal];
        
        [_maleBtn addTarget:self action:@selector(maleBtnAciton:) forControlEvents:UIControlEventTouchUpInside];
        [_famleBtn addTarget:self action:@selector(famleBtnAciton:) forControlEvents:UIControlEventTouchUpInside];
        
        _maleBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
        _maleBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
        
        _famleBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
        _famleBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
        [_buttonBGView addSubview:self.maleBtn];
        [_buttonBGView addSubview:self.famleBtn];
        
    }
    return _buttonBGView;
    
}
#pragma mark - action
- (void)maleBtnAciton:(UIButton *)sender {
    
    self.maleBtn.selected = YES;
    self.famleBtn.selected = NO;
    self.sexStr = @"1";
    
}
- (void)famleBtnAciton:(UIButton *)sender {
    
    self.maleBtn.selected = NO;
    self.famleBtn.selected = YES;
    self.sexStr = @"0";
}
- (void)textFieldDidChange:(UITextField *)textF {
    
    NSString *textStr = textF.text;
    
   //这里是对浮点型 和保留2位小数的判断
//    NSString *temp =nil;
//    NSInteger num = 0;
//    NSInteger numStr = 0;
//
//    for(int i =0; i < [textStr length]; i++)
//    {
//        temp = [textStr substringWithRange:NSMakeRange(i,1)];
//        if ([temp isEqualToString:@"."]) {
//            ++ num;
//            numStr = i;
//            continue;
//        }
//        if (num == 1 && numStr + 2 == i) {
//            if (self.textFieldNotTrueBlock) {
//
//                NSString *str1 = [textStr substringToIndex:i];
//                textF.text = str1;
//                self.textFieldNotTrueBlock(@"只能保留小数点后一位");
//
//                break;
//                return;
//            }
//        }
//    }
    
    //后面的考虑
    if ([textStr integerValue] <= 0 && ![textStr isEqualToString:@""]) {
        
        
        if (self.textFieldNotTrueBlock) {
            self.textFieldNotTrueBlock(@"不能为0哦");
        }
        
        //然后值为空
        textF.text = @"";
        return;
    } else {
        
        if ([self.titleStr isEqualToString:@"身      高:"]) {
            //判读身高
            if ([textStr floatValue] > 300.0) {
                if (self.textFieldNotTrueBlock) {
                     textF.text = @"300";
                    self.textFieldNotTrueBlock(@"身高超过限制");
                }
            }
            //先提示
            
            
        } else if ([self.titleStr isEqualToString:@"体      重:"]) {
            //判断体重
            if ([textStr floatValue] > 150.0) {
                if (self.textFieldNotTrueBlock) {
                    textF.text = @"150";
                    self.textFieldNotTrueBlock(@"体重超过限制");
                }
            }
            
        } else if ([self.titleStr isEqualToString:@"出生日期:"]) {
            
            //比较日期大小
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"dd-MM-yyyy"];
            NSDate *date = [dateFormatter dateFromString:textF.text];
            NSInteger count = [self compareOneDay:[self getCurrentTime] withAnotherDay:date];
            //先提示
            
            if (count > 0) {
                if (self.textFieldNotTrueBlock) {
                    self.textFieldNotTrueBlock(@"超过日期期限");
                }
            }
            
        }
        
        
    }
    
}
#pragma mark -得到当前时间
- (NSDate *)getCurrentTime{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd-MM-yy"];
    NSString *dateTime=[formatter stringFromDate:[NSDate date]];
    NSDate *date = [formatter dateFromString:dateTime];
    
    NSLog(@"---------- currentDate == %@",date);
    return date;
}
/*
 3、最后进行比较，将现在的时间与指定时间比较，如果没达到指定日期，返回-1，刚好是这一时间，返回0，否则返回1*/
- (int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy-HHmmss"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    NSLog(@"date1 : %@, date2 : %@", oneDay, anotherDay);
    if (result == NSOrderedDescending) {
        //NSLog(@"Date1  is in the future");
        return 1;
    }
    else if (result == NSOrderedAscending){
        //NSLog(@"Date1 is in the past");
        return -1;
    }
    //NSLog(@"Both dates are the same");
    return 0;
    
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    BOOL isHaveDian;
//    if ([textField.text rangeOfString:@"."].location==NSNotFound) {
//        isHaveDian=NO;
//    }
//
//
//    if ([string length]>0)
//    {
//        unichar single=[string characterAtIndex:0];//当前输入的字符
//        if ((single >='0' && single<='9') || single=='.')//数据格式正确
//        {
//            //首字母不能为0和小数点
//            if([textField.text length]==0){
//                if(single == '.'){
//                    //[self alertView:@"亲，第一个数字不能为小数点"];
//                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
//                    return NO;
//                }
//                if (single == '0') {
//                    //[self alertView:@"亲，第一个数字不能为0"];
//                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
//                    return NO;
//                }
//            }
//            if (single=='.')
//            {
//                if(!isHaveDian)//text中还没有小数点
//                {
//                    isHaveDian=YES;
//                    return YES;
//                }else
//                {
//                    //[self alertView:@"亲，您已经输入过小数点了"];
//                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
//                    return NO;
//                }
//            }
//            else
//            {
//                if (isHaveDian)//存在小数点
//                {
//                    //判断小数点的位数
//                    NSRange ran=[textField.text rangeOfString:@"."];
//                    int tt=range.location-ran.location;
//                    if (tt <= 2){
//                        return YES;
//                    }else{
//                        //[self alertView:@"亲，您最多输入两位小数"];
//                        return NO;
//                    }
//                }
//                else
//                {
//                    return YES;
//                }
//            }
//        }else{//输入的数据格式不正确
////            [self alertView:@"亲，您输入的格式不正确"];
//            [textField.text stringByReplacingCharactersInRange:range withString:@""];
//            return NO;
//        }
//    }
//    else
//    {
//        return YES;
//    }
//}


@end
