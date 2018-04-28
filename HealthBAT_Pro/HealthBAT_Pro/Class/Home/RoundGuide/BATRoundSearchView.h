//
//  BATRoundSearchView.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/9/6.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RoundSearchBlock)(NSString *keyword);

@interface BATRoundSearchView : UIView

@property (nonatomic,strong) UIImageView *bgView;
@property (nonatomic,strong) UIImageView *iconImageView;
@property (nonatomic, strong) UITextField *searchTextField;
@property (nonatomic,strong) RoundSearchBlock roundSearchBlock;

@end
