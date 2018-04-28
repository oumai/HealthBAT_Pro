//
//  BATAddressDetailViewController.h
//  HealthBAT
//
//  Created by cjl on 16/3/16.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATAddressDetailView.h"
#import "BATAddressModel.h"

@interface BATAddressDetailViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) BATAddressDetailView *addressDetailView;

@property (nonatomic,strong) BATAddressModel *addressModel;

@end
