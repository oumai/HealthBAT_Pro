//
//  BATChatCell.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 16/9/27.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATChatCell.h"
@interface BATChatCell()
@property (nonatomic,strong) UILabel *timeLb;
@property (nonatomic,strong) UILabel *intreatmentPersonLb;
@property (nonatomic,strong) UILabel *consultDocLb;
@property (nonatomic,strong) UILabel *typeLb;

@property (nonatomic,strong) UILabel *timeDetailLb;
@property (nonatomic,strong) UILabel *intreatmentPersonDetailLb;
@property (nonatomic,strong) UILabel *consultDocDetailLb;

@property (nonatomic,strong) UIButton *clickBtn;

@property (nonatomic,strong) UIView *lineView;
@end
@implementation BATChatCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        WEAK_SELF(self)
        [self.contentView addSubview:self.timeLb];
        [self.timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
           STRONG_SELF(self)
            make.top.equalTo(self.contentView.mas_top).offset(17);
            make.left.equalTo(self.contentView.mas_left).offset(10);
        }];
        
        [self.contentView addSubview:self.intreatmentPersonLb];
        [self.intreatmentPersonLb mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self)
            make.left.equalTo(self.timeLb.mas_left);
            make.top.equalTo(self.timeLb.mas_bottom).offset(11);
        }];
        
        [self.contentView addSubview:self.consultDocLb];
        [self.consultDocLb mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self)
            make.left.equalTo(self.intreatmentPersonLb.mas_left);
            make.top.equalTo(self.intreatmentPersonLb.mas_bottom).offset(11);
        }];
        
//        [self.contentView addSubview:self.clickBtn];
//        [self.clickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//           STRONG_SELF(self)
//            make.right.equalTo(self.contentView.mas_right).offset(-10);
//            make.bottom.equalTo(self.contentView.mas_bottom).offset(-17);
//            make.size.mas_equalTo(CGSizeMake(70, 30));
//        }];
        
//        [self.contentView addSubview:self.typeLb];
//        [self.typeLb mas_makeConstraints:^(MASConstraintMaker *make) {
//           STRONG_SELF(self)
//            make.centerY.equalTo(self.timeLb.mas_centerY);
//            make.left.equalTo(self.timeLb.mas_left).offset(10);
//        }];
        
        [self.contentView addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
           STRONG_SELF(self)
            make.left.equalTo(self.contentView.mas_left);
            make.right.equalTo(self.contentView.mas_right).offset(0);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(0);
            make.height.equalTo(@1);
        }];
        
        [self.contentView addSubview:self.timeDetailLb];
        [self.timeDetailLb mas_makeConstraints:^(MASConstraintMaker *make) {
           STRONG_SELF(self)
            make.left.equalTo(self.timeLb.mas_right).offset(10);
            make.centerY.equalTo(self.timeLb.mas_centerY);
        }];
        
        [self.contentView addSubview:self.intreatmentPersonDetailLb];
        [self.intreatmentPersonDetailLb mas_makeConstraints:^(MASConstraintMaker *make) {
           STRONG_SELF(self)
            make.left.equalTo(self.intreatmentPersonLb.mas_right).offset(10);
            make.centerY.equalTo(self.intreatmentPersonLb.mas_centerY);
        }];
        
        [self.contentView addSubview:self.consultDocDetailLb];
        [self.consultDocDetailLb mas_makeConstraints:^(MASConstraintMaker *make) {
           STRONG_SELF(self)
            make.centerY.equalTo(self.consultDocLb.mas_centerY);
            make.left.equalTo(self.consultDocLb.mas_right).offset(10);
        }];
    }
    return self;
}

-(void)cellConfigWithChatModel:(OrderResData *)chatModel {
    
    self.timeDetailLb.text = chatModel.ConsultTime;
    self.intreatmentPersonDetailLb.text = chatModel.UserMember.MemberName;
    self.consultDocDetailLb.text = chatModel.Doctor.DoctorName;
   
    
    /*
    switch (chatModel.ConsultState) {
        case 0:
            self.typeLb.text = @"付费";
            break;
        case 1:
            self.typeLb.text =  @"免费";
            break;
        case 2:
            self.typeLb.text = @"义诊";
            break;
        case 3:
            self.typeLb.text = @"套餐";
            break;
        case 4:
            self.typeLb.text = @"会员";
            break;
        default:
            break;
    }
     */
    DDLogInfo(@"订单状态===%ld",(long)chatModel.Order.OrderState);
    switch (chatModel.Order.OrderState) {
        case -1:
        case 0: {
            UIButton *payBtn = [[UIButton alloc]init];
            [payBtn setTitle:@"立即支付" forState:UIControlStateNormal];
            [payBtn addTarget:self action:@selector(payAction) forControlEvents:UIControlEventTouchUpInside];
            [payBtn setBackgroundImage:[UIImage imageNamed:@"Person_Detail_Head"] forState:UIControlStateNormal];
            payBtn.clipsToBounds = YES;
            payBtn.layer.cornerRadius = 5;
         //   payBtn.backgroundColor = UIColorFromHEX(0Xfc9f26, 1);
            payBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [payBtn setTitleColor:UIColorFromHEX(0Xffffff, 1) forState:UIControlStateNormal];
            [self.contentView addSubview:payBtn];
            [payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView.mas_top).offset(17);
                make.right.equalTo(self.contentView.mas_right).offset(-10);
                make.size.mas_equalTo(CGSizeMake(70, 30));
            }];
            
            UIButton *DetailBtn = [[UIButton alloc]init];
            [DetailBtn setTitle:@"咨询详情" forState:UIControlStateNormal];
            DetailBtn.clipsToBounds = YES;
            DetailBtn.layer.cornerRadius = 5;
//            DetailBtn.backgroundColor = UIColorFromHEX(0X45a0f0, 1);
            [DetailBtn setBackgroundImage:[UIImage imageNamed:@"Person_Detail_Head"] forState:UIControlStateNormal];
            DetailBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [DetailBtn setTitleColor:UIColorFromHEX(0Xffffff, 1) forState:UIControlStateNormal];
            [DetailBtn addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:DetailBtn];
            [DetailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView.mas_right).offset(-10);
                make.bottom.equalTo(self.contentView.mas_bottom).offset(-17);
                make.size.mas_equalTo(CGSizeMake(70, 30));
            }];
            break;
        }
        case 1: {
            
            UIButton *startBtn = [[UIButton alloc]init];
            startBtn.clipsToBounds = YES;
            startBtn.layer.cornerRadius = 5;
            [startBtn setBackgroundImage:[UIImage imageNamed:@"Person_Detail_Head"] forState:UIControlStateNormal];
          //  startBtn.backgroundColor = UIColorFromHEX(0Xfc9f26, 1);
            startBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [startBtn setTitle:@"咨询详情" forState:UIControlStateNormal];
            [startBtn setTitleColor:UIColorFromHEX(0Xffffff, 1) forState:UIControlStateNormal];
            [startBtn addTarget:self action:@selector(StartAction) forControlEvents:UIControlEventTouchUpInside];
            /*
            switch (chatModel.ConsultType) {
                case 0:
                case 1:
                case 2:
                case 3:
                    [startBtn setTitle:@"未回复" forState:UIControlStateNormal];
                    startBtn.backgroundColor = UIColorFromHEX(0Xfc9f26, 1);
                    break;
                case 4:
                    [startBtn setTitle:@"已回复" forState:UIControlStateNormal];
                    startBtn.backgroundColor = UIColorFromHEX(0X45a0f0, 1);
                    break;
                case 5:
                    [startBtn setTitle:@"已完成" forState:UIControlStateNormal];
                    startBtn.backgroundColor = UIColorFromHEX(0X45a0f0, 1);
                    break;
            }*/
            
            [self.contentView addSubview:startBtn];
            [startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView.mas_right).offset(-10);
                make.centerY.equalTo(self.contentView.mas_centerY);
                make.size.mas_equalTo(CGSizeMake(70, 30));
            }];
            break;
        }
        case 2: {
            UIButton *finishBtn = [[UIButton alloc]init];
            finishBtn.clipsToBounds = YES;
            finishBtn.layer.cornerRadius = 5;
          //  finishBtn.backgroundColor = UIColorFromHEX(0Xfc9f26, 1);
            finishBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [finishBtn setTitleColor:UIColorFromHEX(0Xffffff, 1) forState:UIControlStateNormal];
            [finishBtn setTitle:@"咨询详情" forState:UIControlStateNormal];
            [finishBtn setBackgroundImage:[UIImage imageNamed:@"Person_Detail_Head"] forState:UIControlStateNormal];
            [finishBtn addTarget:self action:@selector(OrderfinishAction) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:finishBtn];
            [finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView.mas_right).offset(-10);
                make.centerY.equalTo(self.contentView.mas_centerY);
                make.size.mas_equalTo(CGSizeMake(70, 30));
            }];
            break;
        }
        case 3: {
            /*
            UIButton *finishBtn = [[UIButton alloc]init];
            finishBtn.clipsToBounds = YES;
            finishBtn.layer.cornerRadius = 5;
            finishBtn.backgroundColor = UIColorFromRGB(240, 240, 240, 1);
            finishBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [finishBtn setTitleColor:UIColorFromHEX(0Xffffff, 1) forState:UIControlStateNormal];
            [finishBtn setTitle:@"订单已取消" forState:UIControlStateNormal];
            [self.contentView addSubview:finishBtn];
            [finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView.mas_right).offset(-10);
                make.centerY.equalTo(self.contentView.mas_centerY);
                make.size.mas_equalTo(CGSizeMake(70, 30));
            }];*/
            break;
        }
        default:
            break;
    }
}

#pragma mark -DelegateAction
//立即支付代理
-(void)payAction {
    if ([self.delegate respondsToSelector:@selector(BATChatCellPayBtnAction:)]) {
        [self.delegate BATChatCellPayBtnAction:self.rowPath];
    }
}
//取消订单代理
-(void)cancleAction {
    if ([self.delegate respondsToSelector:@selector(BATChatCellCancleBtnAction:)]) {
        [self.delegate BATChatCellCancleBtnAction:self.rowPath];
    }
}
//进入诊室代理
-(void)StartAction {
    if ([self.delegate respondsToSelector:@selector(BATChatCellStartBtnAction:)]) {
        [self.delegate BATChatCellStartBtnAction:self.rowPath];
    }
}

//订单完成了事件
-(void)OrderfinishAction {
    if ([self.delegate respondsToSelector:@selector(BATChatCellFinishBtnAction:)]) {
        [self.delegate BATChatCellFinishBtnAction:self.rowPath];
    }
}

#pragma mark SETTER - GETTER
-(UILabel *)timeLb {
    if (!_timeLb) {
        _timeLb = [[UILabel alloc]init];
        _timeLb.font = [UIFont systemFontOfSize:14];
        _timeLb.textColor = UIColorFromHEX(0X666666, 1);
        _timeLb.text = @"咨询时间:";
    }
    return _timeLb;
}

-(UILabel *)intreatmentPersonLb {
    if (!_intreatmentPersonLb) {
        _intreatmentPersonLb = [[UILabel alloc]init];
        _intreatmentPersonLb.font = [UIFont systemFontOfSize:14];
        _intreatmentPersonLb.textColor = UIColorFromHEX(0X666666, 1);
        _intreatmentPersonLb.text = @"就诊人:";
    }
    return _intreatmentPersonLb;
}

-(UILabel *)consultDocLb {
    if (!_consultDocLb) {
        _consultDocLb = [[UILabel alloc]init];
        _consultDocLb.font = [UIFont systemFontOfSize:14];
        _consultDocLb.textColor = UIColorFromHEX(0X666666, 1);
        _consultDocLb.text = @"咨询医生:";
    }
    return _consultDocLb;
}

-(UILabel *)typeLb {
    if (!_typeLb) {
        _typeLb = [[UILabel alloc]init];
        _typeLb.font = [UIFont systemFontOfSize:14];
        _typeLb.textColor = UIColorFromHEX(0X666666, 1);
    }
    return _typeLb;
}

-(UILabel *)timeDetailLb {
    if (!_timeDetailLb) {
        _timeDetailLb = [[UILabel alloc]init];
        _timeDetailLb.font = [UIFont systemFontOfSize:14];
        _timeDetailLb.textColor = UIColorFromHEX(0X333333, 1);
    }
    return _timeDetailLb;
}

-(UILabel *)intreatmentPersonDetailLb {
    if (!_intreatmentPersonDetailLb) {
        _intreatmentPersonDetailLb = [[UILabel alloc]init];
        _intreatmentPersonDetailLb.font = [UIFont systemFontOfSize:14];
        _intreatmentPersonDetailLb.textColor = UIColorFromHEX(0X333333, 1);
    }
    return _intreatmentPersonDetailLb;
}

-(UILabel *)consultDocDetailLb {
    if (!_consultDocDetailLb) {
        _consultDocDetailLb = [[UILabel alloc]init];
        _consultDocDetailLb.font = [UIFont systemFontOfSize:14];
        _consultDocDetailLb.textColor = UIColorFromHEX(0X333333, 1);
    }
    return _consultDocDetailLb;
}

/*
-(UIButton *)clickBtn {
    if (!_clickBtn) {
        _clickBtn = [[UIButton alloc]init];
        _clickBtn.backgroundColor = [UIColor purpleColor];
        _clickBtn.clipsToBounds = YES;
        _clickBtn.layer.cornerRadius = 5;
        _clickBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_clickBtn setTitleColor:UIColorFromHEX(0Xffffff, 1) forState:UIControlStateNormal];
        [_clickBtn addTarget:self action:@selector(clickBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clickBtn;
}
 */

-(UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = UIColorFromRGB(246, 246, 246, 1);
    }
    return _lineView;
}
@end
