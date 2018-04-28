//
//  BATLeftAttendCell.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/3/17.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATHotTopicListModel.h"
@interface BATLeftAttendCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UIView *VerLineView;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (nonatomic,strong) HotTopicListData *dataModel;

@end
