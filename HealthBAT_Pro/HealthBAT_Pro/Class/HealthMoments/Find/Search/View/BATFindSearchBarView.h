//
//  BATFindSearchBarView.h
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/29.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CancelBlock)(void);

@interface BATFindSearchBarView : UIView

@property (nonatomic,strong) UISearchBar *searchBar;

@property (nonatomic,strong) UIButton *cancelButton;

@property (nonatomic,strong) CancelBlock cancelBlock;

@end
