//
//  administrativeCell.h
//  TableViewTest
//
//  Created by mac on 16/9/17.
//  Copyright © 2016年 sword. All rights reserved.
//
#import "BATDieaseDetailEntityModel.h"
#import <UIKit/UIKit.h>
typedef void(^AdministrativeDetailBlocks)(NSIndexPath *path,NSInteger numbers);
@interface BATAdministrativeCell : UITableViewCell
@property(nonatomic,strong)UILabel *nameLb;
@property(nonatomic,strong)UILabel *downDetailLb;
@property(nonatomic,strong)NSIndexPath *path;

@property(nonatomic,copy)AdministrativeDetailBlocks Administrativeblocks;

-(void)configCellWithModel:(BATDieaseDetailEntityModel *)model;
+(CGFloat)HeightWithModel:(BATDieaseDetailEntityModel *)model;
@end
