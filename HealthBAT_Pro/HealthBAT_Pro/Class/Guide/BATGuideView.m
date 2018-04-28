//
//  BATGuideView.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 16/10/12.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATGuideView.h"

@implementation BATGuideView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame {
  self =  [super initWithFrame:frame];

    self.showsHorizontalScrollIndicator = NO;
    self.pagingEnabled = YES;
    self.bounces = NO;

    self.contentSize = CGSizeMake(SCREEN_WIDTH*4, SCREEN_HEIGHT);
    

//#define iPhone4   (([UIScreen mainScreen].currentMode.size.height) == 960?YES:NO)
//#define iPhone5   (([UIScreen mainScreen].currentMode.size.height) == 1136?YES:NO)
//#define iPhone6   (([UIScreen mainScreen].currentMode.size.height) == 1334?YES:NO)
//    //最新iPhone7系列和6系列两款屏幕一样大小
//#define iPhone6p  (([UIScreen mainScreen].currentMode.size.height) == 1920?YES:NO)
    
    NSString *photoName = nil;
    if (SCREEN_HEIGHT == 480) {
        photoName = @"4s";
    }else if (SCREEN_HEIGHT == 568) {
        photoName = @"5s";
    }else if (SCREEN_HEIGHT == 667) {
        photoName = @"6";
    }else {
        photoName = @"6p";
    }

    for (int i=0; i<4; i++) {
        UIImageView *guidePic =[[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"Guide_%zd_%@",i+1,photoName]]];
        guidePic.frame = CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [self addSubview:guidePic];
        
        if (i==3) {
            guidePic.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissAction:)];
            [guidePic addGestureRecognizer:tap];
        }
    }
    return self;
}

-(void)dismissAction:(UITapGestureRecognizer *)tap {
    [UIView animateWithDuration:1 animations:^{
        tap.view.superview.alpha = 0;
    } completion:^(BOOL finished) {
        [tap.view.superview removeFromSuperview];
    }];
}

@end
