//
//  BATReportViewController.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/9/2.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATReportViewController.h"

@interface BATReportViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,assign) NSInteger selectIndex;

@end

@implementation BATReportViewController

- (void)dealloc
{
    DDLogWarn(@"%@",self);
    _reportView.tableView.delegate = nil;
    _reportView.tableView.dataSource = nil;
}

- (void)loadView
{
    [super loadView];
    
    if (_reportView == nil) {
        _reportView = [[BATReportView alloc] init];
        _reportView.tableView.delegate = self;
        _reportView.tableView.dataSource = self;
        _reportView.tableView.rowHeight = UITableViewAutomaticDimension;
        _reportView.tableView.estimatedRowHeight = 54;
        [self.view addSubview:_reportView];
        
        WEAK_SELF(self);
        [_reportView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.edges.equalTo(self.view);
        }];
    }
    
    WEAK_SELF(self);
    UIBarButtonItem *submitBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"提交" style:UIBarButtonItemStyleDone handler:^(id sender) {
        STRONG_SELF(self);
        [self requestSubmitReport];
    }];
    
    self.navigationItem.rightBarButtonItem = submitBarButtonItem;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"举报";
    
    _dataSource = [NSMutableArray arrayWithObjects:@"色情低俗",@"广告骚扰",@"政治敏感",@"欺诈骗钱",@"违法（暴力恐怖、违禁品等）", nil];
    _selectIndex = -1;
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


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 54)];
    sectionHeaderView.backgroundColor = [UIColor clearColor];
    
    UILabel *nameLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width - 30, 54)];
    nameLab.backgroundColor = [UIColor clearColor];
    nameLab.textAlignment = NSTextAlignmentLeft;
    nameLab.text = @"举报原因";
    nameLab.font = [UIFont systemFontOfSize:15];
    nameLab.textColor = STRING_MID_COLOR;
    [sectionHeaderView addSubview:nameLab];
    
    return sectionHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 54.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifer = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:17];
    }
    
    if (_dataSource.count > 0) {
        cell.textLabel.text = _dataSource[indexPath.row];
        
        if (_selectIndex == indexPath.row) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _selectIndex = indexPath.row;
    [tableView reloadData];
}

#pragma mark - NET

#pragma mark - 提交举报
- (void)requestSubmitReport
{
    
    if (_selectIndex == -1) {
        [self showText:@"请选择举报原因"];
    }
    
    [HTTPTool requestWithURLString:@"/api/DynamicLoop/Report" parameters:@{@"postId":_postId,@"Content":_dataSource[_selectIndex]} type:kPOST success:^(id responseObject) {
        
        [self showText:@"举报成功"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    } failure:^(NSError *error) {
        
    }];
    
    
    //    [HTTPTool requestWithURLString:@"/api/DynamicLoop/Report" parameters:@{@"DynamicLoopsID":@(_bizRecordID),@"Content":_dataSource[_selectIndex]} type:kPOST success:^(id responseObject) {
    //
    //        [self showText:@"举报成功"];
    //
    //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //            [self.navigationController popViewControllerAnimated:YES];
    //        });
    //
    //    } failure:^(NSError *error) {
    //        
    //    }];
}

@end
