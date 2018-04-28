//
//  BATTrainStudioSelectedCollectionViewCell.m
//  HealthBAT_Pro
//
//  Created by Skybrim on 2017/4/5.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATTrainStudioSelectedCollectionViewCell.h"

@implementation BATTrainStudioSelectedCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(@5);
            make.right.bottom.equalTo(@-5);
        }];
        
        self.layer.cornerRadius = 3.0f;
        self.layer.borderWidth = 0.5f;
        self.layer.borderColor = STRING_DARK_COLOR.CGColor;
    }
    return self;
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:13] textColor:STRING_DARK_COLOR textAlignment:NSTextAlignmentCenter];
    }
    return _titleLabel;
}
@end
