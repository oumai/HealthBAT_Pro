//
//  UITableView+SeparatorInsetEdge.h
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/5/13.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

//用法

/************
 
 _tableView.bat_separatorInsetEdge = UIEdgeInsetsMake(0, 0, 0, 0);
 
 或
 
 *  - (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 [cell setCell_cellSeparatorInsetEdge:UIEdgeInsetsMake(0, 0, 0, 0)];
 
 }
 
 ***********/

@interface UITableView (SeparatorInsetEdge)
/**
 *  table分割线内边距
 */
@property (nonatomic, assign) UIEdgeInsets bat_separatorInsetEdge;
@end

@interface UITableViewCell (SeparatorInsetEdge)

@property (nonatomic, assign) UIEdgeInsets bat_cellSeparatorInsetEdge;

@end
