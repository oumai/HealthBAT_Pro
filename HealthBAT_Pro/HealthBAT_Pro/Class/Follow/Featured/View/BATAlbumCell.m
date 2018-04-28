//
//  BATAlbumCell.m
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/6/7.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATAlbumCell.h"
@interface BATAlbumCell ()
/** <#属性描述#> */
@property (nonatomic, strong) UIImageView *bgImageView;

@end

@implementation BATAlbumCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.bgImageView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
}

- (UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc]init];
        //        _imageView.backgroundColor = [UIColor grayColor];
    }
    return _bgImageView;
}
@end

