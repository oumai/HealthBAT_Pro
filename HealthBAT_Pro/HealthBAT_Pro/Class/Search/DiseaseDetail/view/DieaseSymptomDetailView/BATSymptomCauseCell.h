//
//  BATSymptomCauseCell.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2016/12/30.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATSymptomModel.h"
typedef void(^causeDetailBlock)(NSIndexPath *path);
@interface BATSymptomCauseCell : UITableViewCell
@property(nonatomic,strong)NSIndexPath *path;
@property(nonatomic,strong)UILabel *nameLb;
@property(nonatomic,strong)UILabel *detailLb;
@property(nonatomic,strong)UIImageView *iconView;
@property(nonatomic,strong)UIButton *moreBtn;
@property(nonatomic,copy)causeDetailBlock causeblock;

-(void)configCellWithModel:(BATSymptomModel *)model;
+(CGFloat)HeightWithModel:(BATSymptomModel *)model;
@end
