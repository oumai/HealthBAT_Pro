//
//  BATMessageController.h
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/5/12.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BATPersonDetailModel;

@interface BATMessageListViewController : RCConversationListViewController
/** <#属性描述#> */
//@property (nonatomic ,strong) BATPersonDetailModel *personHomePageModel;
/** 用户ID */
@property (nonatomic ,copy) NSString *userID;
/** 用户名称 */
@property (nonatomic ,copy) NSString *userName;
/** 用户头像地址 */
@property (nonatomic ,copy) NSString *userIconUrl;
@end
