//
//  BATHealthThreeSecondStatisTableView.m
//  HealthBAT_Pro
//
//  Created by Carbon on 2017/12/12.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHealthThreeSecondStatisTableView.h"
#import "BATHealthThreeSecondsStatisCell.h"
#import "BATTableViewPlaceHolder.h"
#import "BATEmptyDataView.h"
@interface BATHealthThreeSecondStatisTableView ()
<
UITableViewDelegate,
UITableViewDataSource,
BATTableViewPlaceHolderDelegate
>
@property (nonatomic ,strong)   BATHealthThreeSecondStatisticsModel                *statisticsModel;
@property (nonatomic ,strong)   BATEmptyDataView                                   *emptyDataView;
@property (nonatomic ,strong)   NSMutableArray                                     *animateStatusArray;//处理cell复用会重新绘制折线图的动画
@property (nonatomic ,copy)     NSArray                                            *dataArray;
@property (nonatomic ,copy)     NSArray                                            *nameArray;
@end

@implementation BATHealthThreeSecondStatisTableView

- (instancetype)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithFrame:CGRectZero style:style]) {
        [self setupUI];
    }
    return self;
}

#pragma mark -- private
- (void)setupUI {
    self.delegate = self;
    self.dataSource = self;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mj_header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    [self registerClass:[BATHealthThreeSecondsStatisCell class] forCellReuseIdentifier:BATHealthThreeSecondsStatisCellIdentifier];
}

- (void)updateDataWith:(BATHealthThreeSecondStatisticsModel *)statisticsModel {
    if (statisticsModel) {
        _statisticsModel = statisticsModel;
        [self setupDataWith:statisticsModel];
    }
    [self bat_reloadData];
}

- (void)headerRefresh {
    if (self.bat_Delegate && [self.bat_Delegate respondsToSelector:@selector(healthThreeSecondStatisTableViewHeaderRefresh:)]) {
        [self.bat_Delegate healthThreeSecondStatisTableViewHeaderRefresh:self];
    }
}

- (void)setupDataWith:(BATHealthThreeSecondStatisticsModel *)statisticsModel {
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    NSMutableArray *nameArray = [[NSMutableArray alloc] init];
    [dataArray addObject:statisticsModel.DietData];
    [nameArray addObject:@"摄入卡路里"];
    [dataArray addObject:statisticsModel.DrinkData];
    [nameArray addObject:@"喝水杯数"];
    [dataArray addObject:statisticsModel.SleepData];
    [nameArray addObject:@"睡眠时间"];
    [dataArray addObject:statisticsModel.StepsData];
    [nameArray addObject:@"行走步数"];
    self.dataArray = dataArray;
    self.nameArray = nameArray;
    [self.animateStatusArray removeAllObjects];
}

#pragma mark -- UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BATHealthThreeSecondsStatisCell *statisCell = [tableView dequeueReusableCellWithIdentifier:BATHealthThreeSecondsStatisCellIdentifier forIndexPath:indexPath];
    NSNumber *b = [self.animateStatusArray objectWithIndex:indexPath.row];
    BOOL animate = NO;
    if (!b) {
        if (![self.animateStatusArray containsObject:@(indexPath.row+1)]) {
            [self.animateStatusArray addObject:@(indexPath.row+1)];
        }
        animate = [[self.animateStatusArray objectWithIndex:indexPath.row] integerValue];
    }
    [statisCell setupDataWith:[self.dataArray objectWithIndex:indexPath.row]
                    indexPath:indexPath
                    nameArray:self.nameArray
                      animate:animate];
    return statisCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [BATHealthThreeSecondsStatisCell getHeight];
}

#pragma mark -- BATTableViewPlaceHolderDelegate
- (UIView *)makePlaceHolderView{
    if (!_emptyDataView) {
        WeakSelf
        _emptyDataView = [[BATEmptyDataView alloc]initWithFrame:self.bounds];
        _emptyDataView.reloadRequestBlock = ^{
            if (_emptyDataView != nil) {
                [weakSelf.emptyDataView removeFromSuperview];
            }
            [weakSelf.mj_header beginRefreshing];
        };
    }
    return _emptyDataView;
}

#pragma mark -- setter & getter
- (NSMutableArray *)animateStatusArray {
    if (!_animateStatusArray) {
        _animateStatusArray = [[NSMutableArray alloc] init];
    }
    return _animateStatusArray;
}

@end
