//
//  BATDrugOrderInfoViewController.m
//  HealthBAT_Pro
//
//  Created by wct on 2017/12/14.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDrugOrderInfoViewController.h"

#import "BATDrugOrderInfoView.h"
#import "BATDrugOrderHeader.h"
#import "BATDrugOrderCustomerTableViewCell.h"
#import "BATDrugOrderCommonInfoTableViewCell.h"

#import "BATDrugOrderInfoModel.h"

static  NSString * const CUSTOMER_CELL = @"BATDrugOrderCustomerTableViewCell";
static  NSString * const COMMON_CELL = @"BATDrugOrderCommonInfoTableViewCell";

@interface BATDrugOrderInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    CGFloat _commentRangeFont;//小屏幕字太大了
}
@property (nonatomic,strong) BATDrugOrderInfoView *contentView;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) BATDrugOrderInfoModel *infoModel;

@end

@implementation BATDrugOrderInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = BASE_BACKGROUND_COLOR;
    self.title = @"处方详情";
    
    [self.view addSubview:self.tableView];
    
    [self.contentView contentViewReload];
    
    if(iPhone5){
        _commentRangeFont = 4;
    }else if(iPhone6){
        _commentRangeFont = 2;
    }else{
        _commentRangeFont = 0;
    }
    
    [self requestOrderDetail];
}

#pragma mark - delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    BATDrugOrderInfoRecipeFilesModel *infoRecipeFiles;
    BATDrugOrderListRecipeFilesModel *listRecipeFile = self.data.RecipeFiles.count > 0 ? self.data.RecipeFiles[0]:nil;
    
    for (BATDrugOrderInfoRecipeFilesModel *tmpRecipe in self.infoModel.Data.RecipeFiles) {
        
        if ([tmpRecipe.RecipeFileID isEqualToString:listRecipeFile.RecipeFileID]) {
            infoRecipeFiles = tmpRecipe;
            break;
        }
    }
    
    if (section == 0) {
        
        return 1;
    }
    else if (section == 1) {
        
        return infoRecipeFiles.Diagnoses.count;
        
    }
    else if (section == 2 ) {
        
        return infoRecipeFiles.Details.count;
    }
    else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BATDrugOrderInfoRecipeFilesModel *infoRecipeFiles;
    BATDrugOrderListRecipeFilesModel *listRecipeFile = self.data.RecipeFiles.count > 0 ? self.data.RecipeFiles[0]:nil;

    for (BATDrugOrderInfoRecipeFilesModel *tmpRecipe in self.infoModel.Data.RecipeFiles) {
        
        if ([tmpRecipe.RecipeFileID isEqualToString:listRecipeFile.RecipeFileID]) {
            infoRecipeFiles = tmpRecipe;
            break;
        }
    }
    
    if (indexPath.section == 0) {
        
        BATDrugOrderCustomerTableViewCell *customerCell = [tableView dequeueReusableCellWithIdentifier:CUSTOMER_CELL forIndexPath:indexPath];
        customerCell.nameLabel.text = [NSString stringWithFormat:@"姓名：%@",self.data.Member.MemberName];
        customerCell.sexLabel.text = [NSString stringWithFormat:@"性别：%@",self.data.Member.Gender == 0 ? @"男":@"女"];
        customerCell.birthdayLabel.text = [NSString stringWithFormat:@"生日：%@",self.data.Member.Birthday];
        customerCell.phoneLabel.text = [NSString stringWithFormat:@"联系电话：%@",self.data.Member.Mobile];
        return customerCell;
    }
    else if (indexPath.section == 1) {
        BATDrugOrderCommonInfoTableViewCell *diseaseNameCell = [tableView dequeueReusableCellWithIdentifier:COMMON_CELL forIndexPath:indexPath];

        BATDrugOrderInfoDiagnosesModel *diagnoses = infoRecipeFiles.Diagnoses[indexPath.row];
        
        diseaseNameCell.leftTitleLabel.text = diagnoses.Detail.DiseaseName;
        
        return diseaseNameCell;
    }
    else if (indexPath.section == 2){
        BATDrugOrderCommonInfoTableViewCell *drugNameCell = [tableView dequeueReusableCellWithIdentifier:COMMON_CELL forIndexPath:indexPath];
    
        BATDrugOrderInfoDetailsModel *details = infoRecipeFiles.Details[indexPath.row];
        
        drugNameCell.leftTitleLabel.text = details.Drug.DrugName;
        
        return drugNameCell;
    }
    else{
        BATDrugOrderCommonInfoTableViewCell *doctorNameCell = [tableView dequeueReusableCellWithIdentifier:COMMON_CELL forIndexPath:indexPath];

        doctorNameCell.leftTitleLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@",self.data.Doctor.HospitalName,self.data.Doctor.DepartmentName,self.data.Doctor.DoctorName,[self.data.Order.OrderTime substringToIndex:10]];

        return doctorNameCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (indexPath.section == 0) {
        return 70;
    }
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    BATDrugOrderHeader *header = [[BATDrugOrderHeader alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
    [header setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0.5];
    
    if (section == 0) {
        header.titleLabel.text = @"患者信息";
    }
    else if (section == 1) {
        header.titleLabel.text = @"诊断";
    }
    else if (section == 2){
        header.titleLabel.text = @"RP";
    }
    else{
        header.titleLabel.text = @"看诊医生";
    }
    
    return header;
}

#pragma mark - net
- (void)requestOrderDetail {
   
    [HTTPTool requestWithKmWlyyBaseApiURLString:@"/UserRecipeOrders/" parameters:@{@"OrderNO":self.data.Order.OrderNo} type:kGET success:^(id responseObject) {
        
        self.infoModel = [BATDrugOrderInfoModel mj_objectWithKeyValues:responseObject];
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - setter&getter
- (BATDrugOrderInfoView *)contentView{
    
    if (_contentView == nil) {
        _contentView = [[BATDrugOrderInfoView alloc]init];
        if (iPhone5) {
            _contentView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 125);
        }else if (iPhone6){
            _contentView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 130);
        }else{
            _contentView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 135);
        }
        
        _contentView.nameLabel.text = [NSString stringWithFormat:@"姓名：%@",self.data.Member.MemberName];
        _contentView.sexLabel.text = [NSString stringWithFormat:@"性别：%@",self.data.Member.Gender == 0 ? @"男":@"女"];
        _contentView.birthdayLabel.text = [NSString stringWithFormat:@"生日：%@",self.data.Member.Birthday];
        _contentView.phoneLabel.text = [NSString stringWithFormat:@"联系电话：%@",self.data.Member.Mobile];
    }
    return _contentView;
}


- (UITableView *)tableView{
    
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
        
        [_tableView registerClass:[BATDrugOrderCustomerTableViewCell class] forCellReuseIdentifier:CUSTOMER_CELL];
        [_tableView registerClass:[BATDrugOrderCommonInfoTableViewCell class] forCellReuseIdentifier:COMMON_CELL];

        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 1)];
        
        _tableView.estimatedSectionFooterHeight = 10;
        _tableView.estimatedSectionHeaderHeight = 50;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = BASE_BACKGROUND_COLOR;
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    
    return _tableView;
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

@end
