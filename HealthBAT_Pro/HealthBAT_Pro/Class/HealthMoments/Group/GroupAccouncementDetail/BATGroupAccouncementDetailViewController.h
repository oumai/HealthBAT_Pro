//
//  BATGroupAccouncementDetailViewController.h
//  HealthBAT_Pro
//
//  Created by cjl on 16/9/1.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATGroupAccouncementDetailView.h"
#import "BATGroupAccouncementListModel.h"

@interface BATGroupAccouncementDetailViewController : UIViewController

@property (nonatomic,strong) BATGroupAccouncementDetailView *groupAccouncementDetailView;

@property (nonatomic,strong) BATGroupAccouncementListData *groupAccouncementListData;

@end
