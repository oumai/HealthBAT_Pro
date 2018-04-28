//
//  BATHealthCircleImageCollectionView.h
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/24.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class BATHealthCircleImageCollectionView;
//@protocol BATHealthCircleImageCollectionViewDelegate <NSObject>
//
//- (void)healthCircleImageCollectionView:(BATHealthCircleImageCollectionView *)healthCircleImageCollectionView imageClicked:(NSInteger)index;
//
//@end

@interface BATHealthCircleImageCollectionView : UIView

///**
// *  列表
// */
//@property (nonatomic,strong) UICollectionView *collectionView;
//
///**
// *  layout
// */
//@property (nonatomic,strong) UICollectionViewFlowLayout *flowLayout;
//
//@property (nonatomic,strong) id<BATHealthCircleImageCollectionViewDelegate> delegate;

/**
 *  加载数据
 *
 *  @param imageArray 图片数据
 */
- (void)loadImageData:(NSArray *)imageArray;

@end
