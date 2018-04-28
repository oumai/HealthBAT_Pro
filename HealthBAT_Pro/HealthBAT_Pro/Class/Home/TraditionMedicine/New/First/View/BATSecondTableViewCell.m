//
//  BATSecondTableViewCell.m
//  HealthBAT_Pro
//
//  Created by Skybrim on 2017/3/25.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATSecondTableViewCell.h"

@implementation BATSecondTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        WEAK_SELF(self);
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(@0);
            make.top.equalTo(@10);
        }];
        
        [self.contentView addSubview:self.segment];
        [self.segment mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
            make.centerX.equalTo(@0);
        }];
        
    }
    return self;
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:13] textColor:UIColorFromHEX(0xffffff, 1) textAlignment:NSTextAlignmentCenter];
    }
    return _titleLabel;
}

- (UISegmentedControl *)segment {
    
    if (!_segment) {
        _segment = [[UISegmentedControl alloc] initWithItems:nil];
        _segment.tintColor = [UIColor whiteColor];
        [_segment addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _segment;
}

- (void)segmentAction:(UISegmentedControl *)segment {

    if (self.segmentClick) {
        self.segmentClick(segment.selectedSegmentIndex);
    }
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
