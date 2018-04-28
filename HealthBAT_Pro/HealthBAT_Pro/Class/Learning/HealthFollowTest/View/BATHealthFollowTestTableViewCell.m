//
//  BATHealthFollowTestTableViewCell.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/2/27.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHealthFollowTestTableViewCell.h"

@interface BATHealthFollowTestTableViewCell ()

@property (nonatomic,strong) NSIndexPath *indexPath;

@property (nonatomic,strong) BATQuestion *question;

@end

@implementation BATHealthFollowTestTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
        
        [self pageLayout];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Action
- (void)yesButtonAction:(UIButton *)button
{
    self.noButton.selected = NO;
    button.selected = !button.selected;
    
    [self changeAnswer:button.tag value:button.selected];
}

- (void)noButtonAction:(UIButton *)button
{
    self.yesButton.selected = NO;
    button.selected = !button.selected;
    
    [self changeAnswer:button.tag value:button.selected];
}

- (void)changeAnswer:(NSInteger)index value:(BOOL)value
{
    for (int i = 0; i < self.question.QuestionItemLst.count; i++) {
        BATQuestionAnswerItem *anserItem = self.question.QuestionItemLst[i];
        
        if (i == index) {
            anserItem.isSelect = value;
        } else {
            anserItem.isSelect = NO;
        }

    }
    if (index == 0) {
        [_noButton setGradientColors:@[UIColorFromHEX(0X666666, 1)]];
        if (value) {
            [_yesButton setGradientColors:@[START_COLOR,END_COLOR]];
        }else {
            [_yesButton setGradientColors:@[UIColorFromHEX(0X666666, 1)]];
        }
        
    }
    
    if (index == 1) {
        [_yesButton setGradientColors:@[UIColorFromHEX(0X666666, 1)]];
        if (value) {
            [_noButton setGradientColors:@[START_COLOR,END_COLOR]];
        }else {
            [_noButton setGradientColors:@[UIColorFromHEX(0X666666, 1)]];
        }
       
    }
    
}


- (void)configData:(BATQuestion *)question indexPath:(NSIndexPath *)indexPath
{
    
    
    self.question = question;
    
    self.indexPath = indexPath;
    
    self.titleLabel.text = [NSString stringWithFormat:@"Q%ld %@",(long)indexPath.row + 1,question.Question];
    
    
    for (int i = 0; i < question.QuestionItemLst.count; i++) {
        BATQuestionAnswerItem *anserItem = question.QuestionItemLst[i];
        if (i == 0) {
            _yesButton.tag = 0;
            _yesButton.selected = anserItem.isSelect;
            if (anserItem.isSelect) {
                [_yesButton setGradientColors:@[START_COLOR,END_COLOR]];
            }else {
                [_yesButton setGradientColors:@[UIColorFromHEX(0X666666, 1)]];
            }
            [_yesButton setTitle:[NSString stringWithFormat:@"  %@",anserItem.Item] forState:UIControlStateNormal];
        } else if (i == 1) {
            _noButton.tag = 1;
            _noButton.selected = anserItem.isSelect;
            if (anserItem.isSelect) {
                [_noButton setGradientColors:@[START_COLOR,END_COLOR]];
            }else {
                [_noButton setGradientColors:@[UIColorFromHEX(0X666666, 1)]];
            }
            [_noButton setTitle:[NSString stringWithFormat:@"  %@",anserItem.Item] forState:UIControlStateNormal];
        }
    }
}

#pragma mark - pageLayout
- (void)pageLayout
{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.yesButton];
    [self.contentView addSubview:self.noButton];
    
    WEAK_SELF(self);
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.top.equalTo(self.contentView.mas_top).offset(32);
    }];
    
    [self.yesButton mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.contentView.mas_left).offset(30);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(80, 20));
    }];
    
    [self.noButton mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.yesButton.mas_right).offset(95);
        make.centerY.equalTo(self.yesButton.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
}

#pragma mark - get & set
- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = UIColorFromHEX(0x333333, 1);
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (BATGraditorButton *)yesButton
{
    if (_yesButton == nil) {
        _yesButton = [[BATGraditorButton alloc]init];
        _yesButton.enbleGraditor = YES;
        [_yesButton setImage:[UIImage imageNamed:@"rad-s"] forState:UIControlStateSelected];
        [_yesButton setImage:[UIImage imageNamed:@"rad-f"] forState:UIControlStateNormal];
      //  [_yesButton setTitleColor:UIColorFromHEX(0xff8c28, 1) forState:UIControlStateSelected];
        [_yesButton setTitleColor:UIColorFromHEX(0x666666, 1) forState:UIControlStateNormal];
        [_yesButton addTarget:self action:@selector(yesButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _yesButton.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _yesButton;
}


- (BATGraditorButton *)noButton
{
    if (_noButton == nil) {
        _noButton = [[BATGraditorButton alloc]init];
        _noButton.enbleGraditor = YES;
        [_noButton setTitle:@"  否" forState:UIControlStateNormal];
        [_noButton setImage:[UIImage imageNamed:@"rad-s"] forState:UIControlStateSelected];
        [_noButton setImage:[UIImage imageNamed:@"rad-f"] forState:UIControlStateNormal];
      //  [_noButton setTitleColor:UIColorFromHEX(0xff8c28, 1) forState:UIControlStateSelected];
        [_noButton setTitleColor:UIColorFromHEX(0x666666, 1) forState:UIControlStateNormal];
        [_noButton addTarget:self action:@selector(noButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _noButton.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _noButton;
}

@end
