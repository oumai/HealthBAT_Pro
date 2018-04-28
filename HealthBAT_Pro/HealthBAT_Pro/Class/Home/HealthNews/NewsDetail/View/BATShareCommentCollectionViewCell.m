//
//  BATShareCommentCollectionViewCell.m
//  HealthBAT_Pro
//
//  Created by four on 16/9/23.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATShareCommentCollectionViewCell.h"

@implementation BATShareCommentCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        _iconImageV = [[UIImageView alloc]initWithFrame:CGRectMake((frame.size.width - ((SCREEN_WIDTH-20)/4.0 - 25))/2.0, 5 ,(SCREEN_WIDTH-20)/4.0 - 25 ,(SCREEN_WIDTH-20)/4.0 - 25)];
        _iconImageV.backgroundColor = [UIColor clearColor];
        [self addSubview:_iconImageV];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_iconImageV.frame) + 10  , frame.size.width , 20)];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.font = [UIFont systemFontOfSize:17];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = [UIColor blackColor];
        [self addSubview:_nameLabel];
    }
    return self;
}


@end
