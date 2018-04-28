//
//  BATRelateTreatmentCell.m
//  TableViewTest
//
//  Created by mac on 16/9/17.
//  Copyright © 2016年 sword. All rights reserved.
//

#import "BATRelateTreatmentCell.h"
#import "BATDieaseDetailEntityModel.h"

@interface BATRelateTreatmentCell()
@property(nonatomic,strong)UIView *verView;
@property(nonatomic,strong)UIView *horView;

@property(nonatomic,strong)UIButton *moreBtn;
@property(nonatomic,strong)BATDieaseDetailEntityModel *model;

@property(nonatomic,strong)UIView *examineDocView;
@property(nonatomic,strong)UIView *treatmentDocView;
@property(nonatomic,strong)UIView *nursedDocView;

@property(nonatomic,strong)UILabel *examineDetailLb;
@property(nonatomic,strong)UILabel *treatmeDetailntLb;
@property(nonatomic,strong)UILabel *nursedDetailLb;

@property (nonatomic, strong) UIImageView *arrowImage;

@end
@implementation BATRelateTreatmentCell

 static NSString *const TreatmentReuseName = @"TreatmentCell";

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        WEAK_SELF(self);
        
        [self.contentView addSubview:self.iconView];
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.contentView).offset(10);
            make.top.equalTo(self.contentView.mas_top).offset(0);
            make.size.mas_equalTo(CGSizeMake(19, 19));
        }];
        
        [self.contentView addSubview:self.verView];
        [self.verView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.iconView.mas_bottom).offset(0);
            make.centerX.equalTo(self.iconView.mas_centerX);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(0);
            make.width.mas_equalTo(2);
        }];
        
        [self.contentView addSubview:self.nameLb];
        self.nameLb.preferredMaxLayoutWidth = SCREEN_WIDTH - 56.5;
        [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerY.equalTo(self.iconView.mas_centerY);
            make.left.equalTo(self.iconView.mas_right).offset(10);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
        }];
        
        [self.contentView addSubview:self.horView];
        [self.horView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.nameLb.mas_bottom).offset(5);
            make.left.equalTo(self.iconView.mas_right).offset(10);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.height.equalTo(@1);
        }];
        
        [self.contentView addSubview:self.examineDocView];
        [self.examineDocView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.nameLb.mas_left);
            make.top.equalTo(self.horView.mas_bottom).offset(15);
            make.size.mas_equalTo(CGSizeMake(6, 6));
        }];
        
        [self.contentView addSubview:self.examineLb];
        [self.examineLb mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerY.equalTo(self.examineDocView.mas_centerY);
            make.left.equalTo(self.examineDocView.mas_right).offset(5);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-55, 20));
        }];

        [self.contentView addSubview:self.examineBtn];
        [self.examineBtn addTarget:self action:@selector(changeFrame:) forControlEvents:UIControlEventTouchUpInside];
        [self.examineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.centerY.equalTo(self.examineLb.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(250, 30));
        }];
        
        [self.contentView addSubview:self.examineDetailLb];
        self.examineDetailLb.preferredMaxLayoutWidth = SCREEN_WIDTH - 60;
        [self.examineDetailLb mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.examineLb.mas_bottom).offset(5);
            make.left.equalTo(self.examineLb.mas_left);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
        }];
        
        [self.contentView addSubview:self.treatmentDocView];
        [self.treatmentDocView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.examineDetailLb.mas_bottom).offset(10);
            make.left.equalTo(self.examineDocView.mas_left);
            make.size.mas_equalTo(CGSizeMake(6, 6));
        }];
        
        [self.contentView addSubview:self.treatmentLb];
        [self.treatmentLb mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.examineLb.mas_left);
            make.centerY.equalTo(self.treatmentDocView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-55, 20));
        }];
        
        [self.contentView addSubview:self.treatmentBtn];
        [self.treatmentBtn addTarget:self action:@selector(changeFrame:) forControlEvents:UIControlEventTouchUpInside];
        [self.treatmentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.centerY.equalTo(self.treatmentLb.mas_centerY);
             make.size.mas_equalTo(CGSizeMake(250, 30));
        }];
        
        [self.contentView addSubview:self.treatmeDetailntLb];
        self.treatmeDetailntLb.preferredMaxLayoutWidth = SCREEN_WIDTH - 60;
        [self.treatmeDetailntLb mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.treatmentLb.mas_bottom).offset(5);
            make.left.equalTo(self.treatmentLb.mas_left);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
        }];
        
        
        [self.contentView addSubview:self.nursedDocView];
        [self.nursedDocView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.treatmeDetailntLb.mas_bottom).offset(10);
            make.left.equalTo(self.treatmentDocView.mas_left);
            make.size.mas_equalTo(CGSizeMake(6, 6));
        }];
        
        [self.contentView addSubview:self.nursedLb];
        [self.nursedLb mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerY.equalTo(self.nursedDocView.mas_centerY);
            make.left.equalTo(self.treatmentLb.mas_left);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-55, 20));
        }];
        
        [self.contentView addSubview:self.nursedBtn];
        [self.nursedBtn addTarget:self action:@selector(changeFrame:) forControlEvents:UIControlEventTouchUpInside];
        [self.nursedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.centerY.equalTo(self.nursedLb.mas_centerY);
             make.size.mas_equalTo(CGSizeMake(250, 30));
        }];
        
        [self.contentView addSubview:self.nursedDetailLb];
        self.nursedDetailLb.preferredMaxLayoutWidth = SCREEN_WIDTH - 60;
        [self.nursedDetailLb mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.nursedLb.mas_bottom).offset(5);
            make.left.equalTo(self.nursedLb.mas_left);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
        }];
        
    }
    return self;
}

#pragma mark - 每行刷新时候调用
-(void)configCellWithModel:(BATDieaseDetailEntityModel *)model{
    self.model = model;

    self.examineDetailLb.text = model.treatmentArr[0];
    self.treatmeDetailntLb.text = model.treatmentArr[1];
    self.nursedDetailLb.text = model.treatmentArr[2];
    
    if (model.isExaimBtnShow) {
        self.examineBtn.hidden = NO;
    }else {
        self.examineBtn.hidden = YES;
    }
    
    if (model.isTreatmentBtnShow) {
        self.treatmentBtn.hidden = NO;
    }else {
        self.treatmentBtn.hidden = YES;
    }
    
    if (model.isNurseBtnShow) {
        self.nursedBtn.hidden = NO;
    }else {
        self.nursedBtn.hidden = YES;
    }
    
    
//    if (self.model.RelateExaminIsOpen) {
//        self.examineDetailLb.numberOfLines = 0;
//        [self.examineBtn setImage:[UIImage imageNamed:@"iconfont-arrow-up"] forState:UIControlStateNormal];
//    }else {
//        self.examineDetailLb.numberOfLines = 2;
//        [self.examineBtn setImage:[UIImage imageNamed:@"iconfont-arrow-down-拷贝-2"] forState:UIControlStateNormal];
//    }
//    
//    if (self.model.RelateTreatmentIsOpen) {
//        self.treatmeDetailntLb.numberOfLines = 0;
//        [self.treatmentBtn setImage:[UIImage imageNamed:@"iconfont-arrow-up"] forState:UIControlStateNormal];
//    }else {
//        self.treatmeDetailntLb.numberOfLines = 2;
//        [self.treatmentBtn setImage:[UIImage imageNamed:@"iconfont-arrow-down-拷贝-2"] forState:UIControlStateNormal];
//    }
//    
//    if (self.model.RelateNurseIsOpen) {
//        self.nursedDetailLb.numberOfLines = 0;
//
//        [self.nursedBtn setImage:[UIImage imageNamed:@"iconfont-arrow-up"] forState:UIControlStateNormal];
//    }else {
//        self.nursedDetailLb.numberOfLines = 2;
//        [self.nursedBtn setImage:[UIImage imageNamed:@"iconfont-arrow-down-拷贝-2"] forState:UIControlStateNormal];
//    }
}

#pragma mark - 计算并返回高度
+(CGFloat)HeightWithModel:(BATDieaseDetailEntityModel *)model {
    BATRelateTreatmentCell *cell = [[BATRelateTreatmentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TreatmentReuseName];
    [cell configCellWithModel:model];
    
    
    [cell layoutIfNeeded];
    
    CGRect frame = cell.nursedDetailLb.frame;
    CGFloat height = frame.origin.y +frame.size.height +10;
    return height;
}

-(void)changeSateAction {
//    if (self.model.RelateExaminIsOpen) {
//        self.examineDetailLb.numberOfLines = 0;
//        [self.examineBtn setImage:[UIImage imageNamed:@"iconfont-arrow-up"] forState:UIControlStateNormal];
//    }else {
//        self.examineDetailLb.numberOfLines = 2;
//        [self.examineBtn setImage:[UIImage imageNamed:@"iconfont-arrow-down-拷贝-2"] forState:UIControlStateNormal];
//    }
//    
//    if (self.model.RelateTreatmentIsOpen) {
//        self.treatmeDetailntLb.numberOfLines = 0;
//        [self.treatmentBtn setImage:[UIImage imageNamed:@"iconfont-arrow-up"] forState:UIControlStateNormal];
//    }else {
//        self.treatmeDetailntLb.numberOfLines = 2;
//        [self.treatmentBtn setImage:[UIImage imageNamed:@"iconfont-arrow-down-拷贝-2"] forState:UIControlStateNormal];
//    }
//    
//    if (self.model.RelateNurseIsOpen) {
//        self.nursedDetailLb.numberOfLines = 0;
//        
//        [self.nursedBtn setImage:[UIImage imageNamed:@"iconfont-arrow-up"] forState:UIControlStateNormal];
//    }else {
//        self.nursedDetailLb.numberOfLines = 2;
//        [self.nursedBtn setImage:[UIImage imageNamed:@"iconfont-arrow-down-拷贝-2"] forState:UIControlStateNormal];
//    }

}

#pragma mark -Action
-(void)changeFrame:(UIButton *)senderBtn
{
    

    [self publicModth:senderBtn.tag];

}

- (void)pushAction:(UITapGestureRecognizer *)taper {

    [self publicModth:taper.view.tag - 110];
    
}

-(void)TapAction:(UITapGestureRecognizer *)taper
{
    
    [self publicModth:taper.view.tag];
}

-(void)publicModth:(NSInteger)count
{
    /*
    switch (count) {
        case 0: {
            if (!self.model.RelateExaminIsOpen) {
                self.model.RelateExaminIsOpen = YES;
                
            }else {
                self.model.RelateExaminIsOpen = NO;
                
            }
            break;
        }
        case 1: {
            if (!self.model.RelateTreatmentIsOpen) {
                self.model.RelateTreatmentIsOpen = YES;
            }else {
                self.model.RelateTreatmentIsOpen = NO;
            }
            break;
        }
        case 2: {
            if (!self.model.RelateNurseIsOpen) {
                self.model.RelateNurseIsOpen = YES;
            }else {
                self.model.RelateNurseIsOpen = NO;
            }
            break;
        }
        default:
            break;
    }
    
    [self configCellWithModel:self.model];
     */
    
    if (self.RelateTreatmentblock) {
        self.RelateTreatmentblock(self.path,count);
    }
    
    [self animationStart:count];

}



#pragma mark - SETTER - GETTER
-(UIImageView *)iconView{
    if (!_iconView) {
        _iconView = [[UIImageView alloc]init];
    }
    return _iconView;
}

-(UIView *)horView{
    if (!_horView) {
        _horView = [[UIView alloc]init];
        _horView.backgroundColor = BASE_LINECOLOR;
    }
    return _horView;
}

-(UIView *)verView{
    if (!_verView) {
        _verView = [[UIView alloc]init];
        _verView.backgroundColor = BASE_LINECOLOR;
    }
    return _verView;
}

-(UILabel *)nameLb{
    if (!_nameLb) {
        _nameLb = [[UILabel alloc]init];
        _nameLb.numberOfLines = 0;
        _nameLb.text = @"相关疗法";
        _nameLb.font = [UIFont systemFontOfSize:16];
        _nameLb.textColor = UIColorFromHEX(0X333333, 1);
    }
    return _nameLb;
}

-(UILabel *)detailLb{
    if (!_detailLb) {
        _detailLb = [[UILabel alloc]init];
        _detailLb.numberOfLines = 3;
    }
    return _detailLb;
}


-(UIView *)examineDocView{
    if (!_examineDocView) {
        _examineDocView = [[UIView alloc]init];
        _examineDocView.clipsToBounds = YES;
        _examineDocView.layer.borderWidth = 1;
        _examineDocView.layer.cornerRadius = 3;
        _examineDocView.layer.borderColor = [UIColor clearColor].CGColor;
        _examineDocView.backgroundColor = UIColorFromRGB(91, 193, 183, 1);
    }
    return _examineDocView;
}

-(UIView *)treatmentDocView{
    if (!_treatmentDocView) {
        _treatmentDocView = [[UIView alloc]init];
        _treatmentDocView.clipsToBounds = YES;
        _treatmentDocView.layer.borderWidth = 1;
        _treatmentDocView.layer.cornerRadius = 3;
        _treatmentDocView.layer.borderColor = [UIColor clearColor].CGColor;
        _treatmentDocView.backgroundColor = UIColorFromRGB(91, 193, 183, 1);
    }
    return _treatmentDocView;
}

-(UIView *)nursedDocView{
    if (!_nursedDocView) {
        _nursedDocView = [[UIView alloc]init];
        _nursedDocView.clipsToBounds = YES;
        _nursedDocView.layer.borderWidth = 1;
        _nursedDocView.layer.cornerRadius = 3;
        _nursedDocView.layer.borderColor = [UIColor clearColor].CGColor;
        _nursedDocView.backgroundColor = UIColorFromRGB(91, 193, 183, 1);
    }
    return _nursedDocView;
}

-(UIButton *)examineBtn{
    if (!_examineBtn) {
        _examineBtn = [[UIButton alloc]init];
        _examineBtn.tag = 0;
        [_examineBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 230, 10, 0)];
        [_examineBtn setImage:[UIImage imageNamed:@"jiantou01"] forState:UIControlStateNormal];
    }
    return _examineBtn;
}

-(UIButton *)treatmentBtn{
    if (!_treatmentBtn) {
        _treatmentBtn = [[UIButton alloc]init];
        _treatmentBtn.tag = 1;
        [_treatmentBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 230, 10, 0)];
        [_treatmentBtn setImage:[UIImage imageNamed:@"jiantou01"] forState:UIControlStateNormal];
    }
    return _treatmentBtn;
}

-(UIButton *)nursedBtn{
    if (!_nursedBtn) {
        _nursedBtn = [[UIButton alloc]init];
        _nursedBtn.tag = 2;
        [_nursedBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 230, 10, 0)];
        [_nursedBtn setImage:[UIImage imageNamed:@"jiantou01"] forState:UIControlStateNormal];
    }
    return _nursedBtn;
}

-(UILabel *)examineLb{
    if (!_examineLb) {
        _examineLb = [[UILabel alloc]init];
        _examineLb.text = @"检查方式";
        _examineLb.textAlignment = NSTextAlignmentLeft;
        _examineLb.textColor = UIColorFromHEX(0X666666, 1);
        _examineLb.font = [UIFont systemFontOfSize:14];
    }
    return _examineLb;
}

-(UILabel *)treatmentLb{
    if (!_treatmentLb) {
        _treatmentLb = [[UILabel alloc]init];
        _treatmentLb.textAlignment = NSTextAlignmentLeft;
        _treatmentLb.text = @"治疗方式";
        _treatmentLb.textColor = UIColorFromHEX(0X666666, 1);
        _treatmentLb.font = [UIFont systemFontOfSize:14];
    }
    return _treatmentLb;
}

-(UILabel *)nursedLb{
    if (!_nursedLb) {
        _nursedLb = [[UILabel alloc]init];
        _nursedLb.textAlignment = NSTextAlignmentLeft;
        _nursedLb.text = @"预防护理";
        _nursedLb.textColor = UIColorFromHEX(0X666666, 1);
        _nursedLb.font = [UIFont systemFontOfSize:14];
    }
    return _nursedLb;
}

-(UILabel *)examineDetailLb{
    if (!_examineDetailLb) {
        _examineDetailLb = [[UILabel alloc]init];
        _examineDetailLb.numberOfLines = 3;
        _examineDetailLb.textColor = UIColorFromHEX(0X999999, 1);
        _examineDetailLb.font = [UIFont systemFontOfSize:14];
        _examineDetailLb.userInteractionEnabled = YES;
        _examineDetailLb.tag = 110;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushAction:)];
        [_examineDetailLb addGestureRecognizer:tap];
    }
    return _examineDetailLb;
}

-(UILabel *)treatmeDetailntLb{
    if (!_treatmeDetailntLb) {
        _treatmeDetailntLb = [[UILabel alloc]init];
        _treatmeDetailntLb.numberOfLines = 3;
        _treatmeDetailntLb.textColor = UIColorFromHEX(0X999999, 1);
        _treatmeDetailntLb.font = [UIFont systemFontOfSize:14];
        _treatmeDetailntLb.userInteractionEnabled = YES;
        _treatmeDetailntLb.tag = 111;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushAction:)];
        [_treatmeDetailntLb addGestureRecognizer:tap];
    }
    return _treatmeDetailntLb;
}

-(UILabel *)nursedDetailLb{
    if (!_nursedDetailLb) {
        _nursedDetailLb = [[UILabel alloc]init];
        _nursedDetailLb.numberOfLines = 3;
        _nursedDetailLb.textColor = UIColorFromHEX(0X999999, 1);
        _nursedDetailLb.font = [UIFont systemFontOfSize:14];
        _nursedDetailLb.userInteractionEnabled = YES;
        _nursedDetailLb.tag = 112;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushAction:)];
        [_nursedDetailLb addGestureRecognizer:tap];

    }
    return _nursedDetailLb;
}
//根据tag传递动画
- (void)animationStart:(NSInteger )integer {
    
    
    
    if (integer == 0) {
        [_examineBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        self.arrowImage = [[UIImageView alloc]init];
        self.arrowImage.image = [UIImage imageNamed:@"jiantoud"];
        [_examineBtn addSubview:self.arrowImage];
        
        WEAK_SELF(self);
        
        [self.arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerY.equalTo(self.examineLb.mas_centerY);
            make.right.equalTo(self.contentView.mas_right).offset(-20);
            make.size.mas_equalTo(CGSizeMake(8, 8));
        }];
        
        
        self.arrowImage.image = [UIImage imageNamed:@"jiantoud"];
        
        
        [UIView animateWithDuration:0.2f animations:^{
            self.arrowImage.layer.affineTransform = CGAffineTransformMakeRotation(M_PI);
        } completion:^(BOOL finished) {
            
            [_arrowImage removeFromSuperview];
            [_examineBtn setImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateNormal];
            
        }];

    }
    
    else if (integer == 1)
    {
        [_treatmentBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        self.arrowImage = [[UIImageView alloc]init];
        self.arrowImage.image = [UIImage imageNamed:@"jiantoud"];
        [_treatmentBtn addSubview:self.arrowImage];
        
        WEAK_SELF(self);
        
        [self.arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerY.equalTo(self.treatmentLb.mas_centerY);
            make.right.equalTo(self.contentView.mas_right).offset(-20);
            make.size.mas_equalTo(CGSizeMake(8, 8));
        }];
        
        
        self.arrowImage.image = [UIImage imageNamed:@"jiantoud"];
        
        
        [UIView animateWithDuration:0.2f animations:^{
            self.arrowImage.layer.affineTransform = CGAffineTransformMakeRotation(M_PI);
        } completion:^(BOOL finished) {
            
            [_arrowImage removeFromSuperview];
            [_treatmentBtn setImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateNormal];
            
        }];

        
    }
    
    else if (integer == 2)
        
    {
        [_nursedBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        self.arrowImage = [[UIImageView alloc]init];
        self.arrowImage.image = [UIImage imageNamed:@"jiantoud"];
        [_nursedBtn addSubview:self.arrowImage];
        
        WEAK_SELF(self);
        
        [self.arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerY.equalTo(self.nursedLb.mas_centerY);
            make.right.equalTo(self.contentView.mas_right).offset(-20);
            make.size.mas_equalTo(CGSizeMake(8, 8));
        }];
        
        
        self.arrowImage.image = [UIImage imageNamed:@"jiantoud"];
        
        
        [UIView animateWithDuration:0.2f animations:^{
            self.arrowImage.layer.affineTransform = CGAffineTransformMakeRotation(M_PI);
        } completion:^(BOOL finished) {
            
            [_arrowImage removeFromSuperview];
            [_nursedBtn setImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateNormal];
            
        }];

    }
    
   
}


@end
