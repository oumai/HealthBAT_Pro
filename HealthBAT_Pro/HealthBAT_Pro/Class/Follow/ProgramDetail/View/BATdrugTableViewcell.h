//
//  BATdrugTableViewcell.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/5/15.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^didseleBlock)(NSIndexPath *paht);
@interface BATdrugTableViewcell : UITableViewCell

@property (nonatomic,strong) UICollectionView *productCollectionView;

@property (nonatomic,strong) NSMutableArray *dataArry;

@property (nonatomic,strong) didseleBlock didselectBlock;

@end
