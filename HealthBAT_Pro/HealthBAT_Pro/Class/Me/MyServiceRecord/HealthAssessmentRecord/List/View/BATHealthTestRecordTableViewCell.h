//
//  BATHealthTestRecordTableViewCell.h
//  HealthBAT
//
//  Created by KM on 16/6/162016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATHealthTestRecordModel.h"

@interface BATHealthTestRecordTableViewCell : UITableViewCell

/**
 *  测试项目
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

/**
 *  测试时间
 */
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


- (void)configureCellWith:(BATHealthTestRecordData *)record;

@end
