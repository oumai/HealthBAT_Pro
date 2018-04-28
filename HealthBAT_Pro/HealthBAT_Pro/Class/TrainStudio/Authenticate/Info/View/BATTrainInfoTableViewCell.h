//
//  BATTrainInfoTableViewCell.h
//  HealthBAT_Pro
//
//  Created by Skybrim on 2017/3/20.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATTrainInfoTableViewCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UITextField *inputTF;
@property (nonatomic,strong) UIImageView *rightArrow;

@property (nonatomic,strong) NSIndexPath *currentIndex;
@property (nonatomic,copy) void(^inputBlock)(NSString *input, NSIndexPath *selectIndexPath);
@property (nonatomic,copy) void(^eventBlock)(NSIndexPath *selectIndexPath);

@end
