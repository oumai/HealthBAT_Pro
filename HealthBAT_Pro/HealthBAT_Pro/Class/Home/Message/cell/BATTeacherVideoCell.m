//
//  BATTeacherVideoCell.m
//  HealthBAT_Pro
//
//  Created by four on 16/12/10.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATTeacherVideoCell.h"

@implementation BATTeacherVideoCell

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
        
        [self.contentView addSubview:self.videoImageV];
        [self.videoImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
//            make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
            make.bottom.equalTo(self.mas_bottom).offset(- 15 - 12);
            make.left.equalTo(self.blackBGView.mas_left).offset(12.5);
            make.height.mas_offset(145);
            make.width.mas_offset(SCREEN_WIDTH - 88 - 25);
        }];
        
        [self.contentView addSubview:self.videoIcon];
        [self.videoIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerX.equalTo(self.videoImageV.mas_centerX);
            make.centerY.equalTo(self.videoImageV.mas_centerY);
            make.height.mas_offset(57);
            make.width.mas_offset(57);
        }];
        
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.bottom.equalTo(self.videoImageV.mas_bottom).offset(-1);
            make.left.equalTo(self.videoImageV.mas_left).offset(10);
            make.height.mas_offset(20);
            make.width.mas_offset(SCREEN_WIDTH - 88 - 25);
        }];
        
        [self.contentView addSubview:self.subTitleLabel];
        [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.bottom.equalTo(self.nameLabel.mas_top).offset(-2);
            make.left.equalTo(self.nameLabel.mas_left);
            make.height.mas_offset(20);
            make.width.mas_offset(SCREEN_WIDTH - 88 - 25 - 20);
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
        
    }
    return _titleLabel;
}


- (UIImageView *)videoImageV{
    if (!_videoImageV) {
        _videoImageV = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _videoImageV;
}

- (UIImageView *)videoIcon{
    if(!_videoIcon){
        _videoIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        _videoIcon.image = [UIImage imageNamed:@"message-video-icon"];
    }
    return _videoIcon;
}

- (UILabel *)subTitleLabel{
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc]init];
        _subTitleLabel.textAlignment = NSTextAlignmentLeft;
        _subTitleLabel.textColor = [UIColor whiteColor];
        _subTitleLabel.font = [UIFont systemFontOfSize:13];
        [_subTitleLabel sizeToFit];
    }
    return _subTitleLabel;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
//        _nameLabel.textColor = UIColorFromHEX(0x666666, 1);
        _nameLabel.textColor = [UIColor whiteColor];
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
