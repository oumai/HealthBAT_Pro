//
//  BATCourseReplyTableView.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/2/24.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATTopicReplyTableView.h"
#import "BATTopicReplyCellTableViewCell.h"

@interface BATTopicReplyTableView () <UITableViewDelegate,UITableViewDataSource>


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

@implementation BATTopicReplyTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _dataSource = [NSMutableArray array];
        
        [self pageLayout];
        
        [self.tableView registerClass:[BATTopicReplyCellTableViewCell class] forCellReuseIdentifier:@"BATCourseReplyCommentCell"];
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
    
    //    [self setNeedsLayout];
    //     [self layoutIfNeeded];
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
        secondReplyData *comment = _dataSource[indexPath.row];
        return comment.commentHeight;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BATTopicReplyCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATCourseReplyCommentCell" forIndexPath:indexPath];
    if (_dataSource.count > 0) {
        secondReplyData *comment = _dataSource[indexPath.row];
        cell.indexPath = indexPath;
        [cell confirgationCell:comment];
        
        //        //长按出现menu菜单
        //        UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(cellLongPress:)];
        //        longPressGestureRecognizer.minimumPressDuration = 2.0f;
        //        [cell addGestureRecognizer:longPressGestureRecognizer];
        //
        //        WEAK_SELF(self)
        //        cell.clickUser = ^(NSIndexPath *cellIndexPath) {
        //            //点击评论中的UserName
        //            STRONG_SELF(self);
        //            //            if (_delegate && [_delegate respondsToSelector:@selector(commentTableView:clickedUser:comments:)]) {
        //            //                [_delegate commentTableView:self clickedUser:cellIndexPath comments:comment];
        //            //            }
        //        };
        
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    [_menu setMenuVisible:NO animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    
    if (self.topicreplyCommentAction) {
        secondReplyData *comment = _dataSource[indexPath.row];
        self.topicreplyCommentAction(indexPath,comment,self.parentLevelId);
    }
    
//        if (_delegate && [_delegate respondsToSelector:@selector(commentTableView:reply:comments:)]) {
//            BATComments *comment = _dataSource[indexPath.row];
//            [_delegate commentTableView:self reply:indexPath comments:comment];
//        }
}

//- (CGSize)systemLayoutSizeFittingSize:(CGSize)targetSize withHorizontalFittingPriority:(UILayoutPriority)horizontalFittingPriority verticalFittingPriority:(UILayoutPriority)verticalFittingPriority
//{
//    self.tableView.frame = CGRectMake(0, 0, targetSize.width, MAXFLOAT);
//
//    return [self.tableView contentSize];
//}

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
