//
//  BATDiteGuideListCell.h
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/10/23.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BATDiteGuideListModel;
@interface BATDiteGuideListCell : UICollectionViewCell
/** 按钮点击 */
@property (nonatomic, copy) void (^likeButtonBlock)(UIButton *likeButton);
/** <#属性描述#> */
@property (nonatomic, strong) BATDiteGuideListModel *diteGuideListModel;
@end
