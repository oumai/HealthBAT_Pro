//
//  BATMyAttendUserListCell.h
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/5/13.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BATMyAttendUserListModel;
@protocol BATMyAttendUserListCellDelegat <NSObject>

- (void)focuseButtonDidClick:(UIButton *)focusBtn userModel:(BATMyAttendUserListModel *)userModel;

@end

@interface BATMyAttendUserListCell : UITableViewCell
/** delegate属性 */
@property (nonatomic, weak) id <BATMyAttendUserListCellDelegat> delegate;
/** <#属性描述#> */
@property (nonatomic ,strong) BATMyAttendUserListModel *userListModel;
/** <#属性描述#> */
@property (nonatomic ,strong) NSString *userID;

@end
