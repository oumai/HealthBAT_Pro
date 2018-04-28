//
//  BATSecondTableViewCell.h
//  HealthBAT_Pro
//
//  Created by Skybrim on 2017/3/25.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATSecondTableViewCell : UITableViewCell

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UISegmentedControl *segment;

@property (nonatomic,copy) void(^segmentClick)(NSInteger selectedIndex);

@end
