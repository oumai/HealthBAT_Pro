//
//  BATHealthAssessmentRecordViewController.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/23.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATHealthAssessmentRecordViewController.h"
#import "BATHealthTestRecordTableViewCell.h"
#import "BATHealthTestRecordModel.h"
#import "BATHealthTestRecordDetailViewController.h"
#import "UIScrollView+EmptyDataSet.h"

@interface BATHealthAssessmentRecordViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView * recordTableView;

@property (nonatomic, assign) NSInteger pageIndex;

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, assign) BOOL isCompleteRequest;

@property (nonatomic,strong) BATDefaultView *defaultView;

@end

@implementation BATHealthAssessmentRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"健康评测记录";
    
    _dataSource = [NSMutableArray array];
    _pageIndex = 0;
    _pageSize = 10;
    
    [self subviewsLayout];
    [self.recordTableView.mj_header beginRefreshing];
}

- (void)subviewsLayout {
    [self.view addSubview:self.recordTableView];
    [self.recordTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    
    [self.view addSubview:self.defaultView];
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.top.equalTo(self.view);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    BATHealthTestRecordTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"BATHealthTestRecordTableViewCell" forIndexPath:indexPath];
    if (_dataSource.count > 0) {
        
        BATHealthTestRecordData *data = _dataSource[indexPath.row];
        [cell configureCellWith:data];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BATHealthTestRecordDetailViewController * detailVC = [BATHealthTestRecordDetailViewController new];
    detailVC.recordData = _dataSource[indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - DZNEmptyDataSetSource
//- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
//
//    return -50;
//}
//- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
//
//    if (!self.isCompleteRequest) {
//        return nil;
//    }
//
//    return [UIImage imageNamed:@"无数据"];
//}
//
////返回标题文字
//- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
//    NSString *text = @"";
//    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f], NSForegroundColorAttributeName: [UIColor darkGrayColor]};
//    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
//}
//
////返回详情文字
//- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
//
//    if (!self.isCompleteRequest) {
//        return nil;
//    }
//
//    NSString *text = BAT_NO_DATA;
//    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
//    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
//    paragraph.alignment = NSTextAlignmentCenter;
//    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:16.0f], NSForegroundColorAttributeName: [UIColor lightGrayColor], NSParagraphStyleAttributeName: paragraph};
//    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
//}

#pragma mark - net
- (void)requestGetRecord {
    
    [HTTPTool requestWithURLString:[NSString stringWithFormat:@"/api/Evaluating/GetMyEvaluationTemplateResultsList?pageIndex=%ld&pageSize=%ld",(long)_pageIndex,(long)_pageSize] parameters:nil type:kGET success:^(id responseObject) {
        
        [self.recordTableView reloadData];
        
        [self.recordTableView.mj_header endRefreshingWithCompletionBlock:^{
            self.isCompleteRequest = YES;
            [self.recordTableView reloadData];
        }];
        [self.recordTableView.mj_footer endRefreshing];
        
        BATHealthTestRecordModel *record = [BATHealthTestRecordModel mj_objectWithKeyValues:responseObject];
        
        [_dataSource addObjectsFromArray:record.Data];
        
        if (_dataSource.count == 0) {
            self.recordTableView.mj_footer.hidden = YES;
        } else {
            self.recordTableView.mj_footer.hidden = NO;
        }
        
        if (_dataSource.count == record.RecordsCount) {
            [self.recordTableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        if (_dataSource.count == 0) {
            [self.defaultView showDefaultView];
        }
        
        [self.recordTableView reloadData];
        
        
    } failure:^(NSError *error) {
        [self.recordTableView.mj_header endRefreshingWithCompletionBlock:^{
            self.isCompleteRequest = YES;
            [self.recordTableView reloadData];
        }];
        [self.recordTableView.mj_footer endRefreshing];
        _pageIndex--;
        if (_pageIndex < 0) {
            _pageIndex = 0;
        }
        
        [self.defaultView showDefaultView];
    }];
}

#pragma mark - setter && getter
- (UITableView *)recordTableView {
    if (!_recordTableView) {
        _recordTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _recordTableView.backgroundColor = [UIColor clearColor];
        _recordTableView.delegate = self;
        _recordTableView.dataSource = self;
        _recordTableView.emptyDataSetSource = self;
        _recordTableView.emptyDataSetDelegate = self;
        _recordTableView.tableFooterView = [UIView new];
        
        [_recordTableView registerNib:[UINib nibWithNibName:@"BATHealthTestRecordTableViewCell" bundle:nil] forCellReuseIdentifier:@"BATHealthTestRecordTableViewCell"];
        
        WEAK_SELF(self);
        _recordTableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.pageIndex = 0;
            [_dataSource removeAllObjects];
            [self requestGetRecord];
        }];
        
        _recordTableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.pageIndex++;
            [self requestGetRecord];
        }];
        
        _recordTableView.mj_footer.hidden = YES;
    }
    return _recordTableView;
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
            
            [self.recordTableView.mj_header beginRefreshing];
        }];
        
    }
    return _defaultView;
}


@end
