//
//  leftTabCell.m
//  BATmySelfIntreatmentController
//
//  Created by kmcompany on 16/10/9.
//  Copyright © 2016年 kmcompany. All rights reserved.
//

#import "leftTabCell.h"
@interface leftTabCell()
@property (nonatomic,strong) BATGraditorButton *lineView;
@property (nonatomic,strong) UIView *backView;
@end
@implementation leftTabCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.backView];
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self.contentView).offset(0);
        }];
        
        [self.contentView addSubview:self.nameLb];
        [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self.contentView).offset(0);
        }];
        
        [self.contentView addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(0);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.height.mas_equalTo(35);
            make.width.mas_equalTo(4);
        }];
        
    }
    return self;
}

-(void)setModel:(Partsitemlist *)model {
    _model = model;
    [self.nameLb setTitle:model.ItemName forState:UIControlStateNormal];
    if (model.isSelect) {
//        self.nameLb.textColor = UIColorFromHEX(0X45a0f0, 1);
        [self.nameLb setGradientColors:@[START_COLOR,END_COLOR]];
        self.backView.backgroundColor = [UIColor whiteColor];
        self.lineView.hidden = NO;
    }else {
        self.lineView.hidden = YES;
        self.backView.backgroundColor = UIColorFromHEX(0Xf0f0f0, 1);
        [self.nameLb setGradientColors:@[UIColorFromHEX(0X676767, 1)]];
    }
}


-(BATGraditorButton *)nameLb {
    if (!_nameLb) {
        _nameLb = [[BATGraditorButton alloc]init];
        _nameLb.titleLabel.font = [UIFont systemFontOfSize:15];
        _nameLb.titleLabel.numberOfLines = 0;
        _nameLb.titleLabel.textAlignment = NSTextAlignmentCenter;
        _nameLb.enbleGraditor = YES;
        _nameLb.userInteractionEnabled = NO;
    }
    return _nameLb;
}

-(BATGraditorButton *)lineView {
    if (!_lineView) {
        _lineView = [[BATGraditorButton alloc]init];
        _lineView.backgroundColor = UIColorFromHEX(0X45a0f0, 1);
        _lineView.hidden = YES;
        _lineView.enablehollowOut = YES;
        [_lineView setGradientColors:@[START_COLOR,END_COLOR]];
    }
    return _lineView;
}

-(UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.backgroundColor = UIColorFromHEX(0Xf0f0f0, 1);
    }
    return _backView;
}

@end
