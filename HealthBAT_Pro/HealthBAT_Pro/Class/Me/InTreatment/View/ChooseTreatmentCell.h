//
//  ChooseTreatmentCell.h
//  TableViewTest
//
//  Created by kmcompany on 16/9/23.
//  Copyright © 2016年 sword. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChooseTreatmentModel;
@protocol ChooseTreatmentCellDelegate <NSObject>
-(void)ChooseTreatmentCellEditActionWithRow:(NSIndexPath *)pathRow;
-(void)ChooseTreatmentCellDeleteActionWithRow:(NSIndexPath *)pathRow;

-(void)ChooseTreatmentCellDefaultActionWithRow:(NSIndexPath *)pathRow;
//-(void)ChooseTreatmentCellSelectActionWithRow:(NSIndexPath *)pathRow;
@end

@interface ChooseTreatmentCell : UITableViewCell
@property (nonatomic,strong) NSIndexPath *rowPath;
@property (nonatomic,strong) id <ChooseTreatmentCellDelegate> delegate;
@property (nonatomic,strong) NSString *memberID;

-(void)cellConfigWithModel:(ChooseTreatmentModel *)model;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier isCanSelect:(BOOL)isCanSelect;
@end
