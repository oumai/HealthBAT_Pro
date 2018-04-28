//
//  BATAddInTreamentViewController.m
//  HealthBAT_Pro
//
//  Created by MichaeOu on 2017/6/12.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//
#define KHexColor(stringColor) [UIColor colorForHexString:stringColor]

#import "BATAddInTreamentViewController.h"
#import "BATAddInTreamentCell.h"
#import "UIColor+HNExtensions.h"
#import "UIImage+Tool.h"
#import "BATRelationshipSheetActionView.h"
@interface BATAddInTreamentViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) UILabel *introductionLabel;
@property (nonatomic, strong) BATRelationshipSheetActionView *sheetView;
@property (nonatomic, strong) NSDictionary *dictionary;
@end

@implementation BATAddInTreamentViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加就诊人";
    self.titleArray = @[@"姓名",@"身份证号码",@"手机号码",@"关系"];
    [self configureUI];
    
}
- (void)configureUI
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 40, 40);
    [btn bk_whenTapped:^{
        [self rightItemClick];
    }];
    [btn setImage:[UIImage imageNamed:@"person_add_bc"] forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(-10, -10, -10, -10)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 20, 40);
    [backBtn bk_whenTapped:^{
        
        if ([[self.nameString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0 & [self.phoneNumberString length]==0 & [self.identityCardString length] ==0 & [self.relationshipString length] == 0) {
            [self.navigationController popViewControllerAnimated:YES];
            return ;
        }
        
        if ([self.nameString length] > 0 || [self.phoneNumberString length]>0 ||[self.identityCardString length] > 0 || [self.relationshipString length] > 0) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"放弃此次编辑吗" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
            [alert addAction:cancelAction];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
       
    }];
    [backBtn setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
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
    
}

- (void)configureFooterView
{
    self.footerView = [[UIView alloc] init];
    self.footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
    
    
    
    
    self.introductionLabel = [UILabel new];
    self.introductionLabel.font = [UIFont systemFontOfSize:12];
    self.introductionLabel.textColor = KHexColor(@"#999999");
    self.introductionLabel.text = @"填写身份证便于您使用医疗服务，我们承诺保护您的隐私";
    [self.footerView addSubview:_introductionLabel];
    
    
    [_introductionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.footerView.mas_centerY).offset(0);
        make.centerX.equalTo(self.footerView.mas_centerX).offset(0);
        make.width.equalTo(self.introductionLabel.mas_width);
        make.height.equalTo(@14);
    }];
    
}
#pragma mark ------------------------------------------------------------------UITableViewDatasource Delegate-------------------------------------------------

//-(UIButton *)backBtn{
//    if (!_backBtn) {
//        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom Title:@"" titleColor:nil backgroundColor:nil backgroundImage:[UIImage imageNamed:@"back_icon"] Font:nil];
//        [_backBtn bk_whenTapped:^{
//            [self.navigationController popViewControllerAnimated:YES];
//        }];
//    }
//    return _backBtn;
//}

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
    if ([self.relationshipString isEqualToString:@"本人"]) {
        relateTag = 0;
    }
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
    
    
    
    
    
    [self showProgressWithText:@"正在提交"];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    [HTTPTool requestWithURLString:@"/api/NetworkMedical/InsertUserMember" parameters:dict type:kPOST success:^(id responseObject) {
        [self showText:@"添加成功"];
        self.navigationItem.rightBarButtonItem.enabled = YES;
        if (self.RefreshBlock) {
            self.RefreshBlock();
        }
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [self showErrorWithText:error.localizedDescription];
        
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }];
    
    
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
    cell.textField.delegate = self;
    if (indexPath.row == 3) {
        cell.arrowImage.image = [UIImage imageNamed:@"icon_arrow_right"];
        cell.textField.enabled = NO;
        cell.textField.placeholder = @"";
    }
    else if (indexPath.row == 0)
    {
        cell.textField.placeholder = @"请输入真实姓名";

    }
    else
    {
        cell.textField.placeholder = @"请输入";

    }
    [cell.textField addTarget:self action:@selector(textField1TextChange:) forControlEvents:UIControlEventEditingChanged];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 3) {
        
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
        NSRange _range = [textField.text rangeOfString:@" "];
        if (_range.location != NSNotFound) {
            //有空格
        }else {
            //没有空格
            self.nameString = textField.text;
        }
        
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

