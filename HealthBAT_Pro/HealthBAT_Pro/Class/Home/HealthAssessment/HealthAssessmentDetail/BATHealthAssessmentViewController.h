//
//  HealthAssessmentViewController.h
//  HealthBAT_Pro
//
//  Created by KM on 16/7/62016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATHealthAssessmentViewController : UIViewController

@property (nonatomic,strong) NSURL *url;
@property (nonatomic,assign) BOOL isFromMore;
@property (nonatomic,assign) NSInteger assessmentID;

@end
