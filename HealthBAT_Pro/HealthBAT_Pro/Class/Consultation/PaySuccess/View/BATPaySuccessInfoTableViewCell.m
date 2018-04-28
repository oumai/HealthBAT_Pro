//
//  BATPaySuccessInfoTableViewCell.m
//  HealthBAT
//
//  Created by jlteams on 16/8/2.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATPaySuccessInfoTableViewCell.h"
#import "Masonry.h"

@implementation BATPaySuccessInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.textLabel.font = [UIFont systemFontOfSize:15];
        self.textLabel.textColor = UIColorFromHEX(0x666666, 1);
        self.detailTextLabel.font = [UIFont systemFontOfSize:15];
        self.detailTextLabel.textColor = UIColorFromHEX(0x333333, 1);
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _line = [[UILabel alloc] init];
        _line.backgroundColor = BASE_LINECOLOR;
        [self.contentView addSubview:_line];

        [self setupConstraints];
    }
    return self;
}

- (void)setupConstraints
{
    WEAK_SELF(self);

    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo((1.0 / [UIScreen mainScreen].scale));
    }];
}


@end
