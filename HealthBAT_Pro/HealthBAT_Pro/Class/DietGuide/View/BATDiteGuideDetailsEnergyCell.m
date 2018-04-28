//
//  BATDiteGuideDetailsEnergyCell.m
//  HealthBAT_Pro
//
//  Created by Carbon on 2017/10/25.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDiteGuideDetailsEnergyCell.h"

@interface BATDiteGuideDetailsEnergyCell ()
@property (nonatomic ,strong) UIImageView   *photoImageV;
@property (nonatomic ,strong) UILabel       *nameLabel;
@property (nonatomic ,strong) UILabel       *desLabel;
@end

@implementation BATDiteGuideDetailsEnergyCell

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
    [self.contentView addSubview:self.photoImageV];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.desLabel];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [lineV1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(10);
    }];
    [self.photoImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineV1.mas_bottom).offset(20);
        make.left.equalTo(self.contentView).offset(10);
//        make.bottom.equalTo(self.contentView).offset(-20).priority(250);
        make.bottom.equalTo(self.contentView).offset(-20);
        make.width.height.mas_equalTo(40);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.photoImageV.mas_right).offset(7);
        make.right.equalTo(self.contentView);
        make.top.equalTo(self.photoImageV);
    }];
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameLabel);
        make.bottom.equalTo(self.photoImageV.mas_bottom);
    }];
}

- (void)energyCellhide {
    self.hidden = YES;
}

- (void)setDataDiteGuideDetailModel:(BATDiteGuideDetailModel *)diteGuideDetailModel {
//    self.nameLabel.text = diteGuideDetailModel.FoodLable;
    self.nameLabel.text = [self divisionString:diteGuideDetailModel.FoodLable WithString:@","];
    self.desLabel.text = [NSString stringWithFormat:@"%@千卡／100克",diteGuideDetailModel.PicToCalories];
}

- (NSString *)divisionString:(NSString *)sourceString WithString:(NSString *)string {
    return [[sourceString componentsSeparatedByString:string] firstObject];
}
#pragma mark -- setter & getter

- (UIImageView *)photoImageV {
    if (!_photoImageV) {
        _photoImageV = [[UIImageView alloc] init];
        _photoImageV.image = [UIImage imageNamed:@"DietGuide_Calorie"];
    }
    return _photoImageV;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.textColor = UIColorFromRGB(51, 51, 51, 1);
        _nameLabel.font = [UIFont systemFontOfSize:14.0];
    }
    return _nameLabel;
}

- (UILabel *)desLabel {
    if (!_desLabel) {
        _desLabel = [[UILabel alloc] init];
        _desLabel.textAlignment = NSTextAlignmentLeft;
        _desLabel.textColor = UIColorFromRGB(51, 51, 51, 1);
        _desLabel.font = [UIFont systemFontOfSize:12.0];
    }
    return _desLabel;
}

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
