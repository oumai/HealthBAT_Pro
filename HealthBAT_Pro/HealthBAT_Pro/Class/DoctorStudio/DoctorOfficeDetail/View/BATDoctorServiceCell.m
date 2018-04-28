//
//  BATDoctorServiceCell.m
//  HealthBAT_Pro
//
//  Created by four on 2017/5/8.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDoctorServiceCell.h"

@implementation BATDoctorServiceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self layoutPages];
    }

    return self;
}

- (void)severAction:(UITapGestureRecognizer *)taper {
    
    if (self.SeverTapBlock) {
        self.SeverTapBlock(taper.view.tag);
    }
    
    if (taper.view == self.chatClickBG) {
        self.chatBG.hidden = NO;
        self.audioBG.hidden = YES;
        self.videoBG.hidden = YES;
    }else if (taper.view == self.audioClickBG){
        self.chatBG.hidden = YES;
        self.audioBG.hidden = NO;
        self.videoBG.hidden = YES;
    }else{
        self.chatBG.hidden = YES;
        self.audioBG.hidden = YES;
        self.videoBG.hidden = NO;
    }
}


- (void)layoutPages{
    
    WEAK_SELF(self);
    
    CGFloat widthBG = (SCREEN_WIDTH - 40)/3.0;

    [self.contentView addSubview:self.chatBG];
    [self.chatBG mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.width.mas_equalTo(widthBG);
        make.bottom.equalTo(@-10);
    }];

    [self.contentView addSubview:self.audioBG];
    [self.audioBG mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.width.mas_equalTo(widthBG);
        make.bottom.equalTo(@-10);
    }];
    
    [self.contentView addSubview:self.videoBG];
    [self.videoBG mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.width.mas_equalTo(widthBG);
        make.bottom.equalTo(@-10);
    }];
    
    [self.contentView addSubview:self.chatImage];
    [self.chatImage mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(self.chatBG.mas_top).offset(12);
        make.centerX.equalTo(self.chatBG.mas_centerX);
        make.width.height.mas_equalTo(35);
    }];
    
    [self.contentView addSubview:self.chatTipicLb];
    [self.chatTipicLb mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(self.chatImage.mas_bottom).offset(10 - 5);
        make.centerX.equalTo(self.chatBG.mas_centerX);
        [self.chatTipicLb sizeToFit];
        
    }];
    
    [self.contentView addSubview:self.chatContentLb];
    [self.chatContentLb mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(self.chatTipicLb.mas_bottom).offset(9 - 10);
        make.centerX.equalTo(self.chatBG.mas_centerX);
        [self.chatContentLb sizeToFit];
    }];
    
    [self.contentView addSubview:self.audioimage];
    [self.audioimage mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(self.audioBG.mas_top).offset(12);
        make.centerX.equalTo(self.audioBG.mas_centerX);
        make.width.mas_equalTo(35*43/60.0);
        make.height.mas_offset(35);
    }];
    
    [self.contentView addSubview:self.AudioTipicLb];
    [self.AudioTipicLb mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(self.audioimage.mas_bottom).offset(10 - 5);
        make.centerX.equalTo(self.audioBG.mas_centerX);
        [self.AudioTipicLb sizeToFit];
    }];
    
    [self.contentView addSubview:self.AudioContentLb];
    [self.AudioContentLb mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(self.AudioTipicLb.mas_bottom).offset(9 - 10);
        make.centerX.equalTo(self.audioBG.mas_centerX);
        [self.AudioContentLb sizeToFit];
    }];
    
    [self.contentView addSubview:self.videoImage];
    [self.videoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(self.videoBG.mas_top).offset(12);
        make.centerX.equalTo(self.videoBG.mas_centerX);
        make.width.height.mas_equalTo(35);
    }];
    
    [self.contentView addSubview:self.VideoTipicLb];
    [self.VideoTipicLb mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(self.videoImage.mas_bottom).offset(10 - 5);
        make.centerX.equalTo(self.videoBG.mas_centerX);
        [self.VideoTipicLb sizeToFit];
    }];
    
    [self.contentView addSubview:self.ViedoContentLb];
    [self.ViedoContentLb mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(self.VideoTipicLb.mas_bottom).offset(9 - 10);
        make.centerX.equalTo(self.videoBG.mas_centerX);
        [self.ViedoContentLb sizeToFit];
    }];
    
    
    [self.contentView addSubview:self.chatClickBG];
    [self.chatClickBG mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.right.top.bottom.height.width.equalTo(self.chatBG);
    }];
    
    [self.contentView addSubview:self.audioClickBG];
    [self.audioClickBG mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.right.top.bottom.height.width.equalTo(self.audioBG);
    }];
    
    [self.contentView addSubview:self.videoClickBG];
    [self.videoClickBG mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.right.top.bottom.height.width.equalTo(self.videoBG);
    }];

}


- (UIImageView *)chatBG{
    if (!_chatBG) {
        _chatBG = [[UIImageView alloc]init];
        _chatBG.image = [UIImage imageNamed:@"bg-dj"];
        _chatBG.layer.cornerRadius = 2;
        _chatBG.hidden = NO;
    }
    
    return _chatBG;
}

- (UIImageView *)audioBG{
    if (!_audioBG) {
        _audioBG = [[UIImageView alloc]init];
        _audioBG.image = [UIImage imageNamed:@"bg-dj"];
        _audioBG.layer.cornerRadius = 2;
        _audioBG.hidden = YES;
    }
    
    return _audioBG;
}

- (UIImageView *)videoBG{
    if (!_videoBG) {
        _videoBG = [[UIImageView alloc]init];
        _videoBG.image = [UIImage imageNamed:@"bg-dj"];
        _videoBG.layer.cornerRadius = 2;
        _videoBG.hidden = YES;
    }
    
    return _videoBG;
}

- (UIImageView *)chatImage{
    if (!_chatImage) {
        _chatImage = [[UIImageView alloc]init];
        _chatImage.image = [UIImage imageNamed:@"ic-Picture-consulting-s"];
    }
    
    return _chatImage;
}

- (UIImageView *)audioimage{
    if (!_audioimage) {
        _audioimage = [[UIImageView alloc]init];
        _audioimage.image = [UIImage imageNamed:@"ic-Voice-s"];
    }
    
    return _audioimage;
}

- (UIImageView *)videoImage{
    if (!_videoImage) {
        _videoImage = [[UIImageView alloc]init];
        _videoImage.image = [UIImage imageNamed:@"ic-video-s"];
    }
    
    return _videoImage;
}

- (BATGraditorButton *)chatTipicLb{
    if (!_chatTipicLb) {
        _chatTipicLb = [[BATGraditorButton alloc] init];
        [_chatTipicLb setTitle:@"图文咨询" forState:UIControlStateNormal] ;
        _chatTipicLb.enbleGraditor = YES;
        _chatTipicLb.titleLabel.font = [UIFont systemFontOfSize:15];
        [_chatTipicLb setGradientColors:@[START_COLOR,END_COLOR]];
    }
    
    return _chatTipicLb;
}

- (BATGraditorButton *)AudioTipicLb{
    if (!_AudioTipicLb) {
        _AudioTipicLb = [[BATGraditorButton alloc] init];
        [_AudioTipicLb setTitle:@"语音咨询" forState:UIControlStateNormal] ;
        _AudioTipicLb.enbleGraditor = YES;
        _AudioTipicLb.titleLabel.font = [UIFont systemFontOfSize:15];
        [_AudioTipicLb setGradientColors:@[START_COLOR,END_COLOR]];
    }
    
    return _AudioTipicLb;
}

- (BATGraditorButton *)VideoTipicLb{
    if (!_VideoTipicLb) {
        _VideoTipicLb = [[BATGraditorButton alloc] initWithFrame:CGRectZero];
        [_VideoTipicLb setTitle:@"视频咨询" forState:UIControlStateNormal] ;
        _VideoTipicLb.enbleGraditor = YES;
        _VideoTipicLb.titleLabel.font = [UIFont systemFontOfSize:15];
        [_VideoTipicLb setGradientColors:@[START_COLOR,END_COLOR]];
    }
    
    return _VideoTipicLb;
}

- (BATGraditorButton *)chatContentLb{
    if (!_chatContentLb) {
        _chatContentLb = [[BATGraditorButton alloc] initWithFrame:CGRectZero];
        [_chatContentLb setTitle:@"暂未开通" forState:UIControlStateNormal] ;
        _chatContentLb.enbleGraditor = YES;
        _chatContentLb.titleLabel.font = [UIFont systemFontOfSize:15];
        [_chatContentLb setGradientColors:@[START_COLOR,END_COLOR]];
    }
    
    return _chatContentLb;
}

- (BATGraditorButton *)AudioContentLb{
    if (!_AudioContentLb) {
        _AudioContentLb = [[BATGraditorButton alloc] initWithFrame:CGRectZero];
        [_AudioContentLb setTitle:@"暂未开通" forState:UIControlStateNormal] ;
        _AudioContentLb.enbleGraditor = YES;
        _AudioContentLb.titleLabel.font = [UIFont systemFontOfSize:15];
        [_AudioContentLb setGradientColors:@[UIColorFromHEX(0x29ccbf, 1),UIColorFromHEX(0x6ccc56, 1)]];
    }
    
    return _AudioContentLb;
}

- (BATGraditorButton *)ViedoContentLb{
    if (!_ViedoContentLb) {
        _ViedoContentLb = [[BATGraditorButton alloc] initWithFrame:CGRectZero];
        [_ViedoContentLb setTitle:@"暂未开通" forState:UIControlStateNormal] ;
        _ViedoContentLb.enbleGraditor = YES;
        _ViedoContentLb.titleLabel.font = [UIFont systemFontOfSize:15];
        [_ViedoContentLb setGradientColors:@[START_COLOR,END_COLOR]];
    }
    
    return _ViedoContentLb;
}

- (UIView *)chatClickBG{
    if (!_chatClickBG) {
        _chatClickBG = [[UIView alloc]init];
        _chatClickBG.backgroundColor = [UIColor clearColor];
        _chatClickBG.userInteractionEnabled = YES;
        _chatClickBG.tag = 1230;
        UITapGestureRecognizer *chatTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(severAction:)];
        [_chatClickBG addGestureRecognizer:chatTap];
    }
    return _chatClickBG;
}

- (UIView *)audioClickBG{
    if (!_audioClickBG) {
        _audioClickBG = [[UIView alloc]init];
        _audioClickBG.backgroundColor = [UIColor clearColor];
        _audioClickBG.userInteractionEnabled = YES;
        _audioClickBG.tag = 1231;
        UITapGestureRecognizer *chatTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(severAction:)];
        [_audioClickBG addGestureRecognizer:chatTap];
    }
    return _audioClickBG;
}

- (UIView *)videoClickBG{
    if (!_videoClickBG) {
        _videoClickBG = [[UIView alloc]init];
        _videoClickBG.backgroundColor = [UIColor clearColor];
        _videoClickBG.userInteractionEnabled = YES;
        _videoClickBG.tag = 1232;
        UITapGestureRecognizer *chatTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(severAction:)];
        [_videoClickBG addGestureRecognizer:chatTap];
    }
    return _videoClickBG;
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
