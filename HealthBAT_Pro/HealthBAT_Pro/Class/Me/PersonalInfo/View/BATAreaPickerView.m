//
//  BATAreaPickerView.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/22.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATAreaPickerView.h"

@interface BATAreaPickerView () <UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,strong) NSMutableArray *provinceDataSource;

@property (nonatomic,strong) NSMutableArray *allCityDataSource;

@property (nonatomic,strong) NSMutableArray *currentCityDataSource;

@property (nonatomic,copy) NSString *selectProvince;

@property (nonatomic,copy) NSString *selectCity;

@end

@implementation BATAreaPickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _provinceDataSource = [NSMutableArray array];
        _allCityDataSource = [NSMutableArray array];
        _currentCityDataSource = [NSMutableArray array];
        
        [self getProvinceAndCity];
        
        self.backgroundColor = [UIColor whiteColor];
        
        _toolBar = [[UIToolbar alloc] init];
        [self addSubview:_toolBar];
        
        WEAK_SELF(self);
        UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"取消" style:UIBarButtonItemStylePlain handler:^(id sender) {
            STRONG_SELF(self);
            [self hide];
        }];
        
        UIBarButtonItem *fix = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem *confirmBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"确定" style:UIBarButtonItemStylePlain handler:^(id sender) {
            STRONG_SELF(self);
            [self hide];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(BATAreaPickerView:province:city:)]) {
                [self.delegate BATAreaPickerView:self province:_selectProvince city:_selectCity];
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
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return _provinceDataSource.count;
    }
    return _currentCityDataSource.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        if (_provinceDataSource.count > 0) {
            return _provinceDataSource[row][@"Name"];
        }
    }
    if (_currentCityDataSource.count > 0) {
        return _currentCityDataSource[row][@"Name"];
    }

    return @"";
}


#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        if (_provinceDataSource.count > 0) {
            _selectProvince = _provinceDataSource[row][@"Name"];
        }
        
        if (_allCityDataSource.count > 0) {
            _currentCityDataSource = _allCityDataSource[row];
            
            if (_currentCityDataSource.count > 0) {
                _selectCity = _currentCityDataSource[0][@"Name"];
            }
        }
        
        [pickerView reloadAllComponents];
        
    } else if (component == 1) {
        if (_currentCityDataSource.count > 0) {
            _selectCity = _currentCityDataSource[row][@"Name"];
        }
    }
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

- (void)getProvinceAndCity
{
    NSMutableArray *aryProvinceAndCity = LOCALARRAYVALUE;
    
    for (int n = 0; n < [aryProvinceAndCity count]; n++) {
        NSDictionary *dictProvince = aryProvinceAndCity[n];
        if ([[dictProvince objectForKey:@"ParentCode"] integerValue] == 0) {
            [_provinceDataSource addObject:dictProvince];
        }
    }
    
    for (int n = 0; n < [_provinceDataSource count]; n++) {
        NSDictionary *dict = _provinceDataSource[n];
        NSMutableArray *aryPointCity = [[NSMutableArray alloc] init];
        for (int m = 0; m < [aryProvinceAndCity count]; m++) {
            NSDictionary *dictAll = aryProvinceAndCity[m];
            if ([[dict objectForKey:@"Code"] isEqualToString:[dictAll objectForKey:@"ParentCode"]]) {
                [aryPointCity addObject:dictAll];
            }
        }
        [_allCityDataSource addObject:aryPointCity];
    }
    
    //获取第一个省份或者直辖市下的二级城市或区域
    if (_allCityDataSource.count > 0) {
        if (_allCityDataSource.count > 0) {
            _currentCityDataSource = _allCityDataSource[0];
        }
        
        if (_provinceDataSource.count > 0) {
            _selectProvince = _provinceDataSource[0][@"Name"];
        }
        
        if (_currentCityDataSource.count > 0) {
            _selectProvince = _provinceDataSource[0][@"Name"];
        }
        
        [_pickerView reloadAllComponents];
   }
}

#pragma mark Action
- (void)show
{
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, -CGRectGetHeight(self.frame));
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hide
{
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
}


@end
