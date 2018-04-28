//
//  BATConfirmPayView.h
//  HealthBAT
//
//  Created by jlteams on 16/8/2.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATConfirmPayFooterView.h"

@protocol BATConfirmPayViewDelegate <NSObject>

- (void)confirmPayBtnClickedAction;

@end

@interface BATConfirmPayView : UIView

/**
 *  tableView
 */
@property (nonatomic,strong) UITableView *tableView;

/**
 *  tableFooterView
 */
@property (nonatomic,strong) BATConfirmPayFooterView *tableFooterView;

/**
 *  委托
 */
@property (nonatomic,weak) id<BATConfirmPayViewDelegate> delegate;

@end
