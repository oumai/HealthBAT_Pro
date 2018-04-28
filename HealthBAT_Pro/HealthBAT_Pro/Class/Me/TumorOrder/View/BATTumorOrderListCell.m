//
//  BATTumorOrderListCell.m
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/9/15.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATTumorOrderListCell.h"
#import "BATTumorOrderListModel.h"
#import "UIColor+Gradient.h"

@interface BATTumorOrderListCell ()

@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderSattusLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderMoneyLabel;
/** <#属性描述#> */
@property (nonatomic, strong) UIColor *textColor;

@end

@implementation BATTumorOrderListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.textColor = [UIColor gradientFromColor:UIColorFromHEX(0x29ccbf, 1) toColor:UIColorFromHEX(0x6ccc56, 1) withHeight:14];
    self.orderTitleLabel.textColor = UIColorFromHEX(0x666666, 1);
    self.orderTimeLabel.textColor = UIColorFromHEX(0x666666, 1);
    self.orderMoneyLabel.textColor = UIColorFromHEX(0x666666, 1);
    self.orderSattusLabel.textColor = UIColorFromHEX(0x666666, 1);
    
}

- (void)setOrderListModel:(BATTumorOrderListModel *)orderListModel{
    _orderListModel = orderListModel;
    
    /*
     OrderID = 4f480853-422b-48c3-920a-11d5b168f399,
     OrderCode = 10720170920100002,
     Prop3 = 15817468410,
     CreateDateTime = 2017-09-20 10:55:23,
     ProductName = 基础筛查套餐（男）,
     LinkUrl = https://ctms.anticancer365.com/BATExamine/package_man1.html,
     ProductID = 2c821730-9f54-4d25-8307-a8c30c265d9e,
     TotalFee = 0.01,
     OrderStatus = 1
     
     */
     self.orderTitleLabel.textColor = self.textColor;
    self.orderTitleLabel.text = orderListModel.ProductName;
    self.orderTimeLabel.text = orderListModel.CreateDateTime;
    self.orderMoneyLabel.text = [NSString stringWithFormat:@"¥%@",orderListModel.TotalFee];
    
    switch (orderListModel.OrderStatus) {
        case 0:
        {
            self.orderSattusLabel.textColor = [UIColor redColor];
            self.orderSattusLabel.text = @"未支付";
            break;
        }
            
        case 1:
        {
            
            self.orderSattusLabel.textColor = self.textColor;
            self.orderSattusLabel.text = @"已支付";
            break;
        }
            
        case 2:
        {
            self.orderSattusLabel.text = @"已完成";
            self.orderSattusLabel.textColor = UIColorFromHEX(0x333333, 1);
            break;
        }
        case 3:
        {
            self.orderSattusLabel.text = @"已取消";
            self.orderSattusLabel.textColor = UIColorFromHEX(0x999999, 1);
            break;
        }
            
        default:
            break;
    }
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
