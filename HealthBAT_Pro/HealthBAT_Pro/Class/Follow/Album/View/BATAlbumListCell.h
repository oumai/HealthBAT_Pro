//
//  BATAlbumListCell.h
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/6/8.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BATAlbumListModel;
@interface BATAlbumListCell : UICollectionViewCell
/** UIImageView */
@property (nonatomic, strong) UIImageView *bgImageView;
/** <#属性描述#> */
@property (nonatomic, strong) UILabel *titleLabel;
/** <#属性描述#> */
@property (nonatomic, strong) BATAlbumListModel *albumModel;
@end
