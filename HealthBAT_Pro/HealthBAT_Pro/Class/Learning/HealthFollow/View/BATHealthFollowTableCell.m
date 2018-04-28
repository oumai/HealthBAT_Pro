//
//  BATHealthFollowTableCell.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/2/21.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHealthFollowTableCell.h"
#import "BATHealthFollowContentCell.h"
#import "BATCourseModel.h"
#import "UIScrollView+EmptyDataSet.h"

@interface BATHealthFollowTableCell () <UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>


@property (nonatomic,assign) NSInteger pageSize;

@end

@implementation BATHealthFollowTableCell

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self pageLayout];
        
        _canScroll = NO;
        
        _pageSize = 10;
        _pageIndex = 0;
        
        _dataSource = [NSMutableArray array];
        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(canScoll:) name:@"BATHealthFollowTableCellTableCanScrollNotification" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeReadNum:) name:@"BATChangeReadNumNotification" object:nil];
    }
    return self;
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
    return 101;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BATHealthFollowContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATHealthFollowContentCell" forIndexPath:indexPath];
    
    if (_dataSource.count > 0) {
        
        BATCourseData *courseData = _dataSource[indexPath.row];
        
        [cell confirgationCell:courseData];
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.courseClicked) {
        BATCourseData *courseData = _dataSource[indexPath.row];
        self.courseClicked(courseData);
    }
}

#pragma mark - DZNEmptyDataSetSource
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    
    return [UIImage imageNamed:@"无数据"];
}

//返回标题文字
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f], NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

//返回详情文字
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSString *text = BAT_NO_DATA;
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:16.0f], NSForegroundColorAttributeName: [UIColor lightGrayColor], NSParagraphStyleAttributeName: paragraph};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    
    return -50;
    //    return -(SCREEN_HEIGHT-64-40-49)/2.0 + 50;
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    DDLogDebug(@"%@",NSStringFromCGRect(self.tableView.frame));
    if (!self.canScroll) {
        [self.tableView setContentOffset:CGPointZero animated:NO];
        return;
    }
    
    if (scrollView.contentOffset.y < 0 && self.canScroll) {
        self.canScroll = NO;
        [self.tableView setContentOffset:CGPointZero animated:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HealthFollowViewCanScrollNotification" object:nil];
        return;
    }
    
}

#pragma mark - 获取某种特色课程列表
- (void)requestSpecialtyTopicList:(void (^)(BOOL))complete
{
    
    [HTTPTool requestWithURLString:@"/api/TrainingTeacher/GetCourseList" parameters:@{@"keyword":@"",@"pageIndex":@(_pageIndex),@"pageSize":@(_pageSize),@"category":@(self.ObjID)} type:kGET success:^(id responseObject) {
        
        [self.tableView.mj_footer endRefreshing];
        
        if (_pageIndex == 0) {
            [_dataSource removeAllObjects];
            if (complete) {
                complete(YES);
            }
        }
        
        BATCourseModel *courseModel = [BATCourseModel mj_objectWithKeyValues:responseObject];
        
        [_dataSource addObjectsFromArray:courseModel.Data];
        
        if (courseModel.RecordsCount > 0) {
            self.tableView.mj_footer.hidden = NO;
        } else {
            self.tableView.mj_footer.hidden = YES;
        }
        
        if (_dataSource.count == courseModel.RecordsCount) {
            self.tableView.mj_footer.hidden = YES;
        }
        
        [self.tableView reloadData];
        
        
    } failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        _pageIndex--;
        if (_pageIndex < 0) {
            _pageIndex = 0;
        }
        
    }];
}


#pragma mark - Action
//- (void)canScoll:(NSNotification *)notif
//{
//    self.canScroll = YES;
//}

- (void)changeReadNum:(NSNotification *)notif
{
    NSDictionary *dic = [notif object];
    
    NSInteger category = [dic[@"category"] integerValue];
    NSInteger courseID = [dic[@"courseID"] integerValue];
    NSInteger readNum = [dic[@"ReadingNum"] integerValue];
    
    if (category == self.ObjID) {
        for (int i = 0; i < _dataSource.count; i++) {
            BATCourseData *courseData = _dataSource[i];
            if (courseData.ID == courseID) {
                courseData.ReadingNum = readNum;
                [_dataSource replaceObjectAtIndex:i withObject:courseData];
                [self.tableView reloadData];
                break;
            }
        }
    }
    

}

#pragma mark - pageLayout
- (void)pageLayout
{
    [self.contentView addSubview:self.tableView];
    WEAK_SELF(self);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self.contentView);
    }];
}

#pragma mark - get & set
- (BATPassTableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[BATPassTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        
        [_tableView registerClass:[BATHealthFollowContentCell class] forCellReuseIdentifier:@"BATHealthFollowContentCell"];
        
        WEAK_SELF(self);
        _tableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.pageIndex++;
            [self requestSpecialtyTopicList:nil];
        }];
        
        _tableView.mj_footer.hidden = YES;
    }
    return _tableView;
}

@end
