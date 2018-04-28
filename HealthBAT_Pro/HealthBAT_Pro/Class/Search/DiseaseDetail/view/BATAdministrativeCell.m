//
//  administrativeCell.m
//  TableViewTest
//
//  Created by mac on 16/9/17.
//  Copyright © 2016年 sword. All rights reserved.
//
#import "BATAdministrativeCell.h"
#import "BATDieaseDetailEntityModel.h"

@interface BATAdministrativeCell()
@property(nonatomic,strong)UIView *verView;
@property(nonatomic,strong)UIImageView *iconView;
@property(nonatomic,strong)UIView *horView;
@property(nonatomic,strong)BATDieaseDetailEntityModel *model;

@property(nonatomic,strong)UILabel *detailLb;


@property(nonatomic,strong)UIView *upLeftDoc;
@property(nonatomic,strong)UIView *upRightDoc;
@property(nonatomic,strong)UIView *downLeftDoc;
@property(nonatomic,strong)UIView *downRightDoc;

@property(nonatomic,strong)UIButton *upLeftBtn;
@property(nonatomic,strong)UIButton *upRightBtn;
@property(nonatomic,strong)UIButton *downLeftBtn;
@property(nonatomic,strong)UIButton *downRightBtn;

@property(nonatomic,strong)UIImageView *upLeftArrow;
@property(nonatomic,strong)UIImageView *upRightArrow;
@property(nonatomic,strong)UIImageView *downLeftArrow;
@property(nonatomic,strong)UIImageView *downRightArrow;
@property(nonatomic,assign)NSInteger btnMark;
@end
@implementation BATAdministrativeCell

 static NSString *const AdministerReuseName = @"ADMINISTERCELL";

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
        
        [self.contentView addSubview:self.upLeftDoc];
        [self.upLeftDoc mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.horView.mas_bottom).offset(15);
            make.left.equalTo(self.iconView.mas_right).offset(10);
            make.size.mas_equalTo(CGSizeMake(6, 6));
        }];
        
        
        [self.contentView addSubview:self.upLeftBtn];
        [self.upLeftBtn addTarget:self action:@selector(changeText:) forControlEvents:UIControlEventTouchUpInside];
        [self.upLeftBtn setTitle:@"相关症状" forState:UIControlStateNormal];
        [self.upLeftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.upLeftDoc.mas_right).offset(5);
            make.centerY.equalTo(self.upLeftDoc.mas_centerY);
            make.width.mas_equalTo(100);
        }];
        
        
        [self.contentView addSubview:self.upLeftArrow];
        [self.upLeftArrow mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerY.equalTo(self.upLeftBtn.mas_centerY);
            make.left.equalTo(self.upLeftBtn.mas_right).offset(-35);
        }];
        
        
        [self.contentView addSubview:self.upRightDoc];
        [self.upRightDoc mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.horView.mas_bottom).offset(15);
            make.left.equalTo(self.upLeftBtn.mas_right).offset(50);
            make.size.mas_equalTo(CGSizeMake(6, 6));
        }];
        
        
        [self.contentView addSubview:self.upRightBtn];
        [self.upRightBtn addTarget:self action:@selector(changeText:) forControlEvents:UIControlEventTouchUpInside];
        [self.upRightBtn setTitle:@"并发症" forState:UIControlStateNormal];
        [self.upRightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.upRightDoc.mas_right).offset(5);
            make.centerY.equalTo(self.upRightDoc.mas_centerY);
            make.width.mas_equalTo(100);
        }];
        
        [self.contentView addSubview:self.upRightArrow];
        [self.upRightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerY.equalTo(self.upRightBtn.mas_centerY);
            make.left.equalTo(self.upRightBtn.mas_right).offset(-50);
        }];
        
        [self.contentView addSubview:self.detailLb];
        self.detailLb.preferredMaxLayoutWidth = SCREEN_WIDTH - 60;
        [self.detailLb mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.upLeftBtn.mas_bottom).offset(5);
            make.left.equalTo(self.upLeftBtn);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
        }];
        
        [self.contentView addSubview:self.downLeftDoc];
        [self.downLeftDoc mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.detailLb.mas_bottom).offset(15);
            make.left.equalTo(self.iconView.mas_right).offset(10);
            make.size.mas_equalTo(CGSizeMake(6, 6));
        }];
        
        [self.contentView addSubview:self.downLeftBtn];
        [self.downLeftBtn addTarget:self action:@selector(changeText:) forControlEvents:UIControlEventTouchUpInside];
        [self.downLeftBtn setTitle:@"易感人群" forState:UIControlStateNormal];
        [self.downLeftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.downLeftDoc.mas_right).offset(5);
            make.centerY.equalTo(self.downLeftDoc.mas_centerY);
            make.width.mas_equalTo(100);
        }];
        
        
        [self.contentView addSubview:self.downLeftArrow];
        [self.downLeftArrow mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerY.equalTo(self.downLeftBtn.mas_centerY);
            make.left.equalTo(self.downLeftBtn.mas_right).offset(-35);
        }];
        
        [self.contentView addSubview:self.downRightDoc];
        [self.downRightDoc mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.detailLb.mas_bottom).offset(15);
            make.left.equalTo(self.downLeftBtn.mas_right).offset(50);
            make.size.mas_equalTo(CGSizeMake(6, 6));
        }];
        
        
        [self.contentView addSubview:self.downRightBtn];
        [self.downRightBtn addTarget:self action:@selector(changeText:) forControlEvents:UIControlEventTouchUpInside];
        [self.downRightBtn setTitle:@"治愈率" forState:UIControlStateNormal];
        [self.downRightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.downRightDoc.mas_right).offset(5);
            make.centerY.equalTo(self.downRightDoc.mas_centerY);
            make.width.mas_equalTo(100);
        }];
        
        [self.contentView addSubview:self.downRightArrow];
        [self.downRightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerY.equalTo(self.downRightBtn.mas_centerY);
            make.left.equalTo(self.downRightBtn.mas_right).offset(-50);
        }];
        
        
        
        [self.contentView addSubview:self.downDetailLb];
        self.downDetailLb.preferredMaxLayoutWidth = SCREEN_WIDTH - 60;
        [self.downDetailLb mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.downLeftBtn.mas_bottom).offset(5);
            make.left.equalTo(self.downLeftBtn);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
        }];
        

    }
    return self;
}

#pragma mark - 计算并返回高度
+(CGFloat)HeightWithModel:(BATDieaseDetailEntityModel *)model {
    BATAdministrativeCell *cell = [[BATAdministrativeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AdministerReuseName];
    [cell configCellWithModel:model];
    
    
    [UIView animateWithDuration:0.35 animations:^{
        [cell layoutIfNeeded];
    }];
    
    CGRect frame = cell.downDetailLb.frame;
    CGFloat height = frame.origin.y +frame.size.height +10;
    return height;
}


#pragma mark - 刷新时候调用
-(void)configCellWithModel:(BATDieaseDetailEntityModel *)model{
    
    self.model = model;
    
    self.nameLb.text = model.name;

   
    if (self.model.upLeftIsOpen) {
        NSString *contentString = nil;
        if ([model.DieaseInfo[self.model.detailCount] isEqualToString:@""]) {
            contentString = @"暂无相关信息";
        }else {
            contentString = model.DieaseInfo[self.model.detailCount];
        }
        self.detailLb.text = contentString;
        [self.upLeftBtn setTitleColor:UIColorFromHEX(0X45a0f0, 1) forState:UIControlStateNormal];
        [self.upRightBtn setTitleColor:UIColorFromHEX(0X666666, 1) forState:UIControlStateNormal];
        
        [self.upLeftArrow setImage:[UIImage  imageNamed:@"iconfont-arrow-up"]];
        [self.upRightArrow setImage:[UIImage imageNamed:@"iconfont-arrow-down-拷贝-2"]];
        
    }else  if (self.model.upRightIsOpen) {
        self.detailLb.text = model.DieaseInfo[self.model.detailCount];
        [self.upRightBtn setTitleColor:UIColorFromHEX(0X45a0f0, 1) forState:UIControlStateNormal];
        [self.upLeftBtn setTitleColor:UIColorFromHEX(0X666666, 1) forState:UIControlStateNormal];
        
        [self.upRightArrow setImage:[UIImage  imageNamed:@"iconfont-arrow-up"]];
        [self.upLeftArrow setImage:[UIImage imageNamed:@"iconfont-arrow-down-拷贝-2"]];
    }else {
        self.detailLb.text = nil;
        [self.upLeftBtn setTitleColor:UIColorFromHEX(0X666666, 1) forState:UIControlStateNormal];
        [self.upRightBtn setTitleColor:UIColorFromHEX(0X666666, 1) forState:UIControlStateNormal];
        
        [self.upRightArrow setImage:[UIImage  imageNamed:@"iconfont-arrow-down-拷贝-2"]];
        [self.upLeftArrow setImage:[UIImage imageNamed:@"iconfont-arrow-down-拷贝-2"]];
    }
    
    if (self.model.downLeftIsOpen) {
        self.downDetailLb.text = model.DieaseInfo[self.model.downDetailCount];
        
        [self.downLeftBtn setTitleColor:UIColorFromHEX(0X45a0f0, 1) forState:UIControlStateNormal];
        [self.downRightBtn setTitleColor:UIColorFromHEX(0X666666, 1) forState:UIControlStateNormal];
        
        [self.downLeftArrow setImage:[UIImage  imageNamed:@"iconfont-arrow-up"]];
        [self.downRightArrow setImage:[UIImage imageNamed:@"iconfont-arrow-down-拷贝-2"]];
        
    }else if (self.model.downRightIsOpen) {
        self.downDetailLb.text = model.DieaseInfo[self.model.downDetailCount];
        
        [self.downRightBtn setTitleColor:UIColorFromHEX(0X45a0f0, 1) forState:UIControlStateNormal];
        [self.downLeftBtn setTitleColor:UIColorFromHEX(0X666666, 1) forState:UIControlStateNormal];
        
        [self.downRightArrow setImage:[UIImage  imageNamed:@"iconfont-arrow-up"]];
        [self.downLeftArrow setImage:[UIImage imageNamed:@"iconfont-arrow-down-拷贝-2"]];
    }else {
        self.downDetailLb.text = nil;
        [self.downLeftBtn setTitleColor:UIColorFromHEX(0X666666, 1) forState:UIControlStateNormal];
        [self.downRightBtn setTitleColor:UIColorFromHEX(0X666666, 1) forState:UIControlStateNormal];
        
        [self.downRightArrow setImage:[UIImage  imageNamed:@"iconfont-arrow-down-拷贝-2"]];
        [self.downLeftArrow setImage:[UIImage imageNamed:@"iconfont-arrow-down-拷贝-2"]];
    }
}

#pragma mark - Action
//查看各项内容点击事件
-(void)changeText:(UIButton *)btn{
    
    /*
    switch (btn.tag) {
        case 0: {
            self.model.detailCount = 0;
            if (!self.model.upLeftIsOpen) {
                self.model.upLeftIsOpen = YES;
                self.model.upRightIsOpen = NO;
            }else {
                self.model.upLeftIsOpen = NO;
            }
            break;
        }
        case 1: {
            self.model.detailCount = 1;
            if (!self.model.upRightIsOpen) {
                self.model.upRightIsOpen = YES;
                self.model.upLeftIsOpen = NO;
            }else {
                self.model.upRightIsOpen = NO;
            }
            break;
        }
        case 2: {
            self.model.downDetailCount = 2;
            if (!self.model.downLeftIsOpen) {
                self.model.downLeftIsOpen = YES;
                self.model.downRightIsOpen = NO;
            }else {
                self.model.downLeftIsOpen = NO;
            }
            break;
        }
        case 3: {
            self.model.downDetailCount = 3;
            if (!self.model.downRightIsOpen) {
                self.model.downRightIsOpen = YES;
                self.model.downLeftIsOpen = NO;
            }else {
                self.model.downRightIsOpen = NO;
            }
            break;
        }
        default:
            break;
    }
    
    [self configCellWithModel:self.model];
     */
    
    if (self.Administrativeblocks) {
        self.Administrativeblocks(self.path,btn.tag);
    }
}

#pragma mark - SETTER - GETTER
-(UIImageView *)iconView{
    if (!_iconView) {
        _iconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon-jzks"]];
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
        _nameLb.textColor = UIColorFromHEX(0X333333, 1);
        _nameLb.font = [UIFont systemFontOfSize:16];
    }
    return _nameLb;
}

-(UIView *)upLeftDoc{
    if (!_upLeftDoc) {
        _upLeftDoc = [[UIView alloc]init];
        _upLeftDoc.layer.borderWidth = 1;
        _upLeftDoc.layer.cornerRadius = 3;
        _upLeftDoc.layer.borderColor = [UIColor clearColor].CGColor;
        _upLeftDoc.backgroundColor = UIColorFromHEX(0X81ab54, 1);
    }
    return _upLeftDoc;
}

-(UIView *)upRightDoc{
    if (!_upRightDoc) {
        _upRightDoc = [[UIView alloc]init];
        _upRightDoc.layer.borderWidth = 1;
        _upRightDoc.layer.cornerRadius = 3;
        _upRightDoc.layer.borderColor = [UIColor clearColor].CGColor;
        _upRightDoc.backgroundColor = UIColorFromHEX(0X81ab54, 1);
    }
    return _upRightDoc;
}

-(UIView *)downLeftDoc{
    if (!_downLeftDoc) {
        _downLeftDoc = [[UIView alloc]init];
        _downLeftDoc.layer.borderWidth = 1;
        _downLeftDoc.layer.cornerRadius = 3;
        _downLeftDoc.layer.borderColor = [UIColor clearColor].CGColor;
        _downLeftDoc.backgroundColor = UIColorFromHEX(0X81ab54, 1);
    }
    return _downLeftDoc;
}

-(UIView *)downRightDoc{
    if (!_downRightDoc) {
        _downRightDoc = [[UIView alloc]init];
        _downRightDoc.layer.borderWidth = 1;
        _downRightDoc.layer.cornerRadius = 3;
        _downRightDoc.layer.borderColor = [UIColor clearColor].CGColor;
        _downRightDoc.backgroundColor = UIColorFromHEX(0X81ab54, 1);
    }
    return _downRightDoc;
}

-(UIButton *)upLeftBtn
{
    if (!_upLeftBtn) {
        _upLeftBtn = [[UIButton alloc]init];
        _upLeftBtn.tag = 0;
        _upLeftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _upLeftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_upLeftBtn setTitleColor:UIColorFromHEX(0X666666, 1) forState:UIControlStateNormal];
    }
    return _upLeftBtn;
}

-(UIButton *)upRightBtn
{
    if (!_upRightBtn) {
        _upRightBtn = [[UIButton alloc]init];
        _upRightBtn.tag = 1;
        _upRightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _upRightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_upRightBtn setTitleColor:UIColorFromHEX(0X666666, 1) forState:UIControlStateNormal];
    }
    return _upRightBtn;
}

-(UIButton *)downLeftBtn
{
    if (!_downLeftBtn) {
        _downLeftBtn = [[UIButton alloc]init];
        _downLeftBtn.tag = 2;
        _downLeftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _downLeftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_downLeftBtn setTitleColor:UIColorFromHEX(0X666666, 1) forState:UIControlStateNormal];
    }
    return _downLeftBtn;
}

-(UIButton *)downRightBtn
{
    if (!_downRightBtn) {
        _downRightBtn = [[UIButton alloc]init];
        _downRightBtn.tag = 3;
        _downRightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _downRightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_downRightBtn setTitleColor:UIColorFromHEX(0X666666, 1) forState:UIControlStateNormal];
    }
    return _downRightBtn;
}

-(UILabel *)detailLb{
    if (!_detailLb) {
        _detailLb = [[UILabel alloc]init];
        _detailLb.numberOfLines = 0;
        _detailLb.textColor = UIColorFromHEX(0X999999, 1);
        _detailLb.font = [UIFont systemFontOfSize:15];
    }
    return _detailLb;
}

-(UILabel *)downDetailLb{
    if (!_downDetailLb) {
        _downDetailLb = [[UILabel alloc]init];
        _downDetailLb.numberOfLines = 0;
        _downDetailLb.textColor = UIColorFromHEX(0X999999, 1);
        _downDetailLb.font = [UIFont systemFontOfSize:15];
    }
    return _downDetailLb;
}


-(UIImageView *)upLeftArrow{
    if (!_upLeftArrow) {
        _upLeftArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"iconfont-arrow-down-拷贝-2"]];
    }
    return _upLeftArrow;
}

-(UIImageView *)upRightArrow{
    if (!_upRightArrow) {
        _upRightArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"iconfont-arrow-down-拷贝-2"]];
    }
    return _upRightArrow;
}

-(UIImageView *)downLeftArrow{
    if (!_downLeftArrow) {
        _downLeftArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"iconfont-arrow-down-拷贝-2"]];
    }
    return _downLeftArrow;
}

-(UIImageView *)downRightArrow{
    if (!_downRightArrow) {
        _downRightArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"iconfont-arrow-down-拷贝-2"]];
    }
    return _downRightArrow;
}
@end
