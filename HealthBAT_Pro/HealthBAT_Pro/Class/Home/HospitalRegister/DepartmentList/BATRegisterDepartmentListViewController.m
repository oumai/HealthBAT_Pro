//
//  HospitalViewController.m
//  HealthBAT_Pro
//
//  Created by KM on 16/7/142016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATRegisterDepartmentListViewController.h"
//第三方
#import "UIScrollView+EmptyDataSet.h"
//子视图
#import "BATAreaTableViewCell.h"

#import "BATLeftAreaTableViewCell.h"

#import "BATDoctorTableViewCell.h"
#import "BATDepartmentModel.h"
#import "BATDoctorModel.h"
#import "BATHospitalModel.h"

#import "BATDoctorDutyViewController.h"
#import "BATLoginViewController.h"
#import "BATConsultationDoctorDetailViewController.h"

static  NSString * const LEFT_CELL = @"leftCell";
static  NSString * const RIGHT_CELL = @"rightCell";

@interface BATRegisterDepartmentListViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>


@property (nonatomic,strong) UITableView        *leftTableView;
@property (nonatomic,strong) UITableView        *rightTableView;
@property (nonatomic,strong) NSMutableArray     *dataArray;
@property (nonatomic,assign) int                currentPageIndex;
@property (nonatomic,assign) NSInteger          departmentId;
@property (nonatomic,strong) BATDepartmentModel *departmentModel;
@property (nonatomic,strong) NSMutableArray     *doctorList;
//@property (nonatomic,strong) BATDoctorModel     *doctorList;
@property (nonatomic,copy  ) NSString           *collectionState;

@property (nonatomic,strong) UIBarButtonItem    *collectBarButton;
@property (nonatomic,strong) UIBarButtonItem    *cancelCollectBarButton;

@property (nonatomic,strong) NSString *beginTime;
@property (nonatomic,assign) BOOL isPopAction;
@property (nonatomic,strong) NSString *deptName;


@property (nonatomic,assign) NSUInteger currentIndexPath;//当前indexPath
@property (nonatomic,assign) BOOL isSelcet;//上一个indexPath

@property (nonatomic,assign) BOOL isCompleteRequest;

@property (nonatomic,strong) BATDefaultView *defaultView;

@end

@implementation BATRegisterDepartmentListViewController
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _currentIndexPath = 0;
    _isSelcet = NO;
    _isCompleteRequest = NO;
    
    self.title = self.hospitalName;
    
    self.doctorList = [NSMutableArray array];
    
    [self pagesLayout];
    
    [self departmentDataRequest];
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    if (self.isPopAction) {
        [BATUserPortrayTools saveOperateModuleRequestWithURL:@"/kmStatistical-sync/saveOperateModule" pathName:[NSString stringWithFormat:@"首页-预约挂号-%@",self.pathName] moduleId:1 beginTime:self.beginTime];
    }
    
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
    if (tableView == self.leftTableView) {
        return self.departmentModel.Data.count;
    }
    return self.doctorList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == _leftTableView){
        return 50;
    }else{
        return 70;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.leftTableView) {
        
        BATLeftAreaTableViewCell * areaCell = [tableView dequeueReusableCellWithIdentifier:LEFT_CELL forIndexPath:indexPath];
        BATDepartmentData * department = self.departmentModel.Data[indexPath.row];
        [areaCell.nameLb setTitle:department.DEP_NAME forState:UIControlStateNormal];
        areaCell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_isSelcet == NO) {
            if (_currentIndexPath == 0 && indexPath.row == 0) {
                areaCell.lineView.hidden = NO;
                //  areaCell.nameLb.textColor = UIColorFromHEX(0x0182eb, 1);
                [areaCell.nameLb setGradientColors:@[START_COLOR,END_COLOR]];
                areaCell.backView.backgroundColor = [UIColor whiteColor];
            }else{
                areaCell.lineView.hidden = YES;
                // areaCell.nameLb.textColor = UIColorFromHEX(0x666666, 1);
                [areaCell.nameLb setGradientColors:@[UIColorFromHEX(0X666666, 1),UIColorFromHEX(0X666666, 1)]];
                areaCell.backView.backgroundColor = UIColorFromHEX(0xf0f0f0, 1);
            }
        }else{
            if (_currentIndexPath == indexPath.row) {
                areaCell.lineView.hidden = NO;
                [areaCell.nameLb setGradientColors:@[START_COLOR,END_COLOR]];
                areaCell.backView.backgroundColor = [UIColor whiteColor];
            }else{
                areaCell.lineView.hidden = YES;
                [areaCell.nameLb setGradientColors:@[UIColorFromHEX(0X666666, 1),UIColorFromHEX(0X666666, 1)]];
                areaCell.backView.backgroundColor = UIColorFromHEX(0xf0f0f0, 1);
            }
        }
        return areaCell;
    }
    else {
        
        BATDoctorTableViewCell * doctorCell = [tableView dequeueReusableCellWithIdentifier:RIGHT_CELL forIndexPath:indexPath];
        
        BATDoctorData * doctor = self.doctorList[indexPath.row];
        [doctorCell.headerImageView sd_setImageWithURL:[NSURL URLWithString:doctor.IMAGE] placeholderImage:[UIImage imageNamed:@"医生"]];
        doctorCell.nameLabel.text = doctor.DOCTOR_NAME;
        doctorCell.descriptionLabel.text = doctor.EXPERT;
        
        if (doctor.LEFT_NUM.integerValue > 0) {
            doctorCell.stateImageView.image = [UIImage imageNamed:@"icon-yuyue"];
        } else {
            doctorCell.stateImageView.image = [UIImage imageNamed:@"icon-yiman"];
        }
        
        return doctorCell;
    }
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    if (tableView == self.leftTableView) {
        
        
        
        //做变色效果
        _currentIndexPath = indexPath.row;
        _isSelcet = YES;
        [self.leftTableView reloadData];
        
        BATDepartmentData * department = self.departmentModel.Data[indexPath.row];
        self.departmentId = department.DEP_ID;
        self.deptName = department.DEP_NAME;
        
        
        [self.rightTableView.mj_header beginRefreshing];
    }
    
    if (tableView == self.rightTableView ) {
        BATDoctorData * doctor = self.doctorList[indexPath.row];
        BATConsultationDoctorDetailViewController *doctorVC = [[BATConsultationDoctorDetailViewController alloc] init];
        doctorVC.doctorID = [NSString stringWithFormat:@"%ld",(long)doctor.DOCTOR_ID];
        doctorVC.isKMDoctor = NO;
        doctorVC.isSaveOperate = YES;
        doctorVC.pathName = [NSString stringWithFormat:@"%@-%@-%@",self.pathName,self.deptName,doctor.DOCTOR_NAME];
        [self.navigationController pushViewController:doctorVC animated:YES];
  
    }
}

#pragma mark - DZNEmptyDataSetSource
//返回标题文字
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f], NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

//返回详情文字
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    if (!self.isCompleteRequest) {
        return nil;
    }
    
    NSString *text = @"暂无该科室医生信息";
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName: [UIColor lightGrayColor], NSParagraphStyleAttributeName: paragraph};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

#pragma mark - NET
- (void)departmentDataRequest {
    
    NSDictionary *parammeters = @{
                                  @"uid":@(self.hospitalId),
                                  @"depid":@"",
                                  @"cat_no":@"",
                                  @"his_dep_id":@"",
                                  @"dep_class":@"",
                                  @"city_id":@"",
                                  @"page":@"",
                                  @"page_size":@"",
                                  @"showAll":@"1",
                                  };
    
    
    [HTTPTool requestWithURLString:@"/api/HospitalExternal/GetDepartmentList" parameters:parammeters type:kGET success:^(id responseObject) {
        self.departmentModel = [BATDepartmentModel mj_objectWithKeyValues:responseObject];
        [self.leftTableView reloadData];
        if (self.departmentModel.Data.count > 0) {
            
            [self tableView:self.leftTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        }
    } failure:^(NSError *error) {
        [self.defaultView showDefaultView];
    }];
}

- (void)doctorDataRequest {
    
    NSDictionary *parammeters = @{
                                  @"uid":@(self.hospitalId),
                                  @"depid":@(self.departmentId),
                                  @"doctorid":@"",
                                  @"pageSize":@"10",
                                  @"pageIndex":@(self.currentPageIndex)
                                  };
    [HTTPTool requestWithURLString:@"/api/DoctorExternal/GetDoctorList" parameters:parammeters type:kGET success:^(id responseObject) {
        
        
        _isCompleteRequest = YES;
        if (self.currentPageIndex == 0) {
            [self.doctorList removeAllObjects];
        }
        
        
        
        BATDoctorModel *doctorModel = [BATDoctorModel mj_objectWithKeyValues:responseObject];
        [self.doctorList addObjectsFromArray:doctorModel.Data];
        
        
        [self.rightTableView.mj_header endRefreshingWithCompletionBlock:^{
            
            if (self.doctorList.count > 0) {
                BATDoctorData *doctor = self.doctorList[0];
                if (![doctor.DEP_ID isEqualToString:[NSString stringWithFormat:@"%ld",(long)self.departmentId]]) {
                    
                    [self.rightTableView.mj_header beginRefreshing];
                }
            }
        }];
        
        [self.rightTableView.mj_footer endRefreshing];
        
        if (self.doctorList.count >= doctorModel.RecordsCount) {
            
            [self.rightTableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.rightTableView reloadData];
        
        
        
        
        
    } failure:^(NSError *error) {
        [self.rightTableView.mj_header endRefreshing];
        [self.rightTableView.mj_footer endRefreshing];
        
        [self.defaultView showDefaultView];
    }];
}

- (void)collectionHospitalRequest {
    
    if (!LOGIN_STATION) {
        
        PRESENT_LOGIN_VC;
        return;
    }
    [HTTPTool requestWithURLString:@"/api/CollectLink/AddCollectLink" parameters:@{@"OBJ_ID":@(self.hospitalId),@"OBJ_TYPE":@(kBATCollectionLinkTypeHospital)} type:kPOST success:^(id responseObject) {
        
        [self showText:@"收藏成功"];
        self.navigationItem.rightBarButtonItem = self.cancelCollectBarButton;
    } failure:^(NSError *error) {
        
        [self showText:@"收藏失败"];
    }];
}

- (void)cancelCollectionHospitalRequest {
    
    if (!LOGIN_STATION) {
        
        PRESENT_LOGIN_VC;
        return;
    }
    //取消收藏
    [HTTPTool requestWithURLString:@"/api/CollectLink/CanelCollectLink" parameters:@{@"OBJ_ID":@(self.hospitalId),@"OBJ_TYPE":@(kBATCollectionLinkTypeHospital)} type:kPOST success:^(id responseObject) {
        
        [self showText:@"取消成功"];
        self.navigationItem.rightBarButtonItem = self.collectBarButton;
    } failure:^(NSError *error) {
        
        [self showText:@"取消失败"];
    }];
}

- (void)collectedHospitalListRequest {
    
    if (!LOGIN_STATION) {
        
        PRESENT_LOGIN_VC;
        return;
    }
    
    [HTTPTool requestWithURLString:@"/api/CollectLink/GetCollectWithHospital" parameters:nil type:kGET success:^(id responseObject) {
        BATHospitalModel *collectionHospitals = [BATHospitalModel mj_objectWithKeyValues:responseObject];
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF.UNIT_ID == %d",self.hospitalId];
        NSArray * tmpArray  =  [collectionHospitals.Data filteredArrayUsingPredicate:predicate];
        if (tmpArray.count > 0) {
            //已经收藏
            self.navigationItem.rightBarButtonItem = self.cancelCollectBarButton;
        }
        else {
            //未收藏
            self.navigationItem.rightBarButtonItem = self.collectBarButton;
        }
    } failure:^(NSError *error) {
        DDLogInfo(@"error === %@",error.localizedDescription);
    }];
}

#pragma mark - layout
- (void)pagesLayout {
    
    self.isPopAction = YES;
    self.beginTime = [Tools getCurrentDateStringByFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    [self.view addSubview:self.leftTableView];
    [self.view addSubview:self.rightTableView];

    if (LOGIN_STATION == YES) {
        [self collectedHospitalListRequest];
    }
    else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"icon-dz"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(collectedHospitalListRequest)];
    }
    
    [self.view addSubview:self.defaultView];
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.top.equalTo(self.view);
    }];
}

#pragma mark - setter && getter

- (UITableView *)leftTableView {
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 100, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _leftTableView.tableFooterView = [UIView new];
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _leftTableView.bounces = NO;
        _leftTableView.backgroundColor = UIColorFromRGB(240, 240, 240, 1);
        _leftTableView.estimatedRowHeight = 44;
        _leftTableView.rowHeight = UITableViewAutomaticDimension;
        //        [_leftTableView registerClass:[BATAreaTableViewCell class] forCellReuseIdentifier:LEFT_CELL];
        [_leftTableView registerClass:[BATLeftAreaTableViewCell class] forCellReuseIdentifier:LEFT_CELL];
    }
    return _leftTableView;
}

- (UITableView *)rightTableView {
    if (!_rightTableView) {
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(100, 0, SCREEN_WIDTH-100, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        _rightTableView.tableFooterView = [UIView new];
        _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _rightTableView.emptyDataSetSource = self;
        _rightTableView.emptyDataSetDelegate = self;
        _rightTableView.rowHeight = 80;
        _rightTableView.backgroundColor = BASE_BACKGROUND_COLOR;
        [_rightTableView registerClass:[BATDoctorTableViewCell class] forCellReuseIdentifier:RIGHT_CELL];
        WEAK_SELF(self);
        _rightTableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.currentPageIndex = 0;
            [self.rightTableView.mj_footer resetNoMoreData];
            [self doctorDataRequest];
        }];
        _rightTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.currentPageIndex ++;
            [self doctorDataRequest];
        }];
    }
    return _rightTableView;
}

- (UIBarButtonItem *)collectBarButton {
    
    if (!_collectBarButton) {
        _collectBarButton = [[UIBarButtonItem alloc] bk_initWithImage:[[UIImage imageNamed:@"icon-dz"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain handler:^(id sender) {
            [self collectionHospitalRequest];
        }];
    }
    return _collectBarButton;
}

- (UIBarButtonItem *)cancelCollectBarButton {
    
    if (!_cancelCollectBarButton) {
        _cancelCollectBarButton = [[UIBarButtonItem alloc] bk_initWithImage:[[UIImage imageNamed:@"icon-yjdz"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain handler:^(id sender) {
            [self cancelCollectionHospitalRequest];
        }];
    }
    return _cancelCollectBarButton;
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
            
            [self departmentDataRequest];
            [self.rightTableView.mj_header beginRefreshing];
            
            if (LOGIN_STATION == YES) {
                
                [self collectedHospitalListRequest];
            }
            else {
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"icon-dz"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(collectedHospitalListRequest)];
            }
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
