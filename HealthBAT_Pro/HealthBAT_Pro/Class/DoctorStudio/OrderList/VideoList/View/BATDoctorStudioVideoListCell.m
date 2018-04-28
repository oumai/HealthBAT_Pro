//
//  BATDoctorStudioVideoListCell.m
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/5/11.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDoctorStudioVideoListCell.h"
#import "UIImage+Tool.h"
@implementation BATDoctorStudioVideoListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        WEAK_SELF(self);
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
            STRONG_SELF(self);
            make.left.equalTo(@10);
            make.top.equalTo(self.nameLable.mas_bottom).offset(10);
        }];
        
        [self.contentView addSubview:self.serviceTimeLabel];
        [self.serviceTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(@10);
            make.top.equalTo(self.serviceTypeLabel.mas_bottom).offset(10);
        }];
        
        [self.contentView addSubview:self.separatorView];
        [self.separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(@0);
            make.top.equalTo(self.serviceTimeLabel.mas_bottom).offset(5);
            make.right.equalTo(@0);
            make.height.mas_equalTo(0.5);
        }];
        
        [self.contentView addSubview:self.consulationBtn];
        [self.consulationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-10);
            make.top.equalTo(self.serviceTimeLabel.mas_bottom).offset(10);
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

- (UIView *)separatorView {
    
    if (!_separatorView) {
        _separatorView = [[UIView alloc] init];
        _separatorView.backgroundColor = LineColor;
    }
    return _separatorView;
}

- (UIButton *)consulationBtn {
    
    if (!_consulationBtn) {
        
        _consulationBtn = [UIButton buttonWithType:UIButtonTypeCustom Title:nil titleColor:STRING_MID_COLOR backgroundColor:nil backgroundImage:[UIImage imageNamed:@"进入诊室"] Font:[UIFont systemFontOfSize:14]];
        _consulationBtn.layer.cornerRadius = 2;
        _consulationBtn.layer.masksToBounds = YES;
        _consulationBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [_consulationBtn setTitle:@"进入诊室" forState:UIControlStateHighlighted];
        [_consulationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_consulationBtn setBackgroundImage:[UIImage createImageWithColor:UIColorFromHEX(0x2accbe, 1)] forState:UIControlStateHighlighted];
        [_consulationBtn bk_whenTapped:^{
            if (self.consultationBlock) {
                self.consultationBlock();
            }
        }];
    }
    return _consulationBtn;
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
