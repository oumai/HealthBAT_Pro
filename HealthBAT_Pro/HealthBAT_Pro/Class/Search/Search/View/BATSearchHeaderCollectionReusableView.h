//
//  SearchHeaderCollectionReusableView.h
//  HealthBAT
//
//  Created by KM on 16/8/12016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATSearchHeaderCollectionReusableView : UICollectionReusableView

/**
 *  左边的小图标
 */
@property (nonatomic,strong) UIImageView *leftImageView;
@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,strong) UIButton * clearButton;

@property (nonatomic,copy) void(^clearBlock)(void);

@end
