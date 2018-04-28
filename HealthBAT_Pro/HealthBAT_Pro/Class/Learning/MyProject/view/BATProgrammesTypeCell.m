//
//  BATProgrammesTypeCell.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/2/28.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATProgrammesTypeCell.h"

@interface BATProgrammesTypeCell()


@property (nonatomic,strong) BATGraditorButton *lineView;

@end

@implementation BATProgrammesTypeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        WEAK_SELF(self);
        
        [self.contentView addSubview:self.titleLb];
        [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            
            STRONG_SELF(self);
            make.centerX.centerY.equalTo(self);
        
        }];
        
        [self.contentView addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            STRONG_SELF(self);
            make.width.mas_equalTo(4);
            make.height.mas_equalTo(50);
            make.left.equalTo(self).offset(0);
            make.top.equalTo(self.mas_top).offset(5);
            
        }];
    }
    return self;
}

- (void)setTypeModel:(ProgrammesType *)typeModel {

    _typeModel = typeModel;
    
    [self.titleLb setTitle:typeModel.CategoryName forState:UIControlStateNormal];
    
    if (!typeModel.isSelect) {
//        self.titleLb.textColor = UIColorFromHEX(0X333333, 1);
        [self.titleLb setGradientColors:@[UIColorFromHEX(0X333333, 1)]];
        self.lineView.hidden = YES;
    }else {
//        self.titleLb.textColor = UIColorFromHEX(0X0182eb, 1);
        [self.titleLb setGradientColors:@[START_COLOR,END_COLOR]];
        self.lineView.hidden = NO;
    }
}

#pragma mark - Lazy load
- (BATGraditorButton *)titleLb {

    if (!_titleLb) {
        _titleLb = [[BATGraditorButton alloc]init];
//        _titleLb.textColor = UIColorFromHEX(0X333333, 1);
        _titleLb.titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLb.enbleGraditor = YES;
        _titleLb.userInteractionEnabled = NO;
    }
    return _titleLb;

}

- (BATGraditorButton *)lineView {

    if (!_lineView) {
        _lineView = [[BATGraditorButton alloc]init];
        _lineView.hidden = YES;
        _lineView.enablehollowOut = YES;
        [_lineView setGradientColors:@[START_COLOR,END_COLOR]];
    }
    return _lineView;
}

@end


