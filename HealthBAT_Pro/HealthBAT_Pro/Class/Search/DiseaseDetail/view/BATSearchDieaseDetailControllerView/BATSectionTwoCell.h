//
//  BATSectionTwoCell.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/5/8.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATGraditorButton.h"
/**
 *
 *
 *  @更多点击block
 */
typedef void(^sectionTwoBlock)(NSInteger type);


@interface BATSectionTwoCell : UITableViewCell
//@property (weak, nonatomic) IBOutlet BATGraditorButton *doctorBtn;
//@property (weak, nonatomic) IBOutlet BATGraditorButton *hosptialBtn;
//@property (weak, nonatomic) IBOutlet BATGraditorButton *drugBtn;
//@property (weak, nonatomic) IBOutlet BATGraditorButton *bookBtn;

@property (nonatomic,strong) sectionTwoBlock sectionTwoBlockAction;

@end
