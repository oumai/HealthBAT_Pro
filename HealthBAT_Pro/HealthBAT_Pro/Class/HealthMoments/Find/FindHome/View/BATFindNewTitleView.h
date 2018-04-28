//
//  BATFindNewTitleView.h
//  HealthBAT_Pro
//
//  Created by cjl on 2016/12/7.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FindNewTitleClick) (NSInteger section);

@interface BATFindNewTitleView : UIView

/**
 *  标题
 */
@property (strong, nonatomic) UILabel *titleLabel;

/**
 *  更多
 */
@property (strong, nonatomic) UILabel *detailLabel;

/**
 *  accessory
 */
@property (strong, nonatomic) UIImageView *accessoryImageView;

/**
 索引
 */
@property (assign, nonatomic) NSInteger section;

/**
 点击block
 */
@property (strong, nonatomic) FindNewTitleClick findNewTitleClick;

/**
 点击按扭
 */
@property (strong, nonatomic) UIButton *button;


@end
