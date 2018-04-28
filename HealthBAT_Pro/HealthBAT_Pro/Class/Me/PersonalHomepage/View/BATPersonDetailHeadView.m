//
//  BATPersonDetailHeadView.m
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/5/12.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATPersonDetailHeadView.h"
#import "BATPersonDetailModel.h"
#import "UIButton+TouchAreaInsets.h"

@interface BATPersonDetailHeadView ()
/** 关注 */
@property (weak, nonatomic) IBOutlet UILabel *focusLable;
/** 粉丝 */
@property (weak, nonatomic) IBOutlet UILabel *fanLabel;
/** 关注数按钮 */
@property (weak, nonatomic) IBOutlet UIButton *focusButton;
/** 背景 view */
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
/** 头像 */
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
/** 用户名 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/** 粉丝数按钮 */
@property (weak, nonatomic) IBOutlet UIButton *fanButton;
/** 分割线 */
@property (weak, nonatomic) IBOutlet UIView *separateView;


@end

@implementation BATPersonDetailHeadView


#pragma mark - iaitialize

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    self.focusLable.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:11];
    self.fanLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:11];
    self.focusButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:21];
    self.fanButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:21];
    self.iconImageView.layer.cornerRadius = 32.5;
    self.iconImageView.layer.masksToBounds = YES;
    self.bgImageView.userInteractionEnabled = YES;
    self.iconImageView.layer.borderWidth = 2.0f;
    self.iconImageView.layer.borderColor = [UIColor whiteColor].CGColor;

    //增大按钮触控范围
    self.focusButton.touchAreaInsets = UIEdgeInsetsMake(20, 20, 10, 10);
    self.fanButton.touchAreaInsets = UIEdgeInsetsMake(20, 10, 10, 10);
    
    self.iconImageView.userInteractionEnabled = YES;
    [self.iconImageView bk_whenTapped:^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(focusHeaderViewDidClick)]) {
            [self.delegate focusHeaderViewDidClick];
        }
    }];
    
}
#pragma mark - action

- (IBAction)focusButtonClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(focusCountButtonDidClick:)]) {
        [self.delegate focusCountButtonDidClick:sender];
    }
    
}
- (IBAction)fansButtonClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(fansCountButtonDidClick::)]) {
        [self.delegate fansCountButtonDidClick:sender :self.personModel];
    }
}


#pragma mark - setter
- (void)setPersonModel:(BATPersonDetailModel *)personModel{
    _personModel = personModel;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:personModel.PhotoPath] placeholderImage:[UIImage imageNamed:@"用户"]];
    
    self.nameLabel.text = personModel.UserName;
    
    [self setupButtonTitle:self.focusButton number:personModel.FollowNum placeholder:@"0"];
    [self setupButtonTitle:self.fanButton number:personModel.FansNum placeholder:@"0"];
    
}

- (void)setupButtonTitle:(UIButton *)button number:(NSInteger)number placeholder:(NSString *)placeholder
{
    if (number > 1000) {
        [button setTitle:[NSString stringWithFormat:@"%.1f千", number / 1000.0] forState:UIControlStateNormal];
    } else if (number > 0) {
        [button setTitle:[NSString stringWithFormat:@"%zd", number] forState:UIControlStateNormal];
    }else {
        [button setTitle:placeholder forState:UIControlStateNormal];
    }
}
@end
