//
//  BATTapicListCell.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/3/14.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATTopicDetailModel.h"
#import "BATTopicListModel.h"

@protocol BATTapicListCellDelegate <NSObject>

- (void)BATTapicListCellTopicAttenAction:(UIButton *)topicBtn row:(NSIndexPath *)rowPath;

@end

@interface BATTapicListCell : UITableViewCell

@property (nonatomic,strong) MyTopicListDataModel *model;

@property (nonatomic,strong) BATTopicDetailModel *detailModel;

@property (nonatomic,strong) NSIndexPath *rowPath;

@property (nonatomic,weak) id <BATTapicListCellDelegate> delegate;

@end
