//
//  BATRegistrationRecordTableViewCell.h
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/23.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATRegistrationRecordTableViewCell : UITableViewCell

/**
 *  预约的人
 */
@property (nonatomic,strong) UILabel *nameLabel;

/**
 *  预约的时间
 */
@property (nonatomic,strong) UILabel *timeLabel;

/**
 *  预约的医生
 */
@property (nonatomic,strong) UILabel *docNameLabel;

/**
 *  预约的地址
 */
@property (nonatomic,strong) UILabel *adressLabel;

/**
 *  预约的状态
 */
@property (nonatomic,strong) UILabel *registerState;

/**
 *  取消按钮
 */
@property (nonatomic,strong) UIButton *cancelButton;

@end
