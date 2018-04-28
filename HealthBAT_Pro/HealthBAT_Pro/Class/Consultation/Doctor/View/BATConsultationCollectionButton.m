//
//  BATConsultationCollectionButton.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/9/23.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATConsultationCollectionButton.h"

@implementation BATConsultationCollectionButton

- (instancetype)initWithFrame:(CGRect)frame collectionButtonClickBlock:(CollectionButtonClickBlock)block
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _imageView = [[UIImageView alloc] init];
        _imageView.image = [UIImage imageNamed:@"iconfont-collection"];
        _imageView.userInteractionEnabled = YES;
        [self addSubview:_imageView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = @"收藏";
        [self addSubview:_titleLabel];
        
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_button];
        
        self.collectionButtonClickBlock = block;
        
        [self setupConstraints];
        
    }
    return self;
}

- (void)setupConstraints
{
    WEAK_SELF(self);
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(self.mas_top);
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(_imageView.mas_bottom);
        make.left.bottom.right.equalTo(self);
    }];
    
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self);
    }];
}

#pragma mark - Action
- (void)buttonAction:(UIButton *)button
{
    button.selected = !button.selected;
    
    if (button.selected) {
        _imageView.image = [UIImage imageNamed:@"iconfont-collection-s"];
        _titleLabel.textColor = UIColorFromHEX(0xfc9f26, 1);
        _titleLabel.text = @"已收藏";
    } else {
        _imageView.image = [UIImage imageNamed:@"iconfont-collection"];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = @"收藏";
    }
    
    if (self.collectionButtonClickBlock) {
        self.collectionButtonClickBlock(button);
    }
}

@end
