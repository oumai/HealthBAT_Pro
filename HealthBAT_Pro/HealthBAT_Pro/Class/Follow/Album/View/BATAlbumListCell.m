//
//  BATAlbumListCell.m
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/6/8.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATAlbumListCell.h"
#import "BATAlbumListModel.h"
@implementation BATAlbumListCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self.contentView addSubview:self.bgImageView];
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

#pragma mark - setter

- (void)setAlbumModel:(BATAlbumListModel *)albumModel{
    
    _albumModel = albumModel;
    
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:albumModel.Poster] placeholderImage:[UIImage imageNamed:@"默认图"]];
    self.titleLabel.text = albumModel.Title;
    
}
#pragma mark - 布局子控件

- (void)layoutSubviews{
    [super layoutSubviews];
    
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.centerY.equalTo(self.mas_centerY);
    }];
}


#pragma mark - lazy load

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:28];
        _titleLabel.textColor =[UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"小李天天说健康";
        _titleLabel.numberOfLines = 0;
        
    }
    return _titleLabel;
}
- (UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc]init];
        
        //按照宽高比拉伸
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImageView.clipsToBounds  = YES;
    }
    return _bgImageView;
}
@end
