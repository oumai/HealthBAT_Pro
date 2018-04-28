//
//  BATTopImageCollectionViewCell.m
//  HealthBAT_Pro
//
//  Created by KM on 16/8/252016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATConsultationImageCollectionViewCell.h"

@implementation BATConsultationImageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        WEAK_SELF(self);
        [self.contentView addSubview:self.topImageView];
        [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (UIImageView *)topImageView {
    if (!_topImageView) {
        _topImageView = [[UIImageView alloc] init];
    }
    return _topImageView;
}
@end
