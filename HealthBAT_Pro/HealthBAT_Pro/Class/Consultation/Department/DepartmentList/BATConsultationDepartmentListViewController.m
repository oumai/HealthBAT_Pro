//
//  BATDepartmentListViewController.m
//  HealthBAT_Pro
//
//  Created by Skyrim on 16/9/5.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATConsultationDepartmentListViewController.h"

#import "BATConsultationDepartmentModel.h"

#import "BATConsultationDepartmentDetailViewController.h"

static  NSString * const DEPARTMENT_CELL = @"DepartmentCell";

@interface BATConsultationDepartmentListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *departmentListTableView;
@property (nonatomic,strong) BATConsultationDepartmentModel *consultationDepartmentModel;

@property (nonatomic,strong) NSString *beginTime;

@property (nonatomic,assign) BOOL isPopAction;


@end

@implementation BATConsultationDepartmentListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"科室";
    [self layoutPages];
    [self departmentRequest];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.isPopAction) {
       [BATUserPortrayTools saveOperateModuleRequestWithURL:@"/kmStatistical-sync/saveOperateModule" pathName:[NSString stringWithFormat:@"%@-%@",self.pathName,@"科室"] moduleId:3 beginTime:self.beginTime];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.consultationDepartmentModel.Data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *departmentCell = [tableView dequeueReusableCellWithIdentifier:DEPARTMENT_CELL forIndexPath:indexPath];
    ConsultationDepartmentData *department = self.consultationDepartmentModel.Data[indexPath.row];
    departmentCell.textLabel.text = department.CATNAME;
    departmentCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return departmentCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    self.isPopAction = NO;
    
    ConsultationDepartmentData *department = self.consultationDepartmentModel.Data[indexPath.row];
    //点击科室
    BATConsultationDepartmentDetailViewController *departDetailVC = [[BATConsultationDepartmentDetailViewController alloc] init];
    departDetailVC.title = department.CATNAME;
    departDetailVC.departmentName = department.CATNAME;
    departDetailVC.pathName = [NSString stringWithFormat:@"%@-%@-%@",self.pathName,@"科室",department.CATNAME];
    [self.navigationController pushViewController:departDetailVC animated:YES];
}



#pragma mark - net
//科室
- (void)departmentRequest {

//    //路径
//    NSString *file = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/departmentList.data"];
//    if ([[NSFileManager defaultManager] fileExistsAtPath:file]) {
//
//        self.consultationDepartmentModel = [NSKeyedUnarchiver unarchiveObjectWithFile:file];
//        [self.departmentListTableView reloadData];
//        return;
//    }
    
    [HTTPTool requestWithURLString:@"/api/NetworkMedical/GetPubDepartmentList" parameters:nil type:kGET success:^(id responseObject) {
        self.consultationDepartmentModel = [BATConsultationDepartmentModel mj_objectWithKeyValues:responseObject];
        [self.departmentListTableView reloadData];
        
//        [NSKeyedArchiver archiveRootObject:self.consultationDepartmentModel toFile:file];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - layout
- (void)layoutPages {
    self.isPopAction  = YES;
    self.beginTime = [Tools getCurrentDateStringByFormat:@"yyyy-MM-dd HH:mm:ss"];
    [self.view addSubview:self.departmentListTableView];
    [self.departmentListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - getter
- (UITableView *)departmentListTableView {

    if (!_departmentListTableView) {
        _departmentListTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _departmentListTableView.delegate = self;
        _departmentListTableView.dataSource = self;
        _departmentListTableView.tableFooterView = [UIView new];
        _departmentListTableView.estimatedRowHeight = 44;
        _departmentListTableView.rowHeight = UITableViewAutomaticDimension;

        [_departmentListTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:DEPARTMENT_CELL];

    }
    return _departmentListTableView;
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
