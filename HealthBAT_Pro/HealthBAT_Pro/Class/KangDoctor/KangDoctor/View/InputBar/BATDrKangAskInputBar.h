//
//  BATDrKangAskInputBar.h
//  HealthBAT_Pro
//
//  Created by mac on 2018/2/28.
//  Copyright © 2018年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYText.h"

@interface BATDrKangAskInputBar : UIView

@property (nonatomic,strong) UIButton *nextBtn;
@property (nonatomic,strong) YYTextView *textView;

@property (nonatomic,copy) NSString *tmpQuestion;

@end
