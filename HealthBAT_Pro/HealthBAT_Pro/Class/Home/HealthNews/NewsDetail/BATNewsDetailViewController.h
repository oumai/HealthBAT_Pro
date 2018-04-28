//
//  BATNewsDetailViewController.h
//  HealthBAT_Pro
//
//  Created by Skyrim on 16/9/2.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATNewsDetailViewController : UIViewController

@property (nonatomic,copy) NSString *newsID;

@property (nonatomic,strong) NSString *pathName;

@property (nonatomic,strong) NSString *titleStr;

@property (nonatomic,assign) BOOL isSaveOpera;

@property (nonatomic, copy) NSString *categoryName;

@property (nonatomic, copy) NSString *categoryId;

@end
