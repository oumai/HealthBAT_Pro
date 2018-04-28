//
//  BATHealthFollowSearchView.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/2/21.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HealthFollowSearchClick)(void);

@interface BATHealthFollowSearchView : UIView<UITextFieldDelegate>

@property (nonatomic,strong) UIButton *searchButton;
@property (nonatomic,strong) UITextField *searchTF;
@property (nonatomic,strong) HealthFollowSearchClick healthFollowSearchClick;

@end
