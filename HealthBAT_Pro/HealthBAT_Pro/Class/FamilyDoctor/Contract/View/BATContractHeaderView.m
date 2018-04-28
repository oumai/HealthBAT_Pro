//
//  BATContractHeaderView.m
//  HealthBAT_Pro
//
//  Created by four on 17/3/17.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATContractHeaderView.h"

@implementation BATContractHeaderView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        WEAK_SELF(self);
        [self addSubview:self.attachmentLabel];
        [self.attachmentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(@20);
            make.left.equalTo(self.mas_left).offset(10);
            make.width.mas_equalTo(SCREEN_WIDTH - 20);
        }];
        
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.attachmentLabel.mas_bottom).offset(20);
            make.centerX.equalTo(self.mas_centerX);
            make.width.mas_equalTo(SCREEN_WIDTH - 20);

        }];
        
    }
    
    return self;
}

- (UILabel *)attachmentLabel{
    if (!_attachmentLabel) {
        _attachmentLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
        [_attachmentLabel sizeToFit];
    }
    
    return _attachmentLabel;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:18] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter];
        [_titleLabel sizeToFit];
    }
    
    return _titleLabel;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
