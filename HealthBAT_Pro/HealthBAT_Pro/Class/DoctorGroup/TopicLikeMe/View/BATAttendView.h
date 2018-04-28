//
//  BATAttendView.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/3/17.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATProgrammesTypeModel.h"
#import "BATMyProgrammesModel.h"
@class BATAttendView;
@protocol BATAttendViewDelegate <NSObject>
@optional
- (void)BATRightTableView:(BATAttendView *)view indexPath:(NSIndexPath *)pathRow;

- (void)BATRightTableView:(BATAttendView *)view accountID:(NSString *)account;

@end
@interface BATAttendView : UIView

@property (nonatomic,strong) UITableView *rightTableView;
@property (nonatomic,strong) UITableView *leftTableView;

@property (nonatomic,strong) UIView *defaultView;

@property(nonatomic,assign)id <BATAttendViewDelegate> delegate;

- (void)setLeftTable;

- (void)updateData;

@end
