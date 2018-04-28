//
//  BATDoctorListView.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/4/1.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SortBlock)(void);

typedef void(^FilterBlock)(void);

typedef void(^SearchBlock)(void);

@interface BATDoctorListView : UIView

@property (nonatomic,strong) UIView *topView;

@property (nonatomic,strong) UITextField *searchTF;

@property (nonatomic,strong) UITableView *categoryTableView;

@property (nonatomic,strong) UIView *menuView;

@property (nonatomic,strong) UIButton *sortButton;

@property (nonatomic,strong) UIButton *filterButton;

@property (nonatomic,strong) UITableView *doctorTableView;

@property (nonatomic,strong) SortBlock sortBlock;

@property (nonatomic,strong) FilterBlock filterBlock;

@property (nonatomic,strong) SearchBlock searchBlock;

@end
