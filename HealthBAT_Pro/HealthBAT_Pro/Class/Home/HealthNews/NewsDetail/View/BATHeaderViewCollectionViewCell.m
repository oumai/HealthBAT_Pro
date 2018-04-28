//
//  BATHeaderViewCollectionViewCell.m
//  HealthBAT_Pro
//
//  Created by four on 16/9/23.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATHeaderViewCollectionViewCell.h"

@implementation BATHeaderViewCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0 , frame.size.width , frame.size.height)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:20];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor blackColor];
        [self addSubview:_titleLabel];
    }
    return self;
}

@end
