//
//  BATInvitationPersonCell.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/3/20.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATGraditorButton.h"
/**
 *  头像点击
 *
 *  @param indexPath 指定indexPath
 */
typedef void(^InivationAvatarAction)(void);

/**
 *  头像点击
 *
 *  @param indexPath 指定indexPath
 */
typedef void(^AttendBlock)(void);

@interface BATInvitationPersonCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;

@property (nonatomic,strong) BATGraditorButton *attendBtn;

@property (nonatomic,strong) UIImageView *attendImage;

@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (strong, nonatomic)  BATGraditorButton *tipsLb;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (nonatomic,strong) InivationAvatarAction invitationBlock;

@property (nonatomic,strong) AttendBlock attendblock;

@property (nonatomic,assign) BOOL isFollow;

@end
