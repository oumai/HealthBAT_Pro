//
//  BATHomeHealthyCommunityCell.m
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/11/2.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHomeHealthyCommunityCell.h"
#import "BATHomeHealthyCommunityCommonView.h"

@interface BATHomeHealthyCommunityCell ()
/** 跟我一样 */
@property (nonatomic, strong) BATHomeHealthyCommunityCommonView *sameMeItem;
/** 发现 */
@property (nonatomic, strong) BATHomeHealthyCommunityCommonView *findItem;
/** 饮食指南 */
@property (nonatomic, strong) BATHomeHealthyCommunityCommonView *gietGuildeItem;

/** 水平分割线 */
@property (nonatomic, strong) UIView *levelSeparatorView;
/** 竖直分割线 */
@property (nonatomic, strong) UIView *verticalSeparatorView;


@end

@implementation BATHomeHealthyCommunityCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
         self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.sameMeItem];
        [self.contentView addSubview:self.findItem];
        [self.contentView addSubview:self.gietGuildeItem];
        [self.contentView addSubview:self.levelSeparatorView];
        [self.contentView addSubview:self.verticalSeparatorView];
        
    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.gietGuildeItem mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.bottom.left.mas_equalTo(0);
        make.right.mas_equalTo(self.mas_centerX).offset(0.5);

    }];
    
    //垂直分割线
    [self.verticalSeparatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(self.gietGuildeItem.mas_right);
        make.width.mas_equalTo(0.5);
    }];
    
    //发现
    [self.findItem mas_makeConstraints:^(MASConstraintMaker *make) {
        
        
        make.right.top.mas_equalTo(0);
        make.left.mas_equalTo(self.verticalSeparatorView.mas_right);
    make.bottom.mas_equalTo(self.mas_centerY).offset(-0.25);
    }];
    
    //水平分割线
    [self.levelSeparatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.verticalSeparatorView.mas_right);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];


    //和我一样
    
    [self.sameMeItem mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.verticalSeparatorView.mas_right);
        make.top.mas_equalTo(self.findItem.mas_bottom).offset(0.25);
        make.bottom.mas_equalTo(0);
    }];
    
  
   
    
}

- (BATHomeHealthyCommunityCommonView *)findItem{
    if (!_findItem) {
        _findItem = [[BATHomeHealthyCommunityCommonView alloc]init];
        _findItem.titleLabel.text = @"发现";
        _findItem.descLabel.text = @"找感兴趣的东西";
        _findItem.rightImageView.image = [UIImage imageNamed:@"img-fx"];
        [_findItem bk_whenTapped:^{
            if (self.findItemBlock) {
                self.findItemBlock();
            }
        }];
    }
    return _findItem;
}
- (BATHomeHealthyCommunityCommonView *)sameMeItem{
    if (!_sameMeItem) {
        _sameMeItem = [[BATHomeHealthyCommunityCommonView alloc]init];
        _sameMeItem.titleLabel.text = @"跟我一样";
        _sameMeItem.descLabel.text = @"找志同道合的人";
        _sameMeItem.rightImageView.image = [UIImage imageNamed:@"img-gwyy"];
        [_sameMeItem bk_whenTapped:^{
            if (self.sameMeItemBlcok) {
                self.sameMeItemBlcok();
            }
        }];
    }
    return _sameMeItem;
}

- (BATHomeHealthyCommunityCommonView *)gietGuildeItem{
    if (!_gietGuildeItem) {
        _gietGuildeItem = [[BATHomeHealthyCommunityCommonView alloc]init];
        _gietGuildeItem.titleLabel.text = @"发吃货圈";
        _gietGuildeItem.descLabel.text = @"逛逛逛吃吃吃";
        _gietGuildeItem.rightImageView.image = [UIImage imageNamed:@"Home_Healthy_Community_DietGuide"];
        [_gietGuildeItem bk_whenTapped:^{
            if (self.gietGuildeItemBlock) {
                self.gietGuildeItemBlock();
            }
        }];
    }
    return _gietGuildeItem;
}
- (UIView *)levelSeparatorView{
    if (!_levelSeparatorView) {
        _levelSeparatorView = [[UIView alloc]init];
        _levelSeparatorView.backgroundColor = BASE_LINECOLOR;
    }
    return _levelSeparatorView;
}
- (UIView *)verticalSeparatorView{
    if (!_verticalSeparatorView) {
        _verticalSeparatorView = [[UIView alloc]init];
        _verticalSeparatorView.backgroundColor = BASE_LINECOLOR;
    }
    return _verticalSeparatorView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
