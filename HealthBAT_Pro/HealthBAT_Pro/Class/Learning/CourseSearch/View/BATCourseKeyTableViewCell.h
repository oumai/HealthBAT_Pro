//
//  BATCourseKeyTableViewCell.h
//  HealthBAT_Pro
//
//  Created by cjl on 2016/12/9.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATHotKeyModel.h"

typedef void(^CourseKeyTapBlock)(NSIndexPath *indexPath,NSString *keyword);
@interface BATCourseKeyTableViewCell : UITableViewCell

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) CourseKeyTapBlock courseKeyTapBlock;

- (void)confirgationCell:(BATHotKeyModel *)hotKeyModel;

@end
