//
//  BATServiceRecordViewController.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/23.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATServiceRecordViewController.h"
#import "BATHealthAssessmentRecordViewController.h"
#import "BATRegistrationRecordViewController.h"

@interface BATServiceRecordViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSString *beginTime;
@end

@implementation BATServiceRecordViewController

- (void)dealloc
{
    DDLogDebug(@"%@",self);
    _serviceRecordView.tableView.delegate = nil;
    _serviceRecordView.tableView.dataSource = nil;
}

- (void)loadView
{
    [super loadView];
    
    if (_serviceRecordView == nil) {
        _serviceRecordView = [[BATServiceRecordView alloc] init];
        _serviceRecordView.tableView.delegate = self;
        _serviceRecordView.tableView.dataSource = self;
        [self.view addSubview:_serviceRecordView];
        
        [_serviceRecordView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.beginTime = [Tools getCurrentDateStringByFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.title = @"服务记录";
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
     [BATUserPortrayTools saveOperateModuleRequestWithURL:@"/kmStatistical-sync/saveOperateModule" pathName:@"个人中心-服务记录" moduleId:4 beginTime:self.beginTime];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDatasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"ServiceRecordCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    }
    
//    if (indexPath.row == 0) {
//        cell.textLabel.text = @"挂号记录";
//    } else if (indexPath.row == 1) {
//        cell.textLabel.text = @"轻咨询记录";
//    } else if (indexPath.row == 2) {
//        cell.textLabel.text = @"健康评测记录";
//    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"挂号记录";
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"健康评测记录";
    }
    return cell;
}
#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            //挂号记录
            DDLogDebug(@"挂号记录");
            BATRegistrationRecordViewController *regiserationRecordVC = [[BATRegistrationRecordViewController alloc]init];
            [self.navigationController pushViewController:regiserationRecordVC animated:YES];
        }
            break;
        case 1:
        {
            //健康评测记录
            DDLogDebug(@"健康评测记录");
            BATHealthAssessmentRecordViewController *healthAssessmentRecordVC = [BATHealthAssessmentRecordViewController new];
            [self.navigationController pushViewController:healthAssessmentRecordVC animated:YES];
            
        }
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
