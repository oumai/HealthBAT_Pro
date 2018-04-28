//
//  BATCustomNormalTableViewCell.h
//  HealthBAT
//
//  Created by KM on 16/6/142016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATCustomNormalTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UISwitch *isDefaultSwitch;

@end
