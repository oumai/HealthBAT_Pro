//
//  BATPersonDetailFooterView.m
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/5/13.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATPersonDetailFooterView.h"
@interface BATPersonDetailFooterView ()
/** 顶部分割线 */
@property(nonatomic, strong)UIView *topLineView;
/** 中间分割线 */
@property(nonatomic, strong)UIView *centerLineView;
/** 私聊按钮 */
@property(nonatomic, strong)UIButton *chatButton;
@end
@implementation BATPersonDetailFooterView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.topLineView];
        [self addSubview:self.centerLineView];
        [self addSubview:self.focusButton];
        [self addSubview:self.chatButton];
        
    }
    return self;
}

#pragma mark - action 

- (void)focusButtonClick:(UIButton *)focusBtn{
    if (self.delegate && [self.delegate respondsToSelector:@selector(focusButtonDidClick:)]) {
        [self.delegate focusButtonDidClick:focusBtn];
    }
}

- (void)chatButtonClick:(UIButton *)chatBtn{
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatButtonDidClick:)]) {
        [self.delegate chatButtonDidClick:chatBtn];
    }
    
}

#pragma mark - lazy Load
- (UIView *)topLineView{
    if (!_topLineView) {
        _topLineView = [[UIView alloc]init];
        _topLineView.backgroundColor = UIColorFromHEX(0xe0e0e0, 1);
    }
    return _topLineView;
}
- (UIView *)centerLineView{
    if (!_centerLineView) {
        _centerLineView = [[UIView alloc]init];
        _centerLineView.backgroundColor = UIColorFromHEX(0xe0e0e0, 1);
    }
    return _centerLineView;
}

- (UIButton *)focusButton{
    if (!_focusButton) {
        _focusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_focusButton setImage:[UIImage imageNamed:@"person_gz_jiahao"] forState:UIControlStateNormal];
        [_focusButton setImage:[UIImage imageNamed:@"person_jgz_check"] forState:UIControlStateSelected];
        [_focusButton addTarget:self action:@selector(focusButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _focusButton;
}
- (UIButton *)chatButton{
    if (!_chatButton) {
        _chatButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chatButton setImage:[UIImage imageNamed:@"btn-sl"] forState:UIControlStateNormal];
        [_chatButton setImage:[UIImage imageNamed:@"btn-sl"] forState:UIControlStateSelected];
        _chatButton.backgroundColor = [UIColor whiteColor];
        [_chatButton addTarget:self action:@selector(chatButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chatButton;
}
#pragma mark - layoutSubviews
- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.topLineView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0.5);
    self.focusButton.frame =CGRectMake(0, 0.5, SCREEN_WIDTH/2-0.5, self.bounds.size.height-0.5);
    self.centerLineView.frame = CGRectMake(CGRectGetMaxX(self.focusButton.frame), 5, 1, 40);
    self.chatButton.frame = CGRectMake(CGRectGetMaxX(self.centerLineView.frame), 0.5, self.focusButton.bounds.size.width, self.bounds.size.height-0.5);
}
@end
