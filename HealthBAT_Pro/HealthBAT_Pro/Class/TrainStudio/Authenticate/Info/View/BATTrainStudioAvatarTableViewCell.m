//
//  BATTrainStudioAvatarTableViewCell.m
//  HealthBAT_Pro
//
//  Created by Skybrim on 2017/4/5.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATTrainStudioAvatarTableViewCell.h"

@implementation BATTrainStudioAvatarTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        WEAK_SELF(self);
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(@0);
            make.left.equalTo(@10);
        }];
        
        [self.contentView addSubview:self.rightArrow];
        [self.rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(@0);
            make.right.equalTo(@-10);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];

        
        [self addSubview:self.avatarImageView];
        [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerY.equalTo(@0);
            make.right.equalTo(self.rightArrow.mas_left).offset(-10);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        
        //设置cell的separator
        [self setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:16] textColor:UIColorFromHEX(0x333333, 1) textAlignment:NSTextAlignmentLeft];
    }
    return _titleLabel;
}

- (UIImageView *)avatarImageView {
    
    if (!_avatarImageView) {
       
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.backgroundColor = [UIColor clearColor];
        _avatarImageView.layer.cornerRadius = 20;
        _avatarImageView.layer.masksToBounds = YES;
    }
    return _avatarImageView;
}

- (UIImageView *)rightArrow {
    
    if (!_rightArrow) {
        _rightArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_arrow_right"]];
        [_rightArrow sizeToFit];
    }
    return _rightArrow;
}
@end
