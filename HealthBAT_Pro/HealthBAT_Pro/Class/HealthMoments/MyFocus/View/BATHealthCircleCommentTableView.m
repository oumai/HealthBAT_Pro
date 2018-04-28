//
//  BATHealthCircleCommentTableView.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/24.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATHealthCircleCommentTableView.h"
#import "BATHealthCircleCommentTableViewCell.h"

@interface BATHealthCircleCommentTableView () <UITableViewDelegate,UITableViewDataSource>

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

@implementation BATHealthCircleCommentTableView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    
    _dataSource = [NSMutableArray array];
    
    _tableView = [[UITableView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = UIColorFromRGB(236, 236, 236,1);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.scrollEnabled = NO;
    [self addSubview:_tableView];
    
    [_tableView registerNib:[UINib nibWithNibName:@"BATHealthCircleCommentTableViewCell" bundle:nil] forCellReuseIdentifier:@"BATHealthCircleCommentTableViewCell"];
    
    UIMenuItem *copyMenuItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(handleCopyCell:)];
    
    UIMenuItem *deleteMenuItem = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(handleDeleteCell:)];
    
    _menu = [UIMenuController sharedMenuController];
    [_menu setMenuItems:[NSArray arrayWithObjects:copyMenuItem, deleteMenuItem,  nil]];
    
    [self setupConstraints];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setupConstraints
{
    WEAK_SELF(self);
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self);
    }];
}

#pragma mark - Action
- (void)loadCommentsData:(NSArray *)comments
{
    [_dataSource removeAllObjects];
    [_dataSource addObjectsFromArray:comments];
    [_tableView reloadData];
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
        BATComments *comment = _dataSource[indexPath.row];
        return comment.commentHeight;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BATHealthCircleCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATHealthCircleCommentTableViewCell" forIndexPath:indexPath];
    if (_dataSource.count > 0) {
        BATComments *comment = _dataSource[indexPath.row];
        cell.indexPath = indexPath;
        [cell confirgationCell:comment];
        
        //长按出现menu菜单
        UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(cellLongPress:)];
        longPressGestureRecognizer.minimumPressDuration = 2.0f;
        [cell addGestureRecognizer:longPressGestureRecognizer];
        
        WEAK_SELF(self)
        cell.clickUser = ^(NSIndexPath *cellIndexPath) {
            //点击评论中的UserName
            STRONG_SELF(self);
            if (_delegate && [_delegate respondsToSelector:@selector(commentTableView:clickedUser:comments:)]) {
                [_delegate commentTableView:self clickedUser:cellIndexPath comments:comment];
            }
        };
        
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_menu setMenuVisible:NO animated:YES];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_delegate && [_delegate respondsToSelector:@selector(commentTableView:reply:comments:)]) {
        BATComments *comment = _dataSource[indexPath.row];
        [_delegate commentTableView:self reply:indexPath comments:comment];
    }
}


#pragma mark - Action
- (void)cellLongPress:(UILongPressGestureRecognizer *)longPressGestureRecognizer
{
    //注释menu菜单
//    if (longPressGestureRecognizer.state == UIGestureRecognizerStateBegan) {
//        
//        BATHealthCircleCommentTableViewCell *cell = (BATHealthCircleCommentTableViewCell *)longPressGestureRecognizer.view;
//        
//        _selectIndexPath = [_tableView indexPathForCell:cell];
//        
//        [cell becomeFirstResponder];
//        
//        [_menu setTargetRect:cell.frame inView:self];
//        [_menu setMenuVisible:YES animated:YES];
//
//    }
}

- (void)handleCopyCell:(UIMenuItem *)menuItem
{
    BATComments *comment = _dataSource[_selectIndexPath.row];
    [UIPasteboard generalPasteboard].string = comment.CommentContent;
}

- (void)handleDeleteCell:(UIMenuItem *)menuItem
{
    if (_delegate && [_delegate respondsToSelector:@selector(commentTableView:delete:comments:)]) {
        BATComments *comment = _dataSource[_selectIndexPath.row];
        [_delegate commentTableView:self delete:_selectIndexPath comments:comment];
    }
}

@end
