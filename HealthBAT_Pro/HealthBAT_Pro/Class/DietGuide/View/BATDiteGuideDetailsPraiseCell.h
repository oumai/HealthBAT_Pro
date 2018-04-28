//
//  BATDiteGuideDetailsPraiseCell.h
//  HealthBAT_Pro
//
//  Created by Carbon on 2017/10/26.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATDiteGuideDetailModel.h"
static NSString * const BATDiteGuideDetailsPraiseCellIdentifier = @"BATDiteGuideDetailsPraiseCellIdentifier";

@class BATDiteGuideDetailsPraiseCell;
@protocol BATDiteGuideDetailsPraiseCellDelegate <NSObject>
- (void)diteGuideDetailsPraiseCell:(BATDiteGuideDetailsPraiseCell *)praiseCell diteGuideDetailModel:(BATDiteGuideDetailModel *)diteGuideDetailModel buttonStatus:(BOOL)buttonStatus;
@end

@interface BATDiteGuideDetailsPraiseCell : UITableViewCell
@property (nonatomic ,weak) id<BATDiteGuideDetailsPraiseCellDelegate> delegate;
- (void)setDataDiteGuideDetailModel:(BATDiteGuideDetailModel *)diteGuideDetailModel;
- (void)setDiteGuideDetailPraiseStarStatus:(BOOL)status;
@end
