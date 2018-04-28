//
//  BATAlbumDetailInfoCell.h
//  HealthBAT_Pro
//
//  Created by four on 2017/6/13.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YYText.h"
#import "BATAlbumDetailModel.h"

typedef void(^FoldAction)(void);

typedef void(^CollectionAction)(void);

typedef void(^ShareAction)(void);

@interface BATAlbumDetailInfoCell : UITableViewCell

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

- (void)configData:(BATAlbumDetailModel *)albumDetailModel;

@end
