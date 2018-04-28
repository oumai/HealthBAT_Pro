//
//  UITableView+SeparatorInsetEdge.m
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/5/13.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "UITableView+SeparatorInsetEdge.h"
#import <objc/runtime.h>

@implementation UITableView (SeparatorInsetEdge)

- (UIEdgeInsets)bat_separatorInsetEdge
{
    return [objc_getAssociatedObject(self, @selector(bat_separatorInsetEdge)) UIEdgeInsetsValue];
}

- (void)setBat_separatorInsetEdge:(UIEdgeInsets)bat_separatorInsetEdge
{
    NSValue *value = [NSValue valueWithUIEdgeInsets:bat_separatorInsetEdge];
    objc_setAssociatedObject(self, @selector(bat_separatorInsetEdge), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    //    self.delegate = self;
    
    //适配iOS7+
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        [self  setSeparatorInset:bat_separatorInsetEdge];
    }
    
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        [self setLayoutMargins:bat_separatorInsetEdge];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:self.bat_separatorInsetEdge];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:self.bat_separatorInsetEdge];
    }
}
@end

@implementation UITableViewCell (SeparatorInsetEdge)

- (UIEdgeInsets)bat_cellSeparatorInsetEdge
{
    return [objc_getAssociatedObject(self, @selector(bat_cellSeparatorInsetEdge)) UIEdgeInsetsValue];
}

- (void)setBat_cellSeparatorInsetEdge:(UIEdgeInsets)bat_cellSeparatorInsetEdge
{
    NSValue *value = [NSValue valueWithUIEdgeInsets:bat_cellSeparatorInsetEdge];
    objc_setAssociatedObject(self, @selector(bat_cellSeparatorInsetEdge), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    //    self.delegate = self;
    
    //适配iOS7+
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        [self  setSeparatorInset:bat_cellSeparatorInsetEdge];
    }
    
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        [self setLayoutMargins:bat_cellSeparatorInsetEdge];
    }
}

@end
