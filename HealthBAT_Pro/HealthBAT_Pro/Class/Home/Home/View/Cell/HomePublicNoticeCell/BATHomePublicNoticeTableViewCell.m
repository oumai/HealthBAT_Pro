//
//  PublicNoticeCollectionViewCell.m
//  HealthBAT
//
//  Created by KM on 16/8/182016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATHomePublicNoticeTableViewCell.h"


@implementation BATHomePublicNoticeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        WEAK_SELF(self);
        [self.contentView addSubview:self.iconImageView];
        
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerX.equalTo(self.mas_left).offset(SCREEN_WIDTH/3.0/2.0);
            make.centerY.equalTo(self.mas_centerY);
        }];

        [self.contentView addSubview:self.line];
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(SCREEN_WIDTH/3.0));
            make.top.equalTo(@0);
            make.bottom.equalTo(@0);
            make.width.mas_equalTo(0.5);
        }];

        [self.contentView addSubview:self.dotLabel];
        [self.dotLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.line.mas_right).offset(10);
            make.centerY.equalTo(self.mas_centerY);
        }];

        [self.contentView addSubview:self.publicNotice];
        [self.publicNotice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.line.mas_right).offset(18);
            make.top.bottom.equalTo(self);
            make.right.equalTo(self.mas_right).offset(-10);
        }];

        [self setTopBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0.5];
        [self setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0.5];
    }
    return self;
}

#pragma mark - SDCycleScrollViewDelegate 

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {

}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index  {
    
}


- (void)sendDataArray:(NSArray *)data {

    self.publicNotice.titlesGroup = [data copy];
}

#pragma mark - getter
- (UIImageView *)iconImageView {

    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"健康管家"]];
    }
    return _iconImageView;
}

- (SDCycleScrollView *)publicNotice {
    if (!_publicNotice) {
        _publicNotice = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:[UIImage imageNamed:@"默认图"]];
        _publicNotice.titleLabelBackgroundColor = [UIColor whiteColor];
        _publicNotice.titleLabelTextColor = UIColorFromHEX(0x333333, 1);
        
        _publicNotice.showPageControl = YES;
        _publicNotice.scrollDirection = UICollectionViewScrollDirectionVertical;
        _publicNotice.onlyDisplayText = YES;
        _publicNotice.autoScrollTimeInterval = 30.f;
    }
    return _publicNotice;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = BASE_LINECOLOR;
    }
    return _line;
}

- (UILabel *)dotLabel {

    if (!_dotLabel) {
        _dotLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:12] textColor:BASE_COLOR textAlignment:NSTextAlignmentLeft];
        _dotLabel.text = @"•";
    }
    return _dotLabel;
}
@end
