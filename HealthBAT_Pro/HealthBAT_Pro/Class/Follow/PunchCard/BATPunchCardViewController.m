//
//  BATPunchCardViewController.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/6/13.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATPunchCardViewController.h"
#import "BATPunchCardTableViewCell.h"
#import "BATPunchCardModel.h"

@interface BATPunchCardViewController () <UITableViewDelegate,UITableViewDataSource>

/**
 *  数据源
 */
@property (nonatomic,strong) NSMutableArray *dataSource;

/**
 *  页码
 */
@property (nonatomic,assign) NSInteger pageIndex;

/**
 *  每页显示条数
 */
@property (nonatomic,assign) NSInteger pageSize;

@property (nonatomic,assign) BOOL isCompleteRequest;

@property (nonatomic,strong) BATDefaultView *defaultView;

@end

@implementation BATPunchCardViewController

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (void)loadView
{
    [super loadView];
    
    [self pageLayout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    [self.punchCardView.tableView registerClass:[BATPunchCardTableViewCell class] forCellReuseIdentifier:@"BATPunchCardTableViewCell"];
    
    _dataSource = [NSMutableArray array];
    _pageIndex = 0;
    _pageSize = 10;
    
     [self.punchCardView.tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BATPunchCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATPunchCardTableViewCell" forIndexPath:indexPath];
    
    if (_dataSource.count > 0) {
        
        BATPunchCardItem *punchCardItem = [_dataSource objectAtIndex:indexPath.row];
        
        [cell.avatorImageView sd_setImageWithURL:[NSURL URLWithString:punchCardItem.PhotoPath] placeholderImage:[UIImage imageNamed:@"用户"]];
        cell.userNameLabel.text = punchCardItem.UserName;
        cell.timeLabel.text = [self getTimeStringFromDateString:punchCardItem.ClockInTime];
        cell.leftLabel.text = @"坚持";
        [cell.titleLabel setTitle:[NSString stringWithFormat:@"「%@」",punchCardItem.TemplateName] forState:UIControlStateNormal];
        cell.dayLabel.text = [NSString stringWithFormat:@"%ld天",(long)punchCardItem.ClockFrequency];
    }
    
    return cell;
}

#pragma mark - Action
/**
 *  格式化时间
 *
 *  @param dateString 时间
 *
 *  @return 格式后的时间
 */
- (NSString *)getTimeStringFromDateString:(NSString *)dateString
{
    NSString *timeString = @"";
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *startDate = [formatter dateFromString:dateString];
    NSTimeInterval sendInterval = [startDate timeIntervalSince1970];
    
    NSDate *nowDate = [NSDate date];
    NSString *strNow = [formatter stringFromDate:nowDate];
    NSDate *nowingDate = [formatter dateFromString:strNow];
    NSTimeInterval nowInterval = [nowingDate timeIntervalSince1970];
    
    NSTimeInterval minusInterval = nowInterval - sendInterval;
    
    if (minusInterval < 60) {
        timeString = @"刚刚...";
    }
    else if (minusInterval >= 60 && minusInterval < 3600) {
        timeString = [NSString stringWithFormat:@"%ld分钟前", (long)minusInterval / 60];
    }
    else if (minusInterval >= 3600 && minusInterval < 86400) {
        timeString = [NSString stringWithFormat:@"%ld小时前", (long)minusInterval / 3600];
    }
    else if (minusInterval >= 86400) {
        if ((long)minusInterval / 86400 == 1) {
            timeString = @"昨天";
        }else {
            dateString = [dateString substringToIndex:16];
            timeString = dateString;
        }
    }
    
    
    return timeString;
}


#pragma mark - Net
#pragma mark - 获取打卡记录
- (void)requestGetClockInList
{
    [HTTPTool requestWithURLString:@"/api/trainingteacher/GetClockInList" parameters:@{@"Template":@(self.templateID),@"pageSize":@(_pageSize),@"pageIndex":@(_pageIndex)} type:kGET success:^(id responseObject) {
        
        WEAK_SELF(self);
        [self.punchCardView.tableView.mj_header endRefreshingWithCompletionBlock:^{
            STRONG_SELF(self);
            self.isCompleteRequest = YES;
            [self.punchCardView.tableView reloadData];
        }];
        [self.punchCardView.tableView.mj_footer endRefreshing];
        
        if (_pageIndex == 0) {
            [_dataSource removeAllObjects];
        }
        
        BATPunchCardModel *punchCardModel = [BATPunchCardModel mj_objectWithKeyValues:responseObject];
        
        [_dataSource addObjectsFromArray:punchCardModel.Data];
        
        if (punchCardModel.RecordsCount > 0) {
            self.punchCardView.tableView.mj_footer.hidden = NO;
        } else {
            self.punchCardView.tableView.mj_footer.hidden = YES;
        }
        
        if (_dataSource.count == punchCardModel.RecordsCount) {
            [self.punchCardView.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        if (_dataSource.count == 0) {
            [self.defaultView showDefaultView];
        }
        
        [self.punchCardView.tableView reloadData];
        
    } failure:^(NSError *error) {
        WEAK_SELF(self);
        [self.punchCardView.tableView.mj_header endRefreshingWithCompletionBlock:^{
            STRONG_SELF(self);
            self.isCompleteRequest = YES;
            [self.self.punchCardView.tableView reloadData];
        }];
        [self.punchCardView.tableView.mj_footer endRefreshing];
        _pageIndex--;
        if (_pageIndex < 0) {
            _pageIndex = 0;
        }
        
        [self.defaultView showDefaultView];
        
    }];
}


#pragma mark - pageLayout
- (void)pageLayout
{
    [self.view addSubview:self.punchCardView];
    WEAK_SELF(self);
    [self.punchCardView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:self.defaultView];
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.bottom.right.left.top.equalTo(self.view);
    }];
}

#pragma mark - get & set
- (BATPunchCardView *)punchCardView
{
    if (_punchCardView == nil) {
        _punchCardView = [[BATPunchCardView alloc] init];
        _punchCardView.tableView.delegate = self;
        _punchCardView.tableView.dataSource = self;
        
        WEAK_SELF(self);
        _punchCardView.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.pageIndex = 0;
            [self.punchCardView.tableView.mj_footer resetNoMoreData];
            [self requestGetClockInList];
        }];
        _punchCardView.tableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.pageIndex++;
            [self requestGetClockInList];
        }];
        
        _punchCardView.tableView.mj_footer.hidden = YES;
    }
    return _punchCardView;
}

- (BATDefaultView *)defaultView{
    if (!_defaultView) {
        _defaultView = [[BATDefaultView alloc]initWithFrame:CGRectZero];
        _defaultView.hidden = YES;
        WEAK_SELF(self);
        [_defaultView setReloadRequestBlock:^{
            STRONG_SELF(self);
            DDLogInfo(@"=====重新开始加载！=====");
            self.defaultView.hidden = YES;
            [self.punchCardView.tableView.mj_header beginRefreshing];
            
        }];
        
    }
    return _defaultView;
}

@end
