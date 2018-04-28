//
//  BATFeedbackCell.m
//  HealthBAT_Pro
//
//  Created by KM on 2017/5/10.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATFeedbackCell.h"
@interface BATFeedbackCell ()

@property (nonatomic, strong)UIView *separatorView;
@end
@implementation BATFeedbackCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.separatorView];
        [self.contentView addSubview:self.textFiled];
        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
         //设置富文本对象的颜色
                attributes[NSForegroundColorAttributeName] =  UIColorFromHEX(0x999999, 1);
        // 设置UITextField的占位文字
                _textFiled.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入您的电子邮箱" attributes:attributes];
    }
    return self;
}
- (UIView *)separatorView{
    if (!_separatorView) {
        _separatorView = [[UIView alloc]init];
        _separatorView.backgroundColor = UIColorFromHEX(0xe0e0e0, 1);
    }
    return _separatorView;
}
- (UITextField *)textFiled{
    if (!_textFiled) {
        _textFiled = [[UITextField alloc]init];
//        _textFiled.font = [UIFont fontWithName:@"STXihei" size:15];
        _textFiled.font = [UIFont systemFontOfSize:15];
        _textFiled.textColor = UIColorFromHEX(0x333333, 1);
        _textFiled.textAlignment = NSTextAlignmentLeft;

        
    }
    return _textFiled;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.textFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@(14));
        make.right.mas_equalTo(@(-14));
        make.top.mas_equalTo(@(0));
        make.bottom.mas_equalTo(@-1);
        
    }];
    [self.separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@14);
        make.right.mas_equalTo(@-14);
        make.height.mas_equalTo(@0.5);
        make.bottom.mas_equalTo(@-1);
    }];
}
@end
