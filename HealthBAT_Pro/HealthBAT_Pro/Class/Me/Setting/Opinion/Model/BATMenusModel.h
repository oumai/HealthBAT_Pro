//
//  MenusModel.h
//  HealthBAT
//
//  Created by KM on 16/6/242016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@class BATMenuData,BATSubmenus;

@interface BATMenusModel : NSObject

@property (nonatomic, assign) NSInteger   PagesCount;

@property (nonatomic, assign) NSInteger   ResultCode;

@property (nonatomic, assign) NSInteger   RecordsCount;

@property (nonatomic, copy  ) NSString    *ResultMessage;

@property (nonatomic, copy  ) NSArray<BATMenuData *> *Data;

@end


@interface BATMenuData : NSObject

@property (nonatomic, assign) NSInteger   ID;

@property (nonatomic, assign) NSInteger   ParentId;

@property (nonatomic, copy  ) NSString    *MenuName;

@property (nonatomic, copy  ) NSArray<BATSubmenus *> *SubMenus;

@end


@interface BATSubmenus : NSObject

@property (nonatomic, assign) NSInteger   ID;

@property (nonatomic, copy  ) NSString    *MenuName;

@end

