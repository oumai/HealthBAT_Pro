//
//  BATDrugCell.h
//  TableViewTest
//
//  Created by mac on 16/9/17.
//  Copyright © 2016年 sword. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BATDieaseDetailEntityModel;

typedef void(^moreDetailBlock)(NSIndexPath *path);

@protocol BATDrugCellDelegate <NSObject>

-(void)BATDrugCellDrugClickActionWithRow:(NSInteger)row;

@end

@interface BATDrugCell : UITableViewCell
@property(nonatomic,strong)NSIndexPath *path;
@property(nonatomic,strong)UILabel *nameLb;
@property(nonatomic,copy)moreDetailBlock block;
@property(nonatomic,strong)UIImageView *iconView;
@property(nonatomic,strong)id <BATDrugCellDelegate> delegate;

-(void)configCellWithModel:(BATDieaseDetailEntityModel *)model;
+(CGFloat)HeightWithModel:(BATDieaseDetailEntityModel *)model;

@end
