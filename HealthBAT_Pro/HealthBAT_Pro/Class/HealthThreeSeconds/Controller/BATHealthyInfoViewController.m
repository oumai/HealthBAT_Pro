//
//  BATHealthyInfoViewController.m
//  HealthBAT_Pro
//
//  Created by 黄帆 on 2017/12/15.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHealthyInfoViewController.h"
#import "BATHealthThreeSecondsController.h"
#import "BATPerson.h"
#import "BATHealthyInfoTableViewCell.h"
#import "BATDatePickerView.h"
#import "UIColor+Gradient.h"
static NSString *const DateCellID = @"BATHealthyInfoTableViewCell";

@interface BATHealthyInfoViewController ()<UITableViewDelegate, UITableViewDataSource, BATDatePickerViewDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)UIButton *bottomHealthReportButton;
@property(nonatomic, strong)BATPerson *person;
@property(nonatomic, strong)NSMutableArray *dataSource;
@property(nonatomic, strong)UIButton *tableViewFooterView;

/**
 *  日期选择
 */
@property (nonatomic,strong) BATDatePickerView *datePickerView;
@property (nonatomic ,strong) NSIndexPath      *datePickerVIndexPath;

@property (nonatomic, copy) NSString *dateStringSign;
@end

@implementation BATHealthyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
    NSArray *arr = @[[@{@"title":@"性      别:", @"content":@"", @"lab":@"", @"placeH":@""} mutableCopy],
                     [@{@"title":@"身      高:", @"content":@"", @"lab":@"CM", @"placeH":@"请输入身高"} mutableCopy],
                     [@{@"title":@"体      重:", @"content":@"", @"lab":@"KG", @"placeH":@"请输入体重"} mutableCopy],
                     [@{@"title":@"出生日期:", @"content":@"", @"lab":@"", @"placeH":@""} mutableCopy],] ;

    _dataSource = [arr mutableCopy];
    [self setupNav];
    [self registerCell];
    [self commonInit];
    
    [self.view addSubview:self.datePickerView];
}

- (void)commonInit{
    self.person = PERSON_INFO;
    
    if (self.person) {
        [self dealDataSource];
    }
    self.view.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:self.bottomHealthReportButton];
    [self.view addSubview:self.tableView];
    
    
    

}
- (void)viewWillDisappear:(BOOL)animated {
    [self.datePickerView hide];
}
- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
//    [self.bottomHealthReportButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.right.left.mas_equalTo(0);
//        make.height.equalTo(@50);
//
//    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-5);
    }];
    
}

- (void)setupNav{
    
    self.title = @"个人资料";
    if (self.isShowNavButton) {
//        UIColor *navBtnColor = [UIColor gradientFromColor:START_COLOR toColor:END_COLOR withHeight:30];
    
        UIButton *recordButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
        [recordButton addTarget:self action:@selector(recordButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [recordButton setTitle:@"跳过" forState:UIControlStateNormal];
        recordButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [recordButton setTitleColor:UIColorFromHEX(0x6ccc56, 1) forState:UIControlStateNormal];
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:recordButton];
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    }
    
    
}
- (UIButton *)bottomHealthReportButton{
    if (!_bottomHealthReportButton) {
        _bottomHealthReportButton = [[UIButton alloc]init];
        _bottomHealthReportButton.backgroundColor = [UIColor cyanColor];
        [_bottomHealthReportButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
        _bottomHealthReportButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_bottomHealthReportButton setTitle:@"完成填写" forState:UIControlStateNormal];
//        [_bottomHealthReportButton addTarget:self action:@selector(bottomHealthReportButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomHealthReportButton;
}
#pragma mark - lazy load

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.tableFooterView = self.tableViewFooterView;
        _tableView.estimatedRowHeight = 0;
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        view.frame = CGRectMake(0, 0, 75, SCREEN_WIDTH);
        [view addSubview:self.tableViewFooterView];
        _tableView.tableFooterView = view;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _tableView;
}
- (BATDatePickerView *)datePickerView {
    if (!_datePickerView) {
        _datePickerView = [[BATDatePickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 64, SCREEN_WIDTH, 256)];
        _datePickerView.delegate = self;
    }
    return _datePickerView;
}
- (UIButton *)tableViewFooterView{
    if (!_tableViewFooterView) {
        _tableViewFooterView = [[UIButton alloc]initWithFrame:CGRectMake(10, 35, SCREEN_WIDTH - 20, 40)];
        _tableViewFooterView.backgroundColor = UIColorFromHEX(0x6ccc56, 1);
        _tableViewFooterView.layer.cornerRadius = 5;
        _tableViewFooterView.layer.masksToBounds = YES;
        [_tableViewFooterView setTitle:@"完成填写" forState:UIControlStateNormal];
        [_tableViewFooterView addTarget:self action:@selector(pushEditInfoVC) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tableViewFooterView;
}

/**
 每日健康报告调用
 */
- (void)bottomHealthReportButtonClick:(UIButton *)sender{
    
    self.tableViewFooterView.enabled = NO;
    
    NSIndexPath *index0 = [NSIndexPath indexPathForRow:0 inSection:0];
    BATHealthyInfoTableViewCell *cell0 = [self.tableView cellForRowAtIndexPath:index0];
    self.person.Data.Sex = cell0.sexStr;

    NSIndexPath *index1 = [NSIndexPath indexPathForRow:1 inSection:0];
    BATHealthyInfoTableViewCell *cell1 = [self.tableView cellForRowAtIndexPath:index1];
    NSString *heightStr = cell1.contentTextF.text;
    self.person.Data.Height = [heightStr integerValue];
    
    NSIndexPath *index2 = [NSIndexPath indexPathForRow:2 inSection:0];
    BATHealthyInfoTableViewCell *cell2 = [self.tableView cellForRowAtIndexPath:index2];
    NSString *weightStr = cell2.contentTextF.text;
     self.person.Data.Weight = [weightStr integerValue];
    
    //先吧数据取出来
    
    if ([cell1.contentTextF.text isEqualToString:@""] ||[cell2.contentTextF.text isEqualToString:@""] ) {
        
          [self showText:@"请完整填写资料" withInterval:1.5];
        return;
    }
    
    //比较日期大小
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    NSString *str = [self.person.Data.Birthday substringToIndex:10];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];//设定时间格式,这里可以设置成自己需要的格式
    NSDate *date =[dateFormat dateFromString: str];
    NSInteger count = [self compareOneDay:[self getCurrentTime] withAnotherDay:date];
    //先提示
    
    if (count < 0) {
       
        [self showText:@"日期超过限制" withInterval:1.5];
        return;
    }
  
    [self dealWithUploadParamas];

}
/**
 点击跳过按钮  右上角
 */
- (void)recordButtonClick{
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:isFirstEnterHealthThreeSecond];
    [[NSUserDefaults standardUserDefaults] synchronize];
    BATHealthThreeSecondsController *threeSecondVC = [[BATHealthThreeSecondsController alloc]init];
    [self.navigationController pushViewController:threeSecondVC animated:YES];

}
/**
 判断是否是第一次进入
 */
- (BOOL)isFirstEnter {
    
    BOOL isFirst = [[NSUserDefaults standardUserDefaults] boolForKey:isFirstEnterHealthThreeSecond];
    return isFirst;
}
#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    
    return _dataSource.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath; {
    
    BATHealthyInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DateCellID forIndexPath:indexPath];
    cell.titleStr = _dataSource[indexPath.row][@"title"];
    cell.titleLab.text = _dataSource[indexPath.row][@"title"];
    cell.contentTextF.text = _dataSource[indexPath.row][@"content"];
    cell.contentTextF.placeholder = _dataSource[indexPath.row][@"placeH"];
    cell.lab.text = _dataSource[indexPath.row][@"lab"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        cell.status = SLstatus;
    } else {
        cell.status = XLstatus;
    }
    
    if (indexPath.row == 3) {
        cell.enableNow = NO;
    } else {

        cell.enableNow = YES;
    }
    
    if ([_dataSource[indexPath.row][@"content"] isEqualToString:@"1"]) {//是男的
        cell.sexStr = @"1";
        
    } else {
        
        cell.sexStr = @"0";
        
    }
    cell.textFieldNotTrueBlock = ^(NSString *str){

         [self showText:str withInterval:1.5];
    };
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

- (void)registerCell{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BATHealthyInfoTableViewCell class]) bundle:nil] forCellReuseIdentifier:DateCellID];
   
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    
    return [[UIView alloc] initWithFrame:CGRectZero];
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(10, 0, view.width - 20, 40);
    label.text = @"温馨提示：完整的健康资料，将方便对您的健康做出准确的评估建议";
    label.numberOfLines = 0;
    view.backgroundColor = RGB(251, 247, 230);
    label.textColor = RGB(235, 175, 122);
//    UIColorFromHEX(0x666666, 1)
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:12];
    [view addSubview:label];
    
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return 50;
    } else {
        
        return 0.01;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
     [self.datePickerView hide];
    
    if (indexPath.row == 3) {
        
         [self.datePickerView showWithBirthday:self.person.Data.Birthday == nil?@"1980-01-01":self.person.Data.Birthday];
        _dateStringSign = self.person.Data.Birthday == nil?@"1980-01-01":self.person.Data.Birthday;
    }

}

#pragma mark - BATDatePickerViewDelegate
- (void)batDatePickerView:(BATDatePickerView *)datePickerView didSelectDate:(NSString *)dateString {
   
    //这里逻辑you
    
     NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
     [dateFormatter setDateFormat:@"yyyy-MM-dd"];
     NSDate *birthDay = [dateFormatter dateFromString:dateString];
     NSString *nowAge = [dateString dateToOld:birthDay];
     if ([nowAge integerValue] >= 100) {
     // 1.创建UIAlertController
     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示"
     message:@"您当前年龄已经超过100岁，确认使用该出生日期？"
     preferredStyle:UIAlertControllerStyleAlert];
     UIAlertAction *WZZAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
          self.person.Data.Birthday = dateString;
     [self dealDataSource];
     }];
     UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
         
         //变回去
         self.person.Data.Birthday = _dateStringSign;
         [self dealDataSource];
         NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];//todo(可优化-最好不要写死)
         [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
     return ;
     }];
     [alertController addAction:WZZAction];
     [alertController addAction:cancelAction];       // B取消
     // 3.呈现UIAlertContorller
     [self presentViewController:alertController animated:YES completion:nil];
     
     } else {
      self.person.Data.Birthday = dateString;
     [self dealDataSource];
     }
     
//    [self dealDataSource];
//    [self dealWithUploadParamas];

}

- (void)batDatePickerView:(BATDatePickerView *)datePickerView selectDateValueChange:(NSString *)dateString {
    
    
    self.person.Data.Birthday = dateString;
    [self dealDataSource];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];//todo(可优化-最好不要写死)
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - 组装上传参数
- (void)dealWithUploadParamas
{
    
    NSDictionary * dic = @{
                           @"PhotoPath":self.person.Data.PhotoPath == nil?@"0":self.person.Data.PhotoPath,
                           @"UserName":self.person.Data.UserName == nil?@"0":self.person.Data.UserName,
                           @"Sex":self.person.Data.Sex == nil?@"0":self.person.Data.Sex,
                           @"Birthday":[NSString stringWithFormat:@"%@ 00:00:00",self.person.Data.Birthday],
                           //                           @"Birthday":@"",
                           //                           @"Province":self.person.Data.Province == nil?@"":self.person.Data.Province,
                           //                           @"City":self.person.Data.City == nil?@"":self.person.Data.City,
                           //                           @"Height":[NSNumber numberWithInteger:self.person.Data.Height],
                           //                           @"Weight":[NSNumber numberWithInteger:self.person.Data.Weight],
                           //                           @"NativeProvince":self.person.Data.NativeProvince == nil?@"":self.person.Data.NativeProvince,
                           //                           @"NativeCity":self.person.Data.NativeCity == nil?@"":self.person.Data.NativeCity,
                           @"Signature":self.person.Data.Signature == nil?@"这家伙很懒，什么都没留下":self.person.Data.Signature,
                           @"PatientID":[NSNumber numberWithInteger:self.person.Data.PatientID],
                           @"GeneticDisease":self.person.Data.GeneticDisease == nil?@"无家族遗传病":self.person.Data.GeneticDisease,
                           @"Allergies":self.person.Data.Allergies == nil?@"无过敏史":self.person.Data.Allergies,
                           @"Anamnese":self.person.Data.Anamnese == nil?@"无已往病史":self.person.Data.Anamnese,
                           @"PhoneNumber":self.person.Data.PhoneNumber == nil?@"":self.person.Data.PhoneNumber,
                           @"Height":[NSString stringWithFormat:@"%ld", (long)self.person.Data.Height] == nil?@"":[NSString stringWithFormat:@"%ld", (long)self.person.Data.Height],
                           @"Weight":[NSString stringWithFormat:@"%ld", (long)self.person.Data.Weight] == nil?@"":[NSString stringWithFormat:@"%ld", (long)self.person.Data.Weight]
                           };
    
    [self requestChangePersonAllInfo:dic];
}
#pragma mark - 更新个人信息
- (void)requestChangePersonAllInfo:(NSDictionary *)dictParamas
{
    self.tableViewFooterView.enabled = NO;
//    DDLogDebug(@"dictParamas ==== %@",dictParamas);
    [HTTPTool requestWithURLString:@"/api/Patient/Info" parameters:dictParamas type:kPOST success:^(id responseObject) {
//        [self.tvContent reloadData];
        [self showText:@"个人信息修改成功" withInterval:1.5];
        
        [self personInfoListRequest];
//        //成功后更新沙盒
//        NSString *file = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Person.data"];
//        [NSKeyedArchiver archiveRootObject:self.person toFile:file];
        
//        DDLogDebug(@"%@=====",responseObject);
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //主动进入健康3秒钟页面
            
            if ([self isFirstEnter]) {//等于YES 那么就不是第一次进入
                [self.navigationController popViewControllerAnimated:YES];
            } else {
               [self recordButtonClick];
            }
            
            self.tableViewFooterView.enabled = YES;
        });
        
        
        
        
    } failure:^(NSError *error) {
        
         self.tableViewFooterView.enabled = YES;
       
    }];
}
- (void)personInfoListRequest {
    
    [HTTPTool requestWithURLString:@"/api/Patient/Info" parameters:nil type:kGET success:^(id responseObject) {
        
        BATPerson * person = [BATPerson mj_objectWithKeyValues:responseObject];
        if (person.ResultCode == 0) {
            
            //保存登录信息
            NSString *file = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Person.data"];
            [NSKeyedArchiver archiveRootObject:person toFile:file];
        }
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark - customMethod
- (void)dealDataSource {
    
    for (int i = 0; i < _dataSource.count; i++) {
        NSMutableDictionary *dicM = _dataSource[i];
        switch (i) {
            case 0:
                {
                    if (self.person.Data.Sex) {
                         [dicM jk_setObj:self.person.Data.Sex forKey:@"content"];
                    }

                }
                break;
            case 1:
            {
                
                if (self.person.Data.Height) {
                    [dicM jk_setObj:[NSString stringWithFormat:@"%ld", (long)self.person.Data.Height] forKey:@"content"];
                    if (self.person.Data.Height <= 0) {
                        [dicM jk_setObj:@"" forKey:@"content"];
                    }
                }
            }
                break;
            case 2:
            {
                if (self.person.Data.Weight) {
                    [dicM jk_setObj:[NSString stringWithFormat:@"%ld", (long)self.person.Data.Weight] forKey:@"content"];
                    if (self.person.Data.Weight <= 0) {
                        [dicM jk_setObj:@"" forKey:@"content"];
                    }
                }
            }
                break;
            case 3:
            {
                if (self.person.Data.Birthday.length && self.person.Data.Birthday) {
                    NSArray *arr = [self.person.Data.Birthday componentsSeparatedByString:@" "];
                    NSString *str = arr[0];
                    [dicM jk_setObj:str forKey:@"content"];
                } else {
                    
                    [dicM jk_setObj:@"1990-12-12" forKey:@"content"];
                    
                }

            }
                break;
                
            default:
                break;
        }
        
    }
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self.view endEditing:YES];
    
}
/*
修改完善个人信息
*/
- (void)pushEditInfoVC{
    [self.view endEditing:YES];
    _tableViewFooterView.enabled = NO;
    //这里处理
    [self bottomHealthReportButtonClick:self.tableViewFooterView];
    
    
}
//- (UIImage *)buttonBackBGColorWith:(NSArray *)colorArray {
//    NSMutableArray *colorArr = [[NSMutableArray alloc] init];
//    for (UIColor *color in colorArray) {
//        [colorArr addObject:(id)color.CGColor];
//    }
//    UIGraphicsBeginImageContextWithOptions(self.frame.size, YES, 1);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSaveGState(context);
//    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colorArray lastObject] CGColor]);
//    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)colorArr, NULL);
//    CGPoint start = CGPointZero;
//    CGPoint end = CGPointMake(self.frame.size.width, 0);
//    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    CGGradientRelease(gradient);
//    CGContextRestoreGState(context);
//    CGColorSpaceRelease(colorSpace);
//    UIGraphicsEndImageContext();
//    return image;
//}
#pragma mark -得到当前时间
- (NSDate *)getCurrentTime{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd-MM-yy"];
    NSString *dateTime=[formatter stringFromDate:[NSDate date]];
    NSDate *date = [formatter dateFromString:dateTime];
    
    NSLog(@"---------- currentDate == %@",date);
    return date;
}
/*
 3、最后进行比较，将现在的时间与指定时间比较，如果没达到指定日期，返回-1，刚好是这一时间，返回0，否则返回1*/
- (int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy-HHmmss"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    NSLog(@"date1 : %@, date2 : %@", oneDay, anotherDay);
    if (result == NSOrderedDescending) {
        //NSLog(@"Date1  is in the future");
        return 1;
    }
    else if (result == NSOrderedAscending){
        //NSLog(@"Date1 is in the past");
        return -1;
    }
    //NSLog(@"Both dates are the same");
    return 0;
    
}
@end
