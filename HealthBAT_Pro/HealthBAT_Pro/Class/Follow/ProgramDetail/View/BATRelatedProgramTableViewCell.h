//
//  BATRelatedProgramTableViewCell.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/6/13.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RelatedProgramBlock)(NSIndexPath *cellIndexPath);

@interface BATRelatedProgramTableViewCell : UITableViewCell

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) RelatedProgramBlock relatedProgramBlock;

- (void)loadData:(NSArray *)array;

@end
