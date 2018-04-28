//
//  WriteSingleDiseaseView.h
//  HealthBAT
//
//  Created by cjl on 16/8/1.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATWriteSingleDiseaseFooterView.h"

@protocol BATWriteSingleDiseaseViewDelegate <NSObject>

- (void)consultBtnClickedAction;

@end

@interface BATWriteSingleDiseaseView : UIView

/**
 *  tableivew
 */
@property (nonatomic,strong) UITableView *tableView;

/**
 *  tableFooterView
 */
@property (nonatomic,strong) BATWriteSingleDiseaseFooterView *footerView;

/**
 *  委托
 */
@property (nonatomic,weak) id<BATWriteSingleDiseaseViewDelegate> delegate;

@end
