//
//  BATPayReadButtonTableViewCell.h
//  HealthBAT_Pro
//
//  Created by cjl on 2018/1/16.
//  Copyright © 2018年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATGraditorButton.h"

typedef void(^PayReadBlock)(void);

@interface BATPayReadButtonTableViewCell : UITableViewCell

@property (strong, nonatomic) BATGraditorButton *payReadBtn;

@property (nonatomic, strong) PayReadBlock payReadBlock;

@end
