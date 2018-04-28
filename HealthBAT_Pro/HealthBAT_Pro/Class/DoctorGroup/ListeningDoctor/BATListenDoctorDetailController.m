//
//  BATListenDoctorDetailController.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/3/21.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATListenDoctorDetailController.h"
#import "BATTopicTableViewCell.h"
#import "BATTopicPersonController.h"
#import "BATTopicRecordModel.h"
#import "BATTopicSingleModel.h"
#import "BATAudioCell.h"
#import "RecordView.h"
#import "BATUploadImageModel.h"
#import <AVFoundation/AVFoundation.h>
#import "BATHotTopicModel.h"

#import "BATPersonDetailController.h"
@interface BATListenDoctorDetailController ()<UITableViewDelegate,UITableViewDataSource,BATAudioCellDelegate>

@property (nonatomic,strong) UITableView *listenTab;

@property (nonatomic,assign) NSInteger currentPage;

@property (nonatomic,strong) BATTopicRecordModel *replyModel;

@property (nonatomic,strong) RecordView *recordView;

@property (nonatomic,strong) UIControl *backView;

@property (nonatomic,assign) BOOL isShow;

@property (nonatomic,strong) NSString *soundURL;

@property (nonatomic,assign) NSInteger second;

@property (nonatomic,strong) NSString *ParentID;

@property (nonatomic,strong) NSString *ParentLevelID;

@property (nonatomic,strong) AVPlayer *player;

@property (nonatomic,strong) HotTopicData *modelData;

@end

@implementation BATListenDoctorDetailController

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self pageLayout];
    
    [self attentionRequest];
    
    [self GetReplyListRequest];
    
    [self updateReadNum];
}

- (void)pageLayout {

    self.title = @"医声";
    [self.view addSubview:self.listenTab];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else {
        return self.replyModel.Data.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        BATTopicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATTopicTableViewCell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.commentButton.hidden = YES;
        cell.thumbsUpButton.hidden = YES;
        cell.replyBtn.hidden = NO;

        if (self.modelData) {
            HotTopicData *moment = self.modelData;
            moment.isShowTime = YES;
            cell.indexPath = indexPath;
            [cell configrationCell:moment];
            
             WEAK_SELF(self);
            cell.avatarAction = ^(NSIndexPath *cellIndexPath) {
                STRONG_SELF(self);
                DDLogWarn(@"头像点击%@",cellIndexPath);
                if (!LOGIN_STATION) {
                    PRESENT_LOGIN_VC;
                }
                
               //新的个人详情控制器
                BATPersonDetailController *personVC = [[BATPersonDetailController alloc]init];
                personVC.accountID = moment.AccountID;
                
                /**
                BATTopicPersonController *personVC = [[BATTopicPersonController alloc]init];
                personVC.accountID = moment.AccountID;
                
                 
                WEAK_SELF(self);
                personVC.PersonRefreshBlock = ^(BOOL isChange){
                    STRONG_SELF(self);

                    if (isChange) {
                        [self.listenTab.mj_header beginRefreshing];
                    }
                    
                };
                 */
                [self.navigationController pushViewController:personVC animated:YES];
                
            };
            
            cell.audioAction = ^(){
                STRONG_SELF(self);
                if (!LOGIN_STATION) {
                    PRESENT_LOGIN_VC
                    return;
                }
                
                [self.backView addSubview:self.recordView];
                [[UIApplication sharedApplication].keyWindow addSubview:self.backView];
                [UIView animateWithDuration:0.3 animations:^{
                    self.backView.alpha = 1;
                }];
                self.isShow = !self.isShow;
                
                self.ParentLevelID = nil;
                self.ParentID = nil;
            
            };
            
            cell.moreAction = ^(NSIndexPath *cellIndexPath) {
                STRONG_SELF(self);
                DDLogWarn(@"更多操作点击%@",cellIndexPath);
                if (!LOGIN_STATION) {
                    PRESENT_LOGIN_VC
                    return;
                }
                NSString *urlString = nil;
                if (moment.IsUserFollow) {
                    urlString = @"/api/dynamic/CancelOperation";
                    [self AttendRequesetWithURL:urlString monent:moment];
                }else {
                    urlString = @"/api/dynamic/ExecuteOperation";
                    [self AttendRequesetWithURL:urlString monent:moment];
                }
            };
            
        }
        return cell;

    }else {
        BATAudioCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATAudioCell"];
        cell.paht = indexPath;
        cell.delegate = self;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if (self.replyModel.Data.count >0) {
            cell.model = self.replyModel.Data[indexPath.row];
        }
        
        WEAK_SELF(self);
        //点赞回调
        cell.priseBlock = ^(NSIndexPath *path) {
            STRONG_SELF(self);
            if (!LOGIN_STATION) {
                PRESENT_LOGIN_VC
                return;
            }
            
            TopicReplyData *moment = self.replyModel.Data[indexPath.row];
            NSString *urlString = nil;
            if (moment.IsSetStar) {
                urlString = @"/api/dynamic/CancelOperation";
                [self priseRequesetWithURL:urlString monent:moment];
            }else {
                urlString = @"/api/dynamic/ExecuteOperation";
                [self priseRequesetWithURL:urlString monent:moment];
            }
        };
        
        //评论回调
        cell.commentBlock = ^(NSIndexPath *path) {
             STRONG_SELF(self);
            if (!LOGIN_STATION) {
                PRESENT_LOGIN_VC
                return;
            }
            
            TopicReplyData *moment = self.replyModel.Data[indexPath.row];
            self.ParentID = moment.ID;
            self.ParentLevelID = moment.ID;
            
            [self.backView addSubview:self.recordView];
            [[UIApplication sharedApplication].keyWindow addSubview:self.backView];
            [UIView animateWithDuration:0.3 animations:^{
                self.backView.alpha = 1;
            }];
            self.isShow = !self.isShow;
        };
        
        //头像点击回调
        cell.headImageBlock = ^(NSIndexPath *path){
            STRONG_SELF(self);
        TopicReplyData *moment = self.replyModel.Data[path.row];
            
            //新个个人主页控制器
            BATPersonDetailController *personDetailVC = [[BATPersonDetailController alloc]init];
            personDetailVC.accountID = moment.AccountID;
            
            [self.navigationController pushViewController:personDetailVC animated:YES];
            
            /*
            BATTopicPersonController *topicPersonVC  = [[BATTopicPersonController alloc]init];
            topicPersonVC.accountID = moment.AccountID;
            [self.navigationController pushViewController:topicPersonVC animated:YES];
            */
        };
        return cell;
    }
    
}

//回复列表点赞使用
- (void)priseRequesetWithURL:(NSString *)url monent:(TopicReplyData *)monent {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"1" forKey:@"RelationType"];
    [dict setObject:monent.ID forKey:@"RelationID"];
    
    [HTTPTool requestWithURLString:url parameters:dict type:kPOST success:^(id responseObject) {
        
        if (!monent.IsSetStar) {
            monent.IsSetStar = YES;
            monent.StarNum ++;
        } else {
            monent.IsSetStar = NO;
            monent.StarNum--;
            
            if (monent.StarNum < 0) {
                monent.StarNum = 0;
            }
        }
        [self.listenTab reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

//对用于关注用
- (void)AttendRequesetWithURL:(NSString *)url monent:(HotTopicData *)monent {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"3" forKey:@"RelationType"];
    [dict setObject:monent.AccountID forKey:@"RelationID"];
    
    [HTTPTool requestWithURLString:url parameters:dict type:kPOST success:^(id responseObject) {
        
        monent.IsUserFollow = !monent.IsUserFollow;
        
        
        if (self.listenDoctorBlock) {
            self.listenDoctorBlock(monent.IsUserFollow);
        }
        
        [self.listenTab reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - BATAudioCellDelegate
- (void)BATAudioCellDelegateWithURL:(NSString *)URLString {
  
    if (_player) {
        [_player pause];
        _player = nil;
    }
    self.player = [AVPlayer playerWithURL:[NSURL URLWithString:URLString]];
    [_player play];
}

#pragma mark - NET 
#pragma mark - 获取回复列表
- (void)GetReplyListRequest {
  
    [HTTPTool requestWithURLString:@"/api/dynamic/GetReplyList" parameters:@{@"postId":self.ID} type:kGET success:^(id responseObject) {
        
        [self.listenTab.mj_header endRefreshing];
        
        self.replyModel = [BATTopicRecordModel mj_objectWithKeyValues:responseObject];
        [self.listenTab reloadData];
    } failure:^(NSError *error) {
        
    }];
}

- (void)updateReadNum {
    
    [HTTPTool requestWithURLString:@"/api/dynamic/UpdateReadNum" parameters:@{@"PostID":self.ID} type:kPOST success:^(id responseObject) {
        
        if (self.listenDoctorUpdateReadNumBlock) {
            self.listenDoctorUpdateReadNumBlock();
        }
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 上传声音
- (void)requestUpdateSoundWithData:(NSData *)data second:(NSInteger)second ParentID:(NSString *)ParentID ParentLevelID:(NSString *)ParentLevelID
{
    [HTTPTool requestUploadImageToBATWithParams:nil constructingBodyWithBlock:^(XMRequest *request) {
        
        [request addFormDataWithName:@"record_sound"
                            fileName:@"record_sound.mp3"
                            mimeType:@"multipart/form-data"
                            fileData:data];
        

    } success:^(NSArray *imageArray) {
        
        BATImage *imageModel = [imageArray firstObject];

        self.soundURL = imageModel.url;
        [self dismissProgress];
        [self SubmitReplyWithParentID:ParentID ParentLevelID:ParentLevelID];
        [self.listenTab.mj_header beginRefreshing];
        
    } failure:^(NSError *error) {
        
        [self showText:@"上传失败"];
        
    } fractionCompleted:^(double count) {
        
        [self showProgres:count];
        
    }];
}

#pragma mark -
- (void)SubmitReplyWithParentID:(NSString *)ParentID ParentLevelID:(NSString *)ParentLevelID {

    if (self.second -1 <=0) {
        self.second = 1;
    }else {
        self.second = self.second - 1;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:self.ID forKey:@"PostID"];
    [dict setValue:@"1" forKey:@"ReplyType"];
    [dict setValue:ParentID forKey:@"ParentID"];
    [dict setValue:ParentLevelID forKey:@"ParentLevelID"];
    [dict setValue:@"" forKey:@"ReplyContent"];
    [dict setValue:self.soundURL forKey:@"AudioUrl"];
    [dict setValue:@(self.second) forKey:@"AudioLong"];
    
    [HTTPTool requestWithURLString:@"/api/dynamic/SubmitReply" parameters:dict type:kPOST success:^(id responseObject) {
        NSLog(@"上传成功");
        self.ParentID = nil;
        self.ParentLevelID = nil;
        
        [self GetReplyListRequest];

    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 获取帖子详情
- (void)attentionRequest {
    
    [HTTPTool requestWithURLString:@"/api/dynamic/GetPostDetail"
                        parameters:@{
                                     @"ID":self.ID,
                                     }
                              type:kGET
                           success:^(id responseObject) {
                               
                        
                              
                               self.modelData = [HotTopicData mj_objectWithKeyValues:[responseObject objectForKey:@"Data"]];
                               
                               
                                
                                   [self.listenTab reloadData];
                                   
                               
                               
                           } failure:^(NSError *error) {
                               
                               [self.listenTab.mj_header endRefreshingWithCompletionBlock:^{
                                   
                               }];
                               [self.listenTab.mj_footer endRefreshing];
                               self.currentPage --;
                               if (self.currentPage < 0) {
                                   self.currentPage = 0;
                               }
                               
                           }];
    
}
#pragma mark - Lazy Load
- (UITableView *)listenTab {

    if (!_listenTab) {
        _listenTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
        _listenTab.delegate = self;
        _listenTab.dataSource = self;
        _listenTab.estimatedRowHeight = 250;
        _listenTab.rowHeight = UITableViewAutomaticDimension;
        [_listenTab setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_listenTab registerNib:[UINib nibWithNibName:@"BATTopicTableViewCell" bundle:nil] forCellReuseIdentifier:@"BATTopicTableViewCell"];
        [_listenTab registerClass:[BATAudioCell class] forCellReuseIdentifier:@"BATAudioCell"];
        WEAK_SELF(self);
        _listenTab.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            STRONG_SELF(self);
            [self GetReplyListRequest];
            [self attentionRequest];
        }];
        
    }
    return _listenTab;
}

- (RecordView *)recordView {
    
    if (!_recordView) {
        _recordView = [[[NSBundle mainBundle] loadNibNamed:@"RecordView" owner:self options:nil] lastObject];
        _recordView.frame = CGRectMake(0, SCREEN_HEIGHT - 407, SCREEN_WIDTH, 407);
        _recordView.backgroundColor = [UIColor whiteColor];
        
        WEAK_SELF(self);
        _recordView.SoundDataBlock = ^(NSData *soundData,NSInteger second) {
            STRONG_SELF(self);
            self.second = second;
            //开始上传数据
            [self requestUpdateSoundWithData:soundData second:self.second ParentID:self.ParentID ParentLevelID:self.ParentLevelID];
            
            [UIView animateWithDuration:0.3 animations:^{
                self.backView.alpha = 0;
            } completion:^(BOOL finished) {
                
                [self.recordView.playTimer invalidate];
                self.recordView.playTimer = nil;
                [self.recordView.CountDownTimer invalidate];
                self.recordView.CountDownTimer = nil;
                self.recordView = nil;
                [self.backView removeFromSuperview];
            }];
            self.isShow = !self.isShow;
        };
    }
    return _recordView;
}

- (UIControl *)backView {
    
    if (!_backView) {
        _backView = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _backView.alpha = 0;
        _backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];

        
        
        [_backView addTarget:self action:@selector(dismissViewAction) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return _backView;
}

- (void)dismissViewAction {
    
    if (!self.isShow) {
        [[UIApplication sharedApplication].keyWindow addSubview:self.backView];
        [UIView animateWithDuration:0.3 animations:^{
            self.backView.alpha = 1;
        }];
        self.isShow = !self.isShow;
    }else {
        [UIView animateWithDuration:0.3 animations:^{
            self.backView.alpha = 0;
        } completion:^(BOOL finished) {
          
            
            [self.recordView.playTimer invalidate];
            self.recordView.playTimer = nil;
            [self.recordView.CountDownTimer invalidate];
            self.recordView.CountDownTimer = nil;
             self.recordView = nil;
              [self.backView removeFromSuperview];
        }];
        self.isShow = !self.isShow;
    }
}

- (AVPlayer *)player {

    if (!_player) {
        _player = [[AVPlayer alloc]init];
    }
    return _player;
}


@end
