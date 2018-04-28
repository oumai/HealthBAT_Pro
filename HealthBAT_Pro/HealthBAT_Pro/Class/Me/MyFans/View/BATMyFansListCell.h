//
//  BATMyFansListCell.h
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/5/14.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BATMyFansListModel;

@protocol  BATMyFansListCellDelegate <NSObject>

- (void)focusButtonDidClick:(UIButton *)focusBtn fansModel :(BATMyFansListModel *)fansModel;

@end
@interface BATMyFansListCell : UITableViewCell
/** model */
@property (nonatomic ,strong) BATMyFansListModel *fansListModel;
/** delegate属性 */
@property (nonatomic, weak) id<BATMyFansListCellDelegate> delegate;
@end



