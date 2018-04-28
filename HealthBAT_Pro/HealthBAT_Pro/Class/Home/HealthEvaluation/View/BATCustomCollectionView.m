//
//  BATCustomCollectionView.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/9/14.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATCustomCollectionView.h"

@implementation BATCustomCollectionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self nextResponder]touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self nextResponder]touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self nextResponder]touchesEnded:touches withEvent:event];
}

@end
