//
//  DrugAttributeCell.m
//  HealthBAT
//
//  Created by four on 16/8/25.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "DrugAttributeCell.h"

@implementation DrugAttributeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
//        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, MAXFLOAT)];
//        [_titleLabel setTextAlignment:NSTextAlignmentLeft];
//        _titleLabel.frame = CGRectMake(10, 5, SCREEN_WIDTH-20, MAXFLOAT);
//        _titleLabel.numberOfLines = 0;
//        _titleLabel.backgroundColor = [UIColor clearColor];
//        _titleLabel.textColor = UIColorFromHEX(0X333333,1);
//        [self.contentView addSubview:_titleLabel];
        
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setTextAlignment:NSTextAlignmentLeft];
        _titleLabel.numberOfLines = 0;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = UIColorFromHEX(0X333333,1);
        [self.contentView addSubview:_titleLabel];

        [self.contentView addSubview:self.bottomLine];
        [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(@0);
            make.height.mas_equalTo(0.5);
        }];


        WEAK_SELF(self);
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(5, 10, 0, 10));
        }];

    }
    return self;
}

- (UIView *)bottomLine {

    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = UIColorFromHEX(0xeeeeee, 1);
        _bottomLine.hidden = YES;
    }
    return _bottomLine;
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
