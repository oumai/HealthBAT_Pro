//
//  BATCourseDetailCell.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/2/23.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYText.h"
#import "BATCourseDetailModel.h"

typedef void(^FoldAction)(void);

typedef void(^CollectionAction)(void);

typedef void(^ShareAction)(void);

@interface BATCourseDetailCell : UITableViewCell

/**
 标题
 */
@property (nonatomic,strong) UILabel *titleLabel;

/**
 详细
 */
@property (nonatomic,strong) YYLabel *descLabel;

/**
 播放次数
 */
@property (nonatomic,strong) UILabel *playCountLabel;

/**
 收藏按钮
 */
@property (nonatomic,strong) UIButton *collectButton;

/**
 分享按钮
 */
@property (nonatomic,strong) UIButton *shareButton;

/**
 是否展开
 */
@property (nonatomic,assign) BOOL isFold;

/**
 展开收起Block
 */
@property (nonatomic,strong) FoldAction foldAction;

/**
 收藏Block
 */
@property (nonatomic,strong) CollectionAction collectionAction;

/**
 分享Block
 */
@property (nonatomic,strong) ShareAction shareAction;

- (void)configData:(BATCourseDetailModel *)courseDetailModel;

@end
