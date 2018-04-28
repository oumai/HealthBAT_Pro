//
//  DoctorInfoView.h
//  HealthBAT_Pro
//
//  Created by KM on 16/7/262016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATDoctorInfoView : UIView

@property (nonatomic,strong) UIImageView *headerImageView;
@property (nonatomic,strong) UILabel     *nameLabel;
@property (nonatomic,strong) UILabel     *levelLabel;
@property (nonatomic,strong) UILabel     *hospitalLabel;
@property (nonatomic,strong) UILabel     *desLabel;

- (instancetype)initWithFrame:(CGRect)frame imageUrl:(NSString *)imageUrl name:(NSString *)name level:(NSString *)level hospital:(NSString *)hospital des:(NSString *)des;

@end
