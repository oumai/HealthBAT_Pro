//
//  BATAddProgramSelectTimeViewController.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/3/1.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATAddProgramSelectTimeViewController.h"

@interface BATAddProgramSelectTimeViewController () <UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,strong) NSMutableArray *hours;

@property (nonatomic,strong) NSMutableArray *minutes;

@property (nonatomic,strong) NSString *hour;

@property (nonatomic,strong) NSString *minute;

@property (nonatomic,assign) NSInteger selectHourRow;

@property (nonatomic,assign) NSInteger selectMinuteRow;

@end

@implementation BATAddProgramSelectTimeViewController

- (void)loadView
{
    [super loadView];
    
    [self pageLayout];
    
//    WEAK_SELF(self);
//    UIBarButtonItem *confirmBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"确定" style:UIBarButtonItemStyleDone handler:^(id sender) {
//        STRONG_SELF(self);
//        
//        DDLogDebug(@"time %@:%@",self.hour,self.minute);
//        
////        NSString *hourString = self.hour >= 10 ? [NSString stringWithFormat:@"%ld",self.hour] : [NSString stringWithFormat:@"0%ld",self.hour];
////        NSString *minuteString = self.minute >= 10 ? [NSString stringWithFormat:@"%ld",self.minute] : [NSString stringWithFormat:@"0%ld",self.minute];
//        
//        if (self.saveTime) {
//            self.saveTime([NSString stringWithFormat:@"%@:%@",self.hour,self.minute]);
//        }
//        
//        [self.navigationController popViewControllerAnimated:YES];
//    }];
    
    UIButton *custemBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [custemBtn setTitle:@"确定" forState:UIControlStateNormal];
    [custemBtn setTitleColor:UIColorFromHEX(0X6ccc56, 1) forState:UIControlStateNormal];
    [custemBtn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:custemBtn];
    
    
    self.navigationItem.rightBarButtonItem = item;
    
 //   self.navigationItem.rightBarButtonItem = confirmBarButtonItem;
    
}

- (void)saveAction {

    if (self.saveTime) {
        self.saveTime([NSString stringWithFormat:@"%@:%@",self.hour,self.minute]);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"时间";
    
    _hours = [NSMutableArray array];
    _minutes = [NSMutableArray array];
    
    for (NSInteger i = 0; i < 24; i++) {
        if (i >= 10) {
            [_hours addObject:[NSString stringWithFormat:@"%ld",(long)i]];
        } else {
            [_hours addObject:[NSString stringWithFormat:@"0%ld",(long)i]];
        }
    }
    
    for (NSInteger i = 0; i < 60; i++) {
        if (i >= 10) {
            [_minutes addObject:[NSString stringWithFormat:@"%ld",(long)i]];
        } else {
            [_minutes addObject:[NSString stringWithFormat:@"0%ld",(long)i]];
        }
    }
    
    _hour = _hours[0];
    _minute = _minutes[0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return _hours.count;
    } else {
        return _minutes.count;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 50;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 100;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return _hours[row];
    }
    return _minutes[row];
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    
    CGFloat width = [self pickerView:pickerView widthForComponent:component];
    
    CGFloat height = [self pickerView:pickerView rowHeightForComponent:component];
    
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
    }
    
    NSString *selectString = [self pickerView:pickerView titleForRow:row forComponent:component];

    
//    if (component == 0) {
//        selectString = [selectString stringByAppendingString:@"时"];
//    } else {
//        selectString = [selectString stringByAppendingString:@"分"];
//    }
    
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:selectString];
    [string addAttributes:@{NSForegroundColorAttributeName:UIColorFromHEX(0x333333, 1),NSFontAttributeName:[UIFont systemFontOfSize:26]} range:NSMakeRange(0, string.length)];
    
//    [string addAttributes:@{NSForegroundColorAttributeName:UIColorFromHEX(0x333333, 1),NSFontAttributeName:[UIFont systemFontOfSize:10.5]} range:NSMakeRange(string.length - 1, 1)];
    
    pickerLabel.attributedText = string;

    return pickerLabel;
}

#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if (component == 0) {
        _hour = _hours[row];
        _minute = _minutes[0];
    } else {
        _minute = _minutes[row];
    }
    
}

- (void)pageLayout
{
    [self.view addSubview:self.selectTimeView];
    
    WEAK_SELF(self);
    [self.selectTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self.view);
    }];
}

- (BATAddProgramSelectTimeView *)selectTimeView
{
    if (_selectTimeView == nil) {
        _selectTimeView = [[BATAddProgramSelectTimeView alloc] init];
        _selectTimeView.pickerView.delegate = self;
        _selectTimeView.pickerView.dataSource = self;
    }
    return _selectTimeView;
}

@end
