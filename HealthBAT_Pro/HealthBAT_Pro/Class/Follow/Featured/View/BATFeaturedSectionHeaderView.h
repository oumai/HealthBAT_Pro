//
//  BATAlbumCellHeadView.h
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/6/8.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BATFeaturedSectionHeaderView : UICollectionReusableView
/** <#属性描述#> */
@property (nonatomic, strong) UIView *topSeparatorView;
/** UILabel */
@property (nonatomic, strong) UILabel *leftTitleLabel;
/** UIButton */
@property (nonatomic, strong) UIButton *rightButton;
/** 底部分割线 */
@property (nonatomic, strong) UIView *separatorView;
/** 按钮点击调用 */
@property (nonatomic, copy) void(^rightButtonBlock)(void);

@end
