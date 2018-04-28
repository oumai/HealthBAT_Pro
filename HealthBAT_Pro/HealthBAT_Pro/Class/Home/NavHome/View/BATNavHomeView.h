//
//  BATNavHomeView.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/9/12.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATGoHomeView.h"

typedef void(^DownBlock)(void);

typedef void(^GoHomeBlock)(void);

typedef void(^GoJkdaBlock)(void);

@interface BATNavHomeView : UIView

//@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) UIImageView *downImageView;

@property (nonatomic, strong) BATGoHomeView *gohomeView;

@property (nonatomic, strong) UIButton *jkdaBtn;

@property (nonatomic,strong) DownBlock downBlock;

@property (nonatomic,strong) GoHomeBlock goHomeBlock;

@property (nonatomic,strong) GoJkdaBlock goJkdaBlock;


- (void)downImageAnimate;
//@property (nonatomic, copy) NSString *helpStrig;

@end
