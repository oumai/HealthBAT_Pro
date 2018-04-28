//
//  BATHealthyReportViewController.m
//  HealthBAT_Pro
//
//  Created by 黄帆 on 2017/12/16.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHealthyReportViewController.h"
#import "BATHealthyReportHeadTableViewCell.h"
#import "BATHealthyReportContentTableViewCell.h"
#import "BATPerson.h"
#import "BATHealthyDrugTableViewCell.h"
#import "BATHealthEvalutionServce.h"
#import "BATHealthyAssessModel.h"
#import "BATHealthyRecommendTableViewCell.h"
#import "BATHomeMallViewController.h"
static NSString *const HeadID = @"BATHealthyReportHeadTableViewCell";
static NSString *const ContentID = @"BATHealthyReportContentTableViewCell";
static NSString *const BuyCarID = @"BATHealthyDrugTableViewCell";
static NSString *const RecommendID = @"BATHealthyRecommendTableViewCell";
@interface BATHealthyReportViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)BATPerson *loginUserModel;
@property(nonatomic, strong) BATHealthyAssessModel *assessModel;

@property (nonatomic, strong) NSMutableArray *dataSource1;

@end

@implementation BATHealthyReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    NSArray *arr = @[ [@{@"title":@"饮食", @"image":@"diet_h", @"recommed":@"", @"assess":@""} mutableCopy],
                      [@{@"title":@"喝水", @"image":@"Drink water_h", @"recommed":@"", @"assess":@""} mutableCopy],
                       [@{@"title":@"运动", @"image":@"motion_h", @"recommed":@"", @"assess":@""} mutableCopy],
                       [@{@"title":@"睡眠", @"image":@"sleep_h", @"recommed":@"", @"assess":@""} mutableCopy],
                       [@{@"title":@"心情", @"image":@"mood_h", @"recommed":@"", @"assess":@""} mutableCopy]
                      ];
    _dataSource1 = [arr mutableCopy];
    
    [self registerCell];
    [self commonInit];
    
    [self NewWorkOfMine];
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);

    }];
    
}

#pragma mark - lazy load

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //        _tableView.tableFooterView = self.tableViewFooterView;
 
//        _tableView.estimatedSectionHeaderHeight = 0;
//        _tableView.estimatedSectionFooterHeight = 0;
        
        // 必须设置预估高度才能生效
        _tableView.estimatedRowHeight = 100;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _tableView;
}
#pragma mark - table

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    if (section == 0) {
        return 1;
    } else if (section == 1){
        return 5;
    } else {
        
        return 1;
        
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath; {
    
    if (indexPath.section == 0) {
        BATHealthyReportHeadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HeadID forIndexPath:indexPath];
        
        cell.assessModel = self.assessModel;
        cell.dateStr = self.date;
        cell.infoButtonBlock = ^{
            [self showText:@"体重指数=体重kg/身高m²"];
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    } else if (indexPath.section == 1){
        BATHealthyRecommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RecommendID forIndexPath:indexPath];
        cell.titleLab.text = _dataSource1[indexPath.row][@"title"];
        NSString *imageName = _dataSource1[indexPath.row][@"image"];
        cell.imageV.image = [UIImage imageNamed: imageName];
        
        if (indexPath.row < 4) {
            cell.AssessLab.text = [NSString stringWithFormat:@"评估：%@", _dataSource1[indexPath.row][@"assess"]];
            cell.AssessLab.attributedText = [self updeteOurBigWithTitle:@"评估：" andContent:_dataSource1[indexPath.row][@"assess"]];
            
            cell.RecommendLab.text = [NSString stringWithFormat:@"建议：%@", _dataSource1[indexPath.row][@"recommed"]];
            cell.RecommendLab.attributedText = [self updeteOurBigWithTitle:@"建议：" andContent:_dataSource1[indexPath.row][@"recommed"]];
        } else {
            
            cell.AssessLab.text = [NSString stringWithFormat:@"%@", _dataSource1[indexPath.row][@"assess"]];
            cell.AssessLab.attributedText = [self updeteOurBigWithTitle:@"" andContent:_dataSource1[indexPath.row][@"assess"]];
            
            cell.RecommendLab.text =  [NSString stringWithFormat:@"%@",_dataSource1[indexPath.row][@"recommed"]];
            
            cell.RecommendLab.attributedText = [self updeteOurBigWithTitle:@"" andContent:_dataSource1[indexPath.row][@"recommed"]];
//            cell.AssessLab.text = @"";
            
           
        }
       cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        
        BATHealthyDrugTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BuyCarID forIndexPath:indexPath];
        cell.assessModel = self.assessModel;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return 157;
    } else if (indexPath.section == 1){
        return UITableViewAutomaticDimension;
    } else {
        
        return 80;
        
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    
    return [[UIView alloc] initWithFrame:CGRectZero];

}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    

    if (section == 2) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 50)];
        view.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(10, 10, view.width - 20, 50);
        label.text = @"健康药品推荐：";
        label.font = [UIFont systemFontOfSize:14];
        [view addSubview:label];
        
        UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        view1.backgroundColor = RGB(240, 240, 240);
        [view addSubview:view1];
        
  
        
        return view;
    } else {
        return [[UIView alloc] initWithFrame:CGRectZero];

    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return 0.01;
    } else if(section == 2) {
        
        return 60;
    } else {
        
        return 10;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2) {
        
        BATHomeMallViewController *homeMallVC = [[BATHomeMallViewController alloc] init];
        homeMallVC.url = [NSString stringWithFormat:@"http://m.km1818.com/products/%@.html?kmCloud",self.assessModel.ReturnData.RecommendProduct.SKU_ID];
        homeMallVC.title = self.assessModel.ReturnData.RecommendProduct.PRODUCT_NAME;
        [self.navigationController pushViewController:homeMallVC animated:YES];
        
    }
    
}
#pragma mark - coustom
- (void)registerCell{

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BATHealthyReportHeadTableViewCell class]) bundle:nil] forCellReuseIdentifier:HeadID];
    
     [self.tableView registerClass:[BATHealthyReportContentTableViewCell class] forCellReuseIdentifier:ContentID];
    
     [self.tableView registerNib:[UINib nibWithNibName:@"BATHealthyDrugTableViewCell" bundle:nil] forCellReuseIdentifier:BuyCarID];
    
       [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BATHealthyRecommendTableViewCell class]) bundle:nil] forCellReuseIdentifier:RecommendID];
 
}
- (void)commonInit{
    self.title = @"健康报告";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    self.loginUserModel = PERSON_INFO;
}

- (void)NewWorkOfMine {
    BATHealthEvalutionServce *service = [[BATHealthEvalutionServce alloc] init];
    
    NSMutableDictionary *dicM = [NSMutableDictionary dictionary];
    NSArray *arr = [self.loginUserModel.Data.Birthday componentsSeparatedByString:@" "];
    NSString *str = arr[0];
    [dicM jk_setObj:str forKey:@"Birthday"];
    [dicM jk_setObj:[NSString stringWithFormat:@"%ld", (long)self.loginUserModel.Data.Height] forKey:@"Height"];
    [dicM jk_setObj:[NSString stringWithFormat:@"%ld", (long)self.loginUserModel.Data.Weight] forKey:@"Weight"];
    
    if (!self.Calory) {
        self.Calory = @"0";
    }
    if (!self.DrinkCupNum) {
        self.DrinkCupNum = @"3";
    }
    if (!self.SleepHour) {
        self.SleepHour = @"8";
    }
    if (!self.Steps) {
        self.Steps = @"2000";
    }
    [dicM jk_setObj:self.Calory forKey:@"Calory"];
    [dicM jk_setObj:self.DrinkCupNum forKey:@"DrinkCupNum"];
    [dicM jk_setObj:self.SleepHour forKey:@"SleepHour"];
    [dicM jk_setObj:self.Steps forKey:@"Steps"];
    [dicM jk_setObj:self.Mood forKey:@"Mood"];
    [service HealthyAssessWithParamters:dicM success:^(BATHealthyAssessModel *assModel) {
        self.assessModel = assModel;
    
        //dataSource也有更新
        [self updateDataSource];
        //tableView更新
        [self.tableView reloadData];
        
        
    } failure:^(NSError *error) {
        
        
        
    }];
}
- (void)updateDataSource {

//    for (int i = 0; i < _dataSource1.count; i++) {
//        NSMutableDictionary *dicM = _dataSource1[i];
//        NSArray *assessArrary = self.assessModel.ReturnData.DiagnosisList;
//        NSArray *suggestArr = self.assessModel.ReturnData.SuggestList;
//
//
//        if (i  < assessArrary.count) {
//            [dicM setObject:assessArrary[i] forKey:@"assess"];
//        }
//
//        if (i < suggestArr.count) {
//            [dicM setObject:suggestArr[i] forKey:@"recommed"];
//        }
//
//    }
     for (int i = 0; i < _dataSource1.count; i++) {
         
    
         
     NSMutableDictionary *dicM = _dataSource1[i];
         if (self.assessModel.ReturnData.EvaDetailList.count) {
             EvaDetailListData *data = self.assessModel.ReturnData.EvaDetailList[i];
             [dicM jk_setObj:data.Diagnosis forKey:@"assess"];
             [dicM jk_setObj:data.Suggest forKey:@"recommed"];
         }
        
     }
}

//富文本
- (NSMutableAttributedString *)updeteOurBigWithTitle:(NSString *)title andContent:(NSString *)content {
    
    NSString *strL = title;
    NSString *totalStr = [NSString stringWithFormat:@"%@%@",strL, content];
    NSMutableAttributedString *attrStr1 = [[NSMutableAttributedString alloc] initWithString:totalStr];
    [attrStr1 addAttribute:NSForegroundColorAttributeName
                     value:RGB(102, 102, 102)
                     range:NSMakeRange(strL.length, content.length)];
    
    [attrStr1 addAttribute:NSForegroundColorAttributeName
                     value:RGB(51, 51, 51)
                     range:NSMakeRange(0, strL.length)];
    return attrStr1;
}
@end

