//
//  BATListenTopicCell.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/3/20.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATListenTopicCell.h"

@implementation BATListenTopicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLb.textColor = UIColorFromHEX(0X333333, 1);
    self.titleLb.font = [UIFont systemFontOfSize:15];
    
    self.attendCountLb.textColor = UIColorFromHEX(0X999999, 1);
    self.attendCountLb.font = [UIFont systemFontOfSize:13];
    
    self.topicCountLb.font = [UIFont systemFontOfSize:13];
    self.topicCountLb.textColor = UIColorFromHEX(0X999999, 1);
    
    
    [self addSubview:self.attendBtn];
    [self.attendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(26);
        make.right.equalTo(self.mas_right).offset(-20);
        make.centerY.equalTo(self.headImage.mas_centerY);
        
    }];
    
   
    [self.attendBtn setBackgroundImage:[UIImage imageNamed:@"icon-jgz"] forState:UIControlStateNormal];
    [self.attendBtn setBackgroundImage:[UIImage imageNamed:@"icon-ygz-gray"] forState:UIControlStateSelected];
//    self.attendBtn.imageView.hidden = YES;
    
}


- (void)attendAction {
    
    if (self.attendBlock) {
        self.attendBlock(self.path);
    }
}

- (void)setListData:(HotTopicListData *)listData {

    _listData = listData;
    
    self.titleLb.text = listData.Topic;
    
    self.attendCountLb.text = [NSString stringWithFormat:@"%@关注",listData.FollowNum];
    
    self.topicCountLb.text = [NSString stringWithFormat:@"%@帖子",listData.PostNum];
    
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:listData.TopicImage]];
    
    self.attendBtn.selected = listData.IsTopicFollow;
    
//    if (listData.IsTopicFollow) {
//        [self.attendBtn setTitle:@"已关注" forState:UIControlStateNormal];
//        [self.attendBtn setTitleColor:BASE_COLOR forState:UIControlStateNormal];
//        self.attendBtn.layer.borderColor = BASE_COLOR.CGColor;
//        self.attendBtn.layer.borderWidth = 1;
//    }else {
//        [self.attendBtn setTitle:@"+ 关注" forState:UIControlStateNormal];
//        [self.attendBtn setTitleColor:UIColorFromHEX(0Xfc9f26, 1) forState:UIControlStateNormal];
//        self.attendBtn.layer.borderColor = UIColorFromHEX(0Xfc9f26, 1).CGColor;
//         self.attendBtn.layer.borderWidth = 1;
//    }
}

- (UIButton *)attendBtn {

    if (!_attendBtn) {
        _attendBtn = [[UIButton alloc]init];
        [_attendBtn addTarget:self action:@selector(attendAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _attendBtn;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
