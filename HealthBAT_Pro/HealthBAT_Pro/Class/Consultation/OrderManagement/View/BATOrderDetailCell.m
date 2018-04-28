//
//  BATOrderDetailCell.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 16/9/29.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATOrderDetailCell.h"
@interface BATOrderDetailCell()


@property (nonatomic,strong) UIView  *lineView;
@end
@implementation BATOrderDetailCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        WEAK_SELF(self)
        [self.contentView addSubview:self.nameLb];
        [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self)
            make.left.equalTo(self.contentView.mas_left).offset(14);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        
        [self.contentView addSubview:self.detailLb];
        [self.detailLb mas_makeConstraints:^(MASConstraintMaker *make) {
           STRONG_SELF(self)
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        
        [self.contentView addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
           STRONG_SELF(self)
            make.left.right.bottom.equalTo(self.contentView);
            make.height.equalTo(@1);
        }];
    }
    return self;
}



#pragma mark - SETTER - GETTER
-(UILabel *)nameLb {
    if (!_nameLb) {
        _nameLb = [[UILabel alloc]init];
        _nameLb.font = [UIFont systemFontOfSize:15];
        _nameLb.textColor = UIColorFromHEX(0X666666, 1);
    }
    return _nameLb;
}

-(UILabel *)detailLb {
    if (!_detailLb) {
        _detailLb = [[UILabel alloc]init];
        _detailLb.textColor = UIColorFromHEX(0X333333, 1);
        _detailLb.font = [UIFont systemFontOfSize:15];
    }
    return _detailLb;
}

-(UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = UIColorFromHEX(0Xf6f6f6, 1);
    }
    return _lineView;
}
@end
