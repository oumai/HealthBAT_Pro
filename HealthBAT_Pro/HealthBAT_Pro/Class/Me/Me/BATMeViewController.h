//
//  MeViewController.h
//  HealthBAT_Pro
//
//  Created by KM on 16/7/62016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATMeView.h"
#import "UIViewController+BATIsFromRoundGuide.h"

@interface BATMeViewController : UIViewController <BATUserInfoViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) BATMeView *meView;

//@property (nonatomic,assign) BOOL isFromRoundGuide;

@end
