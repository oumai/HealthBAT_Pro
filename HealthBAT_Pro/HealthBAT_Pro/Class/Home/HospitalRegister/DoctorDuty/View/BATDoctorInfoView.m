//
//  DoctorInfoView.m
//  HealthBAT_Pro
//
//  Created by KM on 16/7/262016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATDoctorInfoView.h"

@implementation BATDoctorInfoView

- (instancetype)initWithFrame:(CGRect)frame imageUrl:(NSString *)imageUrl name:(NSString *)name level:(NSString *)level hospital:(NSString *)hospital des:(NSString *)des {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setBottomBorderWithColor:[UIColor grayColor] width:SCREEN_WIDTH height:0.5];
        WEAK_SELF(self);
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"医生"]];
        [self addSubview:self.headerImageView];
        [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.mas_left).offset(10);
            make.top.equalTo(self.mas_top).offset(10);
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];

        self.nameLabel.text = name;
        [self addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.headerImageView.mas_right).offset(10);
            make.top.equalTo(self.headerImageView.mas_top);
            make.right.equalTo(self.mas_right).offset(-10);
        }];

        switch ([level intValue]) {
            case 1:
                self.levelLabel.text = @"主任医生";
                break;
            case 2:
                self.levelLabel.text = @"副主任医生";
                break;
            case 3:
                self.levelLabel.text = @"主治医生";
                break;
            case 4:
                self.levelLabel.text = @"医师";
                break;
            default:
                self.levelLabel.text = @"医生";
                break;
        }
        [self addSubview:self.levelLabel];
        [self.levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.headerImageView.mas_right).offset(10);
            make.centerY.equalTo(self.headerImageView.mas_centerY);
            make.right.equalTo(self.mas_right).offset(-10);
        }];

        self.hospitalLabel.text = hospital;
        [self addSubview:self.hospitalLabel];
        [self.hospitalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.headerImageView.mas_right).offset(10);
            make.bottom.equalTo(self.headerImageView.mas_bottom);
            make.right.equalTo(self.mas_right).offset(-10);
        }];

        self.desLabel.text = des;
        [self addSubview:self.desLabel];
        [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.mas_left).offset(10);
            make.top.equalTo(self.headerImageView.mas_bottom).offset(10);
            make.right.equalTo(self.mas_right).offset(-10);
        }];

    }
    return self;
}

- (UIImageView *)headerImageView {
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc] init];
    }
    return _headerImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:14] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    }
    return _nameLabel;
}

- (UILabel *)levelLabel {
    if (!_levelLabel) {
        _levelLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:12] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    }
    return _levelLabel;
}

- (UILabel *)hospitalLabel {
    if (!_hospitalLabel) {
        _hospitalLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:12] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    }
    return _hospitalLabel;
}

- (UILabel *)desLabel {
    if (!_desLabel) {
        _desLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:12] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    }
    return _desLabel;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
