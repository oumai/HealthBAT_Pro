//
//  BATProjectCell.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/2/28.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATProjectCell.h"

@implementation BATProjectCell

- (IBAction)clickAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(BATProjectCellClickAction:)]) {
        [self.delegate BATProjectCellClickAction:self.pathRow.row];
    }
    
}

- (void)setModel:(ProgrammesData *)model {

    _model = model;
    
    [self.iconImg sd_setImageWithURL:[NSURL URLWithString:model.TemplateImage] placeholderImage:[UIImage imageNamed:@"icon_login_logo"]];
    
    self.titleLb.text = model.Remark;
    
//    self.subTitle.hidden = _model.IsFlag;
//    self.clickBtn.hidden = _model.IsFlag;
//    self.stateLabel.hidden = !_model.IsFlag;
    
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.titleLb.textColor = UIColorFromHEX(0X333333, 1);
    
    self.subTitle.enbleGraditor = YES;
    [self.subTitle setGradientColors:@[START_COLOR,END_COLOR]];
    
    self.lineView.backgroundColor = BASE_BACKGROUND_COLOR;
    
    self.stateLabel.hidden = YES;
}


@end
