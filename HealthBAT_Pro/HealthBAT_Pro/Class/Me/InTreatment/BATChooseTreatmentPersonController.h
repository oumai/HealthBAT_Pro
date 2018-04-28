//
//  BATChooseTreatmentPersonController.h
//  TableViewTest
//
//  Created by kmcompany on 16/9/23.
//  Copyright © 2016年 sword. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseTreatmentModel.h"

@interface BATChooseTreatmentPersonController : UIViewController
@property(nonatomic,strong)void (^ChooseBlock)(ChooseTreatmentModel *model);

@property (nonatomic,assign) BOOL isShow;

@property (nonatomic,strong) NSString *memberID;

@property (nonatomic,strong) NSString *pathName;
@end
