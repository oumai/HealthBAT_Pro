//
//  BATAddTreatmentController.h
//  TableViewTest
//
//  Created by kmcompany on 16/9/22.
//  Copyright © 2016年 sword. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseTreatmentModel.h"
@interface BATAddTreatmentController : UIViewController
@property(nonatomic,assign)BOOL isAdd;
@property (nonatomic,strong) ChooseTreatmentModel *editModel;
@end
