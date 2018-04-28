//
//  BATAlbumDetailCourseSectionCell.m
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/9/19.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATAlbumDetailCourseSectionCell.h"
#import "BATAlbumDetailModel.h"

@interface BATAlbumDetailCourseSectionCell ()
/** <#属性描述#> */
@property (nonatomic, strong) UILabel *courseNameLabel;

@end

@implementation BATAlbumDetailCourseSectionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self.contentView addSubview:self.courseNameLabel];
        [self.contentView addSubview:self.circleButton];
        [self.contentView addSubview:self.circleTopView];
        [self.contentView addSubview:self.circleBottomView];
        [self.contentView addSubview:self.videoImageButton];
        
    }
    return self;
}
- (void)setDateWith:(BATAlbumDetailModel *)albumDetailModel indexPath:(NSIndexPath *)indexPath selctedVideoID:(NSString *)selctedVideoID{
    
    BATAlbumProjectVideoData *data = albumDetailModel.Data.ProjectVideoList[indexPath.row-1];
    self.courseNameLabel.text = data.Name;
    
    self.circleTopView.hidden = indexPath.row == 1 ? YES : NO;
    self.circleBottomView.hidden = ((indexPath.row) == albumDetailModel.Data.ProjectVideoList.count) ? YES : NO;
    
    if ([selctedVideoID isEqualToString:[NSString stringWithFormat:@"%ld",(long)data.VideoID]]) {
        self.circleButton.selected = YES;
        self.videoImageButton.selected = self.circleButton.selected;
        self.courseNameLabel.textColor = UIColorFromHEX(0x29ccbf, 1);
    }else{
        self.circleButton.selected = NO;
        self.videoImageButton.selected = self.circleButton.selected;
        self.courseNameLabel.textColor = UIColorFromHEX(0x333333, 1);
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    
    [self.circleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.height.mas_equalTo(12);
        make.left.mas_equalTo(43/2);
    }];
    
    [self.videoImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.circleButton.mas_right).offset(10);
        make.centerY.mas_equalTo(self.circleButton.mas_centerY);
    }];
    
    
    [self.circleTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(self.circleButton.mas_top);
        make.width.mas_equalTo(1);
        make.centerX.mas_equalTo(self.circleButton.mas_centerX);
    }];
    
  
    [self.circleBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.circleButton.mas_bottom);
        make.centerX.mas_equalTo(self.circleButton.mas_centerX);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(1);
    }];
    
    
    [self.courseNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       make.centerY.mas_equalTo(self.mas_centerY);
       make.left.mas_equalTo(self.videoImageButton.mas_right).offset(7.5);
    }];
    
    
}
- (UIButton *)videoImageButton{
    if (!_videoImageButton) {
        _videoImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_videoImageButton setImage:[UIImage imageNamed:@"playing"] forState:UIControlStateSelected];
        [_videoImageButton setImage:[UIImage imageNamed:@"playwill"] forState:UIControlStateNormal];
    }
    return _videoImageButton;
}
- (UILabel *)courseNameLabel{
    if (!_courseNameLabel) {
        _courseNameLabel = [[UILabel alloc]init];
        _courseNameLabel.textColor = UIColorFromHEX(0x333333, 1);
        _courseNameLabel.font = [UIFont systemFontOfSize:15];
        
    }
    return _courseNameLabel;
}
- (UIView *)circleButton{
    if (!_circleButton) {
        _circleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_circleButton setImage:[UIImage imageNamed:@"round_pre"] forState:UIControlStateNormal];
        [_circleButton setImage:[UIImage imageNamed:@"round_playing"] forState:UIControlStateSelected];
    }
    return _circleButton;
}
- (UIView *)circleTopView{
    if (!_circleTopView) {
        _circleTopView = [[UIView alloc]init];
        _circleTopView.backgroundColor = UIColorFromHEX(0x29ccbf, 1);
    }
    return _circleTopView;
}


- (UIView *)circleBottomView{
    if (!_circleBottomView) {
        _circleBottomView = [[UIView alloc]init];
        _circleBottomView.backgroundColor = UIColorFromHEX(0x29ccbf, 1);
    }
    return _circleBottomView;
}




@end
