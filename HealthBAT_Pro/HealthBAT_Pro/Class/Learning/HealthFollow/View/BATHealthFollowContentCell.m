//
//  BATHealthFollowContentCell.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/2/21.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHealthFollowContentCell.h"

@implementation BATHealthFollowContentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self pagesLayout];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)confirgationCell:(BATCourseData *)data
{
    [self.thumbImageView sd_setImageWithURL:[NSURL URLWithString:data.Poster] placeholderImage:[UIImage imageNamed:@"默认图"]];
    
    self.titleLabel.text = data.Topic;
    self.authorLabel.text = data.TeacherName;
    self.learningCountLabel.text = [NSString stringWithFormat:@"%ld人看过",(long)data.ReadingNum];
}

#pragma mark - Layout
- (void)pagesLayout
{
    [self.contentView addSubview:self.thumbImageView];
    [self.thumbImageView addSubview:self.videoIconImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.authorLabel];
    [self.contentView addSubview:self.learningCountLabel];

    WEAK_SELF(self);
    [self.thumbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_offset(CGSizeMake(105, 63));
    }];
    
    [self.videoIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        //        make.center.equalTo(self.contentImageView);
        //        make.size.mas_offset(CGSizeMake(27, 22));
        make.bottom.equalTo(self.thumbImageView.mas_bottom).offset(-5);
        make.right.equalTo(self.thumbImageView.mas_right).offset(-10);
        make.size.mas_offset(CGSizeMake(23, 23));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.thumbImageView.mas_right).offset(20);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.top.equalTo(self.thumbImageView.mas_top).offset(9);
    }];
    
    [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.thumbImageView.mas_right).offset(20);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-26);
    }];
    
    [self.learningCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.greaterThanOrEqualTo(self.thumbImageView.mas_right).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.height.mas_offset(15);
        make.centerY.equalTo(self.authorLabel.mas_centerY);
    }];
    
}


#pragma mark - get&set

- (UIImageView *)thumbImageView
{
    if (!_thumbImageView) {
        _thumbImageView = [[UIImageView alloc] init];
        _thumbImageView.layer.borderColor = BASE_LINECOLOR.CGColor;
        _thumbImageView.layer.borderWidth = 0.5;
    }
    return _thumbImageView;
}

- (UIImageView *)videoIconImageView
{
    if (!_videoIconImageView) {
        _videoIconImageView = [[UIImageView alloc] init];
        _videoIconImageView.image = [UIImage imageNamed:@"icon-sp-1"];
        //        _videoIconImageView.hidden = YES;
    }
    return _videoIconImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 1;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = UIColorFromHEX(0x333333, 1);
    }
    return _titleLabel;
}

- (UILabel *)authorLabel
{
    if (!_authorLabel) {
        _authorLabel = [[UILabel alloc] init];
        _authorLabel.font = [UIFont systemFontOfSize:13];
        _authorLabel.textColor = UIColorFromHEX(0x666666, 1);
    }
    return _authorLabel;
}

- (UILabel *)learningCountLabel
{
    if (!_learningCountLabel) {
        _learningCountLabel = [[UILabel alloc] init];
        _learningCountLabel.font = [UIFont systemFontOfSize:13];
        _learningCountLabel.textColor = UIColorFromHEX(0x666666, 1);
    }
    return _learningCountLabel;
}

@end
