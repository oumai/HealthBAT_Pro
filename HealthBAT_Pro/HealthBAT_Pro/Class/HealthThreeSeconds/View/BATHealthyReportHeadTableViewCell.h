//
//  BATHealthyReportHeadTableViewCell.h
//  HealthBAT_Pro
//
//  Created by 黄帆 on 2017/12/16.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BATHealthyAssessModel;
@interface BATHealthyReportHeadTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *priceLab;

@property (weak, nonatomic) IBOutlet UILabel *FatIndexLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;


@property(nonatomic, strong) BATHealthyAssessModel *assessModel;
@property (weak, nonatomic) IBOutlet UILabel *lab;
@property (nonatomic, copy) void(^infoButtonBlock)();

@property (strong, nonatomic) UIButton *infoButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellInfoBtn;
@property (copy, nonatomic) NSString *dateStr;
@end
