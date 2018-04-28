//
//  BATDiteGuideDetailsPhotoCell.m
//  HealthBAT_Pro
//
//  Created by Carbon on 2017/10/25.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDiteGuideDetailsPhotoCell.h"
#import "BATGraditorButton.h"
@interface BATDiteGuideDetailsPhotoCell ()
@property (nonatomic ,strong) UIImageView           *headImageV;
@property (nonatomic ,strong) UILabel               *nameLabel;
@property (nonatomic ,strong) UILabel               *timeLabel;
@property (nonatomic ,strong) UIImageView           *photoImageV;
@property (nonatomic ,strong) UILabel               *messageLabel;
@property (nonatomic ,strong) UIView                *desBackView;
//@property (nonatomic ,strong) UIView                *desView;
//@property (nonatomic ,strong) BATGraditorButton     *desButton;
@end

@implementation BATDiteGuideDetailsPhotoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

#pragma mark -- private
- (void)setupUI {
    [self.contentView addSubview:self.headImageV];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.photoImageV];
    [self.contentView addSubview:self.messageLabel];
    [self.contentView addSubview:self.desBackView];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.headImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(9);
        make.left.equalTo(self.contentView).offset(16);
        make.width.height.mas_equalTo(28);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageV.mas_right).offset(10);
        make.centerY.equalTo(self.headImageV);
        make.right.equalTo(self.timeLabel.mas_left);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-17);
        make.centerY.equalTo(self.headImageV);
        make.left.equalTo(self.nameLabel.mas_right);
//        make.width.mas_equalTo(80);
    }];
    [self.photoImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImageV.mas_bottom).offset(10);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(self.photoImageV.mas_width);
    }];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(8);
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(self.photoImageV.mas_bottom).offset(10);
    }];
    [self.desBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.messageLabel.mas_bottom).offset(10);
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-15);
//        make.bottom.equalTo(self.contentView).offset(-15).priority(250);
    }];
}

- (void)setDataDiteGuideDetailModel:(BATDiteGuideDetailModel *)diteGuideDetailModel {
    [self.headImageV sd_setImageWithURL:[NSURL URLWithString:diteGuideDetailModel.UserPhoto] placeholderImage:[UIImage imageNamed:@"默认图"]];
    self.nameLabel.text = diteGuideDetailModel.UserName;
    self.timeLabel.text = diteGuideDetailModel.CreatedTime;
    [self.photoImageV sd_setImageWithURL:[NSURL URLWithString:diteGuideDetailModel.FoodPic] placeholderImage:[UIImage imageNamed:@"默认图"]];
    self.messageLabel.text = diteGuideDetailModel.FoodName;
    [self setFoodLabelContentWith:diteGuideDetailModel.FoodLable];
}

- (void)setFoodLabelContentWith:(NSString *)foodDes {
    NSArray *foodLabelArr = [self divisionString:foodDes WithString:@","];
    UIView *lastView = nil;
    for (NSString *text in foodLabelArr) {
        UIView *desView = [[UIView alloc] init];
        desView.layer.masksToBounds = YES;
        desView.layer.cornerRadius = 8;
        desView.layer.borderWidth = 1.0;
        desView.layer.borderColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"img-qryy"]].CGColor;;
        [self.desBackView addSubview:desView];
        [desView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.desBackView);
            make.width.mas_equalTo(70);
            if (lastView) {
                make.left.equalTo(lastView.mas_right).offset(8);
            } else {
                make.left.equalTo(self.desBackView).offset(9);
            }
        }];
        BATGraditorButton *desButton = [[BATGraditorButton alloc]init];
        desButton.enbleGraditor = YES;
        desButton.titleLabel.font = [UIFont systemFontOfSize:13];
        desButton.userInteractionEnabled = NO;
        [desButton setTitle:text forState:UIControlStateNormal];
        [desButton setGradientColors:@[START_COLOR,END_COLOR]];
        [desView addSubview:desButton];
        [desButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(desView).offset(-5);
            make.bottom.equalTo(desView).offset(5);
            make.left.equalTo(desView).offset(5);
            make.right.equalTo(desView).offset(-5);
        }];
        lastView = desView;
    }
}

- (NSArray *)divisionString:(NSString *)sourceString WithString:(NSString *)string {
    return [sourceString componentsSeparatedByString:string];
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
        _messageLabel.textColor = UIColorFromRGB(51, 51, 51, 1);
        _messageLabel.font = [UIFont systemFontOfSize:15.0];
        _messageLabel.numberOfLines = 0;
        _messageLabel.preferredMaxLayoutWidth = (SCREEN_WIDTH-18);
        [_messageLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    }
    return _messageLabel;
}

- (UIView *)desBackView {
    if (!_desBackView) {
        _desBackView = [[UIView alloc] init];
    }
    return _desBackView;
}

//- (UIView *)desView {
//    if (!_desView) {
//        _desView = [[UIView alloc] init];
//        _desView.layer.masksToBounds = YES;
//        _desView.layer.cornerRadius = 8;
//        _desView.layer.borderWidth = 1.0;
//        _desView.layer.borderColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"img-qryy"]].CGColor;;
//        [_desView addSubview:self.desButton];
//        [self.desButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_desView).offset(-5);
//            make.bottom.equalTo(_desView).offset(5);
//            make.left.equalTo(_desView).offset(10);
//            make.right.equalTo(_desView).offset(-10);
//        }];
//    }
//    return _desView;
//}
//
//- (BATGraditorButton *)desButton {
//    if (!_desButton) {
//        _desButton = [[BATGraditorButton alloc]init];
//        _desButton.enbleGraditor = YES;
//        _desButton.titleLabel.font = [UIFont systemFontOfSize:13];
//        _desButton.userInteractionEnabled = NO;
//    }
//    return _desButton;
//}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}
@end
