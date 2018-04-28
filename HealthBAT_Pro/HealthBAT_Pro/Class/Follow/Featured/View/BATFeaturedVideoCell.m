//
//  BATFeaturedVideoCell.m
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/6/13.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATFeaturedVideoCell.h"
#import "BATFeaturedVideoModel.h"

@interface BATFeaturedVideoCell ()

/** title */
@property (nonatomic, strong) UILabel *titleLabel;
/** icon */
@property (nonatomic, strong) UIImageView *imageView;
/** time */
@property (nonatomic, strong) UILabel *timeLabel;
/** 专辑 */
@property (nonatomic, strong) UIImageView *albumImageView;
/** 播放量 */
@property (nonatomic, strong) UILabel *playCountLabel;
/** 分割线 */
@property (nonatomic, strong) UIView *separatorView;

@end
@implementation BATFeaturedVideoCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.albumImageView];
        [self.contentView addSubview:self.playCountLabel];
        [self.contentView addSubview:self.separatorView];
    }
    return self;
}

#pragma mark - setter

- (void)setFeaturedVideoModel:(BATFeaturedVideoListModel *)featuredVideoModel{
    _featuredVideoModel = featuredVideoModel;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:featuredVideoModel.Poster] placeholderImage:[UIImage imageNamed:@"默认图"]];
    
    self.playCountLabel.text = [NSString stringWithFormat:@"播放%@",featuredVideoModel.ReadingNum];
    if (featuredVideoModel.Isalbums) {

        self.albumImageView.hidden = NO;
        self.timeLabel.text = [NSString stringWithFormat:@" 共%ld集",(long)featuredVideoModel.AlbumCount];

    }else{

        self.albumImageView.hidden = YES;
        self.timeLabel.text = [NSString stringWithFormat:@" 时长%@",featuredVideoModel.CoursePlayTime];
    }
    
    
    /** 1 : 美容 2:养生 3 ：减肥  4 ： 塑型*/
    switch (featuredVideoModel.Category) {
        case 1:
            self.titleLabel.text = [NSString stringWithFormat:@"【美容】%@",featuredVideoModel.Topic];
            break;
        case 2:
            self.titleLabel.text = [NSString stringWithFormat:@"【养生】%@",featuredVideoModel.Topic];
            break;
        case 3:
            self.titleLabel.text = [NSString stringWithFormat:@"【减肥】%@",featuredVideoModel.Topic];
            break;
        case 4:
            self.titleLabel.text = [NSString stringWithFormat:@"【塑形】%@",featuredVideoModel.Topic];
            break;
            
        default:
            break;
    }
    
}

#pragma mark - 布局子控件

- (void)layoutSubviews{
    [super layoutSubviews];
    
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
        make.width.mas_equalTo(110);
        
    }];
    
    [self.albumImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_equalTo(self.imageView);
        
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(self.imageView.mas_right).offset(10);
        make.right.mas_equalTo(-10);
        
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(self.titleLabel.mas_left);
        make.bottom.mas_equalTo(-10);
    }];
    
    
    [self.playCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.timeLabel.mas_right).offset(10);
        make.bottom.top.mas_equalTo(self.timeLabel);
    }];
  
    [self.separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imageView.mas_left);
        make.height.mas_equalTo(0.5);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    
}

#pragma mark - lazy load
- (UIView *)separatorView{
    if (!_separatorView) {
        _separatorView = [[UIView alloc]init];
        _separatorView.backgroundColor = UIColorFromHEX(0xe0e0e0, 1);
    }
    return _separatorView;
}
- (UILabel *)playCountLabel{
    if (!_playCountLabel) {
        _playCountLabel = [[UILabel alloc]init];
        _playCountLabel.font = [UIFont systemFontOfSize:11];
        _playCountLabel.textColor = UIColorFromHEX(0x666666, 1);
    }
    return _playCountLabel;
}
- (UIImageView *)albumImageView{
    if (!_albumImageView) {
        _albumImageView = [[UIImageView alloc]init];
        _albumImageView.image = [UIImage imageNamed:@"tag_zhuanji"];
    }
    return _albumImageView;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.layer.cornerRadius = 3;
        _imageView.layer.masksToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        
    }
    return _imageView;
}
- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:11];
        _timeLabel.textColor = UIColorFromHEX(0x666666, 1);
        
    }
    return _timeLabel;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = UIColorFromHEX(0x333333, 1);
        _titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:14];
        _titleLabel.numberOfLines = 2;
        _titleLabel.preferredMaxLayoutWidth = self.size.width-130;
    }
    return _titleLabel;
}
@end
