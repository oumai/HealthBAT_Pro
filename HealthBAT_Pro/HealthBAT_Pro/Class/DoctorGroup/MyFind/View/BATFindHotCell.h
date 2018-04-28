//
//  BATFindHotCell.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/3/14.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATHotTopicListModel.h"

typedef void(^TopicKeyTapBlock)(NSIndexPath *indexPath,NSString *keyword);

@interface BATFindHotCell : UITableViewCell

@property (nonatomic,strong) UICollectionView *collectionView;


@property (nonatomic,strong) TopicKeyTapBlock topicKeyTapBlock;

- (void)confirgationCell:(BATHotTopicListModel *)hotKeyModel;

@end
