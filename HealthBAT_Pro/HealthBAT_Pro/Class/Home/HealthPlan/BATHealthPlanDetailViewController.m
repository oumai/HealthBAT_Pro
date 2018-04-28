//
//  BATHealthPlanDetailViewController.m
//  HealthBAT_Pro
//
//  Created by Skybrim on 2017/3/20.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHealthPlanDetailViewController.h"
#import "BATHealthPlanVideoTableViewCell.h"
#import "BATHealthPlanModel.h"

#import "ZFPlayer.h"

static  NSString * const VIDEO_CELL = @"BATHealthPlanVideoTableViewCell";

@interface BATHealthPlanDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *videoTableView;
@property (nonatomic,strong) BATHealthPlanModel *model;

@property (nonatomic,strong) ZFPlayerControlView *controlView;
@property (nonatomic,strong) ZFPlayerView *playerView;
@property (nonatomic,strong) UIView *fatherView;


@end

@implementation BATHealthPlanDetailViewController

- (void)dealloc {
    
    self.playerView = nil;
    self.controlView = nil;
    self.fatherView = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self pagesLayout];
    [self videoDataRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    HealthPlanVideData *data = self.model.Data[0];
    return data.VideoLst.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BATHealthPlanVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:VIDEO_CELL forIndexPath:indexPath];
    
    HealthPlanVideData *data = self.model.Data[0];
    Video *video = data.VideoLst[indexPath.row];
    
    cell.titleLabel.text = video.VideoName;
    [cell.bigImageView sd_setImageWithURL:[NSURL URLWithString:video.PictureURL] placeholderImage:[UIImage imageNamed:@"默认图"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HealthPlanVideData *data = self.model.Data[0];
    Video *video = data.VideoLst[indexPath.row];
    
    BATHealthPlanVideoTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    ZFPlayerModel *model = [[ZFPlayerModel alloc] init];
    model.title = video.VideoName;
    model.placeholderImageURLString = video.PictureURL;
    model.videoURL = [NSURL URLWithString:[video.VideoAddress stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    model.fatherView = cell.contentView;
    
    [self.playerView playerControlView:self.controlView playerModel:model];
    
    // 自动播放
    [self.playerView autoPlayTheVideo];
    
    [self.controlView fullScreenBtnClick:self.controlView.fullScreenBtn];
    
}

#pragma mark - NET
- (void)videoDataRequest {

    [HTTPTool requestWithURLString:@"/api/HealthManager/GetSportList" parameters:@{@"typeId":@(self.type)} type:kGET success:^(id responseObject) {
        
        self.model = [BATHealthPlanModel mj_objectWithKeyValues:responseObject];
        
        [self.videoTableView reloadData];

    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - pagesLayout
- (void)pagesLayout {
    
    [self.view addSubview:self.videoTableView];
    [self.videoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
}
#pragma mark - getter
- (UITableView *)videoTableView {
    
    if (!_videoTableView) {
        _videoTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        [_videoTableView registerClass:[BATHealthPlanVideoTableViewCell class] forCellReuseIdentifier:VIDEO_CELL];
        _videoTableView.rowHeight = 180;
        
        _videoTableView.delegate = self;
        _videoTableView.dataSource = self;
    }
    return _videoTableView;
}


- (UIView *)fatherView
{
    if (_fatherView == nil) {
        _fatherView = [[UIView alloc] init];
        _fatherView.backgroundColor = [UIColor blackColor];
    }
    return _fatherView;
}

- (ZFPlayerView *)playerView
{
    if (_playerView == nil) {
        _playerView = [[ZFPlayerView alloc] init];
        _playerView.backgroundColor = [UIColor blackColor];
        _playerView.hasPreviewView = YES;

    }
    return _playerView;
}

- (ZFPlayerControlView *)controlView
{
    if (_controlView == nil) {
        _controlView = [[ZFPlayerControlView alloc] init];
        _controlView.backgroundColor = [UIColor blackColor];
        _controlView.isFromHealthPlan = YES;
        WEAK_SELF(self);
        [_controlView setBackBtnClick:^{
            STRONG_SELF(self);

            [self.playerView removeFromSuperview];
            [self.controlView removeFromSuperview];
            self.playerView = nil;
            self.controlView = nil;
        }];
        
        [_controlView setFullScreenBtnClick:^{
            
            STRONG_SELF(self);
            [self.playerView removeFromSuperview];
            [self.controlView removeFromSuperview];
            self.playerView = nil;
            self.controlView = nil;
        }];

    }
    return _controlView;
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
