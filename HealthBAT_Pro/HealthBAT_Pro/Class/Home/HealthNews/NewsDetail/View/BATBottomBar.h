//
//  BATBottomBar.h
//  HealthBAT_Pro
//
//  Created by Skyrim on 16/9/18.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATBottomBar : UIView

@property (nonatomic,strong) UIButton *editButton;
@property (nonatomic,strong) UIButton *reviewButton;
@property (nonatomic,strong) UIButton *collectionButton;
@property (nonatomic,strong) UIButton *shareButton;

@property (nonatomic,copy) void(^editBlock)(void);
@property (nonatomic,copy) void(^reviewBlock)(void);
@property (nonatomic,copy) void(^collectionBlock)(void);
@property (nonatomic,copy) void(^shareBlock)(void);

@end
