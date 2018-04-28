//
//  BATAddressDetailViewController.m
//  HealthBAT
//
//  Created by cjl on 16/3/16.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATAddressDetailViewController.h"
#import "BATModifyAddressViewController.h"

@interface BATAddressDetailViewController ()

@property (nonatomic,strong) NSMutableArray *titleDataSource;

@property (nonatomic,strong) NSMutableArray *valueDateSource;

@end

@implementation BATAddressDetailViewController

- (void)dealloc
{
    _addressDetailView.tableView.delegate = nil;
    _addressDetailView.tableView.dataSource = nil;
}

- (void)loadView
{
    [super loadView];
    if (_addressDetailView == nil) {
        _addressDetailView = [[BATAddressDetailView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _addressDetailView.tableView.delegate = self;
        _addressDetailView.tableView.dataSource = self;
        [self.view addSubview:_addressDetailView];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"收货地址";
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithTitle:@"修改" style:UIBarButtonItemStylePlain target:self action:@selector(modifyAddressAction:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [_addressDetailView.defaultAddressBtn addTarget:self action:@selector(defaultAddressBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //初始化数据源
    _titleDataSource = [NSMutableArray arrayWithObjects:
                        @"收货人",
                        @"联系电话",
                        @"所在地区",
                        @"详细地址",nil];
}

- (void)viewDidLayoutSubviews
{
    if ([_addressDetailView.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_addressDetailView.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([_addressDetailView.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_addressDetailView.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return _titleDataSource.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    }
    
    if (indexPath.section == 0) {
        cell.textLabel.text = _titleDataSource[indexPath.row];
        cell.detailTextLabel.text = _valueDateSource[indexPath.row];
    } else if (indexPath.section == 1) {
        cell.textLabel.text = @"删除收货地址";
        cell.textLabel.textColor = [UIColor redColor];
    }
    
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        DDLogDebug(@"删除收货地址");
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark 设置默认地址
- (void)defaultAddressBtnAction:(id)sender
{
    DDLogDebug(@"设置默认地址");
}

#pragma mark 修改收货地址
- (void)modifyAddressAction:(id)sender
{
//    BATModifyAddressViewController *modifyAddressVC = [[BATModifyAddressViewController alloc] init];
//    modifyAddressVC.isAddNewAddress = NO;
////    modifyAddressVC.addressModel = _addressModel;
//    modifyAddressVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:modifyAddressVC animated:YES];
}

@end
