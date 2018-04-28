//
//  BATAddInTreamentCell.h
//  HealthBAT_Pro
//
//  Created by MichaeOu on 2017/6/12.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATAddInTreamentCell : UITableViewCell
@property (nonatomic, strong) NSIndexPath *path;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView  *lineView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIImageView *arrowImage;

@end
