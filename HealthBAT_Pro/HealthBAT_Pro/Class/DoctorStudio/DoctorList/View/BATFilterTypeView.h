//
//  BATFilterTypeView.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/4/1.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^FilterClickBlock)(NSInteger index,BOOL isSelect);
@interface BATFilterTypeView : UIView

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UILabel *line;

@property (nonatomic,strong) FilterClickBlock filterClickBlock;

- (void)loadFilterItem:(NSArray *)data;

@end
