//
//  BATInvitationContentCell.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/3/20.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATPhotoView.h"
#import "BATInvitationModel.h"
#import "BATCustomButton.h"
@interface BATInvitationContentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet UILabel *contentLb;

@property (nonatomic,strong) BATPhotoView *photoView;

@property (nonatomic,strong) BATInvitationModel *model;

@property (nonatomic,strong) BATCustomButton *priseBtn;

@property (nonatomic,strong) void (^topicDetailPriseBlock)(void);

@end
