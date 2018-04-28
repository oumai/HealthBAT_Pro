//
//  BATMeView.h
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/22.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATUserInfoView.h"

@interface BATMeView : UIView

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) BATUserInfoView *userInfoView;

@end
