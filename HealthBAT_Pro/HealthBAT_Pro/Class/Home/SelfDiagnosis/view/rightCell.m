//
//  rightCell.m
//  BATmySelfIntreatmentController
//
//  Created by kmcompany on 16/10/9.
//  Copyright © 2016年 kmcompany. All rights reserved.
//

#import "rightCell.h"
#import "BATGraditorButton.h"
@interface rightCell()
@property (nonatomic,strong) BATGraditorButton *dieaseNameLb;
@end
@implementation rightCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.dieaseNameLb];
        [self.dieaseNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(20);
            make.top.bottom.right.equalTo(self.contentView).offset(0);
        }];
    }
    return self;
}

-(void)setRightModels:(Dislist *)rightModels {
    
    _rightModels = rightModels;
    [self.dieaseNameLb setTitle:rightModels.DisName forState:UIControlStateNormal];
    if (rightModels.isSelect) {
        [self.dieaseNameLb setGradientColors:@[START_COLOR,END_COLOR]];
    }else {
        [self.dieaseNameLb setGradientColors:@[UIColorFromHEX(0X676767, 1)]];
    }
    
}

-(BATGraditorButton *)dieaseNameLb {
    if (!_dieaseNameLb) {
        _dieaseNameLb = [[BATGraditorButton alloc]init];
        _dieaseNameLb.titleLabel.numberOfLines = 0;
        _dieaseNameLb.titleLabel.font = [UIFont systemFontOfSize:15];
        _dieaseNameLb.enbleGraditor = YES;
        _dieaseNameLb.userInteractionEnabled = NO;
    }
    return _dieaseNameLb;
}

@end
