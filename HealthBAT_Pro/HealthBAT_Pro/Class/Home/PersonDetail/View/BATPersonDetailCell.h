//
//  BATPersonDetailCell.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/3/17.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATTopicPersonModel.h"

@interface BATPersonDetailCell : UITableViewCell
//动态数量
@property (weak, nonatomic) IBOutlet UILabel *dymaicCount;
//关注的话题数量
@property (weak, nonatomic) IBOutlet UILabel *attentTopicCount;
//关注的人的数量
@property (weak, nonatomic) IBOutlet UILabel *attendPersonCount;
//粉丝数量
@property (weak, nonatomic) IBOutlet UILabel *fansCount;


@property (weak, nonatomic) IBOutlet UILabel *dymaicTitle;

@property (weak, nonatomic) IBOutlet UILabel *attentTopicTitle;
@property (weak, nonatomic) IBOutlet UILabel *attendPersonTitle;
@property (weak, nonatomic) IBOutlet UILabel *fansTitle;

@property (weak, nonatomic) IBOutlet UIView *dymaicView;
@property (weak, nonatomic) IBOutlet UIView *attentView;
@property (weak, nonatomic) IBOutlet UIView *attendPersonView;
@property (weak, nonatomic) IBOutlet UIView *fansView;


@property (nonatomic,strong) BATTopicPersonModel *model;

@property (nonatomic,strong) void (^ChangeScrollView)(NSInteger tag);

@end
