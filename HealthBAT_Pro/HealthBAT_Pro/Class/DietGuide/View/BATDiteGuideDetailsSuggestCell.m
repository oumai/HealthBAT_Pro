//
//  BATDiteGuideDetailsSuggestCell.m
//  HealthBAT_Pro
//
//  Created by Carbon on 2017/10/25.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDiteGuideDetailsSuggestCell.h"

@interface BATDiteGuideDetailsSuggestCell ()
@property (nonatomic ,strong) UILabel                            *diteGuideLabel;
@property (nonatomic ,strong) UILabel                            *diteDesLabel;
@property (nonatomic ,strong) UIView                             *energyView;
@property (nonatomic ,strong) UILabel                            *sportSuggestLabel;
@property (nonatomic ,strong) UILabel                            *sportSuggestDesLabel;
@end

@implementation BATDiteGuideDetailsSuggestCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

#pragma mark -- private
- (void)setupUI {
    UIView *lineV1 = [self getLineViewWith:UIColorFromRGB(245, 245, 245, 1)];
    UIView *lineV2 = [self getLineViewWith:UIColorFromRGB(224, 224, 224, 1)];
    UIView *lineV3 = [self getLineViewWith:UIColorFromRGB(224, 224, 224, 1)];
    UIView *lineV4 = [self getLineViewWith:UIColorFromRGB(224, 224, 224, 1)];
    [self.contentView addSubview:lineV1];
    [self.contentView addSubview:lineV2];
    [self.contentView addSubview:lineV3];
    [self.contentView addSubview:lineV4];
    [self.contentView addSubview:self.diteGuideLabel];
    [self.contentView addSubview:self.diteDesLabel];
    [self.contentView addSubview:self.energyView];
    [self.contentView addSubview:self.sportSuggestLabel];
    [self.contentView addSubview:self.sportSuggestDesLabel];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [lineV1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(10);
    }];
    [self.diteGuideLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineV1.mas_bottom).offset(15);
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView);
    }];
    [lineV2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.diteGuideLabel.mas_bottom).offset(15);
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-16);
        make.height.mas_equalTo(1);
    }];
    [self.energyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineV2.mas_bottom).offset(20);
        make.left.equalTo(self.contentView).offset(25);
    }];
    [self.diteDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.energyView).offset(-3);
        make.left.equalTo(self.contentView).offset(80);
        make.right.equalTo(self.contentView.mas_right).offset(-35);
    }];
    [lineV3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.diteDesLabel.mas_bottom).offset(20);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];
    [self.sportSuggestLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineV3.mas_bottom).offset(16);
        make.left.right.equalTo(self.diteGuideLabel);
    }];
    [lineV4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sportSuggestLabel.mas_bottom).offset(15);
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-16);
        make.height.mas_equalTo(1);
    }];
    [self.sportSuggestDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineV4.mas_bottom).offset(20);
        make.left.equalTo(self.contentView).offset(25);
        make.right.equalTo(self.contentView).offset(-30);
        make.bottom.equalTo(self.contentView).offset(-15);
//        make.bottom.equalTo(self.contentView).offset(-15).priority(250);
    }];
}

- (void)setDataDiteGuideDetailModel:(BATDiteGuideDetailModel *)diteGuideDetailModel {
    [self setDiteGuideDetailEatSuggestModel:diteGuideDetailModel.EatSuggest];
    [self setDiteGuideDetailSportSuggestModel:diteGuideDetailModel.SportSuggest];
}

- (void)setDiteGuideDetailEatSuggestModel:(BATDiteGuideDetailEatSuggestModel *)eatSuggestModel {
    [self setEnergyViewWith:eatSuggestModel.HeatLevel];
    self.diteDesLabel.text = eatSuggestModel.Suggest;
}

- (void)setDiteGuideDetailSportSuggestModel:(BATDiteGuideDetailSportSuggestModel *)sportSuggestModel {
    self.sportSuggestDesLabel.text = sportSuggestModel.SuggestContent;
}

- (void)setEnergyViewWith:(NSString *)status {
    NSString *imageVName = nil;
    NSString *imageVTitle = nil;
    if ([status isEqualToString:@"推荐"]) {
        imageVName = @"DietGuide_Recommend";
        imageVTitle = @"DietGuide_Recommend_Word";
    } else if ([status isEqualToString:@"适量"]) {
        imageVName = @"DietGuide_Smile_Face";
        imageVTitle = @"DietGuide_Fit_Word";
    } else if ([status isEqualToString:@"饱和"]) {
        imageVName = @"DietGuide_hot";
        imageVTitle = @"DietGuide_High_Fever_word";
    } else {};
    [self setEnergyViewWith:imageVName title:imageVTitle];
}

- (void)setEnergyViewWith:(NSString *)name title:(NSString *)title {
    [self.energyView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIImageView *imageV1 = [[UIImageView alloc] init];
    imageV1.image = [UIImage imageNamed:name];
    [self.energyView addSubview:imageV1];
    [imageV1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.energyView);
        make.bottom.equalTo(self.energyView);
        make.width.mas_equalTo(14);
        make.height.mas_equalTo(13);
    }];
    UIImageView *imageV2 = [[UIImageView alloc] init];
    imageV2.image = [UIImage imageNamed:title];
    [self.energyView addSubview:imageV2];
    [imageV2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageV1);
        make.left.equalTo(imageV1.mas_right).offset(2);
        make.right.equalTo(self.energyView);
        make.width.mas_equalTo(27);
        make.height.mas_equalTo(13);
    }];
}
#pragma mark -- setter&getter
- (UILabel *)diteGuideLabel {
    if (!_diteGuideLabel) {
        _diteGuideLabel = [[UILabel alloc] init];
        _diteGuideLabel.textAlignment = NSTextAlignmentLeft;
        _diteGuideLabel.text = @"饮食指南";
        _diteGuideLabel.textColor = UIColorFromRGB(51, 51, 51, 1);
        _diteGuideLabel.font = [UIFont systemFontOfSize:15.0];
    }
    return _diteGuideLabel;
}

- (UIView *)energyView {
    if (!_energyView) {
        _energyView = [[UIView alloc] init];
    }
    return _energyView;
}

- (UILabel *)diteDesLabel {
    if (!_diteDesLabel) {
        _diteDesLabel = [[UILabel alloc] init];
        _diteDesLabel.textAlignment = NSTextAlignmentLeft;
        _diteDesLabel.textColor = UIColorFromRGB(51, 51, 51, 1);
        _diteDesLabel.font = [UIFont systemFontOfSize:14.0];
        _diteDesLabel.numberOfLines = 0;
        _diteDesLabel.preferredMaxLayoutWidth = (SCREEN_WIDTH-80-35);
        [_diteDesLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    }
    return _diteDesLabel;
}

- (UILabel *)sportSuggestLabel {
    if (!_sportSuggestLabel) {
        _sportSuggestLabel = [[UILabel alloc] init];
        _sportSuggestLabel.textAlignment = NSTextAlignmentLeft;
        _sportSuggestLabel.text = @"运动建议";
        _sportSuggestLabel.textColor = UIColorFromRGB(51, 51, 51, 1);
        _sportSuggestLabel.font = [UIFont systemFontOfSize:15.0];
    }
    return _sportSuggestLabel;
}

- (UILabel *)sportSuggestDesLabel {
    if (!_sportSuggestDesLabel) {
        _sportSuggestDesLabel = [[UILabel alloc] init];
        _sportSuggestDesLabel.textAlignment =NSTextAlignmentLeft;
        _sportSuggestDesLabel.textColor = UIColorFromRGB(51, 51, 51, 1);
        _sportSuggestDesLabel.font = [UIFont systemFontOfSize:14.0];
        _sportSuggestDesLabel.numberOfLines = 0;
        _sportSuggestDesLabel.preferredMaxLayoutWidth = (SCREEN_WIDTH-25-30);
        [_sportSuggestDesLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    }
    return _sportSuggestDesLabel;
}

- (UIView *)getLineViewWith:(UIColor *)color {
    UIView *lineV = [[UIView alloc] init];
    lineV.backgroundColor = color;
    return lineV;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
