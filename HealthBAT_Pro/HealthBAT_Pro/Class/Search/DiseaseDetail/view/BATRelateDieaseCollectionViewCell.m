//
//  BATRelateDieaseCollectionViewCell.m
//  TableViewTest
//
//  Created by mac on 16/9/17.
//  Copyright © 2016年 sword. All rights reserved.
//

#import "BATRelateDieaseCollectionViewCell.h"

@implementation BATRelateDieaseCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
   
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
//        self.layer.borderColor = [UIColor clearColor].CGColor;
        self.layer.borderColor = BASE_LINECOLOR.CGColor;
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 5;
        
        [self.contentView addSubview:self.dieaseNameLb];
//        self.contentView.backgroundColor = [UIColor colorWithHue:((arc4random()+10) % 256 / 256.0 ) saturation:( (arc4random()+10) % 128 / 256.0 ) + 0.5
//                                         brightness:( (arc4random()+10) % 128 / 256.0 ) + 0.5 alpha:0.7];
        self.contentView.backgroundColor = BASE_BACKGROUND_COLOR;
        
        WEAK_SELF(self);
        [self.dieaseNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
        }];
    }
    return self;
}

-(UILabel *)dieaseNameLb{
    if (!_dieaseNameLb) {
        _dieaseNameLb = [[UILabel alloc]init];
        _dieaseNameLb.textColor = UIColorFromHEX(0X333333, 1);
        _dieaseNameLb.font = [UIFont systemFontOfSize:14];
    }
    return _dieaseNameLb;
}


@end
