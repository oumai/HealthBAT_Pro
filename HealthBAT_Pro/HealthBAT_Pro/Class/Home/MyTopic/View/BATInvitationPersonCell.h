//
//  BATInvitationPersonCell.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/3/20.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  头像点击
 *
 *  @param indexPath 指定indexPath
 */
typedef void(^InivationAvatarAction)();

/**
 *  头像点击
 *
 *  @param indexPath 指定indexPath
 */
typedef void(^AttendBlock)();

@interface BATInvitationPersonCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UIButton *attendBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UILabel *tipsLb;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (nonatomic,strong) InivationAvatarAction invitationBlock;

@property (nonatomic,strong) AttendBlock attendblock;

@end
