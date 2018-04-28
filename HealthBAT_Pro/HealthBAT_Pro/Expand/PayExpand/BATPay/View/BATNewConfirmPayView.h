//
//  BATNewConfirmPayView.h
//  HealthBAT_Pro
//
//  Created by four on 2017/5/12.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BATNewPaybottomView.h"

@protocol BATNewConfirmPayViewDelegate <NSObject>

- (void)confirmPayBtnClickedAction;

@end

@interface BATNewConfirmPayView : UIView


/**
 *  tableView
 */
@property (nonatomic,strong) UITableView *tableView;

/**
 *  tableFooterView
 */
@property (nonatomic,strong) BATNewPaybottomView *tableFooterView;

/**
 *  委托
 */
@property (nonatomic,weak) id<BATNewConfirmPayViewDelegate> delegate;


@end
