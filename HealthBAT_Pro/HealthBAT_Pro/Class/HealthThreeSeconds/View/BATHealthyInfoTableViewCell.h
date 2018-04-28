//
//  BATHealthyInfoTableViewCell.h
//  HealthBAT_Pro
//
//  Created by 黄帆 on 2017/12/16.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, HealthyInfoStatus) {
    SLstatus = 0,
    XLstatus = 1,

};
typedef void(^TextFieldNotTrue)(NSString *str);
@interface BATHealthyInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UITextField *contentTextF;

@property (weak, nonatomic) IBOutlet UILabel *lab;

@property (assign, nonatomic) HealthyInfoStatus status;

@property (assign, nonatomic) BOOL enableNow;

@property (nonatomic, strong) NSString *sexStr;

@property (nonatomic, copy) TextFieldNotTrue textFieldNotTrueBlock;

@property (nonatomic, strong) NSString *titleStr;
@end
