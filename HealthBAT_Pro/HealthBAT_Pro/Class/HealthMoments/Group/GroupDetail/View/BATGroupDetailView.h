//
//  BATGroupDetailView.h
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/30.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATGroupDetailHeaderView.h"

@interface BATGroupDetailView : UIView

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) BATGroupDetailHeaderView *headerView;

@end
