//
//  BATHealthFollowView.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/2/21.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATHealthFollowSearchView.h"
#import "BATHealthFollowMenuView.h"

@interface BATHealthFollowView : UIView

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UIView *tableHeaderView;

@property (nonatomic,strong) BATHealthFollowSearchView *healthFollowSearchView;

@property (nonatomic,strong) BATHealthFollowMenuView *healthFollowMenuView;

@end
