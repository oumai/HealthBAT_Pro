//
//  BATDoctorHorderHotNoteTableViewCell.m
//  HealthBAT_Pro
//
//  Created by Skybrim on 2017/3/15.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDoctorHorderHotNoteTableViewCell.h"

@implementation BATDoctorHorderHotNoteTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        WEAK_SELF(self);
        [self.contentView addSubview:self.hotImageView];
        [self.hotImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.top.equalTo(@10);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        
        [self.contentView addSubview:self.titleLabel];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.hotImageView.mas_right).offset(10);
            make.centerY.equalTo(self.hotImageView);
            make.right.lessThanOrEqualTo(@-5);
        }];

        [self.contentView addSubview:self.detailLabel];
        [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.titleLabel.mas_left).offset(0);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(12);
            make.right.equalTo(@-5);
        }];

        [self.contentView addSubview:self.readCountLabel];
        [self.readCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.right.equalTo(@-10);
            make.top.equalTo(self.detailLabel.mas_bottom).offset(5);
        }];
        

        [self setTopBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0.5];
        
    }
    return self;
}

#pragma mark - getter
- (UIImageView *)hotImageView {
    
    if (!_hotImageView) {
        _hotImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-homehot"]];
        [_hotImageView sizeToFit];
    }
    return _hotImageView;
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:STRING_DARK_COLOR textAlignment:NSTextAlignmentLeft];
        _titleLabel.numberOfLines = 1;
    }
    return _titleLabel;
}

- (UILabel *)detailLabel {
    
    if (!_detailLabel) {
        _detailLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:13] textColor:STRING_MID_COLOR textAlignment:NSTextAlignmentLeft];
        _detailLabel.numberOfLines = 2;
    }
    return _detailLabel;
}

- (UILabel *)readCountLabel {
    
    if (!_readCountLabel) {
        _readCountLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:12] textColor:UIColorFromHEX(0x999999, 1) textAlignment:NSTextAlignmentLeft];
        _readCountLabel.numberOfLines = 1;
    }
    return _readCountLabel;
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
