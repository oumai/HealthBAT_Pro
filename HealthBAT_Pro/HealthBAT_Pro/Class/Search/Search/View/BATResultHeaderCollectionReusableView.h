//
//  ResultHeaderCollectionReusableView.h
//  HealthBAT
//
//  Created by KM on 16/8/12016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATResultHeaderCollectionReusableView : UICollectionReusableView

@property (nonatomic,strong) UIView * blueView;
@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,strong) UILabel * subTitleLabel;
@property (nonatomic,strong) UIButton * moreButton;

@property (nonatomic,assign) kSearchType type;

@property (nonatomic,copy) void(^moreBlock)(NSString * title , kSearchType type);

@end
