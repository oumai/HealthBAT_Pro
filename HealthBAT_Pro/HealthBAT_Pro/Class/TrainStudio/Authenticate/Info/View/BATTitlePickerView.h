//
//  BATTitlePickerView.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/3/15.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BATTitlePickerView;
@protocol BATTitlePickerViewDelegate <NSObject>

- (void)BATTitlePickerView:(BATTitlePickerView *)titlePickerView didSelectRow:(NSInteger)row titleForRow:(NSString *)title;

@end

typedef void(^CancelBlcok)(void);

@interface BATTitlePickerView : UIView

@property (nonatomic,strong) UIToolbar *toolBar;

@property (nonatomic,strong) UIPickerView *pickerView;

@property (nonatomic,weak) id<BATTitlePickerViewDelegate> delegate;

@property (nonatomic,strong) CancelBlcok cancelBlcok;

//- (void)show;
//
//- (void)hide;

@end
