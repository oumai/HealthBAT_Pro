//
//  BATSecondDieaseCell.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/5/11.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATDieaseDetailEntityModel.h"
#import "BATCustomButton.h"

typedef void(^secondmoreDetailBlock)(NSIndexPath *path);

@interface BATSecondDieaseCell : UITableViewCell

@property(nonatomic,strong)NSIndexPath *path;
@property(nonatomic,strong)UILabel *nameLb;
@property(nonatomic,strong)UILabel *detailLb;
@property(nonatomic,copy)secondmoreDetailBlock block;
@property(nonatomic,strong)UIImageView *iconView;
@property(nonatomic,assign) BOOL isRowOne;
@property(nonatomic,strong)BATCustomButton *moreBtn;

-(void)configCellWithModel:(BATDieaseDetailEntityModel *)model;
+(CGFloat)HeightWithModel:(BATDieaseDetailEntityModel *)model;

@end
