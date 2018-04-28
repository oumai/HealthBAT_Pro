//
//  PublicNoticeCollectionViewCell.h
//  HealthBAT
//
//  Created by KM on 16/8/182016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"

@interface BATHomePublicNoticeTableViewCell : UITableViewCell<SDCycleScrollViewDelegate>

@property (nonatomic,strong) UIImageView *iconImageView;
@property (nonatomic,strong) UIView *line;
@property (nonatomic,strong) UILabel *dotLabel;
@property (nonatomic,strong) SDCycleScrollView *publicNotice;
@property (nonatomic,strong) NSMutableArray *dataArray;

- (void)sendDataArray:(NSArray *)data;

@end
