//
//  BATEmptyDataView.h
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/6/21.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATEmptyDataView : UIView
//重新加载
@property (nonatomic,copy) void(^reloadRequestBlock)(void);
@end
