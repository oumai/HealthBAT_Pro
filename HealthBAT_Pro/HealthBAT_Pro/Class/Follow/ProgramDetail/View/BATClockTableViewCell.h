//
//  BATClockTableViewCell.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/2/28.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SwitchAction)(void);

@interface BATClockTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView *clockImageView;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UISwitch *switchOn;

@property (nonatomic,strong) UIImageView *switchImageView;

@property (nonatomic,strong) SwitchAction switchAction;

@end
