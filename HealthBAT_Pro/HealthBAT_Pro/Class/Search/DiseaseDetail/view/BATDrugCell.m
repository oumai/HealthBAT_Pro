//
//  BATDrugCell.m
//  TableViewTest
//
//  Created by mac on 16/9/17.
//  Copyright © 2016年 sword. All rights reserved.
//

#import "BATDrugCell.h"
#import "BATDieaseDetailEntityModel.h"
#import "BATDieaseDetailModel.h"

@interface BATDrugCell()
@property(nonatomic,strong)UIView *verView;
@property(nonatomic,strong)UIView *horView;

@property(nonatomic,strong)BATDieaseDetailEntityModel *model;

@property(nonatomic,strong)UILabel *lastLb;
//@property(nonatomic,strong)UIButton *moreBtn;

@property(nonatomic,assign)NSInteger  moreCount;

@property(nonatomic,assign)NSInteger cellHeight;

@end
@implementation BATDrugCell

static NSString *const DrugReuseName = @"DRUGCELL";

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        WEAK_SELF(self)
        
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
        
//        [self.contentView addSubview:self.moreBtn];
//        [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            STRONG_SELF(self);
//            make.right.equalTo(self.contentView.mas_right).offset(-10);
//            make.centerY.equalTo(self.nameLb.mas_centerY);
//            make.size.mas_equalTo(CGSizeMake(250, 30));
//        }];
        
        [self.contentView addSubview:self.horView];
        [self.horView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.nameLb.mas_bottom).offset(5);
            make.left.equalTo(self.iconView.mas_right).offset(10);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.height.equalTo(@1);
        }];
    }
    return self;
}

#pragma mark - 返回Cell高度
+(CGFloat)HeightWithModel:(BATDieaseDetailEntityModel *)model {
    

    BATDrugCell *cell = [[BATDrugCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DrugReuseName];
    [cell configCellWithModel:model];
    
    
    [cell layoutIfNeeded];
    
    CGRect frame = cell.lastLb.frame;
    CGFloat height = frame.origin.y +frame.size.height +20;
    return height;
}

#pragma mark -CellForRow执行方法
-(void)configCellWithModel:(BATDieaseDetailEntityModel *)model{
    
    self.model = model;
    

        for (id object in self.contentView.subviews) {
            if ([object isKindOfClass:[UILabel class]]) {
                UILabel *lb = (UILabel *)object;
                if (lb.tag>=110) {
                    [lb removeFromSuperview];
                }
            }
        }
    
    if (model.DieaseInfo.count!=0) {
        self.lastLb = nil;
        for (int i = 0; i < model.treatmentsCount; i++) {
            UILabel *dieaseName = [[UILabel alloc]init];
            dieaseName.tag = 110+i;
            dieaseName.clipsToBounds = YES;
            dieaseName.layer.borderColor = BASE_LINECOLOR.CGColor;
            dieaseName.layer.borderWidth = 1;
            dieaseName.textAlignment = NSTextAlignmentCenter;
            dieaseName.textColor = UIColorFromHEX(0X333333, 1);
            dieaseName.font = [UIFont systemFontOfSize:14];
            dieaseName.numberOfLines = 0;
            Drugslst *drugslst  = model.DieaseInfo[i];
            
            CGSize size = [drugslst.Name boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-59, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
            
            dieaseName.text = drugslst.Name;
            
            dieaseName.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushToDrugDetailControllerAction:)];
            [dieaseName addGestureRecognizer:tap];
            
            dieaseName.backgroundColor = BASE_BACKGROUND_COLOR;
            
            [self.contentView addSubview:dieaseName];
            [dieaseName mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(size.height+10);
                
                CGFloat TopPins = 10 +i*(size.height+20);
                
                make.top.equalTo(self.horView.mas_bottom).offset(TopPins);
                
                CGFloat width = size.width+20.0;
                make.width.mas_equalTo(@(width));
                if (i==0) {
                    make.left.equalTo(self.iconView.mas_right).offset(10);
                }else{
                    make.left.equalTo(self.lastLb.mas_left);
                }
            }];
            self.lastLb = dieaseName;
        }
    }
    
//    if (self.model.treatmentIsOpen) {
//
//        [self.moreBtn setImage:[UIImage imageNamed:@"iconfont-arrow-up"] forState:UIControlStateNormal];
//    }else{
//        [self.moreBtn setImage:[UIImage imageNamed:@"iconfont-arrow-down-拷贝-2"] forState:UIControlStateNormal];
//    }
}


#pragma mark -Action
//药品点击事件，代理
-(void)pushToDrugDetailControllerAction:(UITapGestureRecognizer *)taper{
    if ([self.delegate respondsToSelector:@selector(BATDrugCellDrugClickActionWithRow:)]) {
        [self.delegate BATDrugCellDrugClickActionWithRow:taper.view.tag-110];
    }
}

//显示更多按钮事件
-(void)changeCounts:(UIButton *)btn
{
    
    if (!self.model.treatmentIsOpen) {
        _moreCount = self.model.DieaseInfo.count;
        self.model.treatmentIsOpen = YES;
        self.model.treatmentsCount = self.model.DieaseInfo.count;
    }else{
        if (self.model.DieaseInfo.count<2) {
            _moreCount = self.model.DieaseInfo.count;
            self.model.treatmentsCount = self.model.DieaseInfo.count;
            self.model.treatmentIsOpen = NO;
        }else {
        _moreCount = 2;
        self.model.treatmentsCount = 2;
        self.model.treatmentIsOpen = NO;
        }
    }
     [self configCellWithModel:self.model];
    
    if (self.block) {
        self.block(self.path);
    }
}


#pragma mark - SETTER - GETTER
-(UIImageView *)iconView{
    if (!_iconView) {
        _iconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon-cyyp"]];
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
        _nameLb.text = @"常用药品";
        _nameLb.font = [UIFont systemFontOfSize:16];
        _nameLb.textColor = UIColorFromHEX(0X333333, 1);
    }
    return _nameLb;
}

-(UILabel *)lastLb{
    if (!_lastLb) {
        _lastLb = [[UILabel alloc]init];
    }
    return _lastLb;
}
//
//-(UIButton *)moreBtn{
//    if (!_moreBtn) {
//        _moreBtn = [[UIButton alloc]init];
//        [_moreBtn setImage:[UIImage imageNamed:@"iconfont-arrow-down-拷贝-2"] forState:UIControlStateNormal];
//        [_moreBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 230, 10, 0)];
//        [_moreBtn addTarget:self action:@selector(changeCounts:) forControlEvents:UIControlEventTouchUpInside];
//        _moreCount = 2;
//    }
//    return _moreBtn;
//}
@end
