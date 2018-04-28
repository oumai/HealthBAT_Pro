//
//  BATFilterTypeView.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/4/1.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATFilterTypeView.h"
#import "BATGraditorButton.h"
@implementation BATFilterTypeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self pageLayout];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - Action
- (void)loadFilterItem:(NSArray *)data
{
    WEAK_SELF(self);
    [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        STRONG_SELF(self);
        
        long columnIndex = idx % 2;
        long rowIndex = idx / 2;
        
        NSString *title = obj;
        
        BATGraditorButton *button = [BATGraditorButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(15 + columnIndex * (75 + 31), 15 + rowIndex * (30 + 21) + 60, 75, 30)];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromHEX(0x999999, 1) forState:UIControlStateNormal];
//        [button setTitleColor:UIColorFromHEX(0x0182eb, 1) forState:UIControlStateSelected];
        [button setTitleColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Person_Detail_Head"]] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.layer.borderColor = UIColorFromHEX(0x999999, 1).CGColor;
        button.layer.borderWidth = (1.0 / [UIScreen mainScreen].scale);
        button.layer.cornerRadius = 6.0f;
        button.layer.masksToBounds = YES;
        button.tag = idx + 100;
        
        [self addSubview:button];
        
    }];
}

- (void)buttonAction:(BATGraditorButton *)button
{
    button.selected = !button.selected;
    UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Person_Detail_Head"]];
    button.layer.borderColor = button.selected ? color.CGColor : UIColorFromHEX(0x999999, 1).CGColor;
    
    if (self.filterClickBlock) {
        self.filterClickBlock(button.tag - 100,button.selected);
    }
    
}

#pragma mark - pageLayout
- (void)pageLayout
{
    [self addSubview:self.titleLabel];
    [self addSubview:self.line];
    
    WEAK_SELF(self);
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.mas_top).offset(29);
        make.right.equalTo(self.mas_right).offset(-15);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
        make.right.left.equalTo(self);
        make.height.mas_offset(1.0 / [UIScreen mainScreen].scale);
    }];
}

#pragma mark - get & set
- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = UIColorFromHEX(0x333333, 1);
    }
    return _titleLabel;
}

- (UILabel *)line
{
    if (_line == nil) {
        _line = [[UILabel alloc] init];
        _line.backgroundColor = BASE_LINECOLOR;
    }
    return _line;
}

@end
