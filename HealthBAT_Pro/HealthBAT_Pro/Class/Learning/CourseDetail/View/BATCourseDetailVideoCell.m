//
//  BATCourseDetailVideoCell.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/2/23.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATCourseDetailVideoCell.h"

@interface BATCourseDetailVideoCell () <ZFPlayerDelegate>

@end

@implementation BATCourseDetailVideoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self pageLayout];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - ZFPlayerDelegate
- (void)zf_playerBackAction
{
   
}

- (void)configData:(BATCourseDetailModel *)courseDetailModel
{
    ZFPlayerModel *model = [[ZFPlayerModel alloc] init];
    model.title = courseDetailModel.Data.Topic;
    model.placeholderImageURLString = courseDetailModel.Data.Poster;
    model.videoURL = [NSURL URLWithString:courseDetailModel.Data.AttachmentUrl];
    model.fatherView = self.fatherView;
    
    [self.playerView playerControlView:nil playerModel:model];
    
    self.playerView.hasPreviewView = YES;
    
    // 自动播放
    [self.playerView autoPlayTheVideo];
}

#pragma mark - pageLayout
- (void)pageLayout
{
    [self.contentView addSubview:self.fatherView];
    
    WEAK_SELF(self);
    [self.fatherView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self.contentView);
    }];
}

#pragma mark - get & set
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
        _playerView.delegate = self;
        
    }
    return _playerView;
}

@end
