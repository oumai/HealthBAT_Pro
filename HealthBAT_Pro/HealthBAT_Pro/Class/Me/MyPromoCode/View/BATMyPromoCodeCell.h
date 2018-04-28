//
//  BATMyPromoCodeCell.h
//  HealthBAT_Pro
//
//  Created by four on 2017/6/8.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BATPromoCodeModel.h"

@interface BATMyPromoCodeCell : UITableViewCell

/*
 全额免费
 */
@property (nonatomic,strong) UILabel    *allFreeLabel;
/*
 优惠码
 */
@property (nonatomic,strong) UILabel    *promoCodeLabel;
/*
 使用范围
 */
@property (nonatomic,strong) UILabel    *useRangeLabel;
/*
 有效时间
 */
@property (nonatomic,strong) UILabel    *validTimeLabel;
/*
 背景图片
 */
@property (nonatomic,strong) UIImageView     *bgImageView;

- (void)setCellWithData:(BATPrommoCodeData *)model;


@end
