//
//  BATRelateTreatmentCell.h
//  TableViewTest
//
//  Created by mac on 16/9/17.
//  Copyright © 2016年 sword. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BATDieaseDetailEntityModel;
typedef void(^RelateTreatmentDetailBlock)(NSIndexPath *path,NSInteger numbers);

@interface BATRelateTreatmentCell : UITableViewCell
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

@property(nonatomic,strong)UIImageView *iconView;

-(void)configCellWithModel:(BATDieaseDetailEntityModel *)model;
+(CGFloat)HeightWithModel:(BATDieaseDetailEntityModel *)model;

@end
