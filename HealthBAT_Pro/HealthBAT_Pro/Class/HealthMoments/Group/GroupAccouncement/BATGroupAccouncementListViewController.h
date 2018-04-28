//
//  BATGroupAccouncementListViewController.h
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/31.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATGroupAccouncementListView.h"

@interface BATGroupAccouncementListViewController : UIViewController

@property (nonatomic,strong) BATGroupAccouncementListView *groupAccouncementListView;

@property (nonatomic,assign) NSInteger groupID;

@end
