//
//  NewsTableViewCell.h
//  HealthBAT_Pro
//
//  Created by KM on 16/7/212016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATHomeDetailNewsTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView *newsImageView;
@property (nonatomic,strong) UILabel     *newsTitleLabel;
@property (nonatomic,strong) UILabel     *contentLabel;
@property (nonatomic,strong) UILabel     *sourceLabel;
@property (nonatomic,strong) UILabel     *readTimeLabel;

@end
