//
//  BATHomeNewsCollectionViewCell.m
//  HealthBAT_Pro
//
//  Created by KM on 16/9/202016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATHomeNewsTableViewCell.h"
#import "BATHomeNewsCollectionViewCell.h"
#import "BATHomeNewsListModel.h"

static  NSString * const NEWS_COLLECTIONVIEW_CELL = @"NewsCollectionViewCell";
static  NSString * const HOT_NEWS_LAST_DATE = @"HotNewsLastTime";
static  NSString * const RECOMMEND_NEWS_LAST_DATE = @"RecommednNewsLastTime";

@implementation BATHomeNewsTableViewCell

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNews:) name:@"NEWS_REFRESH" object:nil];

        self.recommendCurrentPage = 0;
        self.recommendNewsDataArray = [NSMutableArray array];
        self.hotCurrentPage = 0;
        self.hotNewsDataArray = [NSMutableArray array];

        self.selectionStyle = UITableViewCellSelectionStyleNone;

        WEAK_SELF(self);
        [self.contentView addSubview:self.headerView];
        [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.top.right.equalTo(self);
            make.height.mas_equalTo(40);
        }];

        [self.contentView addSubview:self.newsCollectionView];
        [self.newsCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.headerView.mas_bottom);
            make.left.right.equalTo(self);
            make.height.mas_equalTo(SCREEN_HEIGHT-64-40);
        }];

        [self recommendNewsListRequest];
        //延迟1s加载热门新闻数据
        [self performSelector:@selector(hotNewsListRequest) withObject:nil afterDelay:1];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHomeNews) name:@"HOME_NEWS_REFRESH" object:nil];
    }
    return self;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return 2;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BATHomeNewsCollectionViewCell *newsCell = [collectionView dequeueReusableCellWithReuseIdentifier:NEWS_COLLECTIONVIEW_CELL forIndexPath:indexPath];

    WEAK_SELF(self);
    if (indexPath.row == 0) {

        //推荐
        MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            self.recommendCurrentPage ++;
            [self recommendNewsListRequest];
        }];
        footer.refreshingTitleHidden = YES;
        [footer setTitle:@"" forState:MJRefreshStateIdle];

        newsCell.newsListTableView.mj_footer = footer;
        newsCell.dataArray = self.recommendNewsDataArray;
        [newsCell.newsListTableView reloadData];

    }
    else {

        //热门
        MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.hotCurrentPage ++;
            [self hotNewsListRequest];
        }];
        footer.refreshingTitleHidden = YES;
        [footer setTitle:@"" forState:MJRefreshStateIdle];

        newsCell.newsListTableView.mj_footer = footer;
        newsCell.dataArray = self.hotNewsDataArray;
        [newsCell.newsListTableView reloadData];
    }

    [newsCell setNewsClickedBlock:^(NSString *newsID, NSString *newsTitle) {

        if (self.newsClickedBlock) {
            self.newsClickedBlock(newsID,newsTitle);
        }
    }];

    return newsCell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {

    return CGFLOAT_MIN;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {

    return CGFLOAT_MIN;
}

//每个item 的视图的宽高  只有宽高，没有frame
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    CGSize size = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-64-40);
    return size;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {


    if (scrollView.contentOffset.x/SCREEN_WIDTH +10 == kHomeNewsRecommend) {
        [self.headerView categoryButtonAnimate:self.headerView.recommendNewsView];
    }
    else if (scrollView.contentOffset.x/SCREEN_WIDTH + 10 == kHomeNewsHot) {
        [self.headerView categoryButtonAnimate:self.headerView.hotNewsView];
    }
}

#pragma mark - action
- (void)refreshNews:(NSNotification *)noti {

    if ([noti.userInfo[@"category"] intValue] == kHomeNewsHot) {
        BATHomeNewsCollectionViewCell *newsCell = (BATHomeNewsCollectionViewCell *)[self.newsCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
        if (self.hotNewsDataArray.count > 0) {
            [newsCell.newsListTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        self.hotCurrentPage = 0;
        [self hotNewsListRequest];

    }
    else if ([noti.userInfo[@"category"] intValue] == kHomeNewsRecommend) {
        BATHomeNewsCollectionViewCell *newsCell = (BATHomeNewsCollectionViewCell *)[self.newsCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        if (self.recommendNewsDataArray.count > 0) {
            [newsCell.newsListTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        self.recommendCurrentPage = 0;
        [self recommendNewsListRequest];
    }
}

#pragma mark - net
- (void)refreshHomeNews {
    
    self.recommendCurrentPage = 0;
    self.recommendNewsDataArray = [NSMutableArray array];
    self.hotCurrentPage = 0;
    self.hotNewsDataArray = [NSMutableArray array];

    [self recommendNewsListRequest];
    [self hotNewsListRequest];
}

- (void)recommendNewsListRequest {

    NSTimeInterval time;

    if (self.recommendCurrentPage == 0) {
        //存入本次刷新时间
        [[NSUserDefaults standardUserDefaults] setValue:[NSDate date] forKey:RECOMMEND_NEWS_LAST_DATE];
        [[NSUserDefaults standardUserDefaults] synchronize];

        time = [[NSDate date] timeIntervalSince1970];
    }
    else {
        //获取上次刷新时间
        NSDate *lastDate = [[NSUserDefaults standardUserDefaults] valueForKey:RECOMMEND_NEWS_LAST_DATE];
        if (!lastDate) {
            lastDate = [NSDate date];
        }
        time = [lastDate timeIntervalSince1970];
    }

    //用户行为信息
    NSArray *behavourArray = [[NSUserDefaults standardUserDefaults] valueForKey:@"Behavour"];
    if (!behavourArray) {
        behavourArray = [NSArray array];
    }
    NSMutableDictionary *tmpDic = [NSMutableDictionary dictionary];
    for (NSString *type in behavourArray) {
        if (tmpDic[type]) {
            int num = [tmpDic[type] intValue];
            [tmpDic setObject:@(num + 1) forKey:type];
        }
        else {
            [tmpDic setObject:@1 forKey:type];
        }
    }
    NSMutableArray *tmpArray = [NSMutableArray array];
    NSArray *keyArray = tmpDic.allKeys;
    for (NSString *type in keyArray) {
        [tmpArray addObject:@{@"type":type,@"num":tmpDic[type]}];
    }
    NSString *dataString = [Tools dataTojsonString:tmpArray];


    //请求数据
    [HTTPTool requestWithSearchURLString:@"/elasticsearch/recommend/recommendnews" parameters:@{@"page":@(self.recommendCurrentPage),@"lastflashtime":@(floor(time*1000)),@"userdeviceid":[Tools getUUID],@"recommenddatas":dataString} success:^(id responseObject) {

        BATHomeNewsCollectionViewCell *newsCell = (BATHomeNewsCollectionViewCell *)[self.newsCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        [newsCell.newsListTableView.mj_footer endRefreshing];

        BATHomeNewsListModel *news = [BATHomeNewsListModel mj_objectWithKeyValues:responseObject];
        if (self.recommendCurrentPage == 0) {
            [self.recommendNewsDataArray removeAllObjects];
        }
        [self.recommendNewsDataArray addObjectsFromArray:news.resultData.content];

        newsCell.dataArray = self.recommendNewsDataArray;
        [newsCell.newsListTableView reloadData];


    } failure:^(NSError *error) {

        BATHomeNewsCollectionViewCell *newsCell = (BATHomeNewsCollectionViewCell *)[self.newsCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        [newsCell.newsListTableView.mj_footer endRefreshing];

    }];
}

- (void)hotNewsListRequest {

    NSTimeInterval time;

    if (self.hotCurrentPage == 0) {
        //存入本次刷新时间
        [[NSUserDefaults standardUserDefaults] setValue:[NSDate date] forKey:HOT_NEWS_LAST_DATE];
        [[NSUserDefaults standardUserDefaults] synchronize];

        time = [[NSDate date] timeIntervalSince1970];
    }
    else {
        //获取上次刷新时间
        NSDate *lastDate = [[NSUserDefaults standardUserDefaults] valueForKey:HOT_NEWS_LAST_DATE];
        if (!lastDate) {
            lastDate = [NSDate date];
        }
        time = [lastDate timeIntervalSince1970];
    }

    //请求数据
    [HTTPTool requestWithSearchURLString:@"/elasticsearch/recommend/gethotnews" parameters:@{@"page":@(self.hotCurrentPage),@"lastFlashTime":@(floor(time*1000)),@"userdeviceid":[Tools getUUID]} success:^(id responseObject) {

        BATHomeNewsCollectionViewCell *newsCell = (BATHomeNewsCollectionViewCell *)[self.newsCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
        [newsCell.newsListTableView.mj_footer endRefreshing];

        BATHomeNewsListModel *news = [BATHomeNewsListModel mj_objectWithKeyValues:responseObject];
        if (self.hotCurrentPage == 0) {
            [self.hotNewsDataArray removeAllObjects];
        }
        [self.hotNewsDataArray addObjectsFromArray:news.resultData.content];
        if (self.hotNewsDataArray.count >= news.resultData.totalElements) {
            [newsCell.newsListTableView.mj_footer endRefreshingWithNoMoreData];
        }

        newsCell.dataArray = self.hotNewsDataArray;
        [newsCell.newsListTableView reloadData];

    } failure:^(NSError *error) {

        BATHomeNewsCollectionViewCell *newsCell = (BATHomeNewsCollectionViewCell *)[self.newsCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
        [newsCell.newsListTableView.mj_footer endRefreshing];

    }];
}

#pragma mark - getter
- (UICollectionView *)newsCollectionView {

    if (!_newsCollectionView) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _newsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flow];
        _newsCollectionView.backgroundColor = [UIColor whiteColor];
        _newsCollectionView.pagingEnabled = YES;
        _newsCollectionView.delegate = self;
        _newsCollectionView.dataSource = self;

        [_newsCollectionView registerClass:[BATHomeNewsCollectionViewCell class] forCellWithReuseIdentifier:NEWS_COLLECTIONVIEW_CELL];

    }
    return _newsCollectionView;
}

- (BATHomeNewsHeaderView *)headerView {

    if (!_headerView) {
        _headerView = [[BATHomeNewsHeaderView alloc] initWithFrame:CGRectZero];
        WEAK_SELF(self);
        [_headerView setCategoryClickedBlock:^(HomeNewsType type) {
            STRONG_SELF(self);

            if (type == kHomeNewsHot) {
                //热门
                [self.newsCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            }
            else if (type == kHomeNewsRecommend) {
                //推荐
                [self.newsCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            }

            if (self.categoryClick) {
                self.categoryClick(type);
            }
        }];

    }
    return _headerView;
}

@end
