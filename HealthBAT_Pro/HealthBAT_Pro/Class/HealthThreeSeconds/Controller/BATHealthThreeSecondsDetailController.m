//
//  BATHealthThreeSecondsDetailController.m
//  HealthBAT_Pro
//
//  Created by KM_MAC on 2017/12/15.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHealthThreeSecondsDetailController.h"
#import "BATHealthThreeSecondsFoodEnterController.h"
#import "BATHealthThreeSecondsCalendarController.h"
#import "BATHealthThreeSecondsController.h"
#import "BATEatSearchTwiceViewController.h"
#import "BATHealthyInfoViewController.h"
#import "BATHealthThreeSecondsController.h"
#import "BATHealthThreeSecondsFoodEnterCell.h"
#import "BATHealthThreeSecondsDetailListModel.h"

#import "BATPhotoPickHelper.h"
#import "TZImagePickerController.h"
#import "BATPerson.h"
#import "BATTableViewPlaceHolder.h"
#import "BATEmptyDataView.h"
#import "UIButton+TouchAreaInsets.h"
#import "BATHealthThreeSecondsDetailTopInfoView.h"
#import "BATHealthThreeSecondsTopChangeDateView.h"
#import "UINavigationController+FDFullscreenPopGesture.h"


static NSString *const FoodEnterCellID = @"BATHealthThreeSecondsFoodEnterCell";

@interface BATHealthThreeSecondsDetailController ()<UITableViewDelegate, BATTableViewPlaceHolderDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, TZImagePickerControllerDelegate, BATHealthThreeSecondsTopChangeDateViewDelegate>
@property (nonatomic, strong)BATPerson *loginUserModel;
@property (nonatomic, strong)UIButton *bottomAddButton;
@property (nonatomic, strong)NSMutableDictionary *backDictM;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UIView *tableHeadView;
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, assign)NSInteger pageSize;
@property (nonatomic, assign)NSInteger currentPage;
@property (nonatomic, assign)UIImage *selImage;
@property (nonatomic, assign)CGFloat CaloriesIntake;
/** 无数据占位 view */
@property (nonatomic,strong) BATEmptyDataView *emptyDataView;
@property (nonatomic, strong) BATHealthThreeSecondsDetailTopInfoView *foodDetailTopInfoView;

@end

@implementation BATHealthThreeSecondsDetailController
- (void)dealloc{
    DDLogDebug(@"====BATHealthThreeSecondsDetailController===dealloc");
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loginUserModel = PERSON_INFO;
    self.title = @"食物详情";
    [self.view addSubview:self.foodDetailTopInfoView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomAddButton];
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
    self.fd_interactivePopDisabled = NO;
    
    [self setupRefresh];
    [self setupNav];
    //获取当天摄入的卡路里总值
    [self loadCalorieValueRequestWithDate:self.date];
    //加载当前摄入的食物列表
    [self loadDataRequestWithDate:self.date];
    
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    [self.foodDetailTopInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.right.mas_equalTo(0);
        make.height.equalTo(@146);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.foodDetailTopInfoView.mas_bottom);
        make.left.right.mas_equalTo(0);
      make.bottom.mas_equalTo(self.bottomAddButton.mas_top).offset(-5);
    }];
    
    [self.bottomAddButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.mas_equalTo(0);
        make.height.equalTo(@58);
        
    }];
     
     
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [self postNotification];
    
}
- (void)setupNav{
    
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 15, 15)];
    //    backButton.backgroundColor = batRandomColor;
    backButton.touchAreaInsets = UIEdgeInsetsMake(20, 20, 20, 20);
    [backButton addTarget:self action:@selector(backButtonButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    backButton.imageView.contentMode = UIViewContentModeLeft;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    
}
/**
 点击返回按钮发送通知
 */
- (void)postNotification{
    
    //点击返回按钮,回到健康3秒钟主界面时,刷新数据
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ADDFOODSUCCESSREFRESHDATA" object:nil userInfo:@{@"date":self.date}];
    
}

#pragma mark - 占位视图

/**
 无数据占位 view
 */
- (UIView *)makePlaceHolderView{
    if (!_emptyDataView) {
        _emptyDataView = [[BATEmptyDataView alloc]initWithFrame:self.tableView.bounds];
        
        _emptyDataView.reloadRequestBlock = ^{
            
        };
        
    }
    return _emptyDataView;
    
}
#pragma mark - setupRefresh
/**
 集成刷新控件
 */
- (void)setupRefresh{
    
    self.tableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshRequest)];
    
    _currentPage = 0;
    _pageSize = 10;
    
}
/**
 尾部刷新调用
 */
- (void)footerRefreshRequest{
    _currentPage ++ ;
    
    [self.tableView.mj_header endRefreshing];
    [self loadDataRequestWithDate:self.date];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BATHealthThreeSecondsFoodEnterCell *cell = [tableView dequeueReusableCellWithIdentifier:FoodEnterCellID];
    cell.threeSecondsDetailListModel = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
//点击删除按钮
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self deleteFoodHistryDataRequest:indexPath];
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.tableHeadView;
}

#pragma mark  - BATHealthThreeSecondsTopChangeDateViewDelegate

- (void)leftButtonDidClick:(UIButton *)leftButton date:(NSString *)date{
    
    self.date = date;
    [self getCurrentDataRequestWithDate:date];
    
}
- (void)centerButtonDidClick:(UIButton *)centerButton callBackBlock:(void (^)(NSString *))callBackBlock{
    
    BATHealthThreeSecondsCalendarController *calendarVC = [[BATHealthThreeSecondsCalendarController alloc]init];
    calendarVC.selectedDateStr = self.date;
    
    calendarVC.backBlock = ^(NSString *selDate) {
        
        _date = selDate;
        
        callBackBlock(selDate);
        
        [self getCurrentDataRequestWithDate:selDate];
    };
    
    [self.navigationController pushViewController:calendarVC animated:YES];
    
}
- (void)rightButtonDidClick:(UIButton *)rightButton date:(NSString *)date{
     self.date = date;
    [self getCurrentDataRequestWithDate:date];
}

#pragma mark - Action

- (void)backButtonButtonClick{
    

    for (UIViewController *tempVC in self.navigationController.viewControllers) {
        
        if ([tempVC isKindOfClass:[BATHealthThreeSecondsController class]]) {
        
            {
                //点击返回按钮,回到健康3秒钟主界面时,刷新数据
                [self postNotification];
            
            [self.navigationController popToViewController:tempVC animated:YES];
            
        }
    }
    
    }
}
- (void)bottomAddButtonClick{
    
    [self showAlertViewController];
    
}


/**
 点击相机调用
 */
- (void)showAlertViewController{
    
    WeakSelf
    UIAlertController *alertSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //调用相机
        if (![BATPhotoPickHelper checkCameraAuthorizationStatus]) {
            return;
        }
        UIImagePickerController *pickerVc = [[UIImagePickerController alloc]init];
        pickerVc.delegate = weakSelf;
        pickerVc.sourceType =  UIImagePickerControllerSourceTypeCamera;
        [weakSelf presentViewController:pickerVc animated:YES completion:nil];
        
    }];
    
    
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //从相册选择
        [self choosePhoto];
        
    }];
    
    UIAlertAction *manualAction = [UIAlertAction actionWithTitle:@"手动" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //跳转到搜索界面
        BATEatSearchTwiceViewController *searchVc = [[BATEatSearchTwiceViewController alloc]init];
        searchVc.dateStr = self.date;
        [weakSelf.navigationController pushViewController:searchVc animated:YES];
        
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertSheet addAction:cameraAction];
    [alertSheet addAction:photoAction];
    [alertSheet addAction:manualAction];
    [alertSheet addAction:cancelAction];
    
    [self presentViewController:alertSheet animated:YES completion:nil];
    
    
}
/**
 进入食物录入界面
 */
- (void)pushFoodEnterVcWithImage:(UIImage *)selImage dateStr:(NSString *)dateStr{
    
    BATHealthThreeSecondsFoodEnterController *foodEnterVc = [[BATHealthThreeSecondsFoodEnterController alloc]initWithSelImage:selImage date:dateStr];
//    foodEnterVc.selImage = selImage;
//    foodEnterVc.dateStr = self.date;
    [self.navigationController pushViewController:foodEnterVc animated:YES];
    
}
/**
 从相册选择
 */
- (void)choosePhoto{
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePickerVc.photoWidth = SCREEN_WIDTH;
    imagePickerVc.allowPickingMultipleVideo = NO;
    // 你可以通过block或者代理，来得到用户选择的照片.
    WeakSelf
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
        //        weakSelf.selImage = photos.lastObject;
        
        [weakSelf pushFoodEnterVcWithImage:photos.lastObject dateStr:weakSelf.date];
        
        
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
    
}

/**
 跳转到日历控制器
 */
- (void)pushCalendarController{
    
    BATHealthThreeSecondsCalendarController *calendarVC = [[BATHealthThreeSecondsCalendarController alloc]init];
    calendarVC.backBlock = ^(NSString *selDate) {
        
          self.date = selDate;
        _date = selDate;
        [self getCurrentDataRequestWithDate:selDate];
    };
     [self.navigationController pushViewController:calendarVC animated:YES];
    
}
/*
 过去健康报告结果
- (NSString *)getReportResult{
    
    CGFloat height = self.loginUserModel.Data.Height;
    CGFloat weight = self.loginUserModel.Data.Weight;
    
    //标准卡路里
    CGFloat standCalorie = 0;
    
    if (height && weight) {
        //标准体重
        CGFloat standardWeight = ABS(105-height);
        //BMI=体重/ 身高²
        CGFloat BMI = weight / pow(height, 2);
        
        standCalorie =  BMI < 18.5 ? standardWeight * 35 :
                        BMI < 24   ? standardWeight * 30:
                        BMI < 28   ? standardWeight * 25 : standardWeight * 25;
        
        return  standCalorie * 1.1 < self.CaloriesIntake ? @"偏高" :
        standCalorie * 0.9 < self.CaloriesIntake &&  self.CaloriesIntake < standCalorie * 1.1 ?  @"适中" :
        standCalorie * 0.9 > self.CaloriesIntake ?  @"偏低" : @"";
 
    }
    
    
    return @"暂无法评估";
    
}
*/

#pragma mark - Request
#pragma mark - 获取推荐数据

/**
 获取当日添加的食物列表
 */
- (void)loadDataRequestWithDate:(NSString *)date{
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    dictM[@"date"] = date;
    dictM[@"pageSize"] = @(_pageSize);;
    dictM[@"pageIndex"] = @(_currentPage);;
    
    WeakSelf
    [HTTPTool requestWithURLString:@"api/EatCircle/GetDietDetails" parameters:dictM type:kGET success:^(id responseObject) {
        
        
        [weakSelf.tableView.mj_footer endRefreshing];
        
        if (_currentPage == 0) {
            [weakSelf.dataSource removeAllObjects];
        }
        
        //DDLogDebug(@"---------%@",responseObject);
        
        NSArray *moreData =  [BATHealthThreeSecondsDetailListModel mj_objectArrayWithKeyValuesArray:responseObject[@"Data"]];
        
        [weakSelf.dataSource addObjectsFromArray:moreData];
        
        if (moreData.count < _pageSize) {
            [weakSelf.tableView.mj_footer setHidden:YES];
        }else{
            [weakSelf.tableView.mj_footer setHidden:NO];
        }
        
        [weakSelf.tableView bat_reloadData];
        
        
        
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_footer endRefreshing];
        //请求失败显示占位视图
        [weakSelf.tableView bat_reloadData];
        
    }];
    
}

/**
 获取当日摄入的卡路里总数
 */
- (void)loadCalorieValueRequestWithDate:(NSString *)data{
    
    //组装参数
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    dictM[@"Data.AccountID"] = @(self.loginUserModel.Data.AccountID);
    dictM[@"date"] = data;

    [HTTPTool requestWithURLString:@"api/EatCircle/GetHealthData" parameters:dictM type:kGET success:^(id responseObject) {
        
        DDLogDebug(@"==============%@",responseObject);
        _CaloriesIntake =  [[responseObject[@"Data"] objectForKey:@"CaloriesIntake"] floatValue];
        _foodDetailTopInfoView.calorieValue = _CaloriesIntake;


        
    } failure:^(NSError *error) {
        
        //        DDLogDebug(@"---------%@",error);
    }];
    
}


#pragma mark - 删除当天摄入的食物

- (void)deleteFoodHistryDataRequest:(NSIndexPath *)indexPath{
    
    BATHealthThreeSecondsDetailListModel *programModel = self.dataSource[indexPath.row];
    
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    dictM[@"id"] = programModel.ID;
    WeakSelf
    [HTTPTool requestWithURLString:@"api/EatCircle/RemoveDietDetails" parameters:dictM type:kGET success:^(id responseObject) {
        
        //        DDLogDebug(@"%@----",responseObject);
        
        if ([responseObject[@"ResultMessage"] isEqualToString:@"删除成功"]) {
            
            [weakSelf.dataSource removeObjectAtIndex:indexPath.row];
            
            
            [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            if (!weakSelf.dataSource.count) {
                weakSelf.tableView.tableFooterView.hidden = YES;
                [weakSelf.tableView bat_reloadData];
                
            }
            
        }
    } failure:^(NSError *error) {
        [self showErrorWithText:@"请检查网络"];
    }];
    
    
}
/**
 获取当前时间数据
 */
- (void)getCurrentDataRequestWithDate:(NSString *)date{
    
    [self.dataSource removeAllObjects];
    self.date = date;
    [self loadCalorieValueRequestWithDate:date];
    [self loadDataRequestWithDate:date];
    
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    // 选取完图片后跳转回原控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    // 从info中将图片取出，并加载到imageView当中
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.selImage = image;
    // 创建保存图像时需要传入的选择器对象（回调方法格式固定）
    SEL selectorToCall = @selector(image:didFinishSavingWithError:contextInfo:);
    // 将图像保存到相册（第三个参数需要传入上面格式的选择器对象）
    UIImageWriteToSavedPhotosAlbum(image, self, selectorToCall, NULL);
    
}
// 保存图片后到相册后，回调的相关方法，查看是否保存成功
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error == nil){
        NSLog(@"%@-------=======",contextInfo);
        //保存照片成功后重新加载数据
        [self pushFoodEnterVcWithImage:image dateStr:self.date];
        
    } else {
        NSLog(@"保存照片失败");
    }
}
- (NSString *)dateConverStr{
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    return  [formatter stringFromDate:date];
}
#pragma mark - lazy load
- (BATHealthThreeSecondsDetailTopInfoView *)foodDetailTopInfoView{
    if (!_foodDetailTopInfoView) {
        _foodDetailTopInfoView = [[BATHealthThreeSecondsDetailTopInfoView alloc]init];
        _foodDetailTopInfoView.topChangeDateVieW.delegate = self;
        _foodDetailTopInfoView.backgroundColor = [UIColor whiteColor];
        _foodDetailTopInfoView.topChangeDateVieW.defauDateStr = self.date;
        WeakSelf
        _foodDetailTopInfoView.editButtonBlock = ^{
            BATHealthyInfoViewController *infoVc = [[BATHealthyInfoViewController alloc]init];
            [weakSelf.navigationController pushViewController:infoVc animated:YES];
            
        };
    }
    return _foodDetailTopInfoView;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 175*0.5;
        //        _tableView.tableHeaderView = self.tableHeadView;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BATHealthThreeSecondsFoodEnterCell class]) bundle:nil] forCellReuseIdentifier:FoodEnterCellID];
    }
    return _tableView;
}
- (UIView *)tableHeadView{
    if (!_tableHeadView) {
        _tableHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        _tableHeadView.backgroundColor = UIColorFromHEX(0xf5f5f5, 1);
        
        UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 40)];
        contentView.backgroundColor = [UIColor whiteColor];
        
        UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-10, 20)];
        
        textLabel.textColor = [UIColor blackColor];
        textLabel.font = [UIFont boldSystemFontOfSize:16];
        textLabel.text = @"食物列表";
        
        [contentView addSubview:textLabel];
        [_tableHeadView addSubview:contentView];
        
    }
    return _tableHeadView;
}

- (UIButton *)bottomAddButton{
    if (!_bottomAddButton) {
        _bottomAddButton = [[UIButton alloc]init];
        _bottomAddButton.backgroundColor = UIColorFromHEX(0x6ccc56, 1);
        [_bottomAddButton setTitle:@"添加食物" forState:UIControlStateNormal];
        [_bottomAddButton addTarget:self action:@selector(bottomAddButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _bottomAddButton;
}
- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        
    }
    return _dataSource;
}
- (NSMutableDictionary *)backDictM{
    if (!_backDictM) {
        _backDictM = [NSMutableDictionary dictionary];
    }
    return _backDictM;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
