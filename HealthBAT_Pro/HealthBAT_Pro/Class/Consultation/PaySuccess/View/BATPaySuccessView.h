//
//  BATPaySuccessView.h
//  HealthBAT
//
//  Created by jlteams on 16/8/2.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATPaySuccessFooterView.h"
#import "BATPaySuccessHeaderView.h"

@protocol BATPaySuccessViewDelegate <NSObject>

/**
 *  呼叫按钮点击回调
 */
- (void)paySuccessViewCallBtnClickedAction;

@end

@interface BATPaySuccessView : UIView

/**
 *  tableview
 */
@property (nonatomic,strong) UITableView *tableView;

/**
 *  tableHeaderView
 */
@property (nonatomic,strong) BATPaySuccessHeaderView *paySuccessHeaderView;

/**
 *  tableFooterView
 */
@property (nonatomic,strong) BATPaySuccessFooterView *paySuccessFooterView;

/**
 *  委托
 */
@property (nonatomic,weak) id<BATPaySuccessViewDelegate> delegate;

@end
