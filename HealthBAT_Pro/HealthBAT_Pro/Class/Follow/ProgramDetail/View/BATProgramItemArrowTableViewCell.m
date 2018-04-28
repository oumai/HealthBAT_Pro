//
//  BATProgramItemArrowTableViewCell.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/6/13.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATProgramItemArrowTableViewCell.h"

@implementation BATProgramItemArrowTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self pageLayout];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state

}


#pragma mark - pageLayout
- (void)pageLayout
{
    [self.contentView addSubview:self.arrowImageView];
    
    WEAK_SELF(self);
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.center.equalTo(self.contentView);
    }];
}

#pragma mark - get & set
- (UIImageView *)arrowImageView
{
    if (_arrowImageView == nil) {        
        _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconfont-arrow-down"]];
    }
    return _arrowImageView;
}

@end
