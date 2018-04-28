//
//  BATHealthyInfoButton.m
//  HealthBAT_Pro
//
//  Created by 黄帆 on 2017/12/15.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHealthyInfoButton.h"

@implementation BATHealthyInfoButton

+(instancetype)buttonWithType:(UIButtonType)buttonType{
    BATHealthyInfoButton *ccButton = [super buttonWithType:buttonType];
    if (ccButton) {
        ccButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        // 开启button的imageView的剪裁属性，根据imageView的contentMode属性选择是否开启
        ccButton.imageView.layer.masksToBounds = YES;
        ccButton.layer.masksToBounds = YES;
    }
    return ccButton;
}

// 该自定义button的背景和内容view都和它的frame一样大，所以可以不用重写-(CGRect)backgroundRectForBounds:(CGRect)bounds和-(CGRect)contentRectForBounds:(CGRect)bounds这两个函数
//// 返回标题边界
//-(CGRect)titleRectForContentRect:(CGRect)contentRect{
//    // 这contentRect就是button的frame，我们返回标题view宽和button相同，高为20，在button的底部
//    return CGRectMake(0, contentRect.size.height-20, contentRect.size.width, 20);
//}
//// 返回图片边界
//-(CGRect)imageRectForContentRect:(CGRect)contentRect{
//    // button的image view 是正方形，由于title占了20的高了，所以取height - 20和width中最小的值作为image view的边长
//    // 如果图片的位置是根据文字来布局的，这里可以通过self.titleLabel.text拿到title，再计算出图片的位置
//    CGFloat imageWidth = MIN(contentRect.size.height - 20, contentRect.size.width);
//    return CGRectMake(contentRect.size.width/2 - imageWidth/2, 0, imageWidth, imageWidth);
//}
//

@end
