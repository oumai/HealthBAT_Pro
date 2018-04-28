//
//  PGIndexBannerSubiew.m
//  NewPagedFlowViewDemo
//
//  Created by Mars on 16/6/18.
//  Copyright © 2016年 Mars. All rights reserved.
//  Designed By PageGuo,
//  QQ:799573715
//  github:https://github.com/PageGuo/NewPagedFlowView

#import "PGIndexBannerSubiew.h"
@interface PGIndexBannerSubiew ()
{
    CGFloat _commentBigDistance;
    CGFloat _commentSmallDistance;
    CGFloat _commentFontPoor;
    CGFloat _commentHeight;
    CGFloat _commentProportion;
}
@end

@implementation PGIndexBannerSubiew

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        if (iPhone5) {
            _commentSmallDistance = 10;
            _commentFontPoor = 6;
            _commentBigDistance = 40;
            _commentHeight = 25;
            _commentProportion = 1.5;
        }else if (iPhone6){
            _commentSmallDistance = 10;
            _commentFontPoor = 0;
            _commentBigDistance = 60;
            _commentHeight = 40;
            _commentProportion = 1.2;
        }else{
            _commentSmallDistance = 15;
            _commentFontPoor = 0;
            _commentBigDistance = 60;
            _commentHeight = 40;
            _commentProportion = 1;
        }
        
        [self layout];
    }
    
    return self;
}

//自己画路径作为阴影路径
- (CGPathRef)fancyShadowForRect:(CGRect)rect
{
    CGSize size = rect.size;
    UIBezierPath* path = [UIBezierPath bezierPath];
    
    //right
    [path moveToPoint:CGPointMake(-1,-1)];
    [path addLineToPoint:CGPointMake(size.width + 1, -1)];
    [path addLineToPoint:CGPointMake(size.width + 1, size.height)];
    [path addLineToPoint:CGPointMake(size.width - 15, size.height)];
    [path addLineToPoint:CGPointMake(size.width - 15, size.height + 10)];
    [path addLineToPoint:CGPointMake(15, size.height + 10)];
    [path addLineToPoint:CGPointMake(15, size.height)];
    [path addLineToPoint:CGPointMake(-1, size.height)];
    
    [path closePath];
    [path fill];
    
    return path.CGPath;
}

- (void)layout{
    WEAK_SELF(self);
    
    [self addSubview:self.bgView];
    
    [self addSubview:self.topBlueView];
    [self.topBlueView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(self.mas_top).offset(10);
        make.left.equalTo(self).offset(5);
//        make.right.equalTo(self).offset(-5);
        make.width.mas_equalTo(self.bounds.size.width - 10);
//        [self.topBlueView sizeToFit];
        make.height.mas_offset(_commentHeight);
    }];
    
    [self addSubview:self.remindLabel];
    [self.remindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
//        make.top.equalTo(self.mas_top).offset(10);
        make.centerX.equalTo(self.mas_centerX).offset(0);
        make.centerY.equalTo(self.topBlueView.mas_centerY).offset(0);
        make.width.mas_equalTo(self.bounds.size.width - 10 - 20);
        [self.remindLabel sizeToFit];
    }];
    
    [self addSubview:self.consultLable];
    [self.consultLable mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
//        make.top.equalTo(self.topBlueView.mas_bottom).offset(32.5);
        make.top.equalTo(self.mas_top).offset(_commentBigDistance);
        make.centerX.equalTo(self.mas_centerX).offset(0);
        make.width.mas_equalTo(self.bounds.size.width - 10 - 20);
        [self.consultLable sizeToFit];
    }];
    
    [self addSubview:self.consultTimeLable];
    [self.consultTimeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(self.consultLable.mas_bottom).offset(_commentSmallDistance);
        make.centerX.equalTo(self.mas_centerX).offset(0);
        make.width.mas_equalTo(self.bounds.size.width - 10 - 20);
        [self.consultTimeLable sizeToFit];
        
    }];
    
    //咨询时间医生信息分割线
    UIView *dividerLine = [[UIView alloc]initWithFrame:CGRectZero];
    dividerLine.backgroundColor = BASE_BACKGROUND_COLOR;
    [self addSubview:dividerLine];
    [dividerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.mas_left).offset(40);
        make.right.equalTo(self.mas_right).offset(-40);
        make.top.equalTo(self.consultTimeLable.mas_bottom).offset(10);
        make.height.mas_equalTo(0.5);
    }];
    
    [self addSubview:self.doctorIconView];
    [self.doctorIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(self.consultTimeLable.mas_bottom).offset(20);
        make.left.equalTo(self.mas_left).offset(15);
        make.height.width.mas_equalTo(45);
    }];
    
    [self addSubview:self.doctorNameLabel];
    [self.doctorNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.doctorIconView.mas_right).offset(5);
        make.centerY.equalTo(self.doctorIconView.mas_centerY).offset(0);
        [self.doctorNameLabel sizeToFit];
    }];
    
    [self addSubview:self.countDownTimeLabel];
    [self.countDownTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.right.equalTo(self.topBlueView.mas_right).offset(-10);
        make.centerY.equalTo(self.doctorIconView.mas_centerY).offset(0);
        [self.countDownTimeLabel sizeToFit];
    }];
    
    [self addSubview:self.countDownLabel];
    [self.countDownLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.right.equalTo(self.countDownTimeLabel.mas_left).offset(-2);
        make.centerY.equalTo(self.doctorIconView.mas_centerY).offset(0);
        [self.countDownLabel sizeToFit];
    }];
    
    //文字顶部线
    UIView *topLine = [[UIView alloc]initWithFrame:CGRectZero];
    topLine.backgroundColor = BASE_BACKGROUND_COLOR;;
    [self addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right).offset(-20);
        make.top.equalTo(self.doctorIconView.mas_bottom).offset(10);
        make.height.mas_equalTo(0.5);
    }];
    
    [self addSubview:self.describeLabel];
    [self.describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.mas_left).offset(15);
//        make.right.equalTo(self.mas_right).offset(-20);
        make.width.mas_equalTo(self.bounds.size.width - 10 - 20);
        make.top.equalTo(topLine.mas_bottom).offset(5);
        [self.describeLabel sizeToFit];
    }];
    
    //文字分割线
    [self addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right).offset(-20);
        make.centerY.equalTo(self.describeLabel.mas_centerY).offset(0);
        make.height.mas_equalTo(0.5);
    }];
    
    //文字底部线
    UIView *bottpmLine = [[UIView alloc]initWithFrame:CGRectZero];
    bottpmLine.backgroundColor = BASE_BACKGROUND_COLOR;;
    [self addSubview:bottpmLine];
    [bottpmLine mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right).offset(-20);
        make.top.equalTo(self.describeLabel.mas_bottom).offset(5);
        make.height.mas_equalTo(0.5);
    }];
    
    [self addSubview:self.remindView];
    [self.remindView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerX.equalTo(self.mas_centerX).offset(0);
        make.bottom.equalTo(self.bgView.mas_bottom).offset(-15);
        make.height.mas_equalTo(30/_commentProportion);
        make.width.mas_equalTo(100/_commentProportion);
    }];

}

- (UIImageView *)mainImageView {
    
    if (_mainImageView == nil) {
        _mainImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, self.bounds.size.width - 10, self.bounds.size.height - 20)];
        _mainImageView.userInteractionEnabled = YES;
        _mainImageView.hidden = YES;
        
    }
    return _mainImageView;
}

- (UIView *)coverView {
    if (_coverView == nil) {
        _coverView = [[UIView alloc] initWithFrame:self.bounds];
        _coverView.backgroundColor = [UIColor blackColor];
    }
    return _coverView;
}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(5, 10, self.bounds.size.width - 10, self.bounds.size.height - 20)];
        _bgView.backgroundColor = [UIColor whiteColor];
        
        //添加阴影
        CALayer *layer = _bgView.layer;
        layer.shadowOffset = CGSizeZero;
        layer.shadowRadius = 2.0f;
        layer.shadowOpacity = 1.f;
        layer.shadowColor = [UIColorFromRGB(225, 234, 242, 1) CGColor];
        _bgView.layer.shadowPath = [self fancyShadowForRect:layer.bounds];
    }
    return _bgView;
}

- (UIImageView *)topBlueView{
    if (!_topBlueView) {
        _topBlueView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _topBlueView.image = [UIImage imageNamed:@"img-bh"];
        _topBlueView.hidden = YES;
    }
    return _topBlueView;
}

- (UILabel *)remindLabel{
    if (!_remindLabel) {
        _remindLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _remindLabel.text = @"您有新的咨询消息";
        _remindLabel.textColor = [UIColor whiteColor];
        _remindLabel.font = [UIFont systemFontOfSize:20-_commentFontPoor];
        _remindLabel.textAlignment = NSTextAlignmentCenter;
        _remindView.hidden = YES;
    }
    return _remindLabel;
}

- (UILabel *)consultLable{
    if (!_consultLable) {
        _consultLable = [[UILabel alloc]initWithFrame:CGRectZero];
        _consultLable.text = @"咨询时间";
        _consultLable.font = [UIFont systemFontOfSize:18-_commentFontPoor];
        _consultLable.textColor = UIColorFromRGB(51, 51, 51, 1);
        _consultLable.textAlignment = NSTextAlignmentCenter;
    }
    return _consultLable;
}

- (BATGraditorButton *)consultTimeLable{
    if (!_consultTimeLable) {
        _consultTimeLable = [[BATGraditorButton alloc]initWithFrame:CGRectZero];
        [_consultTimeLable setTitle:@"1月1号 00:00" forState:UIControlStateNormal] ;
        _consultTimeLable.enbleGraditor = YES;
        _consultTimeLable.titleLabel.font = [UIFont systemFontOfSize:30 - _commentFontPoor];
        [_consultTimeLable setGradientColors:@[START_COLOR,END_COLOR]];
        _consultTimeLable.userInteractionEnabled = NO;
    }
    return _consultTimeLable;
}

- (UIImageView *)doctorIconView{
    if (!_doctorIconView) {
        _doctorIconView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _doctorIconView.clipsToBounds = YES;
        _doctorIconView.layer.cornerRadius = 22.5f;
        _doctorIconView.image = [UIImage imageNamed:@"BAT_default_doctor"];
    }
    return _doctorIconView;
}

- (UILabel *)doctorNameLabel{
    if (!_doctorNameLabel) {
        _doctorNameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _doctorNameLabel.text = @"医生";
        _doctorNameLabel.font = [UIFont systemFontOfSize:18-_commentFontPoor];
        _doctorNameLabel.textColor = UIColorFromRGB(51, 51, 51, 1);
        _doctorNameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _doctorNameLabel;
}

- (UILabel *)countDownLabel{
    if (!_countDownLabel) {
        _countDownLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _countDownLabel.text = @"倒计时";
        _countDownLabel.font = [UIFont systemFontOfSize:18-_commentFontPoor];
        _countDownLabel.textColor = UIColorFromRGB(252, 90, 90, 1);
        _countDownLabel.textAlignment = NSTextAlignmentRight;
    }
    return _countDownLabel;
}

- (UILabel *)countDownTimeLabel{
    if (!_countDownTimeLabel) {
        _countDownTimeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _countDownTimeLabel.text = @"24:00";
        _countDownTimeLabel.font = [UIFont systemFontOfSize:18-_commentFontPoor];
        _countDownTimeLabel.textColor = UIColorFromRGB(252, 90, 90, 1);
        _countDownTimeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _countDownTimeLabel;
}

- (MZTimerLabel *)countMZTimeLabel{
    if (!_countMZTimeLabel) {
        _countMZTimeLabel = [[MZTimerLabel alloc] initWithLabel:self.countDownTimeLabel andTimerType:MZTimerLabelTypeTimer];
        _countMZTimeLabel.timeFormat = @"HH:mm";
    }
    return _countMZTimeLabel;
}

- (UILabel *)describeLabel{
    if (!_describeLabel) {
        _describeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _describeLabel.text = @"主诉：暂无描述信息1暂无描述信息2暂无描述信息3暂无描述信息4暂无描述信息5暂无描述信息6暂无描述信息7";
        _describeLabel.font = [UIFont systemFontOfSize:18-_commentFontPoor];
        _describeLabel.textColor = UIColorFromRGB(51, 51, 51, 1);
        _describeLabel.textAlignment = NSTextAlignmentLeft;
        _describeLabel.backgroundColor = [UIColor whiteColor];
        _describeLabel.numberOfLines = 2;
    }
    return _describeLabel;
}

- (UIView *)line{
    if (!_line) {
        _line = [[UIView alloc] initWithFrame:CGRectZero];
        _line.backgroundColor = BASE_LINECOLOR;
    }
    return _line;
}

- (UIImageView *)remindView{
    if (!_remindView) {
        _remindView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _remindView.hidden = NO;
        _remindView.userInteractionEnabled = YES;
        _remindView.image = [UIImage imageNamed:@"but-txhf"];
        [_remindView bk_whenTapped:^{
            if (self.remindViewClick) {
                self.remindViewClick();
            }
        }];
    }
    return _remindView;
}
@end
