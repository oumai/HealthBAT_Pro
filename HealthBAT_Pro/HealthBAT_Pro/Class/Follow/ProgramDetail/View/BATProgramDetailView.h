//
//  BATProgramDetailView.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/2/28.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATProgramDetailHeaderView.h"

typedef void(^PunchCardBlock)(void);

@interface BATProgramDetailView : UIView

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) BATProgramDetailHeaderView *headerView;

@property (nonatomic,strong) UIButton *taskStateButton;

@property (nonatomic,strong) UIButton *punchCardButton;

@property (nonatomic,strong) PunchCardBlock punchCardBlock;

@end
