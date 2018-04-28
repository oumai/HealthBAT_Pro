//
//  ImageUtil.h
//  demodemo
//
//  Created by wangxun on 2017/10/22.
//  Copyright © 2017年 wangxun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

@interface ImageUtil : NSObject

//实现滤镜效果
+ (UIImage *)imageWithImage:(UIImage*)inImage withColorMatrix:(const float*)f;


@end

