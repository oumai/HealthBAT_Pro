//
//  BATSectionOneCell.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/5/8.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *
 *
 *  @更多点击block
 */
typedef void(^dieaseDetailBlock)(void);


@interface BATSectionOneCell : UITableViewCell

@property (nonatomic,strong) NSString *contentString;

@property (nonatomic,strong) UILabel *titleLb;

@property (nonatomic,strong) UILabel *contentLb;

@property (nonatomic,strong) dieaseDetailBlock dieaseBlock;

@end
