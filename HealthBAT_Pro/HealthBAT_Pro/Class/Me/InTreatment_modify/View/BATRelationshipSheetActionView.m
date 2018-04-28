//
//  SheetActionView.m
//  YiFu
//
//  Created by Michael on 16/3/11.
//  Copyright © 2016年 jumper. All rights reserved.
//
#define KFontSize(font) [UIFont systemFontOfSize:font]
#define KHexColor(stringColor) [UIColor colorForHexString:stringColor]

#import "Masonry.h"
#import "BATRelationshipSheetActionView.h"
#import "UIColor+HNExtensions.h"
#import "UIImage+Tool.h"
@interface BATRelationshipSheetActionView ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic, strong) NSString  *chooseString;
@property (nonatomic, assign) BOOL     isPresented;             ///下滑弹框
@property (nonatomic, strong) UIView   *shangHuaView;
@property (nonatomic, strong) UIButton *sureButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIView   *tanLine;
@property (nonatomic, strong) UIView   *tanLine2;
@end
@implementation BATRelationshipSheetActionView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        
        
        self.frame = frame;
        self.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTouch)];
        [self addGestureRecognizer:tap];
      
        
        [self setDatasource];
        
        NSLog(@"integertype = %ld",(long)self.integertype);
    }
    return self;
}

- (void)setDatasource
{
    self.relateshipArray =  @[@"配偶",@"父亲",@"母亲",@"儿子",@"女儿",@"其他"];
    self.ageArrarray = [NSMutableArray array];
    for (int i=0; i<120; i++) {
        [self.ageArrarray addObject:[NSString stringWithFormat:@"%zd",i+1]];
    }
    
    self.sexArrarry = [NSMutableArray array];
    for (int i=0; i<2; i++) {
        switch (i) {
            case 0:
                [self.sexArrarry addObject:@"男"];
                break;
            case 1:
                [self.sexArrarry addObject:@"女"];
                break;
            default:
                break;
        }
    }

}

- (void)publicButtonClick:(UIButton *)button
{
    if (button.tag == 100)
    {
        [self animationedDismiss];

    }
    else if (button.tag == 101)
    {
        if (self.sheetViewBlock) {
            self.sheetViewBlock(button.tag,self.chooseString);
        }
    }
    
}
- (void)tapTouch
{
    [self animationedDismiss];
}


#pragma mark ------------------------------------------------------------------ConfigureUI-------------------------------------------------------------------
- (void)configureShangHuaView
{
    self.shangHuaView = [UIView new];
    self.shangHuaView.frame = CGRectMake(0, SCREEN_HEIGHT-64-220, SCREEN_WIDTH, 220);
    self.shangHuaView.backgroundColor = KHexColor(@"#ffffff");
    [self addSubview:_shangHuaView];

 
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 1)];
    lineView.backgroundColor = BASE_BACKGROUND_COLOR;
    [self.shangHuaView addSubview:lineView];

    
    self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 41, SCREEN_WIDTH, 180)];
    self.pickerView.showsSelectionIndicator=YES;
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    [self.pickerView selectRow:1 inComponent:0 animated:NO];
    [self.shangHuaView addSubview:self.pickerView];
    
    [self pickerView:self.pickerView didSelectRow:1 inComponent:0];
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelButton.tag = 100;
    self.cancelButton.titleLabel.font = KFontSize(17);
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    self.cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.cancelButton setTitleColor:END_COLOR forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(publicButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.shangHuaView addSubview:_cancelButton];
    
    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.shangHuaView.mas_top).offset(20);
        make.left.equalTo(self.shangHuaView.mas_left).offset(0);
        make.width.equalTo(@100);
        make.height.equalTo(@40);
    }];
    
    self.sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sureButton.titleLabel.font = KFontSize(17);
    self.sureButton.tag = 101;
    [self.sureButton setTitle:@"确定" forState:UIControlStateNormal];
    self.sureButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.sureButton setTitleColor:END_COLOR forState:UIControlStateNormal];
    [self.sureButton addTarget:self action:@selector(publicButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.shangHuaView addSubview:_sureButton];
    
    [_sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.shangHuaView.mas_top).offset(20);
        make.right.equalTo(self.shangHuaView.mas_right).offset(0);
        make.width.equalTo(@100);
        make.height.equalTo(@40);
    }];


}

#pragma mark -,UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    if (self.integertype == 2) {
        return self.sexArrarry.count;
    }
    else if (self.integertype == 3)
    {
        return self.ageArrarray.count;
    }
    else if (self.integertype == 5)
    {
        return self.relateshipArray.count;
    }
    else
    {
        return 0;
    }

}
#pragma mark -UIPickerViewDelegate
// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 180;
}

// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    
    if (self.integertype == 2) {
        self.chooseString = [self.sexArrarry objectAtIndex:row];
        
    }
    else if (self.integertype == 3)
    {
        self.chooseString = [self.ageArrarray objectAtIndex:row];
    }
    else if (self.integertype == 5)
    {
        self.chooseString = [self.relateshipArray objectAtIndex:row];
        
    }
    else
    {
        
    }

    NSLog(@"chooseString = %@",self.chooseString);
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSLog(@"self.integertype == %ld",(long)self.integertype);

    //return _relateshipArray[row];
    if (self.integertype == 2) {
        return self.sexArrarry[row];

    }
    else if (self.integertype == 3)
    {
        return self.ageArrarray[row];
    }
    else if (self.integertype == 5)
    {
        return self.relateshipArray[row];

    }
    else
    {
        return nil;
    }

}
#pragma mark -Animation
- (void)animationPresent:(NSInteger)type
{
    self.integertype = type;
    [self configureShangHuaView];

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    [UIView commitAnimations];
}
- (void)animationedDismiss
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    self.frame = CGRectMake(0, SCREEN_HEIGHT-64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    [self.shangHuaView removeFromSuperview];

    [UIView commitAnimations];
}
@end
