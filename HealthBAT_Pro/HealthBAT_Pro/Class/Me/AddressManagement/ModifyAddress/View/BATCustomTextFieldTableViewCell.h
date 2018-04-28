//
//  BATCustomNormalTableViewCell.h
//  HealthBAT
//
//  Created by cjl on 16/3/16.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATCustomTextFieldTableViewCell : UITableViewCell

@property (nonatomic,strong) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *NameLabel;

@end
