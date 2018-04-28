//
//  SheetActionView.h
//  YiFu
//
//  Created by Michael on 16/3/11.
//  Copyright © 2016年 jumper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATRelationshipSheetActionView : UIView

@property (nonatomic, assign) NSInteger integertype; //5关系，2性别，3年龄
@property (nonatomic, strong) void(^sheetViewBlock)(NSInteger,NSString *chooseString);
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSArray *relateshipArray;
@property (nonatomic, strong) NSMutableArray *ageArrarray;
@property (nonatomic, strong) NSMutableArray *sexArrarry;


- (void)animationPresent:(NSInteger)type;
- (void)animationedDismiss;


@end
