
//
//  BATBookCell.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 16/9/27.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATBookCell.h"

@interface BATBookCell()
@property (nonatomic,strong) UIImageView *iconImg;
@property (nonatomic,strong) UILabel *nameLb;
@property (nonatomic,strong) UILabel *depNameLb;
@property (nonatomic,strong) UILabel *hosptialLb;
@property (nonatomic,strong) UILabel *timeLb;
@property (nonatomic,strong) UIButton *joinBtn;
@property (nonatomic,strong) UIButton *cancleBtn;
@property (nonatomic,strong) UIView *lineView;
@end
@implementation BATBookCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        WEAK_SELF(self)
        [self.contentView addSubview:self.iconImg];
        [self.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self)
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];
        
        [self.contentView addSubview:self.hosptialLb];
        [self.hosptialLb mas_makeConstraints:^(MASConstraintMaker *make) {
           STRONG_SELF(self)
            make.left.equalTo(self.iconImg.mas_right).offset(10);
            make.centerY.equalTo(self.iconImg.mas_centerY);
        }];
        
        [self.contentView addSubview:self.timeLb];
        [self.timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
           STRONG_SELF(self)
            make.left.equalTo(self.hosptialLb.mas_left);
            make.top.equalTo(self.hosptialLb.mas_bottom).offset(13);
        }];
        
        [self.contentView addSubview:self.nameLb];
        [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
           STRONG_SELF(self)
            make.left.equalTo(self.hosptialLb.mas_left);
            make.bottom.equalTo(self.hosptialLb.mas_top).offset(-13);
        }];
        
        [self.contentView addSubview:self.depNameLb];
        [self.depNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
           STRONG_SELF(self)
            make.left.equalTo(self.nameLb.mas_right).offset(10);
            make.centerY.equalTo(self.nameLb.mas_centerY);
        }];
        
   
//            [self.contentView addSubview:self.joinBtn];
//            [self.joinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//               STRONG_SELF(self)
//                make.centerY.equalTo(self.contentView.mas_centerY);
//                make.right.equalTo(self.contentView.mas_right).offset(-10);
//                make.size.mas_equalTo(CGSizeMake(80, 30));
//            }];

//            [self.contentView addSubview:self.joinBtn];
//            [self.joinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//                STRONG_SELF(self)
//                make.top.equalTo(self.contentView.mas_top).offset(12.5);
//                make.right.equalTo(self.contentView.mas_right).offset(-10);
//                make.size.mas_equalTo(CGSizeMake(80, 30));
//            }];
//            
//            [self.contentView addSubview:self.cancleBtn];
//            [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//                STRONG_SELF(self)
//                make.bottom.equalTo(self.contentView.mas_bottom).offset(-12.5);
//                make.right.equalTo(self.contentView.mas_right).offset(-10);
//                make.size.mas_equalTo(CGSizeMake(80, 30));
//            }];
        
        
        [self.contentView addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
           STRONG_SELF(self)
            make.left.right.bottom.equalTo(self.contentView);
            make.height.equalTo(@1);
        }];
    }
    return self;
}

-(void)cellConfigWithModel:(VideoData *)model {

    self.nameLb.text = model.Doctor.DoctorName;
    self.depNameLb.text = model.Doctor.DepartmentName;
    self.hosptialLb.text = model.Doctor.HospitalName;
    NSString *subTime = [model.OPDDate substringToIndex:10];
    NSString *holeTimeString = [NSString stringWithFormat:@"%@ %@ %@",subTime,model.Schedule.StartTime,model.Schedule.EndTime];
    self.timeLb.text = holeTimeString;
    
    [self.iconImg sd_setImageWithURL:[NSURL URLWithString:model.Doctor.User.PhotoUrl] placeholderImage:[UIImage imageNamed:@"BAT_default_doctor"]];
    
    switch (model.Order.OrderState) {
        case -1:
        case 0: {
            UIButton *payBtn = [[UIButton alloc]init];
            [payBtn setTitle:@"立即支付" forState:UIControlStateNormal];
            [payBtn setBackgroundImage:[UIImage imageNamed:@"Person_Detail_Head"] forState:UIControlStateNormal];
            [payBtn addTarget:self action:@selector(payAction) forControlEvents:UIControlEventTouchUpInside];
            payBtn.clipsToBounds = YES;
            payBtn.layer.cornerRadius = 5;
          //  payBtn.backgroundColor = UIColorFromHEX(0Xfc9f26, 1);
            payBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [payBtn setTitleColor:UIColorFromHEX(0Xffffff, 1) forState:UIControlStateNormal];
            [self.contentView addSubview:payBtn];
            [payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView.mas_top).offset(17);
                make.right.equalTo(self.contentView.mas_right).offset(-10);
                make.size.mas_equalTo(CGSizeMake(70, 30));
            }];
            
            UIButton *DetailBtn = [[UIButton alloc]init];
            [DetailBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            [DetailBtn setBackgroundImage:[UIImage imageNamed:@"Person_Detail_Head"] forState:UIControlStateNormal];
            DetailBtn.clipsToBounds = YES;
            DetailBtn.layer.cornerRadius = 5;
        //    DetailBtn.backgroundColor = UIColorFromHEX(0X45a0f0, 1);
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
            //model.Order.TotalFee<=0  这是原判断
            if (model.Order.LogisticState == 3 || model.Order.LogisticState == 4 || model.Order.LogisticState == 99) {
                
                UIButton *payBtn = [[UIButton alloc]init];
                [payBtn setTitle:@"进入诊室" forState:UIControlStateNormal];
                [payBtn setBackgroundImage:[UIImage imageNamed:@"Person_Detail_Head"] forState:UIControlStateNormal];
                [payBtn addTarget:self action:@selector(JoinAction) forControlEvents:UIControlEventTouchUpInside];
                payBtn.clipsToBounds = YES;
                payBtn.layer.cornerRadius = 5;
              //  payBtn.backgroundColor = UIColorFromHEX(0Xfc9f26, 1);
                payBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                [payBtn setTitleColor:UIColorFromHEX(0Xffffff, 1) forState:UIControlStateNormal];
                [self.contentView addSubview:payBtn];
                [payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(self.contentView.mas_centerY);
                    make.right.equalTo(self.contentView.mas_right).offset(-10);
                    make.size.mas_equalTo(CGSizeMake(70, 30));
                }];

            }else {
                UIButton *payBtn = [[UIButton alloc]init];
                [payBtn setTitle:@"进入诊室" forState:UIControlStateNormal];
                [payBtn setBackgroundImage:[UIImage imageNamed:@"Person_Detail_Head"] forState:UIControlStateNormal];
                [payBtn addTarget:self action:@selector(JoinAction) forControlEvents:UIControlEventTouchUpInside];
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
                [DetailBtn setBackgroundImage:[UIImage imageNamed:@"Person_Detail_Head"] forState:UIControlStateNormal];
                [DetailBtn setTitle:@"申请退款" forState:UIControlStateNormal];
                DetailBtn.clipsToBounds = YES;
                DetailBtn.layer.cornerRadius = 5;
             //   DetailBtn.backgroundColor = UIColorFromHEX(0X45a0f0, 1);
                DetailBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                [DetailBtn setTitleColor:UIColorFromHEX(0Xffffff, 1) forState:UIControlStateNormal];
                [DetailBtn addTarget:self action:@selector(refundAction) forControlEvents:UIControlEventTouchUpInside];
                [self.contentView addSubview:DetailBtn];
                [DetailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.contentView.mas_right).offset(-10);
                    make.bottom.equalTo(self.contentView.mas_bottom).offset(-17);
                    make.size.mas_equalTo(CGSizeMake(70, 30));
                }];
            }
            
            break;
        }
        default:
            break;
    }
}

-(void)payAction {
    if ([self.delegate respondsToSelector:@selector(BATBookCellDelegatePayActionWithRowPath:)]) {
        [self.delegate BATBookCellDelegatePayActionWithRowPath:self.rowPath];
    }
}

-(void)cancleAction {
    if ([self.delegate respondsToSelector:@selector(BATBookCellDelegateCancleActionWithRowPath:)]) {
        [self.delegate BATBookCellDelegateCancleActionWithRowPath:self.rowPath];
    }
}

-(void)JoinAction {
    if ([self.delegate respondsToSelector:@selector(BATBookCellDelegateStartActionWithRowPath:)]) {
        [self.delegate BATBookCellDelegateStartActionWithRowPath:self.rowPath];
    }
}

-(void)refundAction {
    if ([self.delegate respondsToSelector:@selector(BATBookCellDelegateRefundActionWithRowPath:)]) {
        [self.delegate BATBookCellDelegateRefundActionWithRowPath:self.rowPath];
    }
}

#pragma mark - SETTER - GETTER
-(UIImageView *)iconImg {
    if (!_iconImg) {
        _iconImg = [[UIImageView alloc]init];
        _iconImg.clipsToBounds = YES;
        _iconImg.layer.cornerRadius = 30;
    }
    return _iconImg;
}

-(UILabel *)nameLb {
    if (!_nameLb) {
        _nameLb = [[UILabel alloc]init];
        _nameLb.font = [UIFont systemFontOfSize:14];
        _nameLb.textColor = UIColorFromHEX(0X666666, 1);
    }
    return _nameLb;
}

-(UILabel *)depNameLb {
    if (!_depNameLb) {
        _depNameLb = [[UILabel alloc]init];
     //   _depNameLb.text = @"心理科";
        _depNameLb.font = [UIFont systemFontOfSize:12];
        _depNameLb.textColor = UIColorFromHEX(0X999999, 1);
    }
    return _depNameLb;
}

-(UILabel *)hosptialLb {
    if (!_hosptialLb) {
        _hosptialLb = [[UILabel alloc]init];
      //  _hosptialLb.text = @"北京大学人民医院";
        _hosptialLb.font = [UIFont systemFontOfSize:12];
        _hosptialLb.textColor = UIColorFromHEX(0X999999, 1);
    }
    return _hosptialLb;
}

-(UILabel *)timeLb {
    if (!_timeLb) {
        _timeLb = [[UILabel alloc]init];
        _timeLb.font = [UIFont systemFontOfSize:12];
        _timeLb.textColor = UIColorFromHEX(0X999999, 1);
    }
    return _timeLb;
}

-(UIButton *)joinBtn {
    if (!_joinBtn) {
        _joinBtn = [[UIButton alloc]init];
      //  _joinBtn.backgroundColor = UIColorFromHEX(0Xfc9f26, 1);
        _joinBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_joinBtn setTitle:@"进入诊室" forState:UIControlStateNormal];
        _joinBtn.clipsToBounds = YES;
        _joinBtn.layer.cornerRadius = 5;
        [_joinBtn setTitleColor:UIColorFromHEX(0Xffffff, 1) forState:UIControlStateNormal];
    }
    return _joinBtn;
}

-(UIButton *)cancleBtn {
    if (!_cancleBtn) {
        _cancleBtn = [[UIButton alloc]init];
     //   _cancleBtn.backgroundColor = UIColorFromHEX(0X45a0f0, 1);
        _cancleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_cancleBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        _cancleBtn.clipsToBounds = YES;
        _cancleBtn.layer.cornerRadius = 5;
        [_joinBtn setTitleColor:UIColorFromHEX(0Xffffff, 1) forState:UIControlStateNormal];
    }
    return _cancleBtn;
}

-(UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = UIColorFromRGB(246, 246, 246, 1);
    }
    return _lineView;
}

@end
