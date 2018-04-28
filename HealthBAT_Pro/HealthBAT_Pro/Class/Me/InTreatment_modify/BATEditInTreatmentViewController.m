//
//  BATEditInTreatmentViewController.m
//  HealthBAT_Pro
//
//  Created by MichaeOu on 2017/6/13.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//


#define KHexColor(stringColor) [UIColor colorForHexString:stringColor]
#import "BATEditInTreatmentViewController.h"
#import "BATAddInTreamentCell.h"
#import "UIColor+HNExtensions.h"
#import "UIImage+Tool.h"
#import "BATRelationshipSheetActionView.h"
@interface BATEditInTreatmentViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *detailArray;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UILabel *introductionLabel;
@property (nonatomic, strong) BATRelationshipSheetActionView *sheetView;
@property (nonatomic, strong) NSDictionary *dictionary;

@end

@implementation BATEditInTreatmentViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑就诊人";
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 40, 40);
    [btn bk_whenTapped:^{
        [self rightItemClick];
    }];
    [btn setImage:[UIImage imageNamed:@"person_add_bc"] forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(-10, -10, -10, -10)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];

    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 45;
    self.tableView.backgroundColor = BASE_BACKGROUND_COLOR;
    [self configureFooterView];
    self.tableView.tableFooterView = self.footerView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
    
    self.titleArray = @[@"姓名",@"身份证号码",@"手机号码",@"关系"];
    self.detailArray = @[_nameString,
                         _identityCardString,
                         _phoneNumberString,
                         _relationshipString,];
    
    NSLog(@"model%ld",(long)self.model.memberID);
}
- (void)configureFooterView
{
    self.footerView = [[UIView alloc] init];
    self.footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 120);
    
    
    self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.deleteButton.titleLabel.font = [UIFont systemFontOfSize:14];
    self.deleteButton.layer.masksToBounds = YES;
    self.deleteButton.layer.cornerRadius = 5.5;
    [self.deleteButton setTitle:@"删除此就诊人" forState:UIControlStateNormal];
    [self.deleteButton setTitleColor:KHexColor(@"#ffffff") forState:UIControlStateNormal];
    [self.deleteButton setBackgroundImage:[UIImage createImageWithColor:KHexColor(@"#ff3b3b")] forState:UIControlStateNormal];
    [self.deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.footerView addSubview:_deleteButton];
    
    [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.footerView.mas_centerX).offset(0);
        make.centerY.equalTo(self.footerView.mas_centerY).offset(0);
        make.width.equalTo(@(SCREEN_WIDTH-28));
        make.height.equalTo(@44);
    }];
    
    self.introductionLabel = [UILabel new];
    self.introductionLabel.font = [UIFont systemFontOfSize:12];
    self.introductionLabel.textColor = KHexColor(@"#999999");
    self.introductionLabel.text = @"填写身份证便于您使用医疗服务，我们承诺保护您的隐私";
    [self.footerView addSubview:_introductionLabel];
    
    
    [_introductionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.deleteButton.mas_bottom).offset(15);
        make.centerX.equalTo(self.footerView.mas_centerX).offset(0);
        make.width.equalTo(self.introductionLabel.mas_width);
        make.height.equalTo(@14);
    }];
    
    
    
    
}
- (void)rightItemClick
{
   
    if (self.nameString == nil || [self.nameString isEqualToString:@""]||[[self.nameString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        [self showText:@"请填写名字"];
        return;
    }
    if (self.phoneNumberString == nil || [self.phoneNumberString isEqualToString:@""]) {
        [self showText:@"请输入手机号码"];
        return;
    }
    if ([self.phoneNumberString length]  != 11) {
        [self showText:@"请输入11位手机号码"];
        return;
    }

    if (self.identityCardString == nil || [self.identityCardString isEqualToString:@""]) {
        [self showText:@"请输入身份证号码"];
        return;
    }else {
        
        BOOL isRight =  [Tools verifyIDCardNumber:self.identityCardString];
        if (!isRight) {
            [self showText:@"请输入正确身份证号码"];
            return;
        }
    }
    
    if (self.relationshipString == nil || [self.relationshipString isEqualToString:@""]) {
        [self showText:@"请选择身份"];
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@"" forKey:@"PhotoPath"];
    [dict setValue:self.nameString forKey:@"MemberName"];
    [dict setValue:self.phoneNumberString forKey:@"Mobile"];

    
    [dict setValue:self.model.memberID forKey:@"MemberID"];
    
    NSInteger isPer = 0;
    if (self.model.IsPerfect) {
        isPer = 1;
    }else {
        isPer = 0;
    }
    [dict setObject:@(isPer) forKey:@"IsPerfect"];
    
   
    
    [dict setValue:self.identityCardString forKey:@"IDNumber"];
    
    NSInteger relateTag = 0;
    if ([self.relationshipString isEqualToString:@"配偶"]) {
        relateTag = 1;
    }
    if ([self.relationshipString isEqualToString:@"父亲"]) {
        relateTag = 2;
    }
    if ([self.relationshipString isEqualToString:@"母亲"]) {
        relateTag = 3;
    }
    if ([self.relationshipString isEqualToString:@"儿子"]) {
        relateTag = 4;
    }
    if ([self.relationshipString isEqualToString:@"女儿"]) {
        relateTag = 5;
    }
    if ([self.relationshipString isEqualToString:@"其他"]) {
        relateTag = 6;
    }
    [dict setValue:@(relateTag) forKey:@"Relation"];
    
    [dict setValue:@(_model.isDefault) forKey:@"IsDefault"];
    

       
    NSLog(@"dict%@",dict);
    [self showProgressWithText:@"正在提交"];
    [HTTPTool requestWithURLString:@"/api/NetworkMedical/UpdateUserMember" parameters:dict type:kPOST success:^(id responseObject) {
        [self showText:@"更新成功"];
        self.navigationItem.rightBarButtonItem.enabled = YES;
        if (self.RefreshBlock) {
            self.RefreshBlock();
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [self dismissProgress];
        
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }];

}
- (void)deleteButtonClick:(UIButton *)button
{
    if ([_relationshipString isEqualToString:@"本人"]) {
        [self showText:@"就诊人关系是本人,暂不能删除!"];
    }else {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否删除就诊人信息" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            [self showProgressWithText:@"正在删除档案"];
            self.navigationItem.rightBarButtonItem.enabled = NO;
            [HTTPTool requestWithURLString:@"/api/NetworkMedical/DeleteUserMember" parameters:@{@"MemberId":self.model.memberID} type:kGET success:^(id responseObject) {
                self.navigationItem.rightBarButtonItem.enabled = YES;
                [self showText:@"删除成功"];
                if (self.RefreshBlock) {
                    self.RefreshBlock();
                }
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(NSError *error) {
                [self showErrorWithText:error.localizedDescription];
                
                self.navigationItem.rightBarButtonItem.enabled = YES;
            }];

        }];
        
        [alert addAction:cancelAction];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    }

}

#pragma mark ------------------------------------------------------------------UITableViewDatasource Delegate-------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"BATAddInTreamentCell";
    BATAddInTreamentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell) {
        cell = [[BATAddInTreamentCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
    }
    cell.path = indexPath;
    cell.textField.tag = indexPath.row;
    cell.titleLabel.text = self.titleArray[indexPath.row];
    cell.textField.text = self.detailArray[indexPath.row];
    cell.textField.delegate = self;
    if (indexPath.row == 3) {
        cell.arrowImage.image = [UIImage imageNamed:@"icon_arrow_right"];
        cell.textField.enabled = NO;
    }
    [cell.textField addTarget:self action:@selector(textField1TextChange:) forControlEvents:UIControlEventEditingChanged];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 3) {
        
        //本人关系不能修改
        if ([self.relationshipString isEqualToString:@"本人"]) {
            [self showText:@"不能修改本人"];
            return;
        }
        [self CustomtableView:tableView cellForRowAtIndexPath:indexPath type:5];
       
      
    }
}
#pragma mark ------------------------------------------------------------------UITextField-------------------------------------------------
- (void)textFieldDidBeginEditing:(UITextField *)textField
{

    if (textField.tag == 0 ||textField.tag == 1) {
        textField.keyboardType =  UIKeyboardTypeDefault;
        
    }
    else if (textField.tag == 2)
    {
        textField.keyboardType =  UIKeyboardTypeNumberPad;
    }

}
#pragma mark - 直接添加监听方法
-(void)textField1TextChange:(UITextField *)textField{
    if (textField.tag == 0) {
        self.nameString = textField.text;
        
    }
    else if (textField.tag == 1)
    {
        self.identityCardString = textField.text;
    }
      else if (textField.tag == 2)
    {
        self.phoneNumberString = textField.text;
    }
    
    else if (textField.tag == 3)
    {
        self.relationshipString = textField.text;
    }

}
- (void)CustomtableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath type:(NSInteger)integer
{
    
    if (!_sheetView)
    {
        
        _sheetView = [[BATRelationshipSheetActionView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        [self.view addSubview:_sheetView];
    }
    [self.sheetView animationPresent:integer];
    __weak BATRelationshipSheetActionView *safeView = self.sheetView;
    [safeView setSheetViewBlock:^(NSInteger sheet ,NSString *chooseString) {
        
        
        BATAddInTreamentCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (sheet == 101)
        {

            if (indexPath.row == 3) {
                
                self.relationshipString =  cell.textField.text = chooseString;
            }
          
        }
        [safeView animationedDismiss];
        
    }];
    
  
}
@end
