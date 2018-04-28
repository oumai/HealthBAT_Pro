//
//  BATProgramListAddedCell.m
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/6/8.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATProgramListAddedCell.h"
#import "BATProgramListModel.h"

@interface BATProgramListAddedCell ()
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
@end

@implementation BATProgramListAddedCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.videoImageView];
        [self.contentView addSubview:self.progressView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.joinedCountLabel];
        [self.contentView addSubview:self.completedDayLabel];
        [self.contentView addSubview:self.totalDayLabel];
    }
    
    return self;
}

- (void)setProgramListModel:(BATProgramListModel *)programListModel{
    
    _programListModel = programListModel;
   
    [self.videoImageView sd_setImageWithURL:[NSURL URLWithString: programListModel.TemplateImage] placeholderImage:nil];
    self.nameLabel.text = programListModel.Remark;
    
}

#pragma mark - layoutSubviews

- (void)layoutSubviews{
    [super layoutSubviews];
    
    WeakSelf
    
    [self.videoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.top.bottom.mas_equalTo(0);
        
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.videoImageView.mas_right).offset(-5);
        make.left.mas_equalTo(weakSelf.videoImageView.mas_left).offset(5);
        make.height.mas_equalTo(15);
        make.bottom.mas_equalTo(weakSelf.videoImageView.mas_bottom).offset(-10);
    }];
    
    [self.completedDayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.progressView.mas_left);
        make.bottom.mas_equalTo(weakSelf.progressView.mas_top).offset(-5);

    }];
    
    [self.totalDayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakSelf.completedDayLabel.mas_bottom);
        make.right.mas_equalTo(weakSelf.progressView.mas_right);
        
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
        make.centerY.mas_equalTo(weakSelf.mas_centerY).offset(-20);
    }];
    
    [self.joinedCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
        make.centerY.mas_equalTo(weakSelf.mas_centerY).offset(5);
    }];
}

#pragma mark - lazy load

- (UILabel *)totalDayLabel{
    if (!_totalDayLabel) {
        _totalDayLabel = [[UILabel alloc]init];
        _totalDayLabel.text = @"预计9天完成";
        _totalDayLabel.textColor = [UIColor whiteColor];
        _totalDayLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:14];
        
    }
    return _totalDayLabel;
}
- (UILabel *)completedDayLabel{
    if (!_completedDayLabel) {
        _completedDayLabel = [[UILabel alloc]init];
        _completedDayLabel.text = @"已打卡2天";
        _completedDayLabel.textColor = [UIColor whiteColor];
        _completedDayLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:14];
        
    }
    return _completedDayLabel;
}
- (UILabel *)joinedCountLabel{
    if (!_joinedCountLabel) {
        _joinedCountLabel = [[UILabel alloc]init];
        _joinedCountLabel.text = @"56767678人已参加";
        _joinedCountLabel.textColor = [UIColor whiteColor];
        _joinedCountLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
        
    }
    return _joinedCountLabel;
}
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.text = @"15天养好肾";
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont boldSystemFontOfSize:14];
        
    }
    return _nameLabel;
}
- (UIProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc]init];
        _progressView .progressViewStyle = UIProgressViewStyleDefault;
        _progressView.progress= 0.5;
        _progressView.layer.cornerRadius = 7.5;
        _progressView.layer.masksToBounds = YES;
        _progressView.progressTintColor= [UIColor whiteColor];//设置已过进度部分的颜色
//         [_progressView setProgress:0.8 animated:YES]; //设置初始值，可以看到动画效果
        _progressView.trackTintColor= [UIColor colorWithRed:159 green:159 blue:159 alpha:1];//设置未过进度部分的颜色
    }
    return _progressView;
}
- (UIImageView *)videoImageView {
    if (!_videoImageView) {
        _videoImageView = [[UIImageView alloc]init];
        _videoImageView.layer.cornerRadius = 5;
        _videoImageView.layer.masksToBounds = YES;
//        _videoImageView.backgroundColor = [UIColor grayColor];
        
    }
    return _videoImageView;
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
