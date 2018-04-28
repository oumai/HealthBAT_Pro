//
//  BATDoctorStudioVideoDisableTableViewCell.m
//  HealthBAT_Pro
//
//  Created by KM on 17/5/132017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDoctorStudioVideoDisableTableViewCell.h"

@implementation BATDoctorStudioVideoDisableTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        [self.contentView addSubview:self.statusImageView];
        [self.statusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@15);
            make.right.equalTo(@-10);
        }];
        
        [self.contentView addSubview:self.nameLable];
        [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.top.equalTo(@10);
        }];
        
        [self.contentView addSubview:self.serviceTypeLabel];
        [self.serviceTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.top.equalTo(self.nameLable.mas_bottom).offset(10);
        }];
        
        [self.contentView addSubview:self.serviceTimeLabel];
        [self.serviceTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.top.equalTo(self.serviceTypeLabel.mas_bottom).offset(10);
            make.bottom.mas_equalTo(@-10);
        }];

    }
    return self;
}

#pragma mark -getter
- (UIImageView *)statusImageView {
    
    if (!_statusImageView) {
        _statusImageView = [[UIImageView alloc] init];
        [_statusImageView sizeToFit];
    }
    return _statusImageView;
}

- (UILabel *)nameLable {
    
    if (!_nameLable) {
        _nameLable = [UILabel labelWithFont:[UIFont systemFontOfSize:14] textColor:STRING_MID_COLOR textAlignment:NSTextAlignmentLeft];
    }
    return _nameLable;
}

- (UILabel *)serviceTypeLabel {
    
    if (!_serviceTypeLabel) {
        _serviceTypeLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:14] textColor:STRING_MID_COLOR textAlignment:NSTextAlignmentLeft];
    }
    return _serviceTypeLabel;
}

- (UILabel *)serviceTimeLabel {
    
    if (!_serviceTimeLabel) {
        _serviceTimeLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:14] textColor:STRING_MID_COLOR textAlignment:NSTextAlignmentLeft];
    }
    return _serviceTimeLabel;
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
