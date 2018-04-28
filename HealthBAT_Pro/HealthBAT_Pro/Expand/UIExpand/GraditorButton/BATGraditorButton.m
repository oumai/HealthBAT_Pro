//
//  testBtn.m
//  textttt
//
//  Created by kmcompany on 2017/5/4.
//  Copyright © 2017年 kmcompany. All rights reserved.
//

#import "BATGraditorButton.h"

@interface BATGraditorButton()

//@property (nonatomic,strong) NSArray *gradientColors;
{
    NSArray *_gradientColors; //存储渐变色数组
}

@end

@implementation BATGraditorButton

- (void)setGradientColors:(NSArray<UIColor *> *)colors {
    _gradientColors = [NSArray arrayWithArray:colors];
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (_gradientColors) {
        [self setTitleGradientColors:_gradientColors Rect:rect];
    }
}

- (void)setTitleGradientColors:(NSArray<UIColor *> *)colors Rect:(CGRect)rect {
    if (colors.count == 1) { //只有一种颜色，直接上色
        [self setTitleColor:colors[0] forState:UIControlStateNormal];
    } else {
        //有多种颜色，需要渐变层对象来上色
        //创建渐变层对象
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        //设置渐变层的frame等同于titleLabel属性的frame（这里高度有个小误差，补上就可以了）
        gradientLayer.frame = CGRectMake(0, 0, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);
        //将存储的渐变色数组（UIColor类）转变为CAGradientLayer对象的colors数组，并设置该数组为CAGradientLayer对象的colors属性
        NSMutableArray *gradientColors = [NSMutableArray array];
        for (UIColor *colorItem in colors) {
            [gradientColors addObject:(id)colorItem.CGColor];
        }
        
        /*这段是设置文字的渐变*/
        gradientLayer.colors = [NSArray arrayWithArray:gradientColors];
        gradientLayer.locations=@[@0.0,@1.0];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(1, 0);
        
        UIImage *gradientImage = [self imageFromLayer:gradientLayer];
        
        //是否需要自定义字体颜色
        if (!self.titleColor) {
            [self setTitleColor:[UIColor colorWithPatternImage:gradientImage] forState:UIControlStateNormal];
        }else {
            [self setTitleColor:self.titleColor forState:UIControlStateNormal];
        }
        
        
        /*------------------------------------------------------------------------*/
        //self.enbleGraditor 由外部传入，设置是否需要渐变层，默认是bool值是NO，这里取反为一般情况，有需要再由外部传入YES取消渐变层
        if (!self.enbleGraditor) {
            //这个是设置第一层背景色
            CAGradientLayer *gradient = [CAGradientLayer layer];
            gradient.frame = self.bounds;
            gradient.locations=@[@0.0,@1.0];
            gradient.startPoint = CGPointMake(0, 0);
            gradient.endPoint = CGPointMake(1, 0);
            
            gradient.colors = [NSArray arrayWithObjects:gradientColors[0], gradientColors[1], nil];
            
            
            
            //第二层添加到第一层上面去，形成镂空效果
            if (!self.enablehollowOut) {
                
                UIColor *foregroundColor = [UIColor whiteColor];
                if (self.customColor) {
                    foregroundColor = self.customColor;
                }
                
                CGFloat cornerRadius = 5.0f;
                if (self.customCornerRadius) {
                    cornerRadius = self.customCornerRadius;
                }
                
                //这个是设置第二层背景色
                CAGradientLayer *gradient11 = [CAGradientLayer layer];
                if (self.isDeleteBorder == YES) {
                    gradient11.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
                }
                else {
                    gradient11.frame = CGRectMake(0.5, 0.5, rect.size.width-1, rect.size.height - 1);
                }
                gradient11.colors = [NSArray arrayWithObjects:(id)[foregroundColor CGColor], (id)[foregroundColor CGColor], nil];
                gradient11.cornerRadius = cornerRadius;
                gradient11.masksToBounds = YES;
                
                [gradient addSublayer:gradient11];
            }
            
            
            [self.layer insertSublayer:gradient atIndex:0];
        }
       
        
        
    }
}

//将一个CALayer对象绘制到一个UIImage对象上，并返回这个UIImage对象
- (UIImage *)imageFromLayer:(CALayer *)layer {
    UIGraphicsBeginImageContextWithOptions(layer.frame.size, layer.opaque, 0);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return outputImage;
}



@end
