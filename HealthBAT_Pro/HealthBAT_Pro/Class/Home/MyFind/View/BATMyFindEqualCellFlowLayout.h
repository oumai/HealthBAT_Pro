//
//  BATMyFindEqualCellFlowLayout.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/3/23.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol  BATMyFindEqualCellFlowLayoutDelegate<UICollectionViewDelegateFlowLayout>
@end
@interface BATMyFindEqualCellFlowLayout : UICollectionViewFlowLayout
@property (nonatomic,weak) id<BATMyFindEqualCellFlowLayoutDelegate> delegate;
@end
