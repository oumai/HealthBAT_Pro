//
//  BATManagePatientCell.h
//  HealthBAT_Pro
//
//  Created by MichaeOu on 2017/6/12.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseTreatmentModel.h"
#import "MEIQIA_TTTAttributedLabel.h"
@class BATHealthFilesCell;
@interface BATHealthFilesCell : UITableViewCell
@property (nonatomic,strong) ChooseTreatmentModel *model;
@property (nonatomic,strong) NSIndexPath *path;

@property (nonatomic, strong) void(^switchBlock)(BATHealthFilesCell *cell,NSIndexPath*pathRows);

@property (nonatomic, strong) UIView *cellView;

@property (nonatomic, strong) TTTAttributedLabel *titleLabel;
@property (nonatomic, strong) UILabel *defaultLabel;
@property (nonatomic, strong) UILabel *sexLabel; //（0-男、1-女、2-未知）
@property (nonatomic, strong) UILabel *ageLabel;
@property (nonatomic, strong) UILabel *numberLabel;

@property (nonatomic, strong) UISwitch *switchOn;


@end
