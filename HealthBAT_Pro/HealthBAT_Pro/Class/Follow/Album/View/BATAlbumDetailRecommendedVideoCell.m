//
//  BATAlbumDetailRecommendedVideoCell.m
//  HealthBAT_Pro
//
//  Created by four on 2017/6/15.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATAlbumDetailRecommendedVideoCell.h"

@implementation BATAlbumDetailRecommendedVideoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self pageLayout];
    }
    return self;
}

- (void)setCellWithModel:(BATAlbumDetailRecommendVidoeData *)data{

    if (data) {
        
        [self.VideoImageView sd_setImageWithURL:[NSURL URLWithString:data.Poster] placeholderImage:[UIImage imageNamed:@"默认图"]];
        self.titleLabel.text = data.Topic;
        self.playTimeLabel.text = data.CoursePlayTime;
    }
}

#pragma mark - pageLayout
- (void)pageLayout
{
    [self.contentView addSubview:self.VideoImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.playTimeLabel];

    
    WEAK_SELF(self);
    
    [self.VideoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.width.mas_equalTo(175);
        make.bottom.equalTo(@-10);
    }];
    
    [self.playTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.bottom.equalTo(self.VideoImageView.mas_bottom);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.VideoImageView.mas_right).offset(10);
        make.centerY.equalTo(self.VideoImageView.mas_centerY).offset(0);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
    }];
    
    [self setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0.5 leftOffset:10 rightOffset:10];
}

- (UIImageView *)VideoImageView{
    if (_VideoImageView == nil) {
        _VideoImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _VideoImageView.clipsToBounds = YES;
        _VideoImageView.layer.cornerRadius = 5;
    }
    return _VideoImageView;
}

- (UILabel *)playTimeLabel
{
    if (_playTimeLabel == nil) {
        _playTimeLabel = [[UILabel alloc] init];
        _playTimeLabel.font = [UIFont systemFontOfSize:17];
        _playTimeLabel.textColor = [UIColor whiteColor];
        _playTimeLabel.text = @"00:00";
        [_playTimeLabel sizeToFit];
    }
    return _playTimeLabel;
}

- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = UIColorFromHEX(0x333333, 1);
        _titleLabel.numberOfLines = 0;
        _titleLabel.text = @"看看哈";
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
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
