//
//  BATDoctorServeCell.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/4/1.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDoctorServeCell.h"

@interface BATDoctorServeCell()
@property (weak, nonatomic) IBOutlet UIView *chatView;
@property (weak, nonatomic) IBOutlet UIView *audioView;
@property (weak, nonatomic) IBOutlet UIView *videoView;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation BATDoctorServeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.lineView.backgroundColor = BASE_BACKGROUND_COLOR;
    
    self.chatTipsLb.textColor = UIColorFromHEX(0X333333, 1);
    self.AudioTipsLb.textColor = UIColorFromHEX(0X333333, 1);
    self.VideoTipsLb.textColor = UIColorFromHEX(0X333333, 1);
    
    self.chatContentLb.textColor = UIColorFromHEX(0Xff0000, 1);
    self.AudioContentLb.textColor = UIColorFromHEX(0Xff0000, 1);
    self.ViedoContentLb.textColor = UIColorFromHEX(0Xff0000, 1);
    
    UITapGestureRecognizer *chatTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(severAction:)];
    UITapGestureRecognizer *audioTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(severAction:)];
    UITapGestureRecognizer *videoTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(severAction:)];
    
    [self.chatView addGestureRecognizer:chatTap];
    [self.audioView addGestureRecognizer:audioTap];
    [self.videoView addGestureRecognizer:videoTap];
    

}

- (void)severAction:(UITapGestureRecognizer *)taper {

    if (self.SeverTapBlock) {
        self.SeverTapBlock(taper.view.tag);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
