//
//  BATTrainStudioListCell.m
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/7/14.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATTrainStudioListCell.h"
#import "BATTrainStudioListModel.h"
#import "UIColor+Gradient.h"
#import "UIButton+ImagePosition.h"

#define kPING_FANG_FONT  @"PingFang-SC-Regular"

@interface BATTrainStudioListCell ()
/** logo */
@property (nonatomic, strong) UIImageView *logoImageView;
/** 标题 */
@property (nonatomic, strong) UILabel *titleLabel;
/** 内容 */
@property (nonatomic, strong) UILabel *contentLabel;
/** 类型 */
@property (nonatomic, strong) UILabel *typeLabel;
/** 播放 */
@property (nonatomic, strong) UIImageView *playVideoImageView;
/** 浏览icon */
@property (nonatomic, strong) UIImageView *browseImageView;
/** 浏览数 */
@property (nonatomic, strong) UILabel *browseCountLabel;

@end

@implementation BATTrainStudioListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.logoImageView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.typeLabel];
        [self.contentView addSubview:self.playVideoImageView];
        [self.contentView addSubview:self.browseImageView];
        [self.contentView addSubview:self.browseCountLabel];
        
    }
    
    return self;
}

- (void)setStudioListModel:(BATTrainStudioListModel *)studioListModel{
    
    [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:studioListModel.Poster] placeholderImage:[UIImage imageNamed:@"默认图"]];
    self.titleLabel.text = studioListModel.CourseTitle;
    self.contentLabel.text = studioListModel.CourseDesc;

    self.typeLabel.text = studioListModel.CourseCategoryAlias;
    //等于13是图文，小于的是文档课件,大于13的都是视频,接口默认是返回都是视频课程
    self.playVideoImageView.hidden = studioListModel.CourseType == 13 ? YES : NO;
    //浏览数
    [self setupBrowseCount:self.browseCountLabel number:studioListModel.ReadingNum placeholder:@"0"];
    
    self.typeLabel.hidden = self.SubjectType == -1 ? NO : YES;
    //添加宽度约束
    CGFloat typeLabelWidth = [self.typeLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 22) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size.width;
    
    [self.typeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(typeLabelWidth);
        make.height.mas_equalTo(22);
        
    }];
    
    
}
/**
 处理浏览数
 */
- (void)setupBrowseCount:(UILabel *)browCountLabel number:(NSInteger)number placeholder:(NSString *)placeholder
{
    if (number >= 10000) {
        browCountLabel.text = [NSString stringWithFormat:@"%.1f万", number / 10000.0];
        
    } else if (number > 0) {
        browCountLabel.text = [NSString stringWithFormat:@"%.zd", number];
        
    } else {
        browCountLabel.text = placeholder;
        
    }
}
#pragma mark - layoutSubviews

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(10);
        make.height.mas_equalTo(75);
        make.width.mas_equalTo(100);
        
    }];
    
    [self.playVideoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.width.mas_equalTo(25);
        make.centerX.mas_equalTo(self.logoImageView.mas_centerX);
        make.centerY.mas_equalTo(self.logoImageView.mas_centerY);
        
        
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.logoImageView.mas_top).offset(5);
        make.left.equalTo(self.logoImageView.mas_right).offset(10);
        make.right.mas_equalTo(-10);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.left.equalTo(self.titleLabel.mas_left);
        make.right.equalTo(self.titleLabel.mas_right);
        
    }];
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-10);
        make.left.equalTo(self.titleLabel.mas_left);
        make.top.equalTo(self.contentLabel.mas_bottom).offset(10);
        
    }];
    
    
    [self.browseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.mas_equalTo(self.browseCountLabel.mas_left).offset(-7.5);
        make.centerY.mas_equalTo(self.typeLabel.mas_centerY);
    }];
    
    [self.browseCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.width.mas_equalTo(35);
        make.centerY.mas_equalTo(self.typeLabel.mas_centerY);
        
    }];
    
}

#pragma mark - lazy load

- (UIImageView *)logoImageView{
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] init];
        _logoImageView.layer.cornerRadius = 3;
        _logoImageView.layer.masksToBounds = YES;
        _logoImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _logoImageView;
}

- (UIImageView *)playVideoImageView{
    if (!_playVideoImageView) {
        _playVideoImageView = [[UIImageView alloc]init];
        _playVideoImageView.image = [UIImage imageNamed:@"TrainStudio_play"];
    }
    return _playVideoImageView;
}
- (UILabel *)titleLabel{
    if (!_titleLabel ) {
        _titleLabel = [[UILabel alloc]init];
        //        _titleLabel.backgroundColor = RandomColor;
        _titleLabel.font = [UIFont fontWithName:kPING_FANG_FONT size:15];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = UIColorFromHEX(0x333333, 1);
        
    }
    return _titleLabel;
}
- (UILabel *)contentLabel{
    if (!_contentLabel ) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.font = [UIFont fontWithName:kPING_FANG_FONT size:13];
        //        _contentLabel.backgroundColor = RandomColor;
        _contentLabel.textColor = UIColorFromHEX(0x999999, 1);
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        
    }
    return _contentLabel;
}
- (UILabel *)typeLabel{
    if (!_typeLabel ) {
        _typeLabel = [[UILabel alloc]init];
        _typeLabel.layer.borderWidth = 0.5;
        _typeLabel.layer.cornerRadius = 3;
        _typeLabel.layer.masksToBounds = YES;
        _typeLabel.textAlignment = NSTextAlignmentCenter;
        _typeLabel.font = [UIFont systemFontOfSize:12];
        //_typeLabel.layer.borderColor = [UIColor redColor].CGColor;
        UIColor *textGradientColor =  [UIColor gradientFromColor:UIColorFromHEX(0x29ccbf, 1) toColor:UIColorFromHEX(0x6ccc56, 1) withHeight:22];
        UIColor *borderGradientColor =  [UIColor gradientFromColor:UIColorFromHEX(0x29ccbf, 1) toColor:UIColorFromHEX(0x6ccc56, 1) withHeight:1];
        _typeLabel.textColor = textGradientColor;
        _typeLabel.layer.borderColor = borderGradientColor.CGColor;
    }
    return _typeLabel;
}
- (UIImageView *)browseImageView{
    if (!_browseImageView) {
        _browseImageView = [[UIImageView alloc]init];
        _browseImageView.image = [UIImage imageNamed:@"TrainStudio_Browse"];
        //        _browseImageView.backgroundColor = [UIColor redColor];
    }
    return _browseImageView;
}

- (UILabel *)browseCountLabel{
    if (!_browseCountLabel) {
        _browseCountLabel = [[UILabel alloc]init];
        _browseCountLabel.textColor = UIColorFromHEX(0x999999, 1);
        _browseCountLabel.textAlignment = NSTextAlignmentLeft;
        _browseCountLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
        //        _browseCountLabel.backgroundColor = [UIColor redColor];
        _browseCountLabel.text = @"8888";
        
    }
    return _browseCountLabel;
}

@end
