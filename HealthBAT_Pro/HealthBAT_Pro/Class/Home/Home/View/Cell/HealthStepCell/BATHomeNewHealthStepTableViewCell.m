//
//  BATHomeNewHealthStepTableViewCell.m
//  HealthBAT_Pro
//
//  Created by KM on 17/5/102017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHomeNewHealthStepTableViewCell.h"

@implementation BATHomeNewHealthStepTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        WEAK_SELF(self);
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.leftView];
        [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(@0);
            make.size.mas_equalTo(CGSizeMake(340.0/750*SCREEN_WIDTH, 290.0/750*SCREEN_WIDTH));
        }];
        
        [self.contentView addSubview:self.calView];
        [self.calView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.leftView.mas_right).offset(0);
            make.top.equalTo(@0);
            make.size.mas_equalTo(CGSizeMake(410.0/750*SCREEN_WIDTH, 145.0/750*SCREEN_WIDTH));
        }];
        
        [self.contentView addSubview:self.fatView];
        [self.fatView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.leftView.mas_right).offset(0);
            make.top.equalTo(self.calView.mas_bottom).offset(0);
            make.size.mas_equalTo(CGSizeMake(410.0/750*SCREEN_WIDTH, 145.0/750*SCREEN_WIDTH));
        }];
    }
    return self;
}

- (BATHomeHealthStepLeftView *)leftView {
    
    if (!_leftView) {
        
        _leftView = [[BATHomeHealthStepLeftView alloc] initWithFrame:CGRectZero];
        [_leftView setRightBorderWithColor:BASE_LINECOLOR width:0.5 height:290.0/750*SCREEN_WIDTH];
    }
    return _leftView;
}

- (BATHomeHealthStepRightView *)calView {
    
    if (!_calView) {
        
        _calView = [[BATHomeHealthStepRightView alloc] initWithFrame:CGRectZero];
        _calView.rightImageView.image = [UIImage imageNamed:@"RoundedRectangle3"];
        _calView.unitLabel.text = @"cal";
        _calView.desLabel.text = @"消耗卡路里";
        [_calView setBottomBorderWithColor:BASE_LINECOLOR width:410.0/750*SCREEN_WIDTH height:0.5];
    }
    return _calView;
}

- (BATHomeHealthStepRightView *)fatView {
    
    if (!_fatView) {
        
        _fatView = [[BATHomeHealthStepRightView alloc] initWithFrame:CGRectZero];
        _fatView.rightImageView.image = [UIImage imageNamed:@"RoundedRectangle4"];
        _fatView.unitLabel.text = @"g";
        _fatView.desLabel.text = @"消耗脂肪";
    }
    return _fatView;
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
