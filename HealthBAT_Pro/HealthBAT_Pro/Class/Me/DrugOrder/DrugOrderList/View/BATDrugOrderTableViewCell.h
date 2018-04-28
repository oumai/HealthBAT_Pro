//
//  BATDrugOrderTableViewCell.h
//  HealthBAT_Pro
//
//  Created by wct on 2017/12/14.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BATDrugOrderListModel.h"
#import "BATGraditorButton.h"

@interface BATDrugOrderTableViewCell : UITableViewCell

@property (nonatomic,strong) UILabel *orderCodeLabel;

@property (nonatomic,strong) UILabel *timeLabel;

@property (nonatomic,strong) UILabel *prescriptionNameLabel;

@property (nonatomic,strong) UILabel *countLabel;

@property (nonatomic,strong) UILabel *moneyLabel;

@property (nonatomic,strong) BATGraditorButton *payBtn;

@property (nonatomic,strong) UIButton *logisticsBtn;

@property (nonatomic,strong) UIButton *cancelBtn;

//支付完成下的取消
@property (nonatomic,strong) UIButton *otherBtn;

@property (nonatomic,strong) void(^ClickBaseBtn)();

@property (nonatomic,strong) void(^ClickOtherBtn)();

- (void)cellReloadWithModel:(BATDrugOrderListDataModel *)model;

@end
