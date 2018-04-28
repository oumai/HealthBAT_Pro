//
//  BATHomeTopSearchView.m
//  HealthBAT_Pro
//
//  Created by KM on 17/6/292017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHomeTopSearchView.h"
#import "WZLBadgeImport.h"

@implementation BATHomeTopSearchView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.roundView];
        [self.roundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.centerY.equalTo(@0);
            make.size.mas_equalTo(CGSizeMake(42, 42));
        }];
        
        [self addSubview:self.backView];
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.roundView.mas_right).offset(-20);
            make.centerY.equalTo(@0);
            make.size.mas_equalTo(CGSizeMake(frame.size.width-(30+10)-42, 35));
        }];
        
        [self addSubview:self.messageBtn];
        [self.messageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@0);
            make.centerY.equalTo(@0);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        
        [self addSubview:self.bImageView];
        [self.bImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.roundView);
        }];
        
        [self bringSubviewToFront:self.roundView];
        [self bringSubviewToFront:self.bImageView];
        
        
        [self addSubview:self.searchIconImageView];
        [self.searchIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(@0);
            make.left.equalTo(self.bImageView.mas_right).offset(0);
            make.size.mas_equalTo(CGSizeMake(30, 35));
        }];

        [self addSubview:self.desLabel];
        [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(@0);
            make.left.equalTo(self.searchIconImageView.mas_right);
            make.right.lessThanOrEqualTo(self.backView.mas_right);
        }];
    }
    return self;
}

- (CGSize)intrinsicContentSize {
    
    return UILayoutFittingExpandedSize;
}

#pragma mark -
- (UIView *)roundView {
    
    if (!_roundView) {
        _roundView = [[UIView alloc] init];
        _roundView.backgroundColor = BASE_BACKGROUND_COLOR;
        _roundView.layer.cornerRadius = 21;
        _roundView.layer.shadowColor = [UIColor blackColor].CGColor;
        _roundView.layer.shadowOffset = CGSizeMake(-2,0);
        _roundView.layer.shadowOpacity = 0.2;
    }
    return _roundView;
}

- (UIImageView *)bImageView {
    
    if (!_bImageView) {
        _bImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"B"]];
    }
    return _bImageView;
}

- (UIView *)backView {
    
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = BASE_BACKGROUND_COLOR;
        _backView.layer.shadowColor = [UIColor blackColor].CGColor;
        _backView.layer.shadowOffset = CGSizeMake(0,2);
        _backView.layer.shadowOpacity = 0.2;
        
        [_backView bk_whenTapped:^{
            if (self.searchBlock) {
                self.searchBlock();
            }
        }];
    }
    return _backView;
}

- (UIImageView *)searchIconImageView {
    
    if (!_searchIconImageView) {
        
        _searchIconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic-search"]];
        _searchIconImageView.backgroundColor = BASE_BACKGROUND_COLOR;
        _searchIconImageView.contentMode = UIViewContentModeCenter;
    }
    return _searchIconImageView;
}

- (UILabel *)desLabel {
    
    if (!_desLabel) {
        _desLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:13] textColor:STRING_LIGHT_COLOR textAlignment:NSTextAlignmentLeft];
        _desLabel.text = @"搜索疾病、症状、药品、医院、养老院、医生";
    }
    return _desLabel;
}

- (UIButton *)messageBtn {
    
    if (!_messageBtn) {
        
        _messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _messageBtn.frame = CGRectMake(0, 0, 40, 47);
        [_messageBtn setImage:[UIImage imageNamed:@"icon-ld"] forState:UIControlStateNormal];
        _messageBtn.imageView.clipsToBounds = NO;
        _messageBtn.imageView.badgeCenterOffset = CGPointMake(-4, 5);
        [_messageBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
    
        [_messageBtn bk_whenTapped:^{
            if (self.messageBlock) {
                self.messageBlock();
            }
        }];
    }
    return _messageBtn;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
