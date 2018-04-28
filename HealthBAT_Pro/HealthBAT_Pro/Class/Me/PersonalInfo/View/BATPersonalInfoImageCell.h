//
//  BATPersonalInfoImageCell.h
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/5/18.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATPersonalInfoImageCell : UITableViewCell
/** <#属性描述#> */
@property (nonatomic, strong) NSDictionary *dataDict;

/** <#属性描述#> */
@property (nonatomic, strong) UILabel *titleLabel;
/** <#属性描述#> */
@property (nonatomic, strong) UIImageView *iconImageView;
@end
