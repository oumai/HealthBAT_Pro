//
//  BATLeftAttendCell.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/3/17.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATLeftAttendCell.h"

@implementation BATLeftAttendCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.VerLineView.backgroundColor = BASE_COLOR;
//    self.backgroundColor = UIColorFromHEX(0Xf0f0f0, 1);
//    self.backView.hidden = YES;
//    self.VerLineView.hidden = YES;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        WEAK_SELF(self);
        
        [self.contentView addSubview:self.backView];
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            STRONG_SELF(self);
            make.edges.equalTo(self.contentView);
        }];
        
        [self.contentView addSubview:self.VerLineView];
        [self.VerLineView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            STRONG_SELF(self);
            make.top.bottom.left.equalTo(self.contentView).offset(0);
            make.width.mas_equalTo(2);
            
        }];
        
        [self.contentView addSubview:self.titleLb];
        [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
           
            STRONG_SELF(self);
            make.edges.equalTo(self.contentView);
        }];
        
    }
    
    return self;
}

- (void)setDataModel:(HotTopicListData *)dataModel {

    _dataModel = dataModel;
    
    [self.titleLb setTitle:[NSString stringWithFormat:@"#%@#",dataModel.Topic] forState:UIControlStateNormal];
    
    if (dataModel.isSelect) {
        self.backView.hidden = NO;
        self.VerLineView.hidden = NO;
        [self.titleLb setGradientColors:@[START_COLOR,END_COLOR]];
    }else {
        self.backView.hidden = YES;
        self.VerLineView.hidden = YES;
        [self.titleLb setGradientColors:@[UIColorFromHEX(0X333333, 1)]];
    }
    
}

#pragma mark - Load

- (UIView *)backView {

    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.backgroundColor = [UIColor whiteColor];
    }
    return _backView;
}

- (UIView *)VerLineView {

    if (!_VerLineView) {
        _VerLineView = [[UIView alloc]init];
        _VerLineView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Person_Detail_Head"]];
    }
    return _VerLineView;
}

- (BATGraditorButton *)titleLb {

    if (!_titleLb) {
        _titleLb = [[BATGraditorButton alloc]init];
        _titleLb.enbleGraditor = YES;
        _titleLb.userInteractionEnabled = NO;
        _titleLb.titleLabel.font = [UIFont systemFontOfSize:15];
        [_titleLb setGradientColors:@[START_COLOR,END_COLOR]];
    }
    return _titleLb;
}

@end
