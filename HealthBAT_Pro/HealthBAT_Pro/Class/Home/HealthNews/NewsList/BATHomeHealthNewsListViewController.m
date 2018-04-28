//
//  BATHomeHealthNewsListViewController.m
//  HealthBAT_Pro
//
//  Created by KM on 17/5/112017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHomeHealthNewsListViewController.h"
#import "BATHomeDetailNewsTableViewCell.h"//健康资讯
#import "BATHomeNewsListModel.h"
#import "BATNewsDetailViewController.h"

static  NSString * const NEWS_CELL = @"NewsCell";
static  NSString * const HOT_NEWS_LAST_DATE = @"HotNewsLastTime";//新闻资讯刷新时间

@interface BATHomeHealthNewsListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *newsListTableView;
@property (nonatomic,strong) NSMutableArray *newsArray;
@property (nonatomic,assign) NSInteger currentPage;

@end

@implementation BATHomeHealthNewsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"健康资讯";
    self.newsArray = [NSMutableArray array];
    [self pagesLayout];
    [self.newsListTableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.newsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BATHomeDetailNewsTableViewCell *newsCell = [tableView dequeueReusableCellWithIdentifier:NEWS_CELL forIndexPath:indexPath];
    
    HomeNewsContent * data = self.newsArray[indexPath.row];
    if (data.mainImage.length > 0) {
        
        [newsCell.newsImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",data.mainImage]] placeholderImage:[UIImage imageNamed:@"默认图"]];
        [newsCell.newsImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(115);
            make.height.mas_equalTo(75);
        }];
    }
    else {
        [newsCell.newsImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
            make.height.mas_equalTo(0);
        }];
        
    }
    newsCell.newsTitleLabel.text = [data.title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    newsCell.sourceLabel.text = data.sourceName;
    newsCell.readTimeLabel.text = [NSString stringWithFormat:@"阅读量：%@",data.readingQuantity];
    
    return newsCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HomeNewsContent * data = self.newsArray[indexPath.row];
    
    if ([data.categoryName isEqualToString:@"康健专题"]) {
        if (!LOGIN_STATION) {
            PRESENT_LOGIN_VC
            return;
        }
    }
    
    [self addReadingQuantityRequestWithNewID:[data.ID integerValue]];
    BATNewsDetailViewController *newsDetailVC = [[BATNewsDetailViewController alloc] init];
    newsDetailVC.hidesBottomBarWhenPushed = YES;
    newsDetailVC.newsID = data.ID;
    newsDetailVC.titleStr = data.title;
    newsDetailVC.isSaveOpera = YES;
    newsDetailVC.categoryName = data.categoryName;
    newsDetailVC.categoryId = data.categoryId;
    [self.navigationController pushViewController:newsDetailVC animated:YES];
}


#pragma mark - net
- (void)hotNewsListRequest {
    
    NSTimeInterval time;
    
    if (self.currentPage == 0) {
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
    [HTTPTool requestWithSearchURLString:@"/elasticsearch/recommend/gethotnews" parameters:@{@"page":@(self.currentPage),@"lastFlashTime":@(floor(time*1000)),@"userdeviceid":[Tools getUUID]} success:^(id responseObject) {
        
        [self.newsListTableView.mj_header endRefreshing];
        [self.newsListTableView.mj_footer endRefreshing];
        
        if (self.currentPage == 0) {
            [self.newsArray removeAllObjects];
        }
        
        BATHomeNewsListModel *news = [BATHomeNewsListModel mj_objectWithKeyValues:responseObject];
        [self.newsArray addObjectsFromArray:news.resultData.content];
        
        if (self.newsArray.count >= news.resultData.totalElements) {
            [self.newsListTableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        [self.newsListTableView reloadData];
        
    } failure:^(NSError *error) {
        [self.newsListTableView.mj_header endRefreshing];
        [self.newsListTableView.mj_footer endRefreshing];
        self.currentPage --;
        if (self.currentPage < 0) {
            self.currentPage = 0;
        }
    }];
}

//更新阅读量
- (void)addReadingQuantityRequestWithNewID:(NSInteger)newID {
    
    [HTTPTool requestWithURLString:[NSString stringWithFormat:@"/api/News/UpdateReadingQuantity?id=%ld",(long)newID] parameters:nil type:kGET success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - layout
- (void)pagesLayout {
    
    [self.view addSubview:self.newsListTableView];
    [self.newsListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
}

#pragma mark - getter
- (UITableView *)newsListTableView {
    
    if (!_newsListTableView) {
        
        _newsListTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _newsListTableView.showsVerticalScrollIndicator = NO;
        _newsListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _newsListTableView.backgroundColor = BASE_BACKGROUND_COLOR;
        _newsListTableView.rowHeight = 90;

        [_newsListTableView registerClass:[BATHomeDetailNewsTableViewCell class] forCellReuseIdentifier:NEWS_CELL];

        
        _newsListTableView.delegate = self;
        _newsListTableView.dataSource = self;
        
        WEAK_SELF(self);
        _newsListTableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            
            STRONG_SELF(self);
            self.currentPage = 0;
            [self hotNewsListRequest];
        }];
        
        _newsListTableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.currentPage ++;
            [self hotNewsListRequest];
        }];
    }
    return _newsListTableView;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
