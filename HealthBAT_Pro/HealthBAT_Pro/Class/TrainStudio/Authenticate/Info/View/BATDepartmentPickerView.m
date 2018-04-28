//
//  BATDepartmentPickerView.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/4/5.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDepartmentPickerView.h"

@interface BATDepartmentPickerView () <UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,strong) NSDictionary *department;

@property (nonatomic,assign) NSInteger selectIndex;

@end

@implementation BATDepartmentPickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        self.backgroundColor = [UIColor whiteColor];
        
        _dataSource = [NSMutableArray arrayWithObjects:
                       @{@"ID":@"08c73f8a6a67459f863c2e1a0e88b9b9",@"departmentName":@"骨科"},
                       @{@"ID":@"0d61948ccbf24e3b8ba593616191b01b",@"departmentName":@"全科"},
                       @{@"ID":@"0e358462583d458c97e946018ed5309b",@"departmentName":@"肿瘤科"},
                       @{@"ID":@"1a58e70f6609441fa93fb4245e355c30",@"departmentName":@"耳鼻喉科"},
                       @{@"ID":@"1b5a0c624de6436aba63d6fc7b3cd3d4",@"departmentName":@"中医科"},
                       @{@"ID":@"22b0e8dabcb34f5e834372ef4117a82b",@"departmentName":@"内科"},
                       @{@"ID":@"39811e4455f94913bfe7a67aa3c87997",@"departmentName":@"男科"},
                       @{@"ID":@"637cde81b9e240b6835ddf5e0b2db1b1",@"departmentName":@"妇产科"},
                       @{@"ID":@"a762aece63924f408c5c0077e3737ba1",@"departmentName":@"性病科"},
                       @{@"ID":@"ae3d60c0994e466daae27739fd699a28",@"departmentName":@"眼科"},
                       @{@"ID":@"bccf002800ac47fbba754fe3a2869909",@"departmentName":@"皮肤科"},
                       @{@"ID":@"cfd89efd12c6414aa7c71a01beddfd8c",@"departmentName":@"肛肠科"},
                       @{@"ID":@"d58ed9a4f1914c5f81874acac52a1975",@"departmentName":@"口腔科"},
                       @{@"ID":@"e22abfb6b71048009c7de694769505ee",@"departmentName":@"外科"},
                       @{@"ID":@"e9f004d341594e76a5ce1ead5a6a91f0",@"departmentName":@"儿科"},nil];
        _department = _dataSource[0];
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
            if (self.delegate && [self.delegate respondsToSelector:@selector(BATDepartmentPickerView:didSelectRow:departmentForRow:)]) {
                [self.delegate BATDepartmentPickerView:self didSelectRow:self.selectIndex departmentForRow:self.department];
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
    NSDictionary *dic = _dataSource[row];
    return dic[@"departmentName"];
}


#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _selectIndex = row + 1;
    _department = _dataSource[row];
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


@end
