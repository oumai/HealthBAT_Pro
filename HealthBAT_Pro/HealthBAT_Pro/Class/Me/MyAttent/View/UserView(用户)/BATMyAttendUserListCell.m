//
//  BATMyAttendUserListCell.m
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/5/13.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATMyAttendUserListCell.h"
#import "BATMyAttendUserListModel.h"
#import "BATPerson.h"
@interface BATMyAttendUserListCell ()
/** <#属性描述#> */
@property (nonatomic, strong) UILabel *nameLabel;
/** <#属性描述#> */
@property (nonatomic, strong) UIImageView *iconImageView;
/** <#属性描述#> */
@property (nonatomic, strong) UIButton *sexButton;
/** <#属性描述#> */
@property (nonatomic, strong) UIButton *focusButton;
@property (nonatomic, strong) UIButton *focusButton2;
@property (nonatomic, strong) BATPerson *currentLoginUserModel;
@property (nonatomic, assign) BOOL isMe;
@end
@implementation BATMyAttendUserListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.sexButton];
        [self.contentView addSubview:self.focusButton];
        [self.contentView addSubview:self.focusButton2];
        _currentLoginUserModel = PERSON_INFO;
    }
    return self;
}

- (void)setUserListModel:(BATMyAttendUserListModel *)userListModel{
    _userListModel = userListModel;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:userListModel.PhotoPath] placeholderImage:[UIImage imageNamed:@"用户"]];
    self.nameLabel.text = userListModel.UserName;
    self.sexButton.selected = !userListModel.Sex;
    
    self.focusButton.hidden = [[NSString stringWithFormat:@"%ld",(long)self.currentLoginUserModel.Data.AccountID] isEqualToString: userListModel.AccountID];
    
    /**
     isAttend 为1，表示当前用户在查看自己所关注的用户列表
     isAttend 为0 表示当前用户在查看别人所关注的用户列表
     
     当自己看自己的用户列表时 ： IsUserFollow  1 互相关注 0 已经关注 （自己）
     
     当自己看别人的用户列表时 ： IsUserFollow  1 已经关注 0 没有关注 （他人）
     
     */
    
    NSString *userId  = [NSString stringWithFormat:@"%ld",(long)self.currentLoginUserModel.Data.AccountID];
    if ([self.userID isEqualToString:userId]) {
        if (userListModel.isAttend ) {
            
            if (userListModel.IsUserFollow) {
                
                [self.focusButton setImage:[UIImage imageNamed:@"person_xhgz"] forState:UIControlStateNormal];
                
            }else {
                [self.focusButton setImage:[UIImage imageNamed:@"person_yjgz"] forState:UIControlStateNormal];
            }
            
        }else {
            
            
            [self.focusButton setImage:[UIImage imageNamed:@"person_jgz"] forState:UIControlStateNormal];
            
        }
        
    }else{
        
        if (userListModel.IsUserFollow) {
            [self.focusButton setImage:[UIImage imageNamed:@"person_yjgz"] forState:UIControlStateNormal];
        }else{
            [self.focusButton setImage:[UIImage imageNamed:@"person_jgz"] forState:UIControlStateNormal];
        }
    }
    
    
}

- (void)focusButtonClick:(UIButton *)focusBtn{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(focuseButtonDidClick:userModel:)]) {
        [self.delegate focuseButtonDidClick:focusBtn userModel:self.userListModel];
    }
    
}
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
    
    [self.focusButton2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(30);
    }];
    
    
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
