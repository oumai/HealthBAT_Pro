//
//  BATAlbumDetailRecommendedVideoCell.h
//  HealthBAT_Pro
//
//  Created by four on 2017/6/15.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BATAlbumDetailRecommendVidoeModel.h"

@interface BATAlbumDetailRecommendedVideoCell : UITableViewCell

@property (nonatomic,strong) UIImageView *VideoImageView;

@property (nonatomic,strong) UILabel *playTimeLabel;

@property (nonatomic,strong) UILabel *titleLabel;

- (void)setCellWithModel:(BATAlbumDetailRecommendVidoeData *)data;

@end
