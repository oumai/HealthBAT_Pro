//
//  BATTableViewPlaceHolderDelegate.h
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/6/22.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol BATTableViewPlaceHolderDelegate <NSObject>

@required

/***UICollectionView和 UITableView 都可以按照下面的方法操作*****/

/**
 在当前控制器中#import "BATTableViewPlaceHolder.h"
 遵守 BATTableViewPlaceHolderDelegate 协议
 实现 - (UIView *)makePlaceHolderView 在该方法中返回要显示的占位view
 当需要刷新表格时，请使用 [self.tableView bat_reloadData],此方法中已经调用了系统原有的 reloadData,所以无需调用系统的，避免重复刷新
 
 */

- (UIView *)makePlaceHolderView;

@optional
/*!
 默认为 NO 
 当需要下拉占位视图刷新的时候可以实现此方法返回 YES 
 在该方法中调用网络请求方法
 
 */
- (BOOL)enableScrollWhenPlaceHolderViewShowing;

@end
