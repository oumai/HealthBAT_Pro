//
//  BATAlbumDetailView.m
//  HealthBAT_Pro
//
//  Created by four on 2017/6/13.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATAlbumDetailView.h"

@implementation BATAlbumDetailView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self pageLayout];
    }
    return self;
}

#pragma mark - pageLayout
- (void)pageLayout
{
    [self addSubview:self.tableView];
    [self addSubview:self.albumeDetailBottomView];
    
    WEAK_SELF(self);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.right.top.equalTo(self);
    }];
    
    
    [self.albumeDetailBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.right.bottom.equalTo(self);
        make.height.mas_offset(50);
        make.top.equalTo(self.tableView.mas_bottom);
    }];

    
//    self.tableView.tableHeaderView = self.tableHeaderView;
}

#pragma mark - get & set
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _tableView;
}
//- (BATAlbumDetailHeaderView *)tableHeaderView
//{
//    if (_tableHeaderView == nil) {
//        
//        float offsetHeight = 9 * SCREEN_WIDTH / 16;
//        
//        _tableHeaderView = [[BATAlbumDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 68 + offsetHeight)];
//        _tableHeaderView.backgroundColor = [UIColor whiteColor];
//    }
//    return _tableHeaderView;
//}

- (BATAlbumDetailBottomView *)albumeDetailBottomView
{
    if (_albumeDetailBottomView == nil) {
        _albumeDetailBottomView = [[BATAlbumDetailBottomView alloc] init];
        _albumeDetailBottomView.backgroundColor = [UIColor whiteColor];
    }
    return _albumeDetailBottomView;
}


@end
