//
//  BATRightTableView.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/2/28.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATProgrammesTypeModel.h"
#import "BATMyProgrammesModel.h"
@class BATRightTableView;
@protocol BATRightTableViewDelegate <NSObject>

- (void)BATRightTableView:(BATRightTableView *)view indexPath:(NSIndexPath *)pathRow;

@end
@interface BATRightTableView : UIView
@property (nonatomic,strong) UITableView *rightTableView;
@property (nonatomic,strong) UITableView *leftTableView;

- (void)setLeftTableViewModel:(BATProgrammesTypeModel *)typeModel;

@end
