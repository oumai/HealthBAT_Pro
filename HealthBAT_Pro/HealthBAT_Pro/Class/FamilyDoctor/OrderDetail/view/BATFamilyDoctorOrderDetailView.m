//
//  BATFamilyDoctorOrderDetailView.m
//  HealthBAT_Pro
//
//  Created by four on 2017/4/11.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATFamilyDoctorOrderDetailView.h"

@implementation BATFamilyDoctorOrderDetailView

- (instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        
        [self pageLayouts];
    }
    return self;
}

- (void)pageLayouts{
    
    
    WEAK_SELF(self);
    [self addSubview:self.firstView];
    [self.firstView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(self);
        make.height.mas_equalTo(100);
        make.width.mas_equalTo(SCREEN_WIDTH/5.0);
        make.left.equalTo(self);
    }];
    
    [self addSubview:self.secondView];
    [self.secondView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(self);
        make.height.mas_equalTo(100);
        make.width.mas_equalTo(SCREEN_WIDTH/5.0);
        make.left.equalTo(self).offset(SCREEN_WIDTH/5.0);
    }];
    
    [self addSubview:self.thirdView];
    [self.thirdView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.bottom.equalTo(self);
        make.height.mas_equalTo(100);
        make.width.mas_equalTo(SCREEN_WIDTH/5.0);
        make.left.equalTo(self).offset(SCREEN_WIDTH/5.0*2);
    }];
    
    [self addSubview:self.fourView];
    [self.fourView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.bottom.equalTo(self);
        make.height.mas_equalTo(100);
        make.width.mas_equalTo(SCREEN_WIDTH/5.0);
        make.left.equalTo(self).offset(SCREEN_WIDTH/5.0*3);
    }];
    
    [self addSubview:self.fiveView];
    [self.fiveView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.bottom.equalTo(self);
        make.height.mas_equalTo(100);
        make.width.mas_equalTo(SCREEN_WIDTH/5.0);
        make.left.equalTo(self.fourView.mas_right);
        make.left.equalTo(self).offset(SCREEN_WIDTH/5.0*4);
    }];

}

- (void)reloadViewWithData:(BATFamilyDoctorOrderState )OrderStateShow  isComment:(BOOL)isComment IsOrder:(BOOL)IsOrder{
    
    switch (OrderStateShow) {
        case BATFamilyDoctorOrderCancel:
        {
            //判断是否接了单
            if(IsOrder){
                //接了，走到医生接单
                self.firstView.leftLine.hidden = YES;
                self.firstView.rightLine.hidden = NO;
                self.firstView.leftLine.backgroundColor = UIColorFromHEX(0x0182eb, 1);
                self.firstView.rightLine.backgroundColor = UIColorFromHEX(0x0182eb, 1);
                self.firstView.numberView.image = [UIImage imageNamed:@"icon-n-1"];
                self.firstView.titleLabel.textColor = UIColorFromHEX(0x0182eb, 1);
                
                self.secondView.leftLine.hidden = NO;
                self.secondView.rightLine.hidden = NO;
                self.secondView.leftLine.backgroundColor = UIColorFromHEX(0x0182eb, 1);
                self.secondView.rightLine.backgroundColor = UIColorFromHEX(0x0182eb, 1);
                self.secondView.numberView.image = [UIImage imageNamed:@"icon-n-2"];
                self.secondView.titleLabel.textColor = UIColorFromHEX(0x0182eb, 1);
            }else{
                //没走，走到提交订单
                self.firstView.leftLine.hidden = YES;
                self.firstView.rightLine.hidden = NO;
                self.firstView.leftLine.backgroundColor = UIColorFromHEX(0x0182eb, 1);
                self.firstView.rightLine.backgroundColor = UIColorFromHEX(0x0182eb, 1);
                self.firstView.numberView.image = [UIImage imageNamed:@"icon-n-1"];
                self.firstView.titleLabel.textColor = UIColorFromHEX(0x0182eb, 1);
            }
        }
            break;
            
        case BATFamilyDoctorOrderWaitAccept:
        {
            self.firstView.leftLine.hidden = YES;
            self.firstView.rightLine.hidden = NO;
            self.firstView.leftLine.backgroundColor = UIColorFromHEX(0x0182eb, 1);
            self.firstView.rightLine.backgroundColor = UIColorFromHEX(0x0182eb, 1);
            self.firstView.numberView.image = [UIImage imageNamed:@"icon-n-1"];
            self.firstView.titleLabel.textColor = UIColorFromHEX(0x0182eb, 1);
            
        }
            break;
        case BATFamilyDoctorOrderWaitPay:
        {
            self.firstView.leftLine.hidden = YES;
            self.firstView.rightLine.hidden = NO;
            self.firstView.leftLine.backgroundColor = UIColorFromHEX(0x0182eb, 1);
            self.firstView.rightLine.backgroundColor = UIColorFromHEX(0x0182eb, 1);
            self.firstView.numberView.image = [UIImage imageNamed:@"icon-n-1"];
            self.firstView.titleLabel.textColor = UIColorFromHEX(0x0182eb, 1);
            
            self.secondView.leftLine.hidden = NO;
            self.secondView.rightLine.hidden = NO;
            self.secondView.leftLine.backgroundColor = UIColorFromHEX(0x0182eb, 1);
            self.secondView.rightLine.backgroundColor = UIColorFromHEX(0x0182eb, 1);
            self.secondView.numberView.image = [UIImage imageNamed:@"icon-n-2"];
            self.secondView.titleLabel.textColor = UIColorFromHEX(0x0182eb, 1);
        }
            break;
        case BATFamilyDoctorOrderFinish:
        {
            self.firstView.leftLine.hidden = YES;
            self.firstView.rightLine.hidden = NO;
            self.firstView.leftLine.backgroundColor = UIColorFromHEX(0x0182eb, 1);
            self.firstView.rightLine.backgroundColor = UIColorFromHEX(0x0182eb, 1);
            self.firstView.numberView.image = [UIImage imageNamed:@"icon-n-1"];
            self.firstView.titleLabel.textColor = UIColorFromHEX(0x0182eb, 1);
            
            self.secondView.leftLine.hidden = NO;
            self.secondView.rightLine.hidden = NO;
            self.secondView.leftLine.backgroundColor = UIColorFromHEX(0x0182eb, 1);
            self.secondView.rightLine.backgroundColor = UIColorFromHEX(0x0182eb, 1);
            self.secondView.numberView.image = [UIImage imageNamed:@"icon-n-2"];
            self.secondView.titleLabel.textColor = UIColorFromHEX(0x0182eb, 1);
            
            self.thirdView.leftLine.hidden = NO;
            self.thirdView.rightLine.hidden = NO;
            self.thirdView.leftLine.backgroundColor = UIColorFromHEX(0x0182eb, 1);
            self.thirdView.rightLine.backgroundColor = UIColorFromHEX(0x0182eb, 1);
            self.thirdView.numberView.image = [UIImage imageNamed:@"icon-n-3"];
            self.thirdView.titleLabel.textColor = UIColorFromHEX(0x0182eb, 1);
            
            self.fourView.leftLine.hidden = NO;
            self.fourView.rightLine.hidden = NO;
            self.fourView.leftLine.backgroundColor = UIColorFromHEX(0x0182eb, 1);
            self.fourView.rightLine.backgroundColor = UIColorFromHEX(0x0182eb, 1);
            self.fourView.numberView.image = [UIImage imageNamed:@"icon-n-4"];
            self.fourView.titleLabel.textColor = UIColorFromHEX(0x0182eb, 1);
            
            //已经评论
            if (isComment == YES) {
                self.fiveView.leftLine.hidden = NO;
                self.fiveView.rightLine.hidden = YES;
                self.fiveView.leftLine.backgroundColor = UIColorFromHEX(0x0182eb, 1);
                self.fiveView.rightLine.backgroundColor = UIColorFromHEX(0x0182eb, 1);
                self.fiveView.numberView.image = [UIImage imageNamed:@"icon-n-5"];
                self.fiveView.titleLabel.textColor = UIColorFromHEX(0x0182eb, 1);
            }
        }
            break;
        case BATFamilyDoctorOrderHavePay:
        {
            
            self.firstView.leftLine.hidden = YES;
            self.firstView.rightLine.hidden = NO;
            self.firstView.leftLine.backgroundColor = UIColorFromHEX(0x0182eb, 1);
            self.firstView.rightLine.backgroundColor = UIColorFromHEX(0x0182eb, 1);
            self.firstView.numberView.image = [UIImage imageNamed:@"icon-n-1"];
            self.firstView.titleLabel.textColor = UIColorFromHEX(0x0182eb, 1);
            
            self.secondView.leftLine.hidden = NO;
            self.secondView.rightLine.hidden = NO;
            self.secondView.leftLine.backgroundColor = UIColorFromHEX(0x0182eb, 1);
            self.secondView.rightLine.backgroundColor = UIColorFromHEX(0x0182eb, 1);
            self.secondView.numberView.image = [UIImage imageNamed:@"icon-n-2"];
            self.secondView.titleLabel.textColor = UIColorFromHEX(0x0182eb, 1);
            
            self.thirdView.leftLine.hidden = NO;
            self.thirdView.rightLine.hidden = NO;
            self.thirdView.leftLine.backgroundColor = UIColorFromHEX(0x0182eb, 1);
            self.thirdView.rightLine.backgroundColor = UIColorFromHEX(0x0182eb, 1);
            self.thirdView.numberView.image = [UIImage imageNamed:@"icon-n-3"];
            self.thirdView.titleLabel.textColor = UIColorFromHEX(0x0182eb, 1);
            
            self.fourView.leftLine.hidden = NO;
            self.fourView.rightLine.hidden = NO;
            self.fourView.leftLine.backgroundColor = UIColorFromHEX(0x0182eb, 1);
            self.fourView.rightLine.backgroundColor = UIColorFromHEX(0x0182eb, 1);
            self.fourView.numberView.image = [UIImage imageNamed:@"icon-n-4"];
            self.fourView.titleLabel.textColor = UIColorFromHEX(0x0182eb, 1);
        }
            break;
        case BATFamilyDoctorOrderPaySuccess:
        {
            
            self.firstView.leftLine.hidden = YES;
            self.firstView.rightLine.hidden = NO;
            self.firstView.leftLine.backgroundColor = UIColorFromHEX(0x0182eb, 1);
            self.firstView.rightLine.backgroundColor = UIColorFromHEX(0x0182eb, 1);
            self.firstView.numberView.image = [UIImage imageNamed:@"icon-n-1"];
            self.firstView.titleLabel.textColor = UIColorFromHEX(0x0182eb, 1);
            
            self.secondView.leftLine.hidden = NO;
            self.secondView.rightLine.hidden = NO;
            self.secondView.leftLine.backgroundColor = UIColorFromHEX(0x0182eb, 1);
            self.secondView.rightLine.backgroundColor = UIColorFromHEX(0x0182eb, 1);
            self.secondView.numberView.image = [UIImage imageNamed:@"icon-n-2"];
            self.secondView.titleLabel.textColor = UIColorFromHEX(0x0182eb, 1);
            
            self.thirdView.leftLine.hidden = NO;
            self.thirdView.rightLine.hidden = NO;
            self.thirdView.leftLine.backgroundColor = UIColorFromHEX(0x0182eb, 1);
            self.thirdView.rightLine.backgroundColor = UIColorFromHEX(0x0182eb, 1);
            self.thirdView.numberView.image = [UIImage imageNamed:@"icon-n-3"];
            self.thirdView.titleLabel.textColor = UIColorFromHEX(0x0182eb, 1);
        
        }
            break;
        default:
            break;
    }
    
}


- (BATFamilyDoctorOrderDetailNumberView *)firstView{
    if (!_firstView) {
        _firstView = [[BATFamilyDoctorOrderDetailNumberView alloc] init];
        _firstView.leftLine.hidden = YES;
        _firstView.numberView.image = [UIImage imageNamed:@"icon-p-1"];
        _firstView.titleLabel.text = @"提交订单";
    }
    return _firstView;
}

- (BATFamilyDoctorOrderDetailNumberView *)secondView{
    if (!_secondView) {
        _secondView = [[BATFamilyDoctorOrderDetailNumberView alloc] init];
        _secondView.numberView.image = [UIImage imageNamed:@"icon-p-2"];
        _secondView.titleLabel.text = @"医生接单";
    }
    return _secondView;
}

- (BATFamilyDoctorOrderDetailNumberView *)thirdView{
    if (!_thirdView) {
        _thirdView = [[BATFamilyDoctorOrderDetailNumberView alloc] init];
        _thirdView.numberView.image = [UIImage imageNamed:@"icon-p-3"];
        _thirdView.titleLabel.text = @"完成支付";
    }
    return _thirdView;
}

- (BATFamilyDoctorOrderDetailNumberView *)fourView{
    if (!_fourView) {
        _fourView = [[BATFamilyDoctorOrderDetailNumberView alloc] init];
        _fourView.numberView.image = [UIImage imageNamed:@"icon-p-4"];
        _fourView.titleLabel.text = @"服务期";
    }
    return _fourView;
}

- (BATFamilyDoctorOrderDetailNumberView *)fiveView{
    if (!_fiveView) {
        _fiveView = [[BATFamilyDoctorOrderDetailNumberView alloc] init];
        _fiveView.numberView.image = [UIImage imageNamed:@"icon-p-5"];
        _fiveView.rightLine.hidden = YES;
        _fiveView.titleLabel.text = @"评价";
    }
    return _fiveView;
}

@end
