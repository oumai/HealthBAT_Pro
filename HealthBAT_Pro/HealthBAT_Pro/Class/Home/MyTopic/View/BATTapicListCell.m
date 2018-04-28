//
//  BATTapicListCell.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/3/14.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATTapicListCell.h"

@interface BATTapicListCell()
@property (nonatomic,strong) UIImageView *headImage;
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UILabel *TapicBtn;
@property (nonatomic,strong) UILabel *TapicCountBtn;
@property (nonatomic,strong) UIButton *attentBtn;
@end

@implementation BATTapicListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        WEAK_SELF(self);
        
        [self.contentView addSubview:self.headImage];
        [self.headImage mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            
            make.left.equalTo(self.contentView).offset(10);
            make.width.height.mas_equalTo(70);
            make.top.equalTo(self.contentView.mas_top).offset(15);
            
        }];
        
        [self.contentView addSubview:self.titleLb];
        [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
           
            STRONG_SELF(self);
            make.left.equalTo(self.headImage.mas_right).offset(10);
            make.top.equalTo(self.headImage.mas_top).offset(10);
            make.width.mas_equalTo(SCREEN_WIDTH - 90 - 78);
            
        }];
        
        [self.contentView addSubview:self.attentBtn];
        [self.attentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           
            STRONG_SELF(self);
            make.right.equalTo(self.contentView.mas_right).offset(-15);
            make.top.equalTo(self.contentView).offset(25);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(26);
            
        }];
        
        [self.contentView addSubview:self.TapicBtn];
        [self.TapicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           
            STRONG_SELF(self);
            make.left.equalTo(self.headImage.mas_right).offset(10);
            make.top.equalTo(self.titleLb.mas_bottom).offset(15);

            
        }];
        
        [self.contentView addSubview:self.TapicCountBtn];
        [self.TapicCountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           
            STRONG_SELF(self);
            make.left.equalTo(self.TapicBtn.mas_right).offset(20);
            make.centerY.equalTo(self.TapicBtn.mas_centerY);
            
        }];
        
        
        
    }
    return self;
}
- (void)setDetailModel:(BATTopicDetailModel *)detailModel {

    _detailModel = detailModel;
    
    self.titleLb.text = detailModel.Data.Topic;
    NSString *followNum = @"";
    NSString *postNum = @"";
    if (detailModel) {
        followNum = detailModel.Data.FollowNum;
        postNum = detailModel.Data.PostNum;
    }
    
    self.TapicBtn.text = [NSString stringWithFormat:@"%@关注",followNum];
    self.TapicCountBtn.text = [NSString stringWithFormat:@"%@帖子",postNum];
    

    self.attentBtn.selected = detailModel.Data.IsTopicFollow;
    
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:detailModel.Data.TopicImage] placeholderImage:nil];

}

- (void)setModel:(MyTopicListDataModel *)model {

    _model = model;
    
    self.titleLb.text = model.Topic;
    
    NSString *followNum = @"";
    NSString *postNum = @"";
    if (model) {
        followNum = model.FollowNum;
        postNum = model.PostNum;
    }
    self.TapicBtn.text = [NSString stringWithFormat:@"%@关注",followNum];
    self.TapicCountBtn.text = [NSString stringWithFormat:@"%@帖子",postNum];
    

    _attentBtn.selected = model.IsTopicFollow;


    [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.TopicImage] placeholderImage:nil];
}

- (void)attentAction:(UIButton *)sender {

    if ([self.delegate respondsToSelector:@selector(BATTapicListCellTopicAttenAction:row:)]) {
        
        [self.delegate BATTapicListCellTopicAttenAction:sender row:self.rowPath];
        
    }
    
}

#pragma mark - Lazy load
- (UIImageView *)headImage {

    if (!_headImage) {
        _headImage = [[UIImageView alloc]init];
    }
    return _headImage;
}

- (UILabel *)titleLb {

    if (!_titleLb) {
        _titleLb = [[UILabel alloc]init];
        _titleLb.textColor = UIColorFromHEX(0X333333, 1);
        _titleLb.font = [UIFont systemFontOfSize:15];
    }
    return _titleLb;
}

- (UIButton *)attentBtn {

    if (!_attentBtn) {
        _attentBtn = [[UIButton alloc]init];
        [_attentBtn setBackgroundImage:[UIImage imageNamed:@"icon-jgz"] forState:UIControlStateNormal];
        [_attentBtn setBackgroundImage:[UIImage imageNamed:@"icon-ygz-gray"] forState:UIControlStateSelected];
        [_attentBtn addTarget:self action:@selector(attentAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _attentBtn;
}

- (UILabel *)TapicBtn {

    if (!_TapicBtn) {
        _TapicBtn = [[UILabel alloc]init];
       
        _TapicBtn.textColor = UIColorFromHEX(0X999999, 1);
        _TapicBtn.font = [UIFont systemFontOfSize:12];
    }
    return _TapicBtn;
}

- (UILabel *)TapicCountBtn {

    if (!_TapicCountBtn) {
        _TapicCountBtn = [[UILabel alloc]init];
        _TapicCountBtn.textColor = UIColorFromHEX(0X999999, 1);
        _TapicCountBtn.font = [UIFont systemFontOfSize:12];
    }
    return _TapicCountBtn;
}

@end
