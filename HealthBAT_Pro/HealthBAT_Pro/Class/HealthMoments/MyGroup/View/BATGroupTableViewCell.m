//
//  GroupTableViewCell.m
//  HealthBAT_Pro
//
//  Created by KM on 16/7/212016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATGroupTableViewCell.h"

@implementation BATGroupTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        WEAK_SELF(self);
        [self.contentView addSubview:self.groupImageView];
        [self.groupImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.contentView.mas_left).offset(15);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(70, 70));
        }];

        [self.contentView addSubview:self.groupNameLabel];
        [self.groupNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.groupImageView.mas_right).offset(8);
            make.top.equalTo(self.groupImageView.mas_top);
            make.right.equalTo(self.contentView.mas_right).offset(-15);
            make.height.mas_equalTo(21);
        }];

        [self.contentView addSubview:self.memberLabel];
        [self.memberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.groupImageView.mas_right).offset(8);
            make.top.equalTo(self.groupNameLabel.mas_bottom).offset(3);
            make.right.equalTo(self.contentView.mas_right).offset(15);
            make.height.mas_equalTo(21);
        }];

        [self.contentView addSubview:self.descriptionLabel];
        [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.groupImageView.mas_right).offset(8);
            make.top.equalTo(self.memberLabel.mas_bottom).offset(4);
            make.right.equalTo(self.contentView.mas_right).offset(-15);
        }];
    }
    return self;
}

#pragma mark - setter && getter
- (UIImageView *)groupImageView {
    if (!_groupImageView) {
        _groupImageView = [[UIImageView alloc] init];
    }
    return _groupImageView;
}

- (UILabel *)groupNameLabel {
    if (!_groupNameLabel) {
        _groupNameLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    }
    return _groupNameLabel;
}

- (UILabel *)memberLabel {
    if (!_memberLabel) {
        _memberLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:12] textColor:[UIColor lightGrayColor] textAlignment:NSTextAlignmentLeft];
    }
    return _memberLabel;
}

- (UILabel *)descriptionLabel {
    if (!_descriptionLabel) {
        _descriptionLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:12] textColor:[UIColor lightGrayColor] textAlignment:NSTextAlignmentLeft];
        _descriptionLabel.numberOfLines = 2;
        _descriptionLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _descriptionLabel;
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
