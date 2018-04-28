//
//  BATDiteGuideMyPhotoTableView.m
//  HealthBAT_Pro
//
//  Created by Carbon on 2017/10/30.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDiteGuideMyPhotoTableView.h"
#import "BATDiteGuideMyPhotoCell.h"
#import "BATTableViewPlaceHolder.h"
#import "BATEmptyDataView.h"
@interface BATDiteGuideMyPhotoTableView ()
<
UITableViewDelegate,
UITableViewDataSource,
BATTableViewPlaceHolderDelegate
>
@property (nonatomic ,copy)   NSArray<BATDiteGuideMyPhotoDataModel *>     *myPhotoDataModelArray;
@property (nonatomic, strong) BATEmptyDataView                            *emptyDataView;
@end

@implementation BATDiteGuideMyPhotoTableView
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
    self.estimatedRowHeight = 80;
    self.rowHeight = UITableViewAutomaticDimension;
    self.backgroundColor = UIColorFromRGB(245, 245, 245, 1);
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mj_header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    self.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerUploadMore)];
    [self registerClass:[BATDiteGuideMyPhotoCell class] forCellReuseIdentifier:BATDiteGuideMyPhotoCellIdentifier];
}

- (void)configureCell:(BATDiteGuideMyPhotoCell *)photoCell atIndexPath:(NSIndexPath *)indexPath {
    BATDiteGuideMyPhotoDataModel *myPhotoDataModel = [self.myPhotoDataModelArray objectWithIndex:indexPath.row];
    [photoCell setMyPhotoDataModel:myPhotoDataModel];
}

- (void)setDataWithMyPhotoDataModelArray:(NSArray<BATDiteGuideMyPhotoDataModel *> *)myPhotoDataModelArray {
    self.myPhotoDataModelArray = myPhotoDataModelArray;
    [self bat_reloadData];
}
#pragma mark -- action
- (void)headerRefresh {
    if (self.bat_Delegate && [self.bat_Delegate respondsToSelector:@selector(diteGuideMyPhotoTableViewHeaderRefresh:)]) {
        [self.bat_Delegate diteGuideMyPhotoTableViewHeaderRefresh:self];
    }
}

- (void)footerUploadMore {
    if (self.bat_Delegate && [self.bat_Delegate respondsToSelector:@selector(diteGuideMyPhotoTableViewfooterUploadMore:)]) {
        [self.bat_Delegate diteGuideMyPhotoTableViewfooterUploadMore:self];
    }
}
#pragma mark -- UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.myPhotoDataModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BATDiteGuideMyPhotoCell *photoCell = [tableView dequeueReusableCellWithIdentifier:BATDiteGuideMyPhotoCellIdentifier forIndexPath:indexPath];
    [self configureCell:photoCell atIndexPath:indexPath];
    return photoCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BATDiteGuideMyPhotoDataModel *myPhotoDataModel = [self.myPhotoDataModelArray objectWithIndex:indexPath.row];
    if (self.bat_Delegate && [self.bat_Delegate respondsToSelector:@selector(diteGuideMyPhotoTableView:didSelectedPhotoDataModel:)]) {
        [self.bat_Delegate diteGuideMyPhotoTableView:self didSelectedPhotoDataModel:myPhotoDataModel];
    }
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
#pragma mark -- getter & setter

@end
