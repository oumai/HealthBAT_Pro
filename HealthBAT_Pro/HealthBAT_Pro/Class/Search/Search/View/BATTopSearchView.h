//
//  TopSearchView.h
//  HealthBAT
//
//  Created by KM on 16/7/292016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATTopSearchView : UIView

@property (nonatomic,strong) UIButton *chooseButton;
@property (nonatomic,strong) UITextField *searchTF;
@property (nonatomic,strong) UIButton *cancelButton;
@property (nonatomic,strong) UIView *backView;

@property (nonatomic,copy) void(^chooseType)(void);
@property (nonatomic,copy) void(^cancelBlock)(void);

@end
