//
//  BATConsultionNoContentView.m
//  HealthBAT_Pro
//
//  Created by four on 2017/5/5.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATConsultionNoContentView.h"

@interface BATConsultionNoContentView()
{
    CGFloat _commentBigHeight;  //scrollview实际高度
    CGFloat _commentFontPoor;
    CGFloat _commentIntervalHeight;
    CGFloat _commentBigDistance;
    CGFloat _commentImageWidth;
}
@end

@implementation BATConsultionNoContentView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        if (iPhone5) {
            _commentBigHeight = 250;
            _commentFontPoor = 3;
            _commentIntervalHeight = 10;
            _commentBigDistance = 50;
            _commentImageWidth = 60;
        }else if (iPhone6){
            _commentBigHeight = 330;
            _commentFontPoor = 0;
            _commentIntervalHeight = 0;
            _commentBigDistance = 70;
            _commentImageWidth = 90;
        }else{
            _commentBigHeight = 370;
            _commentFontPoor = 0;
            _commentIntervalHeight = 0;
            _commentBigDistance = 80;
            _commentImageWidth = 90;
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
    
    CGSize titleSize = [self.descLabel.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : self.descLabel.titleLabel.font}];
    CGFloat allWidth = (SCREEN_WIDTH - 90 - 33 - 10 - titleSize.width)/2.0;
    DDLogInfo(@"%f",allWidth);
    
    [self addSubview:self.bgView];
    
    [self addSubview:self.consultLable];
    [self.consultLable mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(self.mas_top).offset(_commentBigDistance);
        make.centerX.equalTo(self.bgView.mas_centerX).offset(0);
        [self.consultLable sizeToFit];
    }];
    
    [self addSubview:self.doctorIconView];
    [self.doctorIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(self.consultLable.mas_bottom).offset(28 - _commentIntervalHeight);
        make.centerX.equalTo(self.bgView.mas_centerX).offset(0);
        make.height.width.mas_equalTo(_commentImageWidth);
    }];
    
    //文字分割线
    [self addSubview:self.topLine];
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right).offset(-20);
        make.top.equalTo(self.doctorIconView.mas_bottom).offset(24);
        make.height.mas_equalTo(0.5);
    }];
    
    [self addSubview:self.consultionIcon];
    [self.consultionIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.mas_left).offset(allWidth);
        make.top.equalTo(self.topLine.mas_bottom).offset(15);
        make.width.mas_equalTo(33);
        make.height.mas_equalTo(37.5);
    }];
    
    [self addSubview:self.descLabel];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.consultionIcon.mas_right).offset(5);
        make.centerY.equalTo(self.consultionIcon.mas_centerY).offset(0);
    }];
    
    [self addSubview:self.ellipsisLabel];
    [self.ellipsisLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.descLabel.mas_right).offset(1);
        make.bottom.equalTo(self.descLabel.mas_bottom).offset(-4);
    }];
    
    //文字分割线
    [self addSubview:self.bottomLine];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right).offset(-20);
        make.top.equalTo(self.consultionIcon.mas_bottom).offset(15);
        make.height.mas_equalTo(0.5);
    }];
}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH - 90, _commentBigHeight)];
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

- (UILabel *)consultLable{
    if (!_consultLable) {
        _consultLable = [[UILabel alloc]initWithFrame:CGRectZero];
        _consultLable.text = @"咨询医生";
        _consultLable.font = [UIFont systemFontOfSize:18];
        _consultLable.textColor = UIColorFromRGB(51, 51, 51, 1);
        _consultLable.textAlignment = NSTextAlignmentCenter;
    }
    return _consultLable;
}

- (UIImageView *)doctorIconView{
    if (!_doctorIconView) {
        _doctorIconView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _doctorIconView.clipsToBounds = YES;
        _doctorIconView.layer.cornerRadius = _commentImageWidth/2.0;
        _doctorIconView.image = [UIImage imageNamed:@"BAT_default_doctor"];
    }
    return _doctorIconView;
}


- (UIView *)topLine{
    if (!_topLine) {
        _topLine = [[UIView alloc] initWithFrame:CGRectZero];
        _topLine.backgroundColor = BASE_LINECOLOR;
    }
    return _topLine;
}


- (UIImageView *)consultionIcon{
    if (!_consultionIcon) {
        _consultionIcon = [[UIImageView alloc]initWithFrame:CGRectZero];
        _consultionIcon.image = [UIImage imageNamed:@"icon-zxys-1"];
    }
    return _consultionIcon;
}


- (BATGraditorButton *)descLabel{
    if (!_descLabel) {
        _descLabel = [[BATGraditorButton alloc]initWithFrame:CGRectZero];
        [_descLabel setTitle:@"值班医生正在为您服务" forState:UIControlStateNormal] ;
        _descLabel.enbleGraditor = YES;
        _descLabel.titleLabel.font = [UIFont systemFontOfSize:18 - _commentFontPoor];
        [_descLabel setGradientColors:@[START_COLOR,END_COLOR]];
    }
    return _descLabel;
}

- (UIView *)bottomLine{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomLine.backgroundColor = BASE_LINECOLOR;
    }
    return _bottomLine;
}



- (UILabel *)ellipsisLabel{
    if (!_ellipsisLabel) {
        _ellipsisLabel = [[UILabel alloc] init];
        _ellipsisLabel.textColor = END_COLOR;
        _ellipsisLabel.font = [UIFont systemFontOfSize:18 - _commentFontPoor];
        _ellipsisLabel.textAlignment = NSTextAlignmentLeft;
        _ellipsisLabel.text = @"...";
    }
    return _ellipsisLabel;
}
@end
