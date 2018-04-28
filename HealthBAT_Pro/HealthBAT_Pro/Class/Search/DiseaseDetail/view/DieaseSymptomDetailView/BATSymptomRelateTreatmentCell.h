//
//  BATSymptomRelateTreatmentCell.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2016/12/28.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATSymptomModel.h"
typedef void(^RelateTreatmentDetailBlock)(NSIndexPath *path,NSInteger numbers);
@interface BATSymptomRelateTreatmentCell : UITableViewCell
@property(nonatomic,strong)NSIndexPath *path;
@property(nonatomic,strong)UILabel *nameLb;
@property(nonatomic,strong)UILabel *detailLb;
@property(nonatomic,copy)RelateTreatmentDetailBlock RelateTreatmentblock;

@property(nonatomic,strong)UILabel *examineLb;
@property(nonatomic,strong)UILabel *treatmentLb;
@property(nonatomic,strong)UILabel *nursedLb;

@property(nonatomic,strong)UIButton *examineBtn;
@property(nonatomic,strong)UIButton *treatmentBtn;
@property(nonatomic,strong)UIButton *nursedBtn;

-(void)configCellWithModel:(BATSymptomModel *)model;
+(CGFloat)HeightWithModel:(BATSymptomModel *)model;
@end
