//
//  BATShowView.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/5/12.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATCustomButton.h"
//#import "MEIQIA_TTTAttributedLabel.h"

@interface BATShowView : UIControl

@property (nonatomic,strong) UILabel *showViewTitle;
@property (nonatomic,strong) UILabel *showViewContent;
@property (nonatomic,strong) BATCustomButton *showViewBtn;
@property (nonatomic,strong) UIScrollView *backScroView;

@property (nonatomic,strong) void (^complicateBlock)(void);

- (void)calculateContentSizeWithContent:(NSString *)content;

- (void)animationStart;



@end
