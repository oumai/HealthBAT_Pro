//
//  BATDepartmentPickerView.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/4/5.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BATDepartmentPickerView;
@protocol BATDepartmentPickerViewDelegate <NSObject>

- (void)BATDepartmentPickerView:(BATDepartmentPickerView *)departmentPickerView didSelectRow:(NSInteger)row departmentForRow:(NSDictionary *)department;

@end

typedef void(^CancelBlcok)(void);

@interface BATDepartmentPickerView : UIView

@property (nonatomic,strong) UIToolbar *toolBar;

@property (nonatomic,strong) UIPickerView *pickerView;

@property (nonatomic,weak) id<BATDepartmentPickerViewDelegate> delegate;

@property (nonatomic,strong) CancelBlcok cancelBlcok;

@end
