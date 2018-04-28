//
//  BATFreeClinicDoctorSubview.m
//  HealthBAT_Pro
//
//  Created by wct on 2017/12/13.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATFreeClinicDoctorSubview.h"

@interface BATFreeClinicDoctorSubview ()
{
    CGFloat _commentBigDistance;
    CGFloat _commentSmallDistance;
    CGFloat _commentFontPoor;
    CGFloat _commentImageWidth;
//    CGFloat _commentHeight;
//    CGFloat _commentProportion;
}
@end


@implementation BATFreeClinicDoctorSubview

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        if (iPhone5) {
            _commentSmallDistance = 10;
            _commentFontPoor = 6;
            _commentBigDistance = 30;
            _commentImageWidth = 60;
//            _commentHeight = 25;
//            _commentProportion = 1.5;
        }else if (iPhone6){
            _commentSmallDistance = 10;
            _commentFontPoor = 1;
            _commentBigDistance = 40;
            _commentImageWidth = 90;
//            _commentHeight = 40;
//            _commentProportion = 1.2;
        }else{
            _commentSmallDistance = 20;
            _commentFontPoor = 0;
            _commentBigDistance = 50;
            _commentImageWidth = 90;
//            _commentHeight = 40;
//            _commentProportion = 1;
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
    
    [self addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(self.bgView.mas_top).offset(0);
        make.right.equalTo(self.bgView.mas_right).offset(0);
        make.height.width.mas_equalTo(_commentImageWidth/3*2);
    }];
    
    [self addSubview:self.doctorIconView];
    [self.doctorIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(self.bgView.mas_top).offset(_commentBigDistance);
        make.centerX.equalTo(self.mas_centerX).offset(0);
        make.height.width.mas_equalTo(_commentImageWidth);
    }];
    
    [self addSubview:self.doctorNameLabel];
    [self.doctorNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerX.equalTo(self.mas_centerX).offset(0);
        make.top.equalTo(self.doctorIconView.mas_bottom).offset(20);
        [self.doctorNameLabel sizeToFit];
    }];
    
    [self addSubview:self.deptLabel];
    [self.deptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerX.equalTo(self.mas_centerX).offset(0);
        make.top.equalTo(self.doctorNameLabel.mas_bottom).offset(10);
        [self.deptLabel sizeToFit];
    }];
    
    [self addSubview:self.countLabel];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerX.equalTo(self.mas_centerX).offset(0);
        make.top.equalTo(self.deptLabel.mas_bottom).offset(10);
        [self.countLabel sizeToFit];
    }];

    //咨询时间信息分割线
    UIView *dividerLine = [[UIView alloc]initWithFrame:CGRectZero];
    dividerLine.backgroundColor = BASE_BACKGROUND_COLOR;
    [self addSubview:dividerLine];
    [dividerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.mas_left).offset(40);
        make.right.equalTo(self.mas_right).offset(-40);
        make.top.equalTo(self.countLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(0.5);
    }];
    
    [self addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerX.equalTo(self.mas_centerX).offset(0);
        make.top.equalTo(dividerLine.mas_bottom).offset(_commentSmallDistance);
        [self.timeLabel sizeToFit];
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

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _imageView.image = [UIImage imageNamed:@"img-jryz"];
    }
    return _imageView;
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

//- (UILabel *)doctorNameLabel{
//    if (!_doctorNameLabel) {
//        _doctorNameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
//        _doctorNameLabel.text = @"医生";
//        _doctorNameLabel.font = [UIFont systemFontOfSize:18-_commentFontPoor];
//        _doctorNameLabel.textColor = UIColorFromRGB(51, 51, 51, 1);
//        _doctorNameLabel.textAlignment = NSTextAlignmentLeft;
//    }
//    return _doctorNameLabel;
//}

- (BATGraditorButton *)doctorNameLabel{
    if (!_doctorNameLabel) {
        _doctorNameLabel = [[BATGraditorButton alloc]initWithFrame:CGRectZero];
        [_doctorNameLabel setTitle:@"王医生 主治医生" forState:UIControlStateNormal] ;
        _doctorNameLabel.enbleGraditor = YES;
        _doctorNameLabel.titleLabel.font = [UIFont systemFontOfSize:25 - _commentFontPoor];
        [_doctorNameLabel setGradientColors:@[START_COLOR,END_COLOR]];
        _doctorNameLabel.userInteractionEnabled = NO;
    }
    return _doctorNameLabel;
}

- (UILabel *)deptLabel{
    if (!_deptLabel) {
        _deptLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _deptLabel.text = @"全科";
        _deptLabel.font = [UIFont systemFontOfSize:18-_commentFontPoor];
        _deptLabel.textColor = UIColorFromHEX(0x666666, 1);
        _deptLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _deptLabel;
}

- (UILabel *)countLabel{
    if (!_countLabel) {
        _countLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _countLabel.text = @"义诊次数10/10";
        _countLabel.font = [UIFont systemFontOfSize:18-_commentFontPoor];
        _countLabel.textColor = UIColorFromHEX(0x666666, 1);
        _countLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _countLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _timeLabel.text = @"坐诊时间：8:30-17:00";
        _timeLabel.font = [UIFont systemFontOfSize:18-_commentFontPoor];
        _timeLabel.textColor = UIColorFromHEX(0x666666, 1);
        _timeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _timeLabel;
}

@end
