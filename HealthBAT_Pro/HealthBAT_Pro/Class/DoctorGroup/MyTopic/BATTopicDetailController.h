//
//  BATTopicDetailController.h
//  RecordTest
//
//  Created by kmcompany on 2017/3/16.
//  Copyright © 2017年 kmcompany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATTopicDetailController : UIViewController

@property (nonatomic,strong) NSString *ID;

@property (nonatomic,assign) BOOL isAudio;

@property (nonatomic,strong) void (^TopicDetailRefashBlock)(BOOL isAttend);

@end
