//
//  BATBBSBottomView.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/2/21.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATBBSBottomView.h"
@interface BATBBSBottomView()
@property (nonatomic,strong) UIView *lineView;
@end
@implementation BATBBSBottomView

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.editButton];
        WEAK_SELF(self);
        [self.editButton mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.left.equalTo(self).offset(10);
            make.bottom.equalTo(self).offset(-10);
            make.width.mas_equalTo(SCREEN_WIDTH-20);
        }];
        
        [self addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self).offset(0);
            make.height.mas_equalTo(0.5);
        }];
        
    }
    return self;

}


- (UIButton *)editButton {
    
    if (!_editButton) {
        
        _editButton = [UIButton buttonWithType:UIButtonTypeCustom Title:@"写评论..." titleColor:UIColorFromHEX(0x666666, 1) backgroundColor:[UIColor whiteColor] backgroundImage:nil Font:[UIFont systemFontOfSize:12]];
        _editButton.layer.cornerRadius = 15;
        _editButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

        _editButton.layer.borderWidth = 0.5;
        _editButton.layer.borderColor = UIColorFromHEX(0xeeeeee, 1).CGColor;
        [_editButton setImage:[UIImage imageNamed:@"icon-tjpl"] forState:UIControlStateNormal];
        
        _editButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, -10);
        
        _editButton.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
        
//        _editButton.titleEdgeInsets =UIEdgeInsetsMake(0,
//                                          padding/2,
//                                          0,
//                                          -padding/2);
//        
//        imageEdgeInsets = UIEdgeInsetsMake(0,
//                                           -padding/2,
//                                           0,
//                                           padding/2);
        
        WEAK_SELF(self);
        [_editButton bk_whenTapped:^{
            STRONG_SELF(self);
            if (self.editBlock) {
                self.editBlock();
            }
        }];
    }
    return _editButton;
}

- (UIView *)lineView {

    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = UIColorFromHEX(0xeeeeee, 1);
    }
    return _lineView;
}


@end
