//
//  BATInvitationPersonCell.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/3/20.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATInvitationPersonCell.h"
@implementation BATInvitationPersonCell

- (void)addAttendAction {
    
    if (self.attendblock) {
        self.attendblock();
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.headImage.clipsToBounds = YES;
    self.headImage.layer.cornerRadius = 25;
    
    self.nameLb.textColor = [UIColor blackColor];
    self.nameLb.font = [UIFont systemFontOfSize:16];
    
    self.timeLb.font = [UIFont systemFontOfSize:15];
    self.timeLb.textColor = UIColorFromHEX(0X333333, 1);
    
//    self.tipsLb.font = [UIFont systemFontOfSize:15];
//    self.tipsLb.textColor = UIColorFromHEX(0Xfc9f26, 1);
    WEAK_SELF(self);
    [self addSubview:self.tipsLb];
    [self.tipsLb mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerY.equalTo(self.timeLb.mas_centerY);
        make.left.equalTo(self.timeLb.mas_right).offset(15);
        make.right.lessThanOrEqualTo(self.mas_right).offset(-10);
    }];
    
    [self addSubview:self.attendBtn];
    [self.attendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        STRONG_SELF(self);
        make.centerY.equalTo(self.nameLb.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-10);
        make.size.mas_equalTo(CGSizeMake(65, 26));
    }];
    
    [self addSubview:self.attendImage];
    [self.attendImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        STRONG_SELF(self);
        make.centerY.equalTo(self.nameLb.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-10);
        make.size.mas_equalTo(CGSizeMake(65, 26));
    }];

    
    
    self.lineView.backgroundColor = BASE_BACKGROUND_COLOR;

    
    self.headImage.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushToPersonDetail)];
    [self.headImage addGestureRecognizer:tap];
}

- (void)pushToPersonDetail {
  
    if (self.invitationBlock) {
        self.invitationBlock();
    }
}

/**
 *  格式化时间
 *
 *  @param dateString 时间
 *
 *  @return 格式后的时间
 */
- (NSString *)getTimeStringFromDateString:(NSString *)dateString
{
    NSString *timeString = @"";
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *startDate = [formatter dateFromString:dateString];
    NSTimeInterval sendInterval = [startDate timeIntervalSince1970];
    
    NSDate *nowDate = [NSDate date];
    NSString *strNow = [formatter stringFromDate:nowDate];
    NSDate *nowingDate = [formatter dateFromString:strNow];
    NSTimeInterval nowInterval = [nowingDate timeIntervalSince1970];
    
    NSTimeInterval minusInterval = nowInterval - sendInterval;
    
    if (minusInterval < 60) {
        timeString = @"刚刚...";
    }
    else if (minusInterval >= 60 && minusInterval < 3600) {
        timeString = [NSString stringWithFormat:@"%ld分钟前", (long)minusInterval / 60];
    }
    else if (minusInterval >= 3600 && minusInterval < 86400) {
        timeString = [NSString stringWithFormat:@"%ld小时前", (long)minusInterval / 3600];
    }
    else if (minusInterval >= 86400 ) {
        if ((long)minusInterval / 86400 == 1) {
            timeString = @"昨天";
        }else {
            dateString = [dateString substringToIndex:16];
            timeString = dateString;
        }
    }
    
    
    return timeString;
}

- (BATGraditorButton *)tipsLb {

    if (!_tipsLb) {
        _tipsLb = [[BATGraditorButton alloc]init];
        _tipsLb.enbleGraditor = YES;
        [_tipsLb setGradientColors:@[START_COLOR,END_COLOR]];
        _tipsLb.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _tipsLb;
}

- (BATGraditorButton *)attendBtn {

    if (!_attendBtn) {
        _attendBtn = [[BATGraditorButton alloc]init];
        _attendBtn.clipsToBounds = YES;
        _attendBtn.layer.cornerRadius = 5;
        [_attendBtn setTitle:@"+ 关注" forState:UIControlStateNormal];
        _attendBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_attendBtn setGradientColors:@[START_COLOR,END_COLOR]];
        [_attendBtn addTarget:self action:@selector(addAttendAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _attendBtn;
}

- (void)setIsFollow:(BOOL)isFollow {

    _isFollow = isFollow;
    if (isFollow) {
      
        _attendImage.hidden = NO;
        _attendBtn.hidden = YES;

    }else {
        _attendBtn.hidden = NO;
        _attendImage.hidden = YES;

    }
}

- (UIImageView *)attendImage {

    if (!_attendImage) {
        _attendImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon-ygz-gray"]];
        _attendImage.hidden = YES;
        _attendImage.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addAttendAction)];
        [_attendImage addGestureRecognizer:tap];
    }
    return _attendImage;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
