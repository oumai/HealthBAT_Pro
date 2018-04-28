//
//  UICollectionView+BATCollectionViewPlaceHolder.h
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/6/22.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionView (BATCollectionViewPlaceHolder)
/**
 刷新方法 -  》内部已经调用了系统的 reloadData
 */
- (void)bat_reloadData;
@end
