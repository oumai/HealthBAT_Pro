//
//  BATComplaintController.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/4/11.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATComplaintController : UIViewController


/**
 *  字数
 */
@property (nonatomic,strong) UILabel *wordCountLabel;

@property (nonatomic,strong) NSString *OrderMSTID;

@property(nonatomic,assign) BOOL isComplaint;

@property (nonatomic,copy) void(^commitSuccessBlock)(void);

@end
