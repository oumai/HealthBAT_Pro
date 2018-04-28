//
//  BATAddInTreamentCell.m
//  HealthBAT_Pro
//
//  Created by MichaeOu on 2017/6/12.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATAddInTreamentCell.h"
#import "UIColor+HNExtensions.h"
#define KHexColor(stringColor) [UIColor colorForHexString:stringColor]
@interface BATAddInTreamentCell()<UITextFieldDelegate>

@end
@implementation BATAddInTreamentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = KHexColor(@"#ffffff");
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        
        self.titleLabel = [UILabel new];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.textColor = KHexColor(@"#666666");
        self.titleLabel.text = @"C罗";
        [self.contentView addSubview:_titleLabel];
        
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.centerY.equalTo(self.contentView.mas_centerY).offset(0);
            make.width.equalTo(self.titleLabel.mas_width);
            make.height.equalTo(@14);
        }];
        
       
        self.textField = [UITextField new];
        self.textField.textAlignment = NSTextAlignmentRight;
        self.textField.textColor = KHexColor(@"#666666");
        self.textField.font = [UIFont systemFontOfSize:14];
        self.textField.placeholder = @"请输入";
        [self.textField setValue:KHexColor(@"#999999") forKeyPath:@"_placeholderLabel.textColor"];
        [self.textField setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
        self.textField.delegate = self;
        [self.contentView addSubview:_textField];
        
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-20);
            make.centerY.equalTo(self.contentView.mas_centerY).offset(0);
            make.width.equalTo(@200);
            make.height.equalTo(@30);
        }];

      
        
        self.lineView = [UIView new];
        self.lineView.backgroundColor = BASE_BACKGROUND_COLOR;
        [self.contentView addSubview:_lineView];
        
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView.mas_bottom).offset(0);
            make.left.equalTo(self.contentView.mas_left).offset(0);
            make.width.equalTo(@(SCREEN_WIDTH));
            make.height.equalTo(@0.5);
        }];

        
        self.arrowImage = [UIImageView new];
        [self.contentView addSubview:_arrowImage];
        
        [_arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY).offset(0);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.width.equalTo(@7);
            make.height.equalTo(@11);
        }];

              
    }
    return self;
}


//- (UITextField *)textField
//{
//    
//    if (nil == _textField) {
//        
//       
//    }
//   
//    return _textField;
//}
@end
