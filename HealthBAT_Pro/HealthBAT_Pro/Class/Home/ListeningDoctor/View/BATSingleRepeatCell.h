//
//  BATSingleRepeatCell.h
//  RecordTest
//
//  Created by kmcompany on 2017/3/15.
//  Copyright © 2017年 kmcompany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UUMessageContentButton.h"
#import "BATTopicRecordModel.h"

@protocol BATSingleRepeatCellDelegate <NSObject>

- (void)BATSingleRepeatCellPlayerWithURL:(NSString *)URL;

@end

@interface BATSingleRepeatCell : UITableViewCell
@property (nonatomic,strong) UUMessageContentButton *btnContent;

@property (nonatomic,strong) UILabel *nameLb;
@property (nonatomic,strong) UILabel *timeNum;

@property (nonatomic,strong) secondReplyData *model;

@property (nonatomic,weak) id <BATSingleRepeatCellDelegate> delegate;
@end
