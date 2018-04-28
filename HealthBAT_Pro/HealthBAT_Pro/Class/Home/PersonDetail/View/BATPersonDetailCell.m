//
//  BATPersonDetailCell.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/3/17.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATPersonDetailCell.h"

@interface BATPersonDetailCell()

@property (nonatomic,strong) UIView *lineView;

@end

@implementation BATPersonDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLineViewFrame:) name:@"PersonDetailMainScrollViewChange" object:nil];
    
    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 51, SCREEN_WIDTH/4, 1)];
    self.lineView.backgroundColor = BASE_COLOR;
    [self addSubview:self.lineView];
    
    self.dymaicCount.textColor = BASE_COLOR;
    self.attentTopicCount.textColor = BASE_COLOR;
    self.attendPersonCount.textColor = BASE_COLOR;
    self.fansCount.textColor = BASE_COLOR;
    
    self.dymaicTitle.textColor = UIColorFromHEX(0X333333, 1);
    self.attentTopicTitle.textColor = UIColorFromHEX(0X333333, 1);
    self.attendPersonTitle.textColor = UIColorFromHEX(0X333333, 1);
    self.fansTitle.textColor = UIColorFromHEX(0X333333, 1);
    
    for (int i = 0; i<4; i++) {
        UIView *verLineView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/4+i*(SCREEN_WIDTH/4), 10, 1, 36)];
        verLineView.backgroundColor = BASE_BACKGROUND_COLOR;
        [self addSubview:verLineView];
    }
    
    self.dymaicView.userInteractionEnabled = YES;
    self.attentView.userInteractionEnabled = YES;
    self.attendPersonView.userInteractionEnabled = YES;
    self.fansView.userInteractionEnabled = YES;
    
    
    UITapGestureRecognizer *OneTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeView:)];
    UITapGestureRecognizer *TwoTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeView:)];
    UITapGestureRecognizer *ThreeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeView:)];
    UITapGestureRecognizer *FourTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeView:)];
    
    [self.dymaicView addGestureRecognizer:OneTap];
    [self.attentView addGestureRecognizer:TwoTap];
    [self.attendPersonView addGestureRecognizer:ThreeTap];
    [self.fansView addGestureRecognizer:FourTap];
}

- (void)changeLineViewFrame:(NSNotification *)notice {

    NSInteger page = [notice.object[@"page"] integerValue];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.lineView.frame = CGRectMake(SCREEN_WIDTH/4 * page, 51, SCREEN_WIDTH/4, 1);
        
    }];
    
}

- (void)changeView:(UITapGestureRecognizer *)taper {

    NSInteger tag = taper.view.tag;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.lineView.frame = CGRectMake(SCREEN_WIDTH/4 * tag, 51, SCREEN_WIDTH/4, 1);
        
    }];
  
//    switch (tag) {
//        case 0: {
//            self.lineView.frame = CGRectMake(SCREEN_WIDTH/4 * tag, 39, SCREEN_WIDTH/4, 1);
//            break;
//        }
//        case 1: {
//             self.lineView.frame = CGRectMake(SCREEN_WIDTH/4 * tag, 39, SCREEN_WIDTH/4, 1);
//            break;
//        }
//        case 2: {
//             self.lineView.frame = CGRectMake(SCREEN_WIDTH/4 * tag, 39, SCREEN_WIDTH/4, 1);
//            break;
//        }
//        case 3: {
//             self.lineView.frame = CGRectMake(SCREEN_WIDTH/4 * tag, 39, SCREEN_WIDTH/4, 1);
//            break;
//        }
//        default:
//            break;
//    }
    NSLog(@"%zd",tag);
    if (self.ChangeScrollView) {
        self.ChangeScrollView(tag);
    }
}

- (void)setModel:(BATTopicPersonModel *)model {

    _model = model;
    
    self.dymaicCount.text = model.Data.PostNum;
    self.attentTopicCount.text = model.Data.TopicNum;
    self.attendPersonCount.text = model.Data.FollowNum;
    self.fansCount.text = model.Data.FansNum;
    
}

@end
