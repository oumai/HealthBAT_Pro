//
//  BATDiteGuideDetailsTableView.m
//  HealthBAT_Pro
//
//  Created by Carbon on 2017/10/25.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDiteGuideDetailsTableView.h"
#import "BATDiteGuideDetailsPhotoCell.h"
#import "BATDiteGuideDetailsEnergyCell.h"
#import "BATDiteGuideDetailsSuggestCell.h"
#import "BATDiteGuideDetailsShopCell.h"
#import "BATDiteGuideDetailsPraiseCell.h"

@interface BATDiteGuideDetailsTableView ()
<
UITableViewDelegate,
UITableViewDataSource,
BATDiteGuideDetailsPraiseCellDelegate
>
@property (nonatomic ,strong) BATDiteGuideDetailModel           *diteGuideDetailModel;
@end

@implementation BATDiteGuideDetailsTableView

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
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mj_header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    [self registerClass:[BATDiteGuideDetailsPhotoCell class] forCellReuseIdentifier:BATDiteGuideDetailsPhotoCellIdentifier];
    [self registerClass:[BATDiteGuideDetailsEnergyCell class] forCellReuseIdentifier:BATDiteGuideDetailsEnergyCellIdentifier];
    [self registerClass:[BATDiteGuideDetailsSuggestCell class] forCellReuseIdentifier:BATDiteGuideDetailsSuggestCellIdentifier];
    [self registerClass:[BATDiteGuideDetailsShopCell class] forCellReuseIdentifier:BATDiteGuideDetailsShopCellIdentifier];
    [self registerClass:[BATDiteGuideDetailsPraiseCell class] forCellReuseIdentifier:BATDiteGuideDetailsPraiseCellIdentifier];
}

- (void)loadData {
    if (self.bat_Delegate && [self.bat_Delegate respondsToSelector:@selector(diteGuideDetailsTableViewLoadData:)]) {
        [self.bat_Delegate diteGuideDetailsTableViewLoadData:self];
    }
}

- (void)setDataWithDiteGuideDetailModel:(BATDiteGuideDetailModel *)diteGuideDetailModel {
    self.diteGuideDetailModel = diteGuideDetailModel;
    [self reloadData];
}

- (void)praiseSuccessHandleWith:(BATDiteGuideDetailsPraiseCell *)praiseCell buttonStatus:(BOOL)buttonStatus {
    [[NSNotificationCenter defaultCenter] postNotificationName:BATDiteGuideDetailsPraiseNotification object:self.diteGuideDetailModel.ID];
    [praiseCell setDiteGuideDetailPraiseStarStatus:buttonStatus];//如果成功就不再重新请求模型的数据，直接将点赞数量+1，减少请求和刷新操作，下一次这直接从服务器拉取结果
}

- (UITableViewCell *)tableView:(UITableView *)tableView showCellTypeWithIndexPath:(NSIndexPath *)indexPath {
    if ([self.diteGuideDetailModel.PicToCalories floatValue] <= 0) {
        BATDiteGuideDetailsPraiseCell *praiseCell = [tableView dequeueReusableCellWithIdentifier:BATDiteGuideDetailsPraiseCellIdentifier forIndexPath:indexPath];
        praiseCell.delegate = self;
        [praiseCell setDataDiteGuideDetailModel:self.diteGuideDetailModel];
        return praiseCell;
    } else {
        BATDiteGuideDetailsEnergyCell *energyCell = [tableView dequeueReusableCellWithIdentifier:BATDiteGuideDetailsEnergyCellIdentifier forIndexPath:indexPath];
        [energyCell setDataDiteGuideDetailModel:self.diteGuideDetailModel];
        return energyCell;
    }
}
#pragma mark -- UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.diteGuideDetailModel.PicToCalories floatValue] <= 0) {
        return 2;
    }
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        BATDiteGuideDetailsPhotoCell *photoCell = [tableView dequeueReusableCellWithIdentifier:BATDiteGuideDetailsPhotoCellIdentifier forIndexPath:indexPath];
        [photoCell setDataDiteGuideDetailModel:self.diteGuideDetailModel];
        return photoCell;
    } else if (indexPath.row == 1) {
        return [self tableView:tableView showCellTypeWithIndexPath:indexPath];
    } else if (indexPath.row == 2){
        BATDiteGuideDetailsSuggestCell *suggestCell = [tableView dequeueReusableCellWithIdentifier:BATDiteGuideDetailsSuggestCellIdentifier forIndexPath:indexPath];
        [suggestCell setDataDiteGuideDetailModel:self.diteGuideDetailModel];
        return suggestCell;
    } else if (indexPath.row == 3){
        BATDiteGuideDetailsShopCell *shopCell = [tableView dequeueReusableCellWithIdentifier:BATDiteGuideDetailsShopCellIdentifier forIndexPath:indexPath];
       [shopCell setDataDiteGuideDetailModel:self.diteGuideDetailModel];
        return shopCell;
    } else {
        BATDiteGuideDetailsPraiseCell *praiseCell = [tableView dequeueReusableCellWithIdentifier:BATDiteGuideDetailsPraiseCellIdentifier forIndexPath:indexPath];
        praiseCell.delegate = self;
        [praiseCell setDataDiteGuideDetailModel:self.diteGuideDetailModel];
        return praiseCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3 && self.bat_Delegate &&
        [self.bat_Delegate respondsToSelector:@selector(diteGuideDetailsTableView:diteGuideDetailModel:)]) {
        [self.bat_Delegate diteGuideDetailsTableView:self diteGuideDetailModel:self.diteGuideDetailModel];
    }
}
#pragma mark -- BATDiteGuideDetailsPraiseCellDelegate
- (void)diteGuideDetailsPraiseCell:(BATDiteGuideDetailsPraiseCell *)praiseCell diteGuideDetailModel:(BATDiteGuideDetailModel *)diteGuideDetailModel buttonStatus:(BOOL)buttonStatus {
    NSString *starUrlStr = buttonStatus? @"/api/EatCircle/EatCircleSetStar" : @"/api/EatCircle/CanelEatCircleSetStar";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params jk_setObj:@"4" forKey:@"RelationType"];
    [params jk_setObj:diteGuideDetailModel.ID forKey:@"RelationID"];
    [HTTPTool requestWithURLString:starUrlStr parameters:params type:kPOST success:^(id responseObject) {
        NSInteger resultCode = [[responseObject valueForKey:@"ResultCode"] integerValue];
        if (resultCode == 0) {
            [self praiseSuccessHandleWith:praiseCell buttonStatus:buttonStatus];
        }
    } failure:^(NSError *error) {
    }];
}


@end
