//
//  BATHomeTodayOfferGoodView.h
//  HealthBAT_Pro
//
//  Created by KM on 17/5/92017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZTimerLabel.h"

@interface BATHomeTodayOfferGoodView : UIView

@property (nonatomic,strong) UIImageView *clockImageView;
@property (nonatomic,strong) MZTimerLabel *timeLabel;
@property (nonatomic,strong) UIImageView *leftImageView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *priceLabel;

@end
