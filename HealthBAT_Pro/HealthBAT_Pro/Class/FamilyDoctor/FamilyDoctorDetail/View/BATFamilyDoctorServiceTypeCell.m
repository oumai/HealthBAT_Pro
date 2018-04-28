//
//  BATFamilyDoctorServiceTypeCell.m
//  HealthBAT_Pro
//
//  Created by four on 2017/5/9.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATFamilyDoctorServiceTypeCell.h"

@implementation BATFamilyDoctorServiceTypeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        WEAK_SELF(self);
        [self.contentView addSubview:self.topView];
        [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.right.top.equalTo(self.contentView);
            make.height.mas_equalTo(45);
        }];
        
        [self.contentView addSubview:self.bottomView];
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.right.equalTo(self.topView);
            make.top.equalTo(self.topView.mas_bottom);
            make.height.mas_equalTo(45);
            make.bottom.equalTo(@0);
        }];
        
        [self.contentView addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.right.equalTo(self.topView);
            make.top.equalTo(self.topView.mas_bottom);
            make.height.mas_equalTo(0.5);
        }];
        
        [self.contentView addSubview:self.titleLable];
        [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerY.equalTo(self.topView.mas_centerY);
            make.left.equalTo(self.mas_left).offset(10);
        }];
        
        [self.contentView addSubview:self.subTitleLable];
        [self.subTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerY.equalTo(self.titleLable.mas_centerY);
            make.left.equalTo(self.titleLable.mas_right).offset(10);
        }];
        
        [self.contentView addSubview:self.scrollView];
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerY.equalTo(self.bottomView.mas_centerY);
            make.left.right.equalTo(self.contentView);
            make.height.mas_equalTo(45);
        }];
        
        [self.scrollView addSubview:self.textButton];
        [self.textButton mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerY.equalTo(self.scrollView.mas_centerY);
            make.left.equalTo(self.scrollView.mas_left).offset(0);
            make.width.mas_equalTo(90);
        }];
        
        
        [self.scrollView addSubview:self.audioButton];
        [self.audioButton mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerY.equalTo(self.scrollView.mas_centerY);
            make.left.equalTo(self.textButton.mas_right).offset(0);
            make.width.mas_equalTo(90);
        }];
        
        [self.scrollView addSubview:self.videoButton];
        [self.videoButton mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerY.equalTo(self.scrollView.mas_centerY);
            make.left.equalTo(self.audioButton.mas_right).offset(0);
            make.width.mas_equalTo(95);
        }];
        
        [self.scrollView addSubview:self.goHomeButton];
        [self.goHomeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerY.equalTo(self.scrollView.mas_centerY);
            make.left.equalTo(self.videoButton.mas_right).offset(0);
            make.width.mas_equalTo(90);
        }];
        
    }
    return self;
}

- (void)setCellWithModel:(BATFamilyDoctorModel *)familyDoctorModel{

    WEAK_SELF(self);
    
    NSString *familyServiceKey= [familyDoctorModel.Data.FamilyServiceKey stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    //1.视频 2.语音 3.图文 4.上门
     if (familyDoctorModel) {
         self.titleLable.text = @"家庭医生服务";
         self.subTitleLable.text = @"(服务期间内不限定咨询次数)";
         if ([familyServiceKey isEqualToString:@"1234"]) {
             self.textButton.hidden = NO;
             self.audioButton.hidden = NO;
             self.videoButton.hidden = NO;
             self.goHomeButton.hidden = NO;
             [self.textButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                 STRONG_SELF(self);
                 make.centerY.equalTo(self.scrollView.mas_centerY);
                 make.left.equalTo(self.scrollView.mas_left).offset(0);
                 make.width.mas_equalTo(90);
             }];
             
             [self.audioButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                 STRONG_SELF(self);
                 make.centerY.equalTo(self.scrollView.mas_centerY);
                 make.left.equalTo(self.scrollView.mas_left).offset(90);
                 make.width.mas_equalTo(90);
             }];
             
             [self.videoButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                 STRONG_SELF(self);
                 make.centerY.equalTo(self.scrollView.mas_centerY);
                 make.left.equalTo(self.scrollView.mas_left).offset(90*2);
                 make.width.mas_equalTo(95);
             }];
             
             [self.goHomeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                 STRONG_SELF(self);
                 make.centerY.equalTo(self.scrollView.mas_centerY);
                 make.left.equalTo(self.scrollView.mas_left).offset(90*3+5);
                 make.width.mas_equalTo(90);
             }];
         }else  if ([familyServiceKey isEqualToString:@"123"]){
             self.textButton.hidden = NO;
             self.audioButton.hidden = NO;
             self.videoButton.hidden = NO;
             self.goHomeButton.hidden = YES;
             [self.textButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                 STRONG_SELF(self);
                 make.centerY.equalTo(self.scrollView.mas_centerY);
                 make.left.equalTo(self.scrollView.mas_left).offset(0);
                 make.width.mas_equalTo(90);
             }];
             
             [self.audioButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                 STRONG_SELF(self);
                 make.centerY.equalTo(self.scrollView.mas_centerY);
                 make.left.equalTo(self.scrollView.mas_left).offset(90);
                 make.width.mas_equalTo(90);
             }];
             
             [self.videoButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                 STRONG_SELF(self);
                 make.centerY.equalTo(self.scrollView.mas_centerY);
                 make.left.equalTo(self.scrollView.mas_left).offset(90*2);
                 make.width.mas_equalTo(95);
             }];
         }else  if ([familyServiceKey isEqualToString:@"124"]){
             self.textButton.hidden = YES;
             self.audioButton.hidden = NO;
             self.videoButton.hidden = NO;
             self.goHomeButton.hidden = NO;
             [self.audioButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                 STRONG_SELF(self);
                 make.centerY.equalTo(self.scrollView.mas_centerY);
                 make.left.equalTo(self.scrollView.mas_left).offset(0);
                 make.width.mas_equalTo(90);
             }];
             
             [self.videoButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                 STRONG_SELF(self);
                 make.centerY.equalTo(self.scrollView.mas_centerY);
                 make.left.equalTo(self.scrollView.mas_left).offset(90);
                 make.width.mas_equalTo(90);
             }];
             
             [self.goHomeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                 STRONG_SELF(self);
                 make.centerY.equalTo(self.scrollView.mas_centerY);
                 make.left.equalTo(self.scrollView.mas_left).offset(90*2);
                 make.width.mas_equalTo(90);
             }];
             
         }else  if ([familyServiceKey isEqualToString:@"134"]){
             self.textButton.hidden = NO;
             self.audioButton.hidden = YES;
             self.videoButton.hidden = NO;
             self.goHomeButton.hidden = NO;
             [self.textButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                 STRONG_SELF(self);
                 make.centerY.equalTo(self.scrollView.mas_centerY);
                 make.left.equalTo(self.scrollView.mas_left).offset(0);
                 make.width.mas_equalTo(90);
             }];
             
             [self.videoButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                 STRONG_SELF(self);
                 make.centerY.equalTo(self.scrollView.mas_centerY);
                 make.left.equalTo(self.scrollView.mas_left).offset(90);
                 make.width.mas_equalTo(95);
             }];
             
             [self.goHomeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                 STRONG_SELF(self);
                 make.centerY.equalTo(self.scrollView.mas_centerY);
                 make.left.equalTo(self.scrollView.mas_left).offset(90*2);
                 make.width.mas_equalTo(90);
             }];
         }else  if ([familyServiceKey isEqualToString:@"234"]){
             self.textButton.hidden = NO;
             self.audioButton.hidden = NO;
             self.videoButton.hidden = YES;
             self.goHomeButton.hidden = NO;
             [self.textButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                 STRONG_SELF(self);
                 make.centerY.equalTo(self.scrollView.mas_centerY);
                 make.left.equalTo(self.scrollView.mas_left).offset(0);
                 make.width.mas_equalTo(90);
             }];
             
             [self.audioButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                 STRONG_SELF(self);
                 make.centerY.equalTo(self.scrollView.mas_centerY);
                 make.left.equalTo(self.scrollView.mas_left).offset(90);
                 make.width.mas_equalTo(95);
             }];
             
             [self.goHomeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                 STRONG_SELF(self);
                 make.centerY.equalTo(self.scrollView.mas_centerY);
                 make.left.equalTo(self.scrollView.mas_left).offset(90*2);
                 make.width.mas_equalTo(90);
             }];
         }else  if ([familyServiceKey isEqualToString:@"12"]){
             self.textButton.hidden = YES;
             self.audioButton.hidden = NO;
             self.videoButton.hidden = NO;
             self.goHomeButton.hidden = YES;
             [self.audioButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                 STRONG_SELF(self);
                 make.centerY.equalTo(self.scrollView.mas_centerY);
                 make.left.equalTo(self.scrollView.mas_left).offset(0);
                 make.width.mas_equalTo(90);
             }];
             
             [self.videoButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                 STRONG_SELF(self);
                 make.centerY.equalTo(self.scrollView.mas_centerY);
                 make.left.equalTo(self.scrollView.mas_left).offset(90);
                 make.width.mas_equalTo(90);
             }];
             
         }else  if ([familyServiceKey isEqualToString:@"13"]){
             self.textButton.hidden = NO;
             self.audioButton.hidden = YES;
             self.videoButton.hidden = NO;
             self.goHomeButton.hidden = YES;
             [self.textButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                 STRONG_SELF(self);
                 make.centerY.equalTo(self.scrollView.mas_centerY);
                 make.left.equalTo(self.scrollView.mas_left).offset(0);
                 make.width.mas_equalTo(90);
             }];
             
             [self.videoButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                 STRONG_SELF(self);
                 make.centerY.equalTo(self.scrollView.mas_centerY);
                 make.left.equalTo(self.scrollView.mas_left).offset(90);
                 make.width.mas_equalTo(95);
             }];
         }else  if ([familyServiceKey isEqualToString:@"14"]){
             self.textButton.hidden = YES;
             self.audioButton.hidden = YES;
             self.videoButton.hidden = NO;
             self.goHomeButton.hidden = NO;
             [self.videoButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                 STRONG_SELF(self);
                 make.centerY.equalTo(self.scrollView.mas_centerY);
                 make.left.equalTo(self.scrollView.mas_left).offset(0);
                 make.width.mas_equalTo(90);
             }];
             
             [self.goHomeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                 STRONG_SELF(self);
                 make.centerY.equalTo(self.scrollView.mas_centerY);
                 make.left.equalTo(self.scrollView.mas_left).offset(90);
                 make.width.mas_equalTo(90);
             }];
         }else  if ([familyServiceKey isEqualToString:@"23"]){
             self.textButton.hidden = NO;
             self.audioButton.hidden = NO;
             self.videoButton.hidden = YES;
             self.goHomeButton.hidden = YES;
             [self.textButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                 STRONG_SELF(self);
                 make.centerY.equalTo(self.scrollView.mas_centerY);
                 make.left.equalTo(self.scrollView.mas_left).offset(0);
                 make.width.mas_equalTo(90);
             }];
             
             [self.audioButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                 STRONG_SELF(self);
                 make.centerY.equalTo(self.scrollView.mas_centerY);
                 make.left.equalTo(self.scrollView.mas_left).offset(90);
                 make.width.mas_equalTo(95);
             }];
         }else  if ([familyServiceKey isEqualToString:@"24"]){
             self.textButton.hidden = YES;
             self.audioButton.hidden = NO;
             self.videoButton.hidden = YES;
             self.goHomeButton.hidden = NO;
             [self.audioButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                 STRONG_SELF(self);
                 make.centerY.equalTo(self.scrollView.mas_centerY);
                 make.left.equalTo(self.scrollView.mas_left).offset(0);
                 make.width.mas_equalTo(90);
             }];
             
             [self.goHomeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                 STRONG_SELF(self);
                 make.centerY.equalTo(self.scrollView.mas_centerY);
                 make.left.equalTo(self.scrollView.mas_left).offset(90);
                 make.width.mas_equalTo(90);
             }];
         }else  if ([familyServiceKey isEqualToString:@"34"]){
             self.textButton.hidden = NO;
             self.audioButton.hidden = YES;
             self.videoButton.hidden = YES;
             self.goHomeButton.hidden = NO;
             [self.textButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                 STRONG_SELF(self);
                 make.centerY.equalTo(self.scrollView.mas_centerY);
                 make.left.equalTo(self.scrollView.mas_left).offset(0);
                 make.width.mas_equalTo(95);
             }];
             
             [self.goHomeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                 STRONG_SELF(self);
                 make.centerY.equalTo(self.scrollView.mas_centerY);
                 make.left.equalTo(self.scrollView.mas_left).offset(90);
                 make.width.mas_equalTo(90);
             }];
         }else  if ([familyServiceKey isEqualToString:@"1"]){
            
             self.textButton.hidden = YES;
             self.audioButton.hidden = YES;
             self.videoButton.hidden = NO;
             self.goHomeButton.hidden = YES;
             [self.videoButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                 STRONG_SELF(self);
                 make.centerY.equalTo(self.scrollView.mas_centerY);
                 make.left.equalTo(self.scrollView.mas_left).offset(0);
                 make.width.mas_equalTo(90);
             }];
         }else  if ([familyServiceKey isEqualToString:@"2"]){
             self.textButton.hidden = YES;
             self.audioButton.hidden = NO;
             self.videoButton.hidden = YES;
             self.goHomeButton.hidden = YES;
             [self.audioButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                 STRONG_SELF(self);
                 make.centerY.equalTo(self.scrollView.mas_centerY);
                 make.left.equalTo(self.scrollView.mas_left).offset(0);
                 make.width.mas_equalTo(90);
             }];
         }else  if ([familyServiceKey isEqualToString:@"3"]){
             self.textButton.hidden = NO;
             self.audioButton.hidden = YES;
             self.videoButton.hidden = YES;
             self.goHomeButton.hidden = YES;
             [self.textButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                 STRONG_SELF(self);
                 make.centerY.equalTo(self.scrollView.mas_centerY);
                 make.left.equalTo(self.scrollView.mas_left).offset(0);
                 make.width.mas_equalTo(95);
             }];
         }else  if ([familyServiceKey isEqualToString:@"4"]){
             self.textButton.hidden = YES;
             self.audioButton.hidden = YES;
             self.videoButton.hidden = YES;
             self.goHomeButton.hidden = NO;
             [self.goHomeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                 STRONG_SELF(self);
                 make.centerY.equalTo(self.scrollView.mas_centerY);
                 make.left.equalTo(self.scrollView.mas_left).offset(0);
                 make.width.mas_equalTo(90);
             }];
         }
         
         if ([familyServiceKey isEqualToString:@"1234"]){
             self.scrollView.contentSize = CGSizeMake(365 + 20, 45);
         }else{
             self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 45);
         }
     }
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectZero];
        _lineView.backgroundColor = BASE_LINECOLOR;
    }
    return _lineView;
}

- (UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc]initWithFrame:CGRectZero];
    }
    return _topView;
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectZero];
    }
    return _bottomView;
}

- (UILabel *)titleLable{
    if (!_titleLable) {
        _titleLable = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:UIColorFromHEX(0x333333, 1) textAlignment:NSTextAlignmentLeft];
        _titleLable.numberOfLines = 0;
        [_titleLable sizeToFit];
    }
    
    return _titleLable;
}


- (UILabel *)subTitleLable{
    if (!_subTitleLable) {
        _subTitleLable = [UILabel labelWithFont:[UIFont systemFontOfSize:12] textColor:UIColorFromHEX(0x999999, 1) textAlignment:NSTextAlignmentLeft];
        _subTitleLable.numberOfLines = 0;
        _subTitleLable.hidden = NO;
        [_subTitleLable sizeToFit];
    }
    
    return _subTitleLable;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.contentSize = CGSizeMake(365+20, 45);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bounces = YES;
     }
    
    return _scrollView;
}

- (UIButton *)textButton{
    if (!_textButton) {
        _textButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_textButton setImage:[UIImage imageNamed:@"ic-FD-twzx"] forState:UIControlStateNormal];
        [_textButton setImage:[UIImage imageNamed:@"ic-FD-twzx"] forState:UIControlStateHighlighted];
        [_textButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _textButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [_textButton setTitle:@"图文咨询" forState:UIControlStateNormal];
        _textButton.backgroundColor = [UIColor whiteColor];
        //偏移20最佳
        _textButton.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        _textButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        _textButton.hidden = YES;
    }
    
    return _textButton;
}

- (UIButton *)audioButton{
    if (!_audioButton) {
        _audioButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_audioButton setImage:[UIImage imageNamed:@"ic-FD-Voice"] forState:UIControlStateNormal];
        [_audioButton setImage:[UIImage imageNamed:@"ic-FD-Voice"] forState:UIControlStateHighlighted];
        [_audioButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _audioButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [_audioButton setTitle:@"语音咨询" forState:UIControlStateNormal];
        //偏移20最佳
        _audioButton.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        _audioButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        _audioButton.hidden = YES;
    }
    
    return _audioButton;
}

- (UIButton *)videoButton{
    if (!_videoButton) {
        _videoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_videoButton setImage:[UIImage imageNamed:@"ic-FD-video"] forState:UIControlStateNormal];
        [_videoButton setImage:[UIImage imageNamed:@"ic-FD-video"] forState:UIControlStateHighlighted];
        [_videoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _videoButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [_videoButton setTitle:@"视频咨询" forState:UIControlStateNormal];
        //偏移20最佳
        _videoButton.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        _videoButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        _videoButton.hidden = YES;
    }
    
    return _videoButton;
}

- (UIButton *)goHomeButton{
    if (!_goHomeButton) {
        _goHomeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_goHomeButton setImage:[UIImage imageNamed:@"ic-FD-smfw"] forState:UIControlStateNormal];
        [_goHomeButton setImage:[UIImage imageNamed:@"ic-FD-smfw"] forState:UIControlStateHighlighted];
        [_goHomeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _goHomeButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [_goHomeButton setTitle:@"上门服务" forState:UIControlStateNormal];
        //偏移20最佳
        _goHomeButton.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        _goHomeButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        _goHomeButton.hidden = YES;
    }
    
    return _goHomeButton;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
