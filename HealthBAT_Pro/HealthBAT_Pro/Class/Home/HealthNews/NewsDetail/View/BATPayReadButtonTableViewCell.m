//
//  BATPayReadButtonTableViewCell.m
//  HealthBAT_Pro
//
//  Created by cjl on 2018/1/16.
//  Copyright © 2018年 KMHealthCloud. All rights reserved.
//

#import "BATPayReadButtonTableViewCell.h"

@implementation BATPayReadButtonTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = UIColorFromHEX(0xFAFAFA, 1);
        [self pageLayout];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Action
- (void)payReadBtnAction
{
    if (self.payReadBlock) {
        self.payReadBlock();
    }
}

#pragma mark - pageLayout
- (void)pageLayout
{
    [self.contentView addSubview:self.payReadBtn];
    
    WEAK_SELF(self);
    [self.payReadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
}


#pragma mark - get & set
- (BATGraditorButton *)payReadBtn
{
    if (_payReadBtn == nil) {
        _payReadBtn = [BATGraditorButton buttonWithType:UIButtonTypeCustom];
        
        [_payReadBtn setTitle:@"付费阅读" forState:UIControlStateNormal];
        _payReadBtn.layer.cornerRadius = 3.0f;
        _payReadBtn.layer.masksToBounds = YES;
        
        [_payReadBtn setGradientColors:@[START_COLOR,END_COLOR]];
        _payReadBtn.enablehollowOut = YES;
        _payReadBtn.titleColor  = [UIColor whiteColor];
        
        [_payReadBtn addTarget:self action:@selector(payReadBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _payReadBtn;
}

@end
