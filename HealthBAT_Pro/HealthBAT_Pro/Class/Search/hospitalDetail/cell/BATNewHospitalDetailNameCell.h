//
//  BATNewHospitalDetailNameCell.h
//  HealthBAT_Pro
//
//  Created by four on 2017/5/18.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

//model
#import "HospitalDetailModel.h"

@interface BATNewHospitalDetailNameCell : UITableViewCell
/*
 *图片
 */
@property (nonatomic,strong) UIImageView *imageV;
/*
 *灰色背景
 */
@property (nonatomic,strong) UIView *blackBGView;
/*
 *医院名称
 */
@property (nonatomic,strong) UILabel *nameLabel;
/*
 *医院等级
 */
@property (nonatomic,strong) UILabel *levelLabel;
/*
 *医院地址，icon，箭头
 */
@property (nonatomic,strong) UIView *addressBGView;
@property (nonatomic,strong) UIImageView *addressIcon;
@property (nonatomic,strong) UILabel *addressLabel;
@property (nonatomic,strong) UILabel *titleAddressLabel;
@property (nonatomic,strong) UIImageView *addressRightImageV;
/*
 *分割线
 */
@property (nonatomic,strong) UIView *lineView;
/*
 *医院电话，icon，箭头
 */
@property (nonatomic,strong) UIView *phoneBGView;
@property (nonatomic,strong) UIImageView *phoneIcon;
@property (nonatomic,strong) UILabel *phoneLabel;
@property (nonatomic,strong) UILabel *titlePhoneLabel;
@property (nonatomic,strong) UIImageView *phoneRightImageV;

@property (nonatomic,copy) void(^ClickPhoneBlock)(void);
@property (nonatomic,copy) void(^ClickAddressBlock)(void);

- (void)setCellWithModel:(HospitalDetailModel *)model;

@end
