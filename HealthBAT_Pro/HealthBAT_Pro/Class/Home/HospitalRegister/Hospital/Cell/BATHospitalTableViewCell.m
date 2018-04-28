//
//  HospitalTableViewCell.m
//  HealthBAT_Pro
//
//  Created by KM on 16/7/152016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATHospitalTableViewCell.h"

@implementation BATHospitalTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0];

        WEAK_SELF(self);
        [self.contentView addSubview:self.hospitalImageView];
        [self.hospitalImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.mas_left).offset(5);
            make.centerY.equalTo(self.mas_centerY);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(80);
        }];

        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.hospitalImageView.mas_right).offset(10);
            make.top.equalTo(self.hospitalImageView.mas_top);
            make.right.lessThanOrEqualTo(self.mas_right).offset(-5);
        }];

//        [self.contentView addSubview:self.registerTimesLabel];
//        [self.registerTimesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            STRONG_SELF(self);
//            make.right.equalTo(self.mas_right).offset(-5);
//            make.bottom.equalTo(self.mas_bottom).offset(-10);
//        }];

        [self.contentView addSubview:self.descriptionLabel];
        [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.hospitalImageView.mas_right).offset(10);
            make.right.lessThanOrEqualTo(self.mas_right).offset(-5);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
            make.bottom.lessThanOrEqualTo(self.mas_bottom).offset(-10);
        }];



    }
    return self;
}

#pragma mark -
- (UIImageView *)hospitalImageView {
    if (!_hospitalImageView) {
        _hospitalImageView = [[UIImageView alloc] init];
    }
    return _hospitalImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:14] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
        _nameLabel.numberOfLines = 0;
        _nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _nameLabel;
}

- (UILabel *)descriptionLabel {
    if (!_descriptionLabel) {
        _descriptionLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:12] textColor:[UIColor lightGrayColor] textAlignment:NSTextAlignmentLeft];
        _descriptionLabel.numberOfLines = 0;
        _descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _descriptionLabel;
}

- (UILabel *)registerTimesLabel {
    if (!_registerTimesLabel) {
        _registerTimesLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:9] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentRight];
    }
    return _registerTimesLabel;
}

#pragma mark -
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
