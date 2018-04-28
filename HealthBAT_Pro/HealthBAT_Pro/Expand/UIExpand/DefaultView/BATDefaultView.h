//
//  BATDefaultView.h
//  HealthBAT_Pro
//
//  Created by four on 16/12/27.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATDefaultView : UIView

@property (nonatomic,strong) UIImageView    *imageV;

@property (nonatomic,strong) UILabel        *titleLabel;

@property (nonatomic,strong) UIButton       *reloadButton;

//重新加载
@property (nonatomic,copy) void(^reloadRequestBlock)(void);

- (id)initWithFrame:(CGRect)frame;

- (void)changeDefaultStyleOfShowReloadButtonForNoNet:(BOOL)netState  andRequsetStateError:(BOOL)requsetState;

- (void)showDefaultView;

- (void)chagngeDefaultViewImageView:(NSString *)iamgeStr withTitle:(NSString *)titleStr;

@end
