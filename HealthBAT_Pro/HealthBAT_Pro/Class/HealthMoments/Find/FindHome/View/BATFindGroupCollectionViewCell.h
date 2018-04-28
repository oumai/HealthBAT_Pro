//
//  BATFindGroupCollectionViewCell.h
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/29.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATFindGroupCollectionViewCell : UICollectionViewCell
/**
 *  群头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *groupIconImageView;

/**
 *  群名字
 */
@property (weak, nonatomic) IBOutlet UILabel *groupNameLabel;

/**
 *  群成员数
 */
@property (weak, nonatomic) IBOutlet UILabel *groupMemberCountLabel;

@end
