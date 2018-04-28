//
//  BATListenTopicCell.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/3/20.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATHotTopicListModel.h"
/**
 *  头像点击
 *
 *  @param indexPath 指定indexPath
 */
typedef void(^AttendActionBlock)(NSIndexPath *indexPath);

@interface BATListenTopicCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *attendCountLb;
@property (weak, nonatomic) IBOutlet UILabel *topicCountLb;

@property (nonatomic,strong) NSIndexPath *path;

@property (nonatomic,strong) UIButton *attendBtn;

@property (nonatomic,strong) HotTopicListData *listData;

@property (nonatomic,strong) AttendActionBlock attendBlock;


@end
