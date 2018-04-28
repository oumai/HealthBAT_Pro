//
//  BATTrainStudioListCell.h
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/7/14.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BATTrainStudioListModel;
@interface BATTrainStudioListCell : UITableViewCell
/** model */
@property (nonatomic, strong) BATTrainStudioListModel *studioListModel;
/** 当前课程类型 */
@property (nonatomic, assign) NSInteger  SubjectType;

@end
