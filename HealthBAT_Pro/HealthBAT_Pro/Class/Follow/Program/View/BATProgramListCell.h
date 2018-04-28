//
//  BATHealthProjectListCell.h
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/6/8.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BATProgramListModel;
@interface BATProgramListCell : UITableViewCell
/** 模型 */
@property (nonatomic, strong) BATProgramListModel *programListModel;
/** 模型 */
@property (nonatomic, strong) BATProgramListModel *addedProgramListModel;
@end
