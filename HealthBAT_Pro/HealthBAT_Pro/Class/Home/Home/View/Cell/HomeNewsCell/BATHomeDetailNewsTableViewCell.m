//
//  NewsTableViewCell.m
//  HealthBAT_Pro
//
//  Created by KM on 16/7/212016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATHomeDetailNewsTableViewCell.h"

@implementation BATHomeDetailNewsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        WEAK_SELF(self);

        [self.contentView addSubview:self.newsImageView];
        [self.newsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.centerY.equalTo(@0);
            make.height.mas_equalTo(75);
            make.width.mas_equalTo(100);
        }];

        [self.contentView addSubview:self.newsTitleLabel];
        [self.newsTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(@10);
            make.left.equalTo(self.newsImageView.mas_right).offset(10);
            make.right.equalTo(@-10);
        }];
        
//        [self.contentView addSubview:self.contentLabel];
//        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            
//            make.top.equalTo(self.newsTitleLabel.mas_bottom).offset(10);
//            make.left.equalTo(self.newsImageView.mas_right).offset(10);
//            make.right.equalTo(@-10);
//        }];

//        [self.contentView addSubview:self.sourceLabel];
//        [self.sourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            STRONG_SELF(self);
//            make.leading.equalTo(@10);
//            make.bottom.equalTo(self.mas_bottom).offset(-15);
//        }];

        [self.contentView addSubview:self.readTimeLabel];
        [self.readTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.newsImageView.mas_right).offset(10);
            make.bottom.equalTo(@-10);
        }];

        [self setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0.5];
    }
    return self;
}

#pragma mark - setter && getter
- (UIImageView *)newsImageView {

    if (!_newsImageView) {

        _newsImageView = [[UIImageView alloc] init];
        [_newsImageView sizeToFit];
    }
    return _newsImageView;
}

- (UILabel *)newsTitleLabel {

    if (!_newsTitleLabel) {

        _newsTitleLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:STRING_DARK_COLOR textAlignment:NSTextAlignmentLeft];
        _newsTitleLabel.numberOfLines = 2;
        _newsTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _newsTitleLabel;
}

- (UILabel *)contentLabel {
    
    if (!_contentLabel) {
        
        _contentLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:14] textColor:STRING_MID_COLOR textAlignment:NSTextAlignmentCenter];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (UILabel *)sourceLabel {

    if (!_sourceLabel) {

        _sourceLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:11] textColor:STRING_LIGHT_COLOR textAlignment:NSTextAlignmentCenter];
        }
    return _sourceLabel;
}

- (UILabel *)readTimeLabel {

    if (!_readTimeLabel) {

        _readTimeLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:11] textColor:STRING_LIGHT_COLOR textAlignment:NSTextAlignmentRight];
    }
    return _readTimeLabel;
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
