//
//  BATHealthCircleTableViewCell.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/24.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATTopicTableViewCell.h"
#import "BATPerson.h"
@interface BATTopicTableViewCell ()

@property (strong, nonatomic) UITapGestureRecognizer *avatarTapGestureRecognizer;

@property (nonatomic,strong) YYLabel *seeMore;



@end

@implementation BATTopicTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //设置头像圆形
    _avatarImageView.layer.cornerRadius = _avatarImageView.frame.size.height / 2;
    _avatarImageView.layer.masksToBounds = YES;
    _avatarImageView.userInteractionEnabled = YES;
    
    _avatarTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarAction:)];
    _avatarTapGestureRecognizer.numberOfTapsRequired = 1;
    _avatarTapGestureRecognizer.numberOfTouchesRequired = 1;
    [_avatarImageView addGestureRecognizer:_avatarTapGestureRecognizer];
    
    _nicknameLabel.textColor = UIColorFromHEX(0X0182eb, 1);
    _nicknameLabel.font = [UIFont systemFontOfSize:15];
    
    self.topicTitle.font = [UIFont systemFontOfSize:15];
    self.topicTitle.textColor = UIColorFromHEX(0X333333, 1);
    
    self.contentLabel.font = [UIFont systemFontOfSize:13];
    self.contentLabel.textColor = UIColorFromHEX(0X999999, 1);
    self.contentLabel.numberOfLines = 4;
    self.contentLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 30;
    
    NSMutableAttributedString *text2 = [[NSMutableAttributedString alloc] initWithString:@"...more"];
    
    YYTextHighlight *hi = [YYTextHighlight new];
    [hi setColor:[UIColor colorWithRed:0.578 green:0.790 blue:1.000 alpha:1.000]];
    
    [text2 yy_setColor:[UIColor colorWithRed:0.000 green:0.449 blue:1.000 alpha:1.000]range:[text2.string rangeOfString:@"...more"]];
    [text2 yy_setTextHighlight:hi range:[self.contentLabel.text rangeOfString:@"...more"]];
    text2.yy_font = self.contentLabel.font;
    
    self.seeMore = [YYLabel new];
    self.seeMore.attributedText = text2;
    [self.seeMore sizeToFit];
    
    NSAttributedString *truncationToken = [NSAttributedString yy_attachmentStringWithContent:self.seeMore contentMode:UIViewContentModeCenter attachmentSize:self.seeMore.frame.size alignToFont:text2.yy_font alignment:YYTextVerticalAlignmentCenter];
    
    self.contentLabel.truncationToken = truncationToken;
    
    self.commentButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.commentButton setTitleColor:UIColorFromHEX(0X999999, 1) forState:UIControlStateNormal];
    
    self.thumbsUpButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.thumbsUpButton setTitleColor:UIColorFromHEX(0X999999, 1) forState:UIControlStateNormal];
    
    

    [self.moreButton setBackgroundImage:[UIImage imageNamed:@"icon-jgz"] forState:UIControlStateNormal];
    [self.moreButton setBackgroundImage:[UIImage imageNamed:@"icon-ygz-gray"] forState:UIControlStateSelected];
    
    //设置cell的separator
    [self setBottomBorderWithColor:UIColorFromHEX(0xeeeeee, 1) width:SCREEN_WIDTH height:0];
    
    self.sexView = [[UIImageView alloc]init];
    self.sexView.hidden = YES;
    [self addSubview:self.sexView];
    
    [self.sexView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.nicknameLabel.mas_right).offset(5);
        make.centerY.equalTo(self.nicknameLabel.mas_centerY);

    }];
    
    self.hotView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic-hot"]];
    self.hotView.hidden = YES;
    [self addSubview:self.hotView];
    
    [self.hotView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.sexView.mas_right).offset(5);
        make.centerY.equalTo(self.sexView.mas_centerY);
        
    }];
    
    [self addSubview:self.replyBtn];
    [self.replyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.timeLabel.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-10);
        make.width.mas_equalTo(46);
        make.height.mas_equalTo(21);
        
    }];
    
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Public
#pragma mark - 配置数据
- (void)configrationCell:(HotTopicData *)model
{

        if([model.PhotoPath hasPrefix:@"http://"]) {

            [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.PhotoPath] placeholderImage:[UIImage imageNamed:@"personalCenter_defaultAvator"]];
        }else{

            [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",APP_DOMAIN_URL,model.PhotoPath]] placeholderImage:[UIImage imageNamed:@"personalCenter_defaultAvator"]];
        }

    
    BATPerson *person = PERSON_INFO;
    if ([model.AccountID integerValue]== person.Data.AccountID) {
        _moreButton.hidden = YES;
      
    }else {
      _moreButton.hidden = NO;
    }
  
      _moreButton.selected = model.IsUserFollow;
    //昵称
    _nicknameLabel.text = model.UserName;
    
    
    //内容
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:model.PostContent];
    _contentLabel.attributedText = text;

    //更新图片view的高度
    [_collectionImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(model.collectionImageViewHeight).priorityLow();
    }];
    
    _topicTitle.text = model.Title;
    
    if (model.contentHeight < 50) {
        self.seeMore.hidden = YES;
    }else {
        self.seeMore.hidden = NO;
    }
    
    if (model.isShowTime) {
         //时间
        _timeLabel.text = [self getTimeStringFromDateString:model.CreatedTime];
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _timeLabel.textColor = UIColorFromHEX(0X999999, 1);
        
        _nicknameLabel.textColor = BASE_COLOR;
        
        self.sexView.hidden = NO;
        if ([model.Sex isEqualToString:@"0"]) {
            self.sexView.image = [UIImage imageNamed:@"icon_sex_girl"];
        }else {
            self.sexView.image = [UIImage imageNamed:@"icon_sex_man"];
        }
        
        if (model.HotFlag == 1) {
            self.hotView.hidden = NO;
        }else {
            self.hotView.hidden = YES;
        }
        
        
    }else {
       
        _timeLabel.text = [NSString stringWithFormat:@"#%@#",model.Topic];
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _timeLabel.textColor = UIColorFromHEX(0Xff8c28, 1);
       
    }
    
    [_commentButton setTitle:[NSString stringWithFormat:@"阅读 %@",model.ReadNum] forState:UIControlStateNormal];
    
    [_thumbsUpButton setTitle:[NSString stringWithFormat:@"点赞 %zd",model.StarNum] forState:UIControlStateNormal];
    
    //加载图片数据
    [_collectionImageView loadImageData:model.ImageList];
   
    
    [self.contentView layoutIfNeeded];
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
    else if (minusInterval >= 86400 ) {
        if ((long)minusInterval / 86400 == 1) {
            timeString = @"昨天";
        }else {
            dateString = [dateString substringToIndex:16];
            timeString = dateString;
        }
    }
    
    
    return timeString;
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

#pragma mark - Action

#pragma mark - 头像点击
- (IBAction)avatarAction:(id)sender
{
    if (self.avatarAction) {
        self.avatarAction(_indexPath);
    }
}

#pragma mark - 更多操作点击
- (IBAction)moreButtonAction:(id)sender
{
    if (self.moreAction) {
        self.moreAction(_indexPath);
    }
}

#pragma mark - 评论按钮点击
- (IBAction)commentButtonAction:(id)sender
{
    if (self.commentAction) {
        self.commentAction(_indexPath);
    }
}

- (IBAction)thumpUpButtonAction:(id)sender
{
    if (self.thumbsUpAction) {
        self.thumbsUpAction(_indexPath);
    }
}

- (UIButton *)replyBtn {

    if (!_replyBtn) {
        _replyBtn = [[UIButton alloc]init];
        _replyBtn.clipsToBounds = YES;
        _replyBtn.layer.borderColor = UIColorFromHEX(0X999999,1).CGColor;
        _replyBtn.layer.cornerRadius = 5;
        _replyBtn.layer.borderWidth = 1;
        [_replyBtn setTitle:@"回复" forState:UIControlStateNormal];
        [_replyBtn setTitleColor:UIColorFromHEX(0X999999,1) forState:UIControlStateNormal];
        _replyBtn.hidden = YES;
        _replyBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_replyBtn addTarget:self action:@selector(replyAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _replyBtn;
}

- (void)replyAction {

    if (self.audioAction) {
        self.audioAction();
    }
}
@end
