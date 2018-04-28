//
//  BATHealthThreeSecondsFoodEnterAlertView.m
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/12/12.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHealthThreeSecondsFoodEnterAlertView.h"
#import "BATHealthThreeSecondsRecommedFoodListModel.h"

#define kTag 100

@interface BATHealthThreeSecondsFoodEnterAlertView ()
/** 弹窗主内容view */
@property (nonatomic,strong) UIView   *contentView;
/** message label */
//@property (nonatomic,strong) UILabel  *dateLabel;
/** 食物名称 */
@property (nonatomic,strong) UILabel  *nameLabel;
/** 卡路里 */
@property (nonatomic,strong) UILabel  *calorieLabel;
/** message label */
@property (nonatomic,strong) UILabel  *messageLabel;
/** 食物图片 */
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIButton *cancelButton;
@property (nonatomic,strong) UIButton *sureButton;
@property (nonatomic,strong) UIView *lineView1;
@property (nonatomic,strong) UIView *lineView2;

@end

@implementation BATHealthThreeSecondsFoodEnterAlertView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.messageLabel];
        [self.contentView addSubview:self.calorieLabel];
        [self.contentView addSubview:self.sureButton];
        [self.contentView addSubview:self.cancelButton];
        [self.contentView addSubview:self.lineView1];
        [self.contentView addSubview:self.lineView2];
    }
    return self;
}
#pragma mark - 设置数据
- (void)setRecommedFoodModel:(BATHealthThreeSecondsRecommedFoodListModel *)recommedFoodModel{
    _recommedFoodModel = recommedFoodModel;
    
    self.calorieLabel.text = [NSString stringWithFormat:@"%@卡路里",recommedFoodModel.HeatQty];
    self.nameLabel.text = recommedFoodModel.MenuName;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:recommedFoodModel.PictureURL] placeholderImage:[UIImage imageNamed:@"默认图"]];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismiss];
}
#pragma mark - action
/** 弹出此弹窗 */
- (void)show{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
}
#pragma mark - 移除此弹窗
/** 移除此弹窗 */
- (void)dismiss{
    [self removeFromSuperview];
}
- (void)sureButtonClick:(UIButton *)sureBtn{
    if (self.delegate && [self.delegate respondsToSelector:@selector(foodEnterAlertView:clickedButtonAtIndex:)]) {
        [self.delegate foodEnterAlertView:self clickedButtonAtIndex:sureBtn.tag-kTag];
    }
    [self dismiss];
}
- (void)cancelButtonClick:(UIButton *)cancelBtn{
    if (self.delegate && [self.delegate respondsToSelector:@selector(foodEnterAlertView:clickedButtonAtIndex:)]) {
        [self.delegate foodEnterAlertView:self clickedButtonAtIndex:cancelBtn.tag-kTag];
    }
    [self dismiss];
}


#pragma mark - layoutSubviews
- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-126, 173));
        make.centerY.mas_equalTo(self.mas_centerY);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
  
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.top.equalTo(@17);
        make.height.equalTo(@18);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
        make.top.mas_equalTo(self.messageLabel.mas_bottom).offset(13);
        make.width.equalTo(@80);
        make.height.equalTo(@60);
    }];
   
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imageView.mas_right).offset(20.5);
        make.top.mas_equalTo(self.messageLabel.mas_bottom).offset(22);
    }];
    
    [self.calorieLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_left);
       make.bottom.mas_equalTo(self.imageView.mas_bottom).offset(-10);
    }];

    //水平分割线
    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageView.mas_bottom).offset(15);
        make.height.equalTo(@1);
        make.left.right.mas_equalTo(self.contentView);
        
    }];
  
    //竖直分割线
    [self.lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.width.equalTo(@1);
        make.top.mas_equalTo(self.lineView1.mas_bottom);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        
    }];
    
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.top.mas_equalTo(self.lineView1.mas_bottom);
        make.right.mas_equalTo(self.lineView2.mas_left);

    }];
    
  
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.lineView2.mas_right);
        make.top.bottom.mas_equalTo(self.cancelButton);;
        make.right.mas_equalTo(self.contentView.mas_right);
    }];
    

}

#pragma mark - lazy load
- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc]init];
        _contentView.clipsToBounds = YES;
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 5;
    }
    return _contentView;
}
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.textColor = UIColorFromHEX(0x333333, 1);
        _nameLabel.backgroundColor = [UIColor whiteColor];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.text = @"张三";
    
    }
    return _nameLabel;
}

- (UILabel *)calorieLabel{
    if (!_calorieLabel) {
        _calorieLabel = [[UILabel alloc]init];
         _calorieLabel.font = [UIFont systemFontOfSize:14];
        _calorieLabel.textColor = UIColorFromHEX(0x999999, 1);
        _calorieLabel.textAlignment = NSTextAlignmentLeft;
        _calorieLabel.backgroundColor = [UIColor whiteColor];
        
        
    }
    return _calorieLabel;
}
- (UILabel *)messageLabel{
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc]init];
        _messageLabel.font = [UIFont boldSystemFontOfSize:16];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.text = @"确认添加该食物?";
    }
    return _messageLabel;
}
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.backgroundColor = [UIColor whiteColor];
    }
    return _imageView;
}
- (UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc]init];
        _cancelButton.backgroundColor = [UIColor whiteColor];
        [_cancelButton setTitleColor:UIColorFromHEX(0x999999, 1) forState:UIControlStateNormal];
        _cancelButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _cancelButton.tag = 100;
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}
- (UIButton *)sureButton{
    if (!_sureButton) {
        _sureButton = [[UIButton alloc]init];
        _sureButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _sureButton.tag =101;
        [_sureButton setTitleColor:UIColorFromHEX(0x507af8, 1) forState:UIControlStateNormal];
        _sureButton.backgroundColor = [UIColor whiteColor];
        [_sureButton setTitle:@"确认" forState:UIControlStateNormal];
        [_sureButton addTarget:self action:@selector(sureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}
- (UIView *)lineView1{
    if (!_lineView1) {
        _lineView1 = [[UIView alloc]init];
        _lineView1.backgroundColor = UIColorFromHEX(0xdcdcdc, 1);
    }
    return _lineView1;
}
- (UIView *)lineView2{
    if (!_lineView2) {
        _lineView2 = [[UIView alloc]init];
        _lineView2.backgroundColor = UIColorFromHEX(0xdcdcdc, 1);
    }
    return _lineView2;
}
@end
