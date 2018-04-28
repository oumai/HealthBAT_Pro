//
//  BATMyAttendTopicListCell.m
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/5/13.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATMyAttendTopicListCell.h"
#import "BATMyAttendTopicListModel.h"

@interface BATMyAttendTopicListCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *leftSubLabel;
@property (nonatomic, strong) UILabel *rightSubLabel;
@property (nonatomic, strong) UIButton *focusButton;
@property (nonatomic, strong) UIImageView *iconImageView;

@end

@implementation BATMyAttendTopicListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.leftSubLabel];
        [self.contentView addSubview:self.rightSubLabel];
        [self.contentView addSubview:self.focusButton];
        [self.contentView addSubview:self.iconImageView];
    }
    return self;
}
#pragma mark - setter
- (void)setTopicModel:(BATMyAttendTopicListModel *)topicModel{
    _topicModel = topicModel;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:topicModel.TopicImage] placeholderImage:[UIImage imageNamed:@"用户"]];
    self.titleLabel.text = topicModel.Topic;
    //    "FollowNum": 0,                        --用户关注的数量
    //    "PostNum": 0,                          --所属帖子的数量
    self.leftSubLabel.text = [NSString stringWithFormat:@"%ld人关注",(long)topicModel.FollowNum];
    self.rightSubLabel.text = [NSString stringWithFormat:@"%ld帖子",(long)topicModel.PostNum];
    self.focusButton.selected = topicModel.IsTopicFollow;
}

#pragma mark - action

- (void)focusButtonClick:(UIButton *)focusBtn{
    if (self.delegate && [self.delegate respondsToSelector:@selector(focusButtonDidClick:topicModel:)]) {
        [self.delegate focusButtonDidClick:focusBtn topicModel:self.topicModel];
    }
}

#pragma mark - layoutSubviews

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.mas_equalTo(@10);
        make.height.width.mas_equalTo(@70);
        
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImageView.mas_top).offset(10);
        make.left.mas_equalTo(self.iconImageView.mas_right).offset(10);
    }];
    
    [self.focusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(@-10);
        make.top.mas_equalTo(self.titleLabel.mas_top);
        make.height.mas_equalTo(@30);
    }];
    
    [self.leftSubLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(self.titleLabel.mas_left);
        
    }];
    
    [self.rightSubLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftSubLabel.mas_right).offset(10);
        make.top.bottom.mas_equalTo(self.leftSubLabel);
    }];
}
- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
    }
    return _iconImageView;
}
- (UIButton *)focusButton{
    if (!_focusButton) {
        _focusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_focusButton setImage:[UIImage imageNamed:@"person_jgz"] forState:UIControlStateNormal];
        [_focusButton setImage:[UIImage imageNamed:@"person_yjgz"] forState:UIControlStateSelected];
        [_focusButton addTarget:self action:@selector(focusButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _focusButton;
}
- (UILabel *)rightSubLabel{
    if (!_rightSubLabel) {
        _rightSubLabel = [[UILabel alloc]init];
        _rightSubLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
        _rightSubLabel.textColor = UIColorFromHEX(0x999999, 1);
        _rightSubLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _rightSubLabel;
}
- (UILabel *)leftSubLabel{
    if (!_leftSubLabel) {
        _leftSubLabel = [[UILabel alloc]init];
        _leftSubLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
        _leftSubLabel.textColor = UIColorFromHEX(0x999999, 1);
        _leftSubLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _leftSubLabel;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:15];
        _titleLabel.textColor = UIColorFromHEX(0x333333, 1);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
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
