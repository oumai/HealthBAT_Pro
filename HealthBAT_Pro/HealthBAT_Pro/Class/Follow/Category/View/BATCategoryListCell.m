//
//  BATCategoryListCell.m
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/6/8.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATCategoryListCell.h"
#import "BATCategoryListModel.h"
@interface BATCategoryListCell ()
/** 背景 */
@property (nonatomic, strong) UIImageView *bgImageView;
/** 时长 */
@property (nonatomic, strong) UILabel *playCountLabel;
/** 视频名称 */
@property (nonatomic, strong) UILabel *nameLabel;
/** <#属性描述#> */
@property (nonatomic, strong) UIImageView *albumImageView;
/** <#属性描述#> */
@property (nonatomic, strong) UIView *separatorView;
/** <#属性描述#> */
@property (nonatomic, strong) UILabel *timeLabel;
@end

@implementation BATCategoryListCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.bgImageView];
        [self.contentView addSubview:self.playCountLabel];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.separatorView];
        [self.contentView addSubview:self.albumImageView];
        [self.contentView addSubview:self.timeLabel];
        
    }
    
    return self;
}

#pragma mark - setter

- (void)setCategoryListModel:(BATCategoryListModel *)categoryListModel{
    _categoryListModel = categoryListModel;
    
    self.playCountLabel.text = categoryListModel.CoursePlayTime;
    self.nameLabel.text = categoryListModel.Topic;
//    [NSString stringWithFormat:@"%@  %@",categoryListModel.Topic,categoryListModel.Description];
    
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:categoryListModel.Poster] placeholderImage:[UIImage imageNamed:@"默认图"]];
    self.playCountLabel.text = [NSString stringWithFormat:@"播放%@",categoryListModel.ReadingNum];
    if (categoryListModel.Isalbums) {
        
        self.albumImageView.hidden = NO;
        self.timeLabel.text = [NSString stringWithFormat:@" 共%@集",categoryListModel.AlbumCount];
    }else{
        
        self.albumImageView.hidden = YES;
        self.timeLabel.text = [NSString stringWithFormat:@" 时长%@",categoryListModel.CoursePlayTime];
    }
    
}
#pragma mark - 布局子控件

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(10);
        make.width.mas_equalTo(110);
        make.bottom.mas_equalTo(-10);
    }];
    
    [self.albumImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.mas_equalTo(self.bgImageView);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.bgImageView.mas_right).offset(10);
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.bottom.mas_equalTo(-10);
        
    }];
    
    [self.playCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.timeLabel.mas_right).offset(10);
        make.top.bottom.mas_equalTo(self.timeLabel);
    }];
    
    [self.separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgImageView.mas_left);
        make.height.mas_equalTo(0.5);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
}

#pragma mark - lazy load
- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.font = [UIFont systemFontOfSize:11];
        _timeLabel.textColor = UIColorFromHEX(0x666666, 1);
        
    }
    return _timeLabel;
}
- (UIImageView *)albumImageView{
    if (!_albumImageView) {
        _albumImageView = [[UIImageView alloc]init];
        _albumImageView.image = [UIImage imageNamed:@"tag_zhuanji"];
        
    }
    return _albumImageView;
}
- (UIView *)separatorView{
    if (!_separatorView) {
        _separatorView = [[UIView alloc]init];
        _separatorView.backgroundColor = UIColorFromHEX(0xe0e0e0, 1);
    }
    return _separatorView;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:15];
        _nameLabel.textColor = UIColorFromHEX(0x333333, 1);
        _nameLabel.numberOfLines = 2;
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.preferredMaxLayoutWidth = self.width - 130;
        
    }
    return _nameLabel;
}

- (UILabel *)playCountLabel{
    if (!_playCountLabel) {
        _playCountLabel = [[UILabel alloc]init];
        _playCountLabel.textColor =  UIColorFromHEX(0x666666, 1);
        _playCountLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:11];
    }
    return _playCountLabel;
}
- (UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc]init];
        _bgImageView.layer.cornerRadius = 3;
        _bgImageView.layer.masksToBounds = YES;
    }
    return _bgImageView;
}
@end
