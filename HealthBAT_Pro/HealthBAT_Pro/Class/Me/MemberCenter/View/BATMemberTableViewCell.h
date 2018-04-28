//
//  BATMemberTableViewCell.h
//  HealthBAT_Pro
//
//  Created by cjl on 2018/1/17.
//  Copyright © 2018年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATMemberTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *avatorImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
