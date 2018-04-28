//
//  BATAlbumDetailView.h
//  HealthBAT_Pro
//
//  Created by four on 2017/6/13.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BATAlbumDetailBottomView.h"

@interface BATAlbumDetailView : UIView

@property (nonatomic,strong) UITableView *tableView;

//@property (nonatomic,strong) BATAlbumDetailHeaderView *tableHeaderView;

@property (nonatomic,strong) BATAlbumDetailBottomView *albumeDetailBottomView;

@end
