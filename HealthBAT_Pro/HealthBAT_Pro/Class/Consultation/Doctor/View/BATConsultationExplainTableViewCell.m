//
//  BATConsultationExplainTableViewCell.m
//  HealthBAT_Pro
//
//  Created by KM on 16/9/122016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATConsultationExplainTableViewCell.h"

@implementation BATConsultationExplainTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.explainLabel];
        [self.explainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.equalTo(@10);
            make.trailing.bottom.equalTo(@-10);
        }];
    }
    return self;
}

#pragma mark - getter
- (UILabel *)explainLabel {

    if (!_explainLabel) {
        _explainLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:12] textColor:UIColorFromHEX(0x666666, 1) textAlignment:NSTextAlignmentLeft];
        _explainLabel.numberOfLines = 0;
    }
    return _explainLabel;
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
