//
//  BATGroupDetailHeaderView.h
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/31.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATGroupAccouncementView.h"
#import "BATGroupDecsView.h"
#import "BATGroupDynamicOperationView.h"

@interface BATGroupDetailHeaderView : UIView

@property (nonatomic,strong) BATGroupAccouncementView *groupAccouncementView;

@property (nonatomic,strong) BATGroupDecsView *groupDecsView;

@property (nonatomic,strong) BATGroupDynamicOperationView *groupDynamicOperationView;

@end
