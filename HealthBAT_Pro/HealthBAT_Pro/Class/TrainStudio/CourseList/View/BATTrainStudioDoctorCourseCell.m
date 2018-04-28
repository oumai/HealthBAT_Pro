//
//  BATTrainStudioDoctorCourseCell.m
//  HealthBAT_Pro
//
//  Created by four on 17/4/1.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATTrainStudioDoctorCourseCell.h"

@implementation BATTrainStudioDoctorCourseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        WEAK_SELF(self);
        [self.contentView addSubview:self.headerImageView];
        [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(@10);
            make.left.equalTo(self.mas_left).offset(15);
            make.height.mas_equalTo(63).priorityHigh();
            make.width.mas_equalTo(106);
            make.bottom.equalTo(@-10);
        }];
        
        [self.contentView addSubview:self.nameLable];
        [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.headerImageView.mas_right).offset(10);
            make.bottom.equalTo(self.headerImageView.mas_centerY).offset(-10);
        }];
        
        [self.contentView addSubview:self.typeLable];
        [self.typeLable mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.headerImageView.mas_right).offset(10);
            make.top.equalTo(self.headerImageView.mas_centerY).offset(10);
        }];
        
        [self setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0.25f];
        [self setTopBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0.25f];
    }
    
    return self;
}


- (UIImageView *)headerImageView{
    if(!_headerImageView){
        _headerImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _headerImageView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _headerImageView;
}

- (UILabel *)nameLable{
    if (!_nameLable) {
        _nameLable = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:UIColorFromHEX(0x333333, 1) textAlignment:NSTextAlignmentLeft];
        _nameLable.numberOfLines = 0;
        [_nameLable sizeToFit];
    }
    
    return _nameLable;
}

- (UILabel *)typeLable{
    if (!_typeLable) {
        _typeLable = [UILabel labelWithFont:[UIFont systemFontOfSize:13] textColor:UIColorFromHEX(0x666666, 1) textAlignment:NSTextAlignmentLeft];
        [_typeLable sizeToFit];
        _typeLable.numberOfLines = 0;
    }
    
    return _typeLable;
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
