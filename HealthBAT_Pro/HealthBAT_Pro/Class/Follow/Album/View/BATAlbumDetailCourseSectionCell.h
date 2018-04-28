//
//  BATAlbumDetailCourseSectionCell.h
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/9/19.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BATAlbumDetailModel;
@interface BATAlbumDetailCourseSectionCell : UITableViewCell
/** <#属性描述#> */
@property (nonatomic, strong) BATAlbumDetailModel *albumDetailModel;
/** <#属性描述#> */
@property (nonatomic, strong) UIButton *videoImageButton;
/** <#属性描述#> */
@property (nonatomic, strong) UIButton *circleButton;
/** <#属性描述#> */
@property (nonatomic, strong) UIView *circleTopView;
/** <#属性描述#> */
@property (nonatomic, strong) UIView *circleBottomView;

- (void)setDateWith:(BATAlbumDetailModel *)albumDetailModel indexPath:(NSIndexPath *)indexPath selctedVideoID:(NSString *)selctedVideoID;
@end
