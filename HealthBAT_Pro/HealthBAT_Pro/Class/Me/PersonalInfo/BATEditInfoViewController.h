//
//  BATEditInfoViewController.h
//  CancerNeighbour
//
//  Created by Wilson on 15/10/27.
//  Copyright © 2015年 KM. All rights reserved.
//
//  功能：编辑用户名、身高、体重
//


#import <UIKit/UIKit.h>
#import "BATEditInfoView.h"
#import "BATPerson.h"

@interface BATEditInfoViewController : UIViewController

@property (nonatomic, strong) UIScrollView *svContent;
@property (nonatomic, strong) BATPerson *person;
@property (nonatomic, assign) EditType type;

@property (nonatomic, strong) BATEditInfoView *editInfoView;

@property (nonatomic, copy) void (^editPersonInfoBlock)(BATPerson *model);

@end

