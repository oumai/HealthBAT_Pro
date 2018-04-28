//
//  BATAddressListViewController.m
//  HealthBAT
//
//  Created by cjl on 16/3/16.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATAddressListViewController.h"
#import "BATAddressListTableViewCell.h"
#import "BATAddressModel.h"
//#import "BATAddressDetailViewController.h"
#import "BATAddressManageViewController.h"
#import "BATModifyAddressViewController.h"
#import "BATGraditorButton.h"

@interface BATAddressListViewController ()

@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,strong) BATGraditorButton *manageButton;

@property (nonatomic,strong) BATDefaultView *defaultView;

@end

@implementation BATAddressListViewController

- (void)dealloc
{
    DDLogDebug(@"%s",__func__);
    self.addressListView.tableView.delegate = nil;
    self.addressListView.tableView.dataSource = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadView
{
    [super loadView];
    [self pageLayout];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"选择收货地址";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:BATRefreshAddressNotification object:nil];
    
    _dataSource = [NSMutableArray array];
    
    [self.addressListView.tableView registerNib:[UINib nibWithNibName:@"BATAddressListTableViewCell" bundle:nil] forCellReuseIdentifier:@"BATAddressListTableViewCell"];
  
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:self.manageButton]];
    
    [self.addressListView.tableView.mj_header beginRefreshing];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self requestGetAllAddressList];
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BATAddressListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATAddressListTableViewCell" forIndexPath:indexPath];
    if (_dataSource.count > 0) {
        BATAddressData *am = [_dataSource objectAtIndex:indexPath.row];

        cell.nameLabel.text = am.UserName;
        cell.phoneLabel.text = am.Mobile;

        NSString *address = @"";

        if (am.IsDefault) {
            
            NSString *defaultAdd = @"[默认地址]";
            
            address = [NSString stringWithFormat:@"%@收货地址：%@%@%@%@",defaultAdd,am.ProvinceName,am.CityName,am.AreaName,am.DetailAddress];

            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:address];

            [string setAttributes:@{NSForegroundColorAttributeName:UIColorFromHEX(0xff7200, 1)} range:NSMakeRange(0, defaultAdd.length)];

            cell.addressLabel.attributedText = string;

        } else {
            address = [NSString stringWithFormat:@"收货地址：%@%@%@%@",am.ProvinceName,am.CityName,am.AreaName,am.DetailAddress];
            cell.addressLabel.text = address;
        }
    }

    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_dataSource.count > 0) {
        BATAddressData *am = [_dataSource objectAtIndex:indexPath.row];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:BATOTCSelectReceiptUserNotification object:am];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        BATAddressData *tempAm = [self.dataSource objectAtIndex:indexPath.row];
        
        BATModifyAddressViewController *modifyAddressVC = [[BATModifyAddressViewController alloc] init];
        modifyAddressVC.addressData = tempAm;
        modifyAddressVC.isModify = YES;
        modifyAddressVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:modifyAddressVC animated:YES];
        
    }];
    editAction.backgroundColor = UIColorFromHEX(0xff950d, 1);
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否确认删除？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            BATAddressData *tempAm = [self.dataSource objectAtIndex:indexPath.row];
            
            [self requestDelContactInfo:tempAm];
        }];
        [alert addAction:cancelAction];
        [alert addAction:okAction];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }];
    deleteAction.backgroundColor = UIColorFromHEX(0xff3e31, 1);
    
    return @[deleteAction,editAction];
}

#pragma mark - Action
#pragma mark 添加新地址
- (void)addNewAddressBtnAction:(UIButton *)button
{
    BATModifyAddressViewController *modifyAddressVC = [[BATModifyAddressViewController alloc] init];
    modifyAddressVC.isModify = NO;
    modifyAddressVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:modifyAddressVC animated:YES];
}

#pragma mark - 修改或添加地址后刷新地址列表
- (void)refreshData
{
    [self.addressListView.tableView.mj_header beginRefreshing];
}

#pragma mark - NET
#pragma mark - 接口获取地址列表
- (void)requestGetAllAddressList
{
    
//    for (int i = 0; i < 20; i++) {
//        BATAddressData *addressData = [[BATAddressData alloc] init];
//        addressData.ID = @"111";
//        addressData.Name = @"测试";
//        addressData.Phone = @"13800138000";
//        addressData.NamePath = @"广东省深圳市福田区";
//        addressData.Address = @"深南大道2006号国际创新中心";
//        addressData.DoorNo = @"";
//        [_dataSource addObject:addressData];
//    }
//
//    [self.addressListView.tableView reloadData];
//
//    [self.addressListView.tableView.mj_header endRefreshing];

    
    [HTTPTool requestWithKmWlyyBaseApiURLString:@"/userAddresses/getUserAddressList" parameters:nil type:kGET success:^(id responseObject) {
        BATAddressModel *addressModel = [BATAddressModel mj_objectWithKeyValues:responseObject];

        [_dataSource removeAllObjects];
        [_dataSource addObjectsFromArray:addressModel.Data];
        
        if (self.dataSource.count == 0) {
            [self.defaultView showDefaultView];
            self.defaultView.reloadButton.hidden = YES;
        } else {
            self.defaultView.hidden = YES;
        }

        [self.addressListView.tableView reloadData];

        [self.addressListView.tableView.mj_header endRefreshing];

    } failure:^(NSError *error) {
        [self.defaultView showDefaultView];
        [self.addressListView.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - 删除收货人信息
- (void)requestDelContactInfo:(BATAddressData *)addressData
{
    [HTTPTool requestWithKmWlyyBaseApiURLString:@"/userAddresses/deleteUserAddress" parameters:@{@"ID":addressData.AddressID} type:kPOST success:^(id responseObject) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:BATRefreshAddressNotification object:nil];
        
    } failure:^(NSError *error) {
        [self showText:error.localizedDescription];
    }];
}

#pragma mark - pageLayout
- (void)pageLayout
{
    [self.view addSubview:self.addressListView];

    
    WEAK_SELF(self);
    [self.addressListView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:self.defaultView];
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 58, 0));
    }];
}

#pragma mark - get & set
- (BATGraditorButton *)manageButton
{
    if (_manageButton == nil) {
        _manageButton = [[BATGraditorButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
//        _manageButton.enablehollowOut = YES;
        [_manageButton setGradientColors:@[START_COLOR,END_COLOR]];
        _manageButton.enbleGraditor = YES;
        _manageButton.titleLabel.font = [UIFont systemFontOfSize:16];
//        [_manageButton sizeToFit];
        [_manageButton setTitle:@"管理" forState:UIControlStateNormal];
        
        WEAK_SELF(self);
        [_manageButton bk_whenTapped:^{
            STRONG_SELF(self);
            
            BATAddressManageViewController *addressManageVC = [[BATAddressManageViewController alloc] init];
            addressManageVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:addressManageVC animated:YES];
            
        }];

    }
    return _manageButton;
}

- (BATAddressListView *)addressListView
{
    if (_addressListView == nil) {
        _addressListView = [[BATAddressListView alloc] init];
        _addressListView.tableView.delegate = self;
        _addressListView.tableView.dataSource = self;
        
        WEAK_SELF(self);
        _addressListView.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            STRONG_SELF(self);
            [self requestGetAllAddressList];
        }];
        
        [_addressListView.addNewAddressButton addTarget:self action:@selector(addNewAddressBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addressListView;
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
            
            [self.addressListView.tableView.mj_header beginRefreshing];
            
        }];
        
    }
    return _defaultView;
}

@end
