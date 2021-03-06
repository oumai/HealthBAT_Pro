//
//  testCell.m
//  TableViewTest
//
//  Created by mac on 16/9/16.
//  Copyright © 2016年 sword. All rights reserved.
//

#import "BATDieaseCell.h"

@interface BATDieaseCell()
@property(nonatomic,strong)UIView *verView;
@property (nonatomic, strong) UIImageView *arrowImage;
@property(nonatomic,strong)UIView *horView;


@property(nonatomic,strong)BATDieaseDetailEntityModel *model;
@end

@implementation BATDieaseCell

 static NSString *const DieaseCellReuseName = @"DIEASECELL";

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        WEAK_SELF(self);
    
        [self.contentView addSubview:self.iconView];
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.contentView).offset(10);
            make.top.equalTo(self.contentView.mas_top).offset(12.5);
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
         self.nameLb.preferredMaxLayoutWidth = SCREEN_WIDTH - 61.5;
        [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerY.equalTo(self.iconView.mas_centerY);
            make.left.equalTo(self.iconView.mas_right).offset(10);
            make.right.equalTo(self.contentView.mas_right).offset(-22.5);
        }];
        
        [self.contentView addSubview:self.horView];
        [self.horView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.nameLb.mas_bottom).offset(5);
            make.left.equalTo(self.iconView.mas_right).offset(10);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.height.equalTo(@1);
        }];
        
        [self.contentView addSubview:self.detailLb];
        self.detailLb.preferredMaxLayoutWidth = SCREEN_WIDTH - 49;
        [self.detailLb mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.horView.mas_bottom).offset(10);
            make.left.equalTo(self.iconView.mas_right).offset(10);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
        }];
        
        [self.contentView addSubview:self.moreBtn];
        [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerY.equalTo(self.nameLb.mas_centerY);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.size.mas_equalTo(CGSizeMake(250, 40));
        }];
        
    }
    return self;
}

- (void)setIsRowOne:(BOOL)isRowOne {

    _isRowOne = isRowOne;
    WEAK_SELF(self);
    if (_isRowOne) {
        [self.verView mas_remakeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.iconView.mas_bottom).offset(0);
            make.centerX.equalTo(self.iconView.mas_centerX);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(0);
            make.width.mas_equalTo(2);
        }];
    }else {
        [self.verView mas_remakeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.mas_top).offset(0);
            make.centerX.equalTo(self.iconView.mas_centerX);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(0);
            make.width.mas_equalTo(2);
        }];
    }
}

#pragma mark -CellForRow加载以及滚动时候调用
-(void)configCellWithModel:(BATDieaseDetailEntityModel *)model{
    
    self.model = model;
    self.nameLb.text = model.name;
    self.detailLb.text = model.detailLb;
    
    /*
    if (model.isOpen) {
                self.detailLb.numberOfLines = 0;

            }else {
                self.detailLb.numberOfLines = 3;

            }
     */
    
//    if (self.model.isOpen) {
//        [self.moreBtn setImage:[UIImage imageNamed:@"iconfont-arrow-up"] forState:UIControlStateNormal];
//    }else{
//         [self.moreBtn setImage:[UIImage imageNamed:@"iconfont-arrow-down-拷贝-2"] forState:UIControlStateNormal];
//    }
}

#pragma mark -自动布局自动计算高度并返回
+(CGFloat)HeightWithModel:(BATDieaseDetailEntityModel *)model {
    BATDieaseCell *cell = [[BATDieaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DieaseCellReuseName];
    [cell configCellWithModel:model];
    
    
    [cell layoutIfNeeded];
    
    CGRect frame = cell.detailLb.frame;
    CGFloat height = frame.origin.y +frame.size.height +20;
    return height;
}

-(void)changeFrame
{
    //开关置反
  //  self.model.isOpen = !self.model.isOpen;

    //刷新表格
    if (self.block) {
        self.block(self.path);
    }
    
    [self animationStart];
}


#pragma mark - SETTER - GETTER
-(UIImageView *)iconView{
    if (!_iconView) {
        _iconView = [[UIImageView alloc]init];
        _iconView.backgroundColor = [UIColor whiteColor];
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
        _nameLb.font = [UIFont systemFontOfSize:16];
        _nameLb.textColor = UIColorFromHEX(0X333333, 1);
    }
    return _nameLb;
}

-(UILabel *)detailLb{
    if (!_detailLb) {
        _detailLb = [[UILabel alloc]init];
        _detailLb.numberOfLines = 3;
        _detailLb.textColor = UIColorFromHEX(0X666666, 1);
        _detailLb.font = [UIFont systemFontOfSize:15];
        _detailLb.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeFrame)];
        
        [_detailLb addGestureRecognizer:tap];
    }
    return _detailLb;
}

-(UIButton *)moreBtn{
    if (!_moreBtn) {
        _moreBtn = [[UIButton alloc]init];
        [_moreBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 230, 10, 0)];
        [self.moreBtn addTarget:self action:@selector(changeFrame) forControlEvents:UIControlEventTouchUpInside];
        [_moreBtn setImage:[UIImage imageNamed:@"jiantou01"] forState:UIControlStateNormal];
    }
    return _moreBtn;
}


- (void)animationStart {
    
    
    [_moreBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    self.arrowImage = [[UIImageView alloc]init];
    self.arrowImage.image = [UIImage imageNamed:@"jiantoud"];
    [self.moreBtn addSubview:self.arrowImage];
    
    WEAK_SELF(self);

    [self.arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerY.equalTo(self.nameLb.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.size.mas_equalTo(CGSizeMake(8, 8));
    }];

    
    self.arrowImage.image = [UIImage imageNamed:@"jiantoud"];
    
    
    [UIView animateWithDuration:0.2f animations:^{
        self.arrowImage.layer.affineTransform = CGAffineTransformMakeRotation(M_PI);
    } completion:^(BOOL finished) {
        
        [_arrowImage removeFromSuperview];
        [_moreBtn setImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateNormal];

    }];
}
@end
