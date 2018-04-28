//
//  BATAddressManageViewController.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/10/18.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATAddressManageViewController.h"
#import "BATAddressManageTableViewCell.h"
#import "BATAddressModel.h"
#import "BATModifyAddressViewController.h"

@interface BATAddressManageViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,strong) BATDefaultView *defaultView;

@end

@implementation BATAddressManageViewController

- (void)dealloc
{
    DDLogDebug(@"%s",__func__);
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadView
{
    [super loadView];
    
    [self pageLayout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"管理收货地址";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:BATRefreshAddressNotification object:nil];
    
    [self.addressManageView.tableView registerNib:[UINib nibWithNibName:@"BATAddressManageTableViewCell" bundle:nil] forCellReuseIdentifier:@"BATAddressManageTableViewCell"];
    
    self.dataSource = [NSMutableArray array];
    
    [self.addressManageView.tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BATAddressManageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATAddressManageTableViewCell" forIndexPath:indexPath];
    if (_dataSource.count > 0) {
        BATAddressData *am = [self.dataSource objectAtIndex:indexPath.section];

        cell.nameLabel.text = am.UserName;
        cell.phoneLabel.text = am.Mobile;
        cell.defaultButton.selected = am.IsDefault;

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
        
        WEAK_SELF(self);
        [cell.defaultButton bk_whenTapped:^{
            STRONG_SELF(self);
            
            BATAddressData *tempAm = [self.dataSource objectAtIndex:indexPath.section];
            
            [self requestSetDefaultContact:tempAm];
        }];
        
        [cell.deleteButton bk_whenTapped:^{
            STRONG_SELF(self);
            
            
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否确认删除？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                BATAddressData *tempAm = [self.dataSource objectAtIndex:indexPath.section];
                
                [self requestDelContactInfo:tempAm];
            }];
            [alert addAction:cancelAction];
            [alert addAction:okAction];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }];
        
        [cell.editButton bk_whenTapped:^{
            STRONG_SELF(self);
            BATAddressData *tempAm = [self.dataSource objectAtIndex:indexPath.section];
            BATModifyAddressViewController *modifyAddressVC = [[BATModifyAddressViewController alloc] init];
            modifyAddressVC.addressData = tempAm;
            modifyAddressVC.isModify = YES;
            modifyAddressVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:modifyAddressVC animated:YES];
            
        }];
    }


    
//    cell.nameLabel.text = @"12312313";
//    cell.phoneLabel.text = @"1838888888";
//
//    NSString *defaultAdd = @"[默认地址]";
//
//    NSString *address = [NSString stringWithFormat:@"%@收货地址：广东省揭阳市普宁流沙长春路南侧康美药业大厦一楼左侧",defaultAdd];
//
//    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:address];
//
//    [string setAttributes:@{NSForegroundColorAttributeName:UIColorFromHEX(0xff7200, 1)} range:NSMakeRange(0, defaultAdd.length)];
//
//    cell.addressLabel.attributedText = string;
    
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
    [self.addressManageView.tableView.mj_header beginRefreshing];
}

#pragma mark - NET
#pragma mark - 接口获取地址列表
- (void)requestGetAllAddressList
{
    [HTTPTool requestWithKmWlyyBaseApiURLString:@"/userAddresses/getUserAddressList" parameters:nil type:kGET success:^(id responseObject) {
        BATAddressModel *addressModel = [BATAddressModel mj_objectWithKeyValues:responseObject];
        
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:addressModel.Data];
        
        if (self.dataSource.count == 0) {
            [self.defaultView showDefaultView];
            self.defaultView.reloadButton.hidden = YES;
        } else {
            self.defaultView.hidden = YES;
        }
        
        [self.addressManageView.tableView reloadData];
        
        [self.addressManageView.tableView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        [self.defaultView showDefaultView];
        [self.addressManageView.tableView.mj_header endRefreshing];
        
    }];
}

#pragma mark - 设置默认收货人
- (void)requestSetDefaultContact:(BATAddressData *)addressData
{
    [HTTPTool requestWithKmWlyyBaseApiURLString:@"/userAddresses/setDefaultAddress" parameters:@{@"ID":addressData.AddressID} type:kPOST success:^(id responseObject) {
        
        [self requestGetAllAddressList];
        
    } failure:^(NSError *error) {
        [self showText:error.localizedDescription];
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
    [self.view addSubview:self.addressManageView];
    
    WEAK_SELF(self);
    [self.addressManageView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:self.defaultView];
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 58, 0));
    }];
}

#pragma mark - get & set
- (BATAddressManageView *)addressManageView
{
    if (_addressManageView == nil) {
        _addressManageView = [[BATAddressManageView alloc] init];
        _addressManageView.tableView.delegate = self;
        _addressManageView.tableView.dataSource = self;
        
        WEAK_SELF(self);
        _addressManageView.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            STRONG_SELF(self);
            [self requestGetAllAddressList];
        }];
        
        [_addressManageView.addNewAddressButton addTarget:self action:@selector(addNewAddressBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addressManageView;
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
            
            [self.addressManageView.tableView.mj_header beginRefreshing];
            
        }];
        
    }
    return _defaultView;
}

@end
