//
//  BATBookCell.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 16/9/27.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATAVModel.h"
@protocol BATBookCellDelegate <NSObject>
-(void)BATBookCellDelegatePayActionWithRowPath:(NSIndexPath *)rowPath;
-(void)BATBookCellDelegateCancleActionWithRowPath:(NSIndexPath *)rowPath;
-(void)BATBookCellDelegateStartActionWithRowPath:(NSIndexPath *)rowPath;
-(void)BATBookCellDelegateRefundActionWithRowPath:(NSIndexPath *)rowPath;
@end
@interface BATBookCell : UITableViewCell
@property (nonatomic,strong) NSIndexPath *rowPath;
@property (nonatomic,strong) id <BATBookCellDelegate> delegate;
-(void)cellConfigWithModel:(VideoData *)model;
@end
