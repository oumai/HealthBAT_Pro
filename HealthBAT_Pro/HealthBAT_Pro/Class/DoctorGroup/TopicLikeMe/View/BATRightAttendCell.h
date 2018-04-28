//
//  BATRightAttendCell.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/3/17.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATSameTopicUserModel.h"
@protocol BATRightAttendCellDelegate <NSObject>

- (void)BATRightAttendActionWithRowPath:(NSIndexPath *)rowPath;

- (void)BATRightTableViewToPersonVCindexPath:(NSIndexPath *)pathRow;

@end

@interface BATRightAttendCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLb;

@property (nonatomic,strong) NSIndexPath *rowPath;

@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (strong, nonatomic)  UIButton *attendBtn;

@property (nonatomic,strong) sameTopicUserData *topicUsermodel;

@property (nonatomic,weak) id <BATRightAttendCellDelegate> delegate;

@end
