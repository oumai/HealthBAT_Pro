//
//  BATGroupDetailViewController.h
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/30.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATGroupDetailView.h"
#import "BATGroupModel.h"

@interface BATGroupDetailViewController : UIViewController

@property (nonatomic,strong) BATGroupDetailView *groupDetailView;

@property (nonatomic,assign) NSInteger groupID;

@property (nonatomic,copy) NSString *groupName;

@end
