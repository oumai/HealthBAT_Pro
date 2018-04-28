//
//  BATCollectionListViewController.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/23.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATCollectionListViewController.h"
#import "BATSegmentControl.h"

#import "BATHospitalModel.h"
#import "BATNewsModel.h"
#import "BATCollectionDoctorModel.h"
#import "BATCourseModel.h"

#import "BATHospitalTableViewCell.h"
#import "BATHomeDetailNewsTableViewCell.h"
#import "BATConsultationDepartmentDoctorTableViewCell.h"
#import "BATOnlineLearningTableViewCell.h"

#import "BATNewsDetailViewController.h"
#import "BATRegisterDepartmentListViewController.h"
#import "BATConsultationDoctorDetailViewController.h"
#import "BATNewConsultionDoctorDetailViewController.h"

//#import "BATCourseDetailViewController.h"
//#import "BATCourseNewDetailViewController.h"
#import "BATAlbumDetailViewController.h"

#import "UIScrollView+EmptyDataSet.h"

#import "BATHealthFollowContentCell.h"

@interface BATCollectionListViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,assign) NSInteger pageIndex;

@property (nonatomic,assign) NSInteger pageSize;

@property (nonatomic,assign) BOOL isCompleteRequest;

@property (nonatomic,strong) BATDefaultView *defaultView;

@end

@implementation BATCollectionListViewController

- (void)dealloc
{
    DDLogWarn(@"%@",self);
    _collectionListView.tableView.delegate = nil;
    _collectionListView.tableView.dataSource = nil;
    _collectionListView.tableView.emptyDataSetSource = nil;
    _collectionListView.tableView.emptyDataSetDelegate = nil;
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self];

}
- (void)loadView
{
    [super loadView];
    
    if (_collectionListView == nil) {
        _collectionListView = [[BATCollectionListView alloc] init];
        _collectionListView.tableView.delegate = self;
        _collectionListView.tableView.dataSource = self;
        _collectionListView.tableView.emptyDataSetSource = self;
        _collectionListView.tableView.emptyDataSetDelegate = self;
        [self.view addSubview:_collectionListView];
        
        WEAK_SELF(self);
        _collectionListView.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.pageSize = 10;
            self.pageIndex = 0;
            [self.dataArray removeAllObjects];
            [self refreshData];
        }];
        
        _collectionListView.tableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.pageIndex++;
            [self refreshData];
        }];
        
        _collectionListView.tableView.mj_footer.hidden = YES;
        
        [_collectionListView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.left.right.equalTo(self.view);
            make.height.mas_equalTo(SCREEN_HEIGHT-64-30);
        }];
        
        [self.view addSubview:self.defaultView];
        [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.left.top.equalTo(self.view);
        }];

    }
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    [_collectionListView.tableView.mj_header beginRefreshing];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeReadNum:) name:@"BATChangeReadNumNotification" object:nil];
    
    [_collectionListView.tableView registerClass:[BATHospitalTableViewCell class] forCellReuseIdentifier:@"BATHospitalTableViewCell"];
    [_collectionListView.tableView registerClass:[BATHomeDetailNewsTableViewCell class] forCellReuseIdentifier:@"BATNewsTableViewCell"];
    [_collectionListView.tableView registerClass:[BATConsultationDepartmentDoctorTableViewCell class] forCellReuseIdentifier:@"BATConsultationDepartmentDoctorTableViewCell"];
    [_collectionListView.tableView registerClass:[BATHealthFollowContentCell class] forCellReuseIdentifier:@"BATHealthFollowContentCell"];
    //初始化数据源
    _dataArray = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITabelViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.collectionType == BATCollectionDoctor) {
        return 90;
    } else if (self.collectionType == BATCollectionHospital) {
        return 85;
    } else if (self.collectionType == BATCollectionNews) {
        return 90;
    }else if (self.collectionType == BATCollectionLessons) {
        return 109;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    //医生
    if (self.collectionType == BATCollectionDoctor) {
        BATConsultationDepartmentDoctorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATConsultationDepartmentDoctorTableViewCell" forIndexPath:indexPath];
        
        if (_dataArray.count > 0) {
            BATCollectionDoctorData *collectionDoctorData = _dataArray[indexPath.row];
            [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",APP_WEB_DOMAIN_URL,collectionDoctorData.PhotoPath]] placeholderImage:[UIImage imageNamed:@"医生"]];
            if (![collectionDoctorData.HospitalGrade isEqualToString:@"三级甲等"]) {
                
                cell.hospitalLevelImageView.hidden = YES;
            }
            else {
                
                cell.hospitalLevelImageView.hidden = NO;
            }
            
            switch (collectionDoctorData.OnlineStatus) {
                case 0:
                {
                    //离线
                    cell.onlineStationImageView.image = [UIImage imageNamed:@"离线"];
                }
                    break;
                case 1:
                {
                    //忙碌
                    cell.onlineStationImageView.image = [UIImage imageNamed:@"忙碌"];
                    
                }
                    break;
                default:
                {
                    //在线
                    cell.onlineStationImageView.image = nil;
                }
                    break;
            }
            if (collectionDoctorData.jobTileName.length > 0) {
                cell.nameLabel.text = [NSString stringWithFormat:@"%@[%@]",collectionDoctorData.UserName,collectionDoctorData.jobTileName];
            } else {
                cell.nameLabel.text = collectionDoctorData.UserName;
            }
            cell.departmentLabel.text = collectionDoctorData.DepartmentName;
            cell.descriptionLabel.text = collectionDoctorData.Introduction;
        }
        
        return cell;

    }
    //医院
    else if (self.collectionType == BATCollectionHospital) {
        
        BATHospitalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATHospitalTableViewCell" forIndexPath:indexPath];
        if (_dataArray.count > 0) {
            BATHospitalData * hospital = _dataArray[indexPath.row];
            [cell.hospitalImageView sd_setImageWithURL:[NSURL URLWithString:hospital.IMAGE] placeholderImage:[UIImage imageNamed:@"默认图"]];
            cell.nameLabel.text = hospital.UNIT_NAME;
            cell.descriptionLabel.text = hospital.ADDRESS;
            cell.registerTimesLabel.text = [NSString stringWithFormat:@"%ld个预约号源",(long)hospital.LEFT_NUM];
        }
        return cell;
        
    }
    //新闻
    else if (self.collectionType == BATCollectionNews) {
        BATHomeDetailNewsTableViewCell * newsCell = [tableView dequeueReusableCellWithIdentifier:@"BATNewsTableViewCell" forIndexPath:indexPath];

        if (_dataArray.count > 0) {
            BATNewsData * data = self.dataArray[indexPath.row];
            if (data.MainImage.length > 0) {

                [newsCell.newsImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",data.MainImage]] placeholderImage:[UIImage imageNamed:@"默认图"]];
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
            newsCell.newsTitleLabel.text = [data.Title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            newsCell.readTimeLabel.text = [NSString stringWithFormat:@"阅读量：%ld",(long)data.ReadingQuantity];
        }

        return newsCell;

    }

    //课程
    else if (self.collectionType == BATCollectionLessons) {
        BATHealthFollowContentCell * newsCell = [tableView dequeueReusableCellWithIdentifier:@"BATHealthFollowContentCell" forIndexPath:indexPath];

        if (_dataArray.count > 0) {
            BATCourseData * data = self.dataArray[indexPath.row];

            [newsCell.thumbImageView sd_setImageWithURL:[NSURL URLWithString:data.Poster] placeholderImage:[UIImage imageNamed:@"默认图"]];
            newsCell.titleLabel.text = data.Topic;
            newsCell.authorLabel.text = data.TeacherName;
            newsCell.learningCountLabel.text = [NSString stringWithFormat:@"%zd人看过",data.ReadingNum];
        }
        
        return newsCell;
        
    }
    return nil;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.collectionType == BATCollectionDoctor) {
        //医生
        
        BATCollectionDoctorData *collectionDoctorData = _dataArray[indexPath.row];
        if (collectionDoctorData.CollectType == 0) {
            
            BATConsultationDoctorDetailViewController *doctorDetailVC = [[BATConsultationDoctorDetailViewController alloc] init];
            doctorDetailVC.isKMDoctor = YES;
            doctorDetailVC.doctorID = [NSString stringWithFormat:@"%ld",(long)collectionDoctorData.ID];
            doctorDetailVC.isKMDoctor = YES;
            [self.navigationController pushViewController:doctorDetailVC animated:YES];
        } else {
            BATNewConsultionDoctorDetailViewController *doctorDetailVC = [[BATNewConsultionDoctorDetailViewController alloc] init];
            doctorDetailVC.doctorID = [NSString stringWithFormat:@"%ld",(long)collectionDoctorData.ID];
            [self.navigationController pushViewController:doctorDetailVC animated:YES];
        }
        
        
        
    } else if (self.collectionType == BATCollectionHospital) {
        //医院
        BATHospitalData * hospital = self.dataArray[indexPath.row];
        BATRegisterDepartmentListViewController * departmentListVC = [BATRegisterDepartmentListViewController new];
        departmentListVC.hospitalId = hospital.UNIT_ID;
        departmentListVC.hospitalName = hospital.UNIT_NAME;
        [self.navigationController pushViewController:departmentListVC animated:YES];

    } else if (self.collectionType == BATCollectionNews) {
        //健康资讯
        BATNewsData * newsData = self.dataArray[indexPath.row];

        if ([newsData.CategoryName isEqualToString:@"康健专题"]) {
            if (!LOGIN_STATION) {
                PRESENT_LOGIN_VC
                return;
            }
        }
        
        BATNewsDetailViewController *newsVC = [[BATNewsDetailViewController alloc] init];
        newsVC.hidesBottomBarWhenPushed = YES;
        newsVC.titleStr = newsData.Title;
        newsVC.newsID = [NSString stringWithFormat:@"%ld",(long)newsData.ID];
        newsVC.categoryName = newsData.CategoryName;
        newsVC.categoryId = newsData.CategoryId;
        [self.navigationController pushViewController:newsVC animated:YES];
    }else if (self.collectionType == BATCollectionLessons) {
        //在线学习
        BATCourseData * courseData = self.dataArray[indexPath.row];
        
        [self requestUpdataCourseReadingNum:indexPath model:courseData];
        
//        BATCourseNewDetailViewController *courseDetailVC = [[BATCourseNewDetailViewController alloc] init];
//        courseDetailVC.courseID = courseData.ID;
//        [self.navigationController pushViewController:courseDetailVC animated:YES];
        
        
        BATAlbumDetailViewController *courseDetailVC = [[BATAlbumDetailViewController alloc] init];
        courseDetailVC.videoID = [NSString stringWithFormat:@"%ld",(long)courseData.ID];
        courseDetailVC.albumID = courseData.AlbumID;
        [self.navigationController pushViewController:courseDetailVC animated:YES];
    }
}

#pragma mark - NET
- (void)refreshData
{
    
    if (self.collectionType == BATCollectionDoctor) {
        [self getDoctorCollectionList];
    } else if (self.collectionType == BATCollectionHospital) {
        [self getHospitalCollectionList];
    } else if (self.collectionType == BATCollectionNews) {
        [self getNewsCollectionList];
    } else if (self.collectionType == BATCollectionLessons) {
        [self getLessonsCollectionList];
    }
}

#pragma mark - 获取医生收藏列表
- (void)getDoctorCollectionList
{
    
    NSDictionary *dictParams = @{
                                 @"pageSize":[NSNumber numberWithInteger:_pageSize],
                                 @"pageIndex":[NSNumber numberWithInteger:_pageIndex]
                                 };
    
    [HTTPTool requestWithURLString:@"/api/CollectLink/GetCollectWithDoctor" parameters:dictParams type:kGET success:^(id responseObject) {

        
        [_collectionListView.tableView.mj_header endRefreshingWithCompletionBlock:^{
            self.isCompleteRequest = YES;
            [self.collectionListView.tableView reloadData];
        }];
        [_collectionListView.tableView.mj_footer endRefreshing];

        BATCollectionDoctorModel *collectionDoctorModel = [BATCollectionDoctorModel mj_objectWithKeyValues:responseObject];
        
        [_dataArray addObjectsFromArray:collectionDoctorModel.Data];
        
        if (_dataArray.count == 0) {
            _collectionListView.tableView.mj_footer.hidden = YES;
        } else {
            _collectionListView.tableView.mj_footer.hidden = NO;
        }
        
        if (_dataArray.count == collectionDoctorModel.RecordsCount) {
            [_collectionListView.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        [_collectionListView.tableView reloadData];
        
        if (_dataArray.count == 0) {
            [self.defaultView showDefaultView];
        }
        
    } failure:^(NSError *error) {

        [_collectionListView.tableView.mj_header endRefreshingWithCompletionBlock:^{
            self.isCompleteRequest = YES;
            [self.collectionListView.tableView reloadData];
        }];
        [_collectionListView.tableView.mj_footer endRefreshing];
        _pageIndex--;
        if (_pageIndex < 0) {
            _pageIndex = 0;
        }
        
        [self.defaultView showDefaultView];
    }];
    
}

#pragma mark - 取消医生收藏
- (void)cancelDoctorCollection:(NSIndexPath *)indexPath
{
    BATCollectionDoctorData *collectionDoctorData = _dataArray[indexPath.row];
    
    [HTTPTool requestWithURLString:[NSString stringWithFormat:@"/api/CollectLink/UnfavoriteDoctor?doctorId=%ld",(long)collectionDoctorData.AccountID] parameters:nil type:kPOST success:^(id responseObject) {
        
        [_dataArray removeObjectAtIndex:indexPath.row];
        
        if (_dataArray.count == 0) {
            
            _collectionListView.tableView.mj_footer.hidden = YES;
        }
        
        [_collectionListView.tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}




#pragma mark - 获取医院收藏列表
- (void)getHospitalCollectionList
{
    NSDictionary *dictParams = @{
                                 @"pageSize":[NSNumber numberWithInteger:_pageSize],
                                 @"pageIndex":[NSNumber numberWithInteger:_pageIndex]
                                 };

    [HTTPTool requestWithURLString:@"/api/CollectLink/GetCollectWithHospital" parameters:dictParams type:kGET success:^(id responseObject) {

        [_collectionListView.tableView.mj_header endRefreshingWithCompletionBlock:^{
            self.isCompleteRequest = YES;
            [self.collectionListView.tableView reloadData];
        }];
        [_collectionListView.tableView.mj_footer endRefreshing];

        BATHospitalModel *hospitalModel = [BATHospitalModel mj_objectWithKeyValues:responseObject];

        [_dataArray addObjectsFromArray:hospitalModel.Data];

        if (_dataArray.count == 0) {
            _collectionListView.tableView.mj_footer.hidden = YES;
        } else {
            _collectionListView.tableView.mj_footer.hidden = NO;
        }

        if (_dataArray.count == hospitalModel.RecordsCount) {
            [_collectionListView.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        [_collectionListView.tableView reloadData];
        
        if (_dataArray.count == 0) {
            [self.defaultView showDefaultView];
            [self.defaultView chagngeDefaultViewImageView:@"无收藏的医院" withTitle:@"暂未收藏医院"];
            self.defaultView.reloadButton.hidden = YES;
        }
    } failure:^(NSError *error) {

        [_collectionListView.tableView.mj_header endRefreshingWithCompletionBlock:^{
            self.isCompleteRequest = YES;
            [self.collectionListView.tableView reloadData];
        }];
        [_collectionListView.tableView.mj_footer endRefreshing];

        _pageIndex--;
        if (_pageIndex < 0) {
            _pageIndex = 0;
        }

         [self.defaultView showDefaultView];
    }];
}



#pragma mark - 取消医院收藏
- (void)cancelHospitalCollection:(NSIndexPath *)indexPath
{
    
    BATHospitalData *model = [_dataArray objectAtIndex:indexPath.row];
    
    [HTTPTool requestWithURLString:[NSString stringWithFormat:@"/api/CollectLink/UnfavoriteHospital?hospitalId=%ld",(long)model.UNIT_ID] parameters:nil type:kPOST success:^(id responseObject) {
        
        [_dataArray removeObjectAtIndex:indexPath.row];
        
        if (_dataArray.count == 0) {
            
            _collectionListView.tableView.mj_footer.hidden = YES;
        }
        
        [_collectionListView.tableView reloadData];

        
    } failure:^(NSError *error) {
        
    }];
}



#pragma mark - 获取资讯收藏列表
- (void)getNewsCollectionList
{
    NSDictionary *dictParams = @{
                                 @"pageSize":[NSNumber numberWithInteger:_pageSize],
                                 @"pageIndex":[NSNumber numberWithInteger:_pageIndex]
                                 };
    
    [HTTPTool requestWithURLString:@"/api/CollectLink/GetCollectWithNews" parameters:dictParams type:kGET success:^(id responseObject) {

        [_collectionListView.tableView.mj_header endRefreshingWithCompletionBlock:^{
            self.isCompleteRequest = YES;
            [self.collectionListView.tableView reloadData];
        }];
        [_collectionListView.tableView.mj_footer endRefreshing];
        
        BATNewsModel *newsModel = [BATNewsModel mj_objectWithKeyValues:responseObject];
        [_dataArray addObjectsFromArray:newsModel.Data];
        
        if (_dataArray.count == 0) {
            _collectionListView.tableView.mj_footer.hidden = YES;
        } else {
            _collectionListView.tableView.mj_footer.hidden = NO;
        }
        
        if (_dataArray.count == newsModel.RecordsCount) {
            [_collectionListView.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        [_collectionListView.tableView reloadData];
        if (_dataArray.count == 0) {
            [self.defaultView showDefaultView];
            self.defaultView.reloadButton.hidden = YES;

        }
        
    } failure:^(NSError *error) {

        [_collectionListView.tableView.mj_header endRefreshingWithCompletionBlock:^{
            self.isCompleteRequest = YES;
            [self.collectionListView.tableView reloadData];
        }];
        [_collectionListView.tableView.mj_footer endRefreshing];
        _pageIndex--;
        if (_pageIndex < 0) {
            _pageIndex = 0;
        }
        [self.defaultView showDefaultView];
    }];
}


#pragma mark - 取消资讯收藏
- (void)cancelNewsCollection:(NSIndexPath *)indexPath
{
    
    BATNewsData *model = [_dataArray objectAtIndex:indexPath.row];
    [HTTPTool requestWithURLString:[NSString stringWithFormat:@"/api/CollectLink/UnfavoriteNews?newsId=%ld",(long)model.ID] parameters:nil type:kPOST success:^(id responseObject) {
        
        [_dataArray removeObjectAtIndex:indexPath.row];
        
        if (_dataArray.count == 0) {
            _collectionListView.tableView.mj_footer.hidden = YES;
        }
        
        [_collectionListView.tableView reloadData];

    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 获取学习课程收藏
- (void)getLessonsCollectionList {

    NSDictionary *dictParams = @{
                                 @"pageSize":[NSNumber numberWithInteger:_pageSize],
                                 @"pageIndex":[NSNumber numberWithInteger:_pageIndex]
                                 };
    [HTTPTool requestWithURLString:@"/api/CollectLink/GetCollectWithCourse" parameters:dictParams type:kGET success:^(id responseObject) {

        [_collectionListView.tableView.mj_header endRefreshingWithCompletionBlock:^{
            self.isCompleteRequest = YES;
            [self.collectionListView.tableView reloadData];
        }];
        [_collectionListView.tableView.mj_footer endRefreshing];

        BATCourseModel *courseModel = [BATCourseModel mj_objectWithKeyValues:responseObject];
        [_dataArray addObjectsFromArray:courseModel.Data];

        if (_dataArray.count == 0) {
            _collectionListView.tableView.mj_footer.hidden = YES;
        } else {
            _collectionListView.tableView.mj_footer.hidden = NO;
        }

        if (_dataArray.count == courseModel.RecordsCount) {
            [_collectionListView.tableView.mj_footer endRefreshingWithNoMoreData];
        }

        [_collectionListView.tableView reloadData];
        
        if (_dataArray.count == 0) {
            [self.defaultView showDefaultView];
            self.defaultView.reloadButton.hidden = YES;
        }

    } failure:^(NSError *error) {

        [_collectionListView.tableView.mj_header endRefreshingWithCompletionBlock:^{
            self.isCompleteRequest = YES;
            [self.collectionListView.tableView reloadData];
        }];
        [_collectionListView.tableView.mj_footer endRefreshing];
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

#pragma mark - Action

- (void)changeReadNum:(NSNotification *)notif
{
    
    if (self.collectionType == BATCollectionLessons) {
        NSDictionary *dic = [notif object];
        
        NSInteger courseID = [dic[@"courseID"] integerValue];
        NSInteger readNum = [dic[@"ReadingNum"] integerValue];
        
        for (int i = 0; i < self.dataArray.count; i++) {
            BATCourseData *courseData = self.dataArray[i];
            if (courseData.ID == courseID) {
                courseData.ReadingNum = readNum;
                [_dataArray replaceObjectAtIndex:i withObject:courseData];
                [self.collectionListView.tableView reloadData];
                break;
            }
        }
    }
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
            
            [self.collectionListView.tableView.mj_header beginRefreshing];
        }];
        
    }
    return _defaultView;
}
@end
