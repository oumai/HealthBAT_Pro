//
//  BATPersonInfoViewController.h
//  CancerNeighbour
//
//  Created by Wilson on 15/10/27.
//  Copyright © 2015年 KM. All rights reserved.
//
//  功能：个人信息界面
//

#import <UIKit/UIKit.h>

@interface BATPersonInfoViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIPopoverControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UITableView *tvContent;

@end
