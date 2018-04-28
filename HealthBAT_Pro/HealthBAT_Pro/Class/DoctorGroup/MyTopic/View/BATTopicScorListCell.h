//
//  BATTopicScorListCell.h
//  RecordTest
//
//  Created by kmcompany on 2017/3/16.
//  Copyright © 2017年 kmcompany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATTopicScorListCell : UITableViewCell

@property (nonatomic,strong) UITableView *leftTab;

@property (nonatomic,strong) UITableView *rightTab;

@property (nonatomic,assign) BOOL isCanScor;

@property (nonatomic,strong) NSMutableArray *modelArr;

@property (nonatomic,assign) NSInteger leftTabRecordsCount;

@property (nonatomic,strong) NSMutableArray *RightModelArr;

@property (nonatomic,assign) NSInteger RightTabRecordsCount;

@property (nonatomic,strong) NSString *TopicID;

@property (nonatomic,strong) void (^LeftFooterReflashBlock)(NSInteger page);

@property (nonatomic,strong) void (^RightFooterReflashBlock)(NSInteger page);

@property (nonatomic,strong) void (^pushBlock)(NSString *ID,NSInteger isAudio);

@property (nonatomic,strong) void (^HeadImagePushBlock)(NSString *account);

@end
