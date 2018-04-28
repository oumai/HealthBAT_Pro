//
//  BATTopicPersonHeaderView.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/3/17.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATTopicPersonHeaderView.h"

@implementation BATTopicPersonHeaderView
- (void)attendaction {
    if (self.attendAction) {
        self.attendAction();
    }
}

- (void)awakeFromNib {

    [super awakeFromNib];
    
    self.headImage.clipsToBounds = YES;
    self.headImage.layer.borderWidth = 2;
    self.headImage.layer.borderColor = [UIColor whiteColor].CGColor;
    self.headImage.layer.cornerRadius = 25;
    
    self.nameLb.font = [UIFont boldSystemFontOfSize:16];
    self.nameLb.textColor = UIColorFromHEX(0Xffffff, 1);
    
    self.AttendBtn = [[UIButton alloc]init];
    [self.AttendBtn addTarget:self action:@selector(attendaction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.AttendBtn];
    [self.AttendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(self.mas_right).offset(-10);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(26);
        make.centerY.equalTo(self.headImage.mas_centerY);
        
    }];
    
    
    [self.AttendBtn setBackgroundImage:[UIImage imageNamed:@"icon-jgzb"] forState:UIControlStateNormal];
    [self.AttendBtn setBackgroundImage:[UIImage imageNamed:@"icon-ygzb"] forState:UIControlStateSelected];
}

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        self.headImage.clipsToBounds = YES;
        self.headImage.layer.borderWidth = 2;
        self.headImage.layer.borderColor = [UIColor whiteColor].CGColor;
        self.headImage.layer.cornerRadius = 25;
        
        self.nameLb.font = [UIFont boldSystemFontOfSize:16];
        self.nameLb.textColor = UIColorFromHEX(0Xffffff, 1);
        

        
    }
    return self;
}

@end
