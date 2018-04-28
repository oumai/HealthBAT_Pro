//
//  BATAddProgramItemViewController.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/3/1.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATAddProgramItemView.h"

@interface BATAddProgramItemViewController : UIViewController

@property (nonatomic,strong) BATAddProgramItemView *addProgramItemView;


/**
 父方案ID
 */
@property (nonatomic,assign) NSInteger templateID;

/**
 子方案ID
 */
@property (nonatomic,assign) NSInteger subTemplateID;

/**
 关联ID
 */
@property (nonatomic,assign) NSInteger evaluationID;

/**
 标识
 */
@property (nonatomic,copy) NSString *identifer;


/**
 子方案名称
 */
@property (nonatomic,copy) NSString *itemTitle;

/**
 时间
 */
@property (nonatomic,copy) NSString *jobTime;

/**
 备注
 */
@property (nonatomic,copy) NSString *resultDesc;

/**
 是否开启闹钟
 */
@property (nonatomic,assign) BOOL isFlag;

@end
