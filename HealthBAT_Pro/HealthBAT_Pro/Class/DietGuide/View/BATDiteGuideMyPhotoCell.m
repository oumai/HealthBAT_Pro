//
//  BATDiteGuideMyPhotoCell.m
//  HealthBAT_Pro
//
//  Created by Carbon on 2017/10/30.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDiteGuideMyPhotoCell.h"
@interface BATDiteGuideMyPhotoCell ()
@property (nonatomic ,strong) UIImageView           *headImageV;
@property (nonatomic ,strong) UILabel               *nameLabel;
@property (nonatomic ,strong) UILabel               *timeLabel;
@property (nonatomic ,strong) UIImageView           *photoImageV;
@property (nonatomic ,strong) UIButton              *moreBtn;
@property (nonatomic ,strong) UILabel               *messageLabel;
//@property (nonatomic ,strong) UILabel               *descLabel;
@end

@implementation BATDiteGuideMyPhotoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

#pragma mark -- private
- (void)setupUI {
    UIView *lineV1 = [self getLineView];
    [self.contentView addSubview:lineV1];
    [self.contentView addSubview:self.headImageV];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.photoImageV];
    [self.contentView addSubview:self.moreBtn];
    [self.contentView addSubview:self.messageLabel];
//    [self.contentView addSubview:self.descLabel];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.headImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(9);
        make.left.equalTo(self.contentView).offset(16);
        make.width.height.mas_equalTo(28);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageV.mas_right).offset(10);
        make.centerY.equalTo(self.headImageV);
        make.width.equalTo(self.timeLabel.mas_width).multipliedBy(0.5);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).offset(20);
        make.right.equalTo(self.contentView).offset(-17);
        make.centerY.equalTo(self.headImageV);
    }];
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-17);
        make.centerY.equalTo(self.headImageV);
        make.width.mas_equalTo(21);
        make.height.mas_equalTo(5);
    }];
    [self.photoImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImageV.mas_bottom).offset(9);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(self.photoImageV.mas_width);
    }];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(self.photoImageV.mas_bottom).offset(5);
    }];
//    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.messageLabel.mas_bottom).offset(10);
//        make.left.equalTo(self.contentView).offset(10);
//    }];
    [lineV1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.messageLabel.mas_bottom).offset(15);
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(10);
    }];
}

- (void)setMyPhotoDataModel:(BATDiteGuideMyPhotoDataModel *)myPhotoDataModel {
    [self.headImageV sd_setImageWithURL:[NSURL URLWithString:myPhotoDataModel.UserPhoto] placeholderImage:[UIImage imageNamed:@"img-ys"]];
    self.nameLabel.text = myPhotoDataModel.UserName;
    self.timeLabel.text = myPhotoDataModel.CreatedTime;
    [self.photoImageV sd_setImageWithURL:[NSURL URLWithString:myPhotoDataModel.FoodPic] placeholderImage:[UIImage imageNamed:@"默认图"]];
    self.messageLabel.attributedText = [self joinMessageWith:myPhotoDataModel.FoodName foodDes:myPhotoDataModel.FoodLable];
}

- (NSAttributedString *)joinMessageWith:(NSString *)message foodDes:(NSString *)foodDes {
    NSString *content = [NSString stringWithFormat:@"#%@#%@",foodDes,message];
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:content attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]}];
    [attriStr addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(252, 169, 7, 1)} range:NSMakeRange(0, foodDes.length+2)];
    return attriStr;
}

#pragma mark -- setter & getter
- (UIImageView *)headImageV {
    if (!_headImageV) {
        _headImageV = [[UIImageView alloc] init];
        _headImageV.layer.masksToBounds = YES;
        _headImageV.layer.cornerRadius = 14;
    }
    return _headImageV;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.textColor = UIColorFromRGB(51, 51, 51, 1);
        _nameLabel.font = [UIFont systemFontOfSize:13.0];
    }
    return _nameLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.textColor = UIColorFromRGB(136, 136, 136, 1);
        _timeLabel.font = [UIFont systemFontOfSize:12.0];
    }
    return _timeLabel;
}

- (UIImageView *)photoImageV {
    if (!_photoImageV) {
        _photoImageV = [[UIImageView alloc] init];
        _photoImageV.contentMode = UIViewContentModeScaleAspectFill;
        _photoImageV.clipsToBounds = YES;
    }
    return _photoImageV;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.textAlignment = NSTextAlignmentLeft;
        _messageLabel.font = [UIFont systemFontOfSize:15.0];
        _messageLabel.textColor = UIColorFromRGB(51, 51, 51, 1);
        _messageLabel.numberOfLines = 0;
        _messageLabel.preferredMaxLayoutWidth = (SCREEN_WIDTH-10*2);
        [_messageLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    }
    return _messageLabel;
}

- (UIButton *)moreBtn {
    if (!_moreBtn) {
        _moreBtn = [[UIButton alloc] init];
        _moreBtn.hidden = YES;
        [_moreBtn setImage:[UIImage imageNamed:@"dietGuide_more"] forState:UIControlStateNormal];
    }
    return _moreBtn;
}

//- (UILabel *)descLabel {
//    if (!_descLabel) {
//        _descLabel = [[UILabel alloc] init];
//        _descLabel.textAlignment = NSTextAlignmentLeft;
//        _descLabel.textColor = UIColorFromRGB(252, 169, 7, 1);
//        _descLabel.font = [UIFont systemFontOfSize:13.0];
//    }
//    return _descLabel;
//}

- (UIView *)getLineView {
    UIView *lineV = [[UIView alloc] init];
    lineV.backgroundColor = UIColorFromRGB(245, 245, 245, 1);
    return lineV;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
