//
//  MomentTableViewCell.h
//  HealthBAT_Pro
//
//  Created by Skyrim on 16/7/17.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATMomentsModel.h"
#import "YYText.h"

@interface BATMomentTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView * headerImageView;
@property (nonatomic,strong) YYLabel     * yyLabel;

- (void)showContentWithMoment:(BATMomentData *)moment;

@end
