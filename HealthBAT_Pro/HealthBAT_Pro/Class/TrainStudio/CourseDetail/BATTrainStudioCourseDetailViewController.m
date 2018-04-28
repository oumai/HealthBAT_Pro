//
//  BATTrainStudioCourseDetailViewController.m
//  HealthBAT_Pro
//
//  Created by four on 17/4/1.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATTrainStudioCourseDetailViewController.h"
#import "BATBATTrainStudioCourseDetailInfoCell.h"
#import "BATTrainStudioCourseDetailInfoView.h"
#import "BATTrainStudioCourseDetailModel.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "KMMNetTipsView.h"
#import "KMMGetURLFileLengthTool.h"
#import <AVFoundation/AVFoundation.h>

@interface BATTrainStudioCourseDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *courseDetailTableView;
//播放View
@property (nonatomic,strong) BATTrainStudioCourseDetailInfoView    *videoView;
//默认View
@property (nonatomic,strong) BATDefaultView *defaultView;

@property (nonatomic,strong) KMMNetTipsView *netTipsView;

//整体数据模型
@property (nonatomic,strong) BATTrainStudioCourseDetailModel *detailInfomodel;

//是否折叠
//@property (nonatomic,assign) BOOL isFold;

@property (nonatomic,assign) BOOL isWIFI;

@end

@implementation BATTrainStudioCourseDetailViewController


- (void)dealloc
{
    DDLogDebug(@"%s",__func__);
}

- (void)loadView
{
    [super loadView];
    
    [self pageLayout];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
    if (self.detailInfomodel) {
        [self.videoView.playerView pause];
    }
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.courseDetailTableView registerClass:[BATBATTrainStudioCourseDetailInfoCell class] forCellReuseIdentifier:@"BATBATTrainStudioCourseDetailInfoCell"];
    
    [self checkNetwork];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 返回值要必须为NO
- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BATBATTrainStudioCourseDetailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATBATTrainStudioCourseDetailInfoCell" forIndexPath:indexPath];
    
    if (self.detailInfomodel) {
//        cell.isFold = self.isFold;
        [cell configData:self.detailInfomodel];
        
//        WEAK_SELF(self);
//        cell.foldAction = ^(){
//            //展开收起
//            STRONG_SELF(self);
//            self.isFold = !self.isFold;
//            [self.courseDetailTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        };
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - Action
- (void)checkNetwork
{
    
    [self requestCourseDetail];
    
    NetworkStatus netStatus = [HTTPTool currentNetStatus];
    switch (netStatus) {
        case NotReachable:
            DDLogDebug(@"无网络");
            self.isWIFI = NO;
            break;
        case ReachableViaWiFi:
            DDLogDebug(@"wifi网络");
            self.isWIFI = YES;
            break;
        case ReachableViaWWAN: {
            DDLogDebug(@"移动网络");
            
            self.isWIFI = NO;
            
            self.netTipsView.hidden = NO;
            
//            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
            
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"流量提醒" message:@"当前网络环境是非wifi状态，播放视频可能要耗费4G/3G/2G流量，确定播放？" preferredStyle:UIAlertControllerStyleAlert];
//            
//            WEAK_SELF(self);
//            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                
//            }];
//            
//            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                STRONG_SELF(self);
//                if (self.detailInfomodel) {
//                    [self.videoView.playerView autoPlayTheVideo];
//                }
//            }];
//            
//            [alert addAction:cancelAction];
//            [alert addAction:confirmAction];
//            
//            
//            [self presentViewController:alert animated:YES completion:nil];
        }
            break;
        default:
            self.isWIFI = NO;
            break;
    }
    
}

#pragma mark - 计算视频时长和大小
- (void)getVideoInfoWithSourcePath:(NSString *)path
{
    
    NSURL *url = [NSURL URLWithString:path];
    
    AVURLAsset * asset = [AVURLAsset assetWithURL:url];
    CMTime   time = [asset duration];
    int totalTime = ceil(time.value/time.timescale);
    
    // duration 总时长
    NSInteger durMin = totalTime / 60;//总秒
    NSInteger durSec = totalTime % 60;//总分钟
    // 更新总时间
    self.netTipsView.timeLb.text = [NSString stringWithFormat:@"视频时长 %02zd:%02zd", durMin, durSec];
    
    WEAK_SELF(self);
    [[KMMGetURLFileLengthTool shareInstance] getUrlFileLength:path withResultBlock:^(long long length, NSError *error) {
        STRONG_SELF(self);
        self.netTipsView.sizeLb.text = [NSString stringWithFormat:@"流量 约%zdMB",length/1000/1000];
    }];
}


#pragma mark - NET

#pragma mark - 获取详情
- (void)requestCourseDetail
{
    
    [HTTPTool requestWithMaintenanceURLString:@"api/Course/BatGetInfo" parameters:@{@"id":self.ID} type:kGET success:^(id responseObject) {
        
        self.detailInfomodel = [BATTrainStudioCourseDetailModel mj_objectWithKeyValues:responseObject];
        
        if (self.detailInfomodel.ResultCode == 0) {
            
            [self.videoView configData:self.detailInfomodel];
            
            
            if (!self.isWIFI) {
                [self getVideoInfoWithSourcePath:[self.detailInfomodel.Data.AttachmentUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                [self.videoView.playerView pause];
            } else {
                [self.videoView.playerView autoPlayTheVideo];
            }
            
            [self.courseDetailTableView reloadData];
        }
        
    } failure:^(NSError *error) {
        [self.defaultView showDefaultView];
    }];
    
//    [HTTPTool requestWithURLString:@"/api/Doctor/GetDoctorVideoCourseDetail" parameters:@{@"ID":self.courseID} type:kGET success:^(id responseObject) {
//        
//        self.detailInfomodel = [BATTrainStudioCourseDetailModel mj_objectWithKeyValues:responseObject];
//        
//        if (self.detailInfomodel.ResultCode == 0) {
//            [self.videoView configData:self.detailInfomodel];
//            
//            if (!self.isWIFI) {
//                [self.videoView.playerView pause];
//            }
//            
//            [self.courseDetailTableView reloadData];
//        }
//        
//    } failure:^(NSError *error) {
//        
//        [self.defaultView showDefaultView];
//    }];
    
}

#pragma mark - pageLayout
- (void)pageLayout
{
    
    [self.view addSubview:self.videoView];
    [self.view addSubview:self.courseDetailTableView];
    [self.view addSubview:self.defaultView];
    [self.view addSubview:self.netTipsView];
    
    WEAK_SELF(self);
    
    [self.videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.right.equalTo(self.view);
//        make.top.equalTo(self.view.mas_top).offset(0);
        if (iPhoneX) {
            make.top.equalTo(self.mas_topLayoutGuideBottom);
        }
        else {
            make.top.equalTo(@0);
        }
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(SCREEN_WIDTH/16*9);
    }];
    
    [self.netTipsView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(SCREEN_WIDTH/16*9);
    }];
    
    [self.courseDetailTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(self.videoView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.bottom.right.left.top.equalTo(self.view);
    }];
}

#pragma mark - get & set

- (BATTrainStudioCourseDetailInfoView *)videoView
{
    if (!_videoView) {
        _videoView = [[BATTrainStudioCourseDetailInfoView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 68 + 9 * SCREEN_WIDTH / 16)];
        
        WEAK_SELF(self);
        [_videoView setCilckBackBlock:^{
            STRONG_SELF(self);
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    
   return _videoView;
}

- (UITableView *)courseDetailTableView
{
    if (!_courseDetailTableView) {
        _courseDetailTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _courseDetailTableView.rowHeight = UITableViewAutomaticDimension;
        _courseDetailTableView.estimatedRowHeight = 50;
        
        _courseDetailTableView.tableFooterView = [[UIView alloc] init];
        _courseDetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _courseDetailTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _courseDetailTableView.delegate = self;
        _courseDetailTableView.dataSource = self;
        
    }
    return _courseDetailTableView;
}

- (KMMNetTipsView *)netTipsView
{
    if (_netTipsView == nil) {
        _netTipsView = (KMMNetTipsView *)[[NSBundle mainBundle] loadNibNamed:@"KMMNetTipsView" owner:self options:nil].firstObject;
        _netTipsView.hidden = YES;
//        _netTipsView.messageLb.text = @"当前网络环境是非wifi状态，播放视频可能要耗费4G/3G/2G流量，确定播放？";
        
        WEAK_SELF(self);
        _netTipsView.playBlock = ^{
            STRONG_SELF(self);
            self.netTipsView.hidden = YES;
//            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
            [self.videoView.playerView autoPlayTheVideo];
        };
        
        _netTipsView.backBlock = ^{
            STRONG_SELF(self);
            [self.navigationController popViewControllerAnimated:YES];
        };
    }
    return _netTipsView;
}

- (BATDefaultView *)defaultView
{
    if (!_defaultView) {
        _defaultView = [[BATDefaultView alloc]initWithFrame:CGRectZero];
        _defaultView.hidden = YES;
        WEAK_SELF(self);
        [_defaultView setReloadRequestBlock:^{
            STRONG_SELF(self);
            DDLogInfo(@"=====重新开始加载！=====");
            self.defaultView.hidden = YES;
            [self requestCourseDetail];
            
        }];
        
    }
    return _defaultView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
