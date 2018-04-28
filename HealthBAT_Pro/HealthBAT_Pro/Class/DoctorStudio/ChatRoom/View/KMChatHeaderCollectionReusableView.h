//
//  KMChatHeaderCollectionReusableView.h
//  HealthBAT
//
//  Created by cjl on 16/8/5.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KMChatHeaderCollectionReusableView : UICollectionReusableView

/**
 *  内容view
 */
@property (weak, nonatomic) IBOutlet UIView *contentView;

/**
 *  标题
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

/**
 *  详情
 */
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

/**
 *  图片colleciontView
 */
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

/**
 *  布局layout
 */
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

- (void)reloadHeader:(NSDictionary *)ddm complete:(void (^)(void))complete;

@end
