//
//  BATConsultationHeaderCollectionReusableView.h
//  HealthBAT_Pro
//
//  Created by Skyrim on 16/9/5.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATConsultationHeaderCollectionReusableView : UICollectionReusableView

@property (nonatomic,strong) UILabel *departNameLabel;
@property (nonatomic,strong) UIButton *moreButton;
@property (nonatomic,strong) UITapGestureRecognizer *tap;

@property (nonatomic,copy) void(^moreBlock)();

@end
