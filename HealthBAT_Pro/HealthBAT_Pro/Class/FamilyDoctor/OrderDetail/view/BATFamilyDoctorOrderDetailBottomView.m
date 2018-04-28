//
//  BATFamilyDoctorOrderDetailBottomView.m
//  HealthBAT_Pro
//
//  Created by four on 2017/4/11.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATFamilyDoctorOrderDetailBottomView.h"

@implementation BATFamilyDoctorOrderDetailBottomView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        WEAK_SELF(self);
        [self addSubview:self.bgView];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.left.right.bottom.equalTo(self);
        }];
        
        self.cancelOrderButton.hidden = YES;
        self.requestBtn.hidden = YES;
        self.contractDetailButton.hidden = YES;
        
        [self addSubview:self.requestBtn];
        [self.requestBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.right.equalTo(self.mas_right).offset(-10);
            make.bottom.equalTo(self.mas_bottom).offset(-9.5);
            make.height.mas_equalTo(26);
            make.width.mas_equalTo(80);
        }];
        
        [self addSubview:self.cancelOrderButton];
        [self.cancelOrderButton mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.right.equalTo(self.requestBtn.mas_left).offset(-10);
            //            make.right.equalTo(self.contentView.mas_right).offset(-100);
            make.bottom.equalTo(self.mas_bottom).offset(-9.5);
            make.height.mas_equalTo(26);
            make.width.mas_equalTo(80);
        }];
        
        [self addSubview:self.contractDetailButton];
        [self.contractDetailButton mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.right.equalTo(self.cancelOrderButton.mas_left).offset(-10);
            //            make.right.equalTo(self.contentView.mas_right).offset(-190);
            make.bottom.equalTo(self.mas_bottom).offset(-9.5);
            make.height.mas_equalTo(26);
            make.width.mas_equalTo(80);
        }];


    }
    return self;
}

- (void)cellWithData:(BATFamilyDoctorOrderState )OrderStateShow isComment:(BOOL)isComment{
    WEAK_SELF(self);
    switch (OrderStateShow) {
        case BATFamilyDoctorOrderCancel:
        {
            self.cancelOrderButton.hidden = YES;
            self.requestBtn.hidden = YES;
            self.contractDetailButton.hidden = NO;
            
            [self.contractDetailButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                STRONG_SELF(self);
                make.right.equalTo(self.mas_right).offset(-10);
                make.bottom.equalTo(self.mas_bottom).offset(-9.5);
                make.height.mas_equalTo(26);
                make.width.mas_equalTo(80);
            }];
        }
            break;
            
        case BATFamilyDoctorOrderWaitAccept:
        {
            self.cancelOrderButton.hidden = YES;
            self.requestBtn.hidden = NO;
            self.contractDetailButton.hidden = NO;
            
            [self.requestBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                STRONG_SELF(self);
                make.right.equalTo(self.mas_right).offset(-10);
                make.bottom.equalTo(self.mas_bottom).offset(-9.5);
                make.height.mas_equalTo(26);
                make.width.mas_equalTo(80);
            }];
            
            [self.contractDetailButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                STRONG_SELF(self);
                make.right.equalTo(self.requestBtn.mas_left).offset(-10);
                make.bottom.equalTo(self.mas_bottom).offset(-9.5);
                make.height.mas_equalTo(26);
                make.width.mas_equalTo(80);
            }];

            [self.requestBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            
        }
            break;
        case BATFamilyDoctorOrderWaitPay:
        {
            //等待付款下支付和取消订单同时存在
            self.cancelOrderButton.hidden = NO;
            self.requestBtn.hidden = NO;
            self.contractDetailButton.hidden = NO;
            
            [self.requestBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                STRONG_SELF(self);
                make.right.equalTo(self.mas_right).offset(-10);
                make.bottom.equalTo(self.mas_bottom).offset(-9.5);
                make.height.mas_equalTo(26);
                make.width.mas_equalTo(80);
            }];
            
            [self.cancelOrderButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                STRONG_SELF(self);
                make.right.equalTo(self.requestBtn.mas_left).offset(-10);
                make.bottom.equalTo(self.mas_bottom).offset(-9.5);
                make.height.mas_equalTo(26);
                make.width.mas_equalTo(80);
            }];
            
            [self.contractDetailButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                STRONG_SELF(self);
                make.right.equalTo(self.cancelOrderButton.mas_left).offset(-10);
                make.bottom.equalTo(self.mas_bottom).offset(-9.5);
                make.height.mas_equalTo(26);
                make.width.mas_equalTo(80);
            }];

            [self.requestBtn setTitle:@"付款" forState:UIControlStateNormal];
            
        }
            break;
        case BATFamilyDoctorOrderFinish:
        {
            self.cancelOrderButton.hidden = YES;
            self.contractDetailButton.hidden = NO;
            
            if (isComment == YES) {
                
                self.requestBtn.hidden = YES;
                [self.contractDetailButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                    STRONG_SELF(self);
                    make.right.equalTo(self.mas_right).offset(-10);
                    make.bottom.equalTo(self.mas_bottom).offset(-9.5);
                    make.height.mas_equalTo(26);
                    make.width.mas_equalTo(80);
                }];
                
            }else{
                
                self.requestBtn.hidden = NO;
                [self.requestBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                    STRONG_SELF(self);
                    make.right.equalTo(self.mas_right).offset(-10);
                    make.bottom.equalTo(self.mas_bottom).offset(-9.5);
                    make.height.mas_equalTo(26);
                    make.width.mas_equalTo(80);
                }];
                
                [self.contractDetailButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                    STRONG_SELF(self);
                    make.right.equalTo(self.requestBtn.mas_left).offset(-10);
                    make.bottom.equalTo(self.mas_bottom).offset(-9.5);
                    make.height.mas_equalTo(26);
                    make.width.mas_equalTo(80);
                }];
                
            }
        
            [self.requestBtn setTitle:@"评价" forState:UIControlStateNormal];
            
        }
            break;
        case BATFamilyDoctorOrderHavePay:
        {
            
            self.cancelOrderButton.hidden = YES;
            self.requestBtn.hidden = YES;
            self.contractDetailButton.hidden = NO;
            
            [self.contractDetailButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                STRONG_SELF(self);
                make.right.equalTo(self.mas_right).offset(-10);
                make.bottom.equalTo(self.mas_bottom).offset(-9.5);
                make.height.mas_equalTo(26);
                make.width.mas_equalTo(80);
            }];

        }
            break;
            
        case BATFamilyDoctorOrderPaySuccess:
        {

        }
            break;
            
            
        default:
            break;
    }

}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (UIButton *)requestBtn {
    if (!_requestBtn) {
        _requestBtn = [UIButton buttonWithType:UIButtonTypeCustom Title:@"取消订单" titleColor:UIColorFromHEX(0xff8c28, 1) backgroundColor:nil backgroundImage:nil Font:nil];
        //        [_requestBtn sizeToFit];
        _requestBtn.layer.borderColor = UIColorFromHEX(0xff8c28, 1).CGColor;
        _requestBtn.layer.borderWidth = 1.0f;
        _requestBtn.layer.cornerRadius = 3;
        [_requestBtn setTitleColor:UIColorFromHEX(0xff8c28, 1) forState:UIControlStateNormal];
        [_requestBtn bk_whenTapped:^{
            if (self.requestBtnClickBlock) {
                self.requestBtnClickBlock();
            }
        }];
    }
    return _requestBtn;
}

- (UIButton *)contractDetailButton {
    if (!_contractDetailButton) {
        _contractDetailButton = [UIButton buttonWithType:UIButtonTypeCustom Title:@"附件合同" titleColor:UIColorFromHEX(0x333333, 1) backgroundColor:nil backgroundImage:nil Font:nil];
        //        [_contractDetailButton sizeToFit];
        _contractDetailButton.layer.borderColor = UIColorFromHEX(0x666666, 1).CGColor;
        _contractDetailButton.layer.borderWidth = 1.0f;
        _contractDetailButton.layer.cornerRadius = 3;
        [_contractDetailButton setTitleColor:UIColorFromHEX(0x333333, 1) forState:UIControlStateNormal];
        
        [_contractDetailButton bk_whenTapped:^{
            if (self.contractDetailBtnClickBlock) {
                self.contractDetailBtnClickBlock();
            }
        }];
    }
    return _contractDetailButton;
}


- (UIButton *)cancelOrderButton {
    if (!_cancelOrderButton) {
        _cancelOrderButton = [UIButton buttonWithType:UIButtonTypeCustom Title:@"取消订单" titleColor:UIColorFromHEX(0x333333, 1) backgroundColor:nil backgroundImage:nil Font:nil];
        //        [_cancelOrderButton sizeToFit];
        _cancelOrderButton.layer.borderColor = UIColorFromHEX(0x666666, 1).CGColor;
        _cancelOrderButton.layer.borderWidth = 1.0f;
        _cancelOrderButton.layer.cornerRadius = 3;
        [_cancelOrderButton setTitleColor:UIColorFromHEX(0x333333, 1) forState:UIControlStateNormal];
        
        [_cancelOrderButton bk_whenTapped:^{
            if (self.cancelOrderBtnClickBlock) {
                self.cancelOrderBtnClickBlock();
            }
        }];
    }
    return _cancelOrderButton;
}

@end
