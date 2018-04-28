//
//  BATTotalTableViewCell.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/12/13.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATTotalTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalItemLabel;

- (void)totalPrice:(NSString *)string;

@end
