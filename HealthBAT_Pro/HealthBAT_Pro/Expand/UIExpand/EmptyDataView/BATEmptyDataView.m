//
//  BATEmptyDataView.m
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/6/21.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATEmptyDataView.h"
@interface BATEmptyDataView ()
/** 图片 */
@property (nonatomic, strong) UIImageView *imageView;
/** 描述 */
@property (nonatomic, strong) UILabel *titleLabel;
/** 重新加载 */
@property (nonatomic, strong) UIButton *reloadButton;

@end

@implementation BATEmptyDataView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.imageView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.reloadButton];
        self.backgroundColor = BASE_BACKGROUND_COLOR;
        [self commonInit];
        
    }
    
    return self;
}

- (void)commonInit{
    if(NET_STATION){   //有网
        if (RESQUEST_STATION) {  //请求成功
            [self changeEmptyDataStyleOfShowReloadButtonForNoNet:NO andRequsetStateError:NO];
        }else{
            //请求失败
            [self changeEmptyDataStyleOfShowReloadButtonForNoNet:NO andRequsetStateError:YES];
        }
    }else{
        //没网
        [self changeEmptyDataStyleOfShowReloadButtonForNoNet:YES andRequsetStateError:NO];
    };
    
}

- (void)changeEmptyDataStyleOfShowReloadButtonForNoNet:(BOOL)netState  andRequsetStateError:(BOOL)requsetState{
    
    if(netState){
        //没有网络
        self.imageView.image = [UIImage imageNamed:@"无网络"];
        self.titleLabel.hidden = NO;
        self.titleLabel.text = @"网络好像不太给力，请检查网络再试试";
        self.reloadButton.hidden = NO;
    }else if(requsetState){
        //请求失败
        self.imageView.image = [UIImage imageNamed:@"无数据"];
        self.titleLabel.hidden = NO;
        self.titleLabel.text = @"暂时没有数据";
        self.reloadButton.hidden = YES;
    }else{
        //真的无数据
        self.imageView.image = [UIImage imageNamed:@"无数据"];
        self.titleLabel.hidden = NO;
        self.titleLabel.text = @"暂时没有数据";
        self.reloadButton.hidden = YES;
    }
    
}
- (void)reloadButtonClick:(UIButton *)reloadBtn{
    
    if (self.reloadRequestBlock) {
        self.reloadRequestBlock();
        [self commonInit];
        
    }
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    WeakSelf
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(130/2);
        make.width.mas_equalTo(154/2);
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
        make.centerY.equalTo(weakSelf.mas_centerY).offset(-50);
        
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.imageView.mas_centerX);
        make.top.equalTo(weakSelf.imageView.mas_bottom).offset(10);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        
    }];
    
    [self.reloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.imageView.mas_centerX);
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(10);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(35);
    }];
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
    }
    return _imageView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = UIColorFromHEX(0x666666, 1);
        _titleLabel.font = [UIFont systemFontOfSize:15];
        
    }
    return _titleLabel;
}

- (UIButton *)reloadButton{
    if (!_reloadButton) {
        _reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_reloadButton setTitle:@"重新加载" forState:UIControlStateNormal];
        [_reloadButton setTitle:@"重新加载" forState:UIControlStateHighlighted];
        [_reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _reloadButton.layer.cornerRadius = 5.f;
        _reloadButton.layer.borderWidth = 1.f;
        _reloadButton.layer.masksToBounds = YES;
        _reloadButton.layer.borderColor = UIColorFromHEX(0x666666, 1).CGColor;
        [_reloadButton setTitleColor:UIColorFromHEX(0x666666, 1) forState:UIControlStateNormal];
        [_reloadButton setTitleColor:UIColorFromHEX(0x666666, 1) forState:UIControlStateHighlighted];
    }
    return _reloadButton;
}
@end
