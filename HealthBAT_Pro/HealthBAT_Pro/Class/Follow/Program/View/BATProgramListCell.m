//
//  BATHealthProjectListCell.m
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/6/8.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATProgramListCell.h"
#import "BATProgramListModel.h"
@interface BATProgramListCell ()
/** 背景UIImageView */
@property (nonatomic, strong) UIImageView *videoImageView;
/** 观看进度条 */
@property (nonatomic, strong) UIProgressView *progressView;
/** 视频名称 */
@property (nonatomic, strong) UILabel *nameLabel;
/** 参加人数 */
@property (nonatomic, strong) UILabel *joinedCountLabel;
/** 已完成的天数 */
@property (nonatomic, strong) UILabel *completedDayLabel;
/** 总共天数 */
@property (nonatomic, strong) UILabel *totalDayLabel;

/**
 加入时间
 */
@property (nonatomic,strong) UILabel *joinedTimeLabel;
@end
@implementation BATProgramListCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.videoImageView];
        [self.contentView addSubview:self.progressView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.joinedCountLabel];
        [self.contentView addSubview:self.completedDayLabel];
        [self.contentView addSubview:self.totalDayLabel];
        [self.contentView addSubview:self.joinedTimeLabel];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

#pragma mark - Action
- (NSString *)formatTime:(NSString *)time
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* inputDate = [formatter dateFromString:time];
    NSLog(@"date = %@", inputDate);
    
    [formatter setDateFormat:@"MM月dd日"];
    
    NSString *outDate = [formatter stringFromDate:inputDate];
    
    return outDate;
}

#pragma mark - setter
#pragma mark - 设置已添加方案数据
- (void)setAddedProgramListModel:(BATProgramListModel *)addedProgramListModel{
    
    _addedProgramListModel = addedProgramListModel;
    
    self.joinedTimeLabel.text = [NSString stringWithFormat:@"%@加入方案",[self formatTime:_addedProgramListModel.CreatedTime]];
    
    [self.videoImageView sd_setImageWithURL:[NSURL URLWithString: addedProgramListModel.TemplateImage] placeholderImage:[UIImage imageNamed:@"默认图"]];
    self.nameLabel.text = addedProgramListModel.Remark;
    self.completedDayLabel.text = [NSString stringWithFormat:@"已打卡%ld天",(long)addedProgramListModel.ClockInCount];
    self.totalDayLabel.text = [NSString stringWithFormat:@"%@预计完成",addedProgramListModel.ComplateTime];
    self.joinedCountLabel.text = [NSString stringWithFormat:@"%@人已参加",addedProgramListModel.JoinCount];
    
    /*
     "ClockInCount": 8,  //已打卡天数
     "ExpectClockInCount": 7,  //剩余打卡天数
     "ComplateTime": "06月21日"   //预计打卡完成时间,
     */
    self.progressView.progress = (CGFloat) addedProgramListModel.ClockInCount/ (addedProgramListModel.ExpectClockInCount +addedProgramListModel.ClockInCount);

}

#pragma mark - 设置方案列表数据
- (void)setProgramListModel:(BATProgramListModel *)programListModel{
    
    _programListModel = programListModel;
   
    self.progressView.hidden = YES;
    self.totalDayLabel.hidden = YES;
    self.joinedTimeLabel.hidden = YES;
    self.completedDayLabel.hidden = YES;
    
    [self.videoImageView sd_setImageWithURL: [NSURL URLWithString:programListModel.TemplateImage] placeholderImage:[UIImage imageNamed:@"默认图"]];
    self.nameLabel.text = programListModel.Remark;
    self.joinedCountLabel.text = [NSString stringWithFormat:@"%@人已参加",programListModel.JoinCount];
    
}

#pragma mark - layoutSubviews

- (void)layoutSubviews{
    [super layoutSubviews];
    
    WEAK_SELF(self);
    [self.videoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.left.mas_equalTo(0);
        
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.left.mas_equalTo(20);;
        make.height.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
    }];
    
    [self.completedDayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.progressView.mas_left);
        make.bottom.equalTo(self.progressView.mas_top).offset(-8.5);
        
    }];
    
    [self.totalDayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.bottom.equalTo(self.completedDayLabel.mas_bottom);
        make.right.equalTo(self.progressView.mas_right);
        
    }];
    
    [self.joinedTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.bottom.equalTo(self.totalDayLabel.mas_top);
        make.right.equalTo(self.progressView.mas_right);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(95/2);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        
    }];
    
    [self.joinedCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
        make.left.right.equalTo(self.nameLabel);
    }];
}

#pragma mark - lazy load

- (UILabel *)joinedTimeLabel
{
    if (!_joinedTimeLabel) {
        _joinedTimeLabel = [[UILabel alloc]init];
        _joinedTimeLabel.textColor = [UIColor whiteColor];
        _joinedTimeLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
        
    }
    return _joinedTimeLabel;
}

- (UILabel *)totalDayLabel{
    if (!_totalDayLabel) {
        _totalDayLabel = [[UILabel alloc]init];
        _totalDayLabel.textColor = [UIColor whiteColor];
        _totalDayLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
        
    }
    return _totalDayLabel;
}
- (UILabel *)completedDayLabel{
    if (!_completedDayLabel) {
        _completedDayLabel = [[UILabel alloc]init];
        _completedDayLabel.textColor = [UIColor whiteColor];
        _completedDayLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
        
    }
    return _completedDayLabel;
}
- (UILabel *)joinedCountLabel{
    if (!_joinedCountLabel) {
        _joinedCountLabel = [[UILabel alloc]init];
        _joinedCountLabel.textAlignment = NSTextAlignmentCenter;
        _joinedCountLabel.textColor = [UIColor whiteColor];
        _joinedCountLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
        
    }
    return _joinedCountLabel;
}
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont boldSystemFontOfSize:28];
        
    }
    return _nameLabel;
}
- (UIProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc]init];
        _progressView .progressViewStyle = UIProgressViewStyleDefault;
        _progressView.progress= 0.5;
        _progressView.layer.cornerRadius = 5;
        _progressView.layer.masksToBounds = YES;
        _progressView.progressTintColor= [UIColor whiteColor];//设置已过进度部分的颜色
        //       [_progressView setProgress:0.8 animated:YES]; //设置初始值，可以看到动画效果
        _progressView.trackTintColor= [UIColor colorWithRed:159 green:159 blue:159 alpha:0.3];//设置未过进度部分的颜色
    }
    return _progressView;
}
- (UIImageView *)videoImageView {
    if (!_videoImageView) {
        _videoImageView = [[UIImageView alloc]init];
        _videoImageView.contentMode = UIViewContentModeScaleAspectFill;
        _videoImageView.clipsToBounds  = YES;
        
    }
    return _videoImageView;
}


@end
