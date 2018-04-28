//
//  GroupTableViewCell.h
//  HealthBAT_Pro
//
//  Created by KM on 16/7/212016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATGroupTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView *groupImageView;
@property (nonatomic,strong) UILabel     *groupNameLabel;
@property (nonatomic,strong) UILabel     *memberLabel;
@property (nonatomic,strong) UILabel     *descriptionLabel;

@end
