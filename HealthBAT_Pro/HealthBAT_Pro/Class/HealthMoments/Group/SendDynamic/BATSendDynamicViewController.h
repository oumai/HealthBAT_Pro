//
//  BATSendDynamicViewController.h
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/31.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATSendDynamicView.h"

@interface BATSendDynamicViewController : UIViewController

@property (nonatomic,strong) BATSendDynamicView *sendDynamicView;

@property (nonatomic,assign) NSInteger groupID;

@property (nonatomic,assign) BOOL isBBS;

@property (nonatomic,strong) NSString *topicID;

@end
