//
//  BATTopicSearchCell.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/3/14.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATTopicSearchCell.h"

@interface BATTopicSearchCell()

@property (nonatomic,strong) UIImageView *headImage;
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UIImageView *sexImage;
@property (nonatomic,strong) UIView *lineView;

@end

@implementation BATTopicSearchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        WEAK_SELF(self);
        
        [self.contentView addSubview:self.headImage];
        [self.headImage mas_makeConstraints:^(MASConstraintMaker *make) {
           
            STRONG_SELF(self);
            make.left.top.equalTo(self.contentView).offset(10);
            make.size.mas_equalTo(CGSizeMake(30, 30));
            
        }];
        
        [self.contentView addSubview:self.titleLb];
        [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
           
            STRONG_SELF(self);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.headImage.mas_right).offset(15);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            
        }];
        
        [self.contentView addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            STRONG_SELF(self);
            make.left.bottom.right.equalTo(self.contentView).offset(0);
            make.height.mas_equalTo(1);
        }];
    }
    return self;
}

- (void)setModel:(TopicSearchContent *)model {

    _model = model;
    WEAK_SELF(self);
    
    if ([model.resultType isEqualToString:@"account_info"]) {
        
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.photoPath] placeholderImage:[UIImage imageNamed:@"icon_login_logo"]];
        
        [self.titleLb mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            STRONG_SELF(self);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.headImage.mas_right).offset(15);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            
        }];
        
        [self.headImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            STRONG_SELF(self);
            make.left.top.equalTo(self.contentView).offset(10);
            make.size.mas_equalTo(CGSizeMake(30, 30));
            
        }];

    }else if([model.resultType isEqualToString:@"topic_info"]) {
        
         [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.topicImage] placeholderImage:[UIImage imageNamed:@"icon_login_logo"]];
        
        [self.titleLb mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            STRONG_SELF(self);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.headImage.mas_right).offset(15);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            
        }];
        
        [self.headImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            STRONG_SELF(self);
            make.left.top.equalTo(self.contentView).offset(10);
            make.size.mas_equalTo(CGSizeMake(30, 30));
            
        }];
        
    }else {
        
        
        [self.headImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            
        }];
        
        [self.titleLb mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView).offset(15);
            
        }];
    }
     self.titleLb.text = model.resultTitle;
    
    [self.contentView layoutIfNeeded];
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
        _titleLb.font = [UIFont systemFontOfSize:15];
        _titleLb.textColor = UIColorFromHEX(0x333333, 1);
    }
    return _titleLb;
}

- (UIImageView *)sexImage {

    if (!_sexImage) {
        _sexImage = [[UIImageView alloc]init];
    }
    return _sexImage;
}

- (UIView *)lineView {

    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = BASE_BACKGROUND_COLOR;
    }
    return _lineView;
}

@end
