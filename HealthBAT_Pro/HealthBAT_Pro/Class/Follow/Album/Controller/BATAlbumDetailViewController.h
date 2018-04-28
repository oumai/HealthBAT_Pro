//
//  BATAlbumDetailViewController.h
//  HealthBAT_Pro
//
//  Created by four on 2017/6/13.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BATAlbumDetailView.h"

@interface BATAlbumDetailViewController : UIViewController

@property (nonatomic,strong) BATAlbumDetailView *albumDetailView;

/**
 专辑详情ID
 */
@property (nonatomic,strong) NSString  *albumID;
/**
 视频ID
 */
@property (nonatomic,strong) NSString  *videoID;

@end
