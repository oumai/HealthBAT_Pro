//
//  BATTrainStudioSelectView.h
//  HealthBAT_Pro
//
//  Created by Skybrim on 2017/4/5.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATMyFindEqualCellFlowLayout.h"

@interface BATTrainStudioSelectView : UIView<UICollectionViewDelegate,UICollectionViewDataSource,BATMyFindEqualCellFlowLayoutDelegate>

@property (nonatomic,strong) UICollectionView *selectCollectionView;
@property (nonatomic,copy) NSArray *dataArray;
@property (nonatomic,assign) NSInteger maxSelected;
@property (nonatomic,strong) NSMutableArray *selectedArray;

@property (nonatomic,strong) UIButton *confirmBtn;

@property (nonatomic,copy) void(^confirmBlock)(NSArray *selectedArray);

@end
