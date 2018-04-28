//
//  BATAddressListViewController.h
//  HealthBAT
//
//  Created by cjl on 16/3/16.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATAddressListView.h"

@interface BATAddressListViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) BATAddressListView *addressListView;

@end
