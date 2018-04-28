//
//  BATMemberCenterItemTableViewCell.h
//  HealthBAT_Pro
//
//  Created by cjl on 2018/1/17.
//  Copyright © 2018年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PayBlock)(NSIndexPath *cellIndexPath);

@interface BATMemberCenterItemTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *sellPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *originalPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (strong, nonatomic) NSIndexPath *cellIndexPath;

@property (nonatomic,strong) PayBlock payBlock;

- (void)setSellPrice:(NSString *)sellPrice;
- (void)setOriginalPrice:(NSString *)originalPrice;

@end
