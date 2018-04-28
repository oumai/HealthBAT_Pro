//
//  BATFindContentCell.h
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/29.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  发现类型
 */
typedef NS_ENUM(NSInteger,BATFindType) {
    /**
     *  医生
     */
    BATFindDoctor = 0,
    /**
     *  群组
     */
    BATFindGroup,
    /**
     *  好友
     */
    BATFindFriends,
};

/**
 *  关注按钮block
 *
 *  @param model     数据
 */
typedef void (^FollowUser)(id model);

/**
 *  点击collectionview中某个cell
 *
 *  @param indexPath 指定行
 */
typedef void(^DidSelectedCell)(NSIndexPath *indexPath);

@interface BATFindContentCell : UITableViewCell

/**
 *  列表
 */
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

/**
 *  layout
 */
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;


/**
 *  关注按钮block
 */
@property (nonatomic, strong) FollowUser followUser;

/**
 *  选择选择cell
 */
@property (nonatomic, strong) DidSelectedCell didSelectedCell;

/**
 *  配置加载数据
 *
 *  @param data 数据
 *  @param type 数据类型： 医生、好友、群组
 */
- (void)configrationCell:(NSArray *)data type:(BATFindType)type;

@end
