//
//  BATTeacherMessageCell.m
//  HealthBAT_Pro
//
//  Created by four on 16/12/8.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATTeacherMessageCell.h"

@implementation BATTeacherMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        WEAK_SELF(self);
        [self.contentView addSubview:self.dateLabel];
        [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.mas_top).offset(18);
            make.centerX.equalTo(self.mas_centerX);
            make.height.mas_offset(20);
            make.width.mas_offset(SCREEN_WIDTH);
        }];
        
        [self.contentView addSubview:self.doctorImageV];
        [self.doctorImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.dateLabel.mas_bottom).offset(15);
            make.left.equalTo(self.mas_left).offset(14);
            make.height.mas_offset(48);
            make.width.mas_offset(48);
        }];
        
        [self.contentView addSubview:self.blackBGView];
        
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.blackBGView.mas_top).offset(10);
            make.left.equalTo(self.blackBGView.mas_left).offset(12);
            make.width.mas_offset(SCREEN_WIDTH - 88 - 24);
        }];
        
        [self.blackBGView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.dateLabel.mas_bottom).offset(15);
            make.left.equalTo(self.doctorImageV.mas_right).offset(12);
            make.bottom.equalTo(self.mas_bottom).offset(-15);
            make.width.mas_offset(SCREEN_WIDTH - 88);
        }];
        
        [self.contentView addSubview:self.whiteBGView];
        [self.whiteBGView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
//            make.top.equalTo(self.titleLabel.mas_bottom).offset(7);
            make.bottom.equalTo(self.mas_bottom).offset(-27);
            make.left.equalTo(self.blackBGView.mas_left).offset(12);
            make.height.mas_offset(76);
            make.width.mas_offset(SCREEN_WIDTH - 88 - 24);
        }];
        
        [self.contentView addSubview:self.iconImageV];
        [self.iconImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.whiteBGView.mas_top).offset(9.5);
            make.left.equalTo(self.whiteBGView.mas_left).offset(9.5);
            make.height.mas_offset(57);
            make.width.mas_offset(57);
        }];
        
        [self.contentView addSubview:self.subTitleLabel];
        [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.bottom.equalTo(self.iconImageV.mas_centerY).offset(-3);
            make.left.equalTo(self.iconImageV.mas_right).offset(10);
            make.height.mas_offset(20);
            make.width.mas_offset(SCREEN_WIDTH - 88 - 24 - 81);
        }];

        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.iconImageV.mas_centerY).offset(3);
            make.left.equalTo(self.iconImageV.mas_right).offset(10);
            make.height.mas_offset(20);
            make.width.mas_offset(SCREEN_WIDTH - 88 - 24 - 81);
        }];

    }
    return self;
}

//绘制三角形
- (void)drawRect:(CGRect)rect{
    // 1.获得上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 2.画三角形
    CGContextMoveToPoint(ctx, 76, 64);
    CGContextAddLineToPoint(ctx, 68, 73);
    CGContextAddLineToPoint(ctx, 76, 81);
    // 关闭路径(连接起点和最后一个点)
    CGContextClosePath(ctx);
    
    [BASE_LINECOLOR setFill];
    
    // 3.绘制图形
    CGContextFillPath(ctx);
}

- (UILabel *)dateLabel{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc]init];
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        _dateLabel.textColor = UIColorFromHEX(0x666666, 1);
        _dateLabel.font = [UIFont systemFontOfSize:13];
    }
    return _dateLabel;
}

- (UIImageView *)doctorImageV{
    if(!_doctorImageV){
        _doctorImageV = [[UIImageView alloc] initWithFrame:CGRectZero];
        _doctorImageV.layer.cornerRadius = 30.0f;
    }
    return _doctorImageV;
}



- (UIView *)blackBGView{
    if (!_blackBGView) {
        _blackBGView = [[UIView alloc]init];
        _blackBGView.backgroundColor = BASE_LINECOLOR;
        _blackBGView.layer.cornerRadius = 5.0F;
    }
    return _blackBGView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = UIColorFromHEX(0x666666, 1);
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.numberOfLines = 0;
//        _titleLabel.backgroundColor = [UIColor redColor];
        
    }
    return _titleLabel;
}


- (UIView *)whiteBGView{
    if (!_whiteBGView) {
        _whiteBGView = [[UIView alloc]init];
        _whiteBGView.backgroundColor = [UIColor whiteColor];
    }
    return _whiteBGView;
}

- (UIImageView *)iconImageV{
    if(!_iconImageV){
        _iconImageV = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _iconImageV;
}

- (UILabel *)subTitleLabel{
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc]init];
        _subTitleLabel.textAlignment = NSTextAlignmentLeft;
        _subTitleLabel.textColor = UIColorFromHEX(0x666666, 1);
        _subTitleLabel.font = [UIFont systemFontOfSize:13];
        [_subTitleLabel sizeToFit];
    }
    return _subTitleLabel;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.textColor = UIColorFromHEX(0x666666, 1);
        _nameLabel.font = [UIFont systemFontOfSize:14];
        [_nameLabel sizeToFit];
    }
    return _nameLabel;
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
