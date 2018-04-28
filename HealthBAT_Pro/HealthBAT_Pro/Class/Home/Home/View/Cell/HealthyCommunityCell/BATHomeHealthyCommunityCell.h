//
//  BATHomeHealthyCommunityCell.h
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/11/2.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BATHomeHealthyCommunityCommonView;

@interface BATHomeHealthyCommunityCell : UITableViewCell

/**
 和我一样
 */
@property (nonatomic, copy) void (^sameMeItemBlcok)(void);

/**
 发现
 */
@property (nonatomic, copy) void (^findItemBlock)(void);

/**
 饮食指南
 */
@property (nonatomic, copy) void (^gietGuildeItemBlock)(void);

@end
