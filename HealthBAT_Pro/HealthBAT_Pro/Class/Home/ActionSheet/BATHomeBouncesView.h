//
//  BATHomeBouncesView.h
//  HealthBAT_Pro
//
//  Created by 黄帆 on 2017/11/15.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATHealthEvalutionModel.h"
typedef void(^CloseContentBlock)(void);

typedef NS_ENUM(NSInteger, JianKangStatus) {
    SLstatus = 0,
    XLstatus = 1,
    SHstatus = 2
};

@interface BATHomeBouncesView : UIView
@property (nonatomic,strong) CloseContentBlock closeContentBlock;

@property (strong, nonatomic) NSString *textStr;

@property (assign, nonatomic) JianKangStatus status;

@property (strong, nonatomic) BATHealthEvalutionModel *model;
@end
