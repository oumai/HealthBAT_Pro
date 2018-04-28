//
//  BATFindGroupCollectionViewCell.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/29.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATFindGroupCollectionViewCell.h"

@implementation BATFindGroupCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _groupIconImageView.layer.cornerRadius = _groupIconImageView.frame.size.height / 2;
    _groupIconImageView.layer.masksToBounds = YES;
    
    
}

@end
