//
//  BATFamilyDoctorPaySuccessCell.m
//  HealthBAT_Pro
//
//  Created by four on 2017/4/12.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATFamilyDoctorPaySuccessCell.h"

@implementation BATFamilyDoctorPaySuccessCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self addSubview:self.rightImageView];
        [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@37.5);
            make.centerX.equalTo(@0);
            make.width.height.mas_equalTo(100);
        }];
        
        [self addSubview:self.successLabel];
        [self.successLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.rightImageView.mas_bottom).offset(15);
            make.centerX.equalTo(@5);
            make.bottom.equalTo(@-37.5);
        }];
    }
    
    return self;
}


- (UIImageView *)rightImageView{
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-zfcg"]];
    }
    return _rightImageView;
}


- (UILabel *)successLabel{
    if (!_successLabel) {
        _successLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:16] textColor:UIColorFromHEX(0x666666, 1) textAlignment:NSTextAlignmentCenter];
        _successLabel.text = @" 支付成功！";
        [_successLabel sizeToFit];
    }
    
    return _successLabel;
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
