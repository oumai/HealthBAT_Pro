//
//  BATEditInfoView.h
//  HealthBAT
//
//  Created by cjl on 16/8/1.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, EditType) {
    kEditUserName = 1,
    kEditSignature = 2,
    kEditHeight = 3,
    kEditWeight = 4,
    kEditPastHistory = 5,
    kEditAllergyHistory = 6,
    kEditHereditaryDisease = 7,
};

@interface BATEditInfoView : UIView

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) UIView *containerView;

@property (nonatomic,strong) UIImageView *imageBgView;

@property (nonatomic,strong) UITextField *textField;

@property (nonatomic,strong) UITextView *textView;

- (instancetype)initWithFrame:(CGRect)frame withEditType:(EditType)type;

@end
