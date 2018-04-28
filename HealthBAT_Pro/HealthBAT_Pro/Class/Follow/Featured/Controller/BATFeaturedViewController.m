//
//  BATFeaturedViewController.m
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/6/7.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATFeaturedViewController.h"
#import "BATAlbumListViewController.h"
#import "BATCategoryListViewController.h"
#import "BATAlbumDetailViewController.h"
#import "BATFeaturedSectionHeaderView.h"
#import "BATFeaturedVideoModel.h"
#import "BATFeaturedVideoCell.h"
#import "BATCategoryCell.h"
#import "BATFollowNoMoreDataFooterView.h"

static NSString *const BATCategoryCellID = @"BATCategoryCell";
static NSString *const BATCategorySectionFooterViewID = @"UICollectionReusableView";
static NSString *const BATFeaturedVideoCellID = @"BATFeaturedVideoCell";
static NSString *const BATFeaturedSectionHeaderViewID = @"BATFeaturedSectionHeaderView";
static NSString *const BATFollowNoMoreDataFooterViewID = @"BATFollowNoMoreDataFooterView";


@interface BATFeaturedViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

/** UICollectionView */
@property (nonatomic, strong) UICollectionView *collectionView;
/** category 数据源 */
@property (nonatomic, strong) NSMutableArray *categoryDataSouce;
/** 页码大小 */
@property (nonatomic, assign) NSInteger  pageSize;
/** 当前页码 */
@property (nonatomic, assign) NSInteger  currentPage;
/** 精选视频数据源 */
@property (nonatomic, strong) NSMutableArray *dataSource;
/** 滚动到顶部 */
@property (nonatomic, strong) UIButton *scrollToTopButton;
@property (nonatomic, strong) UILabel *tableViewNoMoreDataLabel;

@end

@implementation BATFeaturedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    [self registerCell];
    [self setupRefresh];
    [self addScrollToTopButton];
    
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
}

/**
 注册 cell & sectionHeader
 */
- (void)registerCell{
    
    
    /**美容/养生/减肥/塑形*/
    [self.collectionView registerClass:[BATCategoryCell class] forCellWithReuseIdentifier:BATCategoryCellID];
    
    /**精选视频*/
    [self.collectionView registerClass:[BATFeaturedVideoCell class] forCellWithReuseIdentifier:BATFeaturedVideoCellID];
    
    //注册 sectionHeader
    [self.collectionView registerClass:[BATFeaturedSectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:BATFeaturedSectionHeaderViewID];
    
    //注册 footerSection
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:BATCategorySectionFooterViewID];
    
    
    //注册数据加载完毕 footerView
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BATFollowNoMoreDataFooterView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:BATFollowNoMoreDataFooterViewID];

}
#pragma mark - 添加滚动到顶部按钮
- (void)addScrollToTopButton{
 
    _scrollToTopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _scrollToTopButton.backgroundColor = [UIColor whiteColor];
    [_scrollToTopButton setBackgroundImage:[UIImage imageNamed:@"ic-zd"] forState:UIControlStateNormal];
    _scrollToTopButton.layer.cornerRadius = 20;
    _scrollToTopButton.layer.masksToBounds = YES;
    _scrollToTopButton.alpha = 1;
    [_scrollToTopButton addTarget:self action:@selector(scrollTopButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_scrollToTopButton];
    [_scrollToTopButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.width.height.mas_equalTo(40);
    make.bottom.mas_equalTo(self.mas_bottomLayoutGuide).offset(-30);

    }];

}
- (void)scrollTopButtonClick:(UIButton *)button{
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > (CGRectGetHeight(self.collectionView.frame) * 3 /2)) {
        self.scrollToTopButton.alpha = 1;
    } else {
        self.scrollToTopButton.alpha = 0;
    }
    
}

#pragma mark - setupRefresh

- (void)setupRefresh{
    _pageSize = 10;
    _currentPage = 1;
    
    self.collectionView.mj_header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshRequest)];
    
    self.collectionView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshRequest)];
    
    
    [self.collectionView.mj_header beginRefreshing];

    
}
/**
 头部刷新调用
 */
- (void)headerRefreshRequest{
    _currentPage = 0;
    
    [self.collectionView.mj_footer endRefreshing];
    [self loadFeaturedVideoDataRequst];
}
/**
 尾部刷新调用
 */
- (void)footerRefreshRequest{
    _currentPage ++;
    
    [self.collectionView.mj_header endRefreshing];
    [self loadFeaturedVideoDataRequst];
}

#pragma mark - Request
#pragma mark - 精选视频网络请求

- (void)loadFeaturedVideoDataRequst{
    
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    dictM[@"pageIndex"] = @(_currentPage);
    dictM[@"pageSize"] = @(_pageSize);
    
    //加载精选视频
    WeakSelf
    // /api/trainingteacher/GetSelectProductWithAlbum
    [HTTPTool requestWithURLString:@"/api/trainingteacher/GetSelectProductWithAlbum" parameters:dictM type:kGET success:^(id responseObject) {
        
        
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
        
        if (_currentPage == 0) {
            [weakSelf.dataSource removeAllObjects];
        }
        
        DDLogDebug(@"---------%@",responseObject);
        
        NSArray *moreData =  [BATFeaturedVideoListModel mj_objectArrayWithKeyValuesArray:responseObject[@"Data"]];
        
        [weakSelf.dataSource addObjectsFromArray:moreData];
        
        if (moreData.count < _pageSize) {
            
            [weakSelf.collectionView.mj_footer setHidden:YES];
            
        }else{
            [weakSelf.collectionView.mj_footer setHidden:NO];
        }
        
        [weakSelf.collectionView reloadData];
        
    
        
    } failure:^(NSError *error) {
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];

    }];
    
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0 ) {
        return self.categoryDataSouce.count;
    }else{
        return self.dataSource.count;
    }
}

- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        BATCategoryCell *categoryCell = [collectionView dequeueReusableCellWithReuseIdentifier:BATCategoryCellID forIndexPath:indexPath];
        categoryCell.backgroundColor = [UIColor whiteColor];
        categoryCell.itemDataSource = self.categoryDataSouce[indexPath.row];
        return categoryCell;
        
    }else {
        
        BATFeaturedVideoCell *featuredVideoCell = [collectionView dequeueReusableCellWithReuseIdentifier:BATFeaturedVideoCellID forIndexPath:indexPath];
        featuredVideoCell.backgroundColor = [UIColor whiteColor];
        featuredVideoCell.featuredVideoModel = self.dataSource[indexPath.row];
        return featuredVideoCell;
        
    }
    
    
}
/**
 设置每组item 大小
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return CGSizeMake((SCREEN_WIDTH)/4, 95);
        
    }else{
        
        return CGSizeMake(SCREEN_WIDTH, 95);
    }
    
}
/**
 点击 item 调用
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        BATCategoryListViewController *categoryListVc = [[BATCategoryListViewController alloc]init];
        switch (indexPath.row) {
            case 0:
                categoryListVc.title = @"美容";
                break;
            case 1:
                categoryListVc.title = @"养生";
                break;
                
            case 2:
                categoryListVc.title = @"减肥";
                break;
                
            case 3:
                categoryListVc.title = @"塑形";
                break;
                
            default:
                break;
        }
        /** 1 : 美容 2:养生 3 ：减肥  4 ： 塑型*/
        categoryListVc.categoryId = [NSString stringWithFormat:@"%ld",(long)indexPath.row + 1];
        categoryListVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:categoryListVc animated:YES];
    }else if (indexPath.section == 1){
        //进入精选视频详情
        BATFeaturedVideoListModel *videoModel  = self.dataSource[indexPath.row];
        BATAlbumDetailViewController *albumDetailVc = [[BATAlbumDetailViewController alloc]init];
        
        albumDetailVc.videoID = videoModel.ID;
        albumDetailVc.albumID = videoModel.ThemplateID.length ? videoModel.ThemplateID : @"";
        albumDetailVc.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:albumDetailVc animated:YES];
        
    }

    
}
/**
 设置每组item 横向间距
 */
- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{

    return CGFLOAT_MIN;
}
/**
 设置每组item 纵向间距
 */
- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
 
    return CGFLOAT_MIN;
}
/**
 设置每组内边距
 */
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{

    return UIEdgeInsetsZero;
    
}
/**
 设置每组头部视图大小
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        
        return CGSizeMake(SCREEN_WIDTH, 55);
    }
    return CGSizeZero;
}
/**
 设置每组尾部视图大小
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (section == 1 && collectionView.mj_footer.hidden) {
        return CGSizeMake(SCREEN_WIDTH, 40);
    }
    return CGSizeZero;
}
/**
 设置头部/尾部视图
 */
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    //头视图
    if (indexPath.section == 1) {
        
        if([kind isEqualToString:UICollectionElementKindSectionHeader]){
            BATFeaturedSectionHeaderView *header=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:BATFeaturedSectionHeaderViewID forIndexPath:indexPath];
            header.backgroundColor = [UIColor whiteColor];
            header.leftTitleLabel.text = @"推荐";
            header.rightButton.hidden = YES;
             return header;
            
        }else if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
            BATFollowNoMoreDataFooterView *noMoreDataFooterView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:BATFollowNoMoreDataFooterViewID forIndexPath:indexPath];
//            noMoreDataFooterView.backgroundColor = [UIColor redColor];
            return noMoreDataFooterView;
            
            
        }
   
    }


    return nil;
}


#pragma mark - Lazy load

- (UICollectionView *)collectionView{
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        
//        if(@available(iOS 11.0, *)) {
//            _collectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-88-83-45);
//        }else{
//            
//            _collectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-49-45);
//        }
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        
    }
    return _collectionView;
}


- (NSMutableArray *)categoryDataSouce{
    if (!_categoryDataSouce) {
        _categoryDataSouce = [NSMutableArray arrayWithObjects:
                              @{@"title":@"美容",@"imageName":@"Follow_Featured_Beauty"},
                              @{@"title":@"养生",@"imageName":@"Follow_Featured_KeepHealth"},
                              @{@"title":@"减肥",@"imageName":@"Follow_Featured_loseWeight"},
                              @{@"title":@"塑形",@"imageName":@"Follow_Featured_Fitness"},
                              nil];
        
    }
    return _categoryDataSouce;
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
