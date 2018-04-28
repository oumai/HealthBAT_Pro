//
//  BATNewsCommentTableViewCell.m
//  HealthBAT_Pro
//
//  Created by Skyrim on 16/9/18.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATNewsCommentTableViewCell.h"

@implementation BATNewsCommentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        WEAK_SELF(self);
        [self.contentView addSubview:self.headImageView];
        [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.contentView.mas_left).offset(21);
            make.top.equalTo(self.contentView.mas_top).offset(10);
            make.size.mas_equalTo(CGSizeMake(35, 35));
        }];

        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.headImageView.mas_right).offset(12);
            make.top.equalTo(self.contentView.mas_top).offset(14);
        }];

        [self.contentView addSubview:self.contentLabel];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.headImageView.mas_right).offset(12);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(7);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
        }];

        [self.contentView addSubview:self.timeLabel];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.nameLabel.mas_right).offset(5);
            make.top.equalTo(self.nameLabel.mas_top);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
        }];

        [self setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0.5 leftOffset:10 rightOffset:10];
    }
    return self;
}

- (UIImageView *)headImageView {

    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.layer.cornerRadius = 35.0f / 2.0f;
        _headImageView.clipsToBounds = YES;
    }
    return _headImageView;
}

- (UILabel *)nameLabel {

    if (!_nameLabel) {
        _nameLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:14] textColor:UIColorFromHEX(0x333333, 1) textAlignment:NSTextAlignmentLeft];
    }
    return _nameLabel;
}

- (UILabel *)contentLabel {

    if (!_contentLabel) {
        _contentLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:12] textColor:UIColorFromHEX(0x666666, 1) textAlignment:NSTextAlignmentLeft];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}


- (UILabel *)timeLabel {

    if (!_timeLabel) {
        _timeLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:11] textColor:UIColorFromHEX(0x999999, 1) textAlignment:NSTextAlignmentLeft];
    }
    return _timeLabel;
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
