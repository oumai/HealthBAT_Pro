//
//  BATTopCircleCollectionViewCell.h
//  HealthBAT_Pro
//
//  Created by KM on 16/9/192016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"

@interface BATHomeTopCircleTableViewCell : UITableViewCell<SDCycleScrollViewDelegate>

@property (nonatomic,strong) SDCycleScrollView *circlePictureView;
@property (nonatomic,copy) void(^TopPicClick)(NSInteger index);

@end
