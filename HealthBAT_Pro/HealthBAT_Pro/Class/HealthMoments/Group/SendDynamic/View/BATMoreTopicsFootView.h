//
//  BATMoreTopicsFootView.h
//  HealthBAT_Pro
//
//  Created by Carbon on 2017/10/24.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATTopicListModel.h"

@class BATMoreTopicsFootView;
@protocol BATMoreTopicsFootViewDelegate <NSObject>
- (void)topicsFootView:(BATMoreTopicsFootView *)topicsFootView didSelectedTopics:(MyTopicListDataModel *)topics;
@end

@interface BATMoreTopicsFootView : UIView
@property (nonatomic ,weak)     id<BATMoreTopicsFootViewDelegate> delegate;
- (void)setDataWithListModel:(BATTopicListModel *)model;
@end
