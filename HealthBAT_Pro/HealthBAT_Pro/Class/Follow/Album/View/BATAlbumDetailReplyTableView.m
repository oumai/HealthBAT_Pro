//
//  BATAlbumDetailReplyTableView.m
//  HealthBAT_Pro
//
//  Created by four on 2017/6/13.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATAlbumDetailReplyTableView.h"

#import "BATAlbumDetailCommentCell.h"

@interface BATAlbumDetailReplyTableView () <UITableViewDelegate,UITableViewDataSource>

/**
 *  数据源
 */
@property (nonatomic,strong) NSMutableArray *dataSource;

/**
 *  菜单
 */
@property (nonatomic,strong) UIMenuController *menu;

/**
 *  长按选中的行
 */
@property (nonatomic,strong) NSIndexPath *selectIndexPath;

@end

@implementation BATAlbumDetailReplyTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _dataSource = [NSMutableArray array];
        
        [self pageLayout];
        
        [self.tableView registerClass:[BATAlbumDetailCommentCell class] forCellReuseIdentifier:@"BATAlbumDetailCommentCell"];
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

#pragma mark - Action
- (void)loadCommentsData:(NSArray *)comments
{
    [_dataSource removeAllObjects];
    [_dataSource addObjectsFromArray:comments];
    [self.tableView reloadData];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dataSource.count > 0) {
        BATAlbumDetailCommentData *comment = _dataSource[indexPath.row];
        return comment.commentHeight;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BATAlbumDetailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATAlbumDetailCommentCell" forIndexPath:indexPath];
    if (_dataSource.count > 0) {
        BATAlbumDetailCommentData *comment = _dataSource[indexPath.row];
        cell.indexPath = indexPath;
        [cell confirgationCell:comment];
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.replyCommentAction) {
        BATAlbumDetailCommentData *comment = _dataSource[indexPath.row];
        self.replyCommentAction(indexPath,comment,self.parentLevelId);
    }
    
}


#pragma mark - pageLayout
- (void)pageLayout
{
    [self addSubview:self.tableView];
    
    WEAK_SELF(self);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self);
    }];
}


#pragma mark - get & set
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = UIColorFromRGB(236, 236, 236,1);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}

@end
