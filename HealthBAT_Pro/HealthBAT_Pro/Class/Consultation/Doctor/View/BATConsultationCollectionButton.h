//
//  BATConsultationCollectionButton.h
//  HealthBAT_Pro
//
//  Created by cjl on 16/9/23.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CollectionButtonClickBlock)(UIButton *button);

@interface BATConsultationCollectionButton : UIView

@property (nonatomic,strong) UIButton *button;

@property (nonatomic,strong) UIImageView *imageView;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) CollectionButtonClickBlock collectionButtonClickBlock;

- (instancetype)initWithFrame:(CGRect)frame collectionButtonClickBlock:(CollectionButtonClickBlock)block;

@end
