//
//  BATAlbumListViewController.h
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/6/8.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATAlbumListViewController.h"
#import "BATAlbumListCell.h"
#import "BATAlbumListModel.h"
#import "BATTableViewPlaceHolder.h"
#import "BATEmptyDataView.h"
#import "BATAlbumDetailViewController.h"

#define kMARGIN 10

static NSString *const AlbumListCellId = @"BATAlbumListCell";

@interface BATAlbumListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource, BATTableViewPlaceHolderDelegate>
/** UICollectionView */
@property (nonatomic, strong) UICollectionView *collectionView;
/** 数据源 */
@property (nonatomic, strong) NSMutableArray *dataSource;
/** 页码大小 */
@property (nonatomic, assign) NSInteger  pageSize;
/**  当前页码*/
@property (nonatomic, assign) NSInteger  currentPage;
/** 无数据占位 view */
@property (nonatomic, strong) BATEmptyDataView *emptyDataView;


@end

@implementation BATAlbumListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"专辑";
    self.view.backgroundColor = [UIColor blueColor];
    
    [self.view addSubview:self.collectionView];
    [self registerCell];
    [self setupRefresh];
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.left.mas_equalTo(0);
    }];
}
- (void)registerCell{
    
    [self.collectionView registerClass:[BATAlbumListCell class] forCellWithReuseIdentifier:AlbumListCellId];
}
#pragma mark - 空数据占位 view
#pragma mark - BATTableViewPlaceHolderDelegate
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
    dictM[@"AllowPaging"] = @(true);
    WeakSelf
    [HTTPTool requestWithURLString:@"/api/trainingteacher/GetProductList" parameters:dictM type:kGET success:^(id responseObject) {
        
        
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
        
        if (_currentPage == 0) {
            [weakSelf.dataSource removeAllObjects];
        }
        
        DDLogDebug(@"---------%@",responseObject);
        
        NSArray *moreData =  [BATAlbumListModel mj_objectArrayWithKeyValuesArray:responseObject[@"Data"]];
        
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
#pragma mark - UITableViewDelegate & UITabelViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return self.dataSource.count ? 1 : 0;
    }
    return self.dataSource.count - 1;
}

- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BATAlbumListCell *albumListCell = [collectionView dequeueReusableCellWithReuseIdentifier:AlbumListCellId forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        
        albumListCell.titleLabel.font = [UIFont boldSystemFontOfSize:28];
        albumListCell.bgImageView.layer.cornerRadius = 0;
//        albumListCell.bgImageView.layer.masksToBounds = YES;
        albumListCell.albumModel = self.dataSource[indexPath.section];
        
    }else{
        
        albumListCell.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        albumListCell.albumModel = self.dataSource[indexPath.row + 1];
        albumListCell.bgImageView.layer.cornerRadius = 3;
//        albumListCell.bgImageView.layer.masksToBounds = YES;

        
    }
    
    return albumListCell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return CGSizeMake(SCREEN_WIDTH, 339/2);
    }
    return CGSizeMake((SCREEN_WIDTH- kMARGIN * 3)/2, 208/2);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 0) {
        return UIEdgeInsetsMake(0, 0, 0, 0);//分别为上、左、下、右
    }
    return UIEdgeInsetsMake(kMARGIN, kMARGIN, 0, kMARGIN);
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    BATAlbumListModel *albumModel;
    if (indexPath.section == 0 ) {
        albumModel = self.dataSource[indexPath.section];
    }else{
        albumModel = self.dataSource[indexPath.row + 1];
        
    }
    
    //跳转到视频详情
    BATAlbumDetailViewController *albumDetailVC = [[BATAlbumDetailViewController alloc]init];
    albumDetailVC.hidesBottomBarWhenPushed = YES;
    albumDetailVC.albumID = albumModel.ID.length ? albumModel.ID : @"";
    albumDetailVC.videoID = albumModel.VideoID;
    [self.navigationController pushViewController:albumDetailVC animated:YES];
}



#pragma mark - Lazy load

- (UICollectionView *)collectionView{
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        //设置2个item之间的最小间隙，
        layout.minimumInteritemSpacing = kMARGIN;
        
        //设置行之间的最小间距
        layout.minimumLineSpacing      = kMARGIN;
        
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        _collectionView.backgroundColor = [UIColor whiteColor];
        
    }
    return _collectionView;
}
- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)dealloc{
    
   DDLogDebug(@"%s",__func__);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
