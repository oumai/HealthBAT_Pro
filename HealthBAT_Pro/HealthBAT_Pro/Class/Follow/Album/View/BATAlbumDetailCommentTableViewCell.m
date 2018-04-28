//
//  BATAlbumDetailCommentTableViewCell.m
//  HealthBAT_Pro
//
//  Created by four on 2017/6/13.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATAlbumDetailCommentTableViewCell.h"

@implementation BATAlbumDetailCommentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self pageLayout];
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

#pragma mark - Action
- (void)configData:(BATAlbumDetailCommentData *)albumDetailCommentData
{
    self.contentLabel.text = albumDetailCommentData.Body;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",albumDetailCommentData.PhotoPath]] placeholderImage:[UIImage imageNamed:@"医生"]];
    self.nameLabel.text = albumDetailCommentData.AccountName;
    self.timeLabel.text = [self getTimeStringFromDateString:albumDetailCommentData.CreatedTime];
    self.likeCountLabel.text = [NSString stringWithFormat:@"%ld",(long)albumDetailCommentData.StarCount];
    self.commentCountLabel.text = [NSString stringWithFormat:@"%ld",(long)albumDetailCommentData.ReplyNum];
    self.likeButton.selected = albumDetailCommentData.IsFocus;
    
    if (albumDetailCommentData.SubCourseReplyList.count > 0) {
        
        WEAK_SELF(self);
        [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.headImageView.mas_right).offset(12);
            make.top.equalTo(self.contentLabel.mas_bottom).offset(15);
        }];
        
        [self.trianglePathView mas_remakeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.timeLabel.mas_bottom).offset(11).priority(750);
            make.height.mas_offset(10).priority(250);
            make.width.mas_offset(20);
            make.left.equalTo(self.timeLabel.mas_left).offset(10);
        }];
        
        [_trianglePathView setNeedsDisplay];
        
        [self.replyTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.trianglePathView.mas_bottom);
            make.left.equalTo(self.contentView.mas_left).offset(60);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
            make.right.equalTo(self.contentView.mas_right).offset(-15);
            make.height.mas_greaterThanOrEqualTo(albumDetailCommentData.commentTableViewHeight).priority(250);
        }];
        
    } else {

        WEAK_SELF(self);
        [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.headImageView.mas_right).offset(12);
            make.top.equalTo(self.contentLabel.mas_bottom).offset(15);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        }];
        
        [self.trianglePathView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
        }];
        
        [self.replyTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
        }];
    }
    
    self.replyTableView.parentLevelId = albumDetailCommentData.ID;
    [self.replyTableView loadCommentsData:albumDetailCommentData.SubCourseReplyList];
}

/**
 *  格式化时间
 *
 *  @param dateString 时间
 *
 *  @return 格式后的时间
 */
- (NSString *)getTimeStringFromDateString:(NSString *)dateString
{
    NSString *timeString = @"";
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *startDate = [formatter dateFromString:dateString];
    NSTimeInterval sendInterval = [startDate timeIntervalSince1970];
    
    NSDate *nowDate = [NSDate date];
    NSString *strNow = [formatter stringFromDate:nowDate];
    NSDate *nowingDate = [formatter dateFromString:strNow];
    NSTimeInterval nowInterval = [nowingDate timeIntervalSince1970];
    
    NSTimeInterval minusInterval = nowInterval - sendInterval;
    
    if (minusInterval < 60) {
        timeString = @"刚刚...";
    }
    else if (minusInterval >= 60 && minusInterval < 3600) {
        timeString = [NSString stringWithFormat:@"%ld分钟前", (long)minusInterval / 60];
    }
    else if (minusInterval >= 3600 && minusInterval < 86400) {
        timeString = [NSString stringWithFormat:@"%ld小时前", (long)minusInterval / 3600];
    }
    else if (minusInterval >= 86400) {
        if ((long)minusInterval / 86400 == 1) {
            timeString = @"昨天";
        }else {
            dateString = [dateString substringToIndex:16];
            timeString = dateString;
        }
    }
    
    
    return timeString;
}

- (void)headimgTap {
    
    if (self.headimgTapBlocks) {
        self.headimgTapBlocks(self.indexPath);
    }
}
/*
 - (NSString *)getTimeStringFromDateString:(NSString *)dateString
 {
 NSString *timeString = @"";
 
 NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
 [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
 NSDate *startDate = [formatter dateFromString:dateString];
 NSTimeInterval sendInterval = [startDate timeIntervalSince1970];
 
 NSDate *nowDate = [NSDate date];
 NSString *strNow = [formatter stringFromDate:nowDate];
 NSDate *nowingDate = [formatter dateFromString:strNow];
 NSTimeInterval nowInterval = [nowingDate timeIntervalSince1970];
 
 NSTimeInterval minusInterval = nowInterval - sendInterval;
 
 if (minusInterval < 60) {
 timeString = @"刚刚...";
 }
 else if (minusInterval >= 60 && minusInterval < 3600) {
 timeString = [NSString stringWithFormat:@"%ld分钟前", (long)minusInterval / 60];
 }
 else if (minusInterval >= 3600 && minusInterval < 86400) {
 timeString = [NSString stringWithFormat:@"%ld小时前", (long)minusInterval / 3600];
 }
 else if (minusInterval >= 86400 && minusInterval< 1296000) {
 timeString = [NSString stringWithFormat:@"%ld天前", (long)minusInterval / 86400];
 }
 else if (minusInterval >= 1296000 && minusInterval< 2592000) {
 timeString = @"半个月前";
 }
 else if (minusInterval >= 2592000 && minusInterval< 15552000) {
 timeString = [NSString stringWithFormat:@"%ld个月前", (long)minusInterval / 2592000];
 }
 else if (minusInterval >= 15552000 && minusInterval< 31104000) {
 timeString = @"半年前";
 }
 else if (minusInterval >= 31104000) {
 timeString = [NSString stringWithFormat:@"%ld年前", (long)minusInterval / 31104000];
 }
 
 return timeString;
 }
 */

- (void)likeButtonAction:(UIButton *)button
{
    if (self.likeAction) {
        self.likeAction(self.indexPath);
    }
}

- (void)commnetButtonAction:(UIButton *)button
{
    NSLog(@"%ld----",(long)self.indexPath.row);
    if (self.commentAction) {
        self.commentAction(self.indexPath);
    }
    
}

#pragma mark - pageLayout
- (void)pageLayout
{
    [self.contentView addSubview:self.headImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.likeButton];
    [self.contentView addSubview:self.likeCountLabel];
    [self.contentView addSubview:self.priseBtn];
    [self.contentView addSubview:self.commnetButton];
    [self.contentView addSubview:self.commentCountLabel];
    [self.contentView addSubview:self.commentBtn];
    [self.contentView addSubview:self.trianglePathView];
    [self.contentView addSubview:self.replyTableView];
    [self.contentView addSubview:self.TopicreplyTableView];
    [self.contentView addSubview:self.rightUpBtn];
    
    WEAK_SELF(self);
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.headImageView.mas_right).offset(12);
        make.top.equalTo(self.contentView.mas_top).offset(14).priorityHigh();
        make.right.equalTo(self.contentView.mas_right).offset(-10);
    }];
    
    [self.rightUpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.centerY.equalTo(self.nameLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.headImageView.mas_right).offset(12);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.headImageView.mas_right).offset(12);
        make.top.equalTo(self.contentLabel.mas_bottom).offset(15);
    }];
    
    [self.commnetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.greaterThanOrEqualTo(self.timeLabel.mas_right).offset(10);
        make.size.mas_offset(CGSizeMake(15, 15));
        make.centerY.equalTo(self.timeLabel.mas_centerY);
    }];
    
    [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.right.equalTo(self.commentCountLabel.mas_right).offset(0);
        make.centerY.equalTo(self.commentCountLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    [self.commentCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.commnetButton.mas_right).offset(7);
        make.centerY.equalTo(self.timeLabel.mas_centerY);
    }];
    
    [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.commentCountLabel.mas_right).offset(25);
        make.size.mas_offset(CGSizeMake(15, 15));
        make.centerY.equalTo(self.timeLabel.mas_centerY);
    }];
    
    [self.likeCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.likeButton.mas_right).offset(7);
        make.centerY.equalTo(self.timeLabel.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
    }];
    
    [self.priseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.right.equalTo(self.contentView.mas_right).offset(0);
        make.centerY.equalTo(self.likeCountLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    [self.trianglePathView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(11).priority(750);
        make.height.mas_offset(10).priority(250);
        make.width.mas_offset(20);
        make.left.equalTo(self.timeLabel.mas_left).offset(10);
    }];
    
    [self.replyTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(self.trianglePathView.mas_bottom);
        make.left.equalTo(self.contentView.mas_left).offset(60);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.height.mas_greaterThanOrEqualTo(0).priority(250);
    }];
    
    [self setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0.5 leftOffset:10 rightOffset:10];
}

#pragma mark - get & set
- (UIImageView *)headImageView {
    
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.layer.cornerRadius = 35.0f / 2.0f;
        _headImageView.clipsToBounds = YES;
        _headImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headimgTap)];
        [_headImageView addGestureRecognizer:tap];
    }
    return _headImageView;
}

- (UILabel *)nameLabel {
    
    if (!_nameLabel) {
        _nameLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:14] textColor:STRING_DARK_COLOR textAlignment:NSTextAlignmentLeft];
        [_nameLabel sizeToFit];
    }
    return _nameLabel;
}

- (UILabel *)contentLabel {
    
    if (!_contentLabel) {
        _contentLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:13] textColor:STRING_MID_COLOR textAlignment:NSTextAlignmentLeft];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}


- (UILabel *)timeLabel {
    
    if (!_timeLabel) {
        _timeLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:11] textColor:STRING_LIGHT_COLOR textAlignment:NSTextAlignmentLeft];
        [_timeLabel sizeToFit];
    }
    return _timeLabel;
}

- (UIButton *)likeButton
{
    if (_likeButton == nil) {
        _likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_likeButton setBackgroundImage:[UIImage imageNamed:@"icon-pre-dz"] forState:UIControlStateSelected];
        [_likeButton setBackgroundImage:[UIImage imageNamed:@"icon_dianzan"] forState:UIControlStateNormal];
        // [_likeButton addTarget:self action:@selector(likeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _likeButton;
}

- (UIButton *)priseBtn
{
    if (_priseBtn == nil) {
        _priseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_priseBtn addTarget:self action:@selector(likeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _priseBtn;
}


- (UIButton *)commnetButton
{
    if (_commnetButton == nil) {
        _commnetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commnetButton setBackgroundImage:[UIImage imageNamed:@"icon-pl"] forState:UIControlStateNormal];
        //   [_commnetButton addTarget:self action:@selector(commnetButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commnetButton;
}

- (UIButton *)commentBtn
{
    if (_commentBtn == nil) {
        _commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_commentBtn addTarget:self action:@selector(commnetButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentBtn;
}

- (UILabel *)likeCountLabel
{
    if (_likeCountLabel == nil) {
        _likeCountLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:12] textColor:UIColorFromHEX(0x999999, 1) textAlignment:NSTextAlignmentLeft];
        [_likeCountLabel sizeToFit];
        _likeCountLabel.text = @"0";
    }
    return _likeCountLabel;
}

- (UILabel *)commentCountLabel
{
    if (_commentCountLabel == nil) {
        _commentCountLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:12] textColor:UIColorFromHEX(0x999999, 1) textAlignment:NSTextAlignmentLeft];
        [_commentCountLabel sizeToFit];
        _commentCountLabel.text = @"0";
    }
    return _commentCountLabel;
}

- (TrianglePathView *)trianglePathView
{
    if (_trianglePathView == nil) {
        _trianglePathView = [[TrianglePathView alloc] init];
        _trianglePathView.backgroundColor = [UIColor whiteColor];
    }
    return _trianglePathView;
}

- (BATAlbumDetailReplyTableView *)replyTableView
{
    if (_replyTableView == nil) {
        _replyTableView = [[BATAlbumDetailReplyTableView alloc] init];
    }
    return _replyTableView;
}

- (BATTopicReplyTableView *)TopicreplyTableView {
    if (_TopicreplyTableView == nil) {
        _TopicreplyTableView = [[BATTopicReplyTableView alloc] init];
    }
    return _TopicreplyTableView;
}

- (BATCustomButton *)rightUpBtn {
    
    if (!_rightUpBtn) {
        _rightUpBtn = [[BATCustomButton alloc]init];
        [_rightUpBtn setImage:[UIImage imageNamed:@"icon-ts"] forState:UIControlStateNormal];
        _rightUpBtn.imageRect = CGRectMake(12, 5, 16, 15);
        _rightUpBtn.titleRect = CGRectMake(0, 25, 40, 15);
        [_rightUpBtn setTitleColor:UIColorFromHEX(0X999999, 1) forState:UIControlStateNormal];
        [_rightUpBtn setTitle:@"投诉" forState:UIControlStateNormal];
        _rightUpBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _rightUpBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _rightUpBtn.hidden = YES;
    }
    return _rightUpBtn;
}

@end
