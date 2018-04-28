//
//  BATAudioCell.h
//  RecordTest
//
//  Created by kmcompany on 2017/3/15.
//  Copyright © 2017年 kmcompany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UUMessageContentButton.h"
#import "BATTopicRecordModel.h"

@protocol BATAudioCellDelegate <NSObject>

- (void)BATAudioCellDelegateWithURL:(NSString *)URLString;

@end

@interface BATAudioCell : UITableViewCell

@property (nonatomic,strong) TopicReplyData *model;

@property (nonatomic,strong) UUMessageContentButton *btnContent;

@property (nonatomic,strong) NSIndexPath *paht;

//点赞回调
@property (nonatomic,strong) void (^priseBlock)(NSIndexPath *path);

//评论回调
@property (nonatomic,strong) void (^commentBlock)(NSIndexPath *path);

//头像回调
@property (nonatomic,strong) void (^headImageBlock)(NSIndexPath *path);

@property (nonatomic,weak) id <BATAudioCellDelegate> delegate;

@end
