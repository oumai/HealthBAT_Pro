//
//  BATPicCollectionViewCell.m
//  HealthBAT
//
//  Created by cjl on 16/8/1.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATPicCollectionViewCell.h"

@implementation BATPicCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _imageView = [[UIImageView alloc] init];
        _imageView.userInteractionEnabled = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [self.contentView addSubview:_imageView];
        
//        _deleteImageView = [[UIImageView alloc] init];
//        _deleteImageView.userInteractionEnabled = YES;
//        _deleteImageView.image = [UIImage imageNamed:@"ic_delete"];
//        [self.contentView addSubview:_deleteImageView];
        
        [self setupConstraints];
    }
    return self;
}

- (void)setupConstraints
{
    WEAK_SELF(self);
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(7, 7, 0, 0));
    }];
    
//    [_deleteImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.contentView.mas_left);
//        make.top.equalTo(self.contentView.mas_top);
//        make.size.mas_offset(CGSizeMake(13, 13));
//    }];
}

@end
