//
//  BATTreatmentCell.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2016/11/4.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATTreatmentCell.h"
@interface BATTreatmentCell()

@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UIImageView *arrowImg;
@end
@implementation BATTreatmentCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        WEAK_SELF(self)
        
        [self.contentView addSubview:self.eventLabel];
        [self.eventLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self)
            make.left.equalTo(self.contentView).offset(13);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        
        [self.contentView addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
           STRONG_SELF(self)
            make.left.right.bottom.equalTo(self.contentView).offset(0);
            make.height.mas_equalTo(1);
        }];
        
        [self.contentView addSubview:self.arrowImg];
        [self.arrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
           STRONG_SELF(self)
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
        }];
        
        [self.contentView addSubview:self.infoLabel];
        [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self)
            make.right.equalTo(self.arrowImg.mas_left).offset(-5);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        
    }
    return self;
}

- (UILabel *)eventLabel {
    if (!_eventLabel) {
        NSRange ranges;
        ranges.location = 4;
        ranges.length = 1;
        NSString * str = [NSString stringWithFormat:@"%@ *",@"就诊人"];
        NSDictionary * attDic = @{NSForegroundColorAttributeName:UIColorFromHEX(0Xff3b2f, 1)};
        NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attStr setAttributes:attDic range:ranges];
        _eventLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:UIColorFromHEX(0X333333, 1) textAlignment:NSTextAlignmentLeft];
        _eventLabel.attributedText = attStr;
    }
    return _eventLabel;
}

- (UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:UIColorFromHEX(0X999999, 1) textAlignment:NSTextAlignmentLeft];
        _infoLabel.numberOfLines = 0;
        _infoLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _infoLabel.text = @"请选择就诊人";
    }
    return _infoLabel;
}

-(UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = BASE_LINECOLOR;
    }
    return _lineView;
}

-(UIImageView *)arrowImg {
    if (!_arrowImg) {
        _arrowImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_arrow_right"]];
    }
    return _arrowImg;
}

@end
