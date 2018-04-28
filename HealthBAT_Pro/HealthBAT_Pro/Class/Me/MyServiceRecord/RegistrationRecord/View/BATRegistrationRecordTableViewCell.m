//
//  BATRegistrationRecordTableViewCell.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/23.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATRegistrationRecordTableViewCell.h"

@implementation BATRegistrationRecordTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:17];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_nameLabel];
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:14];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        [_timeLabel sizeToFit];
        [self.contentView addSubview:_timeLabel];
        
        _docNameLabel = [[UILabel alloc] init];
        _docNameLabel.font = [UIFont systemFontOfSize:14];
        _docNameLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_docNameLabel];
        
        _adressLabel = [[UILabel alloc] init];
        _adressLabel.numberOfLines = 0;
        _adressLabel.font = [UIFont systemFontOfSize:14];
        _adressLabel.textAlignment = NSTextAlignmentLeft;
        [_adressLabel sizeToFit];
        [self.contentView addSubview:_adressLabel];
        
        _registerState = [[UILabel alloc] init];
        _registerState.font = [UIFont systemFontOfSize:14];
        _registerState.textAlignment = NSTextAlignmentCenter;
        [_registerState sizeToFit];
        _registerState.hidden = YES;
        [self.contentView addSubview:_registerState];
        
        _cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cancelButton setTitle:@"取消挂号" forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _cancelButton.layer.borderWidth = 1.0;
        _cancelButton.layer.cornerRadius = 3.0;
        _cancelButton.layer.borderColor = UIColorFromRGB(26, 162, 215, 1).CGColor;
        _cancelButton.hidden = YES;
        [self.contentView addSubview:_cancelButton];
        
        [self setupConstraints];
    }
    return self;
}

- (void)setupConstraints
{
    WEAK_SELF(self);
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.height.mas_equalTo(30);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(_nameLabel.mas_right).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.top.equalTo(_nameLabel.mas_top);
        make.height.mas_equalTo(30);
    }];
    
    [_docNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.top.equalTo(_nameLabel.mas_bottom).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.height.mas_equalTo(30);
    }];
    
    [_adressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.top.equalTo(_docNameLabel.mas_bottom).offset(10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];
    
    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(100);
        make.top.equalTo(_docNameLabel.mas_bottom);
        make.left.greaterThanOrEqualTo(_adressLabel.mas_right).offset(10);
    }];
    
    [_registerState mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.top.equalTo(_adressLabel.mas_top);
        make.left.greaterThanOrEqualTo(_adressLabel.mas_right).offset(10);
    }];

}

@end
