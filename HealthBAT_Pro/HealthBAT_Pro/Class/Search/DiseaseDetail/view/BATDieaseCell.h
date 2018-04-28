//
//  testCell.h
//  TableViewTest
//
//  Created by mac on 16/9/16.
//  Copyright © 2016年 sword. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATDieaseDetailEntityModel.h"
typedef void(^moreDetailBlock)(NSIndexPath *path);
@interface BATDieaseCell : UITableViewCell
@property(nonatomic,strong)NSIndexPath *path;
@property(nonatomic,strong)UILabel *nameLb;
@property(nonatomic,strong)UILabel *detailLb;
@property(nonatomic,copy)moreDetailBlock block;
@property(nonatomic,strong)UIImageView *iconView;
@property(nonatomic,assign) BOOL isRowOne;
@property(nonatomic,strong)UIButton *moreBtn;
-(void)configCellWithModel:(BATDieaseDetailEntityModel *)model;
+(CGFloat)HeightWithModel:(BATDieaseDetailEntityModel *)model;
@end
