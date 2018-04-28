//
//  BATMoreView.h
//  HealthBAT_Pro
//
//  Created by cjl on 16/10/14.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATMoreMenuButton.h"

@class BATMoreView;
@protocol BATMoreViewDelegate <NSObject>

- (void)moreView:(BATMoreView *)moreView buttonClicked:(UIButton *)button;

@end

@interface BATMoreView : UIView


/**
 相机
 */
@property (nonatomic,strong) BATMoreMenuButton *cameraBtn;


/**
 相册
 */
@property (nonatomic,strong) BATMoreMenuButton *albumBtn;


/**
 委托
 */
@property (nonatomic,weak) id<BATMoreViewDelegate> delegate;

@end
