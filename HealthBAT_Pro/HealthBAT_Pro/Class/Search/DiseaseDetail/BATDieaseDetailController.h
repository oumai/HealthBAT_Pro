//
//  ViewController.h
//  TableViewTest
//
//  Created by mac on 16/9/16.
//  Copyright © 2016年 sword. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATDieaseDetailController : UIViewController

@property(nonatomic,assign)NSInteger DieaseID;

@property(nonatomic,strong)NSString *EntryCNName;

@property(nonatomic,assign)BOOL isSaveUserOperaAction;

@property (nonatomic,strong) NSString *pathName;


@end

