//
//  BATHealthFollowCategoryView.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/2/21.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHealthFollowCategoryView.h"
@interface BATHealthFollowCategoryView ()

/**
 移动步长
 */
@property (nonatomic,assign) float step;

@end

@implementation BATHealthFollowCategoryView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
//        NSArray *buttonNames = [[NSArray alloc] initWithObjects:@"美容",@"养生",@"减肥", nil];
        
        _buttons = [NSMutableArray array];
        _refreshs = [NSMutableArray array];
        
        _step = ((SCREEN_WIDTH / 3) - 70) / 2;
    
        
        [self requestAllCourseList];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - Net

#pragma mark - 获取特色课程数据
- (void)requestAllCourseList
{
    
    [HTTPTool requestWithURLString:@"/api/trainingteacher/coursecategory" parameters:nil type:kGET success:^(id responseObject) {
        
        self.specialModel = [BATSpecialtyTopicModel mj_objectWithKeyValues:responseObject];
        
        [self pageLayout];
        
        if (self.loadCategoryFinish) {
            self.loadCategoryFinish(YES);
        }
        
    } failure:^(NSError *error) {
        
        if (self.loadCategoryFinish) {
            self.loadCategoryFinish(NO);
        }
        
    }];
    
}

#pragma mark - Action
- (void)categoryAnimate:(NSInteger)index
{
    UIButton *button = [self viewWithTag:index];
    
    for (BATGraditorButton *btn in _buttons) {
        btn.selected = NO;
        if (button.tag == btn.tag) {
            
            btn.selected = YES;
            
            [btn setGradientColors:@[START_COLOR,END_COLOR]];
            
            [self.blueLine mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left).offset(_step + button.frame.origin.x);
            }];
            
            [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                [self setNeedsLayout];
                [self layoutIfNeeded];
            } completion:nil];
            
        }else {
            [btn setGradientColors:@[UIColorFromHEX(0X333333, 1),UIColorFromHEX(0X333333, 1)]];
        }
    }
    
}

- (void)buttonAction:(UIButton *)button
{
//    _isButtonClicked = YES;
    [self handleAction:button];

}

- (void)handleAction:(UIButton *)button
{
    [self categoryAnimate:button.tag];
    
    if (self.categoryButtonAction) {
        self.categoryButtonAction(button.tag - 100);
    }
}

#pragma mark - pageLayout
- (void)pageLayout
{
    //初始化界面
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    
    [_buttons removeAllObjects];
    [_refreshs removeAllObjects];
    
    
    //分类按钮
    NSInteger count = self.specialModel.Data.count > 3 ? 3 : self.specialModel.Data.count;
    
    for (int i = 0; i < count; i++) {
        
        BATSpecialtyTopicData *data = self.specialModel.Data[i];
        
        BATGraditorButton *button = [[BATGraditorButton alloc]init];
        button.enbleGraditor = YES;
        [button setTitle:data.Title forState:UIControlStateNormal];
        if (i==0) {
            [button setGradientColors:@[START_COLOR,END_COLOR]];
        }else {
            [button setGradientColors:@[UIColorFromHEX(0X333333, 1)]];
        }
    //    [button setTitleColor:UIColorFromHEX(0x333333, 1) forState:UIControlStateNormal];
//        [button setTitleColor:UIColorFromHEX(0x0182eb, 1) forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i + 100;
        [self addSubview:button];
        [_buttons addObject:button];
        
        [_refreshs addObject:[NSNumber numberWithBool:YES]];
        
        if (i == 0) {
            button.selected = YES;
            [self addSubview:self.blueLine];
            WEAK_SELF(self);
            [self.blueLine mas_makeConstraints:^(MASConstraintMaker *make) {
                STRONG_SELF(self);
                make.size.mas_equalTo(CGSizeMake(70, 2));
                make.bottom.equalTo(self.mas_bottom);
                make.left.equalTo(self.mas_left).offset(_step);
            }];
        }
    }
    
    [_buttons mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:(SCREEN_WIDTH / 3) leadSpacing:0 tailSpacing:0];
    WEAK_SELF(self);
    [_buttons mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.bottom.equalTo(self);
    }];
    
    //分隔线
    NSMutableArray *lines = [NSMutableArray array];
    
    for (int i = 0; i < 2; i++) {
        UILabel *line = [[UILabel alloc] init];
        line.backgroundColor = UIColorFromRGB(244, 244, 244, 1);
        [self addSubview:line];
        [lines addObject:line];
    }
    
    float spacing = (SCREEN_WIDTH - (1.0 / [UIScreen mainScreen].scale) * 2) / 3;
    
    [lines mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:(1.0 / [UIScreen mainScreen].scale) leadSpacing:spacing tailSpacing:spacing];
    [lines mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo((1.0 / [UIScreen mainScreen].scale));
        make.top.equalTo(self.mas_top).offset(10);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
    }];
    
    [self setBottomBorderWithColor:UIColorFromRGB(244, 244, 244, 1) width:SCREEN_WIDTH height:0];
}

#pragma mark - get & set
- (BATGraditorButton *)blueLine
{
    if (_blueLine == nil) {
        _blueLine = [[BATGraditorButton alloc] init];
        _blueLine.enablehollowOut = YES;
        [_blueLine setGradientColors:@[START_COLOR,END_COLOR]];
    }
    return _blueLine;
}


@end
