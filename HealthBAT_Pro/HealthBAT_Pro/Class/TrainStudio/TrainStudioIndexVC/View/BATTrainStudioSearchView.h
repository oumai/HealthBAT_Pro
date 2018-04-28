//
//  BATTrainStudioSearchView.h
//  HealthBAT_Pro
//
//  Created by four on 17/4/1.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATTrainStudioSearchView : UIView

@property (nonatomic,strong) UIButton *certificationBtn;

@property (nonatomic,strong) UITextField *searchTF;

@property (nonatomic,copy)   void(^certificationBtnClickBlock)(void);

@end
