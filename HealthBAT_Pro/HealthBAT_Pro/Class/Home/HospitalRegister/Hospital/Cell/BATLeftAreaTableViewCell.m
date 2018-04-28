//
//  BATLeftAreaTableViewCell.m
//  HealthBAT_Pro
//
//  Created by four on 16/10/25.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATLeftAreaTableViewCell.h"

@implementation BATLeftAreaTableViewCell

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
            make.top.bottom.equalTo(self.contentView).offset(0);
            make.width.mas_equalTo(4);
        }];
        
    }
    return self;
}


//-(void)setModel:(BOOL)isSelect {
//    if (isSelect) {
//        self.nameLb.textColor = UIColorFromHEX(0X45a0f0, 1);
//        self.backView.backgroundColor = [UIColor whiteColor];
//        self.lineView.hidden = NO;
//    }else {
//        self.lineView.hidden = YES;
//        self.backView.backgroundColor = UIColorFromHEX(0Xf0f0f0, 1);
//        self.nameLb.textColor = UIColorFromHEX(0X676767, 1);
//    }
//}


-(BATGraditorButton *)nameLb {
    if (!_nameLb) {
        _nameLb = [[BATGraditorButton alloc]init];
        _nameLb.titleLabel.font = [UIFont systemFontOfSize:15];
        _nameLb.titleLabel.numberOfLines = 0;
        _nameLb.titleLabel.textAlignment = NSTextAlignmentCenter;
        _nameLb.enbleGraditor = YES;
        [_nameLb setTitleColor:UIColorFromHEX(0X333333, 1) forState:UIControlStateNormal];
        _nameLb.userInteractionEnabled = NO;
    }
    return _nameLb;
}

-(BATGraditorButton *)lineView {
    if (!_lineView) {
        _lineView = [[BATGraditorButton alloc]init];
        _lineView.backgroundColor = UIColorFromHEX(0X45a0f0, 1);
        _lineView.enablehollowOut = YES;
        [_lineView setGradientColors:@[UIColorFromHEX(0X29ccbf, 1),UIColorFromHEX(0X6ccc56, 1)]];
        _lineView.hidden = YES;
       
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



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
