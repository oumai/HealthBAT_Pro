//
//  BATHealthFollowTestTableViewCell.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/2/27.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATTemplateModel.h"
#import "BATGraditorButton.h"
@interface BATHealthFollowTestTableViewCell : UITableViewCell

/**
 标题
 */
@property (nonatomic,strong) UILabel *titleLabel;

/**
 yes按钮
 */
@property (nonatomic,strong) BATGraditorButton *yesButton;

/**
 no按钮
 */
@property (nonatomic,strong) BATGraditorButton *noButton;

- (void)configData:(BATQuestion *)question indexPath:(NSIndexPath *)indexPath;

@end
