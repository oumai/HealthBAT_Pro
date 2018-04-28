//
//  UIImage+BATExtension.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/1/17.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (BATExtension)
-(void)imageWithCorner:(CGSize)size FillColor:(UIColor *)color complete:(void(^)(UIImage *))complete;

-(UIImage *)imageWithCorner:(CGSize)size FillColor:(UIColor *)color;
@end
