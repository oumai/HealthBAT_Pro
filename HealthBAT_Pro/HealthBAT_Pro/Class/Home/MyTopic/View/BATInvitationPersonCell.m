//
//  BATInvitationPersonCell.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/3/20.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATInvitationPersonCell.h"
@implementation BATInvitationPersonCell
- (IBAction)addAttendAction:(id)sender {
    
    if (self.attendblock) {
        self.attendblock();
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.headImage.clipsToBounds = YES;
    self.headImage.layer.cornerRadius = 25;
    
    self.nameLb.textColor = BASE_COLOR;
    self.nameLb.font = [UIFont systemFontOfSize:16];
    
    self.timeLb.font = [UIFont systemFontOfSize:15];
    self.timeLb.textColor = UIColorFromHEX(0X333333, 1);
    
    self.tipsLb.font = [UIFont systemFontOfSize:15];
    self.tipsLb.textColor = UIColorFromHEX(0Xfc9f26, 1);
    
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
