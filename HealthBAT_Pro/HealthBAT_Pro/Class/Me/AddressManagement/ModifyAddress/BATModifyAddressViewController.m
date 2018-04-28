//
//  BATModifyAddressViewController.m
//  HealthBAT
//
//  Created by cjl on 16/3/16.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATModifyAddressViewController.h"
#import "BATCustomTextFieldTableViewCell.h"
#import "BATCustomTextViewTableViewCell.h"
#import "BATCustomSwitchTableViewCell.h"
#import "BATDeleteAddressTableViewCell.h"
#import "BATRegionModel.h"

typedef NS_ENUM(NSInteger, AddressTextField) {
    kNameTF       = 1101,
    kPhoneTF,
    kAreaTF,
    kDetailTF,
};

@interface BATModifyAddressViewController () <UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,YYTextViewDelegate>

@property (nonatomic,strong) BATRegionModel *rm;

/**
 *  省数据源
 */
@property (nonatomic,strong) NSMutableArray *provinceDateSource;

/**
 *  城市数据源
 */
@property (nonatomic,strong) NSMutableArray *cityDataSource;

/**
 *  区域数据源
 */
@property (nonatomic,strong) NSMutableArray *areaDataSource;

//@property (nonatomic,strong) NSString *pName;
//@property (nonatomic,assign) NSInteger pCode;

//@property (nonatomic,strong) NSString *cName;
//@property (nonatomic,assign) NSInteger cCode;

//@property (nonatomic,strong) NSString *aName;
//@property (nonatomic,assign) NSInteger aCode;

@property (nonatomic,strong) UIToolbar *toolBar;

@property (nonatomic,strong) BATGraditorButton *saveButton;

@end

@implementation BATModifyAddressViewController

- (void)dealloc
{
    DDLogDebug(@"%s",__func__);
    self.modifyAddressView.tableView.delegate = nil;
    self.modifyAddressView.tableView.dataSource = nil;
    self.modifyAddressView.pickerView.delegate = nil;
    self.modifyAddressView.pickerView.dataSource = nil;
}

- (void)loadView
{
    [super loadView];
    [self pageLayout];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    [self.modifyAddressView.tableView registerNib:[UINib nibWithNibName:@"BATCustomTextFieldTableViewCell" bundle:nil] forCellReuseIdentifier:@"BATCustomTextFieldTableViewCell"];
    [self.modifyAddressView.tableView registerNib:[UINib nibWithNibName:@"BATCustomTextViewTableViewCell" bundle:nil] forCellReuseIdentifier:@"BATCustomTextViewTableViewCell"];
    [self.modifyAddressView.tableView registerNib:[UINib nibWithNibName:@"BATCustomSwitchTableViewCell" bundle:nil] forCellReuseIdentifier:@"BATCustomSwitchTableViewCell"];
    [self.modifyAddressView.tableView registerNib:[UINib nibWithNibName:@"BATDeleteAddressTableViewCell" bundle:nil] forCellReuseIdentifier:@"BATDeleteAddressTableViewCell"];
    
    [self requestGetAllRegionList];
    
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:self.saveButton]];
    
    _provinceDateSource = [NSMutableArray array];
    _cityDataSource = [NSMutableArray array];
    _areaDataSource = [NSMutableArray array];
    
    if (!self.isModify) {
        self.title = @"添加新地址";
        //新增地址时。初始化空的地址Model 以便记录填写的地址数据
        _addressData = [[BATAddressData alloc] init];
        _addressData.UserName = @"";
        _addressData.Mobile = @"";
        _addressData.ProvinceName = @"";
        _addressData.CityName = @"";
        _addressData.AreaName = @"";
        _addressData.DetailAddress = @"";
    } else {
        self.title = @"编辑地址";
    }
    
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.isModify) {
        return 3;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || indexPath.section == 2) {
        return 45;
    }
    
    return 116;
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
//    if (section == 1) {
//        return 64;
//    }
    
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        BATCustomTextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATCustomTextFieldTableViewCell" forIndexPath:indexPath];

        cell.textField.inputView = nil;
        cell.textField.delegate = self;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textField.inputAccessoryView = nil;

        if (indexPath.row == 0) {
            cell.NameLabel.text = @"收货人";
            cell.textField.placeholder = @"请输入收货人姓名";
            cell.textField.text = _addressData.UserName;
            cell.textField.tag = kNameTF;
            cell.textField.delegate = self;

        } else if (indexPath.row == 1) {
            cell.NameLabel.text = @"联系电话";
            cell.textField.placeholder = @"请输入联系电话";
            cell.textField.text = _addressData.Mobile;
            cell.textField.keyboardType = UIKeyboardTypeNumberPad;
            cell.textField.tag = kPhoneTF;
            cell.textField.delegate = self;
        }
        else if (indexPath.row == 2) {
            cell.textField.inputAccessoryView = self.toolBar;
            cell.NameLabel.text = @"选择地区";
            cell.textField.placeholder = @"省市区";
            cell.textField.text = [NSString stringWithFormat:@"%@%@%@",_addressData.ProvinceName,_addressData.CityName,_addressData.AreaName];
            cell.textField.inputView = _modifyAddressView.pickerView;
            cell.textField.tag = kAreaTF;
            cell.textField.delegate = self;
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        return cell;
    } else if (indexPath.section == 1) {
        BATCustomTextViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATCustomTextViewTableViewCell" forIndexPath:indexPath];
        cell.textView.delegate = self;
        cell.textView.text = _addressData.DetailAddress;
        
        return cell;
    } else if (indexPath.section == 2) {
        BATDeleteAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATDeleteAddressTableViewCell" forIndexPath:indexPath];
        return cell;
    }

    return nil;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isModify && indexPath.section == 2) {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否确认删除？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self requestDelContactInfo];
        }];
        [alert addAction:cancelAction];
        [alert addAction:okAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{

    switch (textField.tag) {
        case kNameTF:
            _addressData.UserName = textField.text;
            break;
        case kPhoneTF:
            _addressData.Mobile = textField.text;
            break;
        case kAreaTF:
            textField.text = textField.text;
            break;
        case kDetailTF:

            break;
    }
    
    [self.modifyAddressView.tableView reloadData];

}

- (void)textViewDidChange:(YYTextView *)textView {
    
    _addressData.DetailAddress = textView.text;
    
}

#pragma mark UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return _provinceDateSource.count;
    } else if (component == 1) {
        return _cityDataSource.count;
    }
    return _areaDataSource.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        BATRegionItem *ri = _provinceDateSource[row];
        return ri.Name;
    } else if (component == 1) {
        BATRegionItem *ri = _cityDataSource[row];
        return ri.Name;
    }
    BATRegionItem *ri = _areaDataSource[row];
    return ri.Name;
}

#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if (_provinceDateSource.count == 0 || _cityDataSource.count == 0 || _areaDataSource.count == 0) {
        return;
    }
    
    if (component == 0) {
        BATRegionItem *pri = _provinceDateSource[row];
        [_cityDataSource removeAllObjects];
        [_cityDataSource addObjectsFromArray:[self getSubAreaWithCode:pri.Code]];
        
        if (_cityDataSource.count == 0) {
            [_areaDataSource removeAllObjects];
            
            [pickerView reloadComponent:1];
            [pickerView selectRow:0 inComponent:1 animated:YES];
            [pickerView reloadComponent:2];
            [pickerView selectRow:0 inComponent:2 animated:YES];
            return;
        }

        BATRegionItem *cri = _cityDataSource[0];
        [_areaDataSource removeAllObjects];
        [_areaDataSource addObjectsFromArray:[self getSubAreaWithCode:cri.Code]];
        
        if (_areaDataSource.count == 0) {
            [pickerView reloadComponent:2];
            [pickerView selectRow:0 inComponent:2 animated:YES];
            return;
        }

        BATRegionItem *ari = _areaDataSource[0];

        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
        
        _addressData.ProvinceName = pri.Name;
//        _pCode = pri.Code;
        _addressData.CityName = cri.Name;
//        _cCode = cri.Code;
        _addressData.AreaName = ari.Name;
//        _aCode = ari.Code;
        
//        _addressData.NamePath = [NSString stringWithFormat:@"^%@^%@^%@^",_pName,_cName,_aName];
//        _addressData.CodePath = [NSString stringWithFormat:@"^%ld^%ld^%ld^",(long)_pCode,(long)_cCode,(long)_aCode];

    } else if (component == 1) {
        
        
        BATRegionItem *cri = _cityDataSource[row];
        
        [_areaDataSource removeAllObjects];
        [_areaDataSource addObjectsFromArray:[self getSubAreaWithCode:cri.Code]];
        
        if (_areaDataSource.count == 0) {
            [pickerView reloadComponent:2];
            [pickerView selectRow:0 inComponent:2 animated:YES];
            return;
        }

        BATRegionItem *ari = _areaDataSource[0];

        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
        
        if ([_addressData.ProvinceName isEqualToString:@""]) {
            NSInteger prow = [pickerView selectedRowInComponent:0];
            BATRegionItem *pri = _provinceDateSource[prow];
            _addressData.ProvinceName = pri.Name;
//            _pCode = pri.Code;
        }
        
        _addressData.CityName = cri.Name;
//        _cCode = cri.Code;
        _addressData.AreaName = ari.Name;
//        _aCode = ari.Code;
        
//        _addressData.NamePath = [NSString stringWithFormat:@"^%@^%@^%@^",_pName,_cName,_aName];
//        _addressData.CodePath = [NSString stringWithFormat:@"^%ld^%ld^%ld^",(long)_pCode,(long)_cCode,(long)_aCode];

    }
    else {
        BATRegionItem *ari = _areaDataSource[row];
        
        if ([_addressData.ProvinceName isEqualToString:@""]) {
            NSInteger prow = [pickerView selectedRowInComponent:0];
            BATRegionItem *pri = _provinceDateSource[prow];
            _addressData.ProvinceName = pri.Name;
//            _pCode = pri.Code;
        }
        
        if ([_addressData.CityName isEqualToString:@""]) {
            NSInteger crow = [pickerView selectedRowInComponent:1];
            BATRegionItem *cri = _cityDataSource[crow];
            _addressData.CityName = cri.Name;
//            _cCode = cri.Code;
        }

        _addressData.AreaName = ari.Name;
//        _aCode = ari.Code;
        
//        _addressData.NamePath = [NSString stringWithFormat:@"^%@^%@^%@^",_pName,_cName,_aName];
//        _addressData.CodePath = [NSString stringWithFormat:@"^%ld^%ld^%ld^",(long)_pCode,(long)_cCode,(long)_aCode];

    }

}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
        pickerLabel.minimumScaleFactor = 8.;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}


#pragma mark - action
#pragma mark 获取指定code的下级区域
- (NSMutableArray *)getSubAreaWithCode:(NSInteger)code
{
    NSMutableArray *array = [NSMutableArray array];
    for (BATRegionItem *ri in _rm.Data) {
        if (ri.ParentCode == code) {
            [array addObject:ri];
        }
    }
    return array;
}

- (BATRegionItem *)getRegionItemByCode:(NSInteger)code
{
    for (BATRegionItem *ri in _rm.Data) {
        if (ri.Code == code) {
            return ri;
        }
    }
    return nil;
}

#pragma mark - 查找code在对应的数组的index
- (NSInteger)getRegionItemInArrayByCode:(NSInteger)code array:(NSArray *)array
{
    for (NSInteger i = 0; i < array.count; i++) {
        BATRegionItem *ri = array[i];
        if (ri.Code == code) {
            return i;
        }
    }
    return 0;
}

//#pragma mark - picker初次显示已经选中的地址 主要针对编辑进来的
//- (void)showSelectRegionInPicker
//{
//    if (![_addressData.ID isEqualToString:@""]) {
//
//        NSArray *nameArray = [[_addressData.NamePath stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"^"]] componentsSeparatedByString:@"^"];
//        NSArray *codeArray = [[_addressData.CodePath stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"^"]] componentsSeparatedByString:@"^"];
//
//        _pCode = [codeArray[0] integerValue];
//        _pName = nameArray[0];
//
//        _cCode = [codeArray[1] integerValue];
//        _cName = nameArray[1];
//
//        _aCode = [codeArray[2] integerValue];
//        _aName = nameArray[2];
//
//        [_cityDataSource removeAllObjects];
//        [_cityDataSource addObjectsFromArray:[self getSubAreaWithCode:_pCode]];
//
//        [_areaDataSource removeAllObjects];
//        [_areaDataSource addObjectsFromArray:[self getSubAreaWithCode:_cCode]];
//
//        NSInteger prow = [self getRegionItemInArrayByCode:_pCode array:_provinceDateSource];
//        NSInteger crow = [self getRegionItemInArrayByCode:_cCode array:_cityDataSource];
//        NSInteger arow = [self getRegionItemInArrayByCode:_aCode array:_areaDataSource];
//
//        [self.modifyAddressView.pickerView selectRow:prow inComponent:0 animated:YES];
//        [self.modifyAddressView.pickerView selectRow:crow inComponent:1 animated:YES];
//        [self.modifyAddressView.pickerView selectRow:arow inComponent:2 animated:YES];
//
//    }
//}

#pragma mark - NET

#pragma mark - 保存
- (void)requestSaveContactInfo
{
    [self.view endEditing:YES];
    
    NSString *name = [_addressData.UserName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    if ([_addressData.UserName length] == 0 || name.length == 0) {
        [self showErrorWithText:@"请填写收货人"];
        return;
    }

    if ([_addressData.Mobile length] == 0 ) {
        [self showErrorWithText:@"请填写联系电话"];
        return;
    }

    if (![Tools checkPhoneNumber:_addressData.Mobile]) {
        [self showErrorWithText:@"请正确填写联系电话"];
        return;
    }
    
//    _addressData.ProvinceName = @"广东省";
//    _addressData.CityName = @"深圳市";
//    _addressData.AreaName = @"福田区";

    if ([_addressData.ProvinceName length] == 0 || [_addressData.CityName length] == 0 || [_addressData.AreaName length] == 0 ) {
        [self showErrorWithText:@"请选择地区"];
        return;
    }

    NSString *address = [_addressData.DetailAddress stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    if ([_addressData.DetailAddress length] == 0 || address.length == 0) {
        [self showErrorWithText:@"请填写详细地址"];
        return;
    }

    if ([_addressData.DetailAddress length] < 5 ) {
        [self showErrorWithText:@"详细地址太短了"];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"UserName":_addressData.UserName,
                                                                                  @"Mobile":_addressData.Mobile,
                                                                                  @"ProvinceName":_addressData.ProvinceName,
                                                                                  @"CityName":_addressData.CityName,
                                                                                  @"AreaName":_addressData.AreaName,
                                                                                  @"DetailAddress":_addressData.DetailAddress,
                                                                                  @"Postcode":@"",
                                                                                  }];
    if (self.isModify) {
        
        [params setObject:_addressData.AddressID forKey:@"AddressID"];
        
        [self requestUpdateAddress:params];
    } else {
        [self requestAddAddress:params];
    }
    
//    if ([_addressData.NamePath rangeOfString:@"^"].location == NSNotFound) {
//        //未有修改过地区
//        NSArray *array = [[_addressData.CodePath stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"^"]] componentsSeparatedByString:@"^"];
//
//        _pCode = [array[0] integerValue];
//        _pName = [self getRegionItemByCode:_pCode].Name;
//
//        _cCode = [array[1] integerValue];
//        _cName = [self getRegionItemByCode:_cCode].Name;
//
//        _aCode = [array[2] integerValue];
//        _aName = [self getRegionItemByCode:_aCode].Name;
//
//        _addressData.NamePath = [NSString stringWithFormat:@"^%@^%@^%@^",_pName,_cName,_aName];
//
//
//    } else {
//        //修改了地区
//        _addressData.CodePath = [NSString stringWithFormat:@"^%ld^%ld^%ld^",_pCode,_cCode,_aCode];
//        _addressData.NamePath = [NSString stringWithFormat:@"^%@^%@^%@^",_pName,_cName,_aName];
//    }

    

//    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{
//                                                                                  @"Id":_addressData.ID,
//                                                                                  @"Name":_addressData.Name,
//                                                                                  @"Phone":_addressData.Phone,
//                                                                                  @"CodePath":_addressData.CodePath,
//                                                                                  @"NamePath":_addressData.NamePath,
//                                                                                  @"Address":_addressData.Address,
//                                                                                  @"DoorNo":_addressData.DoorNo,
//                                                                                  }];
//
//    if (_addressData.ID.length <= 0) {
//        [params removeObjectForKey:@"Id"];
//    }
//
//    self.modifyAddressView.saveAddressBtn.enabled = NO;
//
//    [HTTPTool requestWithURLString:@"/api/custom/SaveContactInfo" parameters:params type:kPOST success:^(id responseObject) {
//        [self showSuccessWithText:@"保存成功"];
//        [self.navigationController popViewControllerAnimated:YES];
//        [[NSNotificationCenter defaultCenter] postNotificationName:BATRefreshAddressNotification object:nil];
//    } failure:^(NSError *error) {
//        self.modifyAddressView.saveAddressBtn.enabled = YES;
//        [self showText:error.localizedDescription];
//    }];
}

#pragma mark - 增加地址
- (void)requestAddAddress:(NSMutableDictionary *)params
{
    self.modifyAddressView.saveAddressBtn.enabled = NO;
    
    [self showProgress];
    
    [HTTPTool requestWithKmWlyyBaseApiURLString:@"/userAddresses/addUserAddress" parameters:params type:kPOST success:^(id responseObject) {
        [self showSuccessWithText:@"添加成功"];
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:BATRefreshAddressNotification object:nil];
        
        if (self.isFromBuyOTC) {
            [[NSNotificationCenter defaultCenter] postNotificationName:BATOTCSelectReceiptUserNotification object:_addressData];
        }
        
    } failure:^(NSError *error) {
        self.modifyAddressView.saveAddressBtn.enabled = YES;
        [self showText:error.localizedDescription];
    }];
}

#pragma mark - 更新地址
- (void)requestUpdateAddress:(NSMutableDictionary *)params
{
    self.modifyAddressView.saveAddressBtn.enabled = NO;
    [self showProgress];
    
    [HTTPTool requestWithKmWlyyBaseApiURLString:@"/userAddresses/updateUserAddress" parameters:params type:kPOST success:^(id responseObject) {
        [self showSuccessWithText:@"更新成功"];
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:BATRefreshAddressNotification object:nil];
    } failure:^(NSError *error) {
        self.modifyAddressView.saveAddressBtn.enabled = YES;
        [self showText:error.localizedDescription];
    }];
}

#pragma mark - 获取全部的区域信息
- (void)requestGetAllRegionList
{
    [HTTPTool requestWithURLString:@"/api/custom/GetAllRegionList" parameters:nil type:kGET success:^(id responseObject) {
        
        _rm = [BATRegionModel mj_objectWithKeyValues:responseObject];
        
        [_provinceDateSource addObjectsFromArray:[self getSubAreaWithCode:0]];
        
        if (_cityDataSource.count == 0) {
            BATRegionItem *firstri = [_provinceDateSource firstObject];
            [_cityDataSource addObjectsFromArray:[self getSubAreaWithCode:firstri.Code]];
        }
        
        if (_areaDataSource.count == 0) {
            BATRegionItem *firstri = [_cityDataSource firstObject];
            [_areaDataSource addObjectsFromArray:[self getSubAreaWithCode:firstri.Code]];
        }
        
        
        [self.modifyAddressView.pickerView reloadAllComponents];
        
        
    } failure:^(NSError *error) {
        [self showText:error.localizedDescription];
    }];
}

#pragma mark - 删除收货人信息
- (void)requestDelContactInfo
{
    [HTTPTool requestWithKmWlyyBaseApiURLString:@"/userAddresses/deleteUserAddress" parameters:@{@"ID":_addressData.AddressID} type:kPOST success:^(id responseObject) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:BATRefreshAddressNotification object:nil];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        [self showText:error.localizedDescription];
    }];
}

#pragma mark - pageLayout
- (void)pageLayout
{
    [self.view addSubview:self.modifyAddressView];
    
    WEAK_SELF(self);
    [self.modifyAddressView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - get & set
- (BATModifyAddressView *)modifyAddressView
{
    if (_modifyAddressView == nil) {
        _modifyAddressView = [[BATModifyAddressView alloc] init];
        _modifyAddressView.tableView.delegate = self;
        _modifyAddressView.tableView.dataSource = self;
        _modifyAddressView.pickerView.delegate = self;
        _modifyAddressView.pickerView.dataSource = self;
        
        
//        WEAK_SELF(self);
//        [_modifyAddressView.saveAddressBtn bk_whenTapped:^{
//            STRONG_SELF(self);
//            [self requestSaveContactInfo];
//        }];
    }
    return _modifyAddressView;
}

- (UIToolbar *)toolBar
{
    
    if (_toolBar == nil) {
        _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        _toolBar.backgroundColor = [UIColor whiteColor];
        
        WEAK_SELF(self);
        UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"取消" style:UIBarButtonItemStylePlain handler:^(id sender) {
            STRONG_SELF(self);
            
            
            [self.view endEditing:YES];
        }];
        
        UIBarButtonItem *fix = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem *confirmBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"确定" style:UIBarButtonItemStylePlain handler:^(id sender) {
            STRONG_SELF(self);
            [self.view endEditing:YES];
            
            if (self.provinceDateSource.count == 0 || self.cityDataSource == 0 || self.areaDataSource.count == 0) {
                return;
            }
            
            if ([self.addressData.ProvinceName isEqualToString:@""]) {

                if (self.provinceDateSource.count > 0) {
                    NSInteger prow = [self.modifyAddressView.pickerView selectedRowInComponent:0];
                    BATRegionItem *pri = self.provinceDateSource[prow];
                    self.addressData.ProvinceName = pri.Name;
//                    self.pCode = pri.Code;
                }
            }

            if ([self.addressData.CityName isEqualToString:@""]) {

                if (self.cityDataSource.count > 0) {
                    NSInteger crow = [self.modifyAddressView.pickerView selectedRowInComponent:1];
                    BATRegionItem *cri = self.cityDataSource[crow];
                    self.addressData.CityName = cri.Name;
//                    self.cCode = cri.Code;
                }
            }

            if ([self.addressData.AreaName isEqualToString:@""]) {
                if (self.areaDataSource.count > 0) {
                    NSInteger arow = [self.modifyAddressView.pickerView selectedRowInComponent:2];
                    BATRegionItem *ari = self.areaDataSource[arow];
                    self.addressData.AreaName = ari.Name;
//                    self.aCode = ari.Code;
                }
            }

//            self.addressData.NamePath = [NSString stringWithFormat:@"^%@^%@^%@^",self.pName,self.cName,self.aName];
//            self.addressData.CodePath = [NSString stringWithFormat:@"^%ld^%ld^%ld^",(long)self.pCode,(long)self.cCode,(long)self.aCode];
            
        }];
        
        _toolBar.items = @[cancelBarButtonItem,fix,confirmBarButtonItem];
    }
    
    return _toolBar;
    
    
}

- (BATGraditorButton *)saveButton
{
    if (_saveButton == nil) {
        _saveButton = [[BATGraditorButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
//        _saveButton.enablehollowOut = YES;
        [_saveButton setGradientColors:@[START_COLOR,END_COLOR]];
        _saveButton.enbleGraditor = YES;
        _saveButton.titleLabel.font = [UIFont systemFontOfSize:16];
//        [_saveButton sizeToFit];
        [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
        
        WEAK_SELF(self);
        [_saveButton bk_whenTapped:^{
            STRONG_SELF(self);
            [self requestSaveContactInfo];
        }];
        
    }
    return _saveButton;
}

@end

