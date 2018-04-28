//
//  BATAreaPickerView.h
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/22.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BATAreaPickerView;
@protocol BATAreaPickerViewDelegate <NSObject>

- (void)BATAreaPickerView:(BATAreaPickerView *)areaPickerView province:(NSString *)province city:(NSString *)city;

@end

@interface BATAreaPickerView : UIView

@property (nonatomic,strong) UIToolbar *toolBar;

@property (nonatomic,strong) UIPickerView *pickerView;

@property (nonatomic,weak) id<BATAreaPickerViewDelegate> delegate;

- (void)show;

- (void)hide;

@end
