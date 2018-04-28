//
//  BATEatSearchAlert.m
//  HealthBAT_Pro
//
//  Created by 黄帆 on 2017/12/13.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATEatSearchAlert.h"
@interface BATEatSearchAlert ()
@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) UIView *contentView;

@property (strong, nonatomic) UILabel *dateLab;
@property (strong, nonatomic) UILabel *greensLab;
@property (strong, nonatomic) UILabel *calorieLab;
@property (strong, nonatomic) UILabel *Lab;

@property (strong, nonatomic) UIImageView *imageV;

@property (strong, nonatomic) UIView *buttonBgView;
@property (strong, nonatomic) UIButton *comfirmBtn;
@property (strong, nonatomic) UIButton *cancleBtn;
@end
@implementation BATEatSearchAlert

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self layoutSelf];
    }
    return self;
}
- (void)layoutSelf {
    
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.bgView];
    [self addSubview:self.contentView];
    [self addSubview:self.buttonBgView];
    [self.buttonBgView addSubview:self.cancleBtn];
    [self.buttonBgView addSubview:self.comfirmBtn];
    
    [self addSubview:self.imageV];
    
    [self addSubview:self.dateLab];
    [self addSubview:self.greensLab];
    [self addSubview:self.calorieLab];
//    [self addSubview:self.Lab];
    
    
    
    self.contentView.layer.cornerRadius = 5;
    self.contentView.layer.masksToBounds = YES;
    
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        
//        make.left.mas_equalTo(self).offset(20);
//        make.right.mas_equalTo(self.mas_right).offset(-20);
        make.center.mas_equalTo(self);
        make.width.mas_equalTo(260);
//        make.height.mas_equalTo(200);
    }];
    
    [self.buttonBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.contentView);
        make.height.mas_equalTo(50);
    }];
    
    [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(self.buttonBgView);
        make.height.mas_equalTo(49);
        make.width.mas_equalTo(129);
    }];
    
    [self.comfirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(self.buttonBgView);
        make.height.mas_equalTo(49);
        make.width.mas_equalTo(130);
    }];

    [self.dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(5);
        make.centerX.mas_equalTo(self.contentView);
        make.height.mas_equalTo(30);
        
    }];
    
//    [self.Lab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(self.contentView);
//        make.bottom.mas_equalTo(self.buttonBgView.mas_top).offset(-5);
//        make.height.mas_equalTo(30);
//    }];
    
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.dateLab.mas_bottom).offset(22);
        make.bottom.mas_equalTo(self.buttonBgView.mas_top).offset(-15);
        make.left.mas_equalTo(self.contentView.mas_left).offset(20);
        make.height.mas_equalTo(60);
//        make.width.mas_equalTo(self.imageV.mas_height).multipliedBy(1);
         make.width.mas_equalTo(80);
    }];
    
    [self.greensLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.left.mas_equalTo(self.imageV.mas_right).offset(24);
//        make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
        make.top.mas_equalTo(self.imageV.mas_top).offset(1);
    }];
    
    [self.calorieLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.left.mas_equalTo(self.imageV.mas_right).offset(24);
//        make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
        make.top.mas_equalTo(self.greensLab.mas_bottom).offset(7);
    }];
}
#pragma mark - getter
- (UIView *)bgView {
    
    if (!_bgView) {
        
        _bgView =[[UIView alloc] init];
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.frame = self.frame;
        _bgView.alpha = 0.3;
        
        
    }
    return  _bgView;
    
}
- (UIView *)contentView {
    
    if (!_contentView) {
        
        _contentView =[[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        
        
    }
    return  _contentView;
    
    
}
- (UIView *)buttonBgView {
    
    if (!_buttonBgView) {
        _buttonBgView = [[UIView alloc] init];
        _buttonBgView.backgroundColor = RGB(220, 220, 220);
    }
    return _buttonBgView;
        
}
- (UIButton *)comfirmBtn {
    
    if (!_comfirmBtn) {
        _comfirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_comfirmBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_comfirmBtn setTitle:@"确定" forState:UIControlStateNormal];
         [_comfirmBtn addTarget:self action:@selector(comfirmAcion:) forControlEvents:UIControlEventTouchUpInside];
        _comfirmBtn.backgroundColor = [UIColor whiteColor];
        
    }
    return _comfirmBtn;
    
    
}
- (UIButton *)cancleBtn {
    if (!_cancleBtn) {
        _cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancleBtn setTitleColor:RGB(200, 200, 200) forState:UIControlStateNormal];
        [_cancleBtn addTarget:self action:@selector(cancleAciton:) forControlEvents:UIControlEventTouchUpInside];
        _cancleBtn.backgroundColor = [UIColor whiteColor];
    }
    return _cancleBtn;
  
}

- (UILabel *)dateLab {
    if (!_dateLab) {
        
        _dateLab = [[UILabel alloc] init];
        _dateLab.textAlignment = NSTextAlignmentLeft;
        _dateLab.text = @"确认添加食物";
    }
    return _dateLab;
}

- (UILabel *)greensLab {
    if (!_greensLab) {
        
        _greensLab = [[UILabel alloc] init];
        _greensLab.textAlignment = NSTextAlignmentLeft;
        _greensLab.text = @"蔬菜";
        _greensLab.font =[UIFont systemFontOfSize:14];
    }
    return _greensLab;
}

- (UILabel *)calorieLab {
    if (!_calorieLab) {
        
        _calorieLab = [[UILabel alloc] init];
        _calorieLab.textAlignment = NSTextAlignmentLeft;
        _calorieLab.text = @"卡路里";
        _calorieLab.font =[UIFont systemFontOfSize:14];
        _calorieLab.textColor = RGB(153, 153, 153);
    }
    return _calorieLab;
}

- (UILabel *)Lab {
    if (!_Lab) {
        
        _Lab = [[UILabel alloc] init];
        _Lab.textAlignment = NSTextAlignmentLeft;
        _Lab.text = @"是否确定";
    }
    return _Lab;
}
- (UIImageView *)imageV {
    
    if (!_imageV) {
        
        _imageV = [[UIImageView alloc] init];
        _imageV.backgroundColor = [UIColor greenColor];
    }
    return _imageV;
    
}
#pragma mark - aciton
- (void)cancleAciton:(UIButton *)sender {
    
    if (self.cancleBlock) {
        self.cancleBlock();
    }

    
}
- (void)comfirmAcion:(UIButton *)sender {
    
    if (self.comfirmBlock) {
        self.comfirmBlock();
    }

}
- (void)setRecommendFoodModel:(BATHealthThreeSecondsRecommedFoodListModel *)recommendFoodModel {

    _recommendFoodModel = recommendFoodModel;
    
    self.calorieLab.text = [NSString stringWithFormat:@"%@卡路里",recommendFoodModel.HeatQty];
    self.greensLab.text = recommendFoodModel.MenuName;
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:recommendFoodModel.PictureURL] placeholderImage:[UIImage imageNamed:@"默认图"]];
    
}
@end
