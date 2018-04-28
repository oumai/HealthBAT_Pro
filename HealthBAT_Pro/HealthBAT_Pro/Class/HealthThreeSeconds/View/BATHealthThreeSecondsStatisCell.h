//
//  BATHealthThreeSecondsStatisCell.h
//  HealthBAT_Pro
//
//  Created by Carbon on 2017/12/12.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const BATHealthThreeSecondsStatisCellIdentifier = @"BATHealthThreeSecondsStatisCellIdentifier";

@interface BATHealthThreeSecondsStatisCell : UITableViewCell
- (void)setupDataWith:(NSDictionary *)dict indexPath:(NSIndexPath *)indexPath nameArray:(NSArray<NSString *> *)nameArray animate:(BOOL)animate;
+ (CGFloat)getHeight;
@end
