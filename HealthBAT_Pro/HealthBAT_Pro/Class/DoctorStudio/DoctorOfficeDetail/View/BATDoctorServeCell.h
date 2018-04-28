//
//  BATDoctorServeCell.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/4/1.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATDoctorServeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *chatTipsLb;
@property (weak, nonatomic) IBOutlet UILabel *AudioTipsLb;
@property (weak, nonatomic) IBOutlet UILabel *VideoTipsLb;
@property (weak, nonatomic) IBOutlet UILabel *chatContentLb;
@property (weak, nonatomic) IBOutlet UILabel *AudioContentLb;
@property (weak, nonatomic) IBOutlet UILabel *ViedoContentLb;

@property (weak, nonatomic) IBOutlet UIImageView *chatImage;

@property (weak, nonatomic) IBOutlet UIImageView *audioimage;

@property (weak, nonatomic) IBOutlet UIImageView *videoImage;

@property (nonatomic,strong) void (^SeverTapBlock)(NSInteger tag);

@end
