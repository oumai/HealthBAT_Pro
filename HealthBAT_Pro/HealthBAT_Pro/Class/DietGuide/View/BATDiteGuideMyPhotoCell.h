//
//  BATDiteGuideMyPhotoCell.h
//  HealthBAT_Pro
//
//  Created by Carbon on 2017/10/30.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATDiteGuideMyPhotoModel.h"
static NSString * const BATDiteGuideMyPhotoCellIdentifier = @"BATDiteGuideMyPhotoCellIdentifier";

@interface BATDiteGuideMyPhotoCell : UITableViewCell
- (void)setMyPhotoDataModel:(BATDiteGuideMyPhotoDataModel *)myPhotoDataModel;
@end
