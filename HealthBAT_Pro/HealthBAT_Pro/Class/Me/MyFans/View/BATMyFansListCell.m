//
//  BATMyFansListCell.m
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/5/14.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATMyFansListCell.h"
#import "BATMyFansListModel.h"
#import "BATPerson.h"


@interface BATMyFansListCell ()
/** name */
@property (nonatomic, strong) UILabel *nameLabel;
/** 头像 */
@property (nonatomic, strong) UIImageView *iconImageView;
/** 性别 */
@property (nonatomic, strong) UIButton *sexButton;
/** 关注按钮 */
@property (nonatomic, strong) UIButton *focusButton;

/** 当前登录的用户模型 */
@property (nonatomic, strong) BATPerson *loginUserModel;
@property (nonatomic, strong) NSString *loginUserID;
@end

@implementation BATMyFansListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.sexButton];
        [self.contentView addSubview:self.focusButton];
        _loginUserModel = PERSON_INFO;
        _loginUserID = [NSString stringWithFormat:@"%ld",(long)_loginUserModel.Data.AccountID];
        
     
    }
    return self;
}

#pragma mark - setter
- (void)setFansListModel:(BATMyFansListModel *)fansListModel{
    _fansListModel = fansListModel;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:fansListModel.PhotoPath] placeholderImage:[UIImage imageNamed:@"用户"]];
    self.nameLabel.text = fansListModel.UserName;
    self.sexButton.selected = !fansListModel.Sex;
    // 1 关注 0 没有
    self.focusButton.selected = fansListModel.IsUserFollow;
    self.focusButton.hidden = [_loginUserID isEqualToString:fansListModel.AccountID];
    
}

#pragma mark - action
- (void)focusButtonClick:(UIButton *)focusBtn{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(focusButtonDidClick:fansModel:)]) {
        [self.delegate focusButtonDidClick:focusBtn fansModel:self.fansListModel];
    }
}

#pragma mark - layoutSubviews
- (void)layoutSubviews{
    [super layoutSubviews];
    
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@10);
        make.top.mas_equalTo(10);
        make.width.height.mas_equalTo(@50);
        
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.iconImageView.mas_right).offset(10);
    }];
    
    [self.sexButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImageView.mas_top);
        make.left.mas_equalTo(self.iconImageView.mas_right).offset(-9);
        make.width.height.mas_equalTo(@18);
    }];
    
    [self.focusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(30);
    }];
    
    
    
}

#pragma mark - setter
- (UIButton *)focusButton{
    if (!_focusButton) {
        _focusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_focusButton setImage:[UIImage imageNamed:@"person_jgz"] forState:UIControlStateNormal];
        [_focusButton setImage:[UIImage imageNamed:@"person_yjgz"] forState:UIControlStateSelected];
        [_focusButton addTarget:self action:@selector(focusButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _focusButton;
}
- (UIButton *)sexButton{
    if (!_sexButton) {
        _sexButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sexButton.layer.cornerRadius = 9;
        _sexButton.layer.masksToBounds = YES;
        [_sexButton setImage:[UIImage imageNamed:@"sex_boy"] forState:UIControlStateNormal];
        [_sexButton setImage:[UIImage imageNamed:@"sex_girl"] forState:UIControlStateSelected];
    }
    return _sexButton;
}
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:15];
        _nameLabel.textColor = UIColorFromHEX(0x333333, 1);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
}
- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.layer.cornerRadius = 25;
        _iconImageView.layer.masksToBounds = YES;
    }
    return _iconImageView;
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

