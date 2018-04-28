//
//  BATHotNewsCollectionViewCell.m
//  HealthBAT_Pro
//
//  Created by KM on 16/9/212016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATHomeNewsCollectionViewCell.h"
#import "BATHomeNewsListModel.h"
#import "BATHomeDetailNewsTableViewCell.h"

#import "BATNewsDetailViewController.h"


static  NSString *const NEWS_LIST_CELL = @"NewsListCell";

@implementation BATHomeNewsCollectionViewCell

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        
        self.canScroll = NO;
        self.lastPositionY = 0;

        //首页整体tableView滑动到底部锁定，开始新闻的子tableView滑动
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newsTableCanScroll) name:@"HOME_LOCK_SCROLL" object:nil];

        //新闻子tableView滑动到顶部，联动所有新闻子tableView滑动到顶部
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newsTableScrollToTop) name:@"NEWS_LOCK_SCROLL" object:nil];


        [self.contentView addSubview:self.newsListTableView];
        [self.newsListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];

    }
    return self;
}

#pragma mark - UITableViewDataSource UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    HomeNewsContent * data = self.dataArray[indexPath.row];
    if (!data) {
        return nil;
    }

    BATHomeDetailNewsTableViewCell * newsCell = [tableView dequeueReusableCellWithIdentifier:NEWS_LIST_CELL forIndexPath:indexPath];
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

    HomeNewsContent * newsData = self.dataArray[indexPath.row];
    if (self.newsClickedBlock) {
        self.newsClickedBlock(newsData.ID,newsData.title);
        newsData.readingQuantity = [NSString stringWithFormat:@"%d",[newsData.readingQuantity intValue]+1];
        [self.dataArray replaceObjectAtIndex:indexPath.row withObject:newsData];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }

    //向本地存储点击的类型，，插入第0个索引，如果大于10个，移除最后一个

    NSArray *behavourArray = [[NSUserDefaults standardUserDefaults] valueForKey:@"Behavour"];
    NSMutableArray *array = [NSMutableArray arrayWithArray:behavourArray];

    [array insertObject:newsData.category atIndex:0];

    if (array.count > 7) {
        [array removeLastObject];
    }

    [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"Behavour"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if (self.canScroll == NO) {
        [scrollView setContentOffset:CGPointZero];
    }

    if (scrollView.contentOffset.y < 0) {

        self.canScroll = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NEWS_LOCK_SCROLL" object:nil];
    }


    int currentPostionY = scrollView.contentOffset.y;
    if (currentPostionY - self.lastPositionY > 25) {
        self.lastPositionY = currentPostionY;
        //向上
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NEWS_TABLE_UP" object:nil];

    }
    else if (self.lastPositionY - currentPostionY > 25)
    {
        self.lastPositionY = currentPostionY;
        //向下
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NEWS_TABLE_DOWN" object:nil];
    }
}

#pragma mark - DZNEmptyDataSetSource
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {

    return [UIImage imageNamed:@"无数据"];
}

//返回标题文字
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f], NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

//返回详情文字
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {

    NSString *text = BAT_NO_DATA;
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:16.0f], NSForegroundColorAttributeName: [UIColor lightGrayColor], NSParagraphStyleAttributeName: paragraph};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {

    return -50;
//    return -(SCREEN_HEIGHT-64-40-49)/2.0 + 50;
}

#pragma mark - action
- (void)newsTableCanScroll {

    self.canScroll = YES;

    if (self.dataArray.count == 0) {
        self.canScroll = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NEWS_LOCK_SCROLL" object:nil];
    }
}

- (void)newsTableScrollToTop {

    //新闻子tableView滑动到顶部，联动所有新闻子tableView滑动到顶部
    [self.newsListTableView setContentOffset:CGPointMake(0, -1)];
}

#pragma mark - getter
- (BATPassTableView *)newsListTableView {

    if (!_newsListTableView) {
        _newsListTableView = [[BATPassTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _newsListTableView.backgroundColor = BASE_BACKGROUND_COLOR;
        _newsListTableView.showsVerticalScrollIndicator = NO;
        _newsListTableView.rowHeight = 90;

        _newsListTableView.delegate = self;
        _newsListTableView.dataSource = self;

        [_newsListTableView registerClass:[BATHomeDetailNewsTableViewCell class] forCellReuseIdentifier:NEWS_LIST_CELL];

        _newsListTableView.tableFooterView = [[UIView alloc] init];

        _newsListTableView.emptyDataSetSource = self;
        _newsListTableView.emptyDataSetDelegate = self;

    }
    return _newsListTableView;
}


@end
