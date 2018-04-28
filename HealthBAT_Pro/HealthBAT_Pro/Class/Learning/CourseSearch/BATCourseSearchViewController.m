//
//  BATCourseSearchViewController.m
//  HealthBAT_Pro
//
//  Created by cjl on 2016/12/9.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATCourseSearchViewController.h"
#import "BATCourseHeaderTableViewCell.h"
#import "BATCourseKeyTableViewCell.h"
#import "BATOnlineLearningTableViewCell.h"
#import "BATCourseDetailViewController.h"
#import "BATHotKeyModel.h"
//#import "BATCourseNewDetailViewController.h"
#import "BATAlbumDetailViewController.h"

typedef NS_ENUM(NSInteger,SearchState) {
    SearchStateNomal = 0,
    SearchStateInput = 1,
};

@interface BATCourseSearchViewController () <UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic,strong) UITextField *searchTF;

@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,assign) NSInteger pageSize;

@property (nonatomic,assign) NSInteger pageIndex;

@property (nonatomic,copy) NSString *keyword;

@property (nonatomic,assign) SearchState searchState;

@property (nonatomic,strong) BATDefaultView *defaultView;

/**
 判断数据请求完成
 */
@property (nonatomic,assign) BOOL isCompleteRequest;

@property (nonatomic,strong) BATHotKeyModel *hotKeyModel;

@end

@implementation BATCourseSearchViewController

- (void)dealloc
{
    DDLogDebug(@"%s",__func__);
    self.batCourseSearchView.tableView.delegate = nil;
    self.batCourseSearchView.tableView.dataSource = nil;
    self.batCourseSearchView.tableView.emptyDataSetSource = nil;
    self.batCourseSearchView.tableView.emptyDataSetDelegate = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshIndexPathModel:) name:BATRefreshIndexPathModelNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeReadNum:) name:@"BATChangeReadNumNotification" object:nil];
        
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    [self.view addSubview:self.batCourseSearchView];
    
    WEAK_SELF(self);
    [self.batCourseSearchView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:self.defaultView];
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.top.equalTo(self.view);
    }];

    
    self.navigationItem.titleView = self.searchTF;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.batCourseSearchView.tableView registerClass:[BATCourseHeaderTableViewCell class] forCellReuseIdentifier:@"BATCourseHeaderTableViewCell"];
    [self.batCourseSearchView.tableView registerClass:[BATCourseKeyTableViewCell class] forCellReuseIdentifier:@"BATCourseKeyTableViewCell"];
    
    [self.batCourseSearchView.tableView registerClass:[BATOnlineLearningTableViewCell class] forCellReuseIdentifier:@"BATOnlineLearningTableViewCell"];
    
    _searchState = SearchStateNomal;
    _pageSize = 10;
    _keyword = @"";
    _dataSource = [NSMutableArray array];
    
    [self hotKeyRequest];
    
    [self.searchTF becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.batCourseSearchView.tableView reloadData];
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
    if (_searchState == SearchStateNomal) {
        if (self.hotKeyModel) {
            return 2;
        }
        return 1;
    }
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_searchState == SearchStateNomal) {
        return 10;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_searchState == SearchStateNomal) {
        return 48;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_searchState == SearchStateNomal) {
        return UITableViewAutomaticDimension;
    }
    return 109;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_searchState == SearchStateNomal) {
        if (indexPath.row == 0) {
            BATCourseHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATCourseHeaderTableViewCell" forIndexPath:indexPath];
            cell.leftImageView.image = [UIImage imageNamed:@"icon-hot"];
            cell.titleLabel.text = @"热门搜索";
            return cell;
        }
        BATCourseKeyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATCourseKeyTableViewCell" forIndexPath:indexPath];
        
        if (self.hotKeyModel && self.hotKeyModel.Data.count > 0) {
            [cell confirgationCell:self.hotKeyModel];
            
            WEAK_SELF(self);
            cell.courseKeyTapBlock = ^(NSIndexPath *keyIndexPath,NSString *hotKeyword){
                DDLogDebug(@"keyIndexPath %@",keyIndexPath);
                STRONG_SELF(self);
                _searchState = SearchStateInput;
                self.batCourseSearchView.tableView.mj_header.hidden = NO;
                _keyword = hotKeyword;
                self.searchTF.text = hotKeyword;
                [self.batCourseSearchView.tableView.mj_header beginRefreshing];
            };
        }
        

        return cell;
    }
    
    BATOnlineLearningTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATOnlineLearningTableViewCell" forIndexPath:indexPath];
    if (_dataSource.count > 0) {
        cell.indexPath = indexPath;
        
        BATCourseData *courseData = _dataSource[indexPath.row];
        
        [cell confirgationCell:courseData];
        cell.onlineLearningCollectionBtnClick = ^(NSIndexPath *cellIndexPath){
            DDLogDebug(@"收藏点击");
        };
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_searchState == SearchStateInput) {
        if (_dataSource.count > 0) {
            BATCourseData *courseData = _dataSource[indexPath.row];
            
            [self requestUpdataCourseReadingNum:indexPath model:courseData];
            
//            BATCourseNewDetailViewController *courseDetailVC = [[BATCourseNewDetailViewController alloc] init];
//            courseDetailVC.courseID = courseData.ID;
//            courseDetailVC.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:courseDetailVC animated:YES];
            
            BATAlbumDetailViewController *courseDetailVC = [[BATAlbumDetailViewController alloc] init];
            courseDetailVC.videoID = [NSString stringWithFormat:@"%ld",(long)courseData.ID] ;
            courseDetailVC.albumID = courseData.AlbumID;
            courseDetailVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:courseDetailVC animated:YES];
            
        }
    }

}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    
    _keyword = textField.text;
    
    if (_keyword.length > 0) {
        _searchState = SearchStateInput;
        self.batCourseSearchView.tableView.mj_header.hidden = NO;
        
        [self.batCourseSearchView.tableView.mj_header beginRefreshing];
    } else {
        _searchState = SearchStateNomal;

        self.batCourseSearchView.tableView.mj_header.hidden = YES;
        
        [self.batCourseSearchView.tableView reloadData];
    }
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    [self.searchTF resignFirstResponder];
    self.searchTF.text = @"";
    
    _searchState = SearchStateNomal;
    
    self.defaultView.hidden = YES;
    
    self.batCourseSearchView.tableView.mj_header.hidden = YES;
    self.batCourseSearchView.tableView.mj_footer.hidden = YES;
    [self.batCourseSearchView.tableView.mj_footer resetNoMoreData];
    
    [self.batCourseSearchView.tableView reloadData];
    
    [self.batCourseSearchView.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
    

    
    return YES;
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
//    
//    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
//    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
//    paragraph.alignment = NSTextAlignmentCenter;
//    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:16.0f], NSForegroundColorAttributeName: [UIColor lightGrayColor], NSParagraphStyleAttributeName: paragraph};
//    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
//}

#pragma mark - Action
- (void)refreshIndexPathModel:(NSNotification *)notif
{
    NSDictionary *dic = [notif object];
    NSInteger courseID = [[dic objectForKey:@"courseID"] integerValue];
    BOOL isCollection = [[dic objectForKey:@"isCollection"] boolValue];
    BOOL commentState = [[dic objectForKey:@"commentState"] boolValue];
    BOOL isRead = [[dic objectForKey:@"isRead"] boolValue];
    
    for (BATCourseData *data in _dataSource) {
        if (data.ID == courseID) {
            if (isCollection) {
                data.CollectNum++;
            } else {
                data.CollectNum--;
            }
            
            if (commentState) {
                data.ReplyNum++;
            }
            
            if (isRead) {
                data.ReadingNum++;
            }
            
            break;
        }
    }
    
    [self.batCourseSearchView.tableView reloadData];
    
}

- (void)changeReadNum:(NSNotification *)notif
{
    NSDictionary *dic = [notif object];
    
//    NSInteger category = [dic[@"category"] integerValue];
    NSInteger courseID = [dic[@"courseID"] integerValue];
    NSInteger readNum = [dic[@"ReadingNum"] integerValue];
    
//    if (category == self.ObjID) {
        for (int i = 0; i < _dataSource.count; i++) {
            BATCourseData *courseData = _dataSource[i];
            if (courseData.ID == courseID) {
                courseData.ReadingNum = readNum;
                [_dataSource replaceObjectAtIndex:i withObject:courseData];
                [self.batCourseSearchView.tableView reloadData];
                break;
            }
        }
//    }
    
    
}


#pragma mark - NET
#pragma mark - 获取在线学习列表
- (void)requestOnlineLearingList
{
    self.defaultView.hidden = YES;
    [HTTPTool requestWithURLString:@"/api/TrainingTeacher/GetCourseList" parameters:@{@"pageIndex":@(_pageIndex),@"pageSize":@(_pageSize),@"keyword":_keyword} type:kGET success:^(id responseObject) {
        
        [self.batCourseSearchView.tableView.mj_header endRefreshingWithCompletionBlock:^{
            self.isCompleteRequest = YES;
            [self.batCourseSearchView.tableView reloadData];
        }];
        [self.batCourseSearchView.tableView.mj_footer endRefreshing];
        
        if (_pageIndex == 0) {
            [_dataSource removeAllObjects];
        }
        
        BATCourseModel *courseModel = [BATCourseModel mj_objectWithKeyValues:responseObject];
        
        [_dataSource addObjectsFromArray:courseModel.Data];
        
        if (courseModel.RecordsCount > 0) {
            self.batCourseSearchView.tableView.mj_footer.hidden = NO;
        } else {
            self.batCourseSearchView.tableView.mj_footer.hidden = YES;
        }
        
        if (_dataSource.count == courseModel.RecordsCount) {
//            [self.batCourseSearchView.tableView.mj_footer endRefreshingWithNoMoreData];
            self.batCourseSearchView.tableView.mj_footer.hidden = YES;
        }
        
        if (_dataSource.count == 0) {
            [self.defaultView showDefaultView];
        }
        
        [self.batCourseSearchView.tableView reloadData];
        
    } failure:^(NSError *error) {
        [self.batCourseSearchView.tableView.mj_header endRefreshingWithCompletionBlock:^{
            self.isCompleteRequest = YES;
            [self.batCourseSearchView.tableView reloadData];
        }];
        [self.batCourseSearchView.tableView.mj_footer endRefreshing];
        _pageIndex--;
        if (_pageIndex < 0) {
            _pageIndex = 0;
        }
        [self.defaultView showDefaultView];
    }];
}

- (void)requestUpdataCourseReadingNum:(NSIndexPath *)indexPath model:(BATCourseData *)model
{
    [HTTPTool requestWithURLString:[NSString stringWithFormat:@"/api/trainingteacher/course/updatereadingnum/%ld",(long)model.ID] parameters:nil type:kGET success:^(id responseObject) {
        
//        model.ReadingNum++;
//        
//        [_dataSource replaceObjectAtIndex:indexPath.row withObject:model];
//        
//        [self.batCourseSearchView.tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)hotKeyRequest {
    
    [HTTPTool requestWithURLString:@"/api/Search/GetHotKeywords" parameters:@{@"Category":@(1)} type:kGET success:^(id responseObject) {
        
        self.hotKeyModel = [BATHotKeyModel mj_objectWithKeyValues:responseObject];
        if (self.hotKeyModel.ResultCode == 0) {
            [self.batCourseSearchView.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}



#pragma mark - get&set
- (BATCourseSearchView *)batCourseSearchView
{
    if (_batCourseSearchView == nil) {
        _batCourseSearchView = [[BATCourseSearchView alloc] init];
        _batCourseSearchView.tableView.delegate = self;
        _batCourseSearchView.tableView.dataSource = self;
        _batCourseSearchView.tableView.emptyDataSetSource = self;
        _batCourseSearchView.tableView.emptyDataSetDelegate = self;
        
        WEAK_SELF(self);
        _batCourseSearchView.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.pageIndex = 0;
            [self.batCourseSearchView.tableView.mj_footer resetNoMoreData];
            [self requestOnlineLearingList];
        }];
        
        _batCourseSearchView.tableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.pageIndex++;
            [self requestOnlineLearingList];
        }];
        
        _batCourseSearchView.tableView.mj_header.hidden = YES;
        _batCourseSearchView.tableView.mj_footer.hidden = YES;
    }
    return _batCourseSearchView;
}

- (UITextField *)searchTF {
    if (!_searchTF) {
        _searchTF = [UITextField textFieldWithfont:[UIFont systemFontOfSize:13] textColor:nil placeholder:@"搜索感兴趣的视频" BorderStyle:UITextBorderStyleNone];
        _searchTF.clearButtonMode = UITextFieldViewModeAlways;
        _searchTF.textColor = STRING_LIGHT_COLOR;
        
        UIImageView *searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"搜索图标"]];
        UIView *leftIcon = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
        [leftIcon addSubview:searchIcon];
        [searchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(leftIcon);
        }];
        
        _searchTF.leftView = leftIcon;
        _searchTF.leftViewMode = UITextFieldViewModeAlways;
        _searchTF.delegate = self;
        _searchTF.bounds = CGRectMake(0, 0, SCREEN_WIDTH - 40, 30);
        _searchTF.backgroundColor = BASE_BACKGROUND_COLOR;
        _searchTF.returnKeyType = UIReturnKeySearch;
        
        
        _searchTF.layer.cornerRadius = 3.0f;
        _searchTF.clipsToBounds = YES;
    }
    return _searchTF;
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
            
        }];
        
    }
    return _defaultView;
}

@end
