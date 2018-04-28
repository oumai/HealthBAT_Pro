//
//  BATRoundContentView.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/8/31.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATRoundContentView.h"

@implementation BATRoundContentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil) {
        for (UIView *subView in self.subviews) {
            CGPoint tp = [subView convertPoint:point fromView:self];
            if (CGRectContainsPoint(subView.bounds, tp)) {
                view = subView;
            }
//            else {
//                if (subView.subviews.count > 0) {
//                    for (UIView *aView in subView.subviews) {
//                        CGPoint tp = [aView convertPoint:point fromView:self];
//                        if (CGRectContainsPoint(aView.bounds, tp)) {
//                            view = subView;
//                        }
//                    }
//                }
//            }
        }
    }
    return view;
}
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    
//}
//- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    
//}
//- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    
//    
//}
@end
