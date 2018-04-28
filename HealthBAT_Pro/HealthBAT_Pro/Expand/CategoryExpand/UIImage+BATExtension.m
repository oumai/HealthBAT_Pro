//
//  UIImage+BATExtension.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/1/17.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "UIImage+BATExtension.h"

@implementation UIImage (BATExtension)
-(void)imageWithCorner:(CGSize)size FillColor:(UIColor *)color complete:(void(^)(UIImage *))complete {

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       
        UIGraphicsBeginImageContextWithOptions(size, YES, 0);
        
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        
        [color setFill];
        
        UIRectFill(rect);
        
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
        
        [path addClip];
        
        [self drawInRect:rect];
        
        UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (complete != nil) {
                complete(result);
            }
        });
        
    });
}


-(UIImage *)imageWithCorner:(CGSize)size FillColor:(UIColor *)color {
    
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    [color setFill];
    
    UIRectFill(rect);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
    
    [path addClip];
    
    [self drawInRect:rect];
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    
    return result;
    
}
@end
