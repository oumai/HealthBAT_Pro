//
//  BATProgramPunchCardTableViewCell.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/6/13.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATProgramPunchCardTableViewCell : UITableViewCell

@property (nonatomic,strong) UILabel *countLabel;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UIImageView *arrowImageView;

@property (nonatomic,strong) UIView *usersView;

- (void)loadUsers:(NSArray *)array;

@end
