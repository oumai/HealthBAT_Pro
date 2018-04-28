//
//  BATCategoryListViewController.m
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/6/8.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATCategoryListViewController.h"
#import "BATAlbumDetailViewController.h"
#import "BATCategoryListCell.h"
#import "BATCategoryListModel.h"

#import "BATTableViewPlaceHolder.h"
#import "BATEmptyDataView.h"
#import "BATFollowNoMoreDataFooterView.h"


static NSString *const CategoryListCellId = @"BATCategoryListCell";
static NSString *const noMoreDataFooterViewID = @"BATFollowNoMoreDataFooterView";



@interface BATCategoryListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource, BATTableViewPlaceHolderDelegate>
/** UICollectionView */
@property (nonatomic, strong) UICollectionView *collectionView;
/** 数据源 */
@property (nonatomic, strong) NSMutableArray *dataSource;
/** 数据页码大小 */
@property (nonatomic, assign) NSInteger  pageSize;
/** 当前页码 */
@property (nonatomic, assign) NSInteger  currentPage;
/** 无数据占位 */
@property (nonatomic, strong) BATEmptyDataView *emptyDataView;

@end

@implementation BATCategoryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.collectionView];
    [self registerCell];
    [self setupRefresh];
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
}
#pragma mark - 无数据占位 view
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
#pragma mark - private

- (void)registerCell{
    
    [self.collectionView registerClass:[BATCategoryListCell class] forCellWithReuseIdentifier:CategoryListCellId];
    
    //注册暂无更多数据footerView
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BATFollowNoMoreDataFooterView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:noMoreDataFooterViewID];

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


#pragma mark - UITabelViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  self.dataSource.count;
}

- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BATCategoryListCell *categoryListCell = [collectionView dequeueReusableCellWithReuseIdentifier:CategoryListCellId forIndexPath:indexPath];
    
    categoryListCell.categoryListModel = self.dataSource[indexPath.row];
    return categoryListCell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN_WIDTH, 95);
}
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    
//    return UIEdgeInsetsMake(10, 10, 0, 10); //上、左、下、右
//    
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    BATCategoryListModel *model = self.dataSource[indexPath.row];
    
    BATAlbumDetailViewController *albumDetailVc = [[BATAlbumDetailViewController alloc]init];
    albumDetailVc.hidesBottomBarWhenPushed = YES;
    albumDetailVc.albumID = model.AlbumID.length ? model.AlbumID : @"";
    albumDetailVc.videoID = model.ID;
    [self.navigationController pushViewController:albumDetailVc animated:YES];
    
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
    if (collectionView.mj_footer.hidden) {
        return CGSizeMake(SCREEN_WIDTH, 40);
    }
    return CGSizeZero;
   
}
/**
 设置头部/尾部视图
 */
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{

    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
     
        BATFollowNoMoreDataFooterView *noreMoreDataFooterView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:noMoreDataFooterViewID forIndexPath:indexPath];
        
        return noreMoreDataFooterView;
    }
    return nil;
}

#pragma mark  - Request

- (void)loadDataRequest{
    
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    dictM[@"pageIndex"] = @(_currentPage);
    dictM[@"pageSize"] = @(_pageSize);
    dictM[@"category"] = self.categoryId;
    WeakSelf
    // /api/TrainingTeacher/GetCourseListWithAlbum
    [HTTPTool requestWithURLString:@"/api/TrainingTeacher/GetCourseListWithAlbum" parameters: dictM type:kGET success:^(id responseObject) {
        
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
        
        if (_currentPage == 0) {
            [weakSelf.dataSource removeAllObjects];
        }
        
        DDLogDebug(@"---------%@",responseObject);
        
        NSArray *moreData =  [BATCategoryListModel mj_objectArrayWithKeyValuesArray:responseObject[@"Data"]];
        
        [weakSelf.dataSource addObjectsFromArray:moreData];
        
        if (moreData.count < _pageSize) {
            [weakSelf.collectionView.mj_footer setHidden:YES];
        }else{
            [weakSelf.collectionView.mj_footer setHidden:NO];
        }
        
        //bat_reloadData里面已经包含 reloadData
        [weakSelf.collectionView bat_reloadData];
        
        
    } failure:^(NSError *error) {
        [weakSelf.collectionView.mj_footer endRefreshing];
        [weakSelf.collectionView.mj_header endRefreshing];
        
        //请求失败显示占位视图
        [weakSelf.collectionView bat_reloadData];
        
    }];
    
    
}


#pragma mark - lazy load

- (UICollectionView *)collectionView{
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        //设置2个item之间的最小间隙，
        layout.minimumInteritemSpacing = 10;
        
        //设置行之间的最小间距
        layout.minimumLineSpacing      = 10;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        /*
        if(@available(iOS 11.0, *)) {
            _collectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-88);
        }else{
            
            _collectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
        }
         */
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
//        UIEdgeInsets edges = UIEdgeInsetsMake(0, 0, 64, 0);
//        _collectionView.contentInset = edges;
//        _collectionView.scrollIndicatorInsets = edges;
        
        
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
