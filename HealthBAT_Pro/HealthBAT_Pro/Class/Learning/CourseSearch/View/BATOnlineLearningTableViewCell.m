//
//  BATOnlineLearningTableViewCell.m
//  HealthBAT_Pro
//
//  Created by cjl on 2016/12/6.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATOnlineLearningTableViewCell.h"

@implementation BATOnlineLearningTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self pagesLayout];
        
         [self setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0 leftOffset:10 rightOffset:0];
        
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
    [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:data.Poster] placeholderImage:[UIImage imageNamed:@"默认图"]];
    
//    self.videoIconImageView.hidden = data.CourseType == kBATCourseType_Video ? NO : YES;
    
    self.titleLabel.text = data.Topic;
    self.authorLabel.text = data.TeacherName;
    self.learningCountLabel.text = [NSString stringWithFormat:@"%ld人看过",(long)data.ReadingNum];
//    [self.readImageBtn setBackgroundImage:[UIImage imageNamed:@"icon-list-lll"] forState:UIControlStateNormal];
//    self.readCountLabel.text = [NSString stringWithFormat:@"%ld",(long)data.ReadingNum];
//    [self.commentImageBtn setBackgroundImage:[UIImage imageNamed:@"icon-list-pl"] forState:UIControlStateNormal];
//    self.commentCountLabel.text = [NSString stringWithFormat:@"%ld",(long)data.ReplyNum];
//    [self.collectImageBtn setBackgroundImage:[UIImage imageNamed:@"icon-list-sc"] forState:UIControlStateNormal];
//    self.collectionCountLabel.text = [NSString stringWithFormat:@"%ld",(long)data.CollectNum];
}

#pragma mark - Action
- (void)collectionBtnAction:(UIButton *)button
{
    if (self.onlineLearningCollectionBtnClick) {
        self.onlineLearningCollectionBtnClick(self.indexPath);
    }
}

#pragma mark - Layout
- (void)pagesLayout
{
    [self.contentView addSubview:self.contentImageView];
    [self.contentImageView addSubview:self.videoIconImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.authorLabel];
    [self.contentView addSubview:self.learningCountLabel];
    [self.contentView addSubview:self.readImageBtn];
    [self.contentView addSubview:self.readCountLabel];
    [self.contentView addSubview:self.commentImageBtn];
    [self.contentView addSubview:self.commentCountLabel];
    [self.contentView addSubview:self.collectImageBtn];
    [self.contentView addSubview:self.collectionCountLabel];
    
    WEAK_SELF(self);
    [self.contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_offset(CGSizeMake(132, 79));
    }];
    
    [self.videoIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
//        make.center.equalTo(self.contentImageView);
//        make.size.mas_offset(CGSizeMake(27, 22));
        make.bottom.equalTo(self.contentImageView.mas_bottom).offset(-5);
        make.right.equalTo(self.contentImageView.mas_right).offset(-10);
        make.size.mas_offset(CGSizeMake(23, 23));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.contentImageView.mas_right).offset(20);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.top.equalTo(self.contentImageView.mas_top).offset(7);
    }];
    
    [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.contentImageView.mas_right).offset(20);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(21);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-20);
    }];
    
    [self.learningCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.greaterThanOrEqualTo(self.contentImageView.mas_right).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.height.mas_offset(15);
        make.centerY.equalTo(self.authorLabel.mas_centerY);
    }];
    
//    [self.readImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        STRONG_SELF(self);
//        make.size.mas_offset(CGSizeMake(15, 15));
//        make.centerY.equalTo(self.authorLabel.mas_centerY);
//        make.left.greaterThanOrEqualTo(self.contentImageView.mas_right).offset(10);
//    }];
//    
//    [self.readCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        STRONG_SELF(self);
//        make.centerY.equalTo(self.authorLabel.mas_centerY);
//        make.left.equalTo(self.readImageBtn.mas_right).offset(5);
//        make.height.mas_offset(15);
//    }];
//    
//    [self.commentImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        STRONG_SELF(self);
//        make.centerY.equalTo(self.authorLabel.mas_centerY);
//        make.size.mas_offset(CGSizeMake(15, 15));
//        make.left.greaterThanOrEqualTo(self.readCountLabel.mas_right).offset(15);
//    }];
//    
//    [self.commentCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        STRONG_SELF(self);
//        make.centerY.equalTo(self.authorLabel.mas_centerY);
//        make.left.equalTo(self.commentImageBtn.mas_right).offset(5);
//        make.height.mas_offset(15);
//    }];
//    
//    [self.collectImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        STRONG_SELF(self);
//        make.centerY.equalTo(self.authorLabel.mas_centerY);
//        make.size.mas_offset(CGSizeMake(15, 15));
//        make.left.greaterThanOrEqualTo(self.commentCountLabel.mas_right).offset(15);
//    }];
//    
//    [self.collectionCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        STRONG_SELF(self);
//        make.centerY.equalTo(self.authorLabel.mas_centerY);
//        make.left.equalTo(self.collectImageBtn.mas_right).offset(5);
//        make.height.mas_offset(15);
//        make.right.equalTo(self.contentView.mas_right).offset(-12.5);
//    }];
    
}


#pragma mark - get&set

- (UIImageView *)contentImageView
{
    if (!_contentImageView) {
        _contentImageView = [[UIImageView alloc] init];
    }
    return _contentImageView;
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
        _titleLabel.numberOfLines = 2;
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

- (UIButton *)readImageBtn
{
    if (!_readImageBtn) {
        _readImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _readImageBtn;
}

- (UILabel *)readCountLabel
{
    if (!_readCountLabel) {
        _readCountLabel = [[UILabel alloc] init];
        _readCountLabel.font = [UIFont systemFontOfSize:11];
        _readCountLabel.textColor = UIColorFromHEX(0x666666, 1);
    }
    return _readCountLabel;
}

- (UIButton *)commentImageBtn
{
    if (!_commentImageBtn) {
        _commentImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _commentImageBtn;
}

- (UILabel *)commentCountLabel
{
    if (!_commentCountLabel) {
        _commentCountLabel = [[UILabel alloc] init];
        _commentCountLabel.font = [UIFont systemFontOfSize:11];
        _commentCountLabel.textColor = UIColorFromHEX(0x666666, 1);
    }
    return _commentCountLabel;
}

- (UIButton *)collectImageBtn
{
    if (!_collectImageBtn) {
        _collectImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_collectImageBtn addTarget:self action:@selector(collectionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _collectImageBtn;
}

- (UILabel *)collectionCountLabel
{
    if (!_collectionCountLabel) {
        _collectionCountLabel = [[UILabel alloc] init];
        _collectionCountLabel.font = [UIFont systemFontOfSize:11];
        _collectionCountLabel.textColor = UIColorFromHEX(0x666666, 1);
    }
    return _collectionCountLabel;
}

@end
