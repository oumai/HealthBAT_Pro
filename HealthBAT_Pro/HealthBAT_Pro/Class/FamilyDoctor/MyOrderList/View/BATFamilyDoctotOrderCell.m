//
//  BATFamilyDoctotOrderCell.m
//  HealthBAT_Pro
//
//  Created by four on 17/3/17.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATFamilyDoctotOrderCell.h"

@implementation BATFamilyDoctotOrderCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = BASE_BACKGROUND_COLOR;
        
        [self setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0.5];
        
        WEAK_SELF(self);
        [self.contentView addSubview:self.bgView];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(@10);
            make.left.right.bottom.equalTo(self.contentView);
        }];
        
        [self.contentView addSubview:self.serviceStateLabel];
        [self.serviceStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(@20);
            make.right.equalTo(self.mas_right).offset(-10);
        }];
        
        [self.contentView addSubview:self.consultButton];
        [self.consultButton mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerY.equalTo(self.serviceStateLabel);
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(80);
        }];
        
        [self.contentView addSubview:self.goHomeButton];
        [self.goHomeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerY.equalTo(self.consultButton);
            make.left.equalTo(self.consultButton.mas_right).offset(10);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(80);
        }];
        
        [self.contentView addSubview:self.midLine];
        [self.midLine mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.serviceStateLabel.mas_bottom).offset(10);
            make.left.right.equalTo(self.contentView);
            make.height.mas_equalTo(0.5);
        }];
        
        [self.contentView addSubview:self.consultService];
        [self.consultService mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.midLine.mas_bottom).offset(15);
            make.left.equalTo(self.contentView.mas_left).offset(15);
        }];
        
        [self.contentView addSubview:self.consultServiceCostLabel];
        [self.consultServiceCostLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.midLine.mas_bottom).offset(15);
            make.left.equalTo(self.consultService.mas_right);
        }];
        
        [self.contentView addSubview:self.serviceIntervalLabel];
        [self.serviceIntervalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.consultService.mas_bottom).offset(25);
            make.left.equalTo(self.contentView.mas_left).offset(15);
        }];
        
        [self.contentView addSubview:self.serviceIntervalTimeLabel];
        [self.serviceIntervalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.consultService.mas_bottom).offset(25);
            make.left.equalTo(self.serviceIntervalLabel.mas_right);
        }];
        
        [self.contentView addSubview:self.requestTimeLabel];
        [self.requestTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-60);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
        }];
        
        [self.contentView addSubview:self.iconImageView];
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerY.equalTo(self.requestTimeLabel);
            make.right.equalTo(self.requestTimeLabel.mas_left).offset(-10);
            make.height.width.mas_equalTo(18);
        }];
        
        [self.contentView addSubview:self.bottomLine];
        [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-45);
            make.left.right.equalTo(self.contentView);
            make.height.mas_equalTo(0.5);
        }];
        
        self.cancelOrderButton.hidden = YES;
        self.requestBtn.hidden = YES;
        self.consultButton.hidden = YES;
        self.contractDetailButton.hidden = YES;
        
        [self.contentView addSubview:self.requestBtn];
        [self.requestBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-9.5);
            make.height.mas_equalTo(26);
            make.width.mas_equalTo(80);
        }];
        
        [self.contentView addSubview:self.cancelOrderButton];
        [self.cancelOrderButton mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.right.equalTo(self.requestBtn.mas_left).offset(-10);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-9.5);
            make.height.mas_equalTo(26);
            make.width.mas_equalTo(80);
        }];
        
        [self.contentView addSubview:self.contractDetailButton];
        [self.contractDetailButton mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.right.equalTo(self.cancelOrderButton.mas_left).offset(-10);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-9.5);
            make.height.mas_equalTo(26);
            make.width.mas_equalTo(80);
        }];
        
    }
    return self;
}

- (void)judgeOrderServerTypeWithString:(BATFamilyDoctorOrderData *)data{
    
    NSArray *array = [data.OrderServerType componentsSeparatedByString:@","];
    DDLogInfo(@"===%@===",data.OrderServerType);
    self.isShowGoHomeBtn = NO;
    self.isShowConsultBtn = NO;
    if ([array containsObject:@"1"]||[array containsObject:@"2"]||[array containsObject:@"3"]) {
        self.isShowConsultBtn = YES;
    }

    if ([array containsObject:@"4"]) {
        self.isShowGoHomeBtn = YES;
    }
    
}



- (void)cellWithData:(BATFamilyDoctorOrderData *)data{
    
    //先判断咨询按钮、上门服务按钮显示及位置
    [self judgeOrderServerTypeWithString:data];

    //ste1：订单状态判断
    WEAK_SELF(self);
    switch (data.OrderStatusShow) {
        case BATFamilyDoctorOrderCancel:
        {
            //订单已取消，只显示合同
            self.cancelOrderButton.hidden = YES;
            self.requestBtn.hidden = YES;
            self.consultButton.hidden = YES;
            self.goHomeButton.hidden = YES;
            self.contractDetailButton.hidden = NO;
            
            [self.contractDetailButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                STRONG_SELF(self);
                make.right.equalTo(self.contentView.mas_right).offset(-10);
                make.bottom.equalTo(self.contentView.mas_bottom).offset(-9.5);
                make.height.mas_equalTo(26);
                make.width.mas_equalTo(80);
            }];
            
            self.serviceStateLabel.text = @"交易关闭";
            self.requestTimeLabel.text = [NSString stringWithFormat:@"发送请求时间：%@",data.LastModifiedTime];
        }
            break;
            
        case BATFamilyDoctorOrderWaitAccept:
        {
             //等待接单，显示取消订单、合同
            self.cancelOrderButton.hidden = YES;
            self.requestBtn.hidden = NO;
            self.consultButton.hidden = YES;
            self.goHomeButton.hidden = YES;
            self.contractDetailButton.hidden = NO;
            
            [self.requestBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                STRONG_SELF(self);
                make.right.equalTo(self.contentView.mas_right).offset(-10);
                make.bottom.equalTo(self.contentView.mas_bottom).offset(-9.5);
                make.height.mas_equalTo(26);
                make.width.mas_equalTo(80);
            }];
            
            [self.contractDetailButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                STRONG_SELF(self);
                make.right.equalTo(self.requestBtn.mas_left).offset(-10);
                make.bottom.equalTo(self.contentView.mas_bottom).offset(-9.5);
                make.height.mas_equalTo(26);
                make.width.mas_equalTo(80);
            }];
            
            
            self.serviceStateLabel.text = @"等待医生接单";
            self.requestTimeLabel.text = [NSString stringWithFormat:@"发送请求时间：%@",data.LastModifiedTime];
            [self.requestBtn setTitle:@"取消订单" forState:UIControlStateNormal];

        }
            break;
        case BATFamilyDoctorOrderWaitPay:
        {
            //等待付款，支付、取消订单、合同
            self.cancelOrderButton.hidden = NO;
            self.requestBtn.hidden = NO;
            self.consultButton.hidden = YES;
            self.goHomeButton.hidden = YES;
            self.contractDetailButton.hidden = NO;
            
            [self.requestBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                STRONG_SELF(self);
                make.right.equalTo(self.contentView.mas_right).offset(-10);
                make.bottom.equalTo(self.contentView.mas_bottom).offset(-9.5);
                make.height.mas_equalTo(26);
                make.width.mas_equalTo(80);
            }];
            
            [self.cancelOrderButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                STRONG_SELF(self);
                make.right.equalTo(self.requestBtn.mas_left).offset(-10);
                make.bottom.equalTo(self.contentView.mas_bottom).offset(-9.5);
                make.height.mas_equalTo(26);
                make.width.mas_equalTo(80);
            }];
            
            [self.contractDetailButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                STRONG_SELF(self);
                make.right.equalTo(self.cancelOrderButton.mas_left).offset(-10);
                make.bottom.equalTo(self.contentView.mas_bottom).offset(-9.5);
                make.height.mas_equalTo(26);
                make.width.mas_equalTo(80);
            }];
            
            
            self.serviceStateLabel.text = @"等待患者付款";
            self.requestTimeLabel.text = [NSString stringWithFormat:@"发送请求时间：%@",data.LastModifiedTime];
            [self.requestBtn setTitle:@"付款" forState:UIControlStateNormal];
            
        }
            break;
        case BATFamilyDoctorOrderFinish:
        {
            //已完成 评价、合同
            self.consultButton.hidden = YES;
            self.contractDetailButton.hidden = NO;
            self.cancelOrderButton.hidden = YES;
            self.goHomeButton.hidden = YES;
            
            if (data.IsComment == YES) {
                
                self.requestBtn.hidden = YES;

                [self.contractDetailButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                    STRONG_SELF(self);
                    make.right.equalTo(self.contentView.mas_right).offset(-10);
                    make.bottom.equalTo(self.contentView.mas_bottom).offset(-9.5);
                    make.height.mas_equalTo(26);
                    make.width.mas_equalTo(80);
                }];

            }else{

                self.requestBtn.hidden = NO;
                
                [self.requestBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                    STRONG_SELF(self);
                    make.right.equalTo(self.contentView.mas_right).offset(-10);
                    make.bottom.equalTo(self.contentView.mas_bottom).offset(-9.5);
                    make.height.mas_equalTo(26);
                    make.width.mas_equalTo(80);
                }];
                
                [self.contractDetailButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                    STRONG_SELF(self);
                    make.right.equalTo(self.requestBtn.mas_left).offset(-10);
                    make.bottom.equalTo(self.contentView.mas_bottom).offset(-9.5);
                    make.height.mas_equalTo(26);
                    make.width.mas_equalTo(80);
                }];

            }
            
            
            self.serviceStateLabel.text = @"交易成功";
            self.requestTimeLabel.hidden = YES;
            self.iconImageView.hidden = YES;
            [self.requestBtn setTitle:@"评价" forState:UIControlStateNormal];

        }
            break;
        case BATFamilyDoctorOrderHavePay:
        {
            //已支付  合同
            self.cancelOrderButton.hidden = YES;
            self.requestBtn.hidden = YES;
            self.contractDetailButton.hidden = NO;
            
            if(self.isShowConsultBtn== YES && self.isShowGoHomeBtn == YES){
                //同时显示
                self.consultButton.hidden = NO;
                self.goHomeButton.hidden = NO;

                [self.consultButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    STRONG_SELF(self);
                    make.centerY.equalTo(self.serviceStateLabel);
                    make.left.equalTo(self.contentView.mas_left).offset(10);
                    make.height.mas_equalTo(30);
                    make.width.mas_equalTo(80);
                }];
                
                [self.goHomeButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    STRONG_SELF(self);
                    make.centerY.equalTo(self.consultButton);
                    make.left.equalTo(self.consultButton.mas_right).offset(10);
                    make.height.mas_equalTo(30);
                    make.width.mas_equalTo(80);
                }];
            }else if(self.isShowConsultBtn== YES && self.isShowGoHomeBtn == NO){
                //没有上们服务
                self.consultButton.hidden = NO;
                self.goHomeButton.hidden = YES;
                
                [self.consultButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    STRONG_SELF(self);
                    make.centerY.equalTo(self.serviceStateLabel);
                    make.left.equalTo(self.contentView.mas_left).offset(10);
                    make.height.mas_equalTo(30);
                    make.width.mas_equalTo(80);
                }];

            }else if(self.isShowConsultBtn== NO && self.isShowGoHomeBtn == YES){
                //只有上门服务
                
                self.consultButton.hidden = YES;
                self.goHomeButton.hidden = NO;
                
                [self.goHomeButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    STRONG_SELF(self);
                    make.centerY.equalTo(self.serviceStateLabel);
                    make.left.equalTo(self.contentView.mas_left).offset(10);
                    make.height.mas_equalTo(30);
                    make.width.mas_equalTo(80);
                }];
                
            }else if(self.isShowConsultBtn== NO && self.isShowGoHomeBtn == NO){
                //同时影藏（不存在这种情况）
            }
            
            [self.contractDetailButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                STRONG_SELF(self);
                make.right.equalTo(self.contentView.mas_right).offset(-10);
                make.bottom.equalTo(self.contentView.mas_bottom).offset(-9.5);
                make.height.mas_equalTo(26);
                make.width.mas_equalTo(80);
            }];
            
            self.serviceStateLabel.text = @"正在服务期...";
            self.requestTimeLabel.text = [NSString stringWithFormat:@"下单时间：%@",data.CreatedTime];
            
        }
            break;
        case BATFamilyDoctorOrderPaySuccess:
        {
            //支付成功，订单不显示，详情显示一次
        }
            break;
        default:
            break;
    }
    
    
    //step3：通用参数处理
    self.consultServiceCostLabel.text = [NSString stringWithFormat:@"%ld个月（%.2f元）",(long)data.OrderServerTime,data.OrderMoney];
    self.serviceIntervalTimeLabel.text = data.ServerTime ;
    
    [self.contentView layoutIfNeeded];
}

#pragma mark - get & set

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

//- (UIButton *)consultButton{
//    if (!_consultButton) {
//        _consultButton = [UIButton buttonWithType:UIButtonTypeCustom Title:@"咨询" titleColor:[UIColor whiteColor] backgroundColor:UIColorFromHEX(0x0182eb, 1) backgroundImage:nil Font:[UIFont systemFontOfSize:14]];
//        _consultButton.layer.cornerRadius = 3;
//        [_consultButton bk_whenTapped:^{
//            if (self.consultBtnClickBlock) {
//                self.consultBtnClickBlock();
//            }
//        }];
//        [_consultButton sizeToFit];
//    }
//    
//    return _consultButton;
//}
//
//- (UIButton *)goHomeButton{
//    if (!_goHomeButton) {
//        _goHomeButton = [UIButton buttonWithType:UIButtonTypeCustom Title:@"上门服务" titleColor:[UIColor whiteColor] backgroundColor:UIColorFromHEX(0x0182eb, 1) backgroundImage:nil Font:[UIFont systemFontOfSize:14]];
//        _goHomeButton.layer.cornerRadius = 3;
//        [_goHomeButton bk_whenTapped:^{
//            if (self.goHomeBtnClickBlock) {
//                self.goHomeBtnClickBlock();
//            }
//        }];
//        [_goHomeButton sizeToFit];
//    }
//    
//    return _goHomeButton;
//}

- (BATGraditorButton *)consultButton{
    if (!_consultButton) {
        _consultButton = [[BATGraditorButton alloc] initWithFrame:CGRectZero];
        [_consultButton setTitle:@"咨询" forState:UIControlStateNormal] ;
        _consultButton.enablehollowOut = YES;
        _consultButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _consultButton.titleColor = [UIColor whiteColor];
        [_consultButton setGradientColors:@[START_COLOR,END_COLOR]];
        _consultButton.clipsToBounds = YES;
        _consultButton.layer.cornerRadius = 3;
        [_consultButton bk_whenTapped:^{
            if (self.consultBtnClickBlock) {
                self.consultBtnClickBlock();
            }
        }];
        [_consultButton sizeToFit];
    }
    
    return _consultButton;
}

- (BATGraditorButton *)goHomeButton{
    if (!_goHomeButton) {
        _goHomeButton = [[BATGraditorButton alloc] initWithFrame:CGRectZero];
        [_goHomeButton setTitle:@"上门服务" forState:UIControlStateNormal] ;
        _goHomeButton.enablehollowOut = YES;
        _goHomeButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _goHomeButton.titleColor = [UIColor whiteColor];
        [_goHomeButton setGradientColors:@[START_COLOR,END_COLOR]];
        _goHomeButton.clipsToBounds = YES;
        _goHomeButton.layer.cornerRadius = 3;
        [_goHomeButton bk_whenTapped:^{
            if (self.goHomeBtnClickBlock) {
                self.goHomeBtnClickBlock();
            }
        }];
        [_goHomeButton sizeToFit];
    }
    
    return _goHomeButton;
}

- (UILabel *)serviceStateLabel{
    if (!_serviceStateLabel) {
        _serviceStateLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:16] textColor:UIColorFromHEX(0xff9000, 1) textAlignment:NSTextAlignmentLeft];
        _serviceStateLabel.text = @"咨询状态在路上";
        [_serviceStateLabel sizeToFit];
    }
    
    return _serviceStateLabel;
}

- (UIView *)midLine{
    if (!_midLine) {
        _midLine = [[UIView alloc]init];
        _midLine.backgroundColor = BASE_LINECOLOR;
    }
    return _midLine;
}

- (UILabel *)consultService{
    if (!_consultService) {
        _consultService = [UILabel labelWithFont:[UIFont systemFontOfSize:16] textColor:UIColorFromHEX(0x999999, 1) textAlignment:NSTextAlignmentLeft];
        _consultService.text = @"咨询套餐：";
        [_consultService sizeToFit];
    }
    
    return _consultService;
}

- (UILabel *)consultServiceCostLabel{
    if (!_consultServiceCostLabel) {
        _consultServiceCostLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:16] textColor:UIColorFromHEX(0x333333, 1) textAlignment:NSTextAlignmentLeft];
        _consultServiceCostLabel.text = @"一个月（100元）";
        [_consultServiceCostLabel sizeToFit];
    }
    
    return _consultServiceCostLabel;
}

- (UILabel *)serviceIntervalLabel{
    if (!_serviceIntervalLabel) {
        _serviceIntervalLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:16] textColor:UIColorFromHEX(0x999999, 1) textAlignment:NSTextAlignmentLeft];
        _serviceIntervalLabel.text = @"服务时间：";
        [_serviceIntervalLabel sizeToFit];
    }
    
    return _serviceIntervalLabel;
}

- (UILabel *)serviceIntervalTimeLabel{
    if (!_serviceIntervalTimeLabel) {
        _serviceIntervalTimeLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:16] textColor:UIColorFromHEX(0x333333, 1) textAlignment:NSTextAlignmentLeft];
        _serviceIntervalTimeLabel.text = @"2017-03-27~2017-04-37";
        [_serviceIntervalTimeLabel sizeToFit];
    }
    
    return _serviceIntervalTimeLabel;
}

- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-rq"]];
    }
    return _iconImageView;
}

- (UILabel *)requestTimeLabel{
    if (!_requestTimeLabel) {
        _requestTimeLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:16] textColor:UIColorFromHEX(0x999999, 1) textAlignment:NSTextAlignmentRight];
        _requestTimeLabel.text = @"发送请求时间：2017-03-28 14:30:32";
        [_requestTimeLabel sizeToFit];
    }
    
    return _requestTimeLabel;
}

- (UIView *)bottomLine{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc]init];
        _bottomLine.backgroundColor = BASE_LINECOLOR;
    }
    return _bottomLine;
}


- (UIButton *)requestBtn {
    if (!_requestBtn) {
        _requestBtn = [UIButton buttonWithType:UIButtonTypeCustom Title:@"取消订单" titleColor:UIColorFromHEX(0xff9101, 1) backgroundColor:nil backgroundImage:nil Font:[UIFont systemFontOfSize:14]];
//        [_requestBtn sizeToFit];
        _requestBtn.layer.borderColor = UIColorFromHEX(0xff9101, 1).CGColor;
        _requestBtn.layer.borderWidth = 1.0f;
        _requestBtn.layer.cornerRadius = 3;
        [_requestBtn setTitleColor:UIColorFromHEX(0xff9101, 1) forState:UIControlStateNormal];
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
        _contractDetailButton = [UIButton buttonWithType:UIButtonTypeCustom Title:@"附件合同" titleColor:UIColorFromHEX(0x333333, 1) backgroundColor:nil backgroundImage:nil Font:[UIFont systemFontOfSize:14]];
//        [_contractDetailButton sizeToFit];
        _contractDetailButton.layer.borderColor = UIColorFromHEX(0x999999, 1).CGColor;
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
        _cancelOrderButton = [UIButton buttonWithType:UIButtonTypeCustom Title:@"取消订单" titleColor:UIColorFromHEX(0x333333, 1) backgroundColor:nil backgroundImage:nil Font:[UIFont systemFontOfSize:14]];
//        [_cancelOrderButton sizeToFit];
        _cancelOrderButton.layer.borderColor = UIColorFromHEX(0x999999, 1).CGColor;
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


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
