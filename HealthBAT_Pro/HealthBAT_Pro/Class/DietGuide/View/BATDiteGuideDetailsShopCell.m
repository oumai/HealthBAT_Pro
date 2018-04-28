//
//  BATDiteGuideDetailsShopCell.m
//  HealthBAT_Pro
//
//  Created by Carbon on 2017/11/3.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDiteGuideDetailsShopCell.h"

@interface BATDiteGuideDetailsShopCell ()
@property (nonatomic ,strong) UIImageView                        *ditePhotoImageV;
@property (nonatomic ,strong) UILabel                            *diteNameLabel;
@property (nonatomic ,strong) UILabel                            *ditePriceLabel;
@property (nonatomic ,strong) UIButton                           *diteShopCarBtn;
@end

@implementation BATDiteGuideDetailsShopCell

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
    [self.contentView addSubview:self.ditePhotoImageV];
    [self.contentView addSubview:self.diteNameLabel];
    [self.contentView addSubview:self.ditePriceLabel];
    [self.contentView addSubview:self.diteShopCarBtn];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [lineV1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(10);
    }];
    [self.ditePhotoImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineV1.mas_bottom).offset(10);
        make.left.equalTo(self.contentView).offset(10);
        make.width.height.mas_equalTo(100);
        make.bottom.equalTo(self.contentView).offset(-10);
//        make.bottom.equalTo(self.contentView).offset(-10).priority(250);
    }];
    [self.diteNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ditePhotoImageV).offset(13);
        make.left.equalTo(self.ditePhotoImageV.mas_right).offset(17);
        make.right.equalTo(self.contentView).offset(-30);
    }];
    [self.ditePriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.diteNameLabel);
        make.bottom.equalTo(self.ditePhotoImageV).offset(-14);
        make.right.equalTo(self.diteShopCarBtn.mas_left);
    }];
    [self.diteShopCarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-28);
        make.width.height.mas_equalTo(22);
        make.bottom.equalTo(self.ditePriceLabel);
    }];
}

- (void)setDataDiteGuideDetailModel:(BATDiteGuideDetailModel *)diteGuideDetailModel {
    [self setDiteGuideDetailGenerationMealModel:diteGuideDetailModel.GenerationMeal];
}

- (void)setDiteGuideDetailGenerationMealModel:(BATDiteGuideDetailGenerationMealModel *)generationMealModel {
    NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://img.km1818.com/product%@",generationMealModel.SKU_IMG_PATH]];
    [self.ditePhotoImageV sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"默认图"]];
    self.diteNameLabel.text = generationMealModel.PRODUCT_NAME;
    self.ditePriceLabel.text = [NSString stringWithFormat:@"¥%ld",(long)generationMealModel.MARKET_PRICE];
}

#pragma mark -- click
- (void)shopCarBtnByClick:(UIButton *)sender {

}

#pragma mark -- setter & getter
- (UIImageView *)ditePhotoImageV {
    if (!_ditePhotoImageV) {
        _ditePhotoImageV = [[UIImageView alloc] init];
    }
    return _ditePhotoImageV;
}

- (UILabel *)diteNameLabel {
    if (!_diteNameLabel) {
        _diteNameLabel = [[UILabel alloc] init];
        _diteNameLabel.textAlignment = NSTextAlignmentLeft;
        _diteNameLabel.textColor = UIColorFromRGB(62, 58, 57, 1);
        _diteNameLabel.font = [UIFont systemFontOfSize:14.0];
        _diteNameLabel.numberOfLines = 0;
    }
    return _diteNameLabel;
}

- (UILabel *)ditePriceLabel {
    if (!_ditePriceLabel) {
        _ditePriceLabel = [[UILabel alloc] init];
        _ditePriceLabel.textAlignment = NSTextAlignmentLeft;
        _ditePriceLabel.textColor = UIColorFromRGB(46, 204, 183, 1);
        _ditePriceLabel.font = [UIFont systemFontOfSize:15.0];
    }
    return _ditePriceLabel;
}

- (UIButton *)diteShopCarBtn {
    if (!_diteShopCarBtn) {
        _diteShopCarBtn = [[UIButton alloc] init];
        [_diteShopCarBtn setImage:[UIImage imageNamed:@"dietGuide_shopping"] forState:UIControlStateNormal];
        [_diteShopCarBtn addTarget:self action:@selector(shopCarBtnByClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _diteShopCarBtn;
}

- (UIView *)getLineView {
    UIView *lineV = [[UIView alloc] init];
    lineV.backgroundColor = UIColorFromRGB(245, 245, 245, 1);;
    return lineV;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
