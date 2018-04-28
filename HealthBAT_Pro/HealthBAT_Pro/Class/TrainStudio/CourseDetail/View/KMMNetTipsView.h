//
//  KMMNetTipsView.h
//  Maintenance
//
//  Created by kmcompany on 2017/7/18.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KMMNetTipsView : UIView
@property (weak, nonatomic) IBOutlet UILabel *messageLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UILabel *sizeLb;
@property (weak, nonatomic) IBOutlet UIButton *clickBtn;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (nonatomic,strong) void (^playBlock)(void);
@property (nonatomic,strong) void (^backBlock)(void);

@end
