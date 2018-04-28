//
//  BATLeftAttendCell.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/3/17.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATHotTopicListModel.h"
#import "BATGraditorButton.h"
@interface BATLeftAttendCell : UITableViewCell

@property (strong, nonatomic) BATGraditorButton *titleLb;

@property (strong, nonatomic)  UIView *VerLineView;
@property (strong, nonatomic)  UIView *backView;
@property (nonatomic,strong) HotTopicListData *dataModel;

@end
