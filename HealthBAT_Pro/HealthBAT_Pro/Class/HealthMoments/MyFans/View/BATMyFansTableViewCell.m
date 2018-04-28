//
//  BATMyFansTableViewCell.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/30.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATMyFansTableViewCell.h"
#import "BATHotTopicListModel.h"
#import "BATLoginModel.h"
#import "BATMyFansModel.h"
@implementation BATMyFansTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _avatarImageView.layer.cornerRadius = _avatarImageView.frame.size.height / 2;
    _avatarImageView.layer.masksToBounds = YES;
    
//    _followButton.layer.masksToBounds = YES;
//    _followButton.layer.cornerRadius = 5.0;
//    _followButton.layer.borderColor = BASE_COLOR.CGColor;
//    _followButton.layer.borderWidth = 1.0;
  //  _followButton.layer.masksToBounds = YES;
  //  _followButton.layer.cornerRadius = 3.0;
  //  _followButton.layer.borderColor = UIColorFromHEX(0xfc9f26, 1).CGColor;
  //  [_followButton setTitleColor:UIColorFromHEX(0xfc9f26, 1) forState:UIControlStateNormal];
  //  _followButton.layer.borderWidth = 1.0;
    [_followButton setBackgroundImage:[UIImage imageNamed:@"icon-jgz"] forState:UIControlStateNormal];
    [_followButton setBackgroundImage:[UIImage imageNamed:@"icon-ygz-gray"] forState:UIControlStateSelected];
    [_followButton addTarget:self action:@selector(followButton:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)configrationEachAttendCell:(id)model
{
    BATMyFansData *myFansData = (BATMyFansData *)model;
    
    if ([myFansData.PhotoPath hasPrefix:@"http://"]) {
        [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:myFansData.PhotoPath] placeholderImage:[UIImage imageNamed:@"用户"]];
    } else {
        [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",APP_WEB_DOMAIN_URL,myFansData.PhotoPath]] placeholderImage:[UIImage imageNamed:@"用户"]];
    }
    
    
    _userNameLabel.text = myFansData.UserName;
    
    //_signatureLabel.text = myFansData.Signature.length > 0 ? myFansData.Signature : @"这个家伙很懒，什么都没有留下。";
    
    
    
    _sexImageView.image = myFansData.Sex == 1 ? [UIImage imageNamed:@"icon_sex_man"] : [UIImage imageNamed:@"icon_sex_girl"];
    
    //  [_followButton setTitle:(myFansData.IsUserFollow ? @"已关注" : @"+ 关注") forState:UIControlStateNormal];
//    _followButton.selected = myFansData.IsUserFollow;
  
    
    if (myFansData.IsAttned) {
        
        if (!myFansData.IsUserFollow) {
            [_followButton setBackgroundImage:[UIImage imageNamed:@"icon-ygz-gray"] forState:UIControlStateNormal];
            
        }else {
            [_followButton setBackgroundImage:[UIImage imageNamed:@"icon-xhgz"] forState:UIControlStateNormal];
            
        }
    }else {
        [_followButton setBackgroundImage:[UIImage imageNamed:@"icon-jgz"] forState:UIControlStateNormal];
    }

    
    if (myFansData.IsShowBtn) {
        _followButton.hidden = NO;
    } else {
        _followButton.hidden = YES;
    }

}

- (void)configrationFansCell:(id)model
{
    BATMyFansData *myFansData = (BATMyFansData *)model;
    
    if ([myFansData.PhotoPath hasPrefix:@"http://"]) {
        [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:myFansData.PhotoPath] placeholderImage:[UIImage imageNamed:@"用户"]];
    } else {
        [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",APP_WEB_DOMAIN_URL,myFansData.PhotoPath]] placeholderImage:[UIImage imageNamed:@"用户"]];
    }
    
    
    _userNameLabel.text = myFansData.UserName;
    
     //_signatureLabel.text = myFansData.Signature.length > 0 ? myFansData.Signature : @"这个家伙很懒，什么都没有留下。";
    
    
    
    _sexImageView.image = myFansData.Sex == 1 ? [UIImage imageNamed:@"icon_sex_man"] : [UIImage imageNamed:@"icon_sex_girl"];
    
  //  [_followButton setTitle:(myFansData.IsUserFollow ? @"已关注" : @"+ 关注") forState:UIControlStateNormal];
    _followButton.selected = myFansData.IsUserFollow;
    
    /*
    if (!myFansData.IsUserFollow) {
        _followButton.layer.borderColor = UIColorFromHEX(0xfc9f26, 1).CGColor;
        [_followButton setTitleColor:UIColorFromHEX(0xfc9f26, 1) forState:UIControlStateNormal];
    }else {
        _followButton.layer.borderColor = BASE_COLOR.CGColor;
        [_followButton setTitleColor:BASE_COLOR forState:UIControlStateNormal];
    }*/
    
    
    if (myFansData.IsShowBtn) {
        _followButton.hidden = NO;
    } else {
        _followButton.hidden = YES;
    }
    
}


- (void)configrationCell:(id)model
{
    HotTopicListData *myFansData = (HotTopicListData *)model;
    
    if ([myFansData.TopicImage hasPrefix:@"http://"]) {
        [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:myFansData.TopicImage] placeholderImage:[UIImage imageNamed:@"用户"]];
    } else {
        [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",APP_WEB_DOMAIN_URL,myFansData.TopicImage]] placeholderImage:[UIImage imageNamed:@"用户"]];
    }
    
    
    _userNameLabel.text = myFansData.Topic;
    
 //   _signatureLabel.text = myFansData.Signature.length > 0 ? myFansData.Signature : @"这个家伙很懒，什么都没有留下。";
    

    
    //_sexImageView.image = myFansData.Sex == 1 ? [UIImage imageNamed:@"icon_sex_man"] : [UIImage imageNamed:@"icon_sex_girl"];
    
  //  [_followButton setTitle:(myFansData.IsTopicFollow ? @"已关注" : @"+ 关注") forState:UIControlStateNormal];
     _followButton.selected = myFansData.IsTopicFollow;
    
    /*
    if (!myFansData.IsTopicFollow) {
        _followButton.layer.borderColor = UIColorFromHEX(0xfc9f26, 1).CGColor;
        [_followButton setTitleColor:UIColorFromHEX(0xfc9f26, 1) forState:UIControlStateNormal];
    }else {
        _followButton.layer.borderColor = BASE_COLOR.CGColor;
        [_followButton setTitleColor:BASE_COLOR forState:UIControlStateNormal];
    }
    */
    if (myFansData.IsShowBtn) {
        _followButton.hidden = NO;
    } else {
        _followButton.hidden = YES;
    }
    
}

#pragma makr - Action

#pragma mark - 关注操作
- (void)followButton:(UIButton *)button
{
    if (self.followUser) {
        self.followUser();
    }
}

@end
