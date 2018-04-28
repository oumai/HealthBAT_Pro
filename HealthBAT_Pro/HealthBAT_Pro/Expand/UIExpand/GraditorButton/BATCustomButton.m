//
//  BATCustomButton.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/4/11.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATCustomButton.h"

@implementation BATCustomButton

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    if (!CGRectIsEmpty(self.titleRect) && !CGRectEqualToRect(self.titleRect, CGRectZero)) {
        return self.titleRect;
    }
    return [super titleRectForContentRect:contentRect];
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    
    if (!CGRectIsEmpty(self.imageRect) && !CGRectEqualToRect(self.imageRect, CGRectZero)) {
        return self.imageRect;
    }
    return [super imageRectForContentRect:contentRect];
}

@end
