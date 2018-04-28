//
//  RecordView.h
//  RecordTest
//
//  Created by kmcompany on 2017/3/15.
//  Copyright © 2017年 kmcompany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordView : UIView
@property (weak, nonatomic) IBOutlet UIView *lineView;
//重录按钮
@property (weak, nonatomic) IBOutlet UIButton *rerecordingBtn;
//提交那妞
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
//录音状态Lb
@property (weak, nonatomic) IBOutlet UILabel *recordType;
//计时Lb
@property (weak, nonatomic) IBOutlet UILabel *countingLb;
//录制按钮
@property (weak, nonatomic) IBOutlet UIButton *recordBtn;

@property (nonatomic,strong) void (^SoundDataBlock)(NSData *songdata,NSInteger second);

@property (nonatomic,strong) NSTimer *CountDownTimer;

@property (nonatomic,strong) NSTimer *playTimer;

@end
