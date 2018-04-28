//
//  BATPersonContentWithImageCell.m
//  HealthBAT_Pro
//
//  Created by four on 16/9/9.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATPersonContentWithImageCell.h"

@implementation BATPersonContentWithImageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        _iconImageV = [[UIImageView alloc]init];
        _iconImageV.backgroundColor = [UIColor clearColor];
        [_iconImageV sizeToFit];
        [self addSubview:_iconImageV];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = UIColorFromRGB(51, 51, 51,1);
        _titleLabel.font = [UIFont systemFontOfSize:14];
        [_titleLabel sizeToFit];
        [self addSubview:_titleLabel];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.textAlignment = NSTextAlignmentRight;
        _contentLabel.textColor = UIColorFromRGB(153, 153, 153,1);
        _contentLabel.font = [UIFont systemFontOfSize:14];
        [_contentLabel sizeToFit];
        [self addSubview:_contentLabel];
        
        //设置cell的separator
        [self setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0];
        
        [self setupConstraints];
        
    }
    return self;
}

- (void)setupConstraints
{
    WEAK_SELF(self);
    [_iconImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.mas_left).offset(10);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(27);
        make.height.mas_equalTo(27);
    }];
    
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(_iconImageV.mas_right).offset(15);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(120);
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.right.equalTo(self.mas_right).offset(-35);
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(_titleLabel.mas_right).offset(10);
    }];
}


- (void)loginAccountCell:(NSIndexPath *)indexPath Model:(BATPerson *)model {
    
    
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    switch (indexPath.row) {
//        case 0: {
//            //手机号
//            _iconImageV.image = [UIImage imageNamed:@"personalCenter_Mobile"];
//            _titleLabel.text = @"手机号";
//            _contentLabel.text = @"更换";
//        }
//            break;
        case 0:{
            //微信账号
            _iconImageV.image = [UIImage imageNamed:@"personalCenter_WeChat"];
            _titleLabel.text = @"微信账号";
            if (model.Data.IsBindWX == 0) {
                _contentLabel.text = @"未绑定";
            }else{
                _contentLabel.text = @"解绑";
            }
        }
            break;
        case 1:{
            //QQ账号
            _iconImageV.image = [UIImage imageNamed:@"personalCenter_QQ"];
            _titleLabel.text = @"QQ账号";
            if (model.Data.IsBindQQ == 0) {
                _contentLabel.text = @"未绑定";
            }else{
                _contentLabel.text = @"解绑";
            }
        }
            break;
        default:
            break;
    }
    
    if ([_contentLabel.text containsString:@"null"]) {
        _contentLabel.text = @"";
    }
    
}


@end
