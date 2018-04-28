//
//  BATPhotoPickerListCell.m
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/10/23.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATPhotoPickerListCell.h"

@implementation BATPhotoPickerListCell
- (void)awakeFromNib{
    
      [super awakeFromNib];
//    imageView.contentMode = UIViewContentModeScaleAspectFill;
     self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;
}
- (void)setSelected:(BOOL)selected{
    self.selectImageView.hidden = selected ? NO : YES;
    self.coverView.hidden = self.selectImageView.hidden;
}


@end
