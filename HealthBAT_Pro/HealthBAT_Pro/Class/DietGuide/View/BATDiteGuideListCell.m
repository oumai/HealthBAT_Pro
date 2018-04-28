//
//  BATDiteGuideListCell.m
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/10/23.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDiteGuideListCell.h"
#import "UIColor+Gradient.h"
#import "BATDiteGuideListModel.h"

@interface BATDiteGuideListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *separateView;

@end

@implementation BATDiteGuideListCell
- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.separateView.backgroundColor = UIColorFromHEX(0xdcdcdc, 1);
    self.iconImageView.layer.cornerRadius = 22.5*0.5;
    self.iconImageView.layer.masksToBounds = YES;
    self.descLabel.textColor = UIColorFromHEX(0x333333, 1);
    self.descLabel.font = [UIFont systemFontOfSize:12];
    self.nameLabel.textColor = UIColorFromHEX(0x888888, 1);
    self.nameLabel.font = [UIFont systemFontOfSize:12];
    
    self.likeButton.titleLabel.font = [UIFont systemFontOfSize:12];
    
    UIColor *selColor = [UIColor gradientFromColor:START_COLOR toColor:END_COLOR withHeight:12];
    [self.likeButton setTitleColor:selColor forState:UIControlStateSelected];
    [self.likeButton setTitleColor:UIColorFromHEX(0x000000, 1) forState:UIControlStateNormal];
    
    [self.likeButton addTarget:self action:@selector(likeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = UIColorFromHEX(0xdcdcdc, 1).CGColor;
    
    self.topImageView.contentMode = UIViewContentModeScaleAspectFill;
    
}
- (void)setDiteGuideListModel:(BATDiteGuideListModel *)diteGuideListModel{
    _diteGuideListModel = diteGuideListModel;

    self.nameLabel.text = diteGuideListModel.UserName;
    [self.likeButton setTitle:[NSString stringWithFormat:@"%ld",(long)diteGuideListModel.SetStarNum] forState:UIControlStateNormal];
    [self.likeButton setTitle:[NSString stringWithFormat:@"%ld",(long)diteGuideListModel.SetStarNum] forState:UIControlStateSelected];
    
    self.likeButton.selected = diteGuideListModel.IsSetStar;
    
    [self.topImageView sd_setImageWithURL:[NSURL URLWithString:diteGuideListModel.FoodPic] placeholderImage:[UIImage imageNamed:@"默认图"]];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:diteGuideListModel.UserPhoto] placeholderImage:[UIImage imageNamed:@"userIcon"]];
    

    //设置描述内容
    NSMutableDictionary *attributeDictM = [NSMutableDictionary dictionary];
    NSString *formatStr = [NSString stringWithFormat:@"#%@#%@",diteGuideListModel.FoodLable,diteGuideListModel.FoodName];
    attributeDictM[NSForegroundColorAttributeName] = UIColorFromHEX(0xfca907, 1);
    NSMutableAttributedString *attributeStrM = [[NSMutableAttributedString alloc]initWithString:formatStr attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    [attributeStrM addAttributes:attributeDictM range:NSMakeRange(0, diteGuideListModel.FoodLable.length+2)];
    self.descLabel.attributedText = attributeStrM;
    
}

- (void)likeButtonClick{

    if (self.likeButtonBlock) {
        self.likeButtonBlock(self.likeButton);
    }
    
}
@end
