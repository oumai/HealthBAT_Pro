//
//  BATFindCommenCell.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2016/12/29.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATFindCommenCell.h"

@implementation BATFindCommenCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _titleLabels.font = [UIFont systemFontOfSize:15];
    _titleLabels.textColor = UIColorFromHEX(0x333333, 1);
    
    [self.contentView addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView).offset(0);
        make.height.mas_equalTo(1);
    }];
}

-(UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc]init];
        _bottomView.backgroundColor = BASE_BACKGROUND_COLOR;
    }
    return _bottomView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
