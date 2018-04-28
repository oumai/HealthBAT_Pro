//
//  BATGroupAccouncementView.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/30.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATGroupAccouncementView.h"

@implementation BATGroupAccouncementView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    //设置cell的separator
    [self setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0];
}

#pragma mark - Action

#pragma mark - 加载数据
- (void)configrationData:(BATGroupAccouncementModel *)model
{
    if (model && model.Data.NoticeContent.length > 0) {
        _titleLabel.text = model.Data.NoticeContent;
    }
}

#pragma mark - 公告点击
- (IBAction)buttonAction:(id)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(groupAccouncementViewClicked:)]) {
        [_delegate groupAccouncementViewClicked:self];
    }
    
}
@end
