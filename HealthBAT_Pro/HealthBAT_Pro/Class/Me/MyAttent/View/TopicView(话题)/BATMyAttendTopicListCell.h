//
//  BATMyAttendTopicListCell.h
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/5/13.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BATMyAttendTopicListModel;
@protocol BATMyAttendTopicListCellDelegate <NSObject>

- (void)focusButtonDidClick:(UIButton *)btn topicModel : (BATMyAttendTopicListModel *)topicModel;

@end

@interface BATMyAttendTopicListCell : UITableViewCell
/** delegate属性 */
@property (nonatomic, weak) id <BATMyAttendTopicListCellDelegate> delegate;
/** <#属性描述#> */
@property (nonatomic ,strong) BATMyAttendTopicListModel *topicModel;
@end
