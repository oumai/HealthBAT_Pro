//
//  BATSingleRepeatCell.m
//  RecordTest
//
//  Created by kmcompany on 2017/3/15.
//  Copyright © 2017年 kmcompany. All rights reserved.
//

#import "BATSingleRepeatCell.h"
#import <AVFoundation/AVFoundation.h>
@interface BATSingleRepeatCell()
@end

@implementation BATSingleRepeatCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = BASE_BACKGROUND_COLOR;
        
        [self.contentView addSubview:self.nameLb];
        [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(self.contentView).offset(10);
            make.centerY.equalTo(self.contentView.mas_centerY);
            
        }];
        
        [self.contentView addSubview:self.btnContent];
        [self.btnContent mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(self.nameLb.mas_right).offset(5);
            make.size.mas_equalTo(CGSizeMake(100, 25));
            make.centerY.equalTo(self.contentView.mas_centerY);
            
        }];
        
        [self.contentView addSubview:self.timeNum];
        [self.timeNum mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(self.btnContent.mas_right).offset(10);
            make.centerY.equalTo(self.contentView.mas_centerY);
            
        }];
        
    }
    return self;
}

- (void)setModel:(secondReplyData *)model {

    _model = model;
    
    self.nameLb.text = [NSString stringWithFormat:@"%@:",model.UserName];
    self.timeNum.text = [NSString stringWithFormat:@"%@''",model.AudioLong];
    
}

#pragma mark - Action
//播放声音
- (void)btnContentClick {
    
    if ([self.delegate respondsToSelector:@selector(BATSingleRepeatCellPlayerWithURL:)]) {
        [self.delegate BATSingleRepeatCellPlayerWithURL:_model.AudioUrl];
    }
}

#pragma mark - Lazy Load
-(UILabel *)timeNum {

    if (!_timeNum) {
        _timeNum = [[UILabel alloc]init];
        _timeNum.textColor = UIColorFromHEX(0X333333, 1);
        _timeNum.font = [UIFont systemFontOfSize:15];
    }
    return _timeNum;
}
- (UILabel *)nameLb {

    if (!_nameLb) {
        _nameLb = [[UILabel alloc]init];
        _nameLb.font = [UIFont systemFontOfSize:13];
        _nameLb.textColor = UIColorFromHEX(0X666666, 1);
    }
    return _nameLb;
}

- (UUMessageContentButton *)btnContent {
    
    if (!_btnContent) {
        _btnContent = [UUMessageContentButton buttonWithType:UIButtonTypeCustom];
        [_btnContent setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _btnContent.titleLabel.numberOfLines = 0;
        [_btnContent addTarget:self action:@selector(btnContentClick)  forControlEvents:UIControlEventTouchUpInside];

        _btnContent.clipsToBounds = YES;
        _btnContent.backgroundColor = [UIColor whiteColor];
        _btnContent.layer.borderWidth = 1;
        _btnContent.layer.cornerRadius = 10;
        _btnContent.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [_btnContent setTitle:@"" forState:UIControlStateNormal];
        
    }
    return _btnContent;
}

@end
