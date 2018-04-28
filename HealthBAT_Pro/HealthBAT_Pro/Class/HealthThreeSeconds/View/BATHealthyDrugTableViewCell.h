//
//  BATHealthyDrugTableViewCell.h
//  HealthBAT_Pro
//
//  Created by 黄帆 on 2017/12/18.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BATHealthyAssessModel;
@interface BATHealthyDrugTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *PriceLab;
@property(nonatomic, strong) BATHealthyAssessModel *assessModel;
@end
