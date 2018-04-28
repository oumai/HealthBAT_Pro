//
//  BATHomeNewMallTableViewCell.m
//  HealthBAT_Pro
//
//  Created by KM on 17/5/92017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHomeNewMallTableViewCell.h"

@implementation BATHomeNewMallTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
//        [self.contentView addSubview:self.todayOfferGoodView];
//        [self.todayOfferGoodView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.top.equalTo(@0);
//            make.size.mas_equalTo(CGSizeMake(382.0/750*SCREEN_WIDTH, 220.0/750*SCREEN_WIDTH));
//        }];
//        
//        [self.contentView addSubview:self.todayOfferMoreView];
//        [self.todayOfferMoreView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(@0);
//            make.left.equalTo(self.todayOfferGoodView.mas_right).offset(0);
//            make.size.mas_equalTo(CGSizeMake(118.0/750*SCREEN_WIDTH, 220.0/750*SCREEN_WIDTH));
//        }];
        
        [self.contentView addSubview:self.bigPharmacy];
        [self.bigPharmacy mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.left.equalTo(@0);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/3.0*2.0, 220.0/750*SCREEN_WIDTH));
        }];
        
        [self.contentView addSubview:self.healthMall];
        [self.healthMall mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bigPharmacy.mas_bottom).offset(0);
            make.left.equalTo(@0);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/3.0, 320.0/750*SCREEN_WIDTH));
        }];
        
        [self.contentView addSubview:self.medicalInstrumentsView];
        [self.medicalInstrumentsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bigPharmacy.mas_bottom).offset(0);
            make.left.equalTo(self.healthMall.mas_right).offset(0);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/3.0, 320.0/750*SCREEN_WIDTH));
        }];
        
        [self.contentView addSubview:self.ninedotnineView];
        [self.ninedotnineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.left.equalTo(self.bigPharmacy.mas_right).offset(0);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/3.0, 320.0/750*SCREEN_WIDTH));
        }];
        
        [self.contentView addSubview:self.healthcareView];
        [self.healthcareView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.medicalInstrumentsView.mas_bottom).offset(0);
            make.left.equalTo(self.medicalInstrumentsView.mas_right).offset(0);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/3.0, 220.0/750*SCREEN_WIDTH));
        }];
        
        [self.contentView addSubview:self.shanshihanfangView];
        [self.shanshihanfangView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.healthMall.mas_bottom).offset(0);
            make.left.equalTo(@0);
            make.width.mas_equalTo(SCREEN_WIDTH/3.0);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/3.0, 220.0/750*SCREEN_WIDTH));
        }];
        
        [self.contentView addSubview:self.anfangzhuayaoView];
        [self.anfangzhuayaoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.healthMall.mas_bottom).offset(0);
            make.left.equalTo(self.shanshihanfangView.mas_right).offset(0);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/3.0*2.0, 220.0/750*SCREEN_WIDTH));
        }];
        
    }
    return self;
}

//- (BATHomeTodayOfferGoodView *)todayOfferGoodView {
//    
//    if (!_todayOfferGoodView) {
//        _todayOfferGoodView = [[BATHomeTodayOfferGoodView alloc] initWithFrame:CGRectZero];
//        [_todayOfferGoodView setBottomBorderWithColor:BASE_LINECOLOR width:382.0/750*SCREEN_WIDTH height:0.5];
//        [_todayOfferGoodView setRightBorderWithColor:BASE_LINECOLOR width:0.5 height:220.0/750*SCREEN_WIDTH];
//        [_todayOfferGoodView bk_whenTapped:^{
//            if (self.todayOfferGoodBlock) {
//                self.todayOfferGoodBlock();
//            }
//        }];
//    }
//    return _todayOfferGoodView;
//}
//
//- (BATHomeTodayOfferMoreView *)todayOfferMoreView {
//    
//    if (!_todayOfferMoreView) {
//        _todayOfferMoreView = [[BATHomeTodayOfferMoreView alloc] initWithFrame:CGRectZero];
//        [_todayOfferMoreView setBottomBorderWithColor:BASE_LINECOLOR width:118.0/750*SCREEN_WIDTH height:0.5];
//        [_todayOfferMoreView setRightBorderWithColor:BASE_LINECOLOR width:0.5 height:220.0/750*SCREEN_WIDTH];
//        [_todayOfferMoreView bk_whenTapped:^{
//            if (self.todayOfferMoreBlock) {
//                self.todayOfferMoreBlock();
//            }
//        }];
//    }
//    return _todayOfferMoreView;
//}

- (BATHomeHealthMallCommonView *)bigPharmacy {
    
    if (!_bigPharmacy) {
        
        _bigPharmacy = [[BATHomeHealthMallCommonView alloc] initWithFrame:CGRectZero];
        _bigPharmacy.titleLabel.text = @"大药房";
        _bigPharmacy.desLabel.text = @"日常用药";
        _bigPharmacy.bottomImageView.image = [UIImage imageNamed:@"img-dyf"];
        [_bigPharmacy setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH/3.0*2.0 height:0.5];
        [_bigPharmacy setRightBorderWithColor:BASE_LINECOLOR width:0.5 height:220.0/750*SCREEN_WIDTH];
        [_bigPharmacy bk_whenTapped:^{
            if (self.bigPharmacyBlock) {
                self.bigPharmacyBlock();
            }
        }];
    }
    return _bigPharmacy;
}

- (BATHomeHealthMallCommonView *)healthMall {
    
    if (!_healthMall) {
        _healthMall = [[BATHomeHealthMallCommonView alloc] initWithFrame:CGRectZero];
        _healthMall.titleLabel.text = @"健康超市";
        _healthMall.desLabel.text = @"急速配送";
        _healthMall.bottomImageView.image = [UIImage imageNamed:@"img-jkcs"];
        [_healthMall setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH/3.0 height:0.5];
        [_healthMall setRightBorderWithColor:BASE_LINECOLOR width:0.5 height:320.0/750*SCREEN_WIDTH];
        [_healthMall bk_whenTapped:^{
            if (self.healthMallBlock) {
                self.healthMallBlock();
            }
        }];
    }
    return _healthMall;
}

- (BATHomeHealthMallCommonView *)medicalInstrumentsView {
    
    if (!_medicalInstrumentsView) {
        _medicalInstrumentsView = [[BATHomeHealthMallCommonView alloc] initWithFrame:CGRectZero];
        _medicalInstrumentsView.titleLabel.text = @"医疗器械";
        _medicalInstrumentsView.desLabel.text = @"超值让利";
        _medicalInstrumentsView.bottomImageView.image = [UIImage imageNamed:@"img-ylqx"];
        [_medicalInstrumentsView setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH/3.0 height:0.5];
        [_medicalInstrumentsView setRightBorderWithColor:BASE_LINECOLOR width:0.5 height:320.0/750*SCREEN_WIDTH];
        [_medicalInstrumentsView bk_whenTapped:^{
            if (self.medicalInstrumentsBlock) {
                self.medicalInstrumentsBlock();
            }
        }];
    }
    return _medicalInstrumentsView;
}

- (BATHomeHealthMallCommonView *)healthcareView {
    
    if (!_healthcareView) {
        _healthcareView = [[BATHomeHealthMallCommonView alloc] initWithFrame:CGRectZero];
        _healthcareView.titleLabel.text = @"营养保健";
        _healthcareView.desLabel.text = @"年度爆款";
        _healthcareView.bottomImageView.image = [UIImage imageNamed:@"img-yybj"];
        [_healthcareView setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH/3.0 height:0.5];
        [_healthcareView setTopBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH/3.0 height:0.5];
        [_healthcareView bk_whenTapped:^{
            if (self.healthcareBlock) {
                self.healthcareBlock();
            }
        }];
    }
    return _healthcareView;
}

- (BATHomeHealthMallCommonView *)anfangzhuayaoView {
    
    if (!_anfangzhuayaoView) {
        _anfangzhuayaoView = [[BATHomeHealthMallCommonView alloc] initWithFrame:CGRectZero];
        _anfangzhuayaoView.titleLabel.text = @"按方抓药";
        _anfangzhuayaoView.desLabel.text = @"方便快捷";
        _anfangzhuayaoView.bottomImageView.image = [UIImage imageNamed:@"img-aszy"];
        [_anfangzhuayaoView setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH/3.0*2 height:0.5];
        [_anfangzhuayaoView setRightBorderWithColor:BASE_LINECOLOR width:0.5 height:220.0/750*SCREEN_WIDTH];
        [_anfangzhuayaoView bk_whenTapped:^{
            if (self.anfangzhuayaoBlock) {
                self.anfangzhuayaoBlock();
            }
        }];
    }
    return _anfangzhuayaoView;
}

- (BATHomeHealthMallCommonView *)shanshihanfangView {
    
    if (!_shanshihanfangView) {
        _shanshihanfangView = [[BATHomeHealthMallCommonView alloc] initWithFrame:CGRectZero];
        _shanshihanfangView.titleLabel.text = @"膳食汉方";
        _shanshihanfangView.desLabel.text = @"健康养生";
        _shanshihanfangView.bottomImageView.image = [UIImage imageNamed:@"img-sshf"];
        [_shanshihanfangView setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH/3.0 height:0.5];
        [_shanshihanfangView setRightBorderWithColor:BASE_LINECOLOR width:0.5 height:220.0/750*SCREEN_WIDTH];
        [_shanshihanfangView bk_whenTapped:^{
            if (self.shanshihanfangBlock) {
                self.shanshihanfangBlock();
            }
        }];
    }
    return _shanshihanfangView;
}

- (BATHomeHealthMallCommonView *)ninedotnineView {
    
    if (!_ninedotnineView) {
        _ninedotnineView = [[BATHomeHealthMallCommonView alloc] initWithFrame:CGRectZero];
        _ninedotnineView.titleLabel.text = @"9.9特卖";
        _ninedotnineView.desLabel.text = @"限时抢购";
        _ninedotnineView.bottomImageView.image = [UIImage imageNamed:@"img-99tm"];
        [_ninedotnineView setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH/3.0 height:0.5];
        [_ninedotnineView bk_whenTapped:^{
            if (self.ninedotnineBlock) {
                self.ninedotnineBlock();
            }
        }];
    }
    return _ninedotnineView;
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
