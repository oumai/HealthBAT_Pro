//
//  BATHomeBounesTableViewCell.m
//  HealthBAT_Pro
//
//  Created by 黄帆 on 2017/11/15.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHomeBounesTableViewCell.h"

@interface BATHomeBounesTableViewCell ()
@property (strong, nonatomic) UIView *contentViewBottom;
@property (strong, nonatomic) UIView *contentViewUp;
@property (strong, nonatomic) UILabel *titelLab;
@property (strong, nonatomic) UILabel *stutasLab;
@end

@implementation BATHomeBounesTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        [self layoutView];
        
    }
    return self;
}

- (void)layoutView {
    
    [self.contentView addSubview:self.titelLab];
    [self.contentView addSubview:self.contentViewBottom];
    [self.contentView addSubview:self.contentViewUp];
    [self.contentView addSubview:self.stutasLab];
    
    
    [self.titelLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.contentView);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width * 0.20);
        make.left.mas_equalTo(self.contentView.mas_left);
    }];
    [self.contentViewBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(20);
        make.bottom.mas_equalTo(self.contentMode).offset(-20);
        make.left.mas_equalTo(self.titelLab.mas_right).offset(10);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width * 0.5);
        
    }];
        [self.contentViewUp mas_makeConstraints:^(MASConstraintMaker *make) {
    
            make.top.mas_equalTo(self.contentView).offset(20);
            make.bottom.mas_equalTo(self.contentMode).offset(-20);
            make.left.mas_equalTo(self.titelLab.mas_right).offset(10);
            make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width * 0.5);
    
        }];
   
    
    [self.stutasLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.bottom.mas_equalTo(self.contentView);
        make.width.mas_greaterThanOrEqualTo(50);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.left.mas_equalTo(self.contentViewBottom.mas_right).offset(10);
    }];
    self.contentViewBottom.layer.cornerRadius = 5;
    self.contentViewBottom.layer.masksToBounds = YES;
    
    self.contentViewUp.layer.cornerRadius = 5;
    self.contentViewUp.layer.masksToBounds = YES;
}
//- (void)layoutSubviews {
//
//    [super layoutSubviews];
//   
//    
//}
- (UILabel *)titelLab {
    
    if (!_titelLab) {
        
        _titelLab = [[UILabel alloc] init];
        _titelLab.textAlignment = NSTextAlignmentRight;
        _titelLab.text = @"交流";
        _titelLab.font = [UIFont systemFontOfSize:13];
        _titelLab.adjustsFontSizeToFitWidth = YES;
        
    }
    return _titelLab;
    
}
- (UILabel *)stutasLab {
    
    if (!_stutasLab) {
        
        _stutasLab = [[UILabel alloc] init];
        _stutasLab.textAlignment = NSTextAlignmentLeft;
        _stutasLab.text = @"优秀";
        _stutasLab.font = [UIFont systemFontOfSize:13];
    }
    return _stutasLab;
    
}
- (UIView *)contentViewBottom {
    
    if (!_contentViewBottom) {
        _contentViewBottom = [[UIView alloc] init];
        _contentViewBottom.backgroundColor = [UIColor grayColor];
        
    }
    return _contentViewBottom;
}
- (UIView *)contentViewUp {
    
    if (!_contentViewUp) {
        _contentViewUp = [[UIView alloc] init];
        _contentViewUp.backgroundColor = [UIColor redColor];
    }
    return _contentViewUp;
}

- (void)setDic:(NSDictionary *)dic {
    
    _dic = dic;
    
    if (self.status == SLstatus ) {
        
        _titelLab.text = dic[@"title"];
        _stutasLab.text =  dic[@"DangerLevelName"];
        
//        NSString *statusStr = @"";
        CGFloat scale = 0.0;
        UIColor *color = UIColorFromHEX(0x23d25d, 1);

        if ([_stutasLab.text isEqualToString:@"极低风险"]) {
            scale = 0.2;
            
        } else if ( [_stutasLab.text isEqualToString:@"低风险"]) {
            scale = 0.4;
        } else if ([_stutasLab.text isEqualToString:@"中等风险"]) {
            scale = 0.6;
            color = UIColorFromHEX(0xfba034, 1);
        } else if ([_stutasLab.text isEqualToString:@"高风险"]) {
            scale = 0.8;
            color = UIColorFromHEX(0xf94e93, 1);
        } else {
            color = UIColorFromHEX(0xf94e93, 1);
            scale = 1.0;
        }
       
        
//        _stutasLab.text = statusStr;
        
        self.contentViewUp.backgroundColor = color;
        [self.contentViewUp mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView).offset(20);
            make.bottom.mas_equalTo(self.contentMode).offset(-20);
            make.left.mas_equalTo(self.titelLab.mas_right).offset(10);
            make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width * 0.5 * scale);

        }];
        
        
    } else if (self.status == SHstatus ) {
       
        NSMutableString *strM = [NSMutableString string];
        strM = [dic[@"title"] mutableCopy];
   
        
        _titelLab.text = strM;
        
        NSString *statusStr = @"";
        
        NSInteger sta = [dic[@"item"] integerValue];
        UIColor *color = [UIColor greenColor];
        switch (sta) {
            case 1:
            {
                statusStr = @"差";
                color = UIColorFromHEX(0x23d25d, 1);
            }
                break;
            case 2:
            {
                statusStr = @"中";
                color = UIColorFromHEX(0xfba034, 1);
            }
                break;
            case 3:
            {
                statusStr = @"优";
                color = UIColorFromHEX(0xf94e93, 1);
            }
                break;
                
            default:
                break;
        }
        
        _stutasLab.text = statusStr;
        
        CGFloat scale = sta / 3.0;
        NSLog(@"%ld --------------------00000000000000---------",(long)sta);
        self.contentViewUp.backgroundColor = color;
        [self.contentViewUp mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView).offset(20);
            make.bottom.mas_equalTo(self.contentMode).offset(-20);
            make.left.mas_equalTo(self.titelLab.mas_right).offset(10);
            
            make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width * 0.5 * scale);
            
        }];
        
        
        
    } else {
        
        NSMutableString *strM = [NSMutableString string];
        strM = [dic[@"title"] mutableCopy];
        
        
        _titelLab.text = strM;
        
        NSString *statusStr = @"";
        
        NSInteger sta = [dic[@"item"] integerValue];
        UIColor *color = [UIColor greenColor];
        switch (sta) {
            case 1:
            {
                statusStr = @"低";
                color =  UIColorFromHEX(0x23d25d, 1);
            }
                break;
            case 2:
            {
                statusStr = @"中";
                color = UIColorFromHEX(0xfba034, 1);
            }
                break;
            case 3:
            {
                statusStr = @"高";
                color = UIColorFromHEX(0xf94e93, 1);
            }
                break;
                
            default:
                break;
        }
        
        _stutasLab.text = statusStr;
        
        CGFloat scale = sta / 3.0;
        NSLog(@"%ld --------------------00000000000000---------",(long)sta);
        self.contentViewUp.backgroundColor = color;
        [self.contentViewUp mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView).offset(20);
            make.bottom.mas_equalTo(self.contentMode).offset(-20);
            make.left.mas_equalTo(self.titelLab.mas_right).offset(10);
            
            make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width * 0.5 * scale);
            
        }];
        
        
    }
    
   

}
@end
