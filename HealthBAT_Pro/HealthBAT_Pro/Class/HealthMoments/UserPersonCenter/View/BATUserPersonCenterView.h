//
//  BATUserPersonCenterView.h
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/30.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATUserPersonCenterUserInfoView.h"

@interface BATUserPersonCenterView : UIView

/**
 *  列表
 */
@property (nonatomic,strong) UITableView *tableView;

/**
 *  个人信息
 */
@property (nonatomic,strong) BATUserPersonCenterUserInfoView *userInfoView;

@end
