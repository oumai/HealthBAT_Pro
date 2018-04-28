//
//  BATProjectCell.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/2/28.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATMyProgrammesModel.h"
#import "BATGraditorButton.h"
@protocol BATProjectCellDelegate <NSObject>
- (void)BATProjectCellClickAction:(NSInteger)row;
@end

@interface BATProjectCell : UITableViewCell
@property (nonatomic,strong) NSIndexPath *pathRow;
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UIButton *clickBtn;

@property (weak, nonatomic) IBOutlet BATGraditorButton *subTitle;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (nonatomic,strong) ProgrammesData *model;

@property (nonatomic,weak) id <BATProjectCellDelegate> delegate;

@end
