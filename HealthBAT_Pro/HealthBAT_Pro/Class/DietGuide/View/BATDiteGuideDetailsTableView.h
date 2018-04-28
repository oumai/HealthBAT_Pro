//
//  BATDiteGuideDetailsTableView.h
//  HealthBAT_Pro
//
//  Created by Carbon on 2017/10/25.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATDiteGuideDetailModel.h"

@class BATDiteGuideDetailsTableView;
@protocol BATDiteGuideDetailsTableViewDelegate <NSObject>
- (void)diteGuideDetailsTableView:(BATDiteGuideDetailsTableView *)guideDetailsTableView diteGuideDetailModel:(BATDiteGuideDetailModel *)model;
- (void)diteGuideDetailsTableViewLoadData:(BATDiteGuideDetailsTableView *)guideDetailsTableView;
@end

@interface BATDiteGuideDetailsTableView : UITableView
@property (nonatomic ,weak) id<BATDiteGuideDetailsTableViewDelegate> bat_Delegate;
- (instancetype)initWithStyle:(UITableViewStyle)style;
- (void)setDataWithDiteGuideDetailModel:(BATDiteGuideDetailModel *)diteGuideDetailModel;
@end
