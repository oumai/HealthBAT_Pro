//
//  BATFileDetailCell.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2016/12/6.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATFileDetailCell.h"
@interface BATFileDetailCell()
@property (nonatomic,strong) UIView *lineView;
@end
@implementation BATFileDetailCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        WEAK_SELF(self)
        
        [self.contentView addSubview:self.titleLb];
        [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self)
            make.left.equalTo(self.contentView).offset(15);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        
        [self.contentView addSubview:self.detailLb];
        [self.detailLb mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self)
            make.right.equalTo(self.contentView).offset(-15);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        
        [self.contentView addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
           STRONG_SELF(self)
            make.left.bottom.right.equalTo(self.contentView).offset(0);
            make.height.mas_equalTo(1);
        }];
    }
    return self;
}

#pragma mark -SETTER-GETTER
-(UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [[UILabel alloc]init];
        _titleLb.font = [UIFont systemFontOfSize:14];
        _titleLb.textColor = UIColorFromHEX(0X333333, 1);
    }
    return _titleLb;
}

-(UILabel *)detailLb {
    if (!_detailLb) {
        _detailLb = [[UILabel alloc]init];
        _detailLb.textColor = UIColorFromHEX(0X999999, 1);
        _detailLb.font = [UIFont systemFontOfSize:14];
    }
    return _detailLb;
}

-(UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = BASE_BACKGROUND_COLOR;
    }
    return _lineView;
}

@end


@interface BATFileDetailTextFiledCell()<UITextFieldDelegate>
@property (nonatomic,strong) UIView *lineView;
@end
@implementation BATFileDetailTextFiledCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        WEAK_SELF(self)
        
        [self.contentView addSubview:self.titleLb];
        [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self)
            make.left.equalTo(self.contentView).offset(15);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        
        [self.contentView addSubview:self.detailFiled];
        [self.detailFiled mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self)
            make.trailing.equalTo(@-15);
            make.centerY.equalTo(self.mas_centerY);
            make.width.mas_equalTo(200);
        }];
        
        [self.contentView addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self)
            make.left.bottom.right.equalTo(self.contentView).offset(0);
            make.height.mas_equalTo(1);
        }];
    }
    return self;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self endEditing:YES];
    return YES;
}

#pragma mark -SETTER-GETTER
-(UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [[UILabel alloc]init];
        _titleLb.font = [UIFont systemFontOfSize:14];
        _titleLb.textColor = UIColorFromHEX(0X333333, 1);
    }
    return _titleLb;
}

-(UITextField *)detailFiled {
    if (!_detailFiled) {
        _detailFiled = [[UITextField alloc]init];
        _detailFiled.textColor = UIColorFromHEX(0X999999, 1);
        _detailFiled.font = [UIFont systemFontOfSize:14];
        _detailFiled.textAlignment  = NSTextAlignmentRight;
        _detailFiled.delegate = self;
        NSAttributedString * ss = [[NSAttributedString alloc] initWithString:@"必填" attributes:@{NSForegroundColorAttributeName :[UIColor redColor]}];
        _detailFiled.attributedPlaceholder = ss;
     //    [_detailFiled addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _detailFiled;
}

-(UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = BASE_BACKGROUND_COLOR;
    }
    return _lineView;
}

@end
