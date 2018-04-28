//
//  BATDiteGuideMyPhotoViewController.m
//  HealthBAT_Pro
//
//  Created by Carbon on 2017/10/30.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDiteGuideMyPhotoViewController.h"
#import "BATDiteGuideDetailsViewController.h"
#import "BATDiteGuideMyPhotoTableView.h"
@interface BATDiteGuideMyPhotoViewController ()
<
BATDiteGuideMyPhotoTableViewDelegate
>
@property (nonatomic ,weak)   BATDiteGuideMyPhotoTableView                      *myPhotoTableView;
@property (nonatomic ,assign) NSInteger                                         currentPage;
@property (nonatomic ,strong) BATDiteGuideMyPhotoModel                          *myPhotoModel;
@property (nonatomic ,strong) NSMutableArray<BATDiteGuideMyPhotoDataModel *>    *myPhotoDataModelArray;
@end

@implementation BATDiteGuideMyPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self.myPhotoTableView.mj_header beginRefreshing];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshMyPhotoDataNotification:)
                                                 name:BATDiteGuideDetailsDeleteNotification
                                               object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BATDiteGuideDetailsDeleteNotification object:nil];
}

#pragma mark -- private
- (void)setupUI {
    self.title = @"我的照片";
    BATDiteGuideMyPhotoTableView *myPhotoTableView = [[BATDiteGuideMyPhotoTableView alloc] initWithStyle:UITableViewStylePlain];
    myPhotoTableView.bat_Delegate = self;
    [self.view addSubview:myPhotoTableView];
    self.myPhotoTableView = myPhotoTableView;
    [self.myPhotoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
    }];
}

- (void)setDataWithMyPhotoModel:(BATDiteGuideMyPhotoModel *)myPhotoModel {
    self.myPhotoModel = myPhotoModel;
    [self.myPhotoDataModelArray addObjectsFromArray:self.myPhotoModel.Data];
    [self.myPhotoTableView.mj_header endRefreshing];
    [self.myPhotoTableView.mj_footer endRefreshing];
    [self.myPhotoTableView setDataWithMyPhotoDataModelArray:self.myPhotoDataModelArray];
}

#pragma mark -- BATDiteGuideMyPhotoTableViewDelegate
- (void)diteGuideMyPhotoTableView:(BATDiteGuideMyPhotoTableView *)photoView didSelectedPhotoDataModel:(BATDiteGuideMyPhotoDataModel *)photoDataModel {
    BATDiteGuideDetailsViewController *diteGuideVC = [[BATDiteGuideDetailsViewController alloc] initWithDataID:photoDataModel.ID accountID:photoDataModel.AccountID showDeleteBtn:YES];
    [self.navigationController pushViewController:diteGuideVC animated:YES];
}

- (void)diteGuideMyPhotoTableViewHeaderRefresh:(BATDiteGuideMyPhotoTableView *)photoView {
    [self.myPhotoDataModelArray removeAllObjects];
    self.currentPage = 0;
    [self myPhotoDataNetworkRequest];
}

- (void)diteGuideMyPhotoTableViewfooterUploadMore:(BATDiteGuideMyPhotoTableView *)photoView {
    if (self.myPhotoDataModelArray.count >= self.myPhotoModel.RecordsCount) {
        [self.myPhotoTableView.mj_footer endRefreshingWithNoMoreData];
    } else {
        self.currentPage ++;
        [self myPhotoDataNetworkRequest];
    }
}

#pragma mark -- network
- (void)myPhotoDataNetworkRequest {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params jk_setObj:@(self.currentPage) forKey:@"pageIndex"];
    [params jk_setObj:@"10" forKey:@"pageSize"];
    [HTTPTool requestWithURLString:@"/api/EatCircle/GetMyPhotoList" parameters:params type:kGET success:^(id responseObject) {
        BATDiteGuideMyPhotoModel *myPhotoModel = [BATDiteGuideMyPhotoModel mj_objectWithKeyValues:responseObject];
        [self setDataWithMyPhotoModel:myPhotoModel];
    } failure:^(NSError *error) {
        [self.myPhotoTableView.mj_header endRefreshing];
        [self.myPhotoTableView.mj_footer endRefreshing];
    }];
}

#pragma mark -- Notification
- (void)refreshMyPhotoDataNotification:(NSNotification *)notify {
    NSString *dataID = (NSString *)notify.object;
    for (BATDiteGuideMyPhotoDataModel *model in self.myPhotoDataModelArray) {
        if ([dataID isEqualToString:model.ID]) {
            [self.myPhotoDataModelArray removeObject:model];
            [self.myPhotoTableView setDataWithMyPhotoDataModelArray:self.myPhotoDataModelArray];
            break;
        }
    }
}

#pragma mark -- setter && getter
- (NSMutableArray<BATDiteGuideMyPhotoDataModel *> *)myPhotoDataModelArray {
    if (!_myPhotoDataModelArray) {
        _myPhotoDataModelArray = [[NSMutableArray alloc] init];
    }
    return _myPhotoDataModelArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
