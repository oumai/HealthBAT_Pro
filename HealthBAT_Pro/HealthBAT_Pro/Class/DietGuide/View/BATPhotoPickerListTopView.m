//
//  BATPhotoPickerListTopView.m
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/10/23.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATPhotoPickerListTopView.h"

@implementation BATPhotoPickerListTopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib{
    [super awakeFromNib];
    
     self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
}
@end
