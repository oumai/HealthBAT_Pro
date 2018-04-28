//
//  BATGroupDetailHeaderView.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/31.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATGroupDetailHeaderView.h"

@implementation BATGroupDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _groupAccouncementView = [[UINib nibWithNibName:@"BATGroupAccouncementView" bundle:nil] instantiateWithOwner:self options:nil].firstObject;
        [self addSubview:_groupAccouncementView];
        
        _groupDecsView = [[UINib nibWithNibName:@"BATGroupDecsView" bundle:nil] instantiateWithOwner:self options:nil].firstObject;
        [self addSubview:_groupDecsView];

        _groupDynamicOperationView = [[UINib nibWithNibName:@"BATGroupDynamicOperationView" bundle:nil] instantiateWithOwner:self options:nil].firstObject;
        [self addSubview:_groupDynamicOperationView];
        
        [self setupConstraints];
        
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

- (void)setupConstraints
{
    WEAK_SELF(self);
    [_groupAccouncementView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(44);
    }];
    
    [_groupDecsView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self)
        make.left.right.equalTo(self);
        make.top.equalTo(_groupAccouncementView.mas_bottom);
        make.height.mas_offset(100);
    }];

    [_groupDynamicOperationView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.bottom.right.equalTo(self);
        make.top.equalTo(_groupDecsView.mas_bottom);
        make.height.mas_equalTo(44);
    }];
    
    [self layoutIfNeeded];
}

@end
