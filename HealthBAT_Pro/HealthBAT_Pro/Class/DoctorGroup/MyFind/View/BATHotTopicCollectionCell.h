//
//  BATHotTopicCollectionCell.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/3/17.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATGraditorButton.h"
static NSString * const BATHotTopicCollectionCellIdentifier = @"BATHotTopicCollectionCellIdentifier";

@interface BATHotTopicCollectionCell : UICollectionViewCell

@property (nonatomic,strong) BATGraditorButton *keyLabel;

@end
