//
//  BATTitlePickerView.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/3/15.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATTitlePickerView.h"

@interface BATTitlePickerView () <UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,strong) NSString *selectTitle;

@property (nonatomic,assign) NSInteger selectIndex;

@end

@implementation BATTitlePickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        self.backgroundColor = [UIColor whiteColor];
        
        _dataSource = [NSMutableArray arrayWithObjects:@"住院医师",@"主治医师",@"副主任医师",@"主任医师", nil];
        _selectTitle = @"住院医师";
        _selectIndex = 1;
        
        _toolBar = [[UIToolbar alloc] init];
        [self addSubview:_toolBar];
        
        WEAK_SELF(self);
        UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"取消" style:UIBarButtonItemStylePlain handler:^(id sender) {
            STRONG_SELF(self);
//            [self hide];
            if (self.cancelBlcok) {
                self.cancelBlcok();
            }
        }];
        
        UIBarButtonItem *fix = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem *confirmBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"确定" style:UIBarButtonItemStylePlain handler:^(id sender) {
            STRONG_SELF(self);
//            [self hide];
            if (self.cancelBlcok) {
                self.cancelBlcok();
            }
            if (self.delegate && [self.delegate respondsToSelector:@selector(BATTitlePickerView:didSelectRow:titleForRow:)]) {
                [self.delegate BATTitlePickerView:self didSelectRow:self.selectIndex titleForRow:self.selectTitle];
            }
        }];
        
        _toolBar.items = @[cancelBarButtonItem,fix,confirmBarButtonItem];
        
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        [self addSubview:_pickerView];
        
        [self setupConstraints];
        
    }
    return self;
}


#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _dataSource.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _dataSource[row];
}


#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _selectIndex = row + 1;
    _selectTitle = _dataSource[row];
}

#pragma mark private

- (void)setupConstraints
{
    WEAK_SELF(self);
    [_toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(44);
    }];
    
    [_pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(_toolBar.mas_bottom);
        make.left.right.bottom.equalTo(self);
    }];
}

#pragma mark Action
//- (void)show
//{
//    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        self.transform = CGAffineTransformMakeTranslation(0, -CGRectGetHeight(self.frame));
//    } completion:^(BOOL finished) {
//        
//    }];
//}
//
//- (void)hide
//{
//    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        self.transform = CGAffineTransformIdentity;
//    } completion:^(BOOL finished) {
//        
//    }];
//}

@end
