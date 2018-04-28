//
//  DepartmentListViewController.h
//  HealthBAT_Pro
//
//  Created by KM on 16/7/152016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATRegisterDepartmentListViewController : UIViewController

@property (nonatomic,assign) NSInteger hospitalId;
@property (nonatomic,copy  ) NSString  *hospitalName;
@property (nonatomic,strong) NSString *pathName;
@end
