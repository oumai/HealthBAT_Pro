//
//  BATLeftAttendCell.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/3/17.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATLeftAttendCell.h"

@implementation BATLeftAttendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.VerLineView.backgroundColor = BASE_COLOR;
    self.backgroundColor = UIColorFromHEX(0Xf0f0f0, 1);
    self.backView.hidden = YES;
    self.VerLineView.hidden = YES;
}

- (void)setDataModel:(HotTopicListData *)dataModel {

    _dataModel = dataModel;
    
    self.titleLb.text = [NSString stringWithFormat:@"#%@#",dataModel.Topic];
    
    if (dataModel.isSelect) {
        self.backView.hidden = NO;
        self.VerLineView.hidden = NO;
        self.titleLb.textColor = BASE_COLOR;
    }else {
        self.backView.hidden = YES;
        self.VerLineView.hidden = YES;
        self.titleLb.textColor = UIColorFromHEX(0X333333, 1);
    }
    
}

@end
