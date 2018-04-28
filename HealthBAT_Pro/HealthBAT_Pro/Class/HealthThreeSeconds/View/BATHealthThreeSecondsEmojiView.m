//
//  BATHealthThreeSecondsEmojiView.m
//  HealthBAT_Pro
//
//  Created by KM_MAC on 2017/12/12.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHealthThreeSecondsEmojiView.h"

#define kEmojiWH 20
#define kEmojiMargin 10

@implementation BATHealthThreeSecondsEmojiView
- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self commmonInit];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self commmonInit];
    }
    return self;
}
- (void)commmonInit{
    
    NSArray *emojiNorImageName = @[@"Expression4",@"Expression1",@"Expression2",@"Expression3",@"Expression5"];
    NSArray *emojiSelImageName =    @[@"Expression4_sel",@"Expression1_sel",@"Expression2_sel",@"Expression3_sel",@"Expression5_sel"];
    
    //心情状态,1.高兴,2.愉快,3.平和,4.低落,5.生气,0.未填写心情记录
    for (int i = 0; i<emojiNorImageName.count; i++) {
        
        UIButton *emojiButton = [UIButton buttonWithType:UIButtonTypeCustom];
        emojiButton.tag = i+1;
        [emojiButton addTarget:self action:@selector(emojiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [emojiButton setImage:[UIImage imageNamed:emojiNorImageName[i]] forState:UIControlStateNormal];
        [emojiButton setImage:[UIImage imageNamed:emojiSelImageName[i]] forState:UIControlStateSelected];
        
        [self addSubview:emojiButton];
        
    }
}
- (void)setSelIndex:(NSInteger)selIndex{
    
    UIButton *selBtn = [self viewWithTag:selIndex];
    selBtn.selected = YES;


}
- (void)emojiButtonClick:(UIButton *)selBtn{
    for (UIButton *btn in self.subviews) {
        btn.selected = selBtn.tag == btn.tag ? YES : NO;
    }
    
    if (self.emojiButtonBlock) {
        self.emojiButtonBlock(selBtn.tag);
    }
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    for (int i = 0; i<self.subviews.count; i++) {
        
        UIButton *btn = self.subviews[i];
        
        btn.frame = CGRectMake(i * (kEmojiWH+kEmojiMargin), (CGRectGetHeight(self.frame)-kEmojiWH)*0.5, kEmojiWH, kEmojiWH);
    }
    
}
@end
