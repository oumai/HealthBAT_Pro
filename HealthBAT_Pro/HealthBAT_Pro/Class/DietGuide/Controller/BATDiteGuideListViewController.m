//
//  BATDiteGuideListViewController.m
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/10/23.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDiteGuideListViewController.h"
#import "BATPhotoPickerListViewController.h"
#import "BATDiteGuideDetailsViewController.h"
#import "BATDiteGuideListCell.h"
#import "BATTableViewPlaceHolder.h"
#import "BATEmptyDataView.h"
#import "BATDiteGuideListModel.h"

static NSString *const DiteGuideListCellID = @"BATDiteGuideListCell";

@interface BATDiteGuideListViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, BATTableViewPlaceHolderDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<BATDiteGuideListModel *> *dataSource;
/** 页码大小 */
@property (nonatomic, assign) NSInteger  pageSize;
/**  当前页码*/
@property (nonatomic, assign) NSInteger  currentPage;
/** 无数据占位 view */
@property (nonatomic, strong) BATEmptyDataView *emptyDataView;
@end

@implementation BATDiteGuideListViewController
- (void)dealloc{
    
    DDLogDebug(@"=====BATDiteGuideListViewController--delloc===");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    [self setupUI];
    [self setupRefresh];
    [self addNotification];
    
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}


- (void)setupUI{
    
    [self.view addSubview:self.collectionView];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)addNotification{
    
    //详情界面删除饮食记录
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(headerRefreshRequest) name:BATDiteGuideDetailsDeleteNotification object:nil];
    
     //发布成功类别页刷新数据
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(headerRefreshRequest) name:BATDiteGuideEditPushSuccessNotification object:nil];
    
}

- (void)setupNav{
    
    self.title = @"吃货圈";
    
    UIButton *cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cameraButton setImage:[UIImage imageNamed:@"DietGuide_Camera_Nav"] forState:UIControlStateNormal];
    cameraButton.frame =CGRectMake(0, 0, 30, 30);
    [cameraButton addTarget:self action:@selector(cameraButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:cameraButton];
}
- (void)cameraButtonClick{
    
    // 相册
    BATPhotoPickerListViewController *photoPickerListVC = [[BATPhotoPickerListViewController alloc]init];
    photoPickerListVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:photoPickerListVC animated:YES];
    NSLog(@"点击了照相机按钮");
    
}

#pragma mark - setupRefresh
/**
 集成刷新控件
 */
- (void)setupRefresh{
    
    self.collectionView.mj_header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshRequest)];
    
    self.collectionView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshRequest)];
    
    _pageSize = 10;
    
    [self.collectionView.mj_header beginRefreshing];
    
}

/**
 头部刷新调用
 */
- (void)headerRefreshRequest{
    _currentPage = 0;
    [self.collectionView.mj_footer endRefreshing];
    
    [self loadDataRequest];
}

/**
 尾部刷新调用
 */
- (void)footerRefreshRequest{
    _currentPage ++ ;
    [self.collectionView.mj_header endRefreshing];
    
    [self loadDataRequest];
}


#pragma mark - Request
- (void)loadDataRequest{
    
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    dictM[@"pageIndex"] = @(_currentPage);
    dictM[@"pageSize"] = @(_pageSize);
    WeakSelf
    [HTTPTool requestWithURLString:@"api/EatCircle/GetEatCircleList" parameters:dictM type:kGET success:^(id responseObject) {
        
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
        
        if (_currentPage == 0) {
            [weakSelf.dataSource removeAllObjects];
        }
        
        DDLogDebug(@"---------%@",responseObject);
        
        NSArray *moreData =  [BATDiteGuideListModel mj_objectArrayWithKeyValuesArray:responseObject[@"Data"]];
        
        [weakSelf.dataSource addObjectsFromArray:moreData];
        
        if (moreData.count < _pageSize) {
            [weakSelf.collectionView.mj_footer setHidden:YES];
        }else{
            [weakSelf.collectionView.mj_footer setHidden:NO];
        }
        
        [weakSelf.collectionView bat_reloadData];
        
        
    } failure:^(NSError *error) {
        [weakSelf.collectionView.mj_footer endRefreshing];
        [weakSelf.collectionView.mj_header endRefreshing];
        
        //请求失败显示占位视图
        [weakSelf.collectionView bat_reloadData];
        
    }];
    
    
}
//点赞/取消点赞
- (void)thumbsUpRequestWith:(BATDiteGuideListModel *)model
                      upBtn:(UIButton *)likeBtn
                  IndexPath:(NSIndexPath *)indexPath{
    
    if (!LOGIN_STATION) {
        PRESENT_LOGIN_VC;
        return;
    }
    
    NSString *cancelOperationURL = @"api/EatCircle/CanelEatCircleSetStar";
    NSString *executeOperationURL = @"api/EatCircle/EatCircleSetStar";
    NSString *operationURL = model.IsSetStar ? cancelOperationURL : executeOperationURL;
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    dictM[@"RelationType"] = @(4); //饮食指南点赞为4，固定
    dictM[@"RelationID"] = model.ID;
    
    WeakSelf
    [HTTPTool requestWithURLString:operationURL parameters:dictM type:kPOST success:^(id responseObject) {
        
        model.SetStarNum = likeBtn.selected ? (model.SetStarNum - 1) : (model.SetStarNum + 1);
        model.IsSetStar = !model.IsSetStar;
        
        [weakSelf.collectionView reloadItemsAtIndexPaths:@[indexPath]];
        
        
    } failure:^(NSError *error) {
                                    
        
         DDLogDebug(@"%@===",error);
    }];
}
#pragma mark - UITabelViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  self.dataSource.count;
}

- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BATDiteGuideListModel *model = self.dataSource[indexPath.row];
    BATDiteGuideListCell *diteGuideListCell = [collectionView dequeueReusableCellWithReuseIdentifier:DiteGuideListCellID forIndexPath:indexPath];
    diteGuideListCell.diteGuideListModel = model;
    
    //点赞调用
    diteGuideListCell.likeButtonBlock = ^(UIButton *likeButton) {
        [self thumbsUpRequestWith:model upBtn:likeButton                    IndexPath:indexPath];
    };
    
    return diteGuideListCell;
    
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10); //上、左、下、右
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    BATDiteGuideListModel *model = self.dataSource[indexPath.row];
    
    BATDiteGuideDetailsViewController *diteDetailsVC = [[BATDiteGuideDetailsViewController alloc] initWithDataID:model.ID accountID:model.AccountID showDeleteBtn:NO];
    [self.navigationController pushViewController:diteDetailsVC animated:YES];
}
/**
 设置每组头部视图大小
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
    return CGSizeZero;
}
/**
 设置每组尾部视图大小
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    return CGSizeZero;
    
}
/**
 设置头部/尾部视图
 */
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    return nil;
}
#pragma mark - 空数据占位 view & BATTableViewPlaceHolderDelegate
- (UIView *)makePlaceHolderView{
    
    if (!_emptyDataView) {
        _emptyDataView = [[BATEmptyDataView alloc]initWithFrame:self.collectionView.bounds];
        WeakSelf
        _emptyDataView.reloadRequestBlock = ^{
            [weakSelf loadDataRequest];
        };
        
    }
    return _emptyDataView;
}

#pragma mark - lazy Load

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        //设置2个item之间的最小间隙，
        layout.minimumInteritemSpacing = 10;
        
        //设置行之间的最小间距
        layout.minimumLineSpacing      = 10;
        layout.itemSize = CGSizeMake((SCREEN_WIDTH-30)/2, 548/2);
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BATDiteGuideListCell class]) bundle:nil] forCellWithReuseIdentifier:DiteGuideListCellID];
        
    }
    
    return _collectionView;
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
