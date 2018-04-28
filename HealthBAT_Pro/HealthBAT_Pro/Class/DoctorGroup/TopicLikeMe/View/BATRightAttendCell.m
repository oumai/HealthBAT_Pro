//
//  BATRightAttendCell.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/3/17.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATRightAttendCell.h"
#import "BATPerson.h"
@implementation BATRightAttendCell
- (void)AttenAction {
    
    if ([self.delegate respondsToSelector:@selector(BATRightAttendActionWithRowPath:)]) {
        [self.delegate BATRightAttendActionWithRowPath:self.rowPath];
    }
}

- (void)pushAction {

    if ([self.delegate respondsToSelector:@selector(BATRightTableViewToPersonVCindexPath:)]) {
        [self.delegate BATRightTableViewToPersonVCindexPath:self.rowPath];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.headImage.clipsToBounds = YES;
    self.headImage.layer.borderWidth = 1;
    self.headImage.layer.cornerRadius = 25;
    self.headImage.layer.borderColor = [UIColor clearColor].CGColor;
    
    self.headImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushAction)];
    [self.headImage addGestureRecognizer:tap];
    
    self.nameLb.textColor = UIColorFromHEX(0X333333, 1);
    
    self.attendBtn = [[UIButton alloc]init];
    [self.attendBtn addTarget:self action:@selector(AttenAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.attendBtn];
    
    [self.attendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(self.mas_right).offset(-10);
        make.height.mas_equalTo(26);
        make.width.mas_equalTo(60);
        make.centerY.equalTo(self.headImage.mas_centerY);
        
    }];
    
    [self.attendBtn setBackgroundImage:[UIImage imageNamed:@"person_jgz"] forState:UIControlStateNormal];
    [self.attendBtn setBackgroundImage:[UIImage imageNamed:@"icon-ygz-gray"] forState:UIControlStateSelected];
    
}

- (void)setTopicUsermodel:(sameTopicUserData *)topicUsermodel {

    _topicUsermodel = topicUsermodel;
    
    self.nameLb.text = topicUsermodel.UserName;
    
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:_topicUsermodel.PhotoPath]];
    self.attendBtn.selected = topicUsermodel.IsUserFollow;
    
    BATPerson *person = PERSON_INFO;
    if (person.Data.AccountID == [topicUsermodel.AccountID integerValue]) {
        self.attendBtn.hidden = YES;
    }else {
        self.attendBtn.hidden = NO;
    }

}



@end
