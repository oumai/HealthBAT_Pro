//
//  BATDatePickerView.h
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/23.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BATDatePickerView;
@protocol BATDatePickerViewDelegate <NSObject>
- (void)batDatePickerView:(BATDatePickerView *)datePickerView didSelectDate:(NSString *)dateString;
- (void)batDatePickerView:(BATDatePickerView *)datePickerView selectDateValueChange:(NSString *)dateString;
@end

@interface BATDatePickerView : UIView
@property (nonatomic,weak) id<BATDatePickerViewDelegate> delegate;
- (void)showWithBirthday:(NSString *)birthday;
- (void)hide;
@end
