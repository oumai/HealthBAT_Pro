//
//  RecordView.m
//  RecordTest
//
//  Created by kmcompany on 2017/3/15.
//  Copyright © 2017年 kmcompany. All rights reserved.
//

#import "RecordView.h"
#import "Mp3Recorder.h"
#import <AVFoundation/AVFoundation.h>
#import "UUAVAudioPlayer.h"
@interface RecordView()<Mp3RecorderDelegate,UUAVAudioPlayerDelegate>
{

    //player
    AVAudioPlayer *player;
    UUAVAudioPlayer *audio;
    BOOL isPlaying;
    NSData *songData;
    BOOL isFinsh;
    
    //recorder
    Mp3Recorder *MP3;
    NSInteger playTime;
    BOOL isRecording;
    
    //Timer
//    NSTimer *CountDownTimer;
    NSInteger countDownPlayTime;
}
@end

@implementation RecordView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.lineView.backgroundColor = BASE_BACKGROUND_COLOR;
    
    MP3 = [[Mp3Recorder alloc]initWithDelegate:self];
    
    [self.rerecordingBtn setTitleColor:UIColorFromHEX(0X333333, 1) forState:UIControlStateNormal];
    self.rerecordingBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    
    self.countingLb.textColor = BASE_COLOR;
    self.countingLb.font = [UIFont systemFontOfSize:24];
    
    [self.commitBtn setTitleColor:BASE_COLOR forState:UIControlStateNormal];
    self.commitBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    
    self.recordType.textColor = UIColorFromHEX(0X666666, 1);
    self.recordType.font = [UIFont systemFontOfSize:15];
    
    
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(UUAVAudioPlayerDidFinishPlay) name:@"VoicePlayHasInterrupt" object:nil];
    
}

//重录按钮
- (IBAction)rerecordingAction:(id)sender {
    
    if (_playTimer) {
        [MP3 stopRecord];
        [_playTimer invalidate];
        _playTimer = nil;
    }
    //开始录音
    self.recordType.text = @"最多录制60s,点击开始";
     [self.recordBtn setImage:[UIImage imageNamed:@"录制"] forState:UIControlStateNormal];
    
    playTime = 0;
    self.countingLb.text = [NSString stringWithFormat:@"%zd''",playTime];
    
//    playTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countVoiceTime) userInfo:nil repeats:YES];
    self.rerecordingBtn.hidden = YES;
    self.commitBtn.hidden = YES;
    [[UUAVAudioPlayer sharedInstance] stopSound];
    
    isPlaying = NO;
    isRecording = NO;
  //  [self recordAction:nil];
    
}

//录音提交按钮
- (IBAction)commitAction:(id)sender {
    
    if (self.SoundDataBlock) {
        if (songData != nil) {
            self.SoundDataBlock(songData,playTime);
        }
    }
    
    playTime = 0;
    self.countingLb.text = [NSString stringWithFormat:@"%zd''",playTime];
    
    //    playTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countVoiceTime) userInfo:nil repeats:YES];
    
    [[UUAVAudioPlayer sharedInstance] stopSound];
    
    isPlaying = NO;
    isRecording = NO;
}

//录音按钮
- (IBAction)recordAction:(id)sender {
    
    if (!isPlaying) {
        if (!isRecording) {
            //开始录音
            [MP3 startRecord];
            playTime = 0;
            _playTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countVoiceTime) userInfo:nil repeats:YES];
            [_playTimer fire];
            isRecording = !isRecording;
            
            self.recordType.text = @"录音中,点击停止录音";
            [self.recordBtn setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
            
        }else {
            
            
            
            //状态切换，此处是停止录音状态
            if (_playTimer) {
                [MP3 stopRecord];
                [_playTimer invalidate];
                _playTimer = nil;
            }
            [self.recordBtn setImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
            
            isPlaying = YES;
            
            self.recordType.text = @"播放试听";
            
            self.rerecordingBtn.hidden = NO;
            self.commitBtn.hidden = NO;
            
        }
    }else {
        if(isFinsh){
            
            [[UUAVAudioPlayer sharedInstance] stopSound];
            if (_CountDownTimer) {
                [_CountDownTimer invalidate];
                _CountDownTimer = nil;
            }
            countDownPlayTime = 0;
            isFinsh = NO;
            self.rerecordingBtn.hidden = NO;
            self.commitBtn.hidden = NO;
             self.recordType.text = @"播放试听";
            [self.recordBtn setImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];

        }else{
        
            self.recordType.text = @"播放中,点击停止播放";
             [self.recordBtn setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
            
            audio = [UUAVAudioPlayer sharedInstance];
            audio.delegate = self;
            [audio playSongWithData:songData];
            
            isFinsh = YES;
            
            self.rerecordingBtn.hidden = YES;
            self.commitBtn.hidden = YES;
            
            _CountDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownVoiceTime) userInfo:nil repeats:YES];
            
        }
    }

}

- (void)countDownVoiceTime {

    if (countDownPlayTime == playTime) {
        [_CountDownTimer invalidate];
         _CountDownTimer = nil;
        countDownPlayTime = 0;
        return;
    }
    
    self.countingLb.text = [NSString stringWithFormat:@"%zd''",countDownPlayTime];
    countDownPlayTime ++;

}

- (void)UUAVAudioPlayerBeiginLoadVoice
{

}
- (void)UUAVAudioPlayerBeiginPlay
{
    //开启红外线感应
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];

}
- (void)UUAVAudioPlayerDidFinishPlay
{
    //关闭红外线感应
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    self.commitBtn.hidden = NO;
    self.rerecordingBtn.hidden = NO;
    self.recordType.text = @"播放试听";
    [self.recordBtn setImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
  //  [self.btnContent stopPlay];
    isFinsh = NO;
    [[UUAVAudioPlayer sharedInstance]stopSound];
}

//取消计时
- (void)countDownFinsh {
    
    //状态切换，此处是停止录音状态
    if (_playTimer) {
        [MP3 stopRecord];
        [_playTimer invalidate];
        _playTimer = nil;
    }
    [self.recordBtn setImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
    
    isPlaying = YES;
     isFinsh = NO;
    self.recordType.text = @"播放试听";
    
    self.rerecordingBtn.hidden = NO;
    self.commitBtn.hidden = NO;
    
}

- (void)countVoiceTime
{
    if (playTime>=60) {
           //到60秒取消计时
           [self countDownFinsh];
    }
    self.countingLb.text = [NSString stringWithFormat:@"%zd''",playTime];
    playTime ++;

}

#pragma mark - Mp3RecorderDelegate

//回调录音资料
- (void)endConvertWithData:(NSData *)voiceData
{
   
    songData = voiceData;
    //缓冲消失时间 (最好有block回调消失完成)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

    });
}

- (void)failRecord
{
  
    
    //缓冲消失时间 (最好有block回调消失完成)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
    });
}

- (void)beginConvert {

}
@end
