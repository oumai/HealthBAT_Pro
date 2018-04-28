//
//  BATEditInfoView.m
//  HealthBAT
//
//  Created by cjl on 16/8/1.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATEditInfoView.h"
#import "Masonry.h"

@interface BATEditInfoView ()

@property (nonatomic,assign) EditType type;

@end

@implementation BATEditInfoView

- (instancetype)initWithFrame:(CGRect)frame withEditType:(EditType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor clearColor];
        [self addSubview:_scrollView];
        
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor clearColor];
        [_scrollView addSubview:_containerView];
        
        _imageBgView = [[UIImageView alloc] init];
        _imageBgView.backgroundColor = [UIColor whiteColor];
        _imageBgView.userInteractionEnabled = YES;
        [_containerView addSubview:_imageBgView];
        
        _type = type;
        
        if (_type <= 4) {
            _textField = [[UITextField alloc] init];
            _textField.backgroundColor = [UIColor clearColor];
            _textField.textAlignment = NSTextAlignmentCenter;
            _textField.font = [UIFont systemFontOfSize:15.0];
            _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            _textField.textColor = [UIColor blackColor];
            [_imageBgView addSubview:_textField];
        } else {
            _textView = [[UITextView alloc] init];
            _textView.backgroundColor = [UIColor clearColor];
            _textView.font = [UIFont systemFontOfSize:15.0];
            _textView.textColor = [UIColor blackColor];
            [_imageBgView addSubview:_textView];
        }
        
        switch (_type) {
            case kEditUserName: {
                _textField.keyboardType = UIKeyboardTypeDefault;
                
                break;
            }
            case kEditSignature: {
                _textField.keyboardType = UIKeyboardTypeDefault;
                
                break;
            }
            case kEditHeight: {
                _textField.keyboardType = UIKeyboardTypeNumberPad;
                
                break;
            }
            case kEditWeight: {
                _textField.keyboardType = UIKeyboardTypeNumberPad;
                
                break;
            }
            default:
                break;
        }
        
        [self setupConstraints];
    }
    return self;
}

- (void)setupConstraints
{
    WEAK_SELF(self);
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self);
    }];
    
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self);
    }];
    
    [_imageBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_containerView.mas_top).offset(20);
        make.left.right.equalTo(_containerView);
        
        if (_type <= 4) {
            make.height.mas_equalTo(40);
        } else {
            make.height.mas_equalTo(100);
        }
    }];
    
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_imageBgView).with.insets(UIEdgeInsetsMake(0, 10, 0, 10));
    }];
    
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_imageBgView).with.insets(UIEdgeInsetsMake(0, 10, 0, 10));
    }];
}

@end
