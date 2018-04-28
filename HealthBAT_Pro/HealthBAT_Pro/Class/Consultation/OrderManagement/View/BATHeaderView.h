//
//  BATHeaderView.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 16/9/27.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATGraditorButton.h"
@protocol BATHeaderViewDelegate <NSObject>
-(void)BATHeaderViewSeleWithPage:(NSInteger)pages;
@end
@interface BATHeaderView : UIView

@property (nonatomic,strong) id <BATHeaderViewDelegate> delegate;

@property (nonatomic,strong) BATGraditorButton *chatBtn;

@property (nonatomic,strong) BATGraditorButton *bookBtn;

@property (nonatomic,assign) BOOL isHalf;

-(void)setLineViewPostionWihPage:(NSInteger)pages;

-(void)selectPages:(NSInteger)pages;

-(instancetype)initWithFrame:(CGRect)frame withLineWidth:(NSInteger)width;
@end
