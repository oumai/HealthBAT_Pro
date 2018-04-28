//
//  BATDiteGuideDetailsShopCell.h
//  HealthBAT_Pro
//
//  Created by Carbon on 2017/11/3.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATDiteGuideDetailModel.h"
static NSString * const BATDiteGuideDetailsShopCellIdentifier = @"BATDiteGuideDetailsShopCellIdentifier";

@protocol BATDiteGuideDetailsShopCellDelegate <NSObject>

@end

@interface BATDiteGuideDetailsShopCell : UITableViewCell
//@property (nonatomic ,weak) id<BATDiteGuideDetailsShopCellDelegate> delegate;
- (void)setDataDiteGuideDetailModel:(BATDiteGuideDetailModel *)diteGuideDetailModel;
@end
