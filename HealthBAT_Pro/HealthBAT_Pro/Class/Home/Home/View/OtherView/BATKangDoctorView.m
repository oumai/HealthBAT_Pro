//
//  BATKangDoctorView.m
//  HealthBAT_Pro
//
//  Created by KM on 16/12/262016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATKangDoctorView.h"

@implementation BATKangDoctorView

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {

        self.kangDoctorImageView.frame = self.bounds;
        [self addSubview:self.kangDoctorImageView];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(kangDoctorViewTapped)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)kangDoctorViewTapped {

    if (self.tapped) {
        self.tapped();
    }
}

- (UIImageView *)kangDoctorImageView {

    if (!_kangDoctorImageView) {
        //DoctorKang_Blue
//        _kangDoctorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dabai4"]];
        _kangDoctorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Home_Doctor_Kang"]];
//        _kangDoctorImageView.clipsToBounds = YES;
        _kangDoctorImageView.contentMode = UIViewContentModeScaleAspectFit;

    }
    return _kangDoctorImageView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
