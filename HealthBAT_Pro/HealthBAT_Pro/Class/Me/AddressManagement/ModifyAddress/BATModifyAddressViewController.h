//
//  BATModifyAddressViewController.h
//  HealthBAT
//
//  Created by cjl on 16/3/16.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATModifyAddressView.h"
#import "BATAddressModel.h"

@interface BATModifyAddressViewController : UIViewController

@property (nonatomic,strong) BATModifyAddressView *modifyAddressView;

@property (nonatomic,strong) BATAddressData *addressData;

@property (nonatomic,assign) BOOL isModify;

@property (nonatomic,assign) BOOL isFromBuyOTC;

@end

