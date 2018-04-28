//
//  BATTrainStudioDoctorCourseListViewController.m
//  HealthBAT_Pro
//
//  Created by four on 17/4/1.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATTrainStudioDoctorCourseListViewController.h"

#import "BATTrainStudioDoctorCourseCell.h"
#import "BATTrainStudioCourseModel.h"

#import "BATTrainStudioCourseDetailViewController.h"

static NSString *const TRAINSTUDIOCOURSE_CELL = @"BATTrainStudioDoctorCourseCell";

@interface BATTrainStudioDoctorCourseListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) BATDefaultView             *defaultView;

@property (nonatomic,strong) UITableView                *TrainStudioTableView;

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

@end

@implementation BATTrainStudioDoctorCourseListViewController

- (void)dealloc
{
    DDLogWarn(@"%@",self);
    self.TrainStudioTableView.delegate = nil;
    self.TrainStudioTableView.dataSource = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self pagesLayout];
    
    _dataSource = [NSMutableArray array];
    _pageSize = 10;
    _pageIndex = 0;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [self.TrainStudioTableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestTrainStudioDoctorCourseList{
    
    [HTTPTool requestWithURLString:@"/api/Doctor/GetDoctorVideoCourseByAccoutId" parameters:@{@"CourseType":@"1",@"pageIndex":@(_pageIndex),@"pageSize":@(_pageSize),@"accountId":self.doctorID} type:kGET success:^(id responseObject) {
        
        [self.TrainStudioTableView.mj_footer endRefreshing];
        [self.TrainStudioTableView.mj_header endRefreshing];
        
        if (_pageIndex == 0) {
            [_dataSource removeAllObjects];
        }
        
        BATTrainStudioCourseModel *doctorModel = [BATTrainStudioCourseModel mj_objectWithKeyValues:responseObject];
        
        [_dataSource addObjectsFromArray:doctorModel.Data];
        
        if (doctorModel.RecordsCount > 0) {
            self.TrainStudioTableView.mj_footer.hidden = NO;
        } else {
            self.TrainStudioTableView.mj_footer.hidden = YES;
        }
        
        if (_dataSource.count == doctorModel.RecordsCount) {
            [self.TrainStudioTableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        [self.TrainStudioTableView reloadData];
        
        if (_dataSource.count == 0) {
            [self.defaultView showDefaultView];
        }
        
    } failure:^(NSError *error) {
        
        [self.TrainStudioTableView.mj_footer endRefreshing];
        [self.TrainStudioTableView.mj_header endRefreshing];
        
        _pageIndex--;
        if (_pageIndex < 0) {
            _pageIndex = 0;
        }
        
        [self.defaultView showDefaultView];
        
    }];
}



#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BATTrainStudioDoctorCourseCell *courseCell = [tableView dequeueReusableCellWithIdentifier:TRAINSTUDIOCOURSE_CELL forIndexPath:indexPath];
    
    if (self.dataSource.count > 0) {
        BATTrainStudioCourseData *data = _dataSource[indexPath.row];
        
        [courseCell.headerImageView sd_setImageWithURL:[NSURL URLWithString:data.Poster] placeholderImage:[UIImage imageNamed:@"默认图"]];
        courseCell.nameLable.text = data.Topic;
        courseCell.typeLable.text = [NSString stringWithFormat:@"分类：%@",data.CategoryName];
    }
    
    return courseCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BATTrainStudioCourseData *data = self.dataSource[indexPath.row];
    
    BATTrainStudioCourseDetailViewController *detailVC = [[BATTrainStudioCourseDetailViewController alloc] init];
    
    detailVC.ID = data.ID;
    detailVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:detailVC animated:YES];
}


#pragma mark - pagesLayout

- (void)pagesLayout{
    
    self.title = [NSString stringWithFormat:@"%@的课程",self.doctorName];
    
    WEAK_SELF(self);
    [self.view addSubview:self.TrainStudioTableView];
    [self.TrainStudioTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:self.defaultView];
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self.view);
    }];
    
}


#pragma mark -get&&set

- (UITableView *)TrainStudioTableView{
    if (!_TrainStudioTableView) {
        _TrainStudioTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _TrainStudioTableView.rowHeight = UITableViewAutomaticDimension;
        _TrainStudioTableView.estimatedRowHeight = 100;
        _TrainStudioTableView.delegate = self;
        _TrainStudioTableView.dataSource = self;
        _TrainStudioTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _TrainStudioTableView.backgroundColor = UIColorFromHEX(0xf1f1f1, 1);
        
        [_TrainStudioTableView registerClass:[BATTrainStudioDoctorCourseCell class] forCellReuseIdentifier:TRAINSTUDIOCOURSE_CELL];
        
        WEAK_SELF(self);
        _TrainStudioTableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            STRONG_SELF(self);
            DDLogInfo(@"下拉刷新！");
            self.pageIndex = 0;
            [self.TrainStudioTableView.mj_footer resetNoMoreData];
            [self requestTrainStudioDoctorCourseList];
        }];
        _TrainStudioTableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            STRONG_SELF(self);
            DDLogInfo(@"上拉拉加载！");
            self.pageIndex++;
            [self requestTrainStudioDoctorCourseList];
        }];
    }
    return _TrainStudioTableView;
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
            [self requestTrainStudioDoctorCourseList];
        }];
        
    }
    return _defaultView;
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
