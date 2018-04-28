//
//  BATTrainStudioIndexViewController.m
//  HealthBAT_Pro
//
//  Created by four on 17/4/1.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATTrainStudioIndexViewController.h"

#import "BATTrainStudioSearchView.h"
#import "BATTrainStudioDoctorCell.h"
#import "BATTrainStudioDoctorModel.h"
#import "BATDoctorStatusModel.h"

#import "BATTrainStudioDoctorCourseListViewController.h"
#import "BATSearchTrainstudioDoctorViewController.h"
#import "BATTrainerInfoViewController.h"
#import "BATTrainResultViewController.h"


static NSString *const TRAINSTUDIO_CELL = @"BATTrainStudioDoctorCell";

@interface BATTrainStudioIndexViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong) BATDefaultView             *defaultView;

@property (nonatomic,strong) UITableView                *TrainStudioTableView;

@property (nonatomic,strong) BATTrainStudioSearchView   *searchView;

@property (nonatomic,strong) BATDoctorStatusModel *doctorStatusModel;
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

@implementation BATTrainStudioIndexViewController

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
    [self requestGetDoctorStatusEntity];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - net

- (void)requestTrainStudioDoctorList{
    
    [HTTPTool requestWithURLString:@"/api/Doctor/GetTrainingCertificationByKeyWord" parameters:@{@"keyword":@"",@"pageIndex":@(_pageIndex),@"pageSize":@(_pageSize)} type:kGET success:^(id responseObject) {
        
        [self.TrainStudioTableView.mj_footer endRefreshing];
        [self.TrainStudioTableView.mj_header endRefreshing];
        
        if (_pageIndex == 0) {
            [_dataSource removeAllObjects];
        }
        
        BATTrainStudioDoctorModel *doctorModel = [BATTrainStudioDoctorModel mj_objectWithKeyValues:responseObject];
        
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

//医生工作室 培训工作室 审核状态
- (void)requestGetDoctorStatusEntity
{
    
    if (!LOGIN_STATION) {
        return;
    }
    
    [HTTPTool requestWithURLString:@"/api/Doctor/GetDoctorStatusEntity" parameters:nil type:kGET success:^(id responseObject) {
        
        self.doctorStatusModel = [BATDoctorStatusModel mj_objectWithKeyValues:responseObject];
        
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    BATSearchTrainstudioDoctorViewController *searchVC = [[BATSearchTrainstudioDoctorViewController alloc] init];
    searchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:YES];

    return NO;
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BATTrainStudioDoctorCell *doctorCell = [tableView dequeueReusableCellWithIdentifier:TRAINSTUDIO_CELL forIndexPath:indexPath];

    if(self.dataSource.count > 0){
        
        BATTrainStudioDoctorData *data = self.dataSource[indexPath.row];
        [doctorCell.headerImageView sd_setImageWithURL:[NSURL URLWithString:data.DoctorPic] placeholderImage:[UIImage imageNamed:@"医生"]];
        doctorCell.nameLable.text = data.UserName;
        doctorCell.levelLable.text = data.DoctorTitle;
        doctorCell.skillLable.text = [NSString stringWithFormat:@"擅长：%@",data.GoodAt];
        [doctorCell setCourseBtnClickBlock:^{
            
            DDLogInfo(@"他的课程");
            
            BATTrainStudioDoctorCourseListViewController *view = [[BATTrainStudioDoctorCourseListViewController alloc] init];
            view.doctorID = data.AccountId;
            view.doctorName = data.UserName;
            view.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:view animated:YES];
            
        }];
        [doctorCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return doctorCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}



#pragma mark - pagesLayout

- (void)pagesLayout{
    self.title = @"培训讲师";
    
    WEAK_SELF(self);
    [self.view addSubview:self.searchView];
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.height.mas_equalTo(50);
        make.left.right.top.equalTo(self.view);
    }];
    
    [self.view addSubview:self.TrainStudioTableView];
    [self.TrainStudioTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(self.view.mas_top).offset(50);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self.view addSubview:self.defaultView];
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(self.view.mas_top).offset(50);
        make.left.right.bottom.equalTo(self.view);
    }];
    
}


#pragma mark -get&&set
- (BATTrainStudioSearchView *)searchView{
    
    if (!_searchView) {
        _searchView = [[BATTrainStudioSearchView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        _searchView.searchTF.delegate = self;
        
        WEAK_SELF(self);
        [_searchView setCertificationBtnClickBlock:^{
            DDLogInfo(@"认证医生");
            STRONG_SELF(self);
            
            if (!self.doctorStatusModel) {
                
                BATTrainerInfoViewController *trainerInfoVC = [[BATTrainerInfoViewController alloc] init];
                trainerInfoVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:trainerInfoVC animated:YES];
                return ;
            }
            else {
                
                if (self.doctorStatusModel) {
                    if (self.doctorStatusModel.Data.IsOpenTrainRoom) {

                        if (self.doctorStatusModel.Data.TrainAuditing == 1) {
                            //审核通过

                        }
                        else {
                            //审核中
                            BATTrainResultViewController  *trainerResultVC = [[BATTrainResultViewController alloc] init];
                            trainerResultVC.hidesBottomBarWhenPushed = YES;
                            [self.navigationController pushViewController:trainerResultVC animated:YES];
                        }
                    }
                    else {
                        //未开通培训工作室
                        BATTrainerInfoViewController *trainerIndexVC = [[BATTrainerInfoViewController alloc] init];
                        trainerIndexVC.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:trainerIndexVC animated:YES];
                    }
                }
            }
        }];
        
    }
    return _searchView;
}


- (UITableView *)TrainStudioTableView{
    if (!_TrainStudioTableView) {
        _TrainStudioTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _TrainStudioTableView.rowHeight = UITableViewAutomaticDimension;
        _TrainStudioTableView.estimatedRowHeight = 100;
        _TrainStudioTableView.delegate = self;
        _TrainStudioTableView.dataSource = self;
        _TrainStudioTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _TrainStudioTableView.backgroundColor = UIColorFromHEX(0xf1f1f1, 1);
        
        [_TrainStudioTableView registerClass:[BATTrainStudioDoctorCell class] forCellReuseIdentifier:TRAINSTUDIO_CELL];
        
//        _TrainStudioTableView.tableHeaderView = self.searchView;
        
        WEAK_SELF(self);
        _TrainStudioTableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            STRONG_SELF(self);
            DDLogInfo(@"下拉刷新！");
            self.pageIndex = 0;
            [self.TrainStudioTableView.mj_footer resetNoMoreData];
            [self requestTrainStudioDoctorList];
        }];
        _TrainStudioTableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            STRONG_SELF(self);
            DDLogInfo(@"上拉拉加载！");
            self.pageIndex++;
            [self requestTrainStudioDoctorList];
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
            [self requestTrainStudioDoctorList];
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
