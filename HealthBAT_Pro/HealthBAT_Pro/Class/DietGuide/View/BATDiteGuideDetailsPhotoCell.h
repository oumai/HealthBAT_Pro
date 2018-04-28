//
//  BATDiteGuideDetailsPhotoCell.h
//  HealthBAT_Pro
//
//  Created by Carbon on 2017/10/25.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATDiteGuideDetailModel.h"
static NSString * const BATDiteGuideDetailsPhotoCellIdentifier = @"BATDiteGuideDetailsPhotoCellIdentifier";

@interface BATDiteGuideDetailsPhotoCell : UITableViewCell
- (void)setDataDiteGuideDetailModel:(BATDiteGuideDetailModel *)diteGuideDetailModel;
@end
