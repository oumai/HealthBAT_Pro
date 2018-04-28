//
//  BATHomeConsultationCollectionViewCell.m
//  HealthBAT_Pro
//
//  Created by KM on 16/9/192016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATHomeConsultationTableViewCell.h"

@implementation BATHomeConsultationTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.nationalPhysicianPavilionView];
        [self.nationalPhysicianPavilionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self);
            make.width.mas_equalTo(SCREEN_WIDTH*0.5);
            make.height.mas_equalTo(205/2.0);
        }];
        
        [self.contentView addSubview:self.healthButlerView];
        [self.healthButlerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self.nationalPhysicianPavilionView.mas_bottom);
            make.width.mas_equalTo(SCREEN_WIDTH*0.5);
            make.height.mas_equalTo(205/2.0);
        }];
        
        [self.contentView addSubview:self.hospitalRegisterView];
        [self.hospitalRegisterView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nationalPhysicianPavilionView.mas_right);
            make.top.equalTo(self);
            make.width.mas_equalTo(SCREEN_WIDTH*0.5);
            make.height.mas_equalTo(205/3.0);
        }];
        
        [self.contentView addSubview:self.intelligentGuideView];
        [self.intelligentGuideView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nationalPhysicianPavilionView.mas_right);
            make.top.equalTo(self.hospitalRegisterView.mas_bottom);
            make.width.mas_equalTo(SCREEN_WIDTH*0.5);
            make.height.mas_equalTo(205/3.0);
        }];
        
        [self.contentView addSubview:self.consultationView];
        [self.consultationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.intelligentGuideView.mas_bottom);
            make.left.equalTo(self.nationalPhysicianPavilionView.mas_right);
            make.width.mas_equalTo(SCREEN_WIDTH*0.5);
            make.height.mas_equalTo(205/3.0);
        }];

        [self setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0.5];
    }
    return self;
}

- (BATHomeNationalPhysicianPavilionView *)nationalPhysicianPavilionView{
    if (!_nationalPhysicianPavilionView) {
        _nationalPhysicianPavilionView = [[BATHomeNationalPhysicianPavilionView alloc]initWithFrame:CGRectZero];
        _nationalPhysicianPavilionView.topImageView.image = [UIImage imageNamed:@"home-national-phusician"];
        _nationalPhysicianPavilionView.bottomImageView.image = [UIImage imageNamed:@"home-national-phusician-bgd"];
        if(iPhone5){
             _nationalPhysicianPavilionView.descripLabel.text = @"资深中医\n在线问诊";
        }else{
            _nationalPhysicianPavilionView.descripLabel.text = @"资深中医 在线问诊";
        }
        
    }
    
    [_nationalPhysicianPavilionView bk_whenTapped:^{
        if (self.nationalPhysicianPavilionBlock) {
            self.nationalPhysicianPavilionBlock();
        }
    }];
    
    return _nationalPhysicianPavilionView;
}

- (BATHomeNationalPhysicianPavilionView *)healthButlerView{
    if (!_healthButlerView) {
        _healthButlerView = [[BATHomeNationalPhysicianPavilionView alloc]initWithFrame:CGRectZero];
        _healthButlerView.topImageView.image = [UIImage imageNamed:@"home-health-bulter"];
        _healthButlerView.bottomImageView.image = [UIImage imageNamed:@"home-health-bulter-bgd"];
        if(iPhone5){
            _healthButlerView.descripLabel.text = @"健康食谱\n运动计划";
        }else{
            _healthButlerView.descripLabel.text = @"健康食谱 运动计划";
        }
        
    }
    
    [_healthButlerView bk_whenTapped:^{
        if (self.healthButlerBlock) {
            self.healthButlerBlock();
        }
    }];
    
    return _healthButlerView;
}

- (BATHomeConsultationView *)consultationView {

    if (!_consultationView) {
        _consultationView = [[BATHomeConsultationView alloc] initWithFrame:CGRectZero];
//        _consultationView.topImageView.image = [UIImage imageNamed:@"home-consultion"];
        _consultationView.titleLabel.text = @"咨询医生";
        _consultationView.bottomImageView.image = [UIImage imageNamed:@"home-doctor-bgd-new"];
        [_consultationView setLeftBorderWithColor:BASE_LINECOLOR width:0.5 height:(205/3.0)];

        if(iPhone5){
            _consultationView.descripLabel.text = @"在线留言\n快速提问";
        }else{
            _consultationView.descripLabel.text = @"在线留言 快速提问";
        }
        
        
        [_consultationView bk_whenTapped:^{
            if (self.consultationBlock) {
                self.consultationBlock();
            }
        }];
    }
    return _consultationView;
}

- (BATHomeHospitalRegisterView *)hospitalRegisterView {

    if (!_hospitalRegisterView) {
        _hospitalRegisterView = [[BATHomeHospitalRegisterView alloc] initWithFrame:CGRectZero];
        _hospitalRegisterView.titleLabel.text = @"预约挂号";
        if(iPhone5){
            _hospitalRegisterView.descripLabel.text = @"绿色通道\n方便快捷";
        }else{
            _hospitalRegisterView.descripLabel.text = @"绿色通道 方便快捷";
        }
        
        _hospitalRegisterView.rightImageView.image = [UIImage imageNamed:@"home-register-pic-1"];
        [_hospitalRegisterView setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH/2.0f height:0.5];
        [_hospitalRegisterView setLeftBorderWithColor:BASE_LINECOLOR width:0.5 height:(205/3.0)];
        [_hospitalRegisterView bk_whenTapped:^{
            if (self.hospitalRegisterBlock) {
                self.hospitalRegisterBlock();
            }
        }];
        _hospitalRegisterView.hotLabel.hidden = NO;
    }
    return _hospitalRegisterView;
}

- (BATHomeHospitalRegisterView *)intelligentGuideView {

    if (!_intelligentGuideView) {
        _intelligentGuideView = [[BATHomeHospitalRegisterView alloc] initWithFrame:CGRectZero];
        _intelligentGuideView.titleLabel.text = @"快速查病";
        if(iPhone5){
           _intelligentGuideView.descripLabel.text = @"症状疾病\n一查便知";
        }else{
           _intelligentGuideView.descripLabel.text = @"症状疾病 一查便知";
        }
        
        _intelligentGuideView.rightImageView.image = [UIImage imageNamed:@"home-Guide-1"];
        [_intelligentGuideView setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH/2.0f height:0.5];
        [_intelligentGuideView setLeftBorderWithColor:BASE_LINECOLOR width:0.5 height:(205/3.0)];


//        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:@"哪里痛点哪里so easy"];
//        if (iPhone5) {
//            attributedStr = [[NSMutableAttributedString alloc]initWithString:@"哪里痛点哪里\nso easy"];
//        }
//        [attributedStr addAttribute:NSForegroundColorAttributeName
//                              value:UIColorFromHEX(0xffb300, 1)
//                              range:NSMakeRange(6, 7)];
//        _intelligentGuideView.descripLabel.attributedText = attributedStr;

//        NSString *string;
//        if (iPhone5 || iPhone4) {
//            string = @"哪里不舒服\n快搜一下";
//        }
//        else {
//            string = @"哪里不舒服 快搜一下";
//        }
//        _intelligentGuideView.descripLabel.text = string;

        [_intelligentGuideView bk_whenTapped:^{
            if (self.intelligentGuideBlock) {
                self.intelligentGuideBlock();
            }
        }];
    }
    return _intelligentGuideView;
}
@end
