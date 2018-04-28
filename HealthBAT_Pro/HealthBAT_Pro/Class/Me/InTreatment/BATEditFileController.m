//
//  BATEditFileController.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2016/12/6.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATEditFileController.h"
#import "BATFileDetailCell.h"
#import "BATMineFiledEditorController.h"
#import "BATGraditorButton.h"
@interface BATEditFileController ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic,strong) BATGraditorButton *leftBtn;
@property (nonatomic,strong) BATGraditorButton *rightBtn;
@property (nonatomic,strong) UITableView *leftTab;
@property (nonatomic,strong) UITableView *rightTab;
@property (nonatomic,strong) NSArray *leftTitleArr;
@property (nonatomic,strong) NSArray *rightTitleArr;
@property (nonatomic,strong) UIScrollView *backScrollView;
@property (nonatomic,strong) BATGraditorButton *lineView;
@property (nonatomic,strong) UIView *showView;
@property (nonatomic,strong) UIPickerView *pickerView;
@property (nonatomic,strong) NSArray *totalArr;
@property (nonatomic,strong) UIView *blackView;

@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) NSInteger seletRow;

@property (nonatomic,assign) BOOL isheight;
@property (nonatomic,assign) BOOL isweight;
@property (nonatomic,assign) BOOL isfitness;
@property (nonatomic,assign) BOOL issleepMood;
@property (nonatomic,assign) BOOL iseatMood;
@property (nonatomic,assign) BOOL isspiritMood;
@property (nonatomic,assign) BOOL isworkMood;

@property (nonatomic,strong) UILabel *nameLb;
@property (nonatomic,strong) UILabel *detailLb;

@property (nonatomic,assign) BOOL isRefresh;

@property (nonatomic,assign) BOOL isChange;

@end

@implementation BATEditFileController

static NSString *const LEFTTAB = @"LEFTTAB";
static NSString *const RIGHTTAB = @"RIGHTTAB";

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"完成" style:UIBarButtonItemStylePlain handler:^(id sender) {
//        
//        [self  uploadFiledRequest];
//        
//    }];
    
    [self pageLayout];
    
   

}

-(void)pageLayout {

    self.title = @"编辑档案信息";
    
    [self headerVeiw];
    
    [self sliderView];
    
    [self sliderTableView];
    
    NSMutableArray *heightArr = [NSMutableArray array];
    for (int i=0; i<151; i++) {
        [heightArr addObject:[NSString stringWithFormat:@"%zd",i+100]];
    }
    
    NSMutableArray *weightArr = [NSMutableArray array];
    for (int i=0; i<250; i++) {
        [weightArr addObject:[NSString stringWithFormat:@"%zd",i+1]];
    }
    
    NSArray *leftArr = @[heightArr,weightArr];
    
    NSArray *fitnessArr = @[@"从不",@"偶尔",@"经常"];
    
    NSArray *sleepQuarity = @[@"失眠多梦",@"正常",@"困倦嗜睡"];
    
    NSArray *eatHobbity = @[@"食欲不振",@"三餐正常",@"饮食不规律"];
    
    NSArray *mood =@[@"低落",@"轻松",@"烦躁"];
    
    NSArray *workArr = @[@"拖沓犹豫",@"按部就班",@"雷厉风行"];
    
    NSArray *rightArr = @[fitnessArr,sleepQuarity,eatHobbity,mood,workArr];
    
    self.totalArr = @[leftArr,rightArr];
    
}

-(void)uploadFiledRequest {
 
//    [self showProgressWithText:@"正在上传"];
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setValue:self.model.photoPath forKey:@"PhotoPath"];
    [dict setValue:self.model.name forKey:@"MemberName"];
    [dict setValue:self.model.phoneNumber forKey:@"Mobile"];
    [dict setValue:self.model.ages forKey:@"Ages"];
    
    if ([self.model.Sex isEqualToString:@"0"]) {
        [dict setValue:@(0) forKey:@"Sex"];
    }else {
        [dict setValue:@(1) forKey:@"Sex"];
    }
    
    [dict setValue:self.model.personID forKey:@"IDNumber"];
    
    NSInteger relateTag = 0;
    if ([self.model.relateship isEqualToString:@"配偶"]) {
        relateTag = 1;
    }
    if ([self.model.relateship isEqualToString:@"父亲"]) {
        relateTag = 2;
    }
    if ([self.model.relateship isEqualToString:@"母亲"]) {
        relateTag = 3;
    }
    if ([self.model.relateship isEqualToString:@"儿子"]) {
        relateTag = 4;
    }
    if ([self.model.relateship isEqualToString:@"女儿"]) {
        relateTag = 5;
    }
    if ([self.model.relateship isEqualToString:@"其他"]) {
        relateTag = 6;
    }
    [dict setValue:@(relateTag) forKey:@"Relation"];
    
    NSInteger isPer = 0;
    if (self.model.IsPerfect) {
        isPer = 1;
    }else {
        isPer = 0;
    }
    [dict setObject:@(isPer) forKey:@"IsPerfect"];
    
    
    NSString *heightStr = [NSString stringWithFormat:@"%@cm",self.model.height];
    NSInteger heightLenght = heightStr.length - 2;
    NSString *subString = [heightStr substringToIndex:heightLenght];
    [dict setValue:subString forKey:@"Height"];
    
    
    NSString *weightStr = [NSString stringWithFormat:@"%@kg",self.model.weight];
    NSInteger weightLength = weightStr.length - 2;
    NSString *weightSubString = [weightStr substringToIndex:weightLength];
    [dict setValue:weightSubString forKey:@"Weight"];
    
    
    [dict setValue:self.model.Exercise forKey:@"Exercise"];
    [dict setValue:self.model.Sleep forKey:@"Sleep"];
    [dict setValue:self.model.Dietary forKey:@"Dietary"];
    [dict setValue:self.model.Mentality forKey:@"Mentality"];
    [dict setValue:self.model.Working forKey:@"Working"];
    
    [dict setValue:self.model.memberID forKey:@"MemberID"];
    
    
    [HTTPTool requestWithURLString:@"/api/NetworkMedical/UpdateUserMember" parameters:dict type:kPOST success:^(id responseObject) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
//        [self dismissProgress];
        
        if (self.RefreshBlock) {
            self.RefreshBlock();
        }
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [self showErrorWithText:error.localizedDescription];

        self.navigationItem.rightBarButtonItem.enabled = YES;
    }];
    
}


#pragma mark -UITableViewDelegate,UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
    if (tableView == _leftTab) {
        return 2;
    }else {
        return 5;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _leftTab) {
        BATFileDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:LEFTTAB];
        cell.titleLb.text = self.leftTitleArr[indexPath.row];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if (indexPath.row == 0) {
            if ([self.model.height isEqualToString:@"0"]) {
                 cell.detailLb.text = @"选填";
            }else {
                cell.detailLb.text = [NSString stringWithFormat:@"%@cm",self.model.height];
            }
        }else {
            if ([self.model.weight isEqualToString:@"0"]) {
                cell.detailLb.text = @"选填";
            }else {
                cell.detailLb.text = [NSString stringWithFormat:@"%@kg",self.model.weight];
            }
        }
       
        return cell;
    }else {
        BATFileDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:RIGHTTAB];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.titleLb.text = self.rightTitleArr[indexPath.row];
        switch (indexPath.row) {
            case 0: {
                if ([self.model.Exercise isEqualToString:@""]) {
                    cell.detailLb.text = @"选填";
                }else {
                    cell.detailLb.text = self.model.Exercise;
                }
            }
                break;
            case 1: {
                if ([self.model.Sleep isEqualToString:@""]) {
                    cell.detailLb.text = @"选填";
                }else {
                    cell.detailLb.text = self.model.Sleep;
                }
            }
                break;
            case 2: {
                if ([self.model.Dietary isEqualToString:@""]) {
                    cell.detailLb.text = @"选填";
                }else {
                    cell.detailLb.text = self.model.Dietary;
                }
            }
                break;
            case 3: {
                if ([self.model.Mentality isEqualToString:@""]) {
                    cell.detailLb.text = @"选填";
                }else {
                    cell.detailLb.text = self.model.Mentality;
                }
            }
                break;
            case 4: {
                if ([self.model.Working isEqualToString:@""]) {
                    cell.detailLb.text = @"选填";
                }else {
                    cell.detailLb.text = self.model.Working;
                }
            }
                break;
        }
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  

    self.seletRow = indexPath.row;
    
    if (self.page == 0) {
        switch (self.seletRow) {
            case 0: {
                self.isheight = NO;
                
            }
                break;
            case 1: {
                self.isweight = NO;
            }
                break;
        }
    }else {
        switch (self.seletRow) {
            case 0: {
                self.isfitness = NO;
            }
                break;
            case 1: {
                self.issleepMood = NO;
            }
                break;
            case 2: {
                self.iseatMood = NO;
            }
                break;
            case 3: {
                self.isspiritMood = NO;
                
            }
                break;
            case 4: {
                self.isworkMood = NO;
            }
                break;
        }
    }

    NSInteger selecount = 0;
    if (tableView == self.leftTab) {
        if (indexPath.row == 0) {
            selecount = 50;
        }else {
            selecount = 49;
        }
        self.isheight = NO;
        self.isweight = NO;
    }else {
        selecount = 1;
        self.isfitness = NO;
        self.issleepMood = NO;
        self.iseatMood = NO;
        self.isspiritMood = NO;
        self.isworkMood = NO;
    }
  
    [self.pickerView reloadAllComponents];
    
    self.blackView.hidden = NO;
    
   
    
    [UIView animateWithDuration:0.3 animations:^{
        self.showView.frame = CGRectMake(0, SCREEN_HEIGHT-250-64, SCREEN_WIDTH, 250);
    }];
    
    [self.pickerView selectRow:selecount inComponent:0 animated:YES];
    [self.pickerView reloadAllComponents];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.backScrollView) {
        NSInteger page = scrollView.contentOffset.x/SCREEN_WIDTH;
        switch (page) {
            case 0: {
                self.page = 0;
                self.seletRow = 0;
                
                [_rightBtn setTitleColor:UIColorFromHEX(0X333333, 1) forState:UIControlStateNormal];
                
                [_leftBtn setTitleColor:UIColorFromHEX(0X0182eb, 1) forState:UIControlStateNormal];
                
                [UIView animateWithDuration:0.3 animations:^{
                    self.lineView.frame = CGRectMake(0, 42, SCREEN_WIDTH/2, 2);
                }];
            }
                break;
            case 1: {
                self.page = 1;
                self.seletRow = 0;
                
                [_leftBtn setTitleColor:UIColorFromHEX(0X333333, 1) forState:UIControlStateNormal];
                
                [_rightBtn setTitleColor:UIColorFromHEX(0X0182eb, 1) forState:UIControlStateNormal];
                
                [UIView animateWithDuration:0.3 animations:^{
                    self.lineView.frame = CGRectMake(SCREEN_WIDTH/2, 42, SCREEN_WIDTH/2, 2);
                }];
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark -UIPickerViewDelegate,UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger count = [self.totalArr[self.page][self.seletRow] count];
    return count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 180;
}

// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString  *_proTimeStr = self.totalArr[self.page][self.seletRow][row];
    self.isChange = YES;
    if (self.page == 0) {
        switch (self.seletRow) {
            case 0: {
                self.isheight = YES;
                
                self.model.height = _proTimeStr;
                
            }
                break;
            case 1: {
                self.isweight = YES;
                
                self.model.weight = _proTimeStr;
                
                
            }
                break;
        }
    }else if(self.page == 1) {
        switch (self.seletRow) {
            case 0: {
                self.isfitness = YES;
                
                self.model.Exercise = _proTimeStr;
                
            }
                break;
            case 1: {
                self.issleepMood = YES;
                
                self.model.Sleep = _proTimeStr;
                
                
            }
                break;
            case 2: {
                self.iseatMood = YES;
                
                self.model.Dietary = _proTimeStr;
                
                
            }
                break;
            case 3: {
                self.isspiritMood = YES;
                
                self.model.Mentality = _proTimeStr;
                
            }
                break;
            case 4: {
                self.isworkMood = YES;
                
                self.model.Working = _proTimeStr;
                
                
            }
                break;
        }
    }
}


//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *string = self.totalArr[self.page][self.seletRow][row];
    return string;
}

#pragma mark - View
-(void)sliderView {
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 76.5+10, SCREEN_WIDTH, 44)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    UIView *grayLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 43, SCREEN_WIDTH, 1)];
    grayLineView.backgroundColor = BASE_BACKGROUND_COLOR;
    [backView addSubview:grayLineView];
    
    self.lineView = [[BATGraditorButton alloc]initWithFrame:CGRectMake(0, 42, SCREEN_WIDTH/2, 2)];
//    self.lineView.backgroundColor = UIColorFromHEX(0X0182eb, 1);
    self.lineView.enablehollowOut = YES;
    [self.lineView setGradientColors:@[START_COLOR,END_COLOR]];
    [backView addSubview:self.lineView];
    
    _leftBtn = [[BATGraditorButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, 44)];
    [_leftBtn setTitle:@"个人资料" forState:UIControlStateNormal];
    _leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    [_leftBtn setTitleColor:UIColorFromHEX(0X0182eb, 1) forState:UIControlStateNormal];
    _leftBtn.enbleGraditor = YES;
    [_leftBtn setGradientColors:@[START_COLOR,END_COLOR]];
    [backView addSubview:_leftBtn];
    
    WEAK_SELF(self)
    
    [_leftBtn bk_whenTapped:^{
        STRONG_SELF(self)
        self.page = 0;
        self.seletRow = 0;
        
        [_rightBtn setTitleColor:UIColorFromHEX(0X333333, 1) forState:UIControlStateNormal];
        
//        [_leftBtn setTitleColor:UIColorFromHEX(0X0182eb, 1)  forState:UIControlStateNormal];
        [_leftBtn setGradientColors:@[START_COLOR,END_COLOR]];
        
        [UIView animateWithDuration:0.3 animations:^{
            self.lineView.frame = CGRectMake(0, 42, SCREEN_WIDTH/2, 2);
        }];
        
        [UIView animateWithDuration:0.3 animations:^{
            self.backScrollView.contentOffset = CGPointMake(0, 0);
        }];
        
    }];
    
    
    
    _rightBtn = [[BATGraditorButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, 44)];
    _rightBtn.enbleGraditor = YES;
    [_rightBtn setTitle:@"生活习惯" forState:UIControlStateNormal];
    _rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_rightBtn setTitleColor:UIColorFromHEX(0X333333, 1) forState:UIControlStateNormal];
    [backView addSubview:_rightBtn];
    
    
    [_rightBtn bk_whenTapped:^{
        STRONG_SELF(self)
        self.page = 1;
        self.seletRow = 0;
        
        [_leftBtn setTitleColor:UIColorFromHEX(0X333333, 1)  forState:UIControlStateNormal];
        
//        [_rightBtn setTitleColor:UIColorFromHEX(0X0182eb, 1) forState:UIControlStateNormal];
        [_rightBtn setGradientColors:@[START_COLOR,END_COLOR]];
        
        [UIView animateWithDuration:0.3 animations:^{
            self.lineView.frame = CGRectMake(SCREEN_WIDTH/2, 42, SCREEN_WIDTH/2, 2);
        }];
        
        
        [UIView animateWithDuration:0.3 animations:^{
            self.backScrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
        }];
        
    }];
    
    
}

-(void)headerVeiw {
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 76.5)];
    headerView.backgroundColor = [UIColor whiteColor];
    headerView.userInteractionEnabled = YES;
    [self.view addSubview:headerView];
    
    UITapGestureRecognizer *headerTap  = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(popToDetailAction)];
    [headerView addGestureRecognizer:headerTap];
    
    UIImageView *icon = [[UIImageView alloc]init];
    [icon sd_setImageWithURL:[NSURL URLWithString:self.model.photoPath] placeholderImage:[UIImage imageNamed:@"医生"]];
    icon.clipsToBounds = YES;
    icon.layer.cornerRadius = 24;
    [headerView addSubview:icon];
    
    
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).offset(10);
        make.centerY.equalTo(headerView.mas_centerY);
        make.height.width.mas_equalTo(48);
    }];
    
    self.nameLb = [[UILabel alloc]init];
    self.nameLb.font = [UIFont systemFontOfSize:14];
    self.nameLb.textColor = UIColorFromHEX(0X666666, 1);
    self.nameLb.text = self.model.name;
    [headerView addSubview:self.nameLb];
    
    [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(icon.mas_right).offset(15);
        make.top.equalTo(icon).offset(0);
    }];
    
    self.detailLb = [[UILabel alloc]init];
    self.detailLb.font = [UIFont systemFontOfSize:13];
    self.detailLb.textColor = UIColorFromHEX(0X666666, 1);
    NSString *sex = nil;
    if ([self.model.Sex isEqualToString:@"1"]) {
        sex = @"男";
    }else {
        sex = @"女";
    }
    
    self.detailLb.text = [NSString stringWithFormat:@"%@ %@岁",sex,self.model.ages];
    [headerView addSubview:self.detailLb];
    
    [self.detailLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(icon.mas_right).offset(15);
        make.bottom.equalTo(icon.mas_bottom).offset(0);
    }];
    
    UIImageView *arrow = [[UIImageView alloc]init];
    arrow.image = [UIImage imageNamed:@"icon_arrow_right"];
    [headerView addSubview: arrow];
    
    [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headerView.mas_right).offset(-14);
        make.centerY.equalTo(headerView.mas_centerY);
    }];
    
}

-(void)sliderTableView {
    
    self.leftTitleArr = @[@"身高",@"体重"];
    
    self.rightTitleArr = @[@"日常健身",@"睡眠质量",@"饮食状况",@"精神情绪",@"工作状态"];
    
    [self.view addSubview:self.backScrollView];
    
    [self.backScrollView addSubview:self.leftTab];
    
    [self.backScrollView addSubview:self.rightTab];
    
}

-(BOOL)navigationShouldPopOnBackButton {
    if (self.isRefresh) {
        if (self.RefreshBlock) {
            self.RefreshBlock();
        }
    }
    if (self.isChange) {
        [self  uploadFiledRequest];
    }
    return YES;
}


#pragma mark -Action
-(void)popToDetailAction {
    
    BATMineFiledEditorController *detailVC = [[BATMineFiledEditorController alloc]init];
    [detailVC setRefreshBlock:^(BOOL refresh) {
        self.isRefresh = refresh;
    }];
    [detailVC setRefreshSexAndAge:^(NSString *name, NSString *sex,NSString *age) {
        NSString *sexSelet = nil;
        if ([sex isEqualToString:@"0"]) {
            sexSelet = @"女";
        }else {
            sexSelet = @"男";
        }
        self.detailLb.text = [NSString stringWithFormat:@"%@ %@岁",sexSelet,self.model.ages];
        self.nameLb.text = self.model.name;
    }];
    detailVC.model = self.model;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

-(void)comfrimAction {
    self.blackView.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.showView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 250);
    }];
    if (self.page == 0) {
        switch (self.seletRow) {
            case 0: {
                if (!self.isheight) {
                    self.model.height = self.totalArr[self.page][self.seletRow][50];
                }
                
            }
                break;
            case 1: {
                if (!self.isweight) {
                    self.model.weight = self.totalArr[self.page][self.seletRow][49];
                }
                
            }
                break;
        }
        
        [self.leftTab reloadData];
    }else {
        switch (self.seletRow) {
            case 0: {
                if (!self.isfitness) {
                    self.model.Exercise = self.totalArr[self.page][self.seletRow][1];
                }
            }
                break;
            case 1: {
                if (!self.issleepMood) {
                    self.model.Sleep = self.totalArr[self.page][self.seletRow][1];
                }
            }
                break;
            case 2: {
                if (!self.iseatMood) {
                    self.model.Dietary = self.totalArr[self.page][self.seletRow][1];
                }
            }
                break;
            case 3: {
                if (!self.isspiritMood) {
                    self.model.Mentality = self.totalArr[self.page][self.seletRow][1];
                }
            }
                break;
            case 4: {
                if (!self.isworkMood) {
                    self.model.Working = self.totalArr[self.page][self.seletRow][1];
                }
            }
                break;
        }
        [self.rightTab reloadData];
    }
}


-(void)cancleAction {
    self.blackView.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.showView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 250);
    }];
    
    if (self.page == 0) {
        switch (self.seletRow) {
            case 0: {
                self.isheight = NO;
                
            }
                break;
            case 1: {
                self.isweight = NO;
            }
                break;
        }
    }else {
        switch (self.seletRow) {
            case 0: {
                self.isfitness = NO;
            }
                break;
            case 1: {
                self.issleepMood = NO;
            }
                break;
            case 2: {
                self.iseatMood = NO;
            }
                break;
            case 3: {
                self.isspiritMood = NO;
                
            }
                break;
            case 4: {
                self.isworkMood = NO;
            }
                break;
        }
    }
    
}
#pragma mark -SETTER
-(UITableView *)leftTab {
    if (!_leftTab) {
        _leftTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 76.5 - 44 -10 -64) style:UITableViewStylePlain];
        _leftTab.delegate = self;
        _leftTab.dataSource = self;
        [_leftTab setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_leftTab registerClass:[BATFileDetailCell class] forCellReuseIdentifier:LEFTTAB];
    }
    return _leftTab;
}

-(UITableView *)rightTab {
    if (!_rightTab) {
        _rightTab = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 76.5 - 44 -10 -64) style:UITableViewStylePlain];
        _rightTab.delegate = self;
        _rightTab.dataSource = self;
        [_rightTab setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_rightTab registerClass:[BATFileDetailCell class] forCellReuseIdentifier:RIGHTTAB];
    }
    return _rightTab;
}

-(UIScrollView *)backScrollView {
    if (!_backScrollView) {
        _backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 76.5+44+10, SCREEN_WIDTH, SCREEN_HEIGHT-76.5 - 44 -64-10)];
        _backScrollView.delegate = self;
        _backScrollView.showsHorizontalScrollIndicator = NO;
        _backScrollView.pagingEnabled = YES;
        _backScrollView.bounces = NO;
        _backScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*2, SCREEN_HEIGHT-76.5 - 44 - 64 - 10);
    }
    return _backScrollView;
}

-(UIView *)blackView {
    if (!_blackView) {
        _blackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        UIColor *color = [UIColor blackColor];
        _blackView.backgroundColor = [color colorWithAlphaComponent:0.6];
        _blackView.hidden = YES;
        [self.view addSubview:_blackView];
    }
    return _blackView;
}

-(UIView *)showView {
    if (!_showView) {
        _showView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 250)];
        _showView.backgroundColor = [UIColor whiteColor];

        UIView *btnView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        btnView.backgroundColor = UIColorFromHEX(0Xf2f2f2, 1);
        [_showView addSubview:btnView];
        
        UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, 40)];
        [cancelBtn addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
        [btnView addSubview:cancelBtn];
        
        UILabel *cancelLb = [[UILabel alloc]initWithFrame:CGRectMake(14, 0, SCREEN_WIDTH/2-14, 40)];
        cancelLb.text = @"取消";
        cancelLb.textColor = UIColorFromHEX(0X333333, 1);
        [btnView addSubview:cancelLb];
        
        UIButton *comfirmBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, 40)];
        [comfirmBtn addTarget:self action:@selector(comfrimAction) forControlEvents:UIControlEventTouchUpInside];
        [btnView addSubview:comfirmBtn];
        
        UILabel *comfirmLB = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2-14, 40)];
        comfirmLB.text = @"确定";
        comfirmLB.textAlignment = NSTextAlignmentRight;
        comfirmLB.textColor = UIColorFromHEX(0X0182eb, 1);
        [btnView addSubview:comfirmLB];
        
        self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 41, SCREEN_WIDTH, 210)];
        self.pickerView.showsSelectionIndicator=YES;
        self.pickerView.dataSource = self;
        self.pickerView.delegate = self;
        [_showView addSubview:self.pickerView];
        
        [self.view addSubview:_showView];
        
    }
    return _showView;
}
@end
