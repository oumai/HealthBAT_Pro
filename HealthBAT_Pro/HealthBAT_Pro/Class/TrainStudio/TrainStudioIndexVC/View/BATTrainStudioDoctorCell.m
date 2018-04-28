//
//  BATTrainStudioDoctorCell.m
//  HealthBAT_Pro
//
//  Created by four on 17/4/1.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATTrainStudioDoctorCell.h"

@implementation BATTrainStudioDoctorCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        WEAK_SELF(self);
        [self.contentView addSubview:self.headerImageView];
        [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(@10);
            make.left.equalTo(self.mas_left).offset(15);
            make.height.mas_equalTo(60).priorityHigh();
            make.width.mas_equalTo(60);
            make.bottom.equalTo(@-10);
        }];
        
        [self.contentView addSubview:self.nameLable];
        [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.headerImageView.mas_right).offset(10);
            make.top.equalTo(self.contentView.mas_top).offset(10);
        }];
        
        [self.contentView addSubview:self.levelLable];
        [self.levelLable mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.headerImageView.mas_right).offset(10);
            make.top.equalTo(self.nameLable.mas_bottom).offset(5);
        }];
        
        [self.contentView addSubview:self.skillLable];
        [self.skillLable mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.headerImageView.mas_right).offset(10);
            make.top.equalTo(self.levelLable.mas_bottom).offset(5);
            make.right.equalTo(self.mas_right).offset(-10);
        }];
        
        [self.contentView addSubview:self.courseBtn];
        [self.courseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.contentView.mas_top).offset(10);
            make.right.equalTo(self.mas_right).offset(-10);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(80);
        }];
        
        [self setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0.25f];
        [self setTopBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0.25f];
    }
    
    return self;
}


- (UIImageView *)headerImageView{
    if(!_headerImageView){
        _headerImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _headerImageView.layer.cornerRadius = 30.f;
        _headerImageView.clipsToBounds = YES;
        _headerImageView.opaque = YES;
        _headerImageView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _headerImageView;
}

- (UILabel *)nameLable{
    if (!_nameLable) {
        _nameLable = [UILabel labelWithFont:[UIFont systemFontOfSize:18] textColor:UIColorFromHEX(0x333333, 1) textAlignment:NSTextAlignmentLeft];
        [_nameLable sizeToFit];
    }
    
    return _nameLable;
}

- (UILabel *)skillLable{
    if (!_skillLable) {
        _skillLable = [UILabel labelWithFont:[UIFont systemFontOfSize:13] textColor:UIColorFromHEX(0x666666, 1) textAlignment:NSTextAlignmentLeft];
        [_skillLable sizeToFit];
        _skillLable.numberOfLines = 0;
    }
    
    return _skillLable;
}


- (BATGraditorButton *)courseBtn{
    if (!_courseBtn) {
//        _courseBtn = [UIButton  buttonWithType:UIButtonTypeCustom Title:@"他的课程" titleColor:UIColorFromHEX(0x0182eb, 1) backgroundColor:nil backgroundImage:nil Font:[UIFont systemFontOfSize:14]];
//        _courseBtn.layer.cornerRadius = 2;
//        _courseBtn.layer.borderColor = UIColorFromHEX(0x0182eb, 1).CGColor;
//        _courseBtn.layer.borderWidth = 1;
        
        
        _courseBtn = [BATGraditorButton buttonWithType:UIButtonTypeCustom];
        [_courseBtn setTitle:@"他的课程" forState:UIControlStateNormal];
        _courseBtn.layer.cornerRadius = 5.0f;
        _courseBtn.layer.masksToBounds = YES;
        _courseBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_courseBtn setGradientColors:@[START_COLOR,END_COLOR]];
        [_courseBtn bk_whenTapped:^{
            if (self.courseBtnClickBlock) {
                self.courseBtnClickBlock();
            }
        }];
    }
    return _courseBtn;
}

- (UILabel *)levelLable{
    if (!_levelLable) {
        _levelLable = [UILabel labelWithFont:[UIFont systemFontOfSize:16] textColor:UIColorFromHEX(0xfc9f26, 1) textAlignment:NSTextAlignmentLeft];
        [_levelLable sizeToFit];
    }
    
    return _levelLable;
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
