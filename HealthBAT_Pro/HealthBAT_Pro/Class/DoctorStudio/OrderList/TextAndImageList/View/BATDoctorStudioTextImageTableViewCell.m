//
//  BATDoctorStudioTextImageTableViewCell.m
//  HealthBAT_Pro
//
//  Created by KM on 17/4/122017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDoctorStudioTextImageTableViewCell.h"
#import "BATDoctorStudioOrderModel.h"
#import "BATPerson.h"
#import "UIImage+Tool.h"
@implementation BATDoctorStudioTextImageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        WEAK_SELF(self);
        [self.contentView addSubview:self.statusImageView];
        [self.statusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@15);
            make.right.equalTo(@-10);
        }];
        
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.top.equalTo(@15);
            make.right.equalTo(self.statusImageView.mas_left).offset(-10).priorityLow();
        }];
        
        
        [self.contentView addSubview:self.serviceDoctorLabel];
        [self.serviceDoctorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.nameLabel);
            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(10);
        }];
        
        [self.contentView addSubview:self.orderTimeLabel];
        [self.orderTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(@10);
            make.top.equalTo(self.serviceDoctorLabel.mas_bottom).offset(10);
            make.right.equalTo(@-10);
        }];
 
        [self.contentView addSubview:self.serveTimeLabel];
        [self.serveTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(@10);
            make.top.equalTo(self.orderTimeLabel.mas_bottom).offset(10);
            make.right.equalTo(@-10);
        }];
        
        
        [self.contentView addSubview:self.separatorView];
        [self.separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(@0);
            make.top.equalTo(self.serveTimeLabel.mas_bottom).offset(20);
            make.right.equalTo(@0);
            make.height.mas_equalTo(0.5);
        }];
        
        [self.contentView addSubview:self.actionButton];
        [self.actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.right.equalTo(@-10);
            make.top.equalTo(self.separatorView.mas_bottom).offset(10);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(75);
            make.bottom.equalTo(@-10);
        }];
        
        [self.contentView addSubview:self.commentButton];
        [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
             STRONG_SELF(self);
            make.right.mas_equalTo(self.actionButton.mas_left).offset(-10);
            make.width.height.mas_equalTo(self.actionButton);
            make.top.mas_equalTo(self.actionButton.mas_top);
                    
        }];
    }
    return self;
}

#pragma mark - getter
- (UILabel *)serviceDoctorLabel{
    if (!_serviceDoctorLabel) {
        _serviceDoctorLabel = [[UILabel alloc]init];
        _serviceDoctorLabel.textColor = STRING_MID_COLOR;
        _serviceDoctorLabel.font = [UIFont systemFontOfSize:15];
        _serviceDoctorLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _serviceDoctorLabel;
}
- (UILabel *)nameLabel {
    
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.textColor = STRING_MID_COLOR;
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
}

- (UIImageView *)statusImageView {
    
    if (!_statusImageView) {
        _statusImageView = [[UIImageView alloc] init];
        [_statusImageView sizeToFit];
    }
    return _statusImageView;
}

- (UILabel *)serveTimeLabel {
    
    if (!_serveTimeLabel) {
        _serveTimeLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:16] textColor:STRING_MID_COLOR textAlignment:NSTextAlignmentLeft];
    }
    return _serveTimeLabel;
}

- (UILabel *)orderTimeLabel {
    
    if (!_orderTimeLabel) {
        _orderTimeLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:16] textColor:STRING_MID_COLOR textAlignment:NSTextAlignmentLeft];
    }
    return _orderTimeLabel;
}

- (UIView *)separatorView {
    
    if (!_separatorView) {
        _separatorView = [[UIView alloc] init];
        _separatorView.backgroundColor = LineColor;
    }
    return _separatorView;
}
- (UIButton *)commentButton {
    if (!_commentButton) {
        _commentButton = [UIButton buttonWithType:UIButtonTypeCustom Title:nil titleColor:nil backgroundColor:nil backgroundImage:[UIImage imageNamed:@"评价"] Font:nil];
        _commentButton.layer.cornerRadius = 2;
        _commentButton.layer.masksToBounds = YES;
        _commentButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
        [_commentButton setTitle:@"评价" forState:UIControlStateHighlighted];
        [_commentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_commentButton setBackgroundImage:[UIImage createImageWithColor:UIColorFromHEX(0x2accbe, 1)] forState:UIControlStateHighlighted];
        [_commentButton bk_whenTapped:^{
            if (self.commentBlock) {
                self.commentBlock();
            }
        }];
    }
    return _commentButton;
}
- (UIButton *)actionButton {
    
    if (!_actionButton) {
        _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _actionButton.layer.cornerRadius = 2;
        _actionButton.layer.masksToBounds = YES;
        [_actionButton setTitleColor:BASE_COLOR forState:UIControlStateNormal];
        _actionButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _actionButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
        [_actionButton bk_whenTapped:^{
            if (self.actionBlock) {
                self.actionBlock();
            }
        }];
    }
    return _actionButton;
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
