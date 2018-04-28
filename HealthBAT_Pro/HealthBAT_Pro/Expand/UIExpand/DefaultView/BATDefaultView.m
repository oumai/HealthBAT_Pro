//
//  BATDefaultView.m
//  HealthBAT_Pro
//
//  Created by four on 16/12/27.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATDefaultView.h"
#import "SVProgressHUD.h"

@implementation BATDefaultView

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = BASE_BACKGROUND_COLOR;
        
        WEAK_SELF(self);
        [self addSubview:self.imageV];
        [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            
            STRONG_SELF(self);
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY).offset(-50);
            make.width.mas_equalTo(128);
            make.height.mas_equalTo(143.5);
        }];
        
        //只有文字
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            STRONG_SELF(self);
            make.centerX.equalTo(self.imageV.mas_centerX);
            make.top.equalTo(self.imageV.mas_bottom).offset(30);
            make.width.mas_equalTo(SCREEN_WIDTH);
            make.height.mas_equalTo(25);
        }];
        
        
        //重新加载按钮
        [self addSubview:self.reloadButton];
        [self.reloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            STRONG_SELF(self);
            make.centerX.equalTo(self.titleLabel.mas_centerX);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(30);
            make.width.mas_equalTo(90);
            make.height.mas_equalTo(40);
        }];
        
        
    }
    return self;
}


- (void)changeDefaultStyleOfShowReloadButtonForNoNet:(BOOL)netState  andRequsetStateError:(BOOL)requsetState{
    
    if(netState){
        //没有网络
        self.imageV.image = [UIImage imageNamed:@"无网络"];
        self.titleLabel.hidden = NO;
        self.titleLabel.text = @"网络好像不太给力，请检查网络再试试";
        self.reloadButton.hidden = NO;
    }else if(requsetState){
        //请求失败
        self.imageV.image = [UIImage imageNamed:@"无数据"];
        self.titleLabel.hidden = NO;
        self.titleLabel.text = @"暂时没有数据";
        self.reloadButton.hidden = NO;
    }else{
        //真的无数据
        self.imageV.image = [UIImage imageNamed:@"无数据"];
        self.titleLabel.hidden = NO;
        self.titleLabel.text = @"暂时没有数据";
        self.reloadButton.hidden = YES;
    }
}

- (void)chagngeDefaultViewImageView:(NSString *)iamgeStr withTitle:(NSString *)titleStr{
    self.imageV.image = [UIImage imageNamed:iamgeStr];
    self.titleLabel.text = titleStr;
}

- (void)showDefaultView{
    self.hidden = NO;
    if(NET_STATION){
        //有网
        if (RESQUEST_STATION) {
            //请求成功
            [self changeDefaultStyleOfShowReloadButtonForNoNet:NO andRequsetStateError:NO];
        }else{
            //请求失败
            [self changeDefaultStyleOfShowReloadButtonForNoNet:NO andRequsetStateError:YES];
        }
    }else{
        //没网
        [self changeDefaultStyleOfShowReloadButtonForNoNet:YES andRequsetStateError:NO];
    };
}

#pragma mark - getter&setter
- (UIImageView *)imageV{
    if (!_imageV) {
        _imageV = [[UIImageView alloc]initWithFrame:CGRectZero];
    }
    
    return _imageV;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _titleLabel.textColor = UIColorFromHEX(0x666666, 1);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.hidden = YES;
    }
    
    return _titleLabel;
}

- (UIButton *)reloadButton{
    
    if (!_reloadButton) {
        _reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _reloadButton.layer.cornerRadius = 5.f;
        _reloadButton.hidden = YES;
        [_reloadButton setTitle:@"重新加载" forState:UIControlStateNormal];
        _reloadButton.layer.borderColor = UIColorFromHEX(0x666666, 1).CGColor;
        _reloadButton.layer.borderWidth = 1.f;
        [_reloadButton setTitleColor:UIColorFromHEX(0x666666, 1) forState:UIControlStateNormal];
        
        [_reloadButton bk_whenTapped:^{
            
            if (self.reloadRequestBlock) {
                self.reloadRequestBlock();
            }
        }];
    }
    
    return _reloadButton;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
