//
//  BATAppDelegate+BATTableViewCategory.m
//  HealthBAT_Pro
//
//  Created by Skybrim on 2017/9/20.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATAppDelegate+BATTableViewCategory.h"
#import "Aspects.h"

@implementation BATAppDelegate (BATTableViewCategory)

- (void)cancelTableViewAdjust {
    
    [UITableView aspect_hookSelector:@selector(initWithFrame:style:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
        
        UITableView * tableView = aspectInfo.instance;
        
        if (tableView == nil) {
            return ;
        }
#ifdef __IPHONE_11_0
        if (@available(iOS 11.0, *)) {
            tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            if (tableView.estimatedRowHeight == UITableViewAutomaticDimension) {
                tableView.estimatedRowHeight = 0;
                tableView.estimatedSectionHeaderHeight = 0;
                tableView.estimatedSectionFooterHeight = 0;
            }
        }
#endif
    } error:nil];
}

@end
