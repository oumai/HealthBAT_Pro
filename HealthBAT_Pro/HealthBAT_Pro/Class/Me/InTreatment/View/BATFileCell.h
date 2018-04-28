//
//  BATFileCell.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2016/12/6.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseTreatmentModel.h"
@class BATFileCell;
@protocol BATFileCellDelegate <NSObject>
-(void)BATFileCellEdit:(BATFileCell *)cell IndexPath:(NSIndexPath *)pathRows;
-(void)BATFileCellSetDefault:(BATFileCell *)cell IndexPath:(NSIndexPath *)pathRows;
@end
@interface BATFileCell : UITableViewCell
@property (nonatomic,strong) NSIndexPath *path;
@property (nonatomic,strong) id <BATFileCellDelegate> delegate;
@property (nonatomic,strong) ChooseTreatmentModel *model;
@end
