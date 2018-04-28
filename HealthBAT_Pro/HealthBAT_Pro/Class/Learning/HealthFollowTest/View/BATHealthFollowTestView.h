//
//  BATHealthFollowTestView.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/2/27.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATGraditorButton.h"
typedef void(^SubmitAction)(void);

@interface BATHealthFollowTestView : UIView

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UIView *tableFooterView;

@property (nonatomic,strong) BATGraditorButton *submitButton;

@property (nonatomic,strong) SubmitAction submitAction;

@end
